CREATE PROCEDURE [dbo].[usp_GetStudentAssessmentData] @DistrictStudentIds VARCHAR(MAX)
	,@Tenantid INT
AS
BEGIN
	SET NOCOUNT ON;

	WITH LatestTests
	AS (
		SELECT a.DistrictStudentId
			,a.SchoolYear
			,b.AssessmentName
			,b.SubjectAreaName
			,b.StrandAreaName
			,a.TestTakenDate
			,a.TenantId
			,ROW_NUMBER() OVER (
				PARTITION BY a.DistrictStudentId
				,b.AssessmentName
				,b.SubjectAreaName
				,b.StrandAreaName
				,a.SchoolYear ORDER BY a.TestTakenDate DESC
				) AS RowNum
		FROM Main.K12StudentGenericAssessment a WITH (NOLOCK)
		INNER JOIN Main.AssessmentDetails b WITH (NOLOCK) ON a.AssessmentCodeId = b.AssessmentDetailsid
			AND a.TenantId = b.TenantId
		WHERE a.TenantId = @tenantid
			AND b.AssessmentCode = 'i-Ready'
			AND b.StrandAreaName IS NOT NULL
			AND a.DistrictStudentId IN (
				SELECT Value
				FROM string_split(@DistrictStudentIds, ',')
				)
		)
		,LatestMetricValues
	AS (
		SELECT a.DistrictStudentId
			,a.SchoolYear
			,b.AssessmentName
			,b.SubjectAreaName
			,a.MetricValue
			,a.TenantId
			,ROW_NUMBER() OVER (
				PARTITION BY a.DistrictStudentId
				,b.AssessmentName
				,b.SubjectAreaName
				,a.SchoolYear ORDER BY a.TestTakenDate DESC
				) AS RowNum
		FROM Main.K12StudentGenericAssessment a WITH (NOLOCK)
		INNER JOIN Main.AssessmentDetails b WITH (NOLOCK) ON a.AssessmentCodeId = b.AssessmentDetailsid
			AND a.TenantId = b.TenantId
		WHERE a.TenantId = @tenantid
			AND a.DistrictStudentId IN (
				SELECT Value
				FROM string_split(@DistrictStudentIds, ',')
				)
			AND b.AssessmentCode = 'i-Ready'
			AND b.StrandAreaName IS NULL
			AND MetricCodeId IN (
				SELECT MetricId
				FROM RefMetric
				WHERE tenantid = @tenantid
					AND MetricDescription = 'tier'
				)
		)
	SELECT j.Schoolyear
		,j.DistrictStudentId
		,s.StudentFullName
		,s.Grade
		,j.AssessmentName
		,j.SubjectAreaName
		,j.StrandAreaName
		,ISNULL(k.MetricValue, tier.TierLabel) AS MetricValue
		,j.TenantId
		,ISNULL(COUNT(DISTINCT c.IncidentNumber), 0) AS TotalIncidents
	FROM (
		SELECT DistrictStudentId
			,SchoolYear
			,AssessmentName
			,SubjectAreaName
			,StrandAreaName
			,TenantId
		FROM LatestTests
		WHERE RowNum = 1
		) j
	LEFT JOIN (
		SELECT DistrictStudentId
			,SchoolYear
			,AssessmentName
			,SubjectAreaName
			,MetricValue
			,TenantId
		FROM LatestMetricValues
		WHERE RowNum = 1
		) k ON j.DistrictStudentId = k.DistrictStudentId
		AND j.SchoolYear = k.SchoolYear
		AND j.AssessmentName = k.AssessmentName
		AND j.SubjectAreaName = k.SubjectAreaName
	INNER JOIN AggRptK12StudentDetails s WITH (NOLOCK) ON j.DistrictStudentId = s.DistrictStudentId
		AND j.SchoolYear = s.SchoolYear
	LEFT JOIN DisciplineIncidentCountsDS c ON j.SchoolYear = c.schoolYear
		AND j.DistrictStudentId = c.DistrictStudentId
	OUTER APPLY (
		SELECT TierLabel
		FROM (
			VALUES ('Tier1')
				,('Tier2')
				,('Tier3')
			) AS TierList(TierLabel)
		WHERE k.MetricValue IS NULL
		) tier
	WHERE 1 = 1
		AND j.TenantId = @tenantid
		AND j.Schoolyear IN (
			SELECT max(latestschoolyear)
			FROM assessmentinfo
			WHERE assessment = 'i-Ready'
				AND tenantid = @tenantid
			)
	GROUP BY j.Schoolyear
		,j.DistrictStudentId
		,s.StudentFullName
		,s.Grade
		,j.AssessmentName
		,j.SubjectAreaName
		,j.StrandAreaName
		,ISNULL(k.MetricValue, tier.TierLabel)
		,j.TenantId
