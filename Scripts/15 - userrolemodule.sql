DECLARE @UserId INT = 1; -- Replace with your desired user ID

WITH UserRoles AS (
    SELECT 
        uro.DDAUserId,
        STRING_AGG(
            CASE WHEN uro.IsDefaultRole = 1 THEN '*' + r.RoleName ELSE r.RoleName END, 
            ', '
        ) AS UserRoles
    FROM IDM.UserRoleOrg uro
    JOIN IDM.DDARole r ON uro.RoleId = r.RoleId
    WHERE uro.DDAUserId = @UserId
    GROUP BY uro.DDAUserId
),
UserOrgs AS (
    SELECT 
        uro.DDAUserId,
        STRING_AGG(o.OrgName, ', ') AS Organizations
    FROM IDM.UserRoleOrg uro
    JOIN IDM.RoleOrg ro ON uro.RoleId = ro.RoleId
    JOIN IDM.Org o ON ro.OrgId = o.OrgId
    WHERE uro.DDAUserId = @UserId
    GROUP BY uro.DDAUserId
),
UserOrgTypes AS (
    SELECT 
        uro.DDAUserId,
        STRING_AGG(CAST(rot.OrganizationTypeId AS VARCHAR), ', ') AS OrganizationTypeIds,
        STRING_AGG(ot.OrganizationTypeDescription, ', ') AS OrganizationTypeNames
    FROM IDM.UserRoleOrg uro
    JOIN IDM.RoleOrgType rot ON uro.RoleId = rot.RoleId
    JOIN [dbo].[RefOrganizationType] ot ON rot.OrganizationTypeId = ot.OrganizationTypeId
    WHERE uro.DDAUserId = @UserId
    GROUP BY uro.DDAUserId
),
UserModules AS (
    SELECT 
        uro.DDAUserId,
        STRING_AGG(m.ModuleName, ', ') AS Modules
    FROM IDM.UserRoleOrg uro
    JOIN IDM.RoleModule rm ON uro.RoleId = rm.RoleId
    JOIN IDM.Module m ON rm.ModuleId = m.ModuleId
    WHERE uro.DDAUserId = @UserId
    GROUP BY uro.DDAUserId
),
UserPermissions AS (
    SELECT 
        uro.DDAUserId,
        STRING_AGG(p.PermissionName, ', ') AS Permissions
    FROM IDM.UserRoleOrg uro
    JOIN IDM.RoleModulePermission rmp ON uro.RoleId = rmp.RoleId
    JOIN RefPermission p ON rmp.PermissionId = p.PermissionId
    WHERE uro.DDAUserId = @UserId
    GROUP BY uro.DDAUserId
),
UserDataDomains AS (
    SELECT 
        uro.DDAUserId,
        STRING_AGG(CAST(rd.DataDomainId AS VARCHAR), ', ') AS DataDomains
    FROM IDM.UserRoleOrg uro
    JOIN IDM.RoleDomain rd ON uro.RoleId = rd.RoleId
    WHERE uro.DDAUserId = @UserId
    GROUP BY uro.DDAUserId
)

SELECT 
    u.DDAUserId,
    u.UserLoginId,
    u.DistrictStaffId,
    t.TenantName,
    ur.UserRoles,
    uo.Organizations,
    uot.OrganizationTypeIds,
    uot.OrganizationTypeNames,
    um.Modules,
    up.Permissions,
    ud.DataDomains
FROM IDM.DDAUser u
CROSS JOIN IDM.Tenant t -- Assuming single tenant or adjust as needed
LEFT JOIN UserRoles ur ON u.DDAUserId = ur.DDAUserId
LEFT JOIN UserOrgs uo ON u.DDAUserId = uo.DDAUserId
LEFT JOIN UserOrgTypes uot ON u.DDAUserId = uot.DDAUserId
LEFT JOIN UserModules um ON u.DDAUserId = um.DDAUserId
LEFT JOIN UserPermissions up ON u.DDAUserId = up.DDAUserId
LEFT JOIN UserDataDomains ud ON u.DDAUserId = ud.DDAUserId
WHERE u.DDAUserId = @UserId;