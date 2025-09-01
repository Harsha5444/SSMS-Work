CREATE TABLE EH_StudentSummaryWithAllAss (
	[SchoolYear] VARCHAR(10)
	,[StudentId] VARCHAR(500)
	,[StudentSchool] VARCHAR(500)
	,[SchoolIdentifier] VARCHAR(500)
	,[DistrictStudentId] VARCHAR(500)
	,[StateStudentId] VARCHAR(500)
	,[StudentName] VARCHAR(500)
	,[Last_Name] VARCHAR(500)
	,[First_Name] VARCHAR(500)
	,[GradeCode] VARCHAR(500)
	,[Gender] VARCHAR(500)
	,[Team] VARCHAR(500)
	,[crdc_504] VARCHAR(500)
	,[SPED] VARCHAR(500)
	,[ELL] VARCHAR(500)
	,[HighNeeds] VARCHAR(500)
	,[Ethnicity] VARCHAR(500)
	,[EntryDate] VARCHAR(500)
	,[ExitDate] VARCHAR(500)
	,[COURSE_NUMBER] VARCHAR(500)
	,[COURSE_NAME] VARCHAR(500)
	,[SECTION_NUMBER] VARCHAR(500)
	,[SECTIONID] VARCHAR(500)
	,[TEACHERID] VARCHAR(500)
	,[DistrictStaffID] VARCHAR(500)
	,[Teacher] VARCHAR(500)
	,[TERMID] VARCHAR(500)
	,[Q1] VARCHAR(500)
	,[Q1_per] VARCHAR(500)
	,[Q2] VARCHAR(500)
	,[Q2_per] VARCHAR(500)
	,[E1] VARCHAR(500)
	,[E1_per] VARCHAR(500)
	,[S1] VARCHAR(500)
	,[S1_per] VARCHAR(500)
	,[Q3] VARCHAR(500)
	,[Q3_per] VARCHAR(500)
	,[Q4] VARCHAR(500)
	,[Q4_per] VARCHAR(500)
	,[E2] VARCHAR(500)
	,[E2_per] VARCHAR(500)
	,[S2] VARCHAR(500)
	,[S2_per] VARCHAR(500)
	,[SAT_TotalScore] VARCHAR(500)
	,[SAT_ReadingScore] VARCHAR(500)
	,[SAT_ReadingBenchmark] VARCHAR(500)
	,[SAT_ReadingMetScore] VARCHAR(500)
	,[SAT_MathScore] VARCHAR(500)
	,[SAT_MathBenchmark] VARCHAR(500)
	,[SAT_MathMetScore] VARCHAR(500)
	,[PSAT_TotalScore] VARCHAR(500)
	,[PSAT_ReadingScore] VARCHAR(500)
	,[PSAT_ReadingBenchmark] VARCHAR(500)
	,[PSAT_ReadingMetScore] VARCHAR(500)
	,[PSAT_MathScore] VARCHAR(500)
	,[PSAT_MathBenchmark] VARCHAR(500)
	,[PSAT_MathMetScore] VARCHAR(500)
	,[DIBELS_Reading_ScaleScore] VARCHAR(500)
	,[DIBELS_Reading_ProfLevel] VARCHAR(500)
	,[IAB_EnglishLanguageArts_ScaleScore] VARCHAR(500)
	,[IAB_EnglishLanguageArts_ProfLevel] VARCHAR(500)
	,[IAB_Mathematics_ScaleScore] VARCHAR(500)
	,[IAB_Mathematics_ProfLevel] VARCHAR(500)
	,[MathSkills_Mathematics_ScaleScore] VARCHAR(500)
	,[MathSkills_Mathematics_ProfLevel] VARCHAR(500)
	,[NGSS_Science_ScaleScore] VARCHAR(500)
	,[NGSS_Science_ProfLevel] VARCHAR(500)
	,[SBAC_EnglishLanguageArts_ScaleScore] VARCHAR(500)
	,[SBAC_EnglishLanguageArts_ProfLevel] VARCHAR(500)
	,[SBAC_Mathematics_ScaleScore] VARCHAR(500)
	,[SBAC_Mathematics_ProfLevel] VARCHAR(500)
	,[AssessmentYear] VARCHAR(500)
	,[TenantId] INT
	);

--truncate table EH_StudentSummaryWithAllAss

