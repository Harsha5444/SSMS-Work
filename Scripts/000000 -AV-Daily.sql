SELECT tenantid,tenantname,tenantcode FROM AnalyticVue_Hallco.idm.tenant UNION ALL
SELECT tenantid,tenantname,tenantcode FROM AnalyticVue_norwood.idm.tenant UNION ALL
SELECT tenantid,tenantname,tenantcode FROM AnalyticVue_district.idm.tenant UNION ALL
SELECT tenantid,tenantname,tenantcode FROM AnalyticVue_obs.idm.tenant UNION ALL
SELECT tenantid,tenantname,tenantcode FROM AnalyticVue_fps.idm.tenant UNION ALL
SELECT tenantid,tenantname,tenantcode FROM AnalyticVue_clayton.idm.tenant


use AnalyticVue
select * from idm.tenant
select * from idm.apperrorlog order by 1 desc

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
select * from Clayton_ReportDetails
select * from Clayton_DashboardReportDetails where 1 = 1 and dataset = 'Clayton_Assessment_EOC_DS'
select * from Clayton_ReportDetails
select distinct BatchId from Clayton_BatchProcessingStatus where 1=1 and ScheduledDay='Today'  order by 1 desc 
select * from fn_DashboardReportsDetails(50) where groupname like '%mile%'
--[USP_ClaytonStudents5YR_Loading]
select * from Clayton_Students_5YR
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
    AND OBJECT_DEFINITION(o.object_id) LIKE '%Clayton_AnalyticVue_ICFRLELL%';

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
    AND table_name LIKE '%ell%' 
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

--this is push test

