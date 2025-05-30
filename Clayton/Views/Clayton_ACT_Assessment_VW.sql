SELECT a.SchoolYear
	,a.LEAIdentifier
	,a.SchoolIdentifier
	,a.AssessmentCode
	,a.AssessmentName
	,a.SubjectAreaCode
	,a.SubjectAreaName
	,a.ProficiencyDescription
	,a.DistrictStudentId
	,a.GradeCode
	,a.GradeDescription AS Grade
	,a.LeaName
	,a.SchoolName
	,a.TenantId
	,a.TestTakenDate
	,a.IsLatest
	,a.ScaleScore
	,a.TermDescription AS Term
	,c.StudentFullName
	,c.Gender
	,c.Gender AS GenderCode
	,NULL AS MilitaryAffiliated
	,c.SchoolCategory
	,c.Race
	,c.Migrant
	,c.GiftedandTalented
	,c.SchoolCategory AS SchoolCategoryCode
	,c.ELL
	,c.StateStudentId
	,c.FRL
	,CASE WHEN c.Disability IS NULL THEN NULL WHEN c.Disability = 'No' THEN 'No' ELSE 'Yes' END AS DisabilityStatus
	,c.Disability
	,c.SpecialEdStatus
	,c.[504Status]
	,Case when c.Race = 'Hispanic' then 'Yes' else 'No' end as Ethnicity
	,c.IEP
	,NULL AS HispanicLatino
	,c.Homeless
	,c.IEP
	,c.REIP
	,c.GAA
	,c.EIP
	,c.Magnet 
FROM AggrptAssessmentSubgroupData A WITH (NOLOCK)
LEFT JOIN Clayton_StudentProgram c
	ON a.DistrictStudentId = c.DistrictStudentId
		AND a.TenantId = c.TenantId
		AND a.schoolyear = c.schoolyear
WHERE a.Assessmentcode = 'ACT' and  a.schoolyear = 2025
--5145
--5141

--4346
--4346
select * from AggrptAssessmentSubgroupData where schoolyear = 2025 and assessmentcode = 'act'

select * from Clayton_ACT_Assessment_VW where schoolyear = 2025

select * from main.clayton_act where schoolyear = 2021

select * from Main.K12StudentGenericAssessment where schoolyear = 2021 and assessmentcodeid in (
select AssessmentDetailsId from main.assessmentdetails where assessmentcode = 'act' and schoolyear = 2021
)


select * from [Import_ACT_K12Studentgenericassessment_Vw_50] where schoolyear = 2021
--ID_StateAssign