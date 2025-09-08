--exec USP_GetReportAnalyticsQuestion @QuestionCode='Q164',@tenantid=26

--exec [dbo].[DataVisulaizerReportsSPDriven] @TenantId=26,@SPName='DataVisulaizerAssessmentReport',@CategoryFields=' ISNULL(x.SchoolYear,'''') as [School Year],  ISNULL(x.Grade,'''') as [Grade],  dbo.[RefGrade].SortOrder as [RefGrade]',@SeriesFields=' x.ProficiencyDescription as [ProficiencyDescription]',@GroupBySeries=' x.ProficiencyDescription ',@GroupByColumns=' x.SchoolYear,  x.Grade ,  dbo.[RefGrade].SortOrder',@WhereCondtion=' x.Subject IN ( ''Mathematics'') AND x.Assessment IN ( ''MCAS'') AND x.SchoolYear IN ( ''2024'') AND x.IsLatest = 1',@SortOrderFileds='[School Year]  asc ,  [RefGrade] asc,  [Grade]  asc',@JoinsTables=' inner join dbo.[RefGrade] on  x.Grade = dbo.[RefGrade].[GradeDescription] AND x.tenantid =dbo.[RefGrade].tenantid  ',@UserId=15,@SubqueryCondition='[School Year], [Grade]',@DynamicFields=' [School Year]  varchar(max),  [Grade]  varchar(max),  [RefGrade]  int',@FinalSelectColumns=' [School Year],  [Grade]',@istesttaken=1,@IsfilteredOnCohort=0,@Subcategorycolumns=' [School Year],  [Grade], [RefGrade]',@studentlist =NULL

select * from idm.Tenant;
--26	Duxbury Public Schools
--38	West Hartford Public Schools
--44	Monomoy Regional School District
--53	Regional School District 10
select * from idm.DDARole where tenantid = 38;
select * from idm.AppErrorLog order by 1 desc;

select * from fn_DashboardReportsDetails(38) where  reportname like '%ngss%' and dashboardname not in ('sbac', 'SBAC Longitudinal Performance')
select * from fn_DashboardReportsDetails(38) where  DashboardName='Acuity Matrix'
select * from fn_DashboardReportsDetails(38) where  groupname in ('Blitz Reports','District - Assessments with Grades','Teacher Blitz Grade Level Assessments')
select distinct groupname from fn_DashboardReportsDetails(38) 

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
--exec sp_depends WHPS_BlitzReportDistrict_Vw
--exec sp_helptext WHPSAssessmentAllDS_Vw

select * from RefFileTemplates where tenantid = 26 and filetemplatename like '%staff%';

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

--sp_helptext WHPS_AcuityMatrix_Vw


	select distinct schoolyear from AggRptK12StudentDetails
	select distinct schoolyear from WHPS_AcuityMatrix_Vw
	select distinct schoolyear from WHPS_HomeRoomTeacher_Vw

--	dbo.AggRptK12StudentDetails
--dbo.WHPS_AcuityMatrix_Vw
--dbo.WHPS_HomeRoomTeacher_Vw




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
--8851



select * from AggRptK12StudentDetails where 1=1 and schoolyear= 2024 and districtstudentid = '117733'
select * from fn_dashboardreportsdetails(38) where dashboardname like '%DISTRICT%'

select * FROM reportdetails where reportdetailsid = 7032

select * from main.k12studentdailyattendance where tenantid = 38 and schoolyear = 2025

select * from AggRptK12StudentDetails where tenantid = 38


select * from reffiletemplates where tenantid = 38

select * from main.WHPS_PeriodAttendance where tenantid = 38 and schoolyear = 2025
select * from main.WHPS_Attendance where tenantid = 38 and schoolyear = 2024

select * from Import_K12StudentDailyAttendance_Vw_38_Bkp
select * into #TEMPK12StudentDailyAttendance2022 from Import_K12StudentDailyAttendance_Vw_38

select * from RefMetric
select * from #TEMPK12StudentDailyAttendance2022

