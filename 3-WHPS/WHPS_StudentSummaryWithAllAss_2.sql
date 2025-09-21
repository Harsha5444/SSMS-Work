--truncate table WHPS_StudentSummaryWithAllAss
--INSERT INTO WHPS_StudentSummaryWithAllAss
SELECT s.SchoolYear
	,s.StudentId
	,sch.NameofInstitution AS StudentSchool
	,sch.SchoolIdentifier
	,s.Student_Number
	,s.state_studentnumber AS SASID
	,s.last_name + ', ' + s.first_name StudentName
	,s.last_name
	,s.first_name
	,s.GRADE_LEVEL
	,s.gender AS gender
	,CASE WHEN s.C_504_STATUS = 1 THEN 'Y' ELSE 'N' END AS crdc_504
	,s.SPECIALEDUCATION AS sped
	,s.ELLIndicator AS ell
	,CASE WHEN (
				s.SPECIALEDUCATION = 'Y'
				OR s.ELLIndicator = 'Y'
				) THEN 'Y' ELSE 'N' END AS highneeds
	,CASE WHEN s.racecd = 'H' THEN 'Hisp/Latino' WHEN s.racecd = 'M' THEN 'Multi' WHEN s.racecd = 'I' THEN 'Amer Indian/Alaskan' WHEN s.racecd = 'A' THEN 'Asian' WHEN s.racecd = 'B' THEN 'Black/African Amer' WHEN s.racecd = 'P' THEN 'Hawaiian/Pac Islander' WHEN s.racecd = 'W' THEN 'White' ELSE 'Unknown' END AS ETHNICITY
	,ISNULL(uf.WH_Counselor, '--') AS counselor
	,ISNULL(g.[GEN Value], '--') AS dept
	,x.course_number
	,x.section_number
	,C.course_name
	,x.external_expression AS exp
	,x.termid AS termid
	,CASE WHEN tm.isyearrec = 1 THEN 'FY' ELSE 'tm.abbreviation' END AS termname
	,t.lastfirst AS Teacher
	,t.TeacherNumber DistrictStaffID
	,x.room
	,cc.currenttardies
	,cc.currentabsences
	,uf.wh_parentcombinedname AS parentcombinedname
	,uf.wh_elemzone AS el_zone
	,uf.wh_middlezone AS ms_zone
	,uf.wh_highzone AS hs_zone
	,CASE WHEN op.SpecialProgramStatusCode IS NOT NULL THEN 'Yes' ELSE op.SpecialProgramStatusCode END OpenChoice
	,Q1Grade AS Q1
	,Q1Percent AS Q1_per
	,Q2Grade AS Q2
	,Q2Percent AS Q2_per
	,E1Grade AS E1
	,E1Percent AS E1_per
	,S1Grade AS S1
	,S1Percent AS S1_per
	,Q3Grade AS Q3
	,Q3Percent AS Q3_per
	,Q4Grade AS Q4
	,Q4Percent AS Q4_per
	,E2Grade AS E2
	,E2Percent AS E2_per
	,S2Grade AS S2
	,S2Percent AS S2_per
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
	,NULL AS [AIMSWebPlus_Mathematics_ProfLevel]
	,NULL AS [AIMSWebPlus_Mathematics_ScaleScore]
	,NULL AS [AIMSWebPlus_OralReadingFluency_ProfLevel]
	,NULL AS [AIMSWebPlus_OralReadingFluency_ScaleScore]
	,NULL AS [AIMSWebPlus_Reading_ProfLevel]
	,NULL AS [AIMSWebPlus_Reading_ScaleScore]
	,NULL AS [i-Ready_Mathematics_ProfLevel]
	,NULL AS [i-Ready_Mathematics_ScaleScore]
	,NULL AS [i-Ready_Reading_ProfLevel]
	,NULL AS [i-Ready_Reading_ScaleScore]
	,NULL AS [NGSS_Science_ProfLevel]
	,NULL AS [NGSS_Science_ScaleScore]
	,NULL AS [SBAC_EnglishLanguageArts_ProfLevel]
	,NULL AS [SBAC_EnglishLanguageArts_ScaleScore]
	,NULL AS [SBAC_Mathematics_ProfLevel]
	,NULL AS [SBAC_Mathematics_ScaleScore]
	,NULL AS [STAR_Reading_ProfLevel]
	,NULL AS [STAR_Reading_ScaleScore]
	,NULL AssessmentYear
	,38 TenantID
