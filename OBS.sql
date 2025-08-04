select * from idm.Tenant;
--26	Duxbury Public Schools
--38	West Hartford Public Schools
--44	Monomoy Regional School District
--53	Regional School District 10
select * from idm.DDARole where tenantid = 38;

select * from fn_DashboardReportsDetails(26)

select * from ReportDetails where tenantid = 38 order by 1 desc;

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
	WHERE reportdetailsid IN (8948)
	)
select *
FROM cte
WHERE rn > 1


select * from idm.StudentsSubgroup where tenantid = 38

--SubgroupName
--Code
--StatusId
--SortOrder
--TenantId
--CreatedBy
--CreatedDate
--ModifiedBy
--ModifiedDate
--DisplayInDashboard
--DisplayRosterView
--ColumnName

--insert into idm.StudentsSubgroup
--select 'SchoolYear' as SubgroupName, 'SY' as Code ,1 as StatusId,17 as	SortOrder,38 as 	TenantId,'DDAAdmin' as 	CreatedBy, Getdate() as CreatedDate,null as ModifiedBy, null as ModifiedDate,
--1 as DisplayInDashboard, 1 as DisplayRosterView, 'SchoolYear' as ColumnName

--update idm.StudentsSubgroup set SubgroupName = 'School Year' where StudentsSubgroupId=471



--CREATE NONCLUSTERED INDEX [NCISX_ReportUsers_R] ON [dbo].[ReportUsers] ([ReportDetailsId]) 

--drop index NCISX_ReportUsers_R on  ReportUsers

select * from dbo.WHPS_StudentSummaryWithAllAss
exec sp_depends WHPS_BlitzReportDistrict_Vw
exec sp_helptext WHPSAssessmentAllDS_Vw

select * from RefFileTemplates where tenantid = 38 and filetemplatename like '%aim%'

select distinct [period] from main.WHPS_AimsWebPlus e
JOIN refterm r
    ON e.SchoolYear = r.SchoolYear
    AND r.TermCode = 'Spring'
    AND r.TenantId = 38
WHERE CAST(e.AdministrationDate AS DATE) BETWEEN r.StartDate AND r.EndDate
and e.schoolyear = 2025

 
 
