SELECT tenantid,tenantname,tenantcode FROM AnalyticVue_Hallco.idm.tenant UNION ALL
SELECT tenantid,tenantname,tenantcode FROM AnalyticVue_norwood.idm.tenant UNION ALL
SELECT tenantid,tenantname,tenantcode FROM AnalyticVue_district.idm.tenant UNION ALL
SELECT tenantid,tenantname,tenantcode FROM AnalyticVue_obs.idm.tenant UNION ALL
SELECT tenantid,tenantname,tenantcode FROM AnalyticVue_fps.idm.tenant UNION ALL
SELECT tenantid,tenantname,tenantcode FROM AnalyticVue_clayton.idm.tenant

SELECT CONVERT(TIME, GETDATE()) AS UTC, CONVERT(TIME, GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'India Standard Time') AS IST, CONVERT(TIME, GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time') AS EST;

use AnalyticVue
select * from idm.tenant
select * from idm.apperrorlog order by 1 desc

use AnalyticVue_norwood
use AnalyticVue_district
use AnalyticVue_clayton
use AnalyticVue_Hallco
use AnalyticVue_obs
use AnalyticVue_fps
use demoanalyticvue_avdemo

use AnalyticVue_Hallco
select * from idm.tenant
select * from idm.apperrorlog order by 1 desc

use AnalyticVue_norwood
select * from idm.tenant
select * from idm.apperrorlog order by 1 desc

use AnalyticVue_district
select * from idm.tenant
select * from idm.apperrorlog order by 1 desc

use AnalyticVue_obs
select * from idm.tenant
select * from idm.apperrorlog order by 1 desc

use AnalyticVue_fps
select * from idm.tenant
select * from idm.apperrorlog order by 1 desc

use AnalyticVue_clayton
select * from idm.tenant
select * from idm.apperrorlog order by 1 desc
select * from Clayton_ReportDetails order by 1 desc
select *from Clayton_DashboardReportDetails where 1 = 1 and dashboardname = 'attendance'
select * from Clayton_ReportDetails
select distinct BatchId from Clayton_BatchProcessingStatus where 1=1 and ScheduledDay='Today'  order by 1 desc 
select * from fn_DashboardReportsDetails(50) where groupname like '%mile%'
--[USP_ClaytonStudents5YR_Loading]
select * from Clayton_Students_5YR
select * from [Clayton_ProcessLogStatistics]
select * from errorlogforusp order by 1 desc
--=================================================================================================
SELECT 
    OBJECT_SCHEMA_NAME(o.object_id) AS schema_name,
    o.name AS object_name,
    o.type_desc AS object_type,
    OBJECT_DEFINITION(o.object_id) AS definition
FROM 
    sys.objects o
WHERE 
    o.type IN ('V', 'P') -- V = View, P = Stored Procedure
    AND OBJECT_DEFINITION(o.object_id) LIKE '%UPDATE ss set statusid=3,ModifiedDate=GETDATE()%';
--==================================================================================================

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
    ro.name = 'Clayton_SecondaryEnrollment_Programs'
    AND ro.type = 'U' -- User tables only
    AND o.type IN ('V', 'P', 'FN', 'IF', 'TF') -- Views, Stored Procedures, Functions
ORDER BY 
    o.type_desc, 
    SchemaName, 
    ObjectName;

--==================================================================================================
SELECT 
    v.name AS ViewName,
    s.name AS SchemaName,
    OBJECT_DEFINITION(v.object_id) AS ViewDefinition,
    STRING_AGG(OBJECT_NAME(sed.referenced_id), ', ') AS ReferencedTables
FROM 
    sys.views v
JOIN 
    sys.schemas s ON v.schema_id = s.schema_id
OUTER APPLY 
    (SELECT DISTINCT referenced_id 
     FROM sys.sql_expression_dependencies 
     WHERE referencing_id = v.object_id 
     AND referenced_id IS NOT NULL
     AND referenced_class = 1) sed -- Class = 1 for Tables
GROUP BY 
    v.name, s.name, OBJECT_DEFINITION(v.object_id)
ORDER BY 
    s.name, v.name;
--=================================================================================================

SELECT 
    TABLE_SCHEMA AS 'Schema',
    table_name AS 'Table',
    CONCAT('select * from ', TABLE_SCHEMA, '.', table_name) AS 'Query',
    CONCAT('select count(*) from ', TABLE_SCHEMA, '.', table_name) AS 'Count_Query'
FROM 
    INFORMATION_SCHEMA.tables
WHERE 1=1
	--AND TABLE_SCHEMA IN ('idm')
    --AND TABLE_SCHEMA IN ('main','stage')  
    AND table_name LIKE '%attendance%' 
ORDER BY 
    TABLE_SCHEMA, 
    table_name;
--===================================================================================================
SELECT SPID
	,ER.percent_complete
	,CAST(((DATEDIFF(s, start_time, GetDate())) / 3600) AS VARCHAR) + ' hour(s), ' + CAST((DATEDIFF(s, start_time, GetDate()) % 3600) / 60 AS VARCHAR) + 'min, ' + CAST((DATEDIFF(s, start_time, GetDate()) % 60) AS VARCHAR) + ' sec' AS running_time
	,CAST((estimated_completion_time / 3600000) AS VARCHAR) + ' hour(s), ' + CAST((estimated_completion_time % 3600000) / 60000 AS VARCHAR) + 'min, ' + CAST((estimated_completion_time % 60000) / 1000 AS VARCHAR) + ' sec' AS est_time_to_go
	,DATEADD(second, estimated_completion_time / 1000, getdate()) AS est_completion_time
	,ER.command
	,ER.blocking_session_id
	,SP.DBID
	,LASTWAITTYPE
	,DB_NAME(SP.DBID) AS DBNAME
	,SUBSTRING(est.TEXT, (ER.statement_start_offset / 2) + 1, (
			(
				CASE ER.statement_end_offset
					WHEN - 1
						THEN DATALENGTH(est.TEXT)
					ELSE ER.statement_end_offset
					END - ER.statement_start_offset
				) / 2
			) + 1) AS QueryText
	,TEXT
	,CPU
	,HOSTNAME
	,LOGIN_TIME
	,LOGINAME
	,SP.STATUS
	,PROGRAM_NAME
	,NT_DOMAIN
	,NT_USERNAME
FROM SYSPROCESSES SP
INNER JOIN sys.dm_exec_requests ER
	ON sp.spid = ER.session_id
CROSS APPLY SYS.DM_EXEC_SQL_TEXT(er.sql_handle) EST
Where DB_NAME(SP.DBID) = 'AnalyticVue_Clayton'
ORDER BY CPU DESC

--========================================================================================================
select * from IDM.DDARole --RoleId,RoleName
select * from IDM.DDAUser --DDAUserId,UserLoginId,DistrictStaffId
select * from IDM.Module  --ModuleId,ModuleName
select * from IDM.ModulePermission --ModuleId,PermissionId
select * from IDM.Org --OrgId,ParentOrgId,OrganizationTypeId,OrgName
select * from IDM.OrgTypeCategory --OrgCategoryId,OrganizationTypeId
select * from IDM.RoleDomain --RoleId,DataDomainId
select * from IDM.RoleModule --RoleModuleId,RoleId,ModuleId
select * from IDM.RoleModulePermission --RoleId,ModuleId,PermissionId
select * from IDM.RoleOrg --RoleOrgId,RoleId,OrgId
select * from IDM.RoleOrgType --RoleId,OrganizationTypeId
select * from IDM.Tenant --TenantId,TenantName
select * from IDM.UserRoleOrg --UserRoleOrgId,DDAUserId,RoleId,OrgId,IsDefaultRole
select * from RefPermission  --PermissionId,PermissionName
select * from refstatus

select du.DDAUserId,du.DistrictStaffId,du.FirstName +' '+ du.LastName as UserName,du.UserLoginId,du.PrimaryEmailId,o.OrgName,r.RoleName
,string_agg(m.ModuleName, '/ ') as Modules,du.LastLoginTime,du.TenantId
from IDM.DDAUser as du
left join IDM.UserRoleOrg as duro on du.TenantId = duro.TenantId and du.DDAUserId =duro.DDAUserId and duro.IsDefaultRole = 1 and duro.StatusId = 1
left join IDM.Org as o on o.TenantId=du.TenantId and o.orgid = duro.orgid
left join IDM.DDARole as r on r.TenantId = du.TenantId and r.RoleId = duro.RoleId
left join IDM.RoleModule as rm on rm.TenantId = duro.TenantId and rm.roleid = duro.RoleId
left join IDM.Module as m on m.tenantid = du.TenantId and m.ModuleId = rm.ModuleId and m.StatusId = 1
left join refstatus as rs on  m.statusid = rs.statusid and du.statusid = rs.statusid
where 1=1 and du.statusid = 1
group by du.DDAUserId,du.DistrictStaffId,du.FirstName, du.LastName,du.UserLoginId,du.PrimaryEmailId,o.OrgName,r.RoleName,du.LastLoginTime,du.TenantId
order by du.TenantId,o.OrgName,du.DDAUserId desc

---==========================================================================================================
select * from clayton_dashboardreportdetails 
where 1 = 1 
--and DashboardName like '%sat%'
--and dataset = 'Clayton_Attendancebyperiod_vw_Ds'
--and ParentReportViewName = 'Clayton_Attendancebyperiod_vw'
order by DashboardName

select * from clayton_batchprocessingstatus
where 1=1
and scheduledday = 'today'
order by 1 desc
---===================================================================================
DECLARE @ReportName NVARCHAR(200) = 'PSAT Proficiency Level % by Grade 10 & 11 - Math';

SELECT rd.*
FROM ReportDetails rd
WHERE rd.ReportDetailsName = @ReportName
  AND EXISTS (
      SELECT 1
      FROM OPENJSON(rd.ReportFileDetails, '$.AdvanceFilter') 
           WITH (
               AliasName NVARCHAR(100) '$.AliasName'
           ) AS j
      WHERE j.AliasName = 'FRL'
  );

---===================================================================================
--All Child Table Reports
SELECT rd.*
FROM reportdetails rd
WHERE rd.ReportDetailsId IN (
    SELECT DISTINCT ChildReportId 
    FROM ReportDetails 
    WHERE 1 = 1 
    AND childreportid IS NOT NULL
) and reporttypeid = 1 and CreatedBy='AnalyticVue.Admin@Clayton';

---===================================================================================
--Datasets of the childreports
select * from rptdomainrelatedviews where domainrelatedviewid in (
SELECT distinct rd.domainrelatedviewid 
FROM reportdetails rd
WHERE rd.ReportDetailsId IN (
    SELECT DISTINCT ChildReportId 
    FROM ReportDetails 
    WHERE 1 = 1 
    AND childreportid IS NOT NULL 
)and reporttypeid = 1 and CreatedBy='AnalyticVue.Admin@Clayton') and isdynamic = 1 and viewname like '%eoc%' or viewname like '%eog%'
;

---===================================================================================
WITH ChildReports AS (
    SELECT DISTINCT ChildReportId 
    FROM ReportDetails 
    Where childreportid IS NOT NULL
),
DynamicViews AS (
    SELECT DISTINCT rd.domainrelatedviewid
    FROM reportdetails rd
    INNER JOIN rptdomainrelatedviews rdrv ON rd.domainrelatedviewid = rdrv.domainrelatedviewid
    WHERE rd.ReportDetailsId IN (
        SELECT ChildReportId 
        FROM ChildReports 
    )
    AND rd.reporttypeid = 1 
    AND rd.CreatedBy = 'AnalyticVue.Admin@Clayton'
    AND rdrv.isdynamic = 1 
    AND rdrv.viewname like '%eoc%' or rdrv.viewname like '%eog%'
)
SELECT rd.* 
FROM reportdetails rd
INNER JOIN ChildReports cr ON rd.ReportDetailsId = cr.ChildReportId
INNER JOIN DynamicViews dmv ON rd.domainrelatedviewid = dmv.domainrelatedviewid
WHERE rd.reporttypeid = 1 
AND rd.CreatedBy = 'AnalyticVue.Admin@Clayton'
AND NOT EXISTS (
    SELECT 1
    FROM OPENJSON(rd.ReportFileDetails, '$.CategoryColumns') AS j
    WHERE j.value = 'GTID'
);

select * from reportdetails where reportdetailsid = 309

select * from reportcolumns where reportdetailsid = 309

---===================================================================================

select * from main.clayton_analyticvue_icstudents where studentnumber = '0460004' and schoolyear = 2025

select * from main.k12school where schoolidentifier=4887

select * from Clayton_Students_5YR where IEP is not NULL

select distinct substring(schoolname,7,len(schoolname))  from Clayton_Students_5YR where schoolname not like '%*%'
select distinct nameofinstitution from main.k12school where schoolidentifier like '%6009%'

select * from refschoolcategory
select * from [Clayton_ProcessLogStatistics]
select * from RefConfiguration

select *From idm.studentssubgroup

---===================================================================================

SELECT 
    o.type_desc AS object_type,
    SCHEMA_NAME(o.schema_id) AS schema_name,
    o.name AS object_name,
    m.definition AS object_definition
FROM 
    sys.sql_modules m
INNER JOIN 
    sys.objects o ON m.object_id = o.object_id
WHERE 
    m.definition LIKE '%main.Clayton_AnalyticVue_ICPrograms%'
    AND o.type IN ('V', 'P', 'FN', 'TF', 'TR') -- View, Procedure, Function, Table-function, Trigger
ORDER BY 
    o.type_desc, o.name;


select r.RoleId,r.RoleName,rd.DashboardId,d.dashboardname
from idm.ddarole r
join RoleDashboard rd on r.roleid = rd.roleid
join Dashboard d on d.DashboardId = rd.DashboardId
where r.rolename = 'District Admin'
order by r.RoleId,rd.DashboardId

select * from dbo.Dashboard where IsDraft=0
select * from dbo.RoleDashboard
where RoleId = 9
select * from dbo.UserDashBoard
select * from dbo.AnalyticProfileDashboard


select distinct d.dashboardname from dbo.RoleDashboard rd
join Dashboard d on rd.DashboardId = d.DashboardId 
intersect
select distinct d.dashboardname
from idm.ddarole r
join RoleDashboard rd on r.roleid = rd.roleid
join Dashboard d on d.DashboardId = rd.DashboardId
where r.rolename = 'District Admin' and d.StatusId = 1 and rd.StatusId = 1

--==================================================================================
exec sp_depends Clayton_SecondaryEnrollment_Programs
exec sp_depends Clayton_SecondaryEnrollmentDetails_View
exec sp_depends Usp_Clayton_SecondaryEnrollment_Programs_Loading

select schoolyear, studentnumber,startdate, enddate, schoolname, OverrideSchoolName 
from Clayton_SecondaryEnrollmentDetails_View
where studentNumber in 
(select studentNumber from (select schoolyear, studentnumber,startdate, enddate, schoolname, OverrideSchoolName,ROW_NUMBER ()over (partition by studentnumber order by studentnumber desc) as rn
from Clayton_SecondaryEnrollmentDetails_View )a where rn = 2)

select studentnumber , count(studentnumber)
from Clayton_SecondaryEnrollmentDetails_View
group by studentnumber having count(studentnumber) > 1

select 96*2
--3819
select * from stage.Clayton_AnalyticVue_ICStudents_NoAction where  studentnumber = '0326430' and schoolyear = 2025 and batchid = 3817

SELECT top 100* FROM Clayton_students_5yr


select schoolyear,grade,count(distinct DistrictStudentId) from dbo.Clayton_DisciplineIncident_Programs
where schoolyear = 2024
group by schoolyear , grade
order by schoolyear,grade

select * from reportdetails order by 1 desc

,case when ic.schooloverride is not null then 'Override School'
			 else 'Home School' end as SchoolType


exec sp_depends Clayton_Attendance_Age_Programs
exec sp_depends Clayton_StudentsAbsentRange_programs

dbo.Clayton_Attendance_Agefilter_Vw

select * from dbo.Clayton_StudentsAbsentRange_Vw

select *from Clayton_DashboardReportDetails where 1 = 1 and dashboardname = 'attendance'


select * from idm.AppErrorLog order by 1 desc

select * from ReportDetails order by 1 desc



--Clayton_OverrideAttendance_Agefilter_Vw
--Clayton_Override_StudentsAbsentRange_Vw
--Clayton_AttendanceStatus_VW


--1342	Override Attendance by Status
--1341	Override Students by Absent Range
--1340	Override Attendance by School Category
--1339	Override Attendance by Race Level
--1338	Override Attendance by Grade Level
--1337	Home School CCRPI Projected Attendance Rate
--1336	Home School Absent
--1335	Home School Students with Perfect Attendance
--1334	Home School Attendance
--1333	Override CCRPI Projected Attendance Rate
--1332	Override Attendance Range Student List
--1331	Override Absent
--1330	Override Students with Perfect Attendance
--1329	Override Attendance List
--1328	Override Attendance
--1327	Attendance by Status Type


--ALTER TABLE Clayton_DisciplineIncident_Programs
--ADD [Override] varchar (150),[SchoolOverrideType] varchar (150),[OverrideSchoolName] varchar (150)

--ALTER TABLE Clayton_DisciplineIncident_Programs
--alter column EIP varchar(10) null 
--ALTER TABLE Clayton_DisciplineIncident_Programs
--alter column GAA varchar(10) null
--ALTER TABLE Clayton_DisciplineIncident_Programs
--alter column REIP varchar(10) null
--ALTER TABLE Clayton_DisciplineIncident_Programs
--alter column IEP varchar(10) null


--,CASE WHEN orr.[SchoolType] = 'Home School' THEN 'No' WHEN orr.[SchoolType] = 'Override School' THEN 'Yes' ELSE NULL END AS [Override]
--,orr.[SchoolType] AS [SchoolOverrideType]
--,orr.[OverrideSchoolName]

--LEFT JOIN Clayton_SecondaryEnrollment_Programs orr
--    ON orr.[studentNumber] = a.[districtstudentiD]
--        AND orr.schoolyear = a.schoolyear
--        AND orr.tenantid = a.tenantid
--        AND orr.schoolnumber = a.schoolidentifier

--[Usp_Clayton_DisciplineIncident_Programs_IOS_Loading]
--[Usp_Clayton_DisciplineIncident_Programs_ODR_Loading]
--[Usp_Clayton_DisciplineIncident_Programs_Loading]


SELECT qsqt.query_sql_text
    ,rs.first_execution_time
    ,rs.last_execution_time
    ,rs.count_executions
    ,rs.avg_duration
    ,rs.avg_cpu_time
    ,rsi.start_time AS stats_interval_start
    ,rsi.end_time AS stats_interval_end
FROM sys.query_store_query_text AS qsqt
INNER JOIN sys.query_store_query AS qsq
    ON qsqt.query_text_id = qsq.query_text_id
INNER JOIN sys.query_store_plan AS qsp
    ON qsq.query_id = qsp.query_id
INNER JOIN sys.query_store_runtime_stats AS rs
    ON qsp.plan_id = rs.plan_id
INNER JOIN sys.query_store_runtime_stats_interval AS rsi
    ON rs.runtime_stats_interval_id = rsi.runtime_stats_interval_id
WHERE rs.first_execution_time >= '2025-06-03 11:00:00'
    AND rs.last_execution_time <= '2025-06-03 11:20:00'
    AND qsqt.query_sql_text LIKE '%idm.ddauser%'




WITH icsource AS (
    SELECT								
        ic.[SchoolNumber],
        ic.[stateID],
        ic.[studentNumber],
        ic.[grade],
        ic.[startDate],
        ic.[endDate],
        ic.[SchoolName],
        ic.[active],
        ic.[servicetype],
        ic.[TenantId],
        ic.[schoolOverride],
        ic.[SchoolYear] 
    FROM main.Clayton_AnalyticVue_ICStudents ic
)

--Students with multiple records in same year (any service type)
--SELECT 
--    'Multiple Records Same Year - All Service Types' AS analysis_type,
--    schoolyear,
--    studentnumber,
--    COUNT(studentnumber) as record_count,
--    STUFF((SELECT DISTINCT ', ' + servicetype 
--           FROM icsource i2 
--           WHERE i2.schoolyear = i1.schoolyear AND i2.studentnumber = i1.studentnumber 
--           FOR XML PATH('')), 1, 2, '') as service_types,
--    STUFF((SELECT DISTINCT ', ' + CAST(SchoolNumber AS VARCHAR(10))
--           FROM icsource i3 
--           WHERE i3.schoolyear = i1.schoolyear AND i3.studentnumber = i1.studentnumber 
--           FOR XML PATH('')), 1, 2, '') as school_numbers
--FROM icsource i1
--GROUP BY schoolyear, studentnumber
--HAVING COUNT(studentnumber) > 1
--ORDER BY schoolyear, studentnumber;

--Students with multiple records in Primary service type only
--SELECT 
--    'Multiple Records Same Year - Primary Service Only' AS analysis_type,
--    schoolyear,
--    studentnumber,
--    COUNT(studentnumber) as record_count,
--    STUFF((SELECT DISTINCT ', ' + CAST(SchoolNumber AS VARCHAR(10))
--           FROM icsource i2 
--           WHERE i2.schoolyear = i1.schoolyear AND i2.studentnumber = i1.studentnumber AND i2.servicetype = 'p'
--           FOR XML PATH('')), 1, 2, '') as school_numbers
--FROM icsource i1
--WHERE servicetype = 'p'
--GROUP BY schoolyear, studentnumber
--HAVING COUNT(studentnumber) > 1
--ORDER BY schoolyear, studentnumber;

--Students with multiple records in Secondary service type only
--SELECT 
--    'Multiple Records Same Year - Secondary Service Only' AS analysis_type,
--    schoolyear,
--    studentnumber,
--    COUNT(studentnumber) as record_count,
--    STUFF((SELECT DISTINCT ', ' + CAST(SchoolNumber AS VARCHAR(10))
--           FROM icsource i2 
--           WHERE i2.schoolyear = i1.schoolyear AND i2.studentnumber = i1.studentnumber AND i2.servicetype = 's'
--           FOR XML PATH('')), 1, 2, '') as school_numbers
--FROM icsource i1
--WHERE servicetype = 's'
--GROUP BY schoolyear, studentnumber
--HAVING COUNT(studentnumber) > 1
--ORDER BY schoolyear, studentnumber;

--Students with Secondary records but NO Primary records in same year
--SELECT 
--    'Secondary Only Students (No Primary in Same Year)' AS analysis_type,
--    s.schoolyear,
--    s.studentnumber,
--    COUNT(s.studentnumber) as secondary_record_count,
--    STUFF((SELECT DISTINCT ', ' + CAST(s2.SchoolNumber AS VARCHAR(10))
--           FROM icsource s2 
--           WHERE s2.schoolyear = s.schoolyear AND s2.studentnumber = s.studentnumber AND s2.servicetype = 's'
--           FOR XML PATH('')), 1, 2, '') as secondary_schools
--FROM icsource s
--WHERE s.servicetype = 's'
--AND NOT EXISTS (
--    SELECT 1 
--    FROM icsource p 
--    WHERE p.studentnumber = s.studentnumber 
--    AND p.schoolyear = s.schoolyear 
--    AND p.servicetype = 'p'
--)
--GROUP BY s.schoolyear, s.studentnumber
--ORDER BY s.schoolyear, s.studentnumber;

-- Students in both Primary and Secondary same year
SELECT 
    'Students in Both Primary and Secondary Same Year' AS analysis_type,
    p.schoolyear,
    p.studentnumber,
    COUNT(DISTINCT CASE WHEN p.servicetype = 'p' THEN p.SchoolNumber END) as primary_schools,
    COUNT(DISTINCT CASE WHEN s.servicetype = 's' THEN s.SchoolNumber END) as secondary_schools,
    STUFF((SELECT DISTINCT ', ' + CAST(p2.SchoolNumber AS VARCHAR(10))
           FROM icsource p2 
           WHERE p2.schoolyear = p.schoolyear AND p2.studentnumber = p.studentnumber AND p2.servicetype = 'p'
           FOR XML PATH('')), 1, 2, '') as primary_school_numbers,
    STUFF((SELECT DISTINCT ', ' + CAST(s2.SchoolNumber AS VARCHAR(10))
           FROM icsource s2 
           WHERE s2.schoolyear = p.schoolyear AND s2.studentnumber = p.studentnumber AND s2.servicetype = 's'
           FOR XML PATH('')), 1, 2, '') as secondary_school_numbers
FROM icsource p
INNER JOIN icsource s ON p.studentnumber = s.studentnumber AND p.schoolyear = s.schoolyear
WHERE p.servicetype = 'p' AND s.servicetype = 's'
GROUP BY p.schoolyear, p.studentnumber
ORDER BY p.schoolyear, p.studentnumber;

-- Students with schoolOverride NOT NULL in Primary service
SELECT 
    'Primary Students with School Override' AS analysis_type,
    schoolyear,
    studentnumber,
    SchoolNumber,
    schoolOverride,
    SchoolName,
    grade,
    active
FROM icsource
WHERE servicetype = 'p' 
AND schoolOverride IS NOT NULL
ORDER BY schoolyear, studentnumber;

-- Students with schoolOverride NOT NULL in Secondary service
SELECT 
    'Secondary Students with School Override' AS analysis_type,
    schoolyear,
    studentnumber,
    SchoolNumber,
    schoolOverride,
    SchoolName,
    grade,
    active
FROM icsource
WHERE servicetype = 's' 
AND schoolOverride IS NOT NULL
ORDER BY schoolyear, studentnumber;

--select * from main.Clayton_AnalyticVue_ICStudents where studentnumber = '0401318'    



WITH UpdatedJSON AS (
    SELECT 
        rd.ReportDetailsId,
        rd.ReportFileDetails,
        CAST(rd.ReportFileDetails AS NVARCHAR(MAX)) AS OriginalJSON,
        JSON_QUERY(rd.ReportFileDetails, '$.AdvanceFilter') AS AdvanceFilterJSON
    FROM reportdetails rd
    WHERE EXISTS (
        SELECT 1
        FROM OPENJSON(rd.ReportFileDetails, '$.AdvanceFilter') 
        WITH (
            DisplayName NVARCHAR(100),
            DefaultValue NVARCHAR(100)
        ) AS j
        WHERE j.DisplayName = 'TestTerm'
          AND j.DefaultValue = 'Winter'
    )
)
--UPDATE rd
--SET ReportFileDetails = JSON_MODIFY(OriginalJSON, '$.AdvanceFilter', 
    (
        SELECT 
            JSON_QUERY('[' + STRING_AGG(
                CASE 
                    WHEN JSON_VALUE(value, '$.DisplayName') = 'TestTerm'
                         AND JSON_VALUE(value, '$.DefaultValue') = 'Winter'
                    THEN JSON_MODIFY(value, '$.DefaultValue', 'Spring')
                    ELSE value
                END, ','
            ) + ']')
        FROM OPENJSON(AdvanceFilterJSON)
    )
)
FROM UpdatedJSON rd;



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
    ro.name = 'Clayton_SecondaryEnrollment_Programs'
    AND ro.type = 'U' -- User tables only
    AND o.type IN ('V', 'P', 'FN', 'IF', 'TF') -- Views, Stored Procedures, Functions
ORDER BY 
    o.type_desc, 
    SchemaName, 
    ObjectName;


WITH ObjectDependencies AS (
    SELECT 
        o.object_id,
        o.name AS ObjectName,
        o.type_desc AS ObjectType,
        SCHEMA_NAME(o.schema_id) AS SchemaName,
        referenced.name AS ReferencedTable
    FROM sys.sql_expression_dependencies d
    INNER JOIN sys.objects o ON d.referencing_id = o.object_id
    INNER JOIN sys.objects referenced ON d.referenced_id = referenced.object_id
    WHERE 
        referenced.name IN ('AggRptK12StudentDetails', 'K12StudentDailyAttendance')
        AND referenced.type = 'U' -- Only user tables
        AND o.type IN ('V', 'P', 'FN', 'IF', 'TF') -- View, SP, scalar/table functions
)
SELECT 
    d1.ObjectName,
    d1.SchemaName,
    d1.ObjectType
FROM ObjectDependencies d1
JOIN ObjectDependencies d2 
    ON d1.object_id = d2.object_id
    AND d1.ReferencedTable = 'AggRptK12StudentDetails'
    AND d2.ReferencedTable = 'K12StudentDailyAttendance'
ORDER BY d1.ObjectType, d1.SchemaName, d1.ObjectName;




SELECT 
    rd.ReportDetailsId,
    rd.reportdetailsname,
    rd.ReportFileDetails,
    CAST(rd.ReportFileDetails AS NVARCHAR(MAX)) AS OriginalJSON,
    JSON_QUERY(rd.ReportFileDetails, '$.SeriesColumn') AS SeriesColumnJSON,
    JSON_QUERY(rd.ReportFileDetails, '$.CategoryColumns') AS CategoryColumnsJSON
FROM reportdetails rd
WHERE 
    rd.reportdetailsname LIKE '%map%' 
    AND (
        EXISTS (
            SELECT 1
            FROM OPENJSON(rd.ReportFileDetails, '$.SeriesColumn') AS j
            WHERE j.value = 'CCPS_Projected_Proficiency' OR j.value = 'proflevel'
        )
        OR
        EXISTS (
            SELECT 1
            FROM OPENJSON(rd.ReportFileDetails, '$.CategoryColumns') AS j
            WHERE j.value = 'CCPS_Projected_Proficiency' OR j.value = 'proflevel'
        )
    )



select * from Clayton_SecondaryEnrollment_Programs

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
    ro.name = 'Clayton_SecondaryEnrollment_Programs'
    AND ro.type = 'U' -- User tables only
    AND o.type IN ('V', 'P', 'FN', 'IF', 'TF') -- Views, Stored Procedures, Functions
ORDER BY 
    o.type_desc, 
    SchemaName, 
    ObjectName;

--Clayton_Override_StudentsAbsentRange_Vw
--Clayton_OverrideAttendance_Agefilter_Vw

select * from ReportDetails 
where ReportDetailsId in
(
844
,845
,1353
,1361
,1362
,1363
,1364
,1365
,1366
,1383
,1385
,1389
,1392
,1403
,1404
,1405
,1406
,1407
,1408
,1409
,1420
,1421
,1422
,1423
,1424
,1425
)
order by 1 desc



SELECT rd.ReportDetailsId, j.*
FROM ReportDetails rd
CROSS APPLY OPENJSON(rd.filterby) WITH (
    Filter nvarchar(100) '$.Filter',
    ComaprisonValue nvarchar(100) '$.ComaprisonValue'
) AS j
WHERE rd.filterby IS NOT NULL 
  AND ISJSON(rd.filterby) = 1
  and j.Filter = 'SchoolOverrideType' 
  AND j.ComaprisonValue = 'Home School'


SELECT rd.ReportDetailsId, j.*
FROM ReportDetails rd
CROSS APPLY OPENJSON(rd.filterby) WITH (
    Filter nvarchar(100) '$.Filter',
    ComaprisonValue nvarchar(100) '$.ComaprisonValue'
) AS j
WHERE rd.filterby IS NOT NULL 
  AND ISJSON(rd.filterby) = 1
  and j.Filter = 'SchoolOverrideType' 
  AND (j.ComaprisonValue = 'Override School' or  j.ComaprisonValue = 'Home School')

SELECT 
    rd.ReportDetailsId,
    filterby,
    JSON_MODIFY(
        filterby, 
        '$[' + CAST(j.[key] AS nvarchar(10)) + '].ComaprisonValue' COLLATE SQL_Latin1_General_CP1_CI_AS, 
        'Servicing School (Attending)' COLLATE SQL_Latin1_General_CP1_CI_AS
    ) AS Updated_JSON
FROM ReportDetails rd
CROSS APPLY OPENJSON(rd.filterby) j
CROSS APPLY OPENJSON(j.value) WITH (
    Filter nvarchar(100) '$.Filter',
    ComaprisonValue nvarchar(100) '$.ComaprisonValue'
) AS parsed
WHERE rd.filterby IS NOT NULL 
  AND ISJSON(rd.filterby) = 1
  AND parsed.Filter = 'SchoolOverrideType' 
  AND parsed.ComaprisonValue = 'Zoned Home School'


select ReportDetailsId from (select * from reportdetails
where reportdetailsname like '%Home School/Override%'
union 
select * from reportdetails
where reportdetailsname like '%Override School%'
union 
select * from reportdetails
where reportdetailsname like '%Home School%' and reportdetailsname not like '%Home School/Override%')a where filterby <> ''
except

SELECT rd.ReportDetailsId
FROM ReportDetails rd
CROSS APPLY OPENJSON(rd.filterby) WITH (
    Filter nvarchar(100) '$.Filter',
    ComaprisonValue nvarchar(100) '$.ComaprisonValue'
) AS j
WHERE rd.filterby IS NOT NULL 
  AND ISJSON(rd.filterby) = 1
  and j.Filter = 'SchoolOverrideType' 
  AND (j.ComaprisonValue = 'Override School' or  j.ComaprisonValue = 'Home School')

  
select * from Clayton_DashboardReportDetails where groupname = 'Override/Home School'




WITH UpdatedJSON
AS (
	SELECT rd.ReportDetailsId
		,rd.ReportFileDetails
		,CAST(rd.ReportFileDetails AS NVARCHAR(MAX)) AS OriginalJSON
		,JSON_QUERY(rd.ReportFileDetails, '$.AdvanceFilter') AS AdvanceFilterJSON
	FROM reportdetails rd
	WHERE EXISTS (
			SELECT 1
			FROM OPENJSON(rd.ReportFileDetails, '$.AdvanceFilter') WITH (
					DisplayName NVARCHAR(100)
					,DefaultValue NVARCHAR(100)
					) AS j
			WHERE j.DisplayName = 'SchoolYear'
				AND j.DefaultValue = '2023' 
				--AND j.DefaultValue = '2023,2023'
			)
		AND ReportDetailsId IN (888, 884, 878, 875, 874, 873, 863, 862, 861, 454, 451, 448, 444, 362, 361, 360, 359, 358, 357, 356, 321, 320, 319, 318)
	)
--UPDATE rd
--SET ReportFileDetails = JSON_MODIFY(OriginalJSON, '$.AdvanceFilter', 
select JSON_MODIFY(OriginalJSON, '$.AdvanceFilter',
    (
        SELECT 
            JSON_QUERY('[' + STRING_AGG(
                CASE 
                    WHEN JSON_VALUE(value, '$.DisplayName') = 'SchoolYear'
                         AND JSON_VALUE(value, '$.DefaultValue') = '2023'
                    THEN JSON_MODIFY(value, '$.DefaultValue', '2023, 2022')
                    ELSE value
                END, ','
            ) + ']')
        FROM OPENJSON(AdvanceFilterJSON)
    )
)
FROM UpdatedJSON rd;


WITH UpdatedJSON AS (
    SELECT rd.ReportDetailsId
        ,rd.ReportFileDetails
        ,CAST(rd.ReportFileDetails AS NVARCHAR(MAX)) AS OriginalJSON
        ,JSON_QUERY(rd.ReportFileDetails, '$.AdvanceFilter') AS AdvanceFilterJSON
    FROM reportdetails rd
    WHERE EXISTS (
            SELECT 1
            FROM OPENJSON(rd.ReportFileDetails, '$.AdvanceFilter') WITH (
                    DisplayName NVARCHAR(100)
                    ,DefaultValue NVARCHAR(100)
                    ) AS j
            WHERE j.DisplayName = 'TestTerm'
            )
        AND ReportDetailsId IN (888, 884, 878, 875, 874, 873, 863, 862, 861, 454, 451, 448, 444, 362, 361, 360, 359, 358, 357, 356, 321, 320, 319, 318)
),
ProcessedFilters AS (
    SELECT 
        rd.ReportDetailsId,
        rd.OriginalJSON,
        '[' + STRING_AGG(
            CASE 
                WHEN af.DisplayName = 'TestTerm'
                THEN JSON_OBJECT(
                    'DisplayName': af.DisplayName,
                    'ColumnName': af.ColumnName,
                    'AliasName': af.AliasName,
                    'SortOrder': af.SortOrder,
                    'FiledId': af.FiledId,
                    'DefaultValue': NULL
                )
                ELSE JSON_OBJECT(
                    'DisplayName': af.DisplayName,
                    'ColumnName': af.ColumnName,
                    'AliasName': af.AliasName,
                    'SortOrder': af.SortOrder,
                    'FiledId': af.FiledId,
                    'DefaultValue': af.DefaultValue
                )
            END, ','
        ) + ']' AS NewAdvanceFilter
    FROM UpdatedJSON rd
    CROSS APPLY OPENJSON(rd.AdvanceFilterJSON) WITH (
        DisplayName NVARCHAR(100),
        ColumnName NVARCHAR(100),
        AliasName NVARCHAR(100),
        SortOrder INT,
        FiledId NVARCHAR(50),
        DefaultValue NVARCHAR(100)
    ) af
    GROUP BY rd.ReportDetailsId, rd.OriginalJSON
)
 Preview the changes:
SELECT 
    ReportDetailsId,
    OriginalJSON AS BeforeUpdate,
    JSON_MODIFY(OriginalJSON, '$.AdvanceFilter', JSON_QUERY(NewAdvanceFilter)) AS AfterUpdate
FROM ProcessedFilters;

 --UPDATE rd
 --SET ReportFileDetails = JSON_MODIFY(pf.OriginalJSON, '$.AdvanceFilter', JSON_QUERY(pf.NewAdvanceFilter))
 --FROM reportdetails rd
 --INNER JOIN ProcessedFilters pf ON rd.ReportDetailsId = pf.ReportDetailsId;



 
WITH UpdatedJSON AS (
    SELECT rd.ReportDetailsId
        ,rd.ReportFileDetails
        ,CAST(rd.ReportFileDetails AS NVARCHAR(MAX)) AS OriginalJSON
        ,JSON_QUERY(rd.ReportFileDetails, '$.CategoryColumns') AS CategoryColumnsJSON
    FROM reportdetails rd
    WHERE JSON_QUERY(rd.ReportFileDetails, '$.CategoryColumns') IS NOT NULL
        AND ReportDetailsId IN (888, 884, 878, 875, 874, 873, 863, 862, 861, 454, 451, 448, 444, 362, 361, 360, 359, 358, 357, 356, 321, 320, 319, 318)
        -- Only process records where SchoolYear is NOT already present
        AND NOT EXISTS (
            SELECT 1 
            FROM OPENJSON(rd.ReportFileDetails, '$.CategoryColumns') 
            WHERE value = 'SchoolYear'  -- Removed quotes since value is already a string
        )
),
ProcessedCategories AS (
    SELECT 
        rd.ReportDetailsId,
        rd.OriginalJSON,
        -- Create new CategoryColumns array by appending SchoolYear
        '[' + STRING_AGG('"' + value + '"', ',') + ',"SchoolYear"]' AS NewCategoryColumns
    FROM UpdatedJSON rd
    CROSS APPLY OPENJSON(rd.CategoryColumnsJSON) cc
    GROUP BY rd.ReportDetailsId, rd.OriginalJSON
)
-- Preview the changes:
--SELECT 
--    ReportDetailsId,
--    JSON_QUERY(OriginalJSON, '$.CategoryColumns') AS BeforeCategoryColumns,
--    NewCategoryColumns AS AfterCategoryColumns,
--    OriginalJSON AS BeforeUpdate,
--    JSON_MODIFY(OriginalJSON, '$.CategoryColumns', JSON_QUERY(NewCategoryColumns)) AS AfterUpdate
--FROM ProcessedCategories;

 --UPDATE rd
 --SET ReportFileDetails = JSON_MODIFY(pc.OriginalJSON, '$.CategoryColumns', JSON_QUERY(pc.NewCategoryColumns))
 --FROM reportdetails rd
 --INNER JOIN ProcessedCategories pc ON rd.ReportDetailsId = pc.ReportDetailsId;


 
-- Generate INSERT statements for all reports that need SchoolYear column
WITH ReportsNeedingSchoolYear AS (
    SELECT DISTINCT rd.ReportDetailsId, rd.TenantId, rrr.DomainRelatedViewId
    FROM reportdetails rd
        join rptDomainRelatedViews rrr on rrr.DomainRelatedViewId = rd.DomainRelatedViewId

    WHERE rd.ReportDetailsId IN (888, 884, 878, 875, 874, 873, 863, 862, 861, 454, 451, 448, 444, 362, 361, 360, 359, 358, 357, 356, 321, 320, 319, 318)
    -- Only include reports that don't already have SchoolYear in ReportColumns
    AND NOT EXISTS (
        SELECT 1 
        FROM ReportColumns rc
        INNER JOIN RptViewFields rvf ON rc.RptViewFieldsId = rvf.RptViewFieldsId
        WHERE rc.ReportDetailsId = rd.ReportDetailsId 
        AND rvf.ColumnName = '[SchoolYear]'
    )
    -- And have CategoryColumns that we've updated
    AND EXISTS (
        SELECT 1 
        FROM OPENJSON(rd.ReportFileDetails, '$.CategoryColumns') 
        WHERE value = 'SchoolYear'
    )
),
InsertStatements AS (
    SELECT 
        rns.ReportDetailsId,
        rns.TenantId,
        rns.DomainRelatedViewId,
        -- Generate the INSERT statement
        'INSERT INTO ReportColumns(' +
        'ReportDetailsId, IsAggregate, AggregateId, IsCategory, IsSeries, ' +
        'RptViewFieldsId, FileTemplateFieldId, IsCustom, SortOrder, TenantId, ' +
        'StatusId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, ComboChartType) ' +
        'VALUES (' + 
        CAST(rns.ReportDetailsId AS VARCHAR(10)) + ', ' +    -- ReportDetailsId
        '0, ' +                                              -- IsAggregate
        'NULL, ' +                                           -- AggregateId  
        '1, ' +                                              -- IsCategory (1 since it's in CategoryColumns)
        '0, ' +                                              -- IsSeries
        CAST(rvf.RptViewFieldsId AS VARCHAR(10)) + ', ' + -- RptViewFieldsId (use 2933 as fallback)
        'NULL, ' +                                           -- FileTemplateFieldId
        '0, ' +                                              -- IsCustom
        CAST(COALESCE(maxSort.MaxSortOrder + 1, 1) AS VARCHAR(5)) + ', ' + -- SortOrder
        CAST(rns.TenantId AS VARCHAR(10)) + ', ' +           -- TenantId
        '1, ' +                                              -- StatusId
        '''AnalyticVue.Admin@Clayton'', ' +                  -- CreatedBy
        'GETDATE(), ' +                                      -- CreatedDate
        'NULL, ' +                                           -- ModifiedBy
        'NULL, ' +                                           -- ModifiedDate
        'NULL);' AS InsertStatement                          -- ComboChartType
    FROM ReportsNeedingSchoolYear rns
    JOIN RptViewFields rvf ON rvf.ColumnName = '[SchoolYear]' and rns.DomainRelatedViewId = rvf.DomainRelatedViewId
    JOIN (
        -- Get the current max SortOrder for each report
        SELECT ReportDetailsId, MAX(SortOrder) AS MaxSortOrder
        FROM ReportColumns 
        WHERE ReportDetailsId IN (SELECT ReportDetailsId FROM ReportsNeedingSchoolYear)
        GROUP BY ReportDetailsId
    ) maxSort ON maxSort.ReportDetailsId = rns.ReportDetailsId
)
-- Display the INSERT statements
SELECT 
    ReportDetailsId,
    TenantId,
    DomainRelatedViewId,
    InsertStatement
FROM InsertStatements
ORDER BY ReportDetailsId;

-- Alternative: Execute all INSERTs at once (uncomment to use)
-- DECLARE @sql NVARCHAR(MAX) = '';
-- SELECT @sql = @sql + InsertStatement + CHAR(13) + CHAR(10)
-- FROM InsertStatements;
-- EXEC sp_executesql @sql;

-- Verification query to check what was inserted
-- SELECT rc.*, rvf.FieldName, rvf.AliasName
-- FROM ReportColumns rc
-- INNER JOIN RptViewFields rvf ON rc.RptViewFieldsId = rvf.RptViewFieldsId
-- WHERE rc.ReportDetailsId IN (888, 884, 878, 875, 874, 873, 863, 862, 861, 454, 451, 448, 444, 362, 361, 360, 359, 358, 357, 356, 321, 320, 319, 318)
-- AND rvf.FieldName = 'SchoolYear'
-- ORDER BY rc.ReportDetailsId;

SELECT ds.[Monthname] AS [Monthname]
	,cast(Avg(cast(ISNULL(ds.[Presentpercentage], 0) AS DECIMAL(15, 1))) AS DECIMAL(15, 1)) AS [Presentpercentage]
	,cast(Avg(cast(ISNULL(ds.[AbsenteeismPercentage], 0) AS DECIMAL(15, 1))) AS DECIMAL(15, 1)) AS [AbsenteeismPercentage]
FROM dbo.ClaytonAttendanceDateRangeDS AS ds WITH (NOLOCK)
LEFT JOIN dbo.Clayton_MontName_SortOrder_Vw
	ON ds.[Monthname] = dbo.Clayton_MontName_SortOrder_Vw.MonthName
		AND ds.tenantid = dbo.Clayton_MontName_SortOrder_Vw.tenantid
WHERE (
		(ISNUMERIC(ISNULL(ds.[Presentpercentage], 0)) = 1)
		AND (ISNUMERIC(ISNULL(ds.[AbsenteeismPercentage], 0)) = 1)
		AND (ds.[SchoolYear] IN ('2025'))
		AND (ds.TenantId = 50)
		)
GROUP BY ds.[Monthname]
	,dbo.Clayton_MontName_SortOrder_Vw.SortOrder
ORDER BY dbo.Clayton_MontName_SortOrder_Vw.SortOrder ASC
	,ds.[Monthname] ASC;


--CREATE VIEW [dbo].[Clayton_Attendance_Vw_DELETE]  --32819414  --33667547
--AS
SELECT SD.SchoolYear
	,SD.LEAIdentifier
	,SD.SchoolIdentifier
	,SD.DistrictStudentId
	,attendancedate
	,MembershipDaysCount AS TotalDays
	,PresentDaysCount AS TotalDaysPresent
	,AbsentDaysCount AS TotalDaysAbsent
	,AbsentPercentage AS AbsenteeismPercentage
	,Presentrate AS Presentpercentage
	,DATENAME(mm, AttendanceDate) AS 'Monthname'
	,sdg.FirstName
	,sdg.LastorSurname
	,sdg.StudentFullName
	,sdg.BirthDate
	,sdg.LeaName
	,sdg.SchoolName
	,sdg.Gender
	,sdg.Grade
	,sdg.SchoolCategory
	,sdg.Race
	,sdg.GiftedandTalented
	,sdg.ELL
	,sdg.StateStudentId
	,sdg.FRL
	,sdg.DisabilityReason AS Disability
	,sdg.SpecialEdStatus
	,sdg.[504Status]
	,sdg.Ethnicity
	,sdg.HispanicLatino
	,sdg.EllProgram
	,sdg.TenantId
	,NULL AS IEP
	,sdg.AgeGroup
	,CASE WHEN Agegroup < 6 THEN 'Students under age 6' WHEN Agegroup >= 6
			AND Agegroup <= 15 THEN 'Students age between 6 and 15' WHEN Agegroup >= 16 THEN 'Students age 16 and over' END AS AgeCategory
	,ca.GAA
	,ca.EIP
	,ca.Homeless
	,ca.REIP
	,CASE WHEN orr.[SchoolType] = 'Servicing School (Attending)' THEN 'No' WHEN orr.[SchoolType] = 'Zoned Home School' THEN 'Yes' ELSE NULL END AS [Override]
	,orr.[SchoolType] AS [SchoolOverrideType]
	,orr.[OverrideSchoolName]
FROM [Main].[K12StudentDailyAttendance] SD
INNER JOIN aggrptk12studentdetails SDG
	ON SD.DistrictStudentId = SDG.DistrictStudentId
		AND sd.LEAIdentifier = sdg.LEAIdentifier
		AND sd.SchoolIdentifier = sdg.SchoolIdentifier
		AND sd.SchoolYear = sdg.SchoolYear
		AND sd.TenantId = sdg.TenantId
LEFT JOIN Clayton_StudentProgram ca
	ON SD.DistrictStudentId = ca.DistrictStudentId
		AND SD.SchoolYear = ca.SchoolYear
		AND SD.TenantId = ca.TenantId
		AND SD.SchoolIdentifier = ca.SchoolIdentifier
LEFT JOIN Clayton_SecondaryEnrollment_Programs orr
	ON orr.[studentNumber] = SD.[districtstudentiD]
		AND orr.schoolyear = SD.schoolyear
		AND orr.tenantid = SD.tenantid
		AND orr.schoolnumber = SD.schoolidentifier
WHERE sdg.MembershipDaysCount IS NOT NULL

select schoolyear,districtstudentid from Clayton_StudentProgram group by schoolyear , districtstudentid having count(districtstudentid)>1
select schoolyear,studentnumber,schoolnumber from Clayton_SecondaryEnrollment_Programs group by schoolyear , studentnumber,schoolnumber having count(studentnumber)>1

select * from clayton_secondaryenrollment_programs where studentnumber = '0485444' and schoolyear = 2025 
select * from main.clayton_analyticvue_icstudents where studentnumber = '0485444' and schoolyear = 2025 

select schoolyear,studentnumber,schoolnumber 
from Clayton_SecondaryEnrollment_Programs 
where schoolOverride is not null
group by schoolyear , studentnumber,schoolnumber having count(studentnumber)>1

select schoolyear,studentnumber 
from Clayton_SecondaryEnrollment_Programs 
where schoolOverride is not null
group by schoolyear,studentnumber having count(DISTINCT schoolOverride)>1

select * from [Export_EOC Fall Mid Months 2023] where len(SchCode_RPT)= 3
select * from [Export_EOC_Fall_2023] where len(SchCode_RPT)= 3
select * from [Export_EOC Winter Mid Months 2023] where len(SchCode_RPT)= 3
select * from [Export_Updated_EOC_Winter_2023] where len(SchCode_RPT)= 3
select * from [Export_EOC_Spring_2023] where len(SchCode_RPT)= 3

select 
    distinct gtid_rpt
from [Export_EOC_Fall_2023] WITH (NOLOCK)
group by gtid_rpt,testadmin,contentarea
having count(*) > 1

select distinct TestAdmin from [dbo].[Export_EOC Fall Mid Months 2023]
select distinct TestAdmin from [dbo].[Export_EOC_Fall_2023]

select distinct TestAdmin from [dbo].[Export_EOC Winter Mid Months 2023]  
select distinct TestAdmin from [dbo].[Export_Updated_EOC_Winter_2023]

select distinct TestAdmin from [dbo].[Export_EOC_Spring_2023]

select * from [Export_EOC Fall Mid Months 2023] where gtid_rpt = '2503207758'
select * from [Export_EOC_Fall_2023] where gtid_rpt = '2503207758'

select * from Export_EOC_Fall_Combined_2023

select * from (
-- Matching rows from [Export_EOC_Winter 2022]
select ew.GTID_RPT, ew.RESAName_RPT, ew.SysCode_RPT, ew.SchCode_RPT, ew.SysName_RPT, ew.SchName_RPT, ew.CLSName_RPT, ew.StuLastName_RPT, ew.StuFirstName_RPT, ew.StuMidInitial_RPT, ew.StuGrade_RPT, ew.StuDOBMonth_RPT, ew.StuDOBDay_RPT, ew.StuDOBYear_RPT, ew.StuGender_RPT, ew.EthnicityRace_RPT, ew.SRC01_RPT, ew.SRC02_RPT, ew.SRC03_RPT, ew.SRC04_RPT, ew.SRC05_RPT, ew.SRC06_RPT, ew.SRC07_RPT, ew.SRC08_RPT, ew.SRC09_RPT, ew.SRC10_RPT, ew.SRC11_RPT, ew.SRC12_RPT, ew.EL_RPT, ew.Section504_RPT, ew.Migrant_RPT, ew.ELF_RPT, ew.SDUA_GAVS_RPT, ew.EOCPurpose_RPT, ew.RetestFlag, ew.TestOutFlag, ew.IR_RPT, ew.IV_RPT, ew.PIV_RPT, ew.PTNA_RPT, ew.ME_RPT, ew.DNA_RPT, ew.SWDFlag, ew.Braille, ew.VideoSignLang, ew.SummaryRPTFlag, ew.Scribe, ew.TestFormScoring, ew.TestMode, ew.SDUBCode_RPT, ew.DupInvalid, ew.LocalOptCoding1, ew.LocalOptCoding2, ew.LocalOptCoding3, ew.LocalOptCoding4, ew.IR_COLLECTED, ew.IV_COLLECTED, ew.PIV_COLLECTED, ew.PTNAFlag_COLLECTED, ew.ME_COLLECTED, ew.SDUBCode_COLLECTED, ew.CondAdmin_COLLECTED, ew.AccomIEP_COLLECTED, ew.AccomELTPC_COLLECTED, ew.AccomIAP_COLLECTED, ew.AccomST_COLLECTED, ew.AccomPRS_COLLECTED, ew.AccomRSP_COLLECTED, ew.AccomSCH_COLLECTED, ew.Audio, ew.ColorChooser, ew.ContrastingColor, ew.AudioPassages, ew.HumanReader, ew.HumanReaderPassage, ew.ContentArea, ew.ContentAreaCode, ew.SS, ew.ACHLevel, ew.CondSEM, ew.CondSEMHigh, ew.CondSEMLow, ew.GCS, ew.Lexile, ew.LexileL, ew.LexileLow, ew.LexileHigh, ew.EXTWRTGenre, ew.EXTWRT1Score, ew.EXTWRT2Score, ew.EXTWRT1CondCode, ew.EXTWRT2CondCode, ew.NARRWRTScore, ew.NARRWRTCondCode, ew.StretchBand, ew.ReadingStatus, ew.MasteryCategoryDom1, ew.MasteryCategoryDom2, ew.MasteryCategoryDom3, ew.MasteryCategoryDom4, ew.MasteryCategoryDom5, ew.MasteryCategoryDom6, ew.MasteryCategoryDom7, ew.MasteryCategoryDom8, ew.MasteryCategoryDom9, ew.MasteryCategoryDom10, ew.MasteryCategoryDom11, ew.NRT_NPRange, ew.SGP_FINAL, ew.SGP_LEVEL, ew.SCHOOL_YEAR_PRIOR_1, ew.SUBJECT_CODE_PRIOR_1, ew.SCALE_SCORE_PRIOR_1, ew.ACH_LEVEL_PRIOR_1, ew.GRADE_PRIOR_1, ew.ADMINISTRATION_PERIOD_PRIOR_1, ew.ASSESSMENT_TYPE_PRIOR_1, ew.SCHOOL_YEAR_PRIOR_2, ew.SUBJECT_CODE_PRIOR_2, ew.SCALE_SCORE_PRIOR_2, ew.ACH_LEVEL_PRIOR_2, ew.GRADE_PRIOR_2, ew.ADMINISTRATION_PERIOD_PRIOR_2, ew.ASSESSMENT_TYPE_PRIOR_2, ew.TestAdmin, ew.TestDate, ew.AdminInd, ew.FileRunType, ew.EOR, ew.StudentID_DRCUse, ew.DocumentID_DRCUse, ew.TestEventID_DRCUse, ew.ClassID_DRCUse, ew.CharterSchoolID_DRCUse, ew.ResaCode_DRCUse, ew.ContentAreaSort_DRCUse, ew.Other_Fields_DRCUse
from [Export_Updated_EOC_Winter_2023] ew
inner join [Export_EOC Winter Mid Months 2023] mm
    on ew.GTID_RPT = mm.GTID_RPT
    and ew.ContentArea = mm.ContentArea
    and ew.TestAdmin = mm.TestAdmin

union all

-- Remaining unmatched rows from [Export_EOC Winter mid months 2022]
select mm.GTID_RPT, mm.RESAName_RPT, mm.SysCode_RPT, mm.SchCode_RPT, mm.SysName_RPT, mm.SchName_RPT, mm.CLSName_RPT, mm.StuLastName_RPT, mm.StuFirstName_RPT, mm.StuMidInitial_RPT, mm.StuGrade_RPT, mm.StuDOBMonth_RPT, mm.StuDOBDay_RPT, mm.StuDOBYear_RPT, mm.StuGender_RPT, mm.EthnicityRace_RPT, mm.SRC01_RPT, mm.SRC02_RPT, mm.SRC03_RPT, mm.SRC04_RPT, mm.SRC05_RPT, mm.SRC06_RPT, mm.SRC07_RPT, mm.SRC08_RPT, mm.SRC09_RPT, mm.SRC10_RPT, mm.SRC11_RPT, mm.SRC12_RPT, mm.EL_RPT, mm.Section504_RPT, mm.Migrant_RPT, mm.ELF_RPT, mm.SDUA_GAVS_RPT, mm.EOCPurpose_RPT, mm.RetestFlag, mm.TestOutFlag, mm.IR_RPT, mm.IV_RPT, mm.PIV_RPT, mm.PTNA_RPT, mm.ME_RPT, mm.DNA_RPT, mm.SWDFlag, mm.Braille, mm.VideoSignLang, mm.SummaryRPTFlag, mm.Scribe, mm.TestFormScoring, mm.TestMode, mm.SDUBCode_RPT, mm.DupInvalid, mm.LocalOptCoding1, mm.LocalOptCoding2, mm.LocalOptCoding3, mm.LocalOptCoding4, mm.IR_COLLECTED, mm.IV_COLLECTED, mm.PIV_COLLECTED, mm.PTNAFlag_COLLECTED, mm.ME_COLLECTED, mm.SDUBCode_COLLECTED, mm.CondAdmin_COLLECTED, mm.AccomIEP_COLLECTED, mm.AccomELTPC_COLLECTED, mm.AccomIAP_COLLECTED, mm.AccomST_COLLECTED, mm.AccomPRS_COLLECTED, mm.AccomRSP_COLLECTED, mm.AccomSCH_COLLECTED, mm.Audio, mm.ColorChooser, mm.ContrastingColor, mm.AudioPassages, mm.HumanReader, mm.HumanReaderPassage, mm.ContentArea, mm.ContentAreaCode, mm.SS, mm.ACHLevel, mm.CondSEM, mm.CondSEMHigh, mm.CondSEMLow, mm.GCS, mm.Lexile, mm.LexileL, mm.LexileLow, mm.LexileHigh, mm.EXTWRTGenre, mm.EXTWRT1Score, mm.EXTWRT2Score, mm.EXTWRT1CondCode, mm.EXTWRT2CondCode, mm.NARRWRTScore, mm.NARRWRTCondCode, mm.StretchBand, mm.ReadingStatus, mm.MasteryCategoryDom1, mm.MasteryCategoryDom2, mm.MasteryCategoryDom3, mm.MasteryCategoryDom4, mm.MasteryCategoryDom5, mm.MasteryCategoryDom6, mm.MasteryCategoryDom7, mm.MasteryCategoryDom8, mm.MasteryCategoryDom9, mm.MasteryCategoryDom10, mm.MasteryCategoryDom11, mm.NRT_NPRange, mm.SGP_FINAL, mm.SGP_LEVEL, mm.SCHOOL_YEAR_PRIOR_1, mm.SUBJECT_CODE_PRIOR_1, mm.SCALE_SCORE_PRIOR_1, mm.ACH_LEVEL_PRIOR_1, mm.GRADE_PRIOR_1, mm.ADMINISTRATION_PERIOD_PRIOR_1, mm.ASSESSMENT_TYPE_PRIOR_1, mm.SCHOOL_YEAR_PRIOR_2, mm.SUBJECT_CODE_PRIOR_2, mm.SCALE_SCORE_PRIOR_2, mm.ACH_LEVEL_PRIOR_2, mm.GRADE_PRIOR_2, mm.ADMINISTRATION_PERIOD_PRIOR_2, mm.ASSESSMENT_TYPE_PRIOR_2, mm.TestAdmin, mm.TestDate, mm.AdminInd, mm.FileRunType, mm.EOR, mm.StudentID_DRCUse, mm.DocumentID_DRCUse, mm.TestEventID_DRCUse, mm.ClassID_DRCUse, mm.CharterSchoolID_DRCUse, mm.ResaCode_DRCUse, mm.ContentAreaSort_DRCUse, mm.Other_Fields_DRCUse
from [Export_EOC Winter Mid Months 2023] mm
where not exists (
    select 1
    from [Export_Updated_EOC_Winter_2023] ew
    where ew.GTID_RPT = mm.GTID_RPT
      and ew.ContentArea = mm.ContentArea
      and ew.TestAdmin = mm.TestAdmin
)) a


select distinct GTID_RPT from [dbo].[Export_EOC Fall Mid Months 2023]
intersect
select distinct GTID_RPT from [dbo].[Export_EOC_Fall_2023]

select distinct GTID_RPT from [dbo].[Export_EOC Winter Mid Months 2023]  
select distinct GTID_RPT from [dbo].[Export_Updated_EOC_Winter_2023]

select distinct GTID_RPT from [dbo].[Export_EOC_Spring_2023]


declare @columns nvarchar(max);

select @columns = string_agg(name, ', ew.')
from sys.columns
where object_id = object_id('[Export_EOC Winter Mid Months 2023]')

   and name not like '%filler%'  -- Uncomment and edit if needed

select @columns as ColumnList;


select * from #temp_EOC_2023_FALL where len(SchCode_RPT) = 3 
select * from [Export_EOC Fall Mid Months 2023] where gtid_rpt in (select distinct GTID_RPT from #temp_EOC_2023_Winter where len(SchCode_RPT) = 3 
)
select * from [Export_EOC_Fall_2023] where gtid_rpt in (select distinct GTID_RPT from #temp_EOC_2023_Winter where len(SchCode_RPT) = 3 
)

select * from #temp_EOC_2022_Winter where len(SchCode_RPT) = 3 
select * from #temp_EOC_2023_Winter where len(StuGrade_RPT) = 1
select * from #temp_EOC_2023_Winter where len(StuDOBMonth_RPT) = 1
select * from #temp_EOC_2023_Winter where len(SchCode_RPT) = 3 

select * from [Export_EOC Winter Mid Months 2023] where gtid_rpt = '6196742663'
select * from [Export_Updated_EOC_Winter_2023] where gtid_rpt = '6196742663'


WITH CategoryColumns AS (
    SELECT 
        rd.ReportDetailsId,
        rd.DomainRelatedViewId,
        category.value AS CategoryColumn
    FROM reportdetails rd
    CROSS APPLY OPENJSON(rd.ReportFileDetails, '$.CategoryColumns') AS category
    WHERE rd.reporttypeid = 2
    AND rd.CreatedBy = 'AnalyticVue.Admin@Clayton'
    AND JSON_QUERY(rd.ReportFileDetails, '$.CategoryColumns') IS NOT NULL
),
SubGroupColumns AS (
    SELECT 
        rd.ReportDetailsId,
        rd.DomainRelatedViewId,
        subgroup.ColumnName AS SubGroupColumnName
    FROM reportdetails rd
    CROSS APPLY OPENJSON(rd.ReportFileDetails, '$.SubGroupColumns') WITH (
        ColumnName nvarchar(100) '$.ColumnName'
    ) AS subgroup
    WHERE rd.reporttypeid = 2
    AND rd.CreatedBy = 'AnalyticVue.Admin@Clayton'
    AND JSON_QUERY(rd.ReportFileDetails, '$.SubGroupColumns') IS NOT NULL
)
,ReportsNeedingUpdate as (
    SELECT 
    cc.ReportDetailsId,
    cc.DomainRelatedViewId,
    --STRING_AGG(cc.CategoryColumn, ', ') AS CategoryColumns
    cc.CategoryColumn AS CategoryColumns
FROM CategoryColumns cc
WHERE NOT EXISTS (
    SELECT 1 
    FROM SubGroupColumns sc 
    WHERE sc.ReportDetailsId = cc.ReportDetailsId 
    AND sc.SubGroupColumnName = cc.CategoryColumn
)),
-- Get the FieldIds for each column
FieldIds AS (
    SELECT 
        rnu.ReportDetailsId,
        rnu.CategoryColumns,
        rv.RptViewFieldsId AS FieldId,
        rv.DisplayName
    FROM ReportsNeedingUpdate rnu
    JOIN rptviewfields rv ON rnu.DomainRelatedViewId = rv.DomainRelatedViewId
    WHERE 
        rv.ColumnName = '[' + REPLACE(rnu.CategoryColumns, ' ', '') + ']' OR
        rv.ColumnName = rnu.CategoryColumns OR
        rv.DisplayName = rnu.CategoryColumns
)
select * from fieldids
--GROUP BY cc.ReportDetailsId,cc.DomainRelatedViewId
--ORDER BY cc.ReportDetailsId;


--select * from ReportDetails where reportdetailsid = 285



--select * from RptDomainRelatedViews where DomainRelatedViewId = 152
--select * from IDM.DataSetColumn where DomainRelatedViewId = 152 and columnname = 'DistrictName'
--select * from rptviewfields  where DomainRelatedViewId = 152 and columnname = '[DistrictName]'


WITH CategoryColumns AS (
    SELECT 
        rd.ReportDetailsId,
        rd.ReportDetailsName,
        rd.DomainRelatedViewId,
        category.value AS CategoryColumn
    FROM reportdetails rd
    CROSS APPLY OPENJSON(rd.ReportFileDetails, '$.CategoryColumns') AS category
    WHERE rd.reporttypeid = 2
    AND rd.CreatedBy = 'AnalyticVue.Admin@Clayton'
    AND JSON_QUERY(rd.ReportFileDetails, '$.CategoryColumns') IS NOT NULL
),
SubGroupColumns AS (
    SELECT 
        rd.ReportDetailsId,
        rd.DomainRelatedViewId,
        subgroup.ColumnName AS SubGroupColumnName
    FROM reportdetails rd
    CROSS APPLY OPENJSON(rd.ReportFileDetails, '$.SubGroupColumns') WITH (
        ColumnName nvarchar(100) '$.ColumnName'
    ) AS subgroup
    WHERE rd.reporttypeid = 2
    AND rd.CreatedBy = 'AnalyticVue.Admin@Clayton'
    AND JSON_QUERY(rd.ReportFileDetails, '$.SubGroupColumns') IS NOT NULL
)
,ReportsNeedingUpdate as (
    SELECT 
    cc.ReportDetailsId,
    cc.ReportDetailsName,
    cc.DomainRelatedViewId,
    STRING_AGG(cc.CategoryColumn, ', ') AS CategoryColumns
    --cc.CategoryColumn AS CategoryColumns
FROM CategoryColumns cc
WHERE NOT EXISTS (
    SELECT 1 
    FROM SubGroupColumns sc 
    WHERE sc.ReportDetailsId = cc.ReportDetailsId 
    AND sc.SubGroupColumnName = cc.CategoryColumn
)
GROUP BY cc.ReportDetailsId,cc.DomainRelatedViewId,cc.ReportDetailsName
),
-- Get the FieldIds for each column
FieldIds AS (
    SELECT 
        rnu.ReportDetailsId,
        rnu.CategoryColumns,
        rv.RptViewFieldsId AS FieldId,
        rv.DisplayName
    FROM ReportsNeedingUpdate rnu
    JOIN rptviewfields rv ON rnu.DomainRelatedViewId = rv.DomainRelatedViewId
    WHERE 
        rv.ColumnName = '[' + REPLACE(rnu.CategoryColumns, ' ', '') + ']' OR
        rv.ColumnName = rnu.CategoryColumns OR
        rv.DisplayName = rnu.CategoryColumns
)
, Final as 
(select ReportDetailsId, ReportDetailsName, CategoryColumns, NTILE(4) OVER (ORDER BY ReportDetailsId) AS PartitionNumber from ReportsNeedingUpdate)
select * from final
--where PartitionNumber=1
--order by 2
--where ReportDetailsName not like '%map%' and  ReportDetailsName not like '%sat%'

--adding comment test




--INSERT INTO RoleDashboard (DashboardId, RoleId, TenantId, StatusId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, IsDefaultDashboard)
--SELECT 
--    rd.DashboardId,
--    dep.RoleId,       -- Department Supervisor role
--    rd.TenantId,
--    1 AS StatusId,
--    'Analyticvue.Admin@WHPS' AS CreatedBy,
--    GETDATE() AS CreatedDate,
--    NULL AS ModifiedBy,
--    NULL AS ModifiedDate,
--    0 AS IsDefaultDashboard
--FROM RoleDashboard rd
--INNER JOIN IDM.DDARole dist 
--    ON rd.RoleId = dist.RoleId 
--    AND rd.TenantId = dist.TenantId
--INNER JOIN IDM.DDARole dep
--    ON dep.TenantId = dist.TenantId
--WHERE dist.RoleName = 'District Wide'
--  AND dep.RoleName = 'Department Supervisor'
--  AND rd.TenantId = 38
--  AND NOT EXISTS (
--        SELECT 1 
--        FROM RoleDashboard rdx
--        WHERE rdx.DashboardId = rd.DashboardId
--          AND rdx.RoleId = dep.RoleId
--          AND rdx.TenantId = rd.TenantId
--    );


DECLARE @BaseTables TABLE (TableName NVARCHAR(200));
INSERT INTO @BaseTables (TableName)
VALUES
('Duxbury_Enrollment'),
('K12DisabilityStudent'),
('K12SpecialEducationStudent'),
('K12StudentDemographics'),
('K12StudentEnrollment'),
('K12StudentOtherRaces'),
('K12StudentProgram'),
('Duxbury_StaffDemographics'),
('K12StaffAssignment'),
('K12StaffContactEmail'),
('K12StaffDemographics'),
('K12StaffEmployment'),
('Duxbury_Course'),
('Duxbury_CourseSection'),
('Duxbury_StudentSections'),
('Duxbury_StaffSections'),
('K12StaffSectionAssignment'),
('Duxbury_DailyAttendance');

select * from @BaseTables where tablename not like '%Demographics%'

DECLARE @StageSuffixes TABLE (Suffix NVARCHAR(100), Ord INT);
INSERT INTO @StageSuffixes (Suffix, Ord)
VALUES
 ('_Audit', 1),
 ('_CleanRecords', 2),
 ('_Deletes', 3),
 ('_FailedRecords', 4),
 ('_NoAction', 5),
 ('_Stage', 6);

-- Generate queries in required order
SELECT 
    b.TableName,
    s.Ord,
    CONCAT('SELECT count(1) FROM Stage.', b.TableName, s.Suffix, 
           ' WHERE schoolyear = 2026 AND tenantid = 26') AS QueryText
FROM @BaseTables b
CROSS JOIN @StageSuffixes s

UNION ALL

SELECT 
    b.TableName,
    7 AS Ord,
    CONCAT('SELECT count(1) FROM Main.', b.TableName, 
           ' WHERE schoolyear = 2026 AND tenantid = 26') AS QueryText
FROM @BaseTables b
ORDER BY b.TableName, Ord;