--INTO WHPS_StudentSummaryWithAllAss
FROM (
	SELECT *
	FROM (
		SELECT SchoolYear
			,StudentId
			,student_number
			,state_studentnumber
			,Grade_Level
			,entrydate
			,Schoolid
			,last_name
			,first_name
			,gender
			,C_504_STATUS
			,SPECIALEDUCATION
			,ELLIndicator
			,racecd
			,exitdate
			,Tenantid
			,ROW_NUMBER() OVER (
				PARTITION BY SchoolYear
				,student_number ORDER BY cast(entrydate AS DATE) DESC
				) RN
		FROM Main.WHPS_Students
		WHERE SchoolYear IN (2025, 2024, 2023)
		) R
	WHERE RN = 1
	) s
INNER JOIN main.k12school sch ON s.schoolid = sch.SchoolIdentifier
	AND s.Schoolyear = sch.Schoolyear
	AND s.Tenantid = sch.Tenantid
INNER JOIN [dbo].[WHPS_CC_export] cc ON cc.studentid = s.STUDENTID
	AND cast(cc.dateenrolled AS DATE) BETWEEN cast(s.entrydate AS DATE)
		AND cast(s.exitdate AS DATE)
INNER JOIN [dbo].[WHPS_Sections_export] x ON cc.sectionid = x.[ID]
INNER JOIN [dbo].[WHPS_Teachers_export] t ON x.teacher = t.id
INNER JOIN [dbo].[WHPS_Courses_export] C ON x.course_number = C.course_number
INNER JOIN [dbo].[WHPS_Terms_export] tm ON tm.id = x.[TermID]
	AND tm.schoolid = x.[SchoolID]
LEFT JOIN [dbo].[WHPS_Gen_export] g ON g.[gen name] = C.sched_department
	AND g.[gen cat] = 'dept_rename'
	AND C.sched_department = g.[gen name]
LEFT JOIN (
	SELECT *
	FROM (
		SELECT [SectionID]
			,[SchoolID]
			,[TermID]
			,[StudentID]
			,StoreCode + code AS [Code]
			,[Value]
		FROM (
			SELECT *
			FROM (
				SELECT [SectionID]
					,[StoreCode]
					,[Grade]
					,[percent]
					,[SchoolID]
					,[TermID]
					,[StudentID]
				FROM [WHPS_StoredGrades_export]
				) p
			unpivot([Value] FOR [Code] IN ([grade], [percent])) f
			) a
		WHERE value <> ''
		) g
	pivot(max([Value]) FOR code IN ([E1Grade], [E2Grade], [Q1Grade], [Q2Grade], [Q3Grade], [Q4Grade], [S1Grade], [S2Grade], [E1Percent], [E2Percent], [Q1Percent], [Q2Percent], [Q3Percent], [Q4Percent], [S1Percent], [S2Percent])) l
	) sg ON sg.studentid = s.STUDENTID
	AND sg.sectionid = x.[ID]
	AND sg.TermID = x.[TermID]
LEFT JOIN [dbo].[WHPS_U_STUDENTSUSERFIELDS_export] uf ON uf.Student_Number = s.STUDENT_NUMBER
	AND uf.StudentsDCID = s.Studentid
LEFT JOIN [dbo].[WHPS_S_CT_STU_X_export] op ON op.Student_Number = s.STUDENT_NUMBER
	AND op.StudentsDCID = s.Studentid
	AND op.SpecialProgramStatusCode IN (02, 12)
