CREATE PROCEDURE [dbo].[CreateHCSAssessmentiReadyPIS] (
	@SchoolYear INT = NULL
	,@TenantId INT = 4
	)
AS
BEGIN
	SET ANSI_NULLS ON;
	SET QUOTED_IDENTIFIER OFF;
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	BEGIN TRY
		DECLARE @StartTime DATETIME2;
		DECLARE @EndTime DATETIME2;
		DECLARE @TotalRowsInserted INT = 0;
		DECLARE @TableRowsBefore INT;
		DECLARE @TableRowsAfter INT
		DECLARE @ProcessName NVARCHAR(150) = '[HCS_Assessment_iReadyPIS]'

		-- Record the start time
		SET @StartTime = CAST(SYSDATETIME() AS DATETIME);

		-- Get row count before operation
		SELECT @TableRowsBefore = COUNT(*)
		FROM [HCS_Assessment_iReadyPIS]

		BEGIN TRANSACTION

		--IF object_id('HCS_Assessment_iReadyPIS') IS NOT NULL
		--DROP TABLE dbo.HCS_Assessment_iReadyPIS;
		DECLARE @LatestYear INT

		SET @LatestYear = (
				SELECT TOP 1 Schoolyear
				FROM DomainReportFilters
				WHERE tenantid = @TenantId
					AND datadomaincode = 'SENRL'
				ORDER BY Schoolyear DESC
				);

		IF @SchoolYear IS NULL
		BEGIN
			SET @SchoolYear = (
					SELECT TOP 1 SchoolYear
					FROM (
						SELECT DISTINCT SchoolYear
							,TenantId
						FROM [Main].[HenryInsights_Personalized_Instruction_Summary_Ela]
						
						UNION
						
						SELECT DISTINCT SchoolYear
							,TenantId
						FROM [Main].[HenryInsights_Personalized_Instruction_Summary_Math]
						) AS a
					WHERE TenantId = @TenantId
					ORDER BY SchoolYear DESC
					)
		END

		EXEC [dbo].[USP_DisableAllIndexes] 'HCS_Assessment_iReadyPIS'

		DELETE
		FROM [HCS_Assessment_iReadyPIS]
		WHERE SchoolYear = @SchoolYear

		--drop table HCS_Assessment_iReadyPIS
		--CREATE TABLE [dbo].[HCS_Assessment_iReadyPIS] (
		--	[LastName] VARCHAR(200) NULL
		--	,[FirstName] VARCHAR(200) NULL
		--	,[StudentID] VARCHAR(500) NULL
		--	,[StudentGrade] VARCHAR(500) NULL
		--	,[AcademicYear] VARCHAR(500) NULL
		--	,[School] VARCHAR(500) NULL
		--	,[Subject] VARCHAR(500) NULL
		--	,[EnrollStatus] VARCHAR(500) NULL
		--	,[Classes] VARCHAR(5000) NULL
		--	,[ClassTeachers] VARCHAR(5000) NULL
		--	,[ReportGroups] VARCHAR(5000) NULL
		--	,[DateRange] VARCHAR(50) NULL
		--	,[DateRangeStart] VARCHAR(50) NULL
		--	,[DateRangeEnd] VARCHAR(50) NULL
		--	,[DateRangeWeek] VARCHAR(200) NOT NULL
		--	,[TotalLessonTimeonTask_min] VARCHAR(50) NULL
		--	,[AllLessonsPassed] VARCHAR(50) NULL
		--	,[AllLessonsCompleted] VARCHAR(50) NULL
		--	,[PerAllLessonsPassed] VARCHAR(50) NULL
		--	,[Domain1Name] VARCHAR(50) NOT NULL
		--	,[Domain2Name] VARCHAR(50) NOT NULL
		--	,[Domain3Name] VARCHAR(50) NOT NULL
		--	,[Domain4Name] VARCHAR(50) NOT NULL
		--	,[Domain5Name] VARCHAR(50) NULL
		--	,[Domain6Name] VARCHAR(50) NULL
		--	,[Strand1Name] VARCHAR(50) NOT NULL
		--	,[Strand2Name] VARCHAR(50) NOT NULL
		--	,[Strand3Name] VARCHAR(50) NOT NULL
		--	,[Strand4Name] VARCHAR(50) NOT NULL
		--	,[Strand5Name] VARCHAR(50) NULL
		--	,[Strand6Name] VARCHAR(50) NULL
		--	,[Strand7Name] VARCHAR(50) NULL
		--	,[Strand8Name] VARCHAR(50) NULL
		--	,[StrandCategory1Name] VARCHAR(50) NULL
		--	,[StrandCategory2Name] VARCHAR(50) NULL
		--	,[StrandCategory3Name] VARCHAR(50) NULL
		--	,[Domain1LessonsPassed] VARCHAR(50) NULL
		--	,[Domain1LessonsComplete] VARCHAR(50) NULL
		--	,[Domain1LessonsPassed_Percent] VARCHAR(50) NULL
		--	,[Domain2LessonsPassed] VARCHAR(50) NULL
		--	,[Domain2LessonsComplete] VARCHAR(50) NULL
		--	,[Domain2LessonsPassed_Percent] VARCHAR(50) NULL
		--	,[Domain3LessonsPassed] VARCHAR(50) NULL
		--	,[Domain3LessonsComplete] VARCHAR(50) NULL
		--	,[Domain3LessonsPassed_Percent] VARCHAR(50) NULL
		--	,[Domain4LessonsPassed] VARCHAR(50) NULL
		--	,[Domain4LessonsComplete] VARCHAR(50) NULL
		--	,[Domain4LessonsPassed_Percent] VARCHAR(50) NULL
		--	,[Domain5LessonsPassed] VARCHAR(50) NULL
		--	,[Domain5LessonsComplete] VARCHAR(50) NULL
		--	,[Domain5LessonsPassed_Percent] VARCHAR(50) NULL
		--	,[Domain6LessonsPassed] VARCHAR(50) NULL
		--	,[Domain6LessonsComplete] VARCHAR(50) NULL
		--	,[Domain6LessonsPassed_Percent] VARCHAR(50) NULL
		--	,[Strand1SkillsSuccessful] VARCHAR(50) NULL
		--	,[Strand1SkillsComplete] VARCHAR(50) NULL
		--	,[Strand1SkillsSuccessful_Percent] VARCHAR(50) NULL
		--	,[Strand2SkillsSuccessful] VARCHAR(50) NULL
		--	,[Strand2SkillsComplete] VARCHAR(50) NULL
		--	,[Strand2SkillsSuccessful_Percent] VARCHAR(50) NULL
		--	,[Strand3SkillsSuccessful] VARCHAR(50) NULL
		--	,[Strand3SkillsComplete] VARCHAR(50) NULL
		--	,[Strand3SkillsSuccessful_Percent] VARCHAR(50) NULL
		--	,[Strand4SkillsSuccessful] VARCHAR(50) NULL
		--	,[Strand4SkillsComplete] VARCHAR(50) NULL
		--	,[Strand4SkillsSuccessful_Percent] VARCHAR(50) NULL
		--	,[Strand5SkillsSuccessful] VARCHAR(50) NULL
		--	,[Strand5SkillsComplete] VARCHAR(50) NULL
		--	,[Strand5SkillsSuccessful_Percent] VARCHAR(50) NULL
		--	,[Strand6SkillsSuccessful] VARCHAR(50) NULL
		--	,[Strand6SkillsComplete] VARCHAR(50) NULL
		--	,[Strand6SkillsSuccessful_Percent] VARCHAR(50) NULL
		--	,[Strand7SkillsSuccessful] VARCHAR(50) NULL
		--	,[Strand7SkillsComplete] VARCHAR(50) NULL
		--	,[Strand7SkillsSuccessful_Percent] VARCHAR(50) NULL
		--	,[Strand8SkillsSuccessful] VARCHAR(50) NULL
		--	,[Strand8SkillsComplete] VARCHAR(50) NULL
		--	,[Strand8SkillsSuccessful_Percent] VARCHAR(50) NULL
		--	,[StrandCategory1LessonsPassed] VARCHAR(50) NULL
		--	,[StrandCategory1LessonsComplete] VARCHAR(50) NULL
		--	,[StrandCategory1LessonsPassed_Percent] VARCHAR(50) NULL
		--	,[StrandCategory2LessonsPassed] VARCHAR(50) NULL
		--	,[StrandCategory2LessonsComplete] VARCHAR(50) NULL
		--	,[StrandCategory2LessonsPassed_Percent] VARCHAR(50) NULL
		--	,[StrandCategory3LessonsPassed] VARCHAR(50) NULL
		--	,[StrandCategory3LessonsComplete] VARCHAR(50) NULL
		--	,[StrandCategory3LessonsPassed_Percent] VARCHAR(50) NULL
		--	,[WeekNumber] VARCHAR(50) NULL
		--	,[WeeklyAverageMinutes] VARCHAR(50) NULL
		--	,[WeeklyAverageLessonsPassed] VARCHAR(50) NULL
		--	,[WeeklyAverageLessonsCompleted] VARCHAR(50) NULL
		--	,[LessonsPassedTotal] VARCHAR(50) NULL
		--	,[LessonsCompletedTotal] VARCHAR(50) NULL
		--	,[CumulativePerformance] VARCHAR(50) NULL
		--	,[ProgressMontoringAchLevel] VARCHAR(50) NULL
		--	,[DistrictTimeGuidance] VARCHAR(50) NULL
		--	,[WeeklyAvgLessonsPassedGroup] VARCHAR(50) NULL
		--	,[ProgressMontoringAchLevelGroup] VARCHAR(50) NULL
		--	,[DistrictTimeGuidanceGroup] VARCHAR(50) NULL
		--	,[StudentNameWithID] VARCHAR(250) NULL
		--	,[StudentFullName] VARCHAR(250) NULL
		--	,[Gender] VARCHAR(50) NULL
		--	,[GenderLong] VARCHAR(50) NULL
		--	,[GradeLevel] VARCHAR(50) NULL
		--	,[ActiveEnrollmentDesc] VARCHAR(50) NULL
		--	,[ActiveYear] VARCHAR(50) NOT NULL
		--	,[ActiveYearDesc] VARCHAR(50) NULL
		--	,[ActiveCalendarIDs] VARCHAR(500) NULL
		--	,[PersonID] VARCHAR(50) NOT NULL
		--	,[StudentNumber] VARCHAR(50) NULL
		--	,[SchoolIdentifier] VARCHAR(50) NOT NULL
		--	,[SchoolName] VARCHAR(50) NOT NULL
		--	,[SchoolNameShort] VARCHAR(50) NULL
		--	,[SchoolLevel] VARCHAR(50) NULL
		--	,[SchoolCategory] VARCHAR(100) NULL
		--	,[Region] VARCHAR(50) NULL
		--	,[Cluster] VARCHAR(50) NULL
		--	,[CurrentSchoolID] VARCHAR(100) NULL
		--	,[CurrentSchoolName] VARCHAR(100) NULL
		--	,[CurrentGrade] VARCHAR(100) NULL
		--	,[RaceEthnicity] VARCHAR(100) NULL
		--	,[RaceEthnicityShort] VARCHAR(50) NULL
		--	,[ELIndicator] VARCHAR(50) NULL
		--	,[GiftedIndicator] VARCHAR(50) NULL
		--	,[MTSSIndicator] VARCHAR(50) NULL
		--	,[MTSSLevel] VARCHAR(50) NULL
		--	,[EIPRemedialIndicator] VARCHAR(50) NULL
		--	,[SWDIndicator] VARCHAR(50) NULL
		--	,[Disability1] VARCHAR(50) NULL
		--	,[S504Indicator] VARCHAR(50) NULL
		--	,[KITIndicator] VARCHAR(50) NULL
		--	,[EDIndicator] VARCHAR(50) NULL
		--	,[CohortYear] VARCHAR(50) NULL
		--	,[EstimatedCohortYear] VARCHAR(50) NULL
		--	,[Grade9Date] VARCHAR(50) NULL
		--	,[ServiceType] VARCHAR(50) NOT NULL
		--	,[EnrollmentStartDate] VARCHAR(50) NULL
		--	,[EnrollmentStartStatus] VARCHAR(50) NULL
		--	,[EnrollmentStartStatusDesc] VARCHAR(300) NULL
		--	,[EnrollmentEndDate] VARCHAR(50) NULL
		--	,[EnrollmentEndStatus] VARCHAR(50) NULL
		--	,[EnrollmentEndStatusDesc] VARCHAR(250) NULL
		--	,[TitleI] VARCHAR(50) NULL
		--	,[CSI] VARCHAR(50) NULL
		--	,[ATSI] VARCHAR(50) NULL
		--	,[LEAIdentifier] VARCHAR(60) NULL
		--	,[SchoolYear] varchar(50) NULL
		--	,[TenantId] INT NULL
		--	);
		INSERT INTO dbo.HCS_Assessment_iReadyPIS (
			[LastName]
			,[FirstName]
			,[StudentID]
			,[StudentGrade]
			,[AcademicYear]
			,[School]
			,[Subject]
			,[EnrollStatus]
			,[Classes]
			,[ClassTeachers]
			,[ReportGroups]
			,[DateRange]
			,[DateRangeStart]
			,[DateRangeEnd]
			,[DateRangeWeek]
			,[TotalLessonTimeonTask_min]
			,[AllLessonsPassed]
			,[AllLessonsCompleted]
			,[PerAllLessonsPassed]
			,[Domain1Name]
			,[Domain2Name]
			,[Domain3Name]
			,[Domain4Name]
			,[Domain5Name]
			,[Domain6Name]
			,[Strand1Name]
			,[Strand2Name]
			,[Strand3Name]
			,[Strand4Name]
			,[Strand5Name]
			,[Strand6Name]
			,[Strand7Name]
			,[Strand8Name]
			,[StrandCategory1Name]
			,[StrandCategory2Name]
			,[StrandCategory3Name]
			,[Domain1LessonsPassed]
			,[Domain1LessonsComplete]
			,[Domain1LessonsPassed_Percent]
			,[Domain2LessonsPassed]
			,[Domain2LessonsComplete]
			,[Domain2LessonsPassed_Percent]
			,[Domain3LessonsPassed]
			,[Domain3LessonsComplete]
			,[Domain3LessonsPassed_Percent]
			,[Domain4LessonsPassed]
			,[Domain4LessonsComplete]
			,[Domain4LessonsPassed_Percent]
			,[Domain5LessonsPassed]
			,[Domain5LessonsComplete]
			,[Domain5LessonsPassed_Percent]
			,[Domain6LessonsPassed]
			,[Domain6LessonsComplete]
			,[Domain6LessonsPassed_Percent]
			,[Strand1SkillsSuccessful]
			,[Strand1SkillsComplete]
			,[Strand1SkillsSuccessful_Percent]
			,[Strand2SkillsSuccessful]
			,[Strand2SkillsComplete]
			,[Strand2SkillsSuccessful_Percent]
			,[Strand3SkillsSuccessful]
			,[Strand3SkillsComplete]
			,[Strand3SkillsSuccessful_Percent]
			,[Strand4SkillsSuccessful]
			,[Strand4SkillsComplete]
			,[Strand4SkillsSuccessful_Percent]
			,[Strand5SkillsSuccessful]
			,[Strand5SkillsComplete]
			,[Strand5SkillsSuccessful_Percent]
			,[Strand6SkillsSuccessful]
			,[Strand6SkillsComplete]
			,[Strand6SkillsSuccessful_Percent]
			,[Strand7SkillsSuccessful]
			,[Strand7SkillsComplete]
			,[Strand7SkillsSuccessful_Percent]
			,[Strand8SkillsSuccessful]
			,[Strand8SkillsComplete]
			,[Strand8SkillsSuccessful_Percent]
			,[StrandCategory1LessonsPassed]
			,[StrandCategory1LessonsComplete]
			,[StrandCategory1LessonsPassed_Percent]
			,[StrandCategory2LessonsPassed]
			,[StrandCategory2LessonsComplete]
			,[StrandCategory2LessonsPassed_Percent]
			,[StrandCategory3LessonsPassed]
			,[StrandCategory3LessonsComplete]
			,[StrandCategory3LessonsPassed_Percent]
			,[WeekNumber]
			,[WeeklyAverageMinutes]
			,[WeeklyAverageLessonsPassed]
			,[WeeklyAverageLessonsCompleted]
			,[LessonsPassedTotal]
			,[LessonsCompletedTotal]
			,[CumulativePerformance]
			,[ProgressMontoringAchLevel]
			,[DistrictTimeGuidance]
			,[WeeklyAvgLessonsPassedGroup]
			,[ProgressMontoringAchLevelGroup]
			,[DistrictTimeGuidanceGroup]
			,[StudentNameWithID]
			,[StudentFullName]
			,[Gender]
			,[GenderLong]
			,[GradeLevel]
			,[ActiveEnrollmentDesc]
			,[ActiveYear]
			,[ActiveYearDesc]
			,[ActiveCalendarIDs]
			,[PersonID]
			,[StudentNumber]
			,[SchoolIdentifier]
			,[SchoolName]
			,[SchoolNameShort]
			,[SchoolLevel]
			,[SchoolCategory]
			,[Region]
			,[Cluster]
			,[RaceEthnicity]
			,[RaceEthnicityShort]
			,[ELIndicator]
			,[GiftedIndicator]
			,[MTSSIndicator]
			,[MTSSLevel]
			,[EIPRemedialIndicator]
			,[SWDIndicator]
			,[Disability1]
			,[S504Indicator]
			,[KITIndicator]
			,[EDIndicator]
			,[CohortYear]
			,[EstimatedCohortYear]
			,[Grade9Date]
			,[ServiceType]
			,[EnrollmentStartDate]
			,[EnrollmentStartStatus]
			,[EnrollmentStartStatusDesc]
			,[EnrollmentEndDate]
			,[EnrollmentEndStatus]
			,[EnrollmentEndStatusDesc]
			,[TitleI]
			,[CSI]
			,[ATSI]
			,[LEAIdentifier]
			,[SchoolYear]
			,[TenantId]
			)
		SELECT c.[LastName]
			,c.[FirstName]
			,c.[StudentID]
			,c.[StudentGrade]
			,c.[AcademicYear]
			,c.[School]
			,c.[Subject]
			,c.[EnrollStatus]
			,c.[Classes]
			,c.[ClassTeachers]
			,c.[ReportGroups]
			,c.[DateRange]
			,c.[DateRangeStart]
			,c.[DateRangeEnd]
			,c.[DateRangeWeek]
			,c.[TotalLessonTimeonTask_min]
			,c.[AllLessonsPassed]
			,c.[AllLessonsCompleted]
			,c.[PerAllLessonsPassed]
			,c.[Domain1Name]
			,c.[Domain2Name]
			,c.[Domain3Name]
			,c.[Domain4Name]
			,c.[Domain5Name]
			,c.[Domain6Name]
			,c.[Strand1Name]
			,c.[Strand2Name]
			,c.[Strand3Name]
			,c.[Strand4Name]
			,c.[Strand5Name]
			,c.[Strand6Name]
			,c.[Strand7Name]
			,c.[Strand8Name]
			,c.[StrandCategory1Name]
			,c.[StrandCategory2Name]
			,c.[StrandCategory3Name]
			,c.[Domain1LessonsPassed]
			,c.[Domain1LessonsComplete]
			,c.[Domain1LessonsPassed_Percent]
			,c.[Domain2LessonsPassed]
			,c.[Domain2LessonsComplete]
			,c.[Domain2LessonsPassed_Percent]
			,c.[Domain3LessonsPassed]
			,c.[Domain3LessonsComplete]
			,c.[Domain3LessonsPassed_Percent]
			,c.[Domain4LessonsPassed]
			,c.[Domain4LessonsComplete]
			,c.[Domain4LessonsPassed_Percent]
			,c.[Domain5LessonsPassed]
			,c.[Domain5LessonsComplete]
			,c.[Domain5LessonsPassed_Percent]
			,c.[Domain6LessonsPassed]
			,c.[Domain6LessonsComplete]
			,c.[Domain6LessonsPassed_Percent]
			,c.[Strand1SkillsSuccessful]
			,c.[Strand1SkillsComplete]
			,c.[Strand1SkillsSuccessful_Percent]
			,c.[Strand2SkillsSuccessful]
			,c.[Strand2SkillsComplete]
			,c.[Strand2SkillsSuccessful_Percent]
			,c.[Strand3SkillsSuccessful]
			,c.[Strand3SkillsComplete]
			,c.[Strand3SkillsSuccessful_Percent]
			,c.[Strand4SkillsSuccessful]
			,c.[Strand4SkillsComplete]
			,c.[Strand4SkillsSuccessful_Percent]
			,c.[Strand5SkillsSuccessful]
			,c.[Strand5SkillsComplete]
			,c.[Strand5SkillsSuccessful_Percent]
			,c.[Strand6SkillsSuccessful]
			,c.[Strand6SkillsComplete]
			,c.[Strand6SkillsSuccessful_Percent]
			,c.[Strand7SkillsSuccessful]
			,c.[Strand7SkillsComplete]
			,c.[Strand7SkillsSuccessful_Percent]
			,c.[Strand8SkillsSuccessful]
			,c.[Strand8SkillsComplete]
			,c.[Strand8SkillsSuccessful_Percent]
			,c.[StrandCategory1LessonsPassed]
			,c.[StrandCategory1LessonsComplete]
			,c.[StrandCategory1LessonsPassed_Percent]
			,c.[StrandCategory2LessonsPassed]
			,c.[StrandCategory2LessonsComplete]
			,c.[StrandCategory2LessonsPassed_Percent]
			,c.[StrandCategory3LessonsPassed]
			,c.[StrandCategory3LessonsComplete]
			,c.[StrandCategory3LessonsPassed_Percent]
			,c.[WeekNumber]
			,c.[WeeklyAverageMinutes]
			,c.[WeeklyAverageLessonsPassed]
			,c.[WeeklyAverageLessonsCompleted]
			,c.[LessonsPassedTotal]
			,c.[LessonsCompletedTotal]
			,c.[CumulativePerformance]
			,c.[ProgressMontoringAchLevel]
			,c.[DistrictTimeGuidance]
			,c.[WeeklyAvgLessonsPassedGroup]
			,CASE WHEN c.[DateRange] = 'Weekly'
					AND c.[ProgressMontoringAchLevel] IN ('Proficient', 'Distinguished') THEN 'Proficient and Above' WHEN c.[DateRange] = 'Weekly'
					AND c.[ProgressMontoringAchLevel] IN ('Developing', 'Beginning') THEN 'Developing and Below' ELSE NULL END AS [ProgressMontoringAchLevelGroup]
			,CASE WHEN c.[DateRange] = 'Weekly'
					AND (
						c.DistrictTimeGuidance IS NULL
						OR c.DistrictTimeGuidance IN ('<30 Minutes', 'No Participation')
						) THEN '< 30 Minutes' WHEN c.[DateRange] = 'Weekly'
					AND c.DistrictTimeGuidance IN ('30-49 Minutes', '> 49 Minutes') THEN '>= 30 Minutes' ELSE NULL END AS [DistrictTimeGuidanceGroup]
			,s.[StudentNameWithID]
			,s.[StudentFullName]
			,s.[Gender]
			,s.[GenderLong]
			,s.[GradeLevel]
			,s.[ActiveEnrollmentDesc]
			,s.[ActiveYear]
			,s.[ActiveYearDesc]
			,s.[ActiveCalendarIDs]
			,s.[PersonID]
			,s.[StudentNumber]
			,s.[SchoolIdentifier]
			,s.[SchoolName]
			,s.[SchoolNameShort]
			,s.[SchoolLevel]
			,s.[SchoolCategory]
			,s.[Region]
			,s.[Cluster]
			,s.[RaceEthnicity]
			,s.[RaceEthnicityShort]
			,s.[ELIndicator]
			,s.[GiftedIndicator]
			,s.[MTSSIndicator]
			,s.[MTSSLevel]
			,s.[EIPRemedialIndicator]
			,s.[SWDIndicator]
			,s.[Disability1]
			,s.[S504Indicator]
			,s.[KITIndicator]
			,s.[EDIndicator]
			,s.[CohortYear]
			,s.[EstimatedCohortYear]
			,s.[Grade9Date]
			,s.[ServiceType]
			,s.[EnrollmentStartDate]
			,s.[EnrollmentStartStatus]
			,s.[EnrollmentStartStatusDesc]
			,s.[EnrollmentEndDate]
			,s.[EnrollmentEndStatus]
			,s.[EnrollmentEndStatusDesc]
			,s.[TitleI]
			,s.[CSI]
			,s.[ATSI]
			,s.[LEAIdentifier]
			,c.SchoolYear
			,s.[TenantId]
		FROM (
			SELECT *
				,CASE WHEN [DateRange] = 'Weekly'
						AND CumulativePerformance IS NULL THEN NULL WHEN [DateRange] = 'Weekly'
						AND CumulativePerformance < 0.7 THEN 'Beginning (0%-69%)' WHEN [DateRange] = 'Weekly'
						AND CumulativePerformance >= 0.7
						AND CumulativePerformance < 0.8 THEN 'Developing (70%-79%)' WHEN [DateRange] = 'Weekly'
						AND CumulativePerformance >= 0.8
						AND CumulativePerformance < 0.9 THEN 'Proficient (80%-89%)' WHEN [DateRange] = 'Weekly'
						AND CumulativePerformance >= 0.9
						AND CumulativePerformance <= 1 THEN 'Distinguished (90%-100%)' ELSE 'Validate' END AS [ProgressMontoringAchLevel]
				,CASE WHEN [DateRange] = 'Weekly'
						AND WeeklyAverageMinutes IS NULL THEN 'No Participation' WHEN [DateRange] = 'Weekly'
						AND WeeklyAverageMinutes = 0 THEN 'No Participation' WHEN [DateRange] = 'Weekly'
						AND WeeklyAverageMinutes < 30 THEN '<30 Minutes' WHEN [DateRange] = 'Weekly'
						AND WeeklyAverageMinutes >= 30
						AND WeeklyAverageMinutes < 50 THEN '30-49 Minutes' WHEN [DateRange] = 'Weekly'
						AND WeeklyAverageMinutes >= 50 THEN '> 49 Minutes' ELSE NULL END AS [DistrictTimeGuidance]
				,CASE WHEN [DateRange] = 'Weekly'
						AND (
							WeeklyAverageLessonsPassed IS NULL
							OR WeeklyAverageLessonsPassed < 2
							) THEN '<2 Lessons Passed' WHEN [DateRange] = 'Weekly'
						AND WeeklyAverageLessonsPassed >= 2 THEN '2+ Lessons Passed' ELSE NULL END AS [WeeklyAvgLessonsPassedGroup]
			FROM (
				SELECT *
					,CASE WHEN [DateRange] = 'Weekly'
							AND [LessonsCompletedTotal] IS NOT NULL
							AND [LessonsCompletedTotal] > 0
							AND [LessonsPassedTotal] IS NOT NULL THEN CAST([LessonsPassedTotal] * 1.0 / [LessonsCompletedTotal] AS DECIMAL(10, 4)) ELSE NULL END AS [CumulativePerformance]
				FROM (
					SELECT [LastName]
						,[FirstName]
						,[StudentID]
						,[StudentGrade]
						,[AcademicYear]
						,[School]
						,[Subject]
						,[Enrolled] AS [EnrollStatus]
						,[Classes]
						,[ClassTeachers]
						,[ReportGroups]
						,[DateRange]
						,[DateRangeStart]
						,[DateRangeEnd]
						,CONCAT (
							[DateRangeStart]
							,' - '
							,[DateRangeEnd]
							) AS [DateRangeWeek]
						,[TotalLessonTimeonTask_min]
						,[AllLessonsPassed]
						,[AllLessonsCompleted]
						,[PerAllLessonsPassed]
						,'i-Ready Phonological Awareness' AS [Domain1Name]
						,'i-Ready Phonics' AS [Domain2Name]
						,'i-Ready High-Frequency Words' AS [Domain3Name]
						,'i-Ready Vocabulary' AS [Domain4Name]
						,'i-Ready Comprehension' AS [Domain5Name]
						,'i-Ready Comprehension: Close Reading' AS [Domain6Name]
						,'i-Ready Pro Single Syllable' AS [Strand1Name]
						,'i-Ready Pro Multi-Syllable' AS [Strand2Name]
						,'i-Ready Pro Endings & Affixes' AS [Strand3Name]
						,'i-Ready Pro High-Frequency Words' AS [Strand4Name]
						,NULL AS [Strand5Name]
						,NULL AS [Strand6Name]
						,NULL AS [Strand7Name]
						,NULL AS [Strand8Name]
						,'i-Ready Pro Comprehension' AS [StrandCategory1Name]
						,'i-Ready Pro Vocabulary' AS [StrandCategory2Name]
						,'i-Ready Pro Language Structures' AS [StrandCategory3Name]
						,[iReadyPhonologicalAwareness_LessonsPassed] AS [Domain1LessonsPassed]
						,[iReadyPhonologicalAwareness_LessonsCompleted] AS [Domain1LessonsComplete]
						,[iReadyPhonologicalAwareness_PerLessonsPassed] AS [Domain1LessonsPassed_Percent]
						,[iReadyPhonics_LessonsPassed] AS [Domain2LessonsPassed]
						,[iReadyPhonics_LessonsCompleted] AS [Domain2LessonsComplete]
						,[iReadyPhonics_PerLessonsPassed] AS [Domain2LessonsPassed_Percent]
						,[iReadyHighFrequencyWords_LessonsPassed] AS [Domain3LessonsPassed]
						,[iReadyHighFrequencyWords_LessonsCompleted] AS [Domain3LessonsComplete]
						,[iReadyHighFrequencyWords_PerLessonsPassed] AS [Domain3LessonsPassed_Percent]
						,[iReadyVocabulary_LessonsPassed] AS [Domain4LessonsPassed]
						,[iReadyVocabulary_LessonsCompleted] AS [Domain4LessonsComplete]
						,[iReadyVocabulary_PerLessonsPassed] AS [Domain4LessonsPassed_Percent]
						,[iReadyComprehension_LessonsPassed] AS [Domain5LessonsPassed]
						,[iReadyComprehension_LessonsCompleted] AS [Domain5LessonsComplete]
						,[iReadyComprehension_PerLessonsPassed] AS [Domain5LessonsPassed_Percent]
						,[iReadyComprehension_CloseReading_LessonsPassed] AS [Domain6LessonsPassed]
						,[iReadyComprehension_CloseReading_LessonsCompleted] AS [Domain6LessonsComplete]
						,[iReadyComprehension_CloseReading_PerLessonsPassed] AS [Domain6LessonsPassed_Percent]
						,[iReadyProSingleSyllable_SkillsSuccessful] AS [Strand1SkillsSuccessful]
						,[iReadyProSingleSyllable_SkillsCompleted] AS [Strand1SkillsComplete]
						,[iReadyProSingleSyllable_PerSkillsSuccessful] AS [Strand1SkillsSuccessful_Percent]
						,[iReadyProMultiSyllable_SkillsSuccessful] AS [Strand2SkillsSuccessful]
						,[iReadyProMultiSyllable_SkillsCompleted] AS [Strand2SkillsComplete]
						,[iReadyProMultiSyllable_PerSkillsSuccessful] AS [Strand2SkillsSuccessful_Percent]
						,[iReadyProEndingsandAffixes_SkillsSuccessful] AS [Strand3SkillsSuccessful]
						,[iReadyProEndingsandAffixes_SkillsCompleted] AS [Strand3SkillsComplete]
						,[iReadyProEndingsandAffixes_PerSkillsSuccessful] AS [Strand3SkillsSuccessful_Percent]
						,[iReadyProHighFrequencyWords_SkillsSuccessful] AS [Strand4SkillsSuccessful]
						,[iReadyProHighFrequencyWords_SkillsCompleted] AS [Strand4SkillsComplete]
						,[iReadyProHighFrequencyWords_PerSkillsSuccessful] AS [Strand4SkillsSuccessful_Percent]
						,NULL AS [Strand5SkillsSuccessful]
						,NULL AS [Strand5SkillsComplete]
						,NULL AS [Strand5SkillsSuccessful_Percent]
						,NULL AS [Strand6SkillsSuccessful]
						,NULL AS [Strand6SkillsComplete]
						,NULL AS [Strand6SkillsSuccessful_Percent]
						,NULL AS [Strand7SkillsSuccessful]
						,NULL AS [Strand7SkillsComplete]
						,NULL AS [Strand7SkillsSuccessful_Percent]
						,NULL AS [Strand8SkillsSuccessful]
						,NULL AS [Strand8SkillsComplete]
						,NULL AS [Strand8SkillsSuccessful_Percent]
						,[iReadyProComprehension_LessonsPassed] AS [StrandCategory1LessonsPassed]
						,[iReadyProComprehension_LessonsCompleted] AS [StrandCategory1LessonsComplete]
						,[iReadyProComprehension_PerLessonsPassed] AS [StrandCategory1LessonsPassed_Percent]
						,[iReadyProVocabulary_LessonsPassed] AS [StrandCategory2LessonsPassed]
						,[iReadyProVocabulary_LessonsCompleted] AS [StrandCategory2LessonsComplete]
						,[iReadyProVocabulary_PerLessonsPassed] AS [StrandCategory2LessonsPassed_Percent]
						,[iReadyProLanguageStructures_LessonsPassed] AS [StrandCategory3LessonsPassed]
						,[iReadyProLanguageStructures_LessonsCompleted] AS [StrandCategory3LessonsComplete]
						,[iReadyProLanguageStructures_PerLessonsPassed] AS [StrandCategory3LessonsPassed_Percent]
						,CASE WHEN [DateRange] = 'Weekly'
								AND CAST([DateRangeStart] AS DATE) >= '2025-09-08' THEN DATEDIFF(WEEK, '2025-09-08', [DateRangeStart]) + 1 ELSE NULL END AS [WeekNumber]
						,CASE WHEN [DateRange] = 'Weekly'
								AND CAST([DateRangeStart] AS DATE) >= '2025-09-08'
								AND DATEDIFF(WEEK, '2025-09-08', CAST([DateRangeStart] AS DATE)) + 1 > 0
								AND CAST(ISNULL([TotalLessonTimeonTask_min], '0') AS DECIMAL(10, 2)) IS NOT NULL THEN CAST(CAST(ISNULL([TotalLessonTimeonTask_min], '0') AS DECIMAL(10, 2)) * 1.0 / (DATEDIFF(WEEK, '2025-09-08', CAST([DateRangeStart] AS DATE)) + 1) AS DECIMAL(10, 2)) ELSE NULL END AS [WeeklyAverageMinutes]
						,CASE WHEN [DateRange] = 'Weekly'
								AND CAST([DateRangeStart] AS DATE) >= '2025-09-08'
								AND DATEDIFF(WEEK, '2025-09-08', CAST([DateRangeStart] AS DATE)) + 1 > 0
								AND CAST(ISNULL([AllLessonsPassed], '0') AS DECIMAL(10, 2)) IS NOT NULL THEN CAST(CAST(ISNULL([AllLessonsPassed], '0') AS DECIMAL(10, 2)) * 1.0 / (DATEDIFF(WEEK, '2025-09-08', CAST([DateRangeStart] AS DATE)) + 1) AS DECIMAL(10, 2)) ELSE NULL END AS [WeeklyAverageLessonsPassed]
						,CASE WHEN [DateRange] = 'Weekly'
								AND CAST([DateRangeStart] AS DATE) >= '2025-09-08'
								AND DATEDIFF(WEEK, '2025-09-08', CAST([DateRangeStart] AS DATE)) + 1 > 0
								AND CAST(ISNULL([AllLessonsCompleted], '0') AS DECIMAL(10, 2)) IS NOT NULL THEN CAST(CAST(ISNULL([AllLessonsCompleted], '0') AS DECIMAL(10, 2)) * 1.0 / (DATEDIFF(WEEK, '2025-09-08', CAST([DateRangeStart] AS DATE)) + 1) AS DECIMAL(10, 2)) ELSE NULL END AS [WeeklyAverageLessonsCompleted]
						,CASE WHEN [DateRange] = 'Weekly'
								AND CAST([DateRangeStart] AS DATE) >= '2025-09-08' THEN SUM(CAST(ISNULL([AllLessonsPassed], '0') AS DECIMAL(10, 2))) OVER (
										PARTITION BY [SchoolYear]
										,[StudentID]
										,[StudentGrade]
										,[AcademicYear]
										,[School] ORDER BY CAST([DateRangeStart] AS DATE)
										) ELSE NULL END AS [LessonsPassedTotal]
						,CASE WHEN [DateRange] = 'Weekly'
								AND CAST([DateRangeStart] AS DATE) >= '2025-09-08' THEN SUM(CAST(ISNULL([AllLessonsCompleted], '0') AS DECIMAL(10, 2))) OVER (
										PARTITION BY [SchoolYear]
										,[StudentID]
										,[StudentGrade]
										,[AcademicYear]
										,[School] ORDER BY CAST([DateRangeStart] AS DATE)
										) ELSE NULL END AS [LessonsCompletedTotal]
						,[SchoolYear]
						,[TenantID]
					FROM [Main].[HenryInsights_Personalized_Instruction_Summary_Ela]
					
					UNION ALL
					
					SELECT [LastName]
						,[FirstName]
						,[StudentID]
						,[StudentGrade]
						,[AcademicYear]
						,[School]
						,[Subject]
						,[Enrolled] AS [EnrollStatus]
						,[Classes]
						,[ClassTeachers]
						,[ReportGroups]
						,[DateRange]
						,[DateRangeStart]
						,[DateRangeEnd]
						,CONCAT (
							[DateRangeStart]
							,' - '
							,[DateRangeEnd]
							) AS [DateRangeWeek]
						,[TotalLessonTimeonTask_min]
						,[AllLessonsPassed]
						,[AllLessonsCompleted]
						,[Per_AllLessonsPassed] AS [PerAllLessonsPassed]
						,'i-Ready Number and Operations' AS [Domain1Name]
						,'i-Ready Algebra and Algebraic Thinking' AS [Domain2Name]
						,'i-Ready Measurement and Data' AS [Domain3Name]
						,'i-Ready Geometry' AS [Domain4Name]
						,NULL AS [Domain5Name]
						,NULL AS [Domain6Name]
						,'i-Ready Pro Whole Numbers and Operations' AS [Strand1Name]
						,'i-Ready Pro Decimals and Operations' AS [Strand2Name]
						,'i-Ready Pro Fractions and Operations' AS [Strand3Name]
						,'i-Ready Pro Equations and Functions' AS [Strand4Name]
						,'i-Ready Pro Ratios and Proportions' AS [Strand5Name]
						,'i-Ready Pro Geometric Measurement and Figures' AS [Strand6Name]
						,'i-Ready Pro Data, Statistics, and Probability' AS [Strand7Name]
						,'i-Ready Pro Rational Numbers and Operations' AS [Strand8Name]
						,NULL AS [StrandCategory1Name]
						,NULL AS [StrandCategory2Name]
						,NULL AS [StrandCategory3Name]
						,[iReadyNumberandOperations_LessonsPassed] AS [Domain1LessonsPassed]
						,[iReadyNumberandOperations_LessonsCompleted] AS [Domain1LessonsComplete]
						,[iReadyNumberandOperations_Per_LessonsPassed] AS [Domain1LessonsPassed_Percent]
						,[iReadyAlgebraandAlgebraicThinking_LessonsPassed] AS [Domain2LessonsPassed]
						,[iReadyAlgebraandAlgebraicThinking_LessonsCompleted] AS [Domain2LessonsComplete]
						,[iReadyAlgebraandAlgebraicThinking_Per_LessonsPassed] AS [Domain2LessonsPassed_Percent]
						,[iReadyMeasurementandData_LessonsPassed] AS [Domain3LessonsPassed]
						,[iReadyMeasurementandData_LessonsCompleted] AS [Domain3LessonsComplete]
						,[iReadyMeasurementandData_Per_LessonsPassed] AS [Domain3LessonsPassed_Percent]
						,[iReadyGeometry_LessonsPassed] AS [Domain4LessonsPassed]
						,[iReadyGeometry_LessonsCompleted] AS [Domain4LessonsComplete]
						,[iReadyGeometry_Per_LessonsPassed] AS [Domain4LessonsPassed_Percent]
						,NULL AS [Domain5LessonsPassed]
						,NULL AS [Domain5LessonsComplete]
						,NULL AS [Domain5LessonsPassed_Percent]
						,NULL AS [Domain6LessonsPassed]
						,NULL AS [Domain6LessonsComplete]
						,NULL AS [Domain6LessonsPassed_Percent]
						,[iReadyProWholeNumbersandOperations_SkillsSuccessful] AS [Strand1SkillsSuccessful]
						,[iReadyProWholeNumbersandOperations_SkillsCompleted] AS [Strand1SkillsComplete]
						,[iReadyProWholeNumbersandOperations_Per_SkillsSuccessful] AS [Strand1SkillsSuccessful_Percent]
						,[iReadyProDecimalsandOperations_SkillsSuccessful] AS [Strand2SkillsSuccessful]
						,[iReadyProDecimalsandOperations_SkillsCompleted] AS [Strand2SkillsComplete]
						,[iReadyProDecimalsandOperations_Per_SkillsSuccessful] AS [Strand2SkillsSuccessful_Percent]
						,[iReadyProFractionsandOperations_SkillsSuccessful] AS [Strand3SkillsSuccessful]
						,[iReadyProFractionsandOperations_SkillsCompleted] AS [Strand3SkillsComplete]
						,[iReadyProFractionsandOperations_Per_SkillsSuccessful] AS [Strand3SkillsSuccessful_Percent]
						,[iReadyProEquationsandFunctions_SkillsSuccessful] AS [Strand4SkillsSuccessful]
						,[iReadyProEquationsandFunctions_SkillsCompleted] AS [Strand4SkillsComplete]
						,[iReadyProEquationsandFunctions_Per_SkillsSuccessful] AS [Strand4SkillsSuccessful_Percent]
						,[iReadyProRatiosandProportions_SkillsSuccessful] AS [Strand5SkillsSuccessful]
						,[iReadyProRatiosandProportions_SkillsCompleted] AS [Strand5SkillsComplete]
						,[iReadyProRatiosandProportions_Per_SkillsSuccessful] AS [Strand5SkillsSuccessful_Percent]
						,[iReadyProGeometricMeasurementandFigures_SkillsSuccessful] AS [Strand6SkillsSuccessful]
						,[iReadyProGeometricMeasurementandFigures_SkillsCompleted] AS [Strand6SkillsComplete]
						,[iReadyProGeometricMeasurementandFigures_Per_SkillsSuccessful] AS [Strand6SkillsSuccessful_Percent]
						,[iReadyProData_StatisticsandProbability_SkillsSuccessful] AS [Strand7SkillsSuccessful]
						,[iReadyProDataStatisticsandProbability_SkillsCompleted] AS [Strand7SkillsComplete]
						,[iReadyProDataStatisticsandProbability_Per_SkillsSuccessful] AS [Strand7SkillsSuccessful_Percent]
						,[iReadyProRationalNumbersandOperations_SkillsSuccessful] AS [Strand8SkillsSuccessful]
						,[iReadyProRationalNumbersandOperations_SkillsCompleted] AS [Strand8SkillsComplete]
						,[iReadyProRationalNumbersandOperations_Per_SkillsSuccessful] AS [Strand8SkillsSuccessful_Percent]
						,NULL AS [StrandCategory1LessonsPassed]
						,NULL AS [StrandCategory1LessonsComplete]
						,NULL AS [StrandCategory1LessonsPassed_Percent]
						,NULL AS [StrandCategory2LessonsPassed]
						,NULL AS [StrandCategory2LessonsComplete]
						,NULL AS [StrandCategory2LessonsPassed_Percent]
						,NULL AS [StrandCategory3LessonsPassed]
						,NULL AS [StrandCategory3LessonsComplete]
						,NULL AS [StrandCategory3LessonsPassed_Percent]
						,CASE WHEN [DateRange] = 'Weekly'
								AND CAST([DateRangeStart] AS DATE) >= '2025-09-08' THEN DATEDIFF(WEEK, '2025-09-08', [DateRangeStart]) + 1 ELSE NULL END AS [WeekNumber]
						,CASE WHEN [DateRange] = 'Weekly'
								AND CAST([DateRangeStart] AS DATE) >= '2025-09-08'
								AND DATEDIFF(WEEK, '2025-09-08', CAST([DateRangeStart] AS DATE)) + 1 > 0
								AND CAST(ISNULL([TotalLessonTimeonTask_min], '0') AS DECIMAL(10, 2)) IS NOT NULL THEN CAST(CAST(ISNULL([TotalLessonTimeonTask_min], '0') AS DECIMAL(10, 2)) * 1.0 / (DATEDIFF(WEEK, '2025-09-08', CAST([DateRangeStart] AS DATE)) + 1) AS DECIMAL(10, 2)) ELSE NULL END AS [WeeklyAverageMinutes]
						,CASE WHEN [DateRange] = 'Weekly'
								AND CAST([DateRangeStart] AS DATE) >= '2025-09-08'
								AND DATEDIFF(WEEK, '2025-09-08', CAST([DateRangeStart] AS DATE)) + 1 > 0
								AND CAST(ISNULL([AllLessonsPassed], '0') AS DECIMAL(10, 2)) IS NOT NULL THEN CAST(CAST(ISNULL([AllLessonsPassed], '0') AS DECIMAL(10, 2)) * 1.0 / (DATEDIFF(WEEK, '2025-09-08', CAST([DateRangeStart] AS DATE)) + 1) AS DECIMAL(10, 2)) ELSE NULL END AS [WeeklyAverageLessonsPassed]
						,CASE WHEN [DateRange] = 'Weekly'
								AND CAST([DateRangeStart] AS DATE) >= '2025-09-08'
								AND DATEDIFF(WEEK, '2025-09-08', CAST([DateRangeStart] AS DATE)) + 1 > 0
								AND CAST(ISNULL([AllLessonsCompleted], '0') AS DECIMAL(10, 2)) IS NOT NULL THEN CAST(CAST(ISNULL([AllLessonsCompleted], '0') AS DECIMAL(10, 2)) * 1.0 / (DATEDIFF(WEEK, '2025-09-08', CAST([DateRangeStart] AS DATE)) + 1) AS DECIMAL(10, 2)) ELSE NULL END AS [WeeklyAverageLessonsCompleted]
						,CASE WHEN [DateRange] = 'Weekly'
								AND CAST([DateRangeStart] AS DATE) >= '2025-09-08' THEN SUM(CAST(ISNULL([AllLessonsPassed], '0') AS DECIMAL(10, 2))) OVER (
										PARTITION BY [SchoolYear]
										,[StudentID]
										,[StudentGrade]
										,[AcademicYear]
										,[School] ORDER BY CAST([DateRangeStart] AS DATE)
										) ELSE NULL END AS [LessonsPassedTotal]
						,CASE WHEN [DateRange] = 'Weekly'
								AND CAST([DateRangeStart] AS DATE) >= '2025-09-08' THEN SUM(CAST(ISNULL([AllLessonsCompleted], '0') AS DECIMAL(10, 2))) OVER (
										PARTITION BY [SchoolYear]
										,[StudentID]
										,[StudentGrade]
										,[AcademicYear]
										,[School] ORDER BY CAST([DateRangeStart] AS DATE)
										) ELSE NULL END AS [LessonsCompletedTotal]
						,[SchoolYear]
						,[TenantID]
					FROM [Main].[HenryInsights_Personalized_Instruction_Summary_Math]
					) a
				) b
			) c
		JOIN (
			SELECT *
			FROM (
				SELECT [StudentNameWithID]
					,[StudentFullName]
					,[Gender]
					,[GenderLong]
					,[GradeLevel]
					,[ActiveEnrollmentDesc]
					,[ActiveYear]
					,[ActiveYearDesc]
					,[ActiveCalendarIDs]
					,[PersonID]
					,[StudentNumber]
					,[schoolID] AS [SchoolIdentifier]
					,[SchoolName]
					,[SchoolNameShort]
					,[SchoolLevel]
					,[SchoolCategory]
					,[Region]
					,[Cluster]
					,[RaceEthnicity]
					,[RaceEthnicityShort]
					,[ELLIndicator] AS [ELIndicator]
					,[GiftedIndicator]
					,[MTSSIndicator]
					,[MTSSLevel]
					,[EIPRemedialIndicator]
					,[SWDIndicator]
					,[Disability1]
					,[S504Indicator]
					,[KITIndicator]
					,[EDIndicator]
					,[CohortYear]
					,[EstimatedCohortYear]
					,[Grade9Date]
					,[ServiceType]
					,[EnrollmentStartDate]
					,[EnrollmentStartStatus]
					,[EnrollmentStartStatusDesc]
					,[EnrollmentEndDate]
					,[EnrollmentEndStatus]
					,[EnrollmentEndStatusDesc]
					,[TitleI]
					,[CSI]
					,[ATSI]
					,[LEAIdentifier]
					,[TenantId]
					,[endYear]
					,ROW_NUMBER() OVER (
						PARTITION BY personID
						,endyear ORDER BY activeEnrollment DESC
							,CAST(enrollmentStartDate AS DATE) DESC
							,mtsslevel DESC
						) rn
				FROM [dbo].[HCS_students_7YR] WITH (NOLOCK)
				WHERE servicetype = 'P'
					AND activeYear = 'Y'
				) hs
			WHERE hs.rn = 1
			) s ON REPLACE(c.[StudentID], 'S', '') = s.[studentNumber]
			AND c.[SchoolYear] = s.[EndYear]
			AND c.[TenantId] = s.[TenantId]
		WHERE c.[SchoolYear] = @SchoolYear
			AND c.[TenantId] = @TenantId

		--Noting Inserted Count
		SET @TotalRowsInserted = @@ROWCOUNT;

		--Updating Latest Year details
		UPDATE e
		SET [CurrentSchoolID] = s.[schoolID]
			,[CurrentSchoolName] = s.[schoolName]
			,[CurrentGrade] = rg.GradeDescription
		FROM dbo.HCS_Assessment_iReadyPIS e
		JOIN (
			SELECT *
				,ROW_NUMBER() OVER (
					PARTITION BY personID
					,endyear ORDER BY activeEnrollment DESC
						,cast(enrollmentStartDate AS DATE) DESC
						,mtsslevel DESC
					) AS rn
			FROM [HCS_students_7YR]
			WHERE endYear = @LatestYear
				AND serviceType = 'P'
				AND activeYear = 'Y'
			) s ON e.StudentNumber = s.[studentNumber]
			AND s.rn = 1
		INNER JOIN [dbo].[RefGrade] rg ON s.GradeLevel = rg.GradeCode
			AND s.Tenantid = rg.Tenantid

		EXEC [dbo].[USP_EnableAllIndexes] 'HCS_Assessment_iReadyPIS'

		UPDATE STATISTICS [dbo].[HCS_Assessment_iReadyPIS]

		-- Get row count after operation
		SELECT @TableRowsAfter = COUNT(*)
		FROM [HCS_Assessment_iReadyPIS];

		-- Record the end time
		SET @EndTime = CAST(SYSDATETIME() AS DATETIME)

		-- Calculate the elapsed time
		DECLARE @ElapsedTime INT = DATEDIFF(MILLISECOND, @StartTime, @EndTime);

		--Statistics Log Insertion
		INSERT INTO [dbo].[HCS_ProcessLogStatistics] (
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
			,@TenantId

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		-- Test whether the transaction is uncommittable.   
		IF XACT_STATE() = - 1
		BEGIN
			ROLLBACK TRAN
		END

		--Comment it if SP contains only SELECT statement                       
		DECLARE @ErrorFromProc VARCHAR(500)
		DECLARE @ProcErrorMessage VARCHAR(1000)
		DECLARE @SeverityLevel INT

		SELECT @ErrorFromProc = '[dbo].[CreateHCSAssessmentiReadyPIS]'
			,@ProcErrorMessage = Error_message() + ' ; Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + ' ; Error State: ' + CAST(ERROR_STATE() AS VARCHAR(10)) + ' ; Error Line: ' + CAST(ERROR_LINE() AS VARCHAR(10))
			,@SeverityLevel = Error_severity()

		INSERT INTO [dbo].[errorlogforusp] (
			ErrorFromProc
			,errormessage
			,severitylevel
			,datetimestamp
			,Tenantid
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



