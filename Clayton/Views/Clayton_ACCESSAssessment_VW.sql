SELECT  a.SchoolYear
	,b.SchoolIdentifier as School_Number
	,b.SchoolName
	,StudentLastName
	,StudentFirstName
	,StudentMiddleName
	,b.Grade
	,b.Gender
	,b.Race
	,b.StateStudentID
	,Student_Type
	,'ELA' AS Subject
	,[StrandArea]
	,Proficiency_Level AS Proficiency_Level_Score
	,CASE WHEN TRY_CAST(Proficiency_Level AS FLOAT) BETWEEN 1 AND 1.9 THEN '1-Entering' WHEN TRY_CAST(Proficiency_Level AS FLOAT) BETWEEN 2 AND 2.9 THEN '2-Emerging' WHEN TRY_CAST(Proficiency_Level AS FLOAT) BETWEEN 3 AND 3.9 THEN '3-Developing' WHEN TRY_CAST(Proficiency_Level AS FLOAT) BETWEEN 4 AND 4.9 THEN '4-Expanding' WHEN TRY_CAST(Proficiency_Level AS FLOAT) BETWEEN 5 AND 5.9 THEN '5-Bridging' WHEN TRY_CAST(Proficiency_Level AS FLOAT) >= 6 THEN '6-Reaching' END AS Proficiency_Level
	,CASE WHEN TRY_CAST(Proficiency_Level AS FLOAT) BETWEEN 1.0 AND 2.1 THEN '1.0 - 2.1' WHEN TRY_CAST(Proficiency_Level AS FLOAT) BETWEEN 2.2 AND 2.8 THEN '2.2 - 2.8' WHEN TRY_CAST(Proficiency_Level AS FLOAT) BETWEEN 2.9 AND 3.1 THEN '2.9 - 3.1' WHEN TRY_CAST(Proficiency_Level AS FLOAT) BETWEEN 3.2 AND 3.4 THEN '3.2 - 3.4' WHEN TRY_CAST(Proficiency_Level AS FLOAT) BETWEEN 3.5 AND 3.7 THEN '3.5 - 3.7' WHEN TRY_CAST(Proficiency_Level AS FLOAT) BETWEEN 3.8 AND 4.0 THEN '3.8 - 4.0' WHEN TRY_CAST(Proficiency_Level AS FLOAT) BETWEEN 4.1 AND 4.2 THEN '4.1 - 4.2' WHEN TRY_CAST(Proficiency_Level AS FLOAT) >= 4.3 THEN '4.3+' END AS Composite_Score
	,Scale_Score
	,TestCompletionDate
	,a.TenantId
	,b.DistrictStudentId as studentnumber
	,b.GiftedandTalented
	,b.SchoolCategory
	,b.ELL
	,b.FRL
	,b.[504Status]
	,b.specialEdStatus
	,b.Homeless
	,b.Disability
	,b.EIP
	,b.REIP
	,b.GAA
	,b.IEP
	,b.Magnet
FROM main.Clayton_AnalyticVue_ACCESS a
left JOIN clayton_studentprogram b
ON a.schoolyear = b.schoolyear
and a.StateStudentID = b.StateStudentId
and a.TenantId = b.tenantid
CROSS APPLY 
(
    VALUES 
        ('Listening', Proficiency_Level_Listening, Scale_Score_Listening),
        ('Reading', Proficiency_Level_Reading, Scale_Score_Reading),
        ('Speaking', Proficiency_Level_Speaking, Scale_Score_Speaking),
        ('Writing', Proficiency_Level_Writing, Scale_Score_Writing),
        ('Comprehension', Proficiency_Level_Comprehension, Scale_Score_Comprehension),
        ('Literacy', Proficiency_Level_Literacy, Scale_Score_Literacy),
        ('Oral', Proficiency_Level_Oral, Scale_Score_Oral),
        ('Overall', Proficiency_Level_Overall, Scale_Score_Overall)
) AS UnpivotedData ([StrandArea], Proficiency_Level, Scale_Score)

--============================[Previous Counts]============================
select Count(*) from Clayton_ACCESSAssessment_VW --150192
select  distinct StateStudentID  from Clayton_ACCESSAssessment_VW  --9117
select  schoolyear, count(distinct StateStudentID)  from Clayton_ACCESSAssessment_VW group by SchoolYear
--2023	5988
--2024	6294
--2025	6374

--============================[Current Counts]============================
select Count(*) from #temp_test_access  --151856
select distinct StateStudentID from #temp_test_access  --9122
select  schoolyear, count(distinct StateStudentID) from #temp_test_access group by SchoolYear
--2023	6063
--2024	6410
--2025	6330

--============================[Main table Counts]============================
select schoolyear, count(distinct StateStudentID)  from main.Clayton_AnalyticVue_ACCESS  group by SchoolYear
--2023	6063
--2024	6410
--2025	6506

select distinct StateStudentID from  main.Clayton_AnalyticVue_ACCESS where schoolyear = 2025
except
select distinct StateStudentID from #temp_test_access  where schoolyear = 2025
--176
select 6506-6330  --176 students are missing  

select * from main.Clayton_AnalyticVue_ACCESS where StateStudentID = '1859498872'
select * from Clayton_Studentprogram where statestudentid = '1859498872'
select * from main.clayton_analyticvue_icstudents where stateid = '1859498872'