INSERT INTO EH_StudentSummaryWithAllAss
SELECT s.SchoolYear 
	,s.StudentId
	,sch.NameofInstitution AS StudentSchool
	,sch.SchoolIdentifier
	,s.DistrictStudentId
	,s.StateStudentId
	,s.last_name + ', ' + s.first_name StudentName
	,s.Last_Name
	,s.First_Name
	,s.GradeCode
	,s.Gender
	,s.Team
	,CASE WHEN s.C_504_STATUS = 1 THEN 'Y' ELSE 'N' END AS crdc_504
	,s.SPECIALEDUCATION AS SPED
	,s.ELLIndicator AS ELL
	,CASE WHEN (
				s.SPECIALEDUCATION = 'Y'
				OR s.ELLIndicator = 'Y'
				) THEN 'Y' ELSE 'N' END AS HighNeeds
	,CASE WHEN s.racecd = 'H' THEN 'Hisp/Latino' WHEN s.racecd = 'M' THEN 'Multi' WHEN s.racecd = 'I' THEN 'Amer Indian/Alaskan' WHEN s.racecd = 'A' THEN 'Asian' WHEN s.racecd = 'B' THEN 'Black/African Amer' WHEN s.racecd = 'P' THEN 'Hawaiian/Pac Islander' WHEN s.racecd = 'W' THEN 'White' ELSE 'Unknown' END AS Ethnicity
	,s.EntryDate
	,s.ExitDate
	,ss.COURSE_NUMBER
	,ss.COURSE_NAME
	,ss.SECTION_NUMBER
	,ss.SECTIONID
	,ss.TEACHERID
	,ss.TEACHERNUMBER AS DistrictStaffID
	,NULL AS Teacher
	,se.TERMID
	,sg.Q1Grade AS Q1
	,sg.Q1Percent AS Q1_per
	,sg.Q2Grade AS Q2
	,sg.Q2Percent AS Q2_per
	,sg.E1Grade AS E1
	,sg.E1Percent AS E1_per
	,sg.S1Grade AS S1
	,sg.S1Percent AS S1_per
	,sg.Q3Grade AS Q3
	,sg.Q3Percent AS Q3_per
	,sg.Q4Grade AS Q4
	,sg.Q4Percent AS Q4_per
	,sg.E2Grade AS E2
	,sg.E2Percent AS E2_per
	,sg.S2Grade AS S2
	,sg.S2Percent AS S2_per
	,w.SAT_TotalScore
	,w.SAT_ReadingScore
	,w.SAT_ReadingBenchmark
	,CASE WHEN w.SAT_ReadingScore >= w.SAT_ReadingMetScore THEN 'Yes' WHEN w.SAT_ReadingMetScore IS NULL THEN NULL ELSE 'No' END SAT_ReadingMetScore
	,w.SAT_MathScore
	,w.SAT_MathBenchmark
	,CASE WHEN w.SAT_MathScore >= w.SAT_MathMetScore THEN 'Yes' WHEN w.SAT_MathMetScore IS NULL THEN NULL ELSE 'No' END SAT_MathMetScore
	,w.PSAT_TotalScore
	,w.PSAT_ReadingScore
	,w.PSAT_ReadingBenchmark
	,CASE WHEN w.PSAT_ReadingScore >= w.PSAT_ReadingMetScore THEN 'Yes' WHEN w.PSAT_ReadingMetScore IS NULL THEN NULL ELSE 'No' END PSAT_ReadingMetScore
	,w.PSAT_MathScore
	,w.PSAT_MathBenchmark
	,CASE WHEN w.PSAT_MathScore >= w.PSAT_MathMetScore THEN 'Yes' WHEN w.PSAT_MathMetScore IS NULL THEN NULL ELSE 'No' END PSAT_MathMetScore
	,NULL AS [DIBELS_Reading_ScaleScore]
	,NULL AS [DIBELS_Reading_ProfLevel]
	,NULL AS [IAB_English Language Arts_ScaleScore]
	,NULL AS [IAB_English Language Arts_ProfLevel]
	,NULL AS [IAB_Mathematics_ScaleScore]
	,NULL AS [IAB_Mathematics_ProfLevel]
	,NULL AS [MathSkills_Mathematics_ScaleScore]
	,NULL AS [MathSkills_Mathematics_ProfLevel]
	,NULL AS [NGSS_Science_ScaleScore]
	,NULL AS [NGSS_Science_ProfLevel]
	,NULL AS [SBAC_English Language Arts_ScaleScore]
	,NULL AS [SBAC_English Language Arts_ProfLevel]
	,NULL AS [SBAC_Mathematics_ScaleScore]
	,NULL AS [SBAC_Mathematics_ProfLevel]
	,NULL AS AssessmentYear
	,35 AS TenantId