--SAT_PSAT AssessmentBlock
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
				--,ROW_NUMBER() OVER (
				--	PARTITION BY STATE_STUDENT_ID
				--	,ss.SchoolYear ORDER BY [LATEST_SAT_EBRW],[LATEST_SAT_MATH_SECTION]  DESC
				--	) AS rn
				FROM Main.WHPS_SAT_Source ss
				INNER JOIN (
					SELECT DISTINCT STATE_STUDENTNUMBER
						,STUDENT_NUMBER
						,schoolyear
						,TenantId
						,SCHOOLID
					FROM [Main].[WHPS_Students]
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
				--,ROW_NUMBER() OVER (
				--	PARTITION BY DISTRICT_STUDENT_ID
				--	,STATE_STUDENT_ID
				--	,ss.SchoolYear ORDER BY cast(LATEST_PSAT_DATE AS DATE) DESC
				--	) AS rn
				FROM Main.WHPS_PSATNM_Source ss
				INNER JOIN [Main].[WHPS_Students] se ON ss.SECONDARY_ID = se.Student_Number
					AND ss.schoolyear = se.schoolyear
				GROUP BY ss.schoolyear
					,se.SCHOOLID
					,ss.SECONDARY_ID
					,ss.LATEST_PSAT_GRADE
					,ss.TenantId
					,se.GRADE_LEVEL
				
				UNION
				
				SELECT ss.schoolyear
					,se.SCHOOLID SchoolIdentifier
					,ss.SECONDARY_ID DistrictStudentId
					,'PSAT' [AssessmentCode]
					,max(LATEST_PSAT_EBRW) Reading
					,max([LATEST_PSAT_MATH_SECTION]) Math
					,CASE WHEN ss.LATEST_PSAT_GRADE = '2' THEN '8' WHEN ss.LATEST_PSAT_GRADE IN ('4', '14', '15') THEN '9' WHEN ss.LATEST_PSAT_GRADE = '5' THEN '10' WHEN ss.LATEST_PSAT_GRADE = '6' THEN '11' WHEN ss.LATEST_PSAT_GRADE = '7' THEN '12' ELSE isnull(ss.LATEST_PSAT_GRADE, se.GRADE_LEVEL) END AS SATGrade
					,ss.TenantId
				--,ROW_NUMBER() OVER (
				--	PARTITION BY DISTRICT_STUDENT_ID
				--	,STATE_STUDENT_ID
				--	,ss.SchoolYear ORDER BY cast(LATEST_PSAT_DATE AS DATE) DESC
				--	) AS rn
				FROM Main.WHPS_PSAT89_Source ss
				INNER JOIN [Main].[WHPS_Students] se ON ss.SECONDARY_ID = se.Student_Number
					AND ss.schoolyear = se.schoolyear
				GROUP BY ss.schoolyear
					,se.SCHOOLID
					,se.GRADE_LEVEL
					,ss.SECONDARY_ID
					,ss.LATEST_PSAT_GRADE
					,ss.TenantId
				) l
			INNER JOIN (
				SELECT *
				FROM WHPS_SAT_PSAT_BenchmarkRanges
				WHERE Subject = 'Reading and Writing'
				) b ON (CASE WHEN l.AssessmentCode IN ('PSAT89', 'PSATNM') THEN 'PSAT' ELSE l.AssessmentCode END) = b.AssessmentCode
				AND isnull((CASE WHEN l.AssessmentCode = 'SAT' THEN NULL ELSE l.SATGrade END), 0) = isnull(cast(b.Grade AS INT), 0)
				AND l.Reading BETWEEN b.MinScore
					AND b.MaxScore
			INNER JOIN (
				SELECT *
				FROM WHPS_SAT_PSAT_BenchmarkRanges
				WHERE Subject = 'Math'
				) d ON (CASE WHEN l.AssessmentCode IN ('PSAT89', 'PSATNM') THEN 'PSAT' ELSE l.AssessmentCode END) = d.AssessmentCode
				AND isnull((CASE WHEN l.AssessmentCode = 'SAT' THEN NULL ELSE l.SATGrade END), 0) = isnull(cast(d.Grade AS INT), 0)
				AND l.Math BETWEEN d.MinScore
					AND d.MaxScore
			WHERE l.SchoolYear IN (2023, 2024, 2025)
				--AND l.rn = 1
			) k
		unpivot([Value] FOR [Col] IN ([TotalScore], [ReadingScore], [ReadingBenchmark], [ReadingMetScore], [MathScore], [MathBenchmark], [MathMetScore])) f
		) h
	pivot(max([Value]) FOR [Assessment] IN ([SAT_TotalScore], [SAT_ReadingScore], [SAT_ReadingBenchmark], [SAT_ReadingMetScore], [SAT_MathScore], [SAT_MathBenchmark], [SAT_MathMetScore], [PSAT_TotalScore], [PSAT_ReadingScore], [PSAT_ReadingBenchmark], [PSAT_ReadingMetScore], [PSAT_MathScore], [PSAT_MathBenchmark], [PSAT_MathMetScore])) l
	) w ON w.schoolyear = s.SchoolYear
	AND w.DistrictStudentId = s.student_number
