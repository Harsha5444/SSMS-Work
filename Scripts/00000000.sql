SELECT o.type_desc AS object_type,
	SCHEMA_NAME(o.schema_id) AS schema_name,
	o.name AS object_name,
	m.DEFINITION AS object_definition
FROM sys.sql_modules m
INNER JOIN sys.objects o ON m.object_id = o.object_id
WHERE m.DEFINITION LIKE '%main.Clayton_AnalyticVue_ICPrograms%'
	AND o.type IN ('V', 'P', 'FN', 'TF', 'TR') -- View, Procedure, Function, Table-function, Trigger
ORDER BY o.type_desc,
	o.name;
--============================================================================================
[
--Clayton_Access_AchivementLevel_Vw
Clayton_ACCESSAssessment_VW
Clayton_ACT_Assessment_VW
Clayton_ACTallyears_VW
Clayton_Attendance_Vw
Clayton_AttendancebyCategory_vw
Clayton_AttendanceStatus_VW
Clayton_Enrollment_VW
Clayton_GAA_Vw
Clayton_GKIDSAssessment_VW
Clayton_Incidents_VW
Clayton_SAT_PSAT_ProficiencyLevel
Clayton_SATPSAT_SS
Clayton_SATSchoolDays_Vw
]

--============================================================================================
SELECT TOP 10 *
FROM Clayton_Access_AchivementLevel_Vw

SELECT *
FROM main.Clayton_AnalyticVue_ICPrograms