FROM (
	SELECT *
	FROM (
		SELECT SchoolYear
			,StudentId
			,Student_Number AS DistrictStudentId
			,State_Studentnumber AS StateStudentId
			,Grade_Level AS GradeCode
			,EntryDate
			,Schoolid AS SchoolIdentifier
			,Last_Name
			,First_Name
			,Gender
			,Team
			,C_504_STATUS
			,SpecialEducation
			,ELLIndicator
			,RaceCD
			,ExitDate
			,Tenantid
			,ROW_NUMBER() OVER (
				PARTITION BY SchoolYear
				,student_number ORDER BY cast(entrydate AS DATE) DESC
				) RN
		FROM main.EH_Students
		WHERE SchoolYear IN (2025, 2024, 2023)
		) R
	WHERE RN = 1
	) s
INNER JOIN main.k12school sch ON s.SchoolIdentifier = sch.SchoolIdentifier
	AND s.Schoolyear = sch.Schoolyear
	AND s.Tenantid = sch.Tenantid
INNER JOIN main.EH_StudentSections ss ON s.DistrictStudentId = ss.STUDENT_NUMBER
	AND s.SchoolIdentifier = ss.SCHOOLID
	AND s.SchoolYear = ss.SchoolYear
	AND s.TenantId = ss.TenantId
INNER JOIN main.EH_Sections se ON ss.SECTION_NUMBER = se.SECTION_NUMBER
	AND ss.COURSE_NUMBER = se.COURSE_NUMBER
	AND ss.SCHOOLID = se.SCHOOLID
	AND ss.SchoolYear = se.SchoolYear
LEFT JOIN (
	SELECT *
	FROM (
		SELECT SchoolYear
			,section_number
			,[SchoolID] AS SchoolIdentifier
			,[TermID]
			,[StudentID] AS DistrictStudentId
			,StoreCode + code AS [Code]
			,[Value]
		FROM (
			SELECT *
			FROM (
				SELECT SchoolYear
					,section_number AS section_number
					,[StoreCode]
					,[Grade]
					,grade_percent AS [percent]
					,[SchoolID]
					,[TermID]
					,student_number AS [StudentID]
				FROM [main].[EH_StoredGrades]
				) p
			unpivot([Value] FOR [Code] IN ([grade], [percent])) f
			) a
		WHERE value <> ''
		) g
	pivot(max([Value]) FOR code IN ([E1Grade], [E2Grade], [Q1Grade], [Q2Grade], [Q3Grade], [Q4Grade], [S1Grade], [S2Grade], [E1Percent], [E2Percent], [Q1Percent], [Q2Percent], [Q3Percent], [Q4Percent], [S1Percent], [S2Percent])) l
	) sg ON sg.DistrictStudentId = s.DistrictStudentId
	AND sg.section_number = ss.section_number
	AND s.schoolyear = sg.SchoolYear
	AND se.TERMID = sg.TERMID
