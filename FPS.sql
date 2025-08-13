select * from idm.Tenant
--28	Framingham Public Schools
--35	East Hartford Public Schools
--36	NSBoro
--37	Rochelle Schools

select * from RefFileTemplates where tenantid = 28 and filetemplatename like '%mcas%'
select * from fn_DashboardReportsDetails(35) where DataSet is NULL

--FPS_MCAS_2023 for Admins
--FPS_MCAS_Tierwithdemo
--FPS_MCAS2024withDemo
--FPS_MCAS2025_Prelimwithdemo
--FPS_MCASELA2024SchoolsOnly
--FPSiReady5LevelsDS
--FPSMCAS2025ELAwithdemo

--[FPSMCAS2023forAdmins]


select * from RptDomainRelatedViews where tenantid = 35 and viewname like '%sbac%'
select * from ReportDetails where tenantid = 35 and reportdetailsid = 3081
select * from Main.EH_SBAC_Math where tenantid = 35


SELECT SPID,ER.percent_complete,
		CAST(((DATEDIFF(s,start_time,GetDate()))/3600) as varchar) + ' hour(s), '
			+ CAST((DATEDIFF(s,start_time,GetDate())%3600)/60 as varchar) + 'min, '
			+ CAST((DATEDIFF(s,start_time,GetDate())%60) as varchar) + ' sec' as running_time,
		CAST((estimated_completion_time/3600000) as varchar) + ' hour(s), '
			+ CAST((estimated_completion_time %3600000)/60000 as varchar) + 'min, '
			+ CAST((estimated_completion_time %60000)/1000 as varchar) + ' sec' as est_time_to_go,
		DATEADD(second,estimated_completion_time/1000, getdate()) as est_completion_time,
	ER.command,ER.blocking_session_id, SP.DBID,LASTWAITTYPE, 
	DB_NAME(SP.DBID) AS DBNAME,
	SUBSTRING(est.text, (ER.statement_start_offset/2)+1, 
			((CASE ER.statement_end_offset
			 WHEN -1 THEN DATALENGTH(est.text)
			 ELSE ER.statement_end_offset
			 END - ER.statement_start_offset)/2) + 1) AS QueryText,
	TEXT,CPU,HOSTNAME,LOGIN_TIME,LOGINAME,
	SP.status,PROGRAM_NAME,NT_DOMAIN, NT_USERNAME 
	FROM SYSPROCESSES SP 
	INNER JOIN sys.dm_exec_requests ER
	ON sp.spid = ER.session_id
	CROSS APPLY SYS.DM_EXEC_SQL_TEXT(er.sql_handle) EST
	ORDER BY CPU DESC
 
 select * from main.k12lea where tenantid=28 and schoolyear = 2026
 select * from main.k12school where tenantid=28 and schoolyear = 2026
 select * from refyear where tenantid=28 and yearvalue = '2026'
 select * from aggrptk12studentdetails where tenantid = 28 and schoolyear = 2025

select * from schoolevent where tenantid = 37 and schoolyear = 2025

 select getdate()


 select * from refyear where tenantid=28 and yearvalue = '2026'



select * from RefYear where TenantId=28
select * from refproficiencylevel where TenantId=28 and sy=2026 --166
select * from refterm where TenantId=28 and schoolyear=2026 --19
select * from filetemplatefieldbyyear where TenantId=28 and YearId in (49) --YearId in (241,258) 7548
 

select * from fn_DashboardReportsDetails(35) where DashboardName in ('District')

select * from reportdetails where reportdetailsid = 3209
--3209

------update a set a.ReportDetailsName= concat(trim(a.ReportDetailsName),' Old')
------FROM reportdetails a
------where a.DomainRelatedViewId is null 
------and a.tenantid = 35 
------and a.reportdetailsname like '%sbac%' 
------and a.reportdetailsid  in (851,852,857,2198,2201,2202,2203,3082)

------UPDATE a
------SET a.ReportDetailsName = 
------    CONCAT(
------        LEFT(LTRIM(RTRIM(a.ReportDetailsName)), LEN(LTRIM(RTRIM(a.ReportDetailsName))) - 3),
------        'Old'
------    )
------FROM reportdetails a
------WHERE a.DomainRelatedViewId IS NULL
------  AND a.tenantid = 35
------  AND a.reportdetailsname LIKE '%sbac%'
------  AND a.reportdetailsid IN (851, 852, 857, 2198, 2201, 2202, 2203, 3082);


 
SELECT du.DDAUserId
	,du.DistrictStaffId
	,du.FirstName + ' ' + du.LastName AS UserName
	,du.UserLoginId
	,du.PrimaryEmailId
	,o.OrgName
	,r.RoleName
	,string_agg(m.ModuleName, '/ ') AS Modules
	,du.TenantId
FROM IDM.DDAUser AS du
LEFT JOIN IDM.UserRoleOrg AS duro ON du.TenantId = duro.TenantId
	AND du.DDAUserId = duro.DDAUserId
	AND duro.IsDefaultRole = 1
	AND duro.StatusId = 1
LEFT JOIN IDM.Org AS o ON o.TenantId = du.TenantId
	AND o.orgid = duro.orgid
LEFT JOIN IDM.DDARole AS r ON r.TenantId = du.TenantId
	AND r.RoleId = duro.RoleId
LEFT JOIN IDM.RoleModule AS rm ON rm.TenantId = duro.TenantId
	AND rm.roleid = duro.RoleId
LEFT JOIN IDM.Module AS m ON m.tenantid = du.TenantId
	AND m.ModuleId = rm.ModuleId
	AND m.StatusId = 1
LEFT JOIN refstatus AS rs ON 
	du.statusid = rs.statusid
	AND m.statusid = rs.statusid
WHERE 1 = 1
	AND du.statusid = 1
	AND rolename = 'District Admin' and du.tenantid = 35
GROUP BY du.DDAUserId
	,du.DistrictStaffId
	,du.FirstName
	,du.LastName
	,du.UserLoginId
	,du.PrimaryEmailId
	,o.OrgName
	,r.RoleName
	,du.TenantId
ORDER BY du.TenantId
	,o.OrgName
	,du.DDAUserId DESC
 
