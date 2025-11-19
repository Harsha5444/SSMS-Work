Create PROCEDURE [USP_WHPS_PAT_LevelMovement_Loading] @SchoolYear VARCHAR(10) = NULL
	,@TenantId INT = 38
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN TRANSACTION

		DECLARE @StartTime DATETIME2;
		DECLARE @EndTime DATETIME2;
		DECLARE @TotalRowsInserted INT = 0;
		DECLARE @TableRowsBefore INT;
		DECLARE @TableRowsAfter INT;
		DECLARE @ProcessName NVARCHAR(200);
		DECLARE @ElapsedTime INT;

		SELECT @SchoolYear = (
				SELECT max(yearcode)
				FROM RefYear
				WHERE Tenantid = 38
				);
		
		---===============================================================================================
		---===============================================================================================
		---===============================================================================================
		SET @ProcessName = '[WHPS_PATStandards]';
		SET @StartTime = CAST(SYSDATETIME() AS DATETIME);

		SELECT @TableRowsBefore = COUNT(*)
		FROM [WHPS_PATStandards];

		TRUNCATE TABLE [WHPS_PATStandards];

		--insert into WHPS_PATStandards (view -> WHPS_PATStandards_Vw)
		WITH AggSt
		AS (
			SELECT agg.SchoolYear
				,agg.SchoolCategory
				,agg.SchoolIdentifier
				,agg.SchoolName
				,agg.DistrictStudentId
				,agg.StudentFullName AS StudentName
				,agg.Grade
				,agg.GradeCode
				,agg.Gender
				,agg.Race
				,agg.MembershipDaysCount
				,agg.PresentDaysCount
				,agg.AbsentDaysCount
				,IsNull(CASE 
						WHEN agg.IsChronic = 1
							THEN 'Yes'
						WHEN agg.IsChronic = 0
							THEN 'No'
						END, 'No') AS IsChronic
				,agg.AbsentPercentage
				,agg.Presentrate
				,agg.AbsentRate
				,agg.CurrentMonthAttendance
				,agg.ELL
				,agg.SpecialEdStatus
				,agg.[504Status]
				,isnull(agg.IEP, 'No') AS IEP
				,agg.TenantId
			FROM AggRptK12StudentDetails agg
			WHERE agg.Tenantid = 38
				AND agg.SchoolYear = @SchoolYear
			)
			,WHPS_PAT_StudentStandards
		AS (
			--before used this [Main.WHPS_StudentStandards] replaced with cte
			SELECT DISTINCT wss.[SchoolId] AS [SchoolId]
				,wss.[identifier] AS [identifier]
				,wss.[name] AS [name]
				,wss.[parentstandardid] AS [parentstandardid]
				,wss.[parentstandardid_nvl] AS [parentstandardid_nvl]
				,wss.[standardgrade]
				,wss.[standardid] AS [standardid]
				,wss.[storecode]
				,wss.[student_number] AS [student_number]
				,wss.[studentid] AS [studentid]
				,wss.[studentsdcid] AS [studentsdcid]
				,wss.[SchoolYear] AS [SchoolYear]
				,wss.TenantId
			FROM Main.WHPS_StudentStandards AS wss
			WHERE (wss.identifier LIKE '%PAT.%')
				AND wss.standardgrade IS NOT NULL
				AND wss.TenantId = 38
				AND wss.SchoolYear = @SchoolYear
			)
			,TeacherCourses
		AS (
			SELECT *
			FROM (
				SELECT ascs.SchoolYear
					,ascs.SchoolIdentifier
					,ascs.Grade
					,ascs.DistrictStudentId
					,ascs.CourseTitle
					,ascs.TenantId
					,asf.DistrictStaffId
					,asf.TeacherFullName
					,ascs.SessionDescription AS SectionName
					,ascs.SectionIdentifier
					,ROW_NUMBER() OVER (
						PARTITION BY ascs.SchoolYear
						,ascs.SchoolIdentifier
						,ascs.Grade
						,ascs.DistrictStudentId
						,ascs.CourseTitle
						,ascs.TenantId
						,asf.DistrictStaffId
						,asf.TeacherFullName
						,ascs.SessionDescription
						,ascs.SectionIdentifier ORDER BY ascs.DistrictStudentId
						) AS RN
				FROM AggPLPStudentCourseSections ascs
				INNER JOIN aggstafffilters asf
					ON ascs.SchoolYear = asf.SchoolYear
						AND ascs.SchoolIdentifier = asf.SchoolIdentifier
						AND ascs.TenantId = asf.TenantId
						AND ascs.CourseIdentifier = asf.CourseIdentifier
						AND ascs.SectionIdentifier = asf.SectionIdentifier
				WHERE ascs.tenantid = 38
				) a
			WHERE rn = 1
			)
		INSERT INTO [WHPS_PATStandards] (
			SchoolYear
			,SchoolCategory
			,SchoolIdentifier
			,SchoolName
			,DistrictStudentId
			,StudentName
			,Grade
			,Gender
			,Race
			,StandardId
			,StandardIdentifier
			,StandardName
			,ParentStandardId
			,ParentIdentifier
			,ParentName
			,StoreCode
			,Term
			,StandardGrade
			,CourseTitle
			,SectionName
			,DistrictStaffId
			,TeacherFullName
			,MembershipDaysCount
			,PresentDaysCount
			,AbsentDaysCount
			,IsChronic
			,AbsentPercentage
			,Presentrate
			,AbsentRate
			,CurrentMonthAttendance
			,ELL
			,SpecialEdStatus
			,[504Status]
			,IEP
			,TenantId
			)
		SELECT agg.SchoolYear
			,agg.SchoolCategory
			,agg.SchoolIdentifier
			,agg.SchoolName
			,agg.DistrictStudentId
			,agg.StudentName
			,agg.Grade
			,agg.Gender
			,agg.Race
			,c.StandardId
			,c.identifier AS StandardIdentifier
			,c.[name] AS StandardName
			,c.ParentStandardId
			,NULL AS ParentIdentifier
			,NULL AS ParentName
			,c.StoreCode
			,CASE 
				WHEN c.StoreCode = 'Q1'
					THEN 'Fall'
				WHEN c.StoreCode IN ('Q2', 'Q3')
					THEN 'Winter'
				WHEN c.StoreCode = 'Q4'
					THEN 'Spring'
				ELSE c.StoreCode
				END AS Term
			,CASE 
				WHEN c.StandardGrade IS NOT NULL
					THEN CONCAT (
							'Level - '
							,c.StandardGrade
							)
				ELSE c.StandardGrade
				END AS StandardGrade
			,sc.CourseTitle
			,sc.SectionName
			,sc.DistrictStaffId
			,sc.TeacherFullName
			,agg.MembershipDaysCount
			,agg.PresentDaysCount
			,agg.AbsentDaysCount
			,agg.IsChronic
			,agg.AbsentPercentage
			,agg.Presentrate
			,agg.AbsentRate
			,agg.CurrentMonthAttendance
			,agg.ELL
			,agg.SpecialEdStatus
			,agg.[504Status]
			,agg.IEP
			,agg.TenantId
		FROM WHPS_PAT_StudentStandards c
		INNER JOIN AggSt agg
			ON c.SchoolYear = agg.SchoolYear
				AND c.student_number = agg.districtstudentid
				AND c.TenantId = agg.TenantId
		LEFT JOIN TeacherCourses sc
			ON agg.districtstudentid = sc.DistrictStudentId
				AND agg.TenantId = sc.TenantId
				AND agg.schoolyear = sc.SchoolYear
				AND agg.SchoolIdentifier = sc.SchoolIdentifier
				AND agg.GradeCode = sc.Grade
		WHERE c.StandardGrade IS NOT NULL
			AND agg.TenantId = 38;

		SET @TotalRowsInserted = @@ROWCOUNT;

		SELECT @TableRowsAfter = COUNT(*)
		FROM [WHPS_PATStandards];

		SET @EndTime = CAST(SYSDATETIME() AS DATETIME);
		SET @ElapsedTime = DATEDIFF(MILLISECOND, @StartTime, @EndTime);

		INSERT INTO [dbo].[WHPS_ProcessLogStatistics] (
			[ProcessName]
			,[TableRowsBefore]
			,[TotalRowsInserted]
			,[TableRowsAfter]
			,[StartTime]
			,[EndTime]
			,[ElapsedTime]
			,[TotalExecutionTime]
			,[EstimatedCPUtime]
			,[EstimatedI/O]
			,[TenantId]
			)
		SELECT @ProcessName
			,@TableRowsBefore
			,@TotalRowsInserted
			,@TableRowsAfter
			,@StartTime
			,@EndTime
			,@ElapsedTime
			,CAST(@ElapsedTime / 1000 AS VARCHAR(10)) + ' seconds ' + CAST(@ElapsedTime % 1000 AS VARCHAR(10)) + ' milliseconds'
			,CAST(@@CPU_BUSY AS VARCHAR(20)) + ' milliseconds'
			,CAST(@@IO_BUSY AS VARCHAR(20)) + ' milliseconds'
			,38;

		---===============================================================================================
		---===============================================================================================
		---===============================================================================================
		SET @ProcessName = '[WHPS_PAT_LevelMovementTeacher]';
		SET @StartTime = CAST(SYSDATETIME() AS DATETIME);

		SELECT @TableRowsBefore = COUNT(*)
		FROM [WHPS_PAT_LevelMovementTeacher];

		TRUNCATE TABLE [WHPS_PAT_LevelMovementTeacher];

		--insert into WHPS_PAT_LevelMovementTeacher (view -> WHPS_PAT_LevelMovement)
		WITH StudentDetails
		AS (
			SELECT DistrictStudentId
				,FirstName
				,MiddleName
				,LastorSurname
				,StudentFullName
				,BirthDate
				,SchoolYear
				,LEAIdentifier
				,SchoolIdentifier
				,LeaName
				,SchoolName
				,Gender
				,Grade
				,MilitaryAffiliated
				,Truant
				,SchoolCategory
				,Race
				,Migrant
				,GiftedandTalented
				,Tribal
				,EnrollmentBeginDate
				,EnrollmentEndDate
				,GenderCode
				,GradeCode
				,MilitaryAffiliatedCode
				,SchoolCategoryCode
				,TribalCode
				,DropOut
				,ELL
				,Graduate
				,MembershipDaysCount
				,PresentDaysCount
				,AbsentDaysCount
				,UA_AbsentDaysCount
				,IsChronic
				,AbsentPercentage
				,AgeGroup
				,DropOutReason
				,TardyDaysCount
				,Presentrate
				,AbsentRate
				,TardyRate
				,ExitType
				,ExitStatus
				,CohortGraduationYear
				,CurrentMonthAttendance
				,PreviousMonthAttendance
				,StateStudentId
				,FRL
				,DisabilityStatus
				,DisabilityReason
				,SpecialEdStatus
				,[504Status]
				,TenantId
				,Ethnicity
				,IepStatus
				,HispanicLatino
				,FosterChild
				,Homeless
				,HomeLanguage
				,EllProgram
				,CountryOfOrigon
				,Team
				,FEL
				,SchoolType
				,HighNeeds
				,IEP
			FROM AggRptK12StudentDetails
			WHERE TenantId = 38
			)
			,WHPS_PAT_StudentStandards
		AS (
			SELECT DISTINCT WSS.[SchoolId] AS [SchoolId]
				,WSS.[identifier] AS [identifier]
				,WSS.[name] AS [name]
				,WSS.[parentstandardid] AS [parentstandardid]
				,WSS.[parentstandardid_nvl] AS [parentstandardid_nvl]
				,'Level - ' + convert(VARCHAR, WSS.[standardgrade]) AS [standardgrade]
				,WSS.[standardid] AS [standardid]
				,CASE 
					WHEN [storecode] = 'Q2'
						THEN 'Q3'
					ELSE [storecode]
					END AS [storecode]
				,WSS.[student_number] AS [student_number]
				,WSS.[studentid] AS [studentid]
				,WSS.[studentsdcid] AS [studentsdcid]
				,WSS.[SchoolYear] AS [SchoolYear]
				,WSS.TenantId
			FROM Main.WHPS_StudentStandards AS WSS
			WHERE (WSS.identifier LIKE '%PAT.%')
				AND WSS.standardgrade IS NOT NULL
				AND WSS.TenantId = 38
			)
			,StandardsFallToWinter
		AS (
			SELECT a.SchoolYear
				,[Name]
				,'Q1 - Q3' AS StoreCode
				,'Fall - Winter' AS Term
				,ISNULL(a.[Q1], 'No Score') AS FromLevel
				,ISNULL(a.[Q3], 'No Score') AS ToLevel
				,CAST(REPLACE(a.[Q3], 'Level - ', '') AS INT) - CAST(REPLACE(a.[Q1], 'Level - ', '') AS INT) AS StatusValue
				,CASE 
					WHEN CAST(REPLACE(a.[Q3], 'Level - ', '') AS INT) - CAST(REPLACE(a.[Q1], 'Level - ', '') AS INT) > 0
						THEN 'Level Up'
					WHEN CAST(REPLACE(a.[Q3], 'Level - ', '') AS INT) - CAST(REPLACE(a.[Q1], 'Level - ', '') AS INT) < 0
						THEN 'Level Down'
					WHEN CAST(REPLACE(a.[Q3], 'Level - ', '') AS INT) - CAST(REPLACE(a.[Q1], 'Level - ', '') AS INT) = 0
						THEN 'Equal'
					ELSE 'No Movement'
					END AS STATUS
				,a.student_number AS DistrictStudentId
				,a.TenantId
			FROM (
				SELECT SchoolYear
					,student_number
					,[name]
					,storecode
					,STANDARDGRADE
					,TenantId
				FROM WHPS_PAT_StudentStandards
				) T
			PIVOT(MAX(STANDARDGRADE) FOR storecode IN ([Q1], [Q3])) A
			)
			,StandardsWinterToSpring
		AS (
			SELECT a.SchoolYear
				,[Name]
				,'Q3 - Q4' AS StoreCode
				,'Winter - Spring' AS Term
				,ISNULL(a.[Q3], 'No Score') AS FromLevel
				,ISNULL(a.[Q4], 'No Score') AS ToLevel
				,CAST(REPLACE(a.[Q4], 'Level - ', '') AS INT) - CAST(REPLACE(a.[Q3], 'Level - ', '') AS INT) AS StatusValue
				,CASE 
					WHEN CAST(REPLACE(a.[Q4], 'Level - ', '') AS INT) - CAST(REPLACE(a.[Q3], 'Level - ', '') AS INT) > 0
						THEN 'Level Up'
					WHEN CAST(REPLACE(a.[Q4], 'Level - ', '') AS INT) - CAST(REPLACE(a.[Q3], 'Level - ', '') AS INT) < 0
						THEN 'Level Down'
					WHEN CAST(REPLACE(a.[Q4], 'Level - ', '') AS INT) - CAST(REPLACE(a.[Q3], 'Level - ', '') AS INT) = 0
						THEN 'Equal'
					ELSE 'No Movement'
					END AS STATUS
				,a.student_number AS DistrictStudentId
				,a.TenantId
			FROM (
				SELECT SchoolYear
					,student_number
					,[name]
					,storecode
					,STANDARDGRADE
					,TenantId
				FROM WHPS_PAT_StudentStandards
				) T
			PIVOT(MAX(STANDARDGRADE) FOR storecode IN ([Q3], [Q4])) A
			)
			,StudentStandards
		AS (
			SELECT SchoolYear
				,[Name]
				,StoreCode
				,Term
				,FromLevel
				,ToLevel
				,STATUS
				,StatusValue
				,DistrictStudentId
				,TenantId
			FROM StandardsFallToWinter
			
			UNION ALL
			
			SELECT SchoolYear
				,[Name]
				,StoreCode
				,Term
				,FromLevel
				,ToLevel
				,STATUS
				,StatusValue
				,DistrictStudentId
				,TenantId
			FROM StandardsWinterToSpring
			)
			,UnpivotData
		AS (
			SELECT SchoolYear
				,[Name]
				,StoreCode
				,Term
				,FromLevel
				,ToLevel
				,StatusValue
				,DistrictStudentId
				,TenantId
				,MovementLevel
				,Colname
			FROM (
				SELECT ss.SchoolYear
					,ss.[Name]
					,ss.StoreCode
					,ss.Term
					,ss.FromLevel
					,ss.ToLevel
					,ss.StatusValue
					,ss.DistrictStudentId
					,ss.TenantId
					,
					-- Movement Categories
					CAST('All Students' AS VARCHAR(50)) AS allstudents
					,CAST(CASE 
							WHEN ss.StatusValue > 0
								THEN 'All Upward Movement'
							END AS VARCHAR(50)) AS AllUpwardMovement
					,CAST(CASE 
							WHEN ss.StatusValue < 0
								THEN 'All Downward Movement'
							END AS VARCHAR(50)) AS AllDownwardMovement
					,CAST(CASE 
							WHEN ss.StatusValue < - 1
								THEN 'Multi-Level Downward Movement'
							END AS VARCHAR(50)) AS MultiLevelDownwardMovement
					,CAST(CASE 
							WHEN ss.StatusValue > 1
								THEN 'Multi-Level Upward Movement'
							END AS VARCHAR(50)) AS MultiLevelUpwardMovement
					,CAST(CASE 
							WHEN ss.StatusValue < - 1
								OR ss.StatusValue > 1
								THEN 'All Multi-Level Movement'
							END AS VARCHAR(50)) AS AllMultiLevelMovement
				FROM StudentStandards ss
				) AS MovementCategories
			UNPIVOT(MovementLevel FOR Colname IN (AllUpwardMovement, AllDownwardMovement, MultiLevelDownwardMovement, MultiLevelUpwardMovement, AllMultiLevelMovement, allstudents)) AS Unpivoted
			WHERE MovementLevel IS NOT NULL
			)
			,TeacherCourses
		AS (
			SELECT *
			FROM (
				SELECT ascs.SchoolYear
					,ascs.SchoolIdentifier
					,ascs.Grade
					,ascs.DistrictStudentId
					,ascs.CourseTitle
					,ascs.TenantId
					,asf.DistrictStaffId
					,asf.TeacherFullName
					,ascs.SessionDescription AS SectionName
					,ascs.SectionIdentifier
					,ROW_NUMBER() OVER (
						PARTITION BY ascs.SchoolYear
						,ascs.SchoolIdentifier
						,ascs.Grade
						,ascs.DistrictStudentId
						,ascs.CourseTitle
						,ascs.TenantId
						,asf.DistrictStaffId
						,asf.TeacherFullName
						,ascs.SessionDescription
						,ascs.SectionIdentifier ORDER BY ascs.DistrictStudentId
						) AS RN
				FROM AggPLPStudentCourseSections ascs
				INNER JOIN aggstafffilters asf
					ON ascs.SchoolYear = asf.SchoolYear
						AND ascs.SchoolIdentifier = asf.SchoolIdentifier
						AND ascs.TenantId = asf.TenantId
						AND ascs.CourseIdentifier = asf.CourseIdentifier
						AND ascs.SectionIdentifier = asf.SectionIdentifier
				WHERE ascs.tenantid = 38
				) a
			WHERE rn = 1
			)
		INSERT INTO [WHPS_PAT_LevelMovementTeacher] (
			[SchoolYear]
			,[Name]
			,[StoreCode]
			,[Term]
			,[FromLevel]
			,[ToLevel]
			,[Status]
			,[DistrictStudentId]
			,[StudentFullName]
			,[SchoolIdentifier]
			,[SchoolCategory]
			,[SchoolName]
			,[Gender]
			,[Grade]
			,[Truant]
			,[Race]
			,[Migrant]
			,[GiftedandTalented]
			,[Tribal]
			,[EnrollmentBeginDate]
			,[EnrollmentEndDate]
			,[GenderCode]
			,[TribalCode]
			,[ELL]
			,[StateStudentId]
			,[FRL]
			,[SpecialEdStatus]
			,[504Status]
			,[IepStatus]
			,[EllProgram]
			,[FEL]
			,[HighNeeds]
			,[IEP]
			,[TenantId]
			,[MovementLevel]
			,[Colname]
			,[IsChronic]
			,[MembershipDaysCount]
			,[PresentDaysCount]
			,[AbsentDaysCount]
			,[AbsentPercentage]
			,[Presentrate]
			,[AbsentRate]
			,[CurrentMonthAttendance]
			,[CourseTitle]
			,[SectionName]
			,[DistrictStaffId]
			,[TeacherFullName]
			)
		SELECT DISTINCT ud.SchoolYear
			,ud.[Name]
			,ud.StoreCode
			,ud.Term
			,ud.FromLevel
			,ud.ToLevel
			,CASE 
				WHEN ud.StatusValue > 0
					THEN 'Level Up'
				WHEN ud.StatusValue < 0
					THEN 'Level Down'
				WHEN ud.StatusValue = 0
					THEN 'Equal'
				ELSE 'No Movement'
				END AS [Status]
			,ud.DistrictStudentId
			,agg.StudentFullName
			,agg.SchoolIdentifier
			,agg.SchoolCategory
			,agg.SchoolName
			,agg.Gender
			,agg.Grade
			,agg.Truant
			,agg.Race
			,agg.Migrant
			,agg.GiftedandTalented
			,agg.Tribal
			,agg.EnrollmentBeginDate
			,agg.EnrollmentEndDate
			,agg.GenderCode
			,agg.TribalCode
			,agg.ELL
			,agg.StateStudentId
			,agg.FRL
			,agg.SpecialEdStatus
			,agg.[504Status]
			,agg.IepStatus
			,agg.EllProgram
			,agg.FEL
			,agg.HighNeeds
			,ISNULL(agg.IEP, 'No') AS IEP
			,ud.TenantId
			,ud.MovementLevel
			,ud.Colname
			,IsNull(CASE 
					WHEN agg.IsChronic = 1
						THEN 'Yes'
					WHEN agg.IsChronic = 0
						THEN 'No'
					END, 'No') AS IsChronic
			,agg.MembershipDaysCount
			,agg.PresentDaysCount
			,agg.AbsentDaysCount
			,agg.AbsentPercentage
			,agg.Presentrate
			,agg.AbsentRate
			,agg.CurrentMonthAttendance
			,sc.CourseTitle
			,sc.SectionName
			,sc.DistrictStaffId
			,sc.TeacherFullName
		FROM UnpivotData ud
		INNER JOIN AggRptK12StudentDetails agg
			ON ud.SchoolYear = agg.SchoolYear
				AND ud.TenantId = agg.TenantId
				AND ud.DistrictStudentId = agg.DistrictStudentId
		LEFT JOIN TeacherCourses sc
			ON agg.districtstudentid = sc.DistrictStudentId
				AND agg.TenantId = sc.TenantId
		ORDER BY ud.DistrictStudentId DESC
			,ud.SchoolYear DESC
			,ud.MovementLevel DESC
			,sc.TeacherFullName DESC;

		SET @TotalRowsInserted = @@ROWCOUNT;

		SELECT @TableRowsAfter = COUNT(*)
		FROM [WHPS_PAT_LevelMovementTeacher];

		SET @EndTime = CAST(SYSDATETIME() AS DATETIME);
		SET @ElapsedTime = DATEDIFF(MILLISECOND, @StartTime, @EndTime);

		INSERT INTO [dbo].[WHPS_ProcessLogStatistics] (
			[ProcessName]
			,[TableRowsBefore]
			,[TotalRowsInserted]
			,[TableRowsAfter]
			,[StartTime]
			,[EndTime]
			,[ElapsedTime]
			,[TotalExecutionTime]
			,[EstimatedCPUtime]
			,[EstimatedI/O]
			,[TenantId]
			)
		SELECT @ProcessName
			,@TableRowsBefore
			,@TotalRowsInserted
			,@TableRowsAfter
			,@StartTime
			,@EndTime
			,@ElapsedTime
			,CAST(@ElapsedTime / 1000 AS VARCHAR(10)) + ' seconds ' + CAST(@ElapsedTime % 1000 AS VARCHAR(10)) + ' milliseconds'
			,CAST(@@CPU_BUSY AS VARCHAR(20)) + ' milliseconds'
			,CAST(@@IO_BUSY AS VARCHAR(20)) + ' milliseconds'
			,38;

		---===============================================================================================
		---===============================================================================================
		---===============================================================================================
		SET @ProcessName = '[WHPS_PATLevelMovementStudentTeacher]';
		SET @StartTime = CAST(SYSDATETIME() AS DATETIME);

		SELECT @TableRowsBefore = COUNT(*)
		FROM [WHPS_PATLevelMovementStudentTeacher];

		TRUNCATE TABLE [WHPS_PATLevelMovementStudentTeacher];

		--insert into WHPS_PATLevelMovementStudentTeacher (view -> WHPS_PATLevelMovementStudent_Vw)
		WITH StudentDetails
		AS (
			SELECT DistrictStudentId
				,FirstName
				,MiddleName
				,LastorSurname
				,StudentFullName
				,BirthDate
				,SchoolYear
				,LEAIdentifier
				,SchoolIdentifier
				,LeaName
				,SchoolName
				,Gender
				,Grade
				,MilitaryAffiliated
				,Truant
				,SchoolCategory
				,Race
				,Migrant
				,GiftedandTalented
				,Tribal
				,EnrollmentBeginDate
				,EnrollmentEndDate
				,GenderCode
				,GradeCode
				,MilitaryAffiliatedCode
				,SchoolCategoryCode
				,TribalCode
				,DropOut
				,ELL
				,Graduate
				,MembershipDaysCount
				,PresentDaysCount
				,AbsentDaysCount
				,UA_AbsentDaysCount
				,IsChronic
				,AbsentPercentage
				,AgeGroup
				,DropOutReason
				,TardyDaysCount
				,Presentrate
				,AbsentRate
				,TardyRate
				,ExitType
				,ExitStatus
				,CohortGraduationYear
				,CurrentMonthAttendance
				,PreviousMonthAttendance
				,StateStudentId
				,FRL
				,DisabilityStatus
				,DisabilityReason
				,SpecialEdStatus
				,[504Status]
				,TenantId
				,Ethnicity
				,IepStatus
				,HispanicLatino
				,FosterChild
				,Homeless
				,HomeLanguage
				,EllProgram
				,CountryOfOrigon
				,Team
				,FEL
				,SchoolType
				,HighNeeds
				,IEP
			FROM AggRptK12StudentDetails
			WHERE tenantid = 38
			)
			,WHPS_PAT_StudentStandards
		AS (
			--before used this view [WHPSPAT_StudentStandards] replaced with cte
			SELECT DISTINCT WHPS_StudentStandards.[SchoolId] AS [SchoolId]
				,WHPS_StudentStandards.[identifier] AS [identifier]
				,WHPS_StudentStandards.[name] AS [name]
				,WHPS_StudentStandards.[parentstandardid] AS [parentstandardid]
				,WHPS_StudentStandards.[parentstandardid_nvl] AS [parentstandardid_nvl]
				,'Level - ' + convert(VARCHAR, WHPS_StudentStandards.[standardgrade]) AS [standardgrade]
				,WHPS_StudentStandards.[standardid] AS [standardid]
				,CASE 
					WHEN [storecode] = 'Q2'
						THEN 'Q3'
					ELSE [storecode]
					END AS [storecode]
				,WHPS_StudentStandards.[student_number] AS [student_number]
				,WHPS_StudentStandards.[studentid] AS [studentid]
				,WHPS_StudentStandards.[studentsdcid] AS [studentsdcid]
				,WHPS_StudentStandards.[SchoolYear] AS [SchoolYear]
				,WHPS_StudentStandards.TenantId
			FROM Main.WHPS_StudentStandards AS WHPS_StudentStandards
			WHERE (WHPS_StudentStandards.identifier LIKE '%PAT.%')
				AND WHPS_StudentStandards.standardgrade IS NOT NULL
				AND WHPS_StudentStandards.TenantId = 38
			)
			,StandardsFallToWinter
		AS (
			SELECT a.SchoolYear
				,[Name]
				,'Q1 - Q3' AS StoreCode
				,'Fall - Winter' AS Term
				,isnull(a.[Q1], 'No Score') AS FromLevel
				,isnull(a.[Q3], 'No Score') AS ToLevel
				,CASE 
					WHEN CAST(REPLACE(a.[Q3], 'Level - ', '') AS INT) - CAST(REPLACE(a.[Q1], 'Level - ', '') AS INT) > 0
						THEN 'Level Up'
					WHEN CAST(REPLACE(a.[Q3], 'Level - ', '') AS INT) - CAST(REPLACE(a.[Q1], 'Level - ', '') AS INT) < 0
						THEN 'Level Down'
					WHEN CAST(REPLACE(a.[Q3], 'Level - ', '') AS INT) - CAST(REPLACE(a.[Q1], 'Level - ', '') AS INT) = 0
						THEN 'Equal'
					ELSE 'No Movement'
					END AS [Status]
				,a.student_number AS DistrictStudentId
				,a.Tenantid
			FROM (
				SELECT SchoolYear
					,student_number
					,[name]
					,storecode
					,STANDARDGRADE
					,TenantId
				FROM WHPS_PAT_StudentStandards
				) T
			PIVOT(MAX(STANDARDGRADE) FOR storecode IN ([Q1], [Q3])) A
			)
			,StandardsWinterToSpring
		AS (
			SELECT a.SchoolYear
				,a.[Name]
				,'Q3 - Q4' AS StoreCode
				,'Winter - Spring' AS Term
				,isnull(a.[Q3], 'No Score') AS FromLevel
				,isnull(a.[Q4], 'No Score') AS ToLevel
				,CASE 
					WHEN CAST(REPLACE(a.[Q4], 'Level - ', '') AS INT) - CAST(REPLACE(a.[Q3], 'Level - ', '') AS INT) > 0
						THEN 'Level Up'
					WHEN CAST(REPLACE(a.[Q4], 'Level - ', '') AS INT) - CAST(REPLACE(a.[Q3], 'Level - ', '') AS INT) < 0
						THEN 'Level Down'
					WHEN CAST(REPLACE(a.[Q4], 'Level - ', '') AS INT) - CAST(REPLACE(a.[Q3], 'Level - ', '') AS INT) = 0
						THEN 'Equal'
					ELSE 'No Movement'
					END AS [Status]
				,a.student_number AS DistrictStudentId
				,a.Tenantid
			FROM (
				SELECT SchoolYear
					,student_number
					,[name]
					,storecode
					,STANDARDGRADE
					,TenantId
				FROM WHPS_PAT_StudentStandards
				) T
			PIVOT(MAX(STANDARDGRADE) FOR storecode IN ([Q3], [Q4])) A
			)
			,StudentStandards
		AS (
			SELECT SchoolYear
				,[Name]
				,StoreCode
				,Term
				,FromLevel
				,ToLevel
				,[Status]
				,DistrictStudentId
				,Tenantid
			FROM StandardsFallToWinter
			
			UNION ALL
			
			SELECT SchoolYear
				,[Name]
				,StoreCode
				,Term
				,FromLevel
				,ToLevel
				,[Status]
				,DistrictStudentId
				,Tenantid
			FROM StandardsWinterToSpring
			)
			,TeacherCourses
		AS (
			SELECT *
			FROM (
				SELECT ascs.SchoolYear
					,ascs.SchoolIdentifier
					,ascs.Grade
					,ascs.DistrictStudentId
					,ascs.CourseTitle
					,ascs.TenantId
					,asf.DistrictStaffId
					,asf.TeacherFullName
					,ascs.SessionDescription AS SectionName
					,ascs.SectionIdentifier
					,ROW_NUMBER() OVER (
						PARTITION BY ascs.SchoolYear
						,ascs.SchoolIdentifier
						,ascs.Grade
						,ascs.DistrictStudentId
						,ascs.CourseTitle
						,ascs.TenantId
						,asf.DistrictStaffId
						,asf.TeacherFullName
						,ascs.SessionDescription
						,ascs.SectionIdentifier ORDER BY ascs.DistrictStudentId
						) AS RN
				FROM AggPLPStudentCourseSections ascs
				INNER JOIN aggstafffilters asf
					ON ascs.SchoolYear = asf.SchoolYear
						AND ascs.SchoolIdentifier = asf.SchoolIdentifier
						AND ascs.TenantId = asf.TenantId
						AND ascs.CourseIdentifier = asf.CourseIdentifier
						AND ascs.SectionIdentifier = asf.SectionIdentifier
				WHERE ascs.tenantid = 38
				) a
			WHERE rn = 1
			)
		INSERT INTO [WHPS_PATLevelMovementStudentTeacher] (
			[SchoolYear]
			,[Name]
			,[StoreCode]
			,[Term]
			,[FromLevel]
			,[ToLevel]
			,[Status]
			,[DistrictStudentId]
			,[StudentFullName]
			,[SchoolIdentifier]
			,[SchoolCategory]
			,[SchoolName]
			,[Gender]
			,[Grade]
			,[Truant]
			,[Race]
			,[Migrant]
			,[GiftedandTalented]
			,[Tribal]
			,[EnrollmentBeginDate]
			,[EnrollmentEndDate]
			,[GenderCode]
			,[TribalCode]
			,[ELL]
			,[StateStudentId]
			,[FRL]
			,[SpecialEdStatus]
			,[504Status]
			,[IepStatus]
			,[EllProgram]
			,[FEL]
			,[HighNeeds]
			,[IEP]
			,[Tenantid]
			,[IsChronic]
			,[MembershipDaysCount]
			,[PresentDaysCount]
			,[AbsentDaysCount]
			,[AbsentPercentage]
			,[Presentrate]
			,[AbsentRate]
			,[CurrentMonthAttendance]
			,[CourseTitle]
			,[SectionName]
			,[DistrictStaffId]
			,[TeacherFullName]
			)
		SELECT agg.[SchoolYear]
			,ss.[Name]
			,ss.[StoreCode]
			,ss.[Term]
			,ss.[FromLevel]
			,ss.[ToLevel]
			,ss.[Status]
			,agg.[DistrictStudentId]
			,agg.[StudentFullName]
			,agg.[SchoolIdentifier]
			,agg.[SchoolCategory]
			,agg.[SchoolName]
			,agg.[Gender]
			,agg.[Grade]
			,agg.[Truant]
			,agg.[Race]
			,agg.[Migrant]
			,agg.[GiftedandTalented]
			,agg.[Tribal]
			,agg.[EnrollmentBeginDate]
			,agg.[EnrollmentEndDate]
			,agg.[GenderCode]
			,agg.[TribalCode]
			,agg.[ELL]
			,agg.[StateStudentId]
			,agg.[FRL]
			,agg.[SpecialEdStatus]
			,agg.[504Status]
			,agg.[IepStatus]
			,agg.[EllProgram]
			,agg.[FEL]
			,agg.[HighNeeds]
			,isnull(agg.[IEP], 'No') AS [IEP]
			,agg.[Tenantid]
			,IsNull(CASE 
					WHEN agg.IsChronic = 1
						THEN 'Yes'
					WHEN agg.IsChronic = 0
						THEN 'No'
					END, 'No') AS IsChronic
			,agg.MembershipDaysCount
			,agg.PresentDaysCount
			,agg.AbsentDaysCount
			,agg.AbsentPercentage
			,agg.Presentrate
			,agg.AbsentRate
			,agg.CurrentMonthAttendance
			,sc.CourseTitle
			,sc.SectionName
			,sc.DistrictStaffId
			,sc.TeacherFullName
		FROM StudentDetails agg
		INNER JOIN StudentStandards ss
			ON agg.SchoolYear = ss.SchoolYear
				AND agg.TenantId = ss.TenantId
				AND agg.DistrictStudentId = ss.DistrictStudentId
		LEFT JOIN TeacherCourses sc
			ON agg.districtstudentid = sc.DistrictStudentId
				AND agg.TenantId = sc.TenantId
		ORDER BY agg.[DistrictStudentId] DESC
			,agg.[SchoolYear] DESC
			,ss.[Name] DESC
			,ss.[StoreCode] DESC
			,sc.DistrictStaffId DESC;

		SET @TotalRowsInserted = @@ROWCOUNT;

		SELECT @TableRowsAfter = COUNT(*)
		FROM [WHPS_PATLevelMovementStudentTeacher];

		SET @EndTime = CAST(SYSDATETIME() AS DATETIME);
		SET @ElapsedTime = DATEDIFF(MILLISECOND, @StartTime, @EndTime);

		INSERT INTO [dbo].[WHPS_ProcessLogStatistics] (
			[ProcessName]
			,[TableRowsBefore]
			,[TotalRowsInserted]
			,[TableRowsAfter]
			,[StartTime]
			,[EndTime]
			,[ElapsedTime]
			,[TotalExecutionTime]
			,[EstimatedCPUtime]
			,[EstimatedI/O]
			,[TenantId]
			)
		SELECT @ProcessName
			,@TableRowsBefore
			,@TotalRowsInserted
			,@TableRowsAfter
			,@StartTime
			,@EndTime
			,@ElapsedTime
			,CAST(@ElapsedTime / 1000 AS VARCHAR(10)) + ' seconds ' + CAST(@ElapsedTime % 1000 AS VARCHAR(10)) + ' milliseconds'
			,CAST(@@CPU_BUSY AS VARCHAR(20)) + ' milliseconds'
			,CAST(@@IO_BUSY AS VARCHAR(20)) + ' milliseconds'
			,38;

		---===============================================================================================
		---===============================================================================================
		---===============================================================================================
		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		DECLARE @ErrorFromProc VARCHAR(500)
		DECLARE @ProcErrorMessage VARCHAR(1000)
		DECLARE @SeverityLevel INT

		SELECT @ErrorFromProc = '[dbo].[USP_WHPS_PAT_LevelMovement_Loading]'
			,@ProcErrorMessage = Error_message() + ' ; Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + ' ; Error State: ' + CAST(ERROR_STATE() AS VARCHAR(10)) + ' ; Error Line: ' + CAST(ERROR_LINE() AS VARCHAR(10))
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