LEFT JOIN (
	SELECT *
	FROM (
		SELECT [schoolyear]
			,[SchoolIdentifier]
			,[DistrictStudentId]
			,[Assessmentcode] + '_' + [Col] AS [Assessment]
			,[Value]
			,[TenantId]
		FROM (
			SELECT l.schoolyear
				,l.SchoolIdentifier
				,l.DistrictStudentId
				,l.Assessmentcode
				,cast((cast(l.Reading AS INT) + cast(l.Math AS INT)) AS VARCHAR) AS TotalScore
				,cast(l.Reading AS VARCHAR) ReadingScore
				,cast(b.benchmarklevel AS VARCHAR) AS ReadingBenchmark
				,cast(b.MET_YN AS VARCHAR) AS ReadingMetScore
				,cast(l.Math AS VARCHAR) AS MathScore
				,cast(d.benchmarklevel AS VARCHAR) AS MathBenchmark
				,cast(d.MET_YN AS VARCHAR) AS MathMetScore
				,l.TenantId
			FROM (
				SELECT ss.schoolyear
					,se.SCHOOLID SchoolIdentifier
					,se.STUDENT_NUMBER DistrictStudentId
					,'SAT' AS Assessmentcode
					,max([LATEST_SAT_EBRW]) Reading
					,max([LATEST_SAT_MATH_SECTION]) Math
					,CASE WHEN ss.LATEST_SAT_GRADE = '2' THEN '08' WHEN ss.LATEST_SAT_GRADE = '4' THEN '09' WHEN ss.LATEST_SAT_GRADE = '5' THEN '10' WHEN ss.LATEST_SAT_GRADE = '6' THEN '11' WHEN ss.LATEST_SAT_GRADE = '7' THEN '12' ELSE ss.LATEST_SAT_GRADE END AS SATGrade
					,ss.TenantId
				FROM Main.EH_SAT ss
				INNER JOIN (
					SELECT DISTINCT STATE_STUDENTNUMBER
						,STUDENT_NUMBER
						,schoolyear
						,TenantId
						,SCHOOLID
					FROM [Main].[EH_Students]
					) se ON ss.STATE_STUDENT_ID = se.STATE_STUDENTNUMBER
					AND ss.schoolyear = se.schoolyear
					AND ss.TenantId = se.TenantId
				GROUP BY ss.schoolyear
					,se.SCHOOLID
					,se.STUDENT_NUMBER
					,ss.LATEST_SAT_GRADE
					,ss.TenantId
				
				UNION
				
				SELECT ss.schoolyear
					,se.SCHOOLID SchoolIdentifier
					,ss.SECONDARY_ID DistrictStudentId
					,'PSAT' [AssessmentCode]
					,max([LATEST_PSAT_EBRW]) Reading
					,max([LATEST_PSAT_MATH_SECTION]) Math
					,CASE WHEN ss.LATEST_PSAT_GRADE = '2' THEN '8' WHEN ss.LATEST_PSAT_GRADE IN ('4', '14', '15') THEN '9' WHEN ss.LATEST_PSAT_GRADE = '5' THEN '10' WHEN ss.LATEST_PSAT_GRADE = '6' THEN '11' WHEN ss.LATEST_PSAT_GRADE = '7' THEN '12' ELSE isnull(ss.LATEST_PSAT_GRADE, se.GRADE_LEVEL) END AS SATGrade
					,ss.TenantId
				FROM Main.EH_PSAT ss
				INNER JOIN [Main].[EH_Students] se ON ss.SECONDARY_ID = se.Student_Number
					AND ss.schoolyear = se.schoolyear
				GROUP BY ss.schoolyear
					,se.SCHOOLID
					,ss.SECONDARY_ID
					,ss.LATEST_PSAT_GRADE
					,ss.TenantId
					,se.GRADE_LEVEL
				) l
			INNER JOIN (
				SELECT *
				FROM eh_SAT_PSAT_BenchmarkRanges
				WHERE Subject = 'Reading and Writing'
				) b ON (CASE WHEN l.AssessmentCode IN ('PSAT89', 'PSATNM') THEN 'PSAT' ELSE l.AssessmentCode END) = b.AssessmentCode
				AND isnull((CASE WHEN l.AssessmentCode = 'SAT' THEN NULL ELSE l.SATGrade END), 0) = isnull(cast(b.Grade AS INT), 0)
				AND l.Reading BETWEEN b.MinScore
					AND b.MaxScore
			INNER JOIN (
				SELECT *
				FROM eh_SAT_PSAT_BenchmarkRanges
				WHERE Subject = 'Math'
				) d ON (CASE WHEN l.AssessmentCode IN ('PSAT89', 'PSATNM') THEN 'PSAT' ELSE l.AssessmentCode END) = d.AssessmentCode
				AND isnull((CASE WHEN l.AssessmentCode = 'SAT' THEN NULL ELSE l.SATGrade END), 0) = isnull(cast(d.Grade AS INT), 0)
				AND l.Math BETWEEN d.MinScore
					AND d.MaxScore
			WHERE l.SchoolYear IN (2023, 2024, 2025)
			) k
		unpivot([Value] FOR [Col] IN ([TotalScore], [ReadingScore], [ReadingBenchmark], [ReadingMetScore], [MathScore], [MathBenchmark], [MathMetScore])) f
		) h
	pivot(max([Value]) FOR [Assessment] IN ([SAT_TotalScore], [SAT_ReadingScore], [SAT_ReadingBenchmark], [SAT_ReadingMetScore], [SAT_MathScore], [SAT_MathBenchmark], [SAT_MathMetScore], [PSAT_TotalScore], [PSAT_ReadingScore], [PSAT_ReadingBenchmark], [PSAT_ReadingMetScore], [PSAT_MathScore], [PSAT_MathBenchmark], [PSAT_MathMetScore])) l
	) w ON w.schoolyear = s.SchoolYear
	AND w.DistrictStudentId = s.DistrictStudentId