SELECT *
    --schoolyear,
    --COUNT(*) AS total_students,
    --SUM(CASE WHEN presentrate <= 90.00 THEN 1 ELSE 0 END) AS chronic_absentees,
    --CAST(SUM(CASE WHEN presentrate <= 90.00 THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(10,1)) AS chronic_percentage
FROM 
    dbo.AggRptK12StudentDetails WITH (NOLOCK)
WHERE 
    TenantId = 38
    AND Grade IN ('K', 'Grade 1', 'Grade 2', 'Grade 3', 'Grade 4', 'Grade 5', 
                 'Grade 6', 'Grade 7', 'Grade 8', 'Grade 9', 'Grade 10', 
                 'Grade 11', 'Grade 12', 'Grade 13')
    AND SchoolYear in (2023)
GROUP BY 
    schoolyear
ORDER BY 
    schoolyear


select distinct CAST(ATT_DATE AS DATE) from [Main].[WHPS_Attendance] 
where 1=1
and schoolyear = 2024 
and student_number ='119366'
and (
		[Presence_Status_CD] <> 'Present'
		OR [ATT_CODE] IN (
			'T'
			,'T15'
			,'TEX'
			,'TUX'
			)
		)
--and [ATT_CODE] not in (
--				'T'
--				,'T15'
--				,'TEX'
--				,'TUX'
--				)
order by CAST(ATT_DATE AS DATE) desc

select cast(attendancedate as date),schoolidentifier from main.K12StudentDailyAttendance
where 1=1
and schoolyear = 2024
and districtstudentid = '119366'
and AttendanceStatusId in (select AttendanceStatusId from refattendancestatus where tenantid = 38 and AttendanceStatusDescription='Absent')
order by cast(attendancedate as date) desc



select * from Import_K12StudentDailyAttendance_Vw_38
where 1=1
and schoolyear = 2024
and districtstudentid = '119366'
and [AttendanceStatus] in ('ABS')


--119350
--122517

--select AttendanceStatusId from refattendancestatus where tenantid = 38 and AttendanceStatusDescription='Present'

--select * from refattendancestatus where tenantid = 38


WITH SourceCounts AS (
    SELECT 
        student_number AS StudentID,
        [SCHOOLID] as Schoolidentifier,
        COUNT(DISTINCT CAST(ATT_DATE AS DATE)) AS SourceAbsenceCount
    FROM [Main].[WHPS_Attendance] a
    WHERE schoolyear = 2024
    AND [Presence_Status_CD] <> 'Present'
    AND [ATT_CODE] NOT IN ('T', 'T15', 'TEX', 'TUX')
    GROUP BY student_number,[SCHOOLID]
),
ProductionCounts AS (
    SELECT 
        districtstudentid AS StudentID,
        SchoolIdentifier,
        COUNT(DISTINCT CAST(attendancedate AS DATE)) AS ProductionAbsenceCount
    FROM main.K12StudentDailyAttendance
    WHERE schoolyear = 2024
    AND AttendanceStatusId IN (
        SELECT AttendanceStatusId 
        FROM refattendancestatus 
        WHERE tenantid = 38 
        AND AttendanceStatusDescription = 'Absent'
    )
    GROUP BY districtstudentid,SchoolIdentifier
),
AllStudents AS (
    SELECT DISTINCT student_number AS StudentID,[SCHOOLID] as Schoolidentifier
    FROM [Main].[WHPS_Attendance]
    WHERE schoolyear = 2024
    
    UNION
    
    SELECT DISTINCT districtstudentid AS StudentID,Schoolidentifier
    FROM main.K12StudentDailyAttendance
    WHERE schoolyear = 2024
)
SELECT 
    a.StudentID,
    ISNULL(s.SourceAbsenceCount, 0) AS SourceAbsenceCount,
    ISNULL(p.ProductionAbsenceCount, 0) AS ProductionAbsenceCount,
    ISNULL(s.SourceAbsenceCount, 0) - ISNULL(p.ProductionAbsenceCount, 0) AS Difference,
    CASE 
        WHEN s.SourceAbsenceCount IS NULL THEN 'Missing in Source'
        WHEN p.ProductionAbsenceCount IS NULL THEN 'Missing in Production'
        WHEN s.SourceAbsenceCount = p.ProductionAbsenceCount THEN 'Match'
        ELSE 'Mismatch'
    END AS Status
FROM AllStudents a
LEFT JOIN SourceCounts s ON a.StudentID = s.StudentID and a.Schoolidentifier = s.Schoolidentifier
LEFT JOIN ProductionCounts p ON a.StudentID = p.StudentID and s.Schoolidentifier = p.Schoolidentifier and a.Schoolidentifier = p.Schoolidentifier
ORDER BY ABS(ISNULL(s.SourceAbsenceCount, 0) - ISNULL(p.ProductionAbsenceCount, 0)) DESC, a.StudentID;



SELECT *
FROM LinkedReportMappedFileds lrmf
WHERE lrmf.TenantId = 38
  AND EXISTS (
        SELECT 1
        FROM LinkedReportMappedFileds sub
        WHERE sub.TenantId = lrmf.TenantId
          AND sub.ReportDetailsId = lrmf.ReportDetailsId
          AND sub.ChildColumnName = lrmf.ParentColumnName
          AND lrmf.IsValueField = 1
    )
  or EXISTS (
        SELECT 1
        FROM LinkedReportMappedFileds sub
        WHERE sub.TenantId = lrmf.TenantId
          AND sub.ReportDetailsId = lrmf.ReportDetailsId
          AND sub.ParentCode = lrmf.ParentCode
          AND sub.ParentColumnName = lrmf.ParentColumnName
          AND (
                sub.IsValueField = 0
                OR sub.ChildReportId IS NOT NULL
                OR sub.ChildColumnName IS NOT NULL
              )
    )
ORDER BY lrmf.ParentCode, lrmf.ParentColumnName;



WITH SourceCounts AS (
    SELECT 
        student_number AS StudentID,
        [SCHOOLID] as Schoolidentifier,
        COUNT(DISTINCT CAST(ATT_DATE AS DATE)) AS SourceAbsenceCount
    FROM [Main].[WHPS_Attendance] a
    WHERE schoolyear = 2024
    AND [Presence_Status_CD] <> 'Present'
    AND [ATT_CODE] NOT IN ('T', 'T15', 'TEX', 'TUX')
    GROUP BY student_number,[SCHOOLID]
),
ProductionCounts AS (
    SELECT 
        districtstudentid AS StudentID,
        SchoolIdentifier,
        COUNT(DISTINCT CAST(attendancedate AS DATE)) AS ProductionAbsenceCount
    FROM main.K12StudentDailyAttendance
    WHERE schoolyear = 2024
    AND AttendanceStatusId IN (
        SELECT AttendanceStatusId 
        FROM refattendancestatus 
        WHERE tenantid = 38 
        AND AttendanceStatusDescription = 'Absent'
    )
    GROUP BY districtstudentid,SchoolIdentifier
)
SELECT 
    s.StudentID,
    s.Schoolidentifier,
    ISNULL(s.SourceAbsenceCount, 0) AS SourceAbsenceCount,
    ISNULL(p.ProductionAbsenceCount, 0) AS ProductionAbsenceCount,
    ISNULL(s.SourceAbsenceCount, 0) - ISNULL(p.ProductionAbsenceCount, 0) AS Difference,
    CASE 
        WHEN s.SourceAbsenceCount = p.ProductionAbsenceCount THEN 'Match'
        ELSE 'Mismatch'
    END AS Status
FROM SourceCounts s
INNER JOIN ProductionCounts p ON s.StudentID = p.StudentID AND s.Schoolidentifier = p.SchoolIdentifier
ORDER BY ABS(ISNULL(s.SourceAbsenceCount, 0) - ISNULL(p.ProductionAbsenceCount, 0)) , s.StudentID;




select distinct student_number from main.whps_students where tenantid = 38 and schoolyear = 2026 --9861
select distinct DistrictStudentID from main.k12studentenrollment where tenantid = 38 and schoolyear = 2026 --9860

select distinct student_number from main.whps_students where tenantid = 38 and schoolyear = 2025 --9375
select distinct DistrictStudentID from main.k12studentenrollment where tenantid = 38 and schoolyear = 2025 --9375

select distinct student_number from main.whps_students where tenantid = 38 and schoolyear = 2024 --9286
select distinct DistrictStudentID from main.k12studentenrollment where tenantid = 38 and schoolyear = 2024 --9532



SELECT 
    COALESCE(w.schoolyear, k.schoolyear) AS SchoolYear,
    w.WHPS_Student_Count,
    k.Enrollment_Student_Count,
    a.AggRpt_Student_Count
FROM (
    SELECT schoolyear, COUNT(DISTINCT student_number) AS WHPS_Student_Count
    FROM main.whps_students
    WHERE tenantid = 38
    GROUP BY schoolyear
) w
FULL OUTER JOIN (
    SELECT schoolyear, COUNT(DISTINCT DistrictStudentID) AS Enrollment_Student_Count
    FROM main.k12studentenrollment
    WHERE tenantid = 38
    GROUP BY schoolyear
) k
    ON w.schoolyear = k.schoolyear
FULL OUTER JOIN (
    SELECT schoolyear, COUNT(DISTINCT DistrictStudentID) AS AggRpt_Student_Count
    FROM AggRptK12StudentDetails
    WHERE tenantid = 38
    GROUP BY schoolyear
) a
    ON w.schoolyear = a.schoolyear
ORDER BY SchoolYear


select * from main.whps_students where schoolyear = 2026 and  STUDENT_NUMBER='118127'
select * from main.k12studentenrollment where schoolyear = 2026 and  DistrictStudentID='118127'
select * from AggRptK12StudentDetails where schoolyear = 2026 and  DistrictStudentID='118127'

select * from stage.whps_students_audit where schoolyear = 2026 and  STUDENT_NUMBER='118127'
select * from stage.whps_students_noaction where schoolyear = 2026 and  STUDENT_NUMBER='118127'

SELECT 
    ws.schoolyear,
    ws.student_number
FROM main.whps_students ws
WHERE ws.tenantid = 38 and schoolyear = 2026
  AND NOT EXISTS (
        SELECT 1
        FROM main.k12studentenrollment ke
        WHERE ke.tenantid = ws.tenantid
          AND ke.schoolyear = ws.schoolyear
          AND ke.DistrictStudentID = ws.student_number
    )
ORDER BY ws.schoolyear, ws.student_number;

SELECT 
    ws.*
FROM main.whps_students ws
WHERE ws.tenantid = 38 and schoolyear = 2026
  AND NOT EXISTS (
        SELECT 1
        FROM AggRptK12StudentDetails a
        WHERE a.tenantid = ws.tenantid
          AND a.schoolyear = ws.schoolyear
          AND a.DistrictStudentID = ws.student_number
    )
ORDER BY ws.schoolyear, ws.student_number;

select * from RecurringScheduleJob where tenantid = 38 and statusid = 1 order by recurringtime

select * from main.Duxbury_StudentSections

select * from reffiletemplates where tenantid =  26

select * from main.k12lea where  tenantid =  26


SELECT  ds.[Period] as [Period], ds.[WHPSProfLevel] as [WHPSProfLevel],Count(Distinct  ds.[DistrictStudentId]) as [% Students]  FROM dbo.WHPSProfLevelAimsWebPlusDS as ds with (nolock)  LEFT JOIN dbo.RefProficiencylevel ON ds.[WHPSProfLevel] = dbo.RefProficiencylevel.ProficiencyDescription AND  ds.tenantid =dbo.RefProficiencylevel.tenantid    WHERE  ((ds.[SchoolYear] IN (2025)) AND (ds.[SchoolYear] IN (2025)) AND (ds.TenantId = 38))   GROUP BY ds.[Period],ds.[WHPSProfLevel],dbo.RefProficiencylevel.SortOrder  ORDER BY dbo.RefProficiencylevel.SortOrder ASC,ds.[WHPSProfLevel] ASC 

SELECT  ds.[Period] as [Period], ds.[WHPSProfLevel] as [WHPSProfLevel],Count(  ds.[DistrictStudentId]) as [% Students]  FROM dbo.WHPSProfLevelAimsWebPlusDS as ds with (nolock)  LEFT JOIN dbo.RefProficiencylevel ON ds.[WHPSProfLevel] = dbo.RefProficiencylevel.ProficiencyDescription AND  ds.tenantid =dbo.RefProficiencylevel.tenantid    WHERE  ((ds.[SchoolYear] IN (2025)) AND (ds.[SchoolYear] IN (2025)) AND (ds.TenantId = 38))   GROUP BY ds.[Period],ds.[WHPSProfLevel],dbo.RefProficiencylevel.SortOrder  ORDER BY dbo.RefProficiencylevel.SortOrder ASC,ds.[WHPSProfLevel] ASC 

--sp_helptext StudentLevelAssessmentDataset
--sp_helptext AssessmentSubgrpProfDS

SELECT 
    t.name AS TableName,
    t.create_date
FROM sys.views t
--WHERE CAST(t.create_date AS DATE) = '2025-08-14'
--where t.name like '%ref%'
ORDER BY t.create_date DESC;


select * from RefAimswebPlusTermLevel
select * from WHPSiReadyTermLevelsDS

select * from rptdomainrelatedviews where DomainRelatedViewId=2857
select * from idm.datasetcolumn where DomainRelatedViewId=2857
select * from rptviewfields where DomainRelatedViewId=2857

--update rptviewfields set LookupTable='WHPSi_ReadyLevel',LookupColumn='AssessmentLevelCode'
--where RptViewFieldsId='59832'

--select * from [WHPSi_ReadyLevel]

--insert into [WHPSi_ReadyLevel]

--select AssessmentLevelCode,	AssessmentLevelDescription,SortOrder,
--'38' as TenantId
--,StatusId
--,CreatedBy
--,getdate() as CreatedDate
--,ModifiedBy
--,ModifiedDate from AnalyticVue_FPS..FPSACCESSAssessmentLevel

--CREATE TABLE [dbo].[WHPSi_ReadyLevel](
--	[AssessmentLevelId] [int] IDENTITY(1,1) NOT NULL,
--	[AssessmentLevelCode] [varchar](50) NOT NULL,
--	[AssessmentLevelDescription] [varchar](255) NULL,
--	[SortOrder] [int] NULL,
--	[TenantId] [int] NOT NULL,
--	[StatusId] [int] NOT NULL,
--	[CreatedBy] [varchar](100) NULL,
--	[CreatedDate] [datetime] NULL,
--	[ModifiedBy] [varchar](100) NULL,
--	[ModifiedDate] [datetime] NULL,
--PRIMARY KEY CLUSTERED 
--(
--	[AssessmentLevelId] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
--) ON [PRIMARY]
--GO

--ALTER TABLE [dbo].[WHPSi_ReadyLevel] ADD  DEFAULT (getdate()) FOR [CreatedDate]
--GO



--SELECT ds.[TermDescription] AS [TermDescription]
--	,ds.[ProficiencyDescription] AS [ProficiencyDescription]
--	,Count(ds.[DistrictStudentId]) AS [DistrictStudentId]
--FROM dbo.WHPSAssessmentAllDS AS ds WITH (NOLOCK)
--LEFT JOIN dbo.RefTerm ON ds.[TermDescription] = dbo.RefTerm.TermDescription
--	AND ds.tenantid = dbo.RefTerm.tenantid
--LEFT JOIN dbo.[WHPSi_ReadyLevel] ON ds.[ProficiencyDescription] = dbo.[WHPSi_ReadyLevel].AssessmentLevelCode
--	AND ds.tenantid = dbo.[WHPSi_ReadyLevel].tenantid
--WHERE (
--		(ds.[Assessment] = 'i-Ready')
--		AND (ds.[TermDescription] IN ('Fall', 'Spring', 'Winter'))
--		AND (ds.[SubjectAreaName] = 'Reading')
--		AND (ds.[SchoolYear] IN (2025))
--		AND (ds.[TermDescription] IN ('Fall', 'Winter', 'Spring'))
--		AND (ds.TenantId = 38)
--		)
--GROUP BY ds.[TermDescription]
--	,ds.[ProficiencyDescription]
--	,dbo.RefTerm.SortOrder
--	,dbo.WHPSi - ReadyLevel.SortOrder
--ORDER BY dbo.RefTerm.SortOrder ASC
--	,ds.[TermDescription] ASC
--	,dbo.[WHPSi_ReadyLevel].SortOrder ASC
--	,ds.[ProficiencyDescription] ASC


select * from Prompts



SELECT DISTINCT 
    a.RecurringScheduleJobId,
    'WHPS' AS District,
    a.DataSourceType,
    a.RecurringType,
    a.BatchName,
    c.FileTemplateName,
    CONVERT(VARCHAR(20), DATEADD(HOUR, -6, a.RecurringTime), 100) AS EST,  -- AM/PM format
    CONVERT(VARCHAR(20), a.RecurringTime, 100) AS UTC,
    CONVERT(VARCHAR(20), DATEADD(MINUTE, 330, a.RecurringTime), 100) AS IST,
    a.RecurringTime
FROM RecurringScheduleJob a
JOIN RecurringScheduleJobTemplate b 
    ON a.RecurringScheduleJobId = b.RecurringScheduleJobId
   AND a.TenantId = b.TenantId
JOIN RefFileTemplates c 
    ON b.FileTemplateID = c.FileTemplateId
   AND a.TenantId = c.TenantId
WHERE a.TenantId = 38 AND a.statusid = 1
ORDER BY a.RecurringTime ASC;

 

select b.NameofInstitution,a.* from  [dbo].[Import_K12StaffSectionAssignment_CoTeachers_Vw_26] a
join  main.k12school b on  a.schoolyear = b.schoolyear and a.schoolidentifier = b.schoolidentifier
where b.TenantId = 26 and a.schoolyear = 2026

select * from idm.ddauser where districtstaffid = '111028282'


select * from [Main].[WHPS_Attendance] where schoolyear = 2026 and student_number='189989'

SELECT *  FROM main.K12StudentDailyAttendance WHERE schoolyear = 2026 and tenantid = 38 and districtstudentid = '189989'

select * from WHPSAttendancedateRangeDS


SELECT DISTINCT 
    a.RecurringScheduleJobId,
    'Duxbury' AS District,
    a.DataSourceType,
    a.RecurringType,
    a.BatchName,
    c.FileTemplateName,
    CONVERT(VARCHAR(20), DATEADD(HOUR, -6, a.RecurringTime), 100) AS EST,  -- AM/PM format
    CONVERT(VARCHAR(20), a.RecurringTime, 100) AS UTC,
    CONVERT(VARCHAR(20), DATEADD(MINUTE, 330, a.RecurringTime), 100) AS IST,
    a.RecurringTime
FROM RecurringScheduleJob a
JOIN RecurringScheduleJobTemplate b 
    ON a.RecurringScheduleJobId = b.RecurringScheduleJobId
   AND a.TenantId = b.TenantId
JOIN RefFileTemplates c 
    ON b.FileTemplateID = c.FileTemplateId
   AND a.TenantId = c.TenantId
JOIN Refyear y on a.tenantid = y.tenantid and a.yearid = y.yearid
WHERE a.TenantId = 26 and y.yearcode = '2026' AND a.statusid = 1 and cast(a.lastrundate as date) <> cast(getdate() as date)
ORDER BY a.RecurringTime ASC;

select * from batchschedule where batchid = 91065
select * from filerecordcountstats where batchid = 90948
select * from reffiletemplates where filetemplateid = 94

select * from filerecordcountstats where tenantid = 26 and tenantfiletemplatename like '%coteachers%'
SELECT * FROM Main.Duxbury_Enrollment WHERE schoolyear = 2026 AND tenantid = 26

SELECT * FROM Main.K12DisabilityStudent  WHERE schoolyear = 2026 AND tenantid = 26
SELECT * FROM Main.K12SpecialEducationStudent  WHERE schoolyear = 2026 AND tenantid = 26
SELECT * FROM Main.K12StudentEnrollment  WHERE schoolyear = 2026 AND tenantid = 26
SELECT * FROM Main.K12StudentOtherRaces  WHERE schoolyear = 2026 AND tenantid = 26
SELECT * FROM Main.K12StudentProgram  WHERE schoolyear = 2026 AND tenantid = 26

SELECT count(1) FROM Main.K12StaffSectionAssignment WHERE schoolyear = 2026 AND tenantid = 26


select distinct b.nameofinstitution ,a.SchoolIdentifier,	DistrictStaffId from [dbo].[Import_K12StaffSectionAssignment_CoTeachers_Vw_26] a
join Main.K12School b on a.SchoolIdentifier = b.SchoolIdentifier and b.TenantId = 26

select * from import_k12staffsectionassignment_vw_26 
select * from [Import_K12StaffSectionAssignment_CoTeachers_Vw_26]

exec [dbo].[USP_GetStudentsForStaffBySectionCourse] @UserId=318,@TenantId=26,@SchoolYear='2026',@SchoolId='820004',@sectionId=NULL,@courseId=NULL,@Grade=NULL,@StaffIds='114035471',@STARTRECORD='0',@RECORDS='50',@SORTBY='StudentName',@SORTTYPE='asc',@IsALLRecords=0,@IsFilterFirstTime=0,@ValueFilters=NULL,@ColorFilters=NULL,@SubGroupFilters=NULL,@CohortFilters=NULL,@isCohortGradeColumn=0,@CohortTitle=NULL,@FilterField=NULL,@UserRoles='6,7',@IsFromTeacherview=0,@MetrcGroupId=3,@IsExport=0

exec [dbo].[USP_GetNotificationsForStaffBySectionCourse] @UserId=318,@TenantId=26,@SchoolYear='2026',@SchoolId='820004',@sectionId=NULL,@courseId=NULL,@StaffIds='114035471',@Grade=NULL,@CohortFilters=NULL,@SubgroupFilters=NULL

select * from main.K12StaffSectionAssignment where DistrictStaffId='111036916' and schoolyear = 2026  --Theophilos
select * from main.K12StaffSectionAssignment where DistrictStaffId='111021501' and schoolyear = 2026  --Armstrong
select * from main.K12StaffSectionAssignment where DistrictStaffId='125121185' and schoolyear = 2026  --McNeil

select distinct districtstaffid from [dbo].[Import_K12StaffSectionAssignment_CoTeachers_Vw_26]


SELECT b.roleid
	,b.IsDefaultRole
	,a.*
FROM idm.ddauser a
INNER JOIN idm.userroleorg b ON a.ddauserid = b.ddauserid
	AND a.tenantid = b.tenantid
WHERE districtstaffid IN (
		SELECT DISTINCT districtstaffid
		FROM [dbo].[Import_K12StaffSectionAssignment_CoTeachers_Vw_26]
		)
	AND a.tenantid = 26
	AND IsDefaultRole = 1


SELECT b.roleid
	,b.IsDefaultRole
	,a.*
FROM idm.ddauser a
INNER JOIN idm.userroleorg b ON a.ddauserid = b.ddauserid
	AND a.tenantid = b.tenantid
WHERE districtstaffid IN ('111020745', '111021501', '111029310', '111030656', '111030784', '111031805', '111031886', '111032779', '111033655', '111034800', '111035862', '111037536', '111037892', '111038395', '112026830', '112030224', '112032348', '112034585', '112034880', '112035384', '112035667', '112035815', '112036579', '112038495', '112038832', '113031374', '113036449', '114038173', '114038175', '114038211', '114038632', '114038648', '114038650', '114038814', '114038818', '114038843', '114038855', '114038875', '125121185', '125126579')
	AND a.tenantid = 26
	AND IsDefaultRole = 1


select * from DuxburyAbsenteesbyReasonDS where schoolyear = 2026

exec sp_helptext DuxburyAbsenteesbyReasonDS




select  * from reffiletemplates where tenantid = 38 and filetemplatename like '%NGSS%'
select  * from TenantFileTemplateMapper where tenantid = 38 and tenantfilename like '%sba%'
--2827
select  * from TenantFileTemplateMapper where tenantid = 38 and tenantfilename like '%ngss%'
--2863
--2838
select  * from TenantFileTemplateMapper where tenantid = 38 and FileTemplateId in (2848,2849)




select distinct schoolyear from main.WHPS_NGSS where tenantid = 38
--2019
--2021
--2022
select  distinct schoolyear from main.WHPS_NGSS_Source where tenantid = 38
--2024
--2023

select distinct schoolyear from main.WHPS_SBAC where tenantid = 38
--2019
--2021
--2022
select distinct schoolyear from main.WHPS_SBAC_ELA_Source where tenantid = 38
--2024
--2023
select distinct schoolyear from main.WHPS_SBAC_Math_Source where tenantid = 38
--2024
--2023


select * from main.WHPS_SBAC where tenantid = 38
select * from main.WHPS_SBAC_ELA_Source where tenantid = 38
select * from main.WHPS_SBAC_Math_Source where tenantid = 38

select * from main.WHPS_NGSS where tenantid = 38
select * from main.WHPS_NGSS_Source where tenantid = 38

--===============================================

select * from Main.WHPS_SBAC_SourceData
select * from Main.WHPS_NGSS_SourceData

select * from Main.WHPS_SBAC_SourceData where vertical_scale_score is null
select * from Main.WHPS_NGSS_SourceData where scale_score is null

--[Import_SBAC_NGSS_K12StudentGenericAssessment_Vw_38]
--[Import_SBAC_NGSS_AssessmentDetails_Vw_38]
select * from dataimportviews where tenantid = 38
select * from refgrade where tenantid = 38

--insert into dataimportviews
--select 'Import_SBAC_NGSS_K12StudentGenericAssessment_Vw_38','Import_SBAC_NGSS_K12StudentGenericAssessment_Vw_38',38,1,1,'DDAUser@DDA',getdate(),null,null
--union select 'Import_SBAC_NGSS_AssessmentDetails_Vw_38','Import_SBAC_NGSS_AssessmentDetails_Vw_38',38,1,1,'DDAUser@DDA',getdate(),null,null


select * from main.K12StudentGenericAssessment with (nolock) where tenantid = 38 and schoolyear = 2025 and assessmentcodeid in
(select assessmentdetailsid from main.AssessmentDetails where tenantid = 38 and assessmentcode = 'sbac' and schoolyear = 2025)



select * from main.K12StudentGenericAssessment with (nolock) where tenantid = 38 and schoolyear = 2025 and assessmentcodeid in
(select assessmentdetailsid from main.AssessmentDetails where tenantid = 38 and assessmentcode = 'ngss' and schoolyear = 2025)


sp_helptext WHPS_AcuityMatrix_Vw

select * from WHPSAssessmentAllDS
select * from WHPSiReadySBACDS
select * from WHPSSBACDSNew
select * from WHPS_SBAC_DS_New
select * from WHPSSBACCYearStudentsDS

select reportfiledetails from reportdetails where reportdetailsid = 8852

--UPDATE ReportDetails
--SET ReportFileDetails = JSON_MODIFY(
--        JSON_MODIFY(ReportFileDetails, '$.DisplayLatestYearData', CAST(0 AS bit)),
--        '$.DisplayLastYearData', CAST(1 AS bit)
--    )
--WHERE ReportDetailsId in (select distinct reportid 
--from fn_DashboardReportsDetails(38) 
--where viewname in ('WHPS_StudentSummaryWithAllAss','WHPS_BlitzReportDistrict_Vw')
--)

select * from refcharttype where tenantid = 38


select * from reportdetails where  tenantid = 38
--reporttypeid in (354,351,355)