--and w.schoolidentifier=s.schoolID
WHERE sch.schoolidentifier IN ('51', '52', '53', '61', '62', '73', '92')
	AND g.[gen value] IN ('English', 'Math', 'Science', 'Soc St')

--AND s.student_number='188549'
/*
================================================================================
UPDATING ASSESSMENT DATA TO 'NULL'
================================================================================
*/
UPDATE ss
SET ss.AIMSWebPlus_Mathematics_ProfLevel = NULL
	,ss.AIMSWebPlus_Mathematics_ScaleScore = NULL
	,ss.AIMSWebPlus_OralReadingFluency_ProfLevel = NULL
	,ss.AIMSWebPlus_OralReadingFluency_ScaleScore = NULL
	,ss.AIMSWebPlus_Reading_ProfLevel = NULL
	,ss.AIMSWebPlus_Reading_ScaleScore = NULL
	,ss.[i-Ready_Mathematics_ProfLevel] = NULL
	,ss.[i-Ready_Mathematics_ScaleScore] = NULL
	,ss.[i-Ready_Reading_ProfLevel] = NULL
	,ss.[i-Ready_Reading_ScaleScore] = NULL
	,ss.NGSS_Science_ProfLevel = NULL
	,ss.NGSS_Science_ScaleScore = NULL
	,ss.SBAC_EnglishLanguageArts_ProfLevel = NULL
	,ss.SBAC_EnglishLanguageArts_ScaleScore = NULL
	,ss.SBAC_Mathematics_ProfLevel = NULL
	,ss.SBAC_Mathematics_ScaleScore = NULL
	,ss.STAR_Reading_ProfLevel = NULL
	,ss.STAR_Reading_ScaleScore = NULL
FROM WHPS_StudentSummaryWithAllAss ss

/*
================================================================================
UPDATING 'AIMSWebPlus', 'i-Ready', 'STAR' ASSESSMENT DATA 
================================================================================
*/
UPDATE ss
SET ss.AIMSWebPlus_Mathematics_ProfLevel = r.AIMSWebPlus_Mathematics_ProfLevel
	,ss.AIMSWebPlus_Mathematics_ScaleScore = r.AIMSWebPlus_Mathematics_ScaleScore
	,ss.AIMSWebPlus_OralReadingFluency_ProfLevel = r.AIMSWebPlus_OralReadingFluency_ProfLevel
	,ss.AIMSWebPlus_OralReadingFluency_ScaleScore = r.AIMSWebPlus_OralReadingFluency_ScaleScore
	,ss.AIMSWebPlus_Reading_ProfLevel = r.AIMSWebPlus_Reading_ProfLevel
	,ss.AIMSWebPlus_Reading_ScaleScore = r.AIMSWebPlus_Reading_ScaleScore
	,ss.[i-Ready_Mathematics_ProfLevel] = r.[i-Ready_Mathematics_ProfLevel]
	,ss.[i-Ready_Mathematics_ScaleScore] = r.[i-Ready_Mathematics_ScaleScore]
	,ss.[i-Ready_Reading_ProfLevel] = r.[i-Ready_Reading_ProfLevel]
	,ss.[i-Ready_Reading_ScaleScore] = r.[i-Ready_Reading_ScaleScore]
	,ss.STAR_Reading_ProfLevel = r.STAR_Reading_ProfLevel
	,ss.STAR_Reading_ScaleScore = r.STAR_Reading_ScaleScore
