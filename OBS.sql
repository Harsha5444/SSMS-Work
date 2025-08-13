select * from idm.Tenant;
--26	Duxbury Public Schools
--38	West Hartford Public Schools
--44	Monomoy Regional School District
--53	Regional School District 10
select * from idm.DDARole where tenantid = 38;
select * from idm.AppErrorLog order by 1 desc;

select * from fn_DashboardReportsDetails(38) where groupname = 'District - Assessments with Grades';

--8932
--8933
--8934
--8935
--8936
--8937
--8939


select * from ReportDetails where tenantid = 38 order by 1 desc;

SELECT DISTINCT JSON_VALUE([value], '$.Code') AS Code
FROM reportdetails r
CROSS APPLY OPENJSON(r.reportfiledetails, '$.ValueColumn')
WHERE JSON_VALUE([value], '$.Code') IS NOT NULL and tenantid = 38;

SELECT r.*
FROM reportdetails r
join (select distinct ReportId from fn_DashboardReportsDetails(38)) fn on r.ReportDetailsId = fn.ReportId
WHERE EXISTS (
    SELECT 1
    FROM OPENJSON(r.reportfiledetails, '$.ValueColumn') AS v
    WHERE JSON_VALUE(v.[value], '$.Code') = 'PercentageDistinctCount'
) and r.tenantid = 38  
and ReportDetailsId not in
('6643','6755','6953','6580','6581','6585','6589','6595','6632','6651','6654','6655','6664','6665','6848','6849','6850','6851')
order by ReportDetailsId;

--Count
--PercentageCount
--None
--PercentageDistinctCount
--Percentage
--Sum
--Distinct Count
--Avg

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

select * from RefFileTemplates where tenantid = 38 and filetemplatename like '%aim%';

--1) We have "NULL" and "N/A" in Period
--select distinct [Period] from main.WHPS_AimsWebPlus order by [Period]
--2) We have NULL for [RelatedForm] from which we are deriving Subject
--select distinct [RelatedForm] from main.WHPS_AimsWebPlus order by 1
--3) We Have AdministrationDate & Period Missmatch Example: Spring Dates But Period is Winter
--select distinct CAST(e.AdministrationDate AS DATE) as AdministrationDate,Period
--from main.WHPS_AimsWebPlus e
--order by CAST(e.AdministrationDate AS DATE)  desc

select  e.AdministrationDate,Period,r.TermCode from main.WHPS_AimsWebPlus e
JOIN refterm r
    ON e.SchoolYear = r.SchoolYear
	    AND r.TermCode in  ('Spring','Winter','Fall','Summer')
    AND r.TenantId = 38
	--and (period is null or period = 'N/A')
WHERE CAST(e.AdministrationDate AS DATE) BETWEEN r.StartDate AND r.EndDate
and e.schoolyear = 2025
order by CAST(e.AdministrationDate AS DATE) desc

select s.nameofinstitution,c.schoolcategorycode from main.k12school s
join RefSchoolCategory c on s.tenantid = c.tenantid
and s.schoolcategoryid = c.schoolcategoryid
where s.tenantid = 38 and schoolyear = 2025
order by c.sortorder

 
--UPDATE refterm
--SET DisplayOrder = CASE TermCode
--    WHEN 'Q1' THEN 1
--    WHEN 'Q2' THEN 2
--    WHEN 'E1' THEN 3
--    WHEN 'S1' THEN 4
--    WHEN 'B1' THEN 5
--    WHEN 'B2' THEN 6
--    WHEN 'Q3' THEN 7
--    WHEN 'Q4' THEN 8
--    WHEN 'E2' THEN 9
--    WHEN 'S2' THEN 10
--    WHEN 'B3' THEN 11
--    WHEN 'B4' THEN 12
--END
--WHERE tenantid = 38
--  AND schoolyear = 2025
--  AND TermCode IN ('Q1','Q2','E1','S1','B1','B2','Q3','Q4','E2','S2','B3','B4');







