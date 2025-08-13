select * from idm.DDAUser where districtstaffid = '308173'

select distinct sse.schoolyear,ssa.DistrictStaffId,aa.schoolname,sse.CourseIdentifier,sse.DistrictStudentId,aa.StudentFullName
from [Main].[K12StudentSectionEnrollment] sse
join AggRptK12StudentDetails aa
on sse.TenantId = aa.TenantId
and sse.SchoolYear = aa.SchoolYear
and sse.DistrictStudentId = aa.DistrictStudentId
and sse.SchoolIdentifier = aa.SchoolIdentifier
join [Main].[K12StaffSectionAssignment] ssa
on sse.tenantid = ssa.tenantid
and sse.CourseIdentifier = ssa.CourseIdentifier
and sse.SchoolIdentifier = ssa.SchoolIdentifier
and sse.schoolyear = ssa.schoolyear
where 1=1
and sse.tenantid = 38
and sse.schoolyear = 2025 
and ssa.DistrictStaffId = '308173'

select * from main.k12school where schoolidentifier = 17

select * from fn_dashboardreportsdetails(38) where childreportname = 'Student performance in i-Ready - List'

exec sp_helptext WHPSAssessmentAllDS

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
LEFT JOIN refstatus AS rs ON m.statusid = rs.statusid
	AND du.statusid = rs.statusid
WHERE 1 = 1
	AND du.statusid = 1
	AND du.DistrictStaffId = '405008'
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

select * from main.WHPS_Teachers where first_name like '%Alison%'
--select * from main.WHPS_Teachers where teachernumber = '400283' and schoolyear = 2025
--select * from main.K12StaffEmployment where TenantId= 38 and schoolyear = 2025 and DistrictStaffId = '399743'

select s.NameofInstitution,* from main.k12staffemployment se
left join main.k12school s 
on se.tenantid = s.tenantid
and se.SchoolIdentifier = s.SchoolIdentifier
and s.schoolyear = se.SchoolYear
where se.tenantid = 38 and se.schoolyear = 2025 and DistrictStaffId = '400111'

select s.nameofinstitution,c.schoolcategorycode from main.k12school s
join RefSchoolCategory c on s.tenantid = c.tenantid
and s.schoolcategoryid = c.schoolcategoryid
where s.tenantid = 38 and schoolyear = 2025
order by c.sortorder


select * from idm.Org where tenantid = 38


SELECT 
    r.RoleId,
    r.RoleName,
    d.DashboardId,
    d.DashboardName
FROM IDM.DDARole r
INNER JOIN RoleDashboard rd 
    ON r.RoleId = rd.RoleId 
    AND r.TenantId = rd.TenantId
INNER JOIN dashboard d 
    ON rd.DashboardId = d.DashboardId
    AND rd.TenantId = d.TenantId
WHERE r.TenantId = 38
order by 1


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
--WHERE dist.RoleName = 'Principal'
--  AND dep.RoleName = 'Principal ES'
--  AND rd.TenantId = 38
--  AND NOT EXISTS (
--        SELECT 1 
--        FROM RoleDashboard rdx
--        WHERE rdx.DashboardId = rd.DashboardId
--          AND rdx.RoleId = dep.RoleId
--          AND rdx.TenantId = rd.TenantId
--    );

--Principal ES
--Principal MS
--Principal HS


select * from reportdetails order by 1 desc

WITH cte
AS (
	SELECT *
		,row_number() OVER (
			PARTITION BY ReportDetailsId
			,DDAUserId
			,TenantId
			,StatusId
			,OrgId
			,OrganizationTypeCode ORDER BY ReportUsersId ASC
			) AS rn
	FROM ReportUsers
	WHERE reportdetailsid IN (8935)
	)
delete
FROM cte
WHERE rn > 1