END
GO

CREATE PROCEDURE [dbo].[USP_GetStrandsByGradeAndSubject] @Grade VARCHAR(max)
	,@Subject VARCHAR(max)
	,@TenantId INT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT DISTINCT Strand
		FROM StandardDetails
		WHERE Grade = @Grade
			AND Subject = @Subject
			AND StatusId = 1
			AND TenantId = @TenantId
	END TRY

	BEGIN CATCH
		IF XACT_STATE() = - 1
		BEGIN
			ROLLBACK TRANSACTION
		END

		DECLARE @ErrorFromProc VARCHAR(500)
		DECLARE @ProcErrorMessage VARCHAR(1000)
		DECLARE @SeverityLevel INT

		SELECT @ErrorFromProc = '[dbo].[USP_GetStrandsByGradeAndSubject]'
			,@ProcErrorMessage = Error_message() + ' ; Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + ' ; Error State: ' + CAST(ERROR_STATE() AS VARCHAR(10)) + ' ; Error Line: ' + CAST(ERROR_LINE() AS VARCHAR(10))
			,@SeverityLevel = Error_severity()

		INSERT INTO [dbo].[errorlogforusp] (
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
			,Getdate()
			,@TenantId
			)
	END CATCH
END
GO

CREATE PROCEDURE [dbo].[USP_GetStandardsByStrand] @Strand VARCHAR(max)
	,@Grade VARCHAR(max)
	,@Subject VARCHAR(max)
	,@TenantId INT
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		SELECT StandardId
			,Standard
			,Description
			,Grade
			,Subject
			,Objective
		FROM StandardDetails
		WHERE Strand = @Strand
			AND Grade = @Grade
			AND Subject = @Subject
			AND StatusId = 1
			AND TenantId = @TenantId
	END TRY

	BEGIN CATCH
		IF XACT_STATE() = - 1
		BEGIN
			ROLLBACK TRANSACTION
		END

		DECLARE @ErrorFromProc VARCHAR(500)
		DECLARE @ProcErrorMessage VARCHAR(1000)
		DECLARE @SeverityLevel INT

		SELECT @ErrorFromProc = '[dbo].[USP_GetStandardsByStrand]'
			,@ProcErrorMessage = Error_message() + ' ; Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + ' ; Error State: ' + CAST(ERROR_STATE() AS VARCHAR(10)) + ' ; Error Line: ' + CAST(ERROR_LINE() AS VARCHAR(10))
			,@SeverityLevel = Error_severity()

		INSERT INTO [dbo].[errorlogforusp] (
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
			,Getdate()
			,@TenantId
			)
	END CATCH
END
GO

CREATE PROCEDURE [dbo].[USP_GetPromptByName] (
	@Name VARCHAR(Max)
	,@Tenantid INT
	,@UserId BIGINT
	)
AS
BEGIN
	BEGIN TRY
		IF EXISTS (
				SELECT 1
				FROM Prompts
				WHERE Name = @Name
					AND TenantId = @TenantId
					AND UserId = @UserId
				)
		BEGIN
			SELECT PromptText
			FROM Prompts
			WHERE Name = @Name
				AND TenantId = @Tenantid
				AND UserId = @UserId
		END
		ELSE
		BEGIN
			SELECT PromptText
			FROM Prompts
			WHERE Name = @Name
		END
	END TRY

	BEGIN CATCH
		DECLARE @ErrorFromProc VARCHAR(500)
		DECLARE @ErrorMessage VARCHAR(1000)
		DECLARE @SeverityLevel INT

		SELECT @ErrorFromProc = '[dbo].[USP_GetPromptByName]'
			,@ErrorMessage = ERROR_MESSAGE()
			,@SeverityLevel = ERROR_SEVERITY()

		INSERT INTO [dbo].[ErrorLogForUSP] (
			ErrorFromProc
			,ErrorMessage
			,SeverityLevel
			,DateTimeStamp
			)
		VALUES (
			@ErrorFromProc
			,@ErrorMessage
			,@SeverityLevel
			,GETDATE()
			);

		THROW;
	END CATCH
