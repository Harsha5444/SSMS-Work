CREATE PROCEDURE [dbo].[USP_GetStudentAssessmentAttendanceCourseDetailsAllYears] @DistrictStudentId NVARCHAR(50)
	,@TenantId INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @CurrentSchoolYear VARCHAR(10);
	DECLARE @FinalResult NVARCHAR(MAX);
	DECLARE @YearlyResults NVARCHAR(MAX) = '{}';
	DECLARE @YearData NVARCHAR(MAX);
	DECLARE @SchoolYear VARCHAR(10);

	-- Get the current school year
	SELECT @CurrentSchoolYear = MAX(schoolyear)
	FROM AggRptK12StudentDetails
	WHERE tenantid = @TenantId;

	BEGIN TRY
		BEGIN TRANSACTION

		-- Get all distinct school years for this student
		DECLARE year_cursor CURSOR
		FOR
		SELECT DISTINCT schoolyear
		FROM AggRptK12StudentDetails
		WHERE DistrictStudentId = @DistrictStudentId
			AND tenantid = @TenantId
		ORDER BY schoolyear DESC;

		OPEN year_cursor;

		FETCH NEXT
		FROM year_cursor
		INTO @SchoolYear;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			DECLARE @AssessmentResults NVARCHAR(MAX);
			DECLARE @AttendanceResults NVARCHAR(MAX);
			DECLARE @IncidentResults NVARCHAR(MAX);
			DECLARE @CourseResults NVARCHAR(MAX);

			-- Get assessment data as JSON for specific year
			SELECT @AssessmentResults = (
					SELECT a.AssessmentCode AS AssessmentName
						,a.SubjectAreaCode AS [Subject]
						,ISNULL(a.GradeCode, 'Unknown') AS Grade
						,ISNULL(MAX(a.[ScaleScore]), 0) AS [ScaleScore]
					FROM (
						SELECT [SchoolYear]
							,[AssessmentCode]
							,[SubjectAreaCode]
							,[Districtstudentid]
							,[GradeCode]
							,[GradeDescription]
							,[ScaleScore]
							,tenantid
						FROM (
							SELECT *
							FROM (
								SELECT h.SchoolYear
									,p.AssessmentCode
									,p.SubjectAreaCode
									,h.Districtstudentid
									,g.GradeCode
									,g.GradeDescription
									,h.MetricValue AS [ScaleScore]
									,ROW_NUMBER() OVER (
										PARTITION BY p.AssessmentCode
										,p.SubjectAreaCode
										,h.StudentCurrentGradeId
										,h.termid
										,h.Districtstudentid ORDER BY h.MetricValue DESC
											,h.SchoolYear DESC
											,CAST(h.TestTakenDate AS DATE) DESC
										) AS RN
									,h.tenantid
								FROM main.k12studentgenericassessment h
								INNER JOIN main.assessmentdetails p ON h.AssessmentCodeId = p.assessmentdetailsid
									AND h.schoolyear = p.schoolyear
								INNER JOIN RefGrade g ON g.gradeid = h.StudentCurrentGradeId
								INNER JOIN refmetric o ON o.metricid = h.MetricCodeId
								WHERE MetricCodeId IN (
										SELECT metricid
										FROM refmetric
										WHERE tenantid = @TenantId
											AND MetricDescription = 'Scale Score'
										)
									AND h.Schoolyear = @SchoolYear
									AND h.Districtstudentid = @DistrictStudentId
									AND h.tenantid = @TenantId
								) t
							WHERE RN = 1
							) o
						) a
					GROUP BY a.SchoolYear
						,a.Districtstudentid
						,a.AssessmentCode
						,a.SubjectAreaCode
						,a.GradeCode
						,A.TenantId
					FOR JSON PATH
					);

			-- Get attendance data as JSON for specific year
			SELECT @AttendanceResults = (
					SELECT FORMAT(ROUND(CAST(daysPresent AS FLOAT) * 100.0 / scheduledDays, 2), 'N2') AS [Attendance Rate]
					FROM (
						SELECT studentFullName
							,DistrictStudentId AS studentnumber
							,schoolyear AS endyear
							,SUM(PresentDaysCount) AS daysPresent
							,SUM(MembershipDaysCount) AS scheduledDays
							,IsChronic AS chronicallyAbsent
							,race AS raceEthnicity
							,gender AS genderLong
							,SpecialEdStatus AS swdindicator
							,ROW_NUMBER() OVER (
								PARTITION BY DistrictStudentId
								,schoolyear ORDER BY PresentDaysCount DESC
								) AS rn
							,tenantid
						FROM [dbo].[AggRptK12StudentDetails]
						WHERE DistrictStudentId = @DistrictStudentId
							AND tenantid = @TenantId
							AND Schoolyear = @SchoolYear
						GROUP BY StudentFullName
							,DistrictStudentId
							,schoolyear
							,PresentDaysCount
							,MembershipDaysCount
							,IsChronic
							,race
							,gender
							,SpecialEdStatus
							,tenantid
						) y
					WHERE rn = 1
						AND daysPresent <> 0
					FOR JSON PATH
					);

			-- Get incident data as JSON for specific year
			SELECT @IncidentResults = (
					SELECT ISNULL(COUNT(incidentnumber), 0) AS BehavioralIncidents
					FROM [dbo].[DisciplineIncidentCountsDS]
					WHERE DistrictStudentId = @DistrictStudentId
						AND TenantId = @TenantId
						AND SchoolYear = @SchoolYear
					FOR JSON PATH
					);

			-- Get course data as JSON for specific year
			SELECT @CourseResults = (
					SELECT DISTINCT CourseTitle AS Course
						,LetterGrade
					FROM [dbo].StudentLevelCourseGradesDataSet
					WHERE DistrictStudentId = @DistrictStudentId
						AND TenantId = @TenantId
						AND SchoolYear = @SchoolYear
					FOR JSON PATH
					);

			-- Combine all JSON results for this year into a single JSON object
			SET @YearData = JSON_MODIFY(JSON_MODIFY(JSON_MODIFY(JSON_MODIFY('{}', '$.Assessments', JSON_QUERY(ISNULL(@AssessmentResults, '[]'))), '$.Attendance', JSON_QUERY(ISNULL(@AttendanceResults, '[]'))), '$.BehavioralIncidents', JSON_QUERY(ISNULL(@IncidentResults, '[]'))), '$.Courses', JSON_QUERY(ISNULL(@CourseResults, '[]')));

			-- Add this year's data to the overall result
			IF @SchoolYear = @CurrentSchoolYear
			BEGIN
				SET @YearlyResults = JSON_MODIFY(@YearlyResults, '$.currentYear', JSON_QUERY(@YearData));
			END
			ELSE
			BEGIN
				-- For previous years, create a nested structure
				IF JSON_VALUE(@YearlyResults, '$.previousYears') IS NULL
				BEGIN
					SET @YearlyResults = JSON_MODIFY(@YearlyResults, '$.previousYears', JSON_QUERY('{}'));
				END

				DECLARE @YearPath NVARCHAR(50) = '$.previousYears."' + @SchoolYear + '"';

				SET @YearlyResults = JSON_MODIFY(@YearlyResults, @YearPath, JSON_QUERY(@YearData));
			END

			FETCH NEXT
			FROM year_cursor
			INTO @SchoolYear;
		END

		CLOSE year_cursor;

		DEALLOCATE year_cursor;

		-- Return the combined JSON result
		SELECT @YearlyResults AS JsonResult;

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		IF CURSOR_STATUS('global', 'year_cursor') >= - 1
		BEGIN
			CLOSE year_cursor;

			DEALLOCATE year_cursor;
		END

		IF XACT_STATE() = - 1
		BEGIN
			ROLLBACK TRANSACTION
		END

		DECLARE @ErrorFromProc VARCHAR(500);
		DECLARE @ProcErrorMessage VARCHAR(1000);
		DECLARE @SeverityLevel INT;

		SELECT @ErrorFromProc = '[dbo].[USP_GetStudentAssessmentAttendanceCourseDetailsAllYears]'
			,@ProcErrorMessage = ERROR_MESSAGE()
			,@SeverityLevel = ERROR_SEVERITY();

		INSERT INTO dbo.[errorlogforusp] (
			ErrorFromProc
			,errormessage
			,severitylevel
			,datetimestamp
			,TenantId
			)
		VALUES (
			@ErrorFromProc
			,@ProcErrorMessage
			,@SeverityLevel
			,GETDATE()
			,@TenantId
			);

		-- Return error information as JSON
		SELECT JSON_MODIFY('{}', '$.error', @ProcErrorMessage) AS JsonResult;
	END CATCH
END
GO