/*
================================================================================
UPDATING ASSESSMENT DATA TO 'NULL'
================================================================================
*/
UPDATE ss
SET ss.[DIBELS_Reading_ScaleScore] = NULL
	,ss.[DIBELS_Reading_ProfLevel] = NULL
	,ss.[IAB_EnglishLanguageArts_ScaleScore] = NULL
	,ss.[IAB_EnglishLanguageArts_ProfLevel] = NULL
	,ss.[IAB_Mathematics_ScaleScore] = NULL
	,ss.[IAB_Mathematics_ProfLevel] = NULL
	,ss.[MathSkills_Mathematics_ScaleScore] = NULL
	,ss.[MathSkills_Mathematics_ProfLevel] = NULL
	,ss.[NGSS_Science_ScaleScore] = NULL
	,ss.[NGSS_Science_ProfLevel] = NULL
	,ss.[SBAC_EnglishLanguageArts_ScaleScore] = NULL
	,ss.[SBAC_EnglishLanguageArts_ProfLevel] = NULL
	,ss.[SBAC_Mathematics_ScaleScore] = NULL
	,ss.[SBAC_Mathematics_ProfLevel] = NULL
FROM EH_StudentSummaryWithAllAss ss

/*
================================================================================
UPDATING ('SBAC', 'NGSS', 'MathSkills', 'IAB', 'DIBELS') ASSESSMENT DATA 
================================================================================
*/
UPDATE ss
SET ss.DIBELS_Reading_ProfLevel = r.DIBELS_Reading_ProfLevel
	,ss.DIBELS_Reading_ScaleScore = r.DIBELS_Reading_ScaleScore
	,ss.IAB_EnglishLanguageArts_ProfLevel = r.IAB_EnglishLanguageArts_ProfLevel
	,ss.IAB_EnglishLanguageArts_ScaleScore = r.IAB_EnglishLanguageArts_ScaleScore
	,ss.IAB_Mathematics_ProfLevel = r.IAB_Mathematics_ProfLevel
	,ss.IAB_Mathematics_ScaleScore = r.IAB_Mathematics_ScaleScore
	,ss.MathSkills_Mathematics_ProfLevel = r.MathSkills_Mathematics_ProfLevel
	,ss.MathSkills_Mathematics_ScaleScore = r.MathSkills_Mathematics_ScaleScore
	,ss.NGSS_Science_ProfLevel = r.NGSS_Science_ProfLevel
	,ss.NGSS_Science_ScaleScore = r.NGSS_Science_ScaleScore
	,ss.SBAC_EnglishLanguageArts_ProfLevel = r.SBAC_EnglishLanguageArts_ProfLevel
	,ss.SBAC_EnglishLanguageArts_ScaleScore = r.SBAC_EnglishLanguageArts_ScaleScore
	,ss.SBAC_Mathematics_ProfLevel = r.SBAC_Mathematics_ProfLevel
	,ss.SBAC_Mathematics_ScaleScore = r.SBAC_Mathematics_ScaleScore