END
GO

CREATE PROCEDURE [dbo].[USP_SaveOrUpdatePrompt] @Name VARCHAR(MAX)
	,@PromptText VARCHAR(MAX)
	,@TenantId INT
	,@UserId INT
	,@UserName VARCHAR(MAX)
AS
BEGIN
	BEGIN TRY
		DECLARE @Description VARCHAR(MAX)

		SELECT @Description = description
		FROM PROMPTS
		WHERE Name = @Name

		IF EXISTS (
				SELECT 1
				FROM Prompts
				WHERE Name = @Name
					AND UserId = @UserId
					AND TenantId = @TenantId
				)
		BEGIN
			-- Update existing record
			UPDATE Prompts
			SET PromptText = @PromptText
				,Description = @Description
				,ModifiedBy = @UserName
				,ModifiedDate = GETDATE()
			WHERE Name = @Name
				AND UserId = @UserId
				AND TenantId = @TenantId
		END
		ELSE
		BEGIN
			-- Insert new record
			INSERT INTO Prompts (
				Name
				,PromptText
				,Description
				,TenantId
				,UserId
				,CreatedBy
				,CreatedDate
				,ModifiedBy
				,ModifiedDate
				,StatusId
				)
			VALUES (
				@Name
				,@PromptText
				,@Description
				,@TenantId
				,@UserId
				,@UserName
				,GETDATE()
				,NULL
				,NULL
				,1
				)
		END
	END TRY

	BEGIN CATCH
		DECLARE @ErrorFromProc VARCHAR(500)
		DECLARE @ErrorMessage VARCHAR(1000)
		DECLARE @SeverityLevel INT

		SELECT @ErrorFromProc = '[dbo].[USP_SaveOrUpdatePrompt]'
			,@ErrorMessage = ERROR_MESSAGE()
			,@SeverityLevel = ERROR_SEVERITY()

		INSERT INTO [dbo].[ErrorLogForUSP] (
			ErrorFromProc
			,ErrorMessage
			,SeverityLevel
			,DateTimeStamp
			)
		VALUES (
			@ErrorFromProc
			,@ErrorMessage
			,@SeverityLevel
			,GETDATE()
			);

		THROW;
	END CATCH
END
GO