FROM WHPS_StudentSummaryWithAllAss ss
INNER JOIN (
	SELECT TenantId
		,schoolyear
		,districtstudentid
		,schoolidentifier
		,MAX([AIMSWebPlus_Mathematics_ProfLevel]) AS [AIMSWebPlus_Mathematics_ProfLevel]
		,MAX([AIMSWebPlus_Mathematics_ScaleScore]) AS [AIMSWebPlus_Mathematics_ScaleScore]
		,MAX([AIMSWebPlus_Oral Reading Fluency_ProfLevel]) AS [AIMSWebPlus_OralReadingFluency_ProfLevel]
		,MAX([AIMSWebPlus_Oral Reading Fluency_ScaleScore]) AS [AIMSWebPlus_OralReadingFluency_ScaleScore]
		,MAX([AIMSWebPlus_Reading_ProfLevel]) AS [AIMSWebPlus_Reading_ProfLevel]
		,MAX([AIMSWebPlus_Reading_ScaleScore]) AS [AIMSWebPlus_Reading_ScaleScore]
		,MAX([i-Ready_Mathematics_ProfLevel]) AS [i-Ready_Mathematics_ProfLevel]
		,MAX([i-Ready_Mathematics_ScaleScore]) AS [i-Ready_Mathematics_ScaleScore]
		,MAX([i-Ready_Reading_ProfLevel]) AS [i-Ready_Reading_ProfLevel]
		,MAX([i-Ready_Reading_ScaleScore]) AS [i-Ready_Reading_ScaleScore]
		,MAX([STAR_Reading_ProfLevel]) AS [STAR_Reading_ProfLevel]
		,MAX([STAR_Reading_ScaleScore]) AS [STAR_Reading_ScaleScore]
	FROM (
		SELECT TenantId
			,schoolyear
			,districtstudentid
			,schoolidentifier
			,[AIMSWebPlus_Mathematics_ProfLevel]
			,[AIMSWebPlus_Mathematics_ScaleScore]
			,[AIMSWebPlus_Oral Reading Fluency_ProfLevel]
			,[AIMSWebPlus_Oral Reading Fluency_ScaleScore]
			,[AIMSWebPlus_Reading_ProfLevel]
			,[AIMSWebPlus_Reading_ScaleScore]
			,[i-Ready_Mathematics_ProfLevel]
			,[i-Ready_Mathematics_ScaleScore]
			,[i-Ready_Reading_ProfLevel]
			,[i-Ready_Reading_ScaleScore]
			,[STAR_Reading_ProfLevel]
			,[STAR_Reading_ScaleScore]
		FROM (
			SELECT DISTINCT TenantId
				,schoolyear
				,districtstudentid
				,schoolidentifier
				,Assessment
				,SubjectAreaName
				,Assessment + '_' + SubjectAreaName + '_ProfLevel' AS ColumnName
				,ProficiencyDescription AS SValue
			FROM WHPSAssessmentAllDS_Vw
			WHERE IsLatest = 1
				AND ProficiencyDescription IS NOT NULL
				AND AssessmentCode IN ('AIMSWebPlus', 'i-Ready', 'STAR')
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
			FROM WHPSAssessmentAllDS_Vw
			WHERE IsLatest = 1
				AND assessment IS NOT NULL
				AND AssessmentCode IN ('AIMSWebPlus', 'i-Ready', 'STAR')
				AND SchoolYear IN (2025, 2024, 2023)
			) AS source
		PIVOT(MAX(SValue) FOR ColumnName IN ([AIMSWebPlus_Mathematics_ProfLevel], [AIMSWebPlus_Mathematics_ScaleScore], [AIMSWebPlus_Oral Reading Fluency_ProfLevel], [AIMSWebPlus_Oral Reading Fluency_ScaleScore], [AIMSWebPlus_Reading_ProfLevel], [AIMSWebPlus_Reading_ScaleScore], [i-Ready_Mathematics_ProfLevel], [i-Ready_Mathematics_ScaleScore], [i-Ready_Reading_ProfLevel], [i-Ready_Reading_ScaleScore], [NGSS_Science_ProfLevel], [NGSS_Science_ScaleScore], [STAR_Reading_ProfLevel], [STAR_Reading_ScaleScore])) AS p
		) pivot_results
	GROUP BY TenantId
		,schoolyear
		,districtstudentid
		,schoolidentifier
	) r ON ss.Student_Number = r.DistrictStudentId
	AND ss.schoolyear = r.schoolyear