SELECT ds.[SchoolName] AS [SchoolName]
	,ds.[AcuityTier] AS [AcuityTier]
	,Count(DISTINCT ds.[DistrictStudentId]) AS [DistrictStudentId]
	,(
		SELECT COUNT(DISTINCT subds.[DistrictStudentId])
		FROM dbo.WHPSAcuityMatrixDS AS subds WITH (NOLOCK)
		LEFT JOIN dbo.RefProficiencylevel ON subds.[AcuityTier] = dbo.RefProficiencylevel.ProficiencyDescription
			AND subds.tenantid = dbo.RefProficiencylevel.tenantid
		WHERE subds.[AcuityTier] = ds.[AcuityTier]
			AND subds.[GradeCode] = ('6')
			AND subds.[schoolyear] IN (2025)
			AND (subds.TenantId = 38)
		) AS [SeriesTotalCount]
FROM dbo.WHPSAcuityMatrixDS AS ds WITH (NOLOCK)
LEFT JOIN dbo.RefProficiencylevel ON ds.[AcuityTier] = dbo.RefProficiencylevel.ProficiencyDescription
	AND ds.tenantid = dbo.RefProficiencylevel.tenantid
WHERE (
		(ds.[GradeCode] = '6')
		--(ds.[schoolyear] IN (2025))
		AND (ds.TenantId = 38)
		)
GROUP BY ds.[SchoolName]
	,ds.[AcuityTier]
	,dbo.RefProficiencylevel.SortOrder
ORDER BY ds.[SchoolName] ASC
	,dbo.RefProficiencylevel.SortOrder ASC
	,ds.[AcuityTier] ASC

sp_helptext WHPS_AcuityMatrix_Vw


	select distinct schoolyear from AggRptK12StudentDetails
	select distinct schoolyear from WHPS_AcuityMatrix_Vw
	select distinct schoolyear from WHPS_HomeRoomTeacher_Vw

	dbo.AggRptK12StudentDetails
dbo.WHPS_AcuityMatrix_Vw
dbo.WHPS_HomeRoomTeacher_Vw




select * from fn_DashboardReportsDetails(38) where reportname like '%chronic%';


SELECT ds.SchoolYear AS [School Year]
	,Count(ds.DistrictStudentId) AS [Count]
	,(
		SELECT COUNT(subds.DistrictStudentId)
		FROM dbo.AggRptK12StudentDetails AS subds WITH (NOLOCK)
		WHERE subds.SchoolYear = ds.SchoolYear
			AND subds.[Grade] IN ('K', 'Grade 1', 'Grade 2', 'Grade 3', 'Grade 4', 'Grade 5', 'Grade 6', 'Grade 7', 'Grade 8', 'Grade 9', 'Grade 10', 'Grade 11', 'Grade 12', 'Grade 13')
			AND (subds.TenantId = 38)
		) AS [SeriesTotalCount]
FROM dbo.AggRptK12StudentDetails AS ds WITH (NOLOCK)
WHERE (
		(ds.Grade IN ('K', 'Grade 1', 'Grade 2', 'Grade 3', 'Grade 4', 'Grade 5', 'Grade 6', 'Grade 7', 'Grade 8', 'Grade 9', 'Grade 10', 'Grade 11', 'Grade 12', 'Grade 13'))
		AND (ISNUMERIC(ds.Presentrate) = 1)
		AND (cast(ds.Presentrate AS DECIMAL(18, 2)) >= '95')
		AND (ds.TenantId = 38)
		)
GROUP BY ds.SchoolYear
	,ds.[SchoolYear]
ORDER BY ds.[SchoolYear] ASC


select * from reportdetails 
where tenantid = 38  
and DomainRelatedViewId in (3671,3670) 
and reportfiledetails like '%Q1_per%' 
and reporttypeid = 101
order by 1 desc


--8950
--8949
--8948
--8945
--8944
--8943
--8942
--8853
8851