CREATE PROCEDURE [dbo].[RITPrediction] @Districtstudentid VARCHAR(max)
	,@Tenantid INT
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	BEGIN TRY
		WITH AssessmentData
		AS (
			SELECT a.SchoolYear
				,a.DistrictStudentid
				,ad.AssessmentName
				,ad.SubjectAreaName
				,rt.TermDescription
				,rt.SortOrder AS TermSortOrder
				,m.MetricName
				,isnull(a.MetricValue, 0) AS MetricValue
				,a.TestTakenDate
				,a.TenantId
				,ROW_NUMBER() OVER (
					PARTITION BY a.SchoolYear
					,a.DistrictStudentId
					,ad.AssessmentName
					,ad.SubjectAreaName
					,rt.TermDescription
					,m.MetricName ORDER BY a.TestTakenDate DESC
					) AS Rn
			FROM main.K12StudentGenericAssessment a
			INNER JOIN main.AssessmentDetails ad ON ad.AssessmentDetailsId = a.AssessmentCodeId
				AND ad.SchoolYear = a.SchoolYear
				AND ad.TenantId = a.TenantId
			INNER JOIN dbo.RefMetric m ON m.TenantId = a.TenantId
				AND m.MetricId = a.MetricCodeId
			LEFT JOIN dbo.RefTerm rt ON rt.TermId = a.TermID
				AND rt.TenantId = a.TenantId
				AND rt.SchoolYear = a.SchoolYear
			WHERE 1 = 1
				AND a.TenantId = @Tenantid
				AND a.DistrictStudentId IN (
					SELECT Value
					FROM string_split(@DistrictStudentId, ',')
					)
				AND ad.AssessmentCode LIKE '%map%'
				AND ad.StrandAreaCode IS NULL
				AND m.MetricDescription IN ('RIT Score', 'Percentile Rank', 'Scale Score')
			)
		SELECT ad.SchoolYear
			,ad.DistrictStudentid
			,b.StudentFullName
			,ad.AssessmentName
			,ad.SubjectAreaName
			,b.GradeCode
			,ad.TermDescription AS Term
			--,cast(isnull(MAX(CASE WHEN ad.MetricName = 'Scale Score' THEN ad.MetricValue END),0) as int) AS PreviousScaleScore
			,CAST(ISNULL(COALESCE(MAX(CASE 
								WHEN ad.MetricName = 'RIT Score'
									THEN ad.MetricValue
								END), MAX(CASE 
								WHEN ad.MetricName = 'Scale Score'
									THEN ad.MetricValue
								END)), 0) AS INT) AS PreviousRITScore
			,cast(isnull(MAX(CASE 
							WHEN ad.MetricName = 'Percentile Rank'
								THEN ad.MetricValue
							END), 0) AS INT) AS PercentileRank
			,ISNULL(TRY_CAST(ROUND(TRY_CAST(b.PresentRate AS FLOAT), 2) AS FLOAT), 0) AS PresentPercentage
			,CAST(b.IsChronic AS VARCHAR) AS ChronicallyAbsent
			,b.Race
			,b.Gender
			,b.DisabilityStatus AS Disability
			,b.FRL
			,COUNT(ISNULL(c.IncidentNumber, 0)) AS TotalIncidents
			,CASE 
				WHEN ad.TermDescription = 'Fall'
					THEN 'Winter (' + CAST(ad.SchoolYear AS VARCHAR) + ')'
				WHEN ad.TermDescription = 'Winter'
					THEN 'Spring (' + CAST(ad.SchoolYear AS VARCHAR) + ')'
				WHEN ad.TermDescription = 'Spring'
					THEN 'Fall (' + CAST(ad.SchoolYear + 1 AS VARCHAR) + ')'
				ELSE 'Unknown'
				END AS NextTerm
		FROM AssessmentData ad
		INNER JOIN aggrptk12studentdetails b ON ad.SchoolYear = b.SchoolYear
			AND ad.DistrictStudentId = b.DistrictStudentId
			AND b.TenantId = ad.TenantId
		LEFT JOIN DisciplineIncidentCountsDS c ON ad.SchoolYear = c.SchoolYear
			AND ad.DistrictStudentId = c.DistrictStudentId
			AND c.TenantId = ad.TenantId
		WHERE Rn = 1
		GROUP BY ad.SchoolYear
			,ad.DistrictStudentId
			,b.StudentFullName
			,ad.AssessmentName
			,ad.SubjectAreaName
			,b.GradeCode
			,ad.TermDescription
			,ad.TermSortOrder
			,ad.TestTakenDate
			,b.IsChronic
			,b.Race
			,b.Gender
			,b.DisabilityStatus
			,b.FRL
			,b.PresentRate
		ORDER BY ad.SchoolYear DESC
			,ad.DistrictStudentId DESC
			,ad.TermSortOrder DESC;
	END TRY

	BEGIN CATCH
		DECLARE @ErrorFromProc VARCHAR(500)
		DECLARE @ProcErrorMessage VARCHAR(1000)
		DECLARE @SeverityLevel INT

		SELECT @ErrorFromProc = '[dbo].[RITPrediction]'
			,@ProcErrorMessage = Error_message()
			,@SeverityLevel = Error_severity()

		INSERT INTO [dbo].[errorlogforusp] (
			ErrorFromProc
			,errormessage
			,severitylevel
			,datetimestamp
			)
		VALUES (
			@ErrorFromProc
			,@ProcErrorMessage
			,@SeverityLevel
			,Getdate()
			)
	END CATCH
END
GO


