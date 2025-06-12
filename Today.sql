
SELECT 
    o.type_desc AS ObjectType,
    SCHEMA_NAME(o.schema_id) AS SchemaName,
    o.name AS ObjectName,
    o.create_date,
    o.modify_date
FROM 
    sys.sql_expression_dependencies d
INNER JOIN 
    sys.objects o ON d.referencing_id = o.object_id
INNER JOIN 
    sys.objects ro ON d.referenced_id = ro.object_id
WHERE 
    ro.name = 'Clayton_Attendance_Age_Programs'
    AND ro.type = 'U' -- User tables only
    AND o.type IN ('V', 'P', 'FN', 'IF', 'TF') -- Views, Stored Procedures, Functions
ORDER BY 
    o.type_desc, 
    SchemaName, 
    ObjectName;

Exec sp_depends Usp_Clayton_Attendance_Age_Programs_Loading

SELECT 1561 + 2450

SELECT *
FROM Clayton_DashboardReportDetails
WHERE dashboardname = 'Attendance - Override'

SELECT *
FROM Clayton_Attendance_Age_Programs
WHERE schooloverridetype LIKE '%zone%'

SELECT DISTINCT studentnumber
FROM clayton_secondaryenrollment_programs
WHERE schooltype LIKE '%zone%'
	AND servicetype = 'p' --3166


SELECT districtstudentid
FROM AggRptK12StudentDetails
WHERE schoolyear = 2025
	AND districtstudentid IN (
		SELECT DISTINCT studentnumber
		FROM clayton_secondaryenrollment_programs
		WHERE schooltype LIKE '%zone%'
			AND servicetype = 'p'
		)

SELECT DISTINCT studentnumber
FROM clayton_secondaryenrollment_programs
WHERE schooltype LIKE '%zone%'
	AND servicetype = 'p'
	AND studentnumber NOT IN (
		SELECT districtstudentid
		FROM AggRptK12StudentDetails
		WHERE schoolyear = 2025
			AND districtstudentid IN (
				SELECT DISTINCT studentnumber
				FROM clayton_secondaryenrollment_programs
				WHERE schooltype LIKE '%zone%'
					AND servicetype = 'p'
				)
		)

SELECT *
FROM main.clayton_analyticvue_icstudents
WHERE studentnumber = '1523230'
	AND schoolyear = 2025

SELECT *
FROM AggRptK12StudentDetails
WHERE districtstudentid IN (
		SELECT DISTINCT studentnumber
		FROM clayton_secondaryenrollment_programs
		WHERE schooltype LIKE '%zone%'
			AND servicetype = 'p'
			AND studentnumber NOT IN (
				SELECT districtstudentid
				FROM AggRptK12StudentDetails
				WHERE schoolyear = 2025
					AND districtstudentid IN (
						SELECT DISTINCT studentnumber
						FROM clayton_secondaryenrollment_programs
						WHERE schooltype LIKE '%zone%'
							AND servicetype = 'p'
						)
				)
		)
	AND schoolyear = 2025


select * from main.Clayton_AnalyticVue_ICStudents
where studentnumber in (
		SELECT DISTINCT studentnumber
		FROM clayton_secondaryenrollment_programs
		WHERE schooltype LIKE '%zone%'
			AND servicetype = 'p'
			AND studentnumber NOT IN (
				SELECT districtstudentid
				FROM AggRptK12StudentDetails
				WHERE schoolyear = 2025
					AND districtstudentid IN (
						SELECT DISTINCT studentnumber
						FROM clayton_secondaryenrollment_programs
						WHERE schooltype LIKE '%zone%'
							AND servicetype = 'p'
						)
				)
		)
	AND schoolyear = 2025 and enddate is null



SELECT *
FROM main.clayton_analyticvue_icstudents
WHERE studentnumber = '1523230'
	AND schoolyear = 2025

SELECT 2450 + 424
	--select * from Clayton_Attendance_Age_Programs where schooloverridetype is null

select * from StaffSummaryViewFields

select cast(AbsentDay as date) as AbsentDay,* from main.clayton_attendancedata where studentnumber = '0334057' order by cast(AbsentDay as date)

select distinct schooltype from clayton_secondaryenrollment_programs


Servicing School (Attending) / Zoned Home School 

select * from reportdetails where reportdetailsid = 1351

select * from dashboard

SELECT *
FROM Clayton_DashboardReportDetails
WHERE groupname = 'Override/Home School'


select * from Clayton_DashboardReportDetails where GroupName='Servicing School (Attending) / Zoned Home School'