FROM EH_StudentSummaryWithAllAss ss
INNER JOIN (
	SELECT TenantId
		,schoolyear
		,districtstudentid
		,schoolidentifier
		,MAX([DIBELS_Reading_ProfLevel]) AS [DIBELS_Reading_ProfLevel]
		,MAX([DIBELS_Reading_ScaleScore]) AS [DIBELS_Reading_ScaleScore]
		,MAX([IAB_English Language Arts_ProfLevel]) AS [IAB_EnglishLanguageArts_ProfLevel]
		,MAX([IAB_English Language Arts_ScaleScore]) AS [IAB_EnglishLanguageArts_ScaleScore]
		,MAX([IAB_Mathematics_ProfLevel]) AS [IAB_Mathematics_ProfLevel]
		,MAX([IAB_Mathematics_ScaleScore]) AS [IAB_Mathematics_ScaleScore]
		,MAX([MathSkills_Mathematics_ProfLevel]) AS [MathSkills_Mathematics_ProfLevel]
		,MAX([MathSkills_Mathematics_ScaleScore]) AS [MathSkills_Mathematics_ScaleScore]
		,MAX([NGSS_Science_ProfLevel]) AS [NGSS_Science_ProfLevel]
		,MAX([NGSS_Science_ScaleScore]) AS [NGSS_Science_ScaleScore]
		,MAX([SBAC_English Language Arts_ProfLevel]) AS [SBAC_EnglishLanguageArts_ProfLevel]
		,MAX([SBAC_English Language Arts_ScaleScore]) AS [SBAC_EnglishLanguageArts_ScaleScore]
		,MAX([SBAC_Mathematics_ProfLevel]) AS [SBAC_Mathematics_ProfLevel]
		,MAX([SBAC_Mathematics_ScaleScore]) AS [SBAC_Mathematics_ScaleScore]
	FROM (
		SELECT TenantId
			,schoolyear
			,districtstudentid
			,schoolidentifier
			,[DIBELS_Reading_ProfLevel]
			,[DIBELS_Reading_ScaleScore]
			,[IAB_English Language Arts_ProfLevel]
			,[IAB_English Language Arts_ScaleScore]
			,[IAB_Mathematics_ProfLevel]
			,[IAB_Mathematics_ScaleScore]
			,[MathSkills_Mathematics_ProfLevel]
			,[MathSkills_Mathematics_ScaleScore]
			,[NGSS_Science_ProfLevel]
			,[NGSS_Science_ScaleScore]
			,[SBAC_English Language Arts_ProfLevel]
			,[SBAC_English Language Arts_ScaleScore]
			,[SBAC_Mathematics_ProfLevel]
			,[SBAC_Mathematics_ScaleScore]
		FROM (
			SELECT DISTINCT TenantId
				,schoolyear
				,districtstudentid
				,schoolidentifier
				,Assessment
				,SubjectAreaName
				,Assessment + '_' + SubjectAreaName + '_ProfLevel' AS ColumnName
				,ProficiencyDescription AS SValue
			FROM EHAssessmentAllDS_Vw
			WHERE IsLatest = 1
				AND ProficiencyDescription IS NOT NULL
				AND AssessmentCode IN ('SBAC', 'NGSS', 'MathSkills', 'IAB', 'DIBELS')
				AND SchoolYear IN (2025, 2024, 2023)
			
			UNION ALL
			
			SELECT DISTINCT TenantId
				,schoolyear
				,districtstudentid
				,schoolidentifier
				,Assessment
				,SubjectAreaName
				,Assessment + '_' + SubjectAreaName + '_ScaleScore' AS ColumnName
				,CAST(ScaleScore AS VARCHAR) AS SValue
			FROM EHAssessmentAllDS_Vw
			WHERE IsLatest = 1
				AND assessment IS NOT NULL
				AND AssessmentCode IN ('SBAC', 'NGSS', 'MathSkills', 'IAB', 'DIBELS')
				AND SchoolYear IN (2025, 2024, 2023)
			) AS source
		PIVOT(MAX(SValue) FOR ColumnName IN ([DIBELS_Reading_ProfLevel], [DIBELS_Reading_ScaleScore], [IAB_English Language Arts_ProfLevel], [IAB_English Language Arts_ScaleScore], [IAB_Mathematics_ProfLevel], [IAB_Mathematics_ScaleScore], [MathSkills_Mathematics_ProfLevel], [MathSkills_Mathematics_ScaleScore], [NGSS_Science_ProfLevel], [NGSS_Science_ScaleScore], [SBAC_English Language Arts_ProfLevel], [SBAC_English Language Arts_ScaleScore], [SBAC_Mathematics_ProfLevel], [SBAC_Mathematics_ScaleScore])) AS p
		) pivot_results
	GROUP BY TenantId
		,schoolyear
		,districtstudentid
		,schoolidentifier
	) r ON ss.DistrictStudentId = r.DistrictStudentId
	AND ss.schoolyear = r.schoolyear

/*
================================================================================
UPDATING 'Teacher Name'
================================================================================
*/
UPDATE ss
SET ss.Teacher = se.firstname + ' ' + se.LastOrSurname
FROM EH_StudentSummaryWithAllAss ss
INNER JOIN Main.K12StaffDemographics se ON ss.districtstaffid = se.districtstaffid
WHERE se.tenantid = 35