CREATE PROC USP_Clayton_AcademicProgressDES_Elem_Loading
AS
BEGIN
	SET ANSI_NULLS ON;
	SET QUOTED_IDENTIFIER OFF;
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	BEGIN TRY
		BEGIN TRANSACTION

		DROP TABLE [Clayton_AcademicProgressDES_Elem]

		CREATE TABLE [Clayton_AcademicProgressDES_Elem] (
			[SchoolYear] VARCHAR(500)
			,[LEAIdentifier] VARCHAR(500)
			,[SchoolIdentifier] VARCHAR(500)
			,[SchoolName] VARCHAR(500)
			,[StateStudentId] VARCHAR(500)
			,[DistrictStudentId] VARCHAR(500)
			,[CaseManager] VARCHAR(500)
			,[FirstName] VARCHAR(500)
			,[LastName] VARCHAR(500)
			,[StudentFullName] VARCHAR(500)
			,[Grade] VARCHAR(500)
			,[Gender] VARCHAR(500)
			,[Race] VARCHAR(500)
			,[GMAS_ELA] VARCHAR(500)
			,[GMAS_MATH] VARCHAR(500)
			,[GMAS_SCI] VARCHAR(500)
			,[MAP_BOY] VARCHAR(500)
			,[MAP_MOY] VARCHAR(500)
			,[MAP_EOY] VARCHAR(500)
			,[GrowthCalculation_MAP] VARCHAR(500)
			,[Amira_BOY] VARCHAR(500)
			,[Amira_MOY] VARCHAR(500)
			,[Amira_EOY] VARCHAR(500)
			,[Attendance] VARCHAR(500)
			,[IncidentCount] VARCHAR(500)
			,[HomeroomTeacher] VARCHAR(500)
			,[ClassworksBOY] VARCHAR(500)
			,[TargetedSkills] VARCHAR(500)
			,[ClassroomTeacher] VARCHAR(500)
			,[AcademicSupportPlan] VARCHAR(500)
			,[TenantId] VARCHAR(500)
			,[Migrant] VARCHAR(500)
			,[GiftedandTalented] VARCHAR(500)
			,[ELL] VARCHAR(500)
			,[FRL] VARCHAR(500)
			,[Disability] VARCHAR(500)
			,[SpecialEdStatus] VARCHAR(500)
			,[504Status] VARCHAR(500)
			,[GAA] VARCHAR(500)
			,[Student Success Team] VARCHAR(500)
			,[Limited English Proficient] VARCHAR(500)
			,[Homeless] VARCHAR(500)
			,[EIP] VARCHAR(500)
			,[REIP] VARCHAR(500)
			,[IEP] VARCHAR(500)
			,[Magnet] VARCHAR(500)
			);

		WITH IcStudents
		AS (
			SELECT ic.SchoolYear
				,ic.districtID AS LEAIdentifier
				,sc.SchoolIdentifier AS SchoolIdentifier
				,ic.Schoolnumber AS ICSchoolIdentifier
				,sc.NameofInstitution AS SchoolName
				,ic.Schoolname AS ICSchoolName
				,cat.SchoolCategoryCode AS SchoolCategory
				,ic.enrollmentID AS EnrollmentID
				,ic.stateID AS StateStudentId
				,ic.studentNumber AS DistrictStudentId
				,ic.firstName AS FirstName
				,ic.middleName AS MiddleName
				,ic.lastName AS LastorSurname
				,CONCAT (
					ISNULL(ic.lastName, '')
					,', '
					,ISNULL(ic.firstName, '')
					,' '
					,ISNULL(ic.middleName, '')
					) AS StudentFullName
				,rg.GradeDescription AS Grade
				,CASE ic.gender WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' ELSE ic.gender END AS Gender
				,ic.raceEthnicity AS Race
				,ic.dob AS BirthDate
				,IIF(ic.hispanicEthnicity = 'Y', 'Yes', IIF(ic.hispanicEthnicity = 'N', 'No', ic.hispanicEthnicity)) AS Ethnicity
				,ic.birthCountry AS BirthCountry
				,ic.birthCity AS BirthCity
				,ic.birthCounty AS BirthCounty
				,ic.startDate AS StartDate
				,ic.startStatus AS StartStatus
				,ic.endDate AS EndDate
				,ic.endStatus AS EndStatus
				,ic.startYear AS StartYear
				,ic.active AS Active
				,ic.cohortYear AS CohortYear
				,ic.serviceType AS ServiceType
				,ic.SchoolOverride
				,ic.TenantId
			FROM (
				SELECT *
					,ROW_NUMBER() OVER (
						PARTITION BY studentnumber
						,schoolyear ORDER BY startdate DESC
						) AS rno
				FROM main.clayton_analyticvue_icstudents WITH (NOLOCK)
				) ic
			LEFT JOIN refgrade rg WITH (NOLOCK)
				ON rg.TenantId = ic.TenantId
					AND rg.GradeCode = ic.grade
			LEFT JOIN main.k12school sc WITH (NOLOCK)
				ON ic.schoolyear = sc.schoolyear
					AND ic.tenantid = sc.tenantid
					AND CASE WHEN ic.schoolnumber = '6008'
							AND ic.SchoolName LIKE '%High%' THEN '0036008' WHEN ic.schoolnumber = '6008'
							AND ic.SchoolName LIKE '%Middle%' THEN '0026008' WHEN ic.schoolnumber = '6008'
							AND ic.SchoolName LIKE '%Elem%' THEN '0016008' WHEN ic.schoolnumber = '6422'
							AND ic.SchoolName LIKE '%High%' THEN '0096422' WHEN ic.schoolnumber = '6422'
							AND ic.SchoolName LIKE '%Middle%' THEN '0236422' WHEN ic.schoolnumber = '6422'
							AND ic.SchoolName LIKE '%Elem%' THEN '1286422' WHEN ic.schoolnumber = '6004'
							AND ic.SchoolName LIKE '%High%' THEN '0086004' WHEN ic.schoolnumber = '6004'
							AND ic.SchoolName LIKE '%Middle%' THEN '0226004' WHEN ic.schoolnumber = '0114'
							AND ic.SchoolName = '24-25 Elite Scholars Middle' THEN '0990114' ELSE ic.schoolnumber END = sc.SchoolIdentifier
			LEFT JOIN refschoolcategory cat WITH (NOLOCK)
				ON sc.SchoolCategoryId = cat.SchoolCategoryId
			WHERE ic.rno = 1
			)
			,EOGPivoted
		AS (
			SELECT GTID
				,schoolYear
				,[ELA]
				,[MATH]
				,[SCI]
			FROM (
				SELECT eog.GTID
					,eog.schoolYear
					,eog.testtype
					,eog.achLevelLong
					,ROW_NUMBER() OVER (
						PARTITION BY eog.GTID
						,eog.schoolYear
						,eog.testtype ORDER BY eog.ss DESC
							,eog.achLevelLong
						) AS row_num
				FROM Clayton_Assessment_EOG eog
				INNER JOIN (
					SELECT GTID
						,schoolYear
						,testtype
						,MAX(ss) AS MaxScaledScore
					FROM Clayton_Assessment_EOG
					GROUP BY GTID
						,schoolYear
						,testtype
					) ms
					ON eog.GTID = ms.GTID
						AND eog.schoolYear = ms.schoolYear
						AND eog.testtype = ms.testtype
						AND eog.ss = ms.MaxScaledScore
				) AS SourceTable
			PIVOT(MAX(achLevelLong) FOR testtype IN ([ELA], [MATH], [SCI])) AS PivotTable
			WHERE row_num = 1
			)
			,MAPPivoted
		AS (
			SELECT gtid
				,schoolyear
				,MAX(CASE WHEN testterm = 'fall' THEN testRitScore END) AS BOY_score
				,MAX(CASE WHEN testterm = 'Winter' THEN testRitScore END) AS MOY_score
				,MAX(CASE WHEN testterm = 'Spring' THEN testRitScore END) AS EOY_score
				,MAX(CASE WHEN testterm = 'fall' THEN ProjectedProficiencyLevel END) AS BOY_Proficiency
				,MAX(CASE WHEN testterm = 'Winter' THEN ProjectedProficiencyLevel END) AS MOY_Proficiency
				,MAX(CASE WHEN testterm = 'Spring' THEN ProjectedProficiencyLevel END) AS EOY_Proficiency
				,CASE WHEN MAX(CASE WHEN testterm = 'fall' THEN testRitScore END) IS NOT NULL
						AND MAX(CASE WHEN testterm = 'Winter' THEN testRitScore END) IS NOT NULL THEN (CAST(MAX(CASE WHEN testterm = 'Winter' THEN testRitScore END) AS FLOAT) - CAST(MAX(CASE WHEN testterm = 'fall' THEN testRitScore END) AS FLOAT)) / CAST(MAX(CASE WHEN testterm = 'fall' THEN testRitScore END) AS FLOAT) * 100 ELSE NULL END AS GrowthCalculation_MAP
			FROM (
				SELECT map.gtid
					,map.testterm
					,map.testRitScore
					,map.schoolyear
					,CASE WHEN map.gradelevel IN ('KK', '01', '02', '03', '04', '05', '06', '07', '08') THEN ISNULL(map.ProjectedProficiencyLevel2, map.ProjectedProficiencyLevel3) WHEN map.gradelevel IN ('09', '10', '11', '12') THEN map.ProjectedProficiencyLevel3 END AS ProjectedProficiencyLevel
				FROM clayton_assessment_map map
				INNER JOIN (
					SELECT gtid
						,schoolyear
						,testterm
						,MAX(testRitScore) AS MaxRitScore
					FROM clayton_assessment_map
					GROUP BY gtid
						,schoolyear
						,testterm
					) ms
					ON map.gtid = ms.gtid
						AND map.testterm = ms.testterm
						AND map.testRitScore = ms.MaxRitScore
				) AS SourceTable
			GROUP BY gtid
				,schoolyear
			)
			,AmiraPivoted
		AS (
			SELECT gtid
				,schoolyear
				,BOY
				,MOY
				,EOY
			FROM (
				SELECT amira.gtid
					,amira.schoolyear
					,amira.TestAdministration
					,amira.ARM_RYG
				FROM clayton_assessment_amira amira
				INNER JOIN (
					SELECT gtid
						,schoolyear
						,TestAdministration
						,MAX(ARM_RYG) AS MaxARMRYG
					FROM clayton_assessment_amira
					GROUP BY gtid
						,schoolyear
						,TestAdministration
					) ms
					ON amira.gtid = ms.gtid
						AND amira.schoolyear = ms.schoolyear
						AND amira.TestAdministration = ms.TestAdministration
						AND amira.ARM_RYG = ms.MaxARMRYG
				) AS SourceTable
			PIVOT(MAX(ARM_RYG) FOR TestAdministration IN ([BOY], [MOY], [EOY])) AS PivotTable
			)
			,BehavioralIncident
		AS (
			SELECT schoolyear
				,districtstudentid
				,cast(count(incidentnumber) AS VARCHAR) AS IncidentCount
			FROM Clayton_DisciplineIncident_Programs
			WHERE incidentnumber IS NOT NULL
			GROUP BY schoolyear
				,districtstudentid
			)
		INSERT INTO [Clayton_AcademicProgressDES_Elem]
		SELECT DISTINCT ic.SchoolYear
			,ic.LEAIdentifier
			,ic.SchoolIdentifier
			,ic.SchoolName
			,ic.StateStudentId
			,ic.DistrictStudentId
			,goiep.Case_Manager AS [CaseManager]
			,ic.FirstName AS FirstName
			,ic.LastorSurname AS LastName
			,ic.StudentFullName
			,ic.Grade
			,ic.Gender
			,ic.Race
			,gmas.ELA AS GMAS_ELA
			,gmas.MATH AS GMAS_MATH
			,gmas.SCI AS GMAS_SCI
			,map.BOY_score AS MAP_BOY
			,map.MOY_score AS MAP_MOY
			,map.EOY_score AS MAP_EOY
			,CAST(ROUND(CAST(GrowthCalculation_MAP AS FLOAT), 2) AS VARCHAR) AS GrowthCalculation_MAP
			,amira.BOY AS Amira_BOY
			,amira.MOY AS Amira_MOY
			,amira.EOY AS Amira_EOY
			,cast(agg.presentrate AS VARCHAR) AS Attendance
			,bi.IncidentCount AS IncidentCount
			,NULL AS [HomeroomTeacher]
			,NULL AS [ClassworksBOY]
			,NULL AS [TargetedSkills]
			,NULL AS [ClassroomTeacher]
			,NULL AS [AcademicSupportPlan]
			,ic.[TenantId]
			,prog.[Migrant]
			,prog.[GiftedandTalented]
			,prog.[ELL]
			,prog.[FRL]
			,prog.[Disability]
			,prog.[SpecialEdStatus]
			,prog.[504Status]
			,prog.[GAA]
			,prog.[Student Success Team]
			,prog.[Limited English Proficient]
			,prog.[Homeless]
			,prog.[EIP]
			,prog.[REIP]
			,prog.[IEP]
			,prog.[Magnet]
		FROM icstudents ic
		INNER JOIN main.Clayton_StudentCaseLoad_GoIEPDueDates goiep
			ON ic.StateStudentId = goiep.gtid
				AND ic.schoolyear = goiep.schoolyear
		LEFT JOIN EOGPivoted gmas
			ON gmas.gtid = ic.StateStudentId
				AND gmas.schoolyear IN (
					SELECT max(cast(schoolyear AS INT))
					FROM EOGPivoted
					)
		LEFT JOIN MAPPivoted map
			ON ic.schoolyear = map.schoolyear
				AND ic.StateStudentId = map.gtid
		LEFT JOIN AmiraPivoted Amira
			ON ic.schoolyear = amira.SchoolYear
				AND ic.StateStudentId = amira.GTID
		LEFT JOIN aggrptk12studentdetails agg
			ON agg.StateStudentId = ic.StateStudentId
				AND agg.schoolyear = ic.schoolyear
		LEFT JOIN BehavioralIncident bi
			ON bi.schoolyear = ic.schoolyear
				AND bi.DistrictStudentId = ic.DistrictStudentId
		LEFT JOIN Clayton_StudentProgram prog
			ON prog.schoolyear = ic.SchoolYear
				AND prog.StateStudentId = ic.StateStudentId
		WHERE ic.SchoolCategory = 'Elementary'

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		IF XACT_STATE() = - 1
		BEGIN
			ROLLBACK TRANSACTION
		END

		DECLARE @ErrorFromProc VARCHAR(500)
		DECLARE @ProcErrorMessage VARCHAR(1000)
		DECLARE @SeverityLevel INT

		SELECT @ErrorFromProc = '[dbo].[USP_Clayton_AcademicProgressDES_Elem_Loading]'
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




--1.) Clayton_StudentCaseLoad_GoIEPDueDates

select distinct gtid from main.Clayton_StudentCaseLoad_GoIEPDueDates where schoolyear = 2025  
except
select distinct stateid from main.clayton_analyticvue_icstudents where schoolyear = 2025  

-- 118 students missing (stateId not matching)


--2.) Clayton_StudentInformation_GoIEPPR

select distinct gtid from main.Clayton_StudentInformation_GoIEPPR where schoolyear = 2025  
except
select distinct stateid from main.clayton_analyticvue_icstudents where schoolyear = 2025  

-- 4 students missing (stateId not matching)

------------------table used in Dataset Report
select distinct StateStudentId from [Clayton_AcademicProgressDES_Elem] -- from main.Clayton_StudentCaseLoad_GoIEPDueDates -- 6206

--only have 3012 because this data is only for [Elementary Students]





hi 