--UPDATE ss
--SET ss.NGSS_Science_ProfLevel = NULL
--	,ss.NGSS_Science_ScaleScore = NULL
--	,ss.SBAC_EnglishLanguageArts_ProfLevel = NULL
--	,ss.SBAC_EnglishLanguageArts_ScaleScore = NULL
--	,ss.SBAC_Mathematics_ProfLevel = NULL
--	,ss.SBAC_Mathematics_ScaleScore = NULL
--FROM WHPS_StudentSummaryWithAllAss ss

--2025 2024,2023 update
UPDATE ss
SET ss.NGSS_Science_ProfLevel = r.NGSS_Science_ProfLevel
	,ss.NGSS_Science_ScaleScore = r.NGSS_Science_ScaleScore
	,ss.SBAC_EnglishLanguageArts_ProfLevel = r.SBAC_EnglishLanguageArts_ProfLevel
	,ss.SBAC_EnglishLanguageArts_ScaleScore = r.SBAC_EnglishLanguageArts_ScaleScore
	,ss.SBAC_Mathematics_ProfLevel = r.SBAC_Mathematics_ProfLevel
	,ss.SBAC_Mathematics_ScaleScore = r.SBAC_Mathematics_ScaleScore
FROM WHPS_StudentSummaryWithAllAss ss
INNER JOIN (
	SELECT TenantId
		,schoolyear
		,districtstudentid
		,schoolidentifier
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
			FROM WHPSAssessmentAllDS_Vw
			WHERE IsLatest = 1
				AND ProficiencyDescription IS NOT NULL
				AND AssessmentCode IN ('SBAC', 'NGSS')
				AND SchoolYear IN (2025,2024, 2023)
			
			UNION ALL
			
			SELECT DISTINCT TenantId
				,schoolyear
				,districtstudentid
				,schoolidentifier
				,Assessment
				,SubjectAreaName
				,Assessment + '_' + SubjectAreaName + '_ScaleScore' AS ColumnName
				,CAST(ScaleScore AS VARCHAR) AS SValue
			FROM WHPSAssessmentAllDS_Vw
			WHERE IsLatest = 1
				AND ScaleScore IS NOT NULL
				AND AssessmentCode IN ('SBAC', 'NGSS')
				AND SchoolYear IN (2025, 2024, 2023)
			) AS source
		PIVOT(MAX(SValue) FOR ColumnName IN ([NGSS_Science_ProfLevel], [NGSS_Science_ScaleScore], [SBAC_English Language Arts_ProfLevel], [SBAC_English Language Arts_ScaleScore], [SBAC_Mathematics_ProfLevel], [SBAC_Mathematics_ScaleScore])) AS p
		) pivot_results
	GROUP BY TenantId
		,schoolyear
		,districtstudentid
		,schoolidentifier
	) r ON ss.Student_Number = r.DistrictStudentId
	AND ss.schoolyear = r.schoolyear

/*
================================================================================
UPDATING 'Teacher Name'
================================================================================
*/
UPDATE ss
SET ss.Teacher = se.firstname + ' ' + se.LastOrSurname
--select distinct ss.districtstaffid,Teacher,se.districtstaffid,se.firstname,se.LastOrSurname
--,se.firstname+' '+se.LastOrSurname
FROM WHPS_StudentSummaryWithAllAss ss
INNER JOIN Main.K12StaffDemographics se ON ss.districtstaffid = se.districtstaffid
WHERE se.tenantid = 38
