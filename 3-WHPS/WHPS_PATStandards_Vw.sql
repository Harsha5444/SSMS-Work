CREATE VIEW [dbo].[WHPS_PATStandards_Vw] --8470  --198054  
AS
WITH AggSt AS (
    SELECT 
        agg.SchoolYear,
        agg.SchoolCategory,
        agg.SchoolIdentifier,
        agg.SchoolName,
        agg.DistrictStudentId,
        agg.StudentFullName AS StudentName,
        agg.Grade,
        agg.GradeCode,
        agg.Gender,
        agg.Race,
        agg.MembershipDaysCount,
        agg.PresentDaysCount,
        agg.AbsentDaysCount,
        IsNull(CASE 
            WHEN agg.IsChronic = 1 THEN 'Yes'
            WHEN agg.IsChronic = 0 THEN 'No'
        END, 'No') AS IsChronic,
        agg.AbsentPercentage,
        agg.Presentrate,
        agg.AbsentRate,
        agg.CurrentMonthAttendance,
        agg.ELL,
        agg.SpecialEdStatus,
        agg.[504Status],
        isnull(agg.IEP, 'No') AS IEP,
        agg.TenantId
    FROM AggRptK12StudentDetails agg
    WHERE agg.Tenantid = 38
        AND agg.SchoolYear = (
            SELECT max(yearcode)
            FROM RefYear
            WHERE Tenantid = 38
        ) 
),

WHPS_PAT_StudentStandards as (  --before used this [Main.WHPS_StudentStandards] replaced with cte
SELECT distinct wss.[SchoolId] AS [SchoolId]
	,wss.[identifier] AS [identifier]
	,wss.[name] AS [name]
	,wss.[parentstandardid] AS [parentstandardid]
	,wss.[parentstandardid_nvl] AS [parentstandardid_nvl]
	,wss.[standardgrade]
	,wss.[standardid] AS [standardid]
	,wss.[storecode]
	,wss.[student_number] AS [student_number]
	,wss.[studentid] AS [studentid]
	,wss.[studentsdcid] AS [studentsdcid]
	,wss.[SchoolYear] AS [SchoolYear]
	,wss.TenantId
FROM Main.WHPS_StudentStandards AS wss
WHERE (wss.identifier LIKE '%PAT.%')
	AND wss.standardgrade IS NOT NULL
	AND wss.TenantId = 38 
), 
TeacherCourses AS (
Select * from (
    SELECT 
        ascs.SchoolYear,
        ascs.SchoolIdentifier,
        ascs.Grade,
        ascs.DistrictStudentId,
        ascs.CourseTitle,
        ascs.TenantId,
        asf.DistrictStaffId,
        asf.TeacherFullName,
        ascs.SessionDescription AS SectionName,
        ascs.SectionIdentifier,
        ROW_NUMBER() OVER (
            PARTITION BY 
                ascs.SchoolYear,
                ascs.SchoolIdentifier,
                ascs.Grade,
                ascs.DistrictStudentId,
                ascs.CourseTitle,
                ascs.TenantId,
                asf.DistrictStaffId,
                asf.TeacherFullName,
                ascs.SessionDescription,
                ascs.SectionIdentifier 
            ORDER BY ascs.DistrictStudentId
        ) AS RN
    FROM AggPLPStudentCourseSections ascs  
    INNER JOIN aggstafffilters asf
        ON ascs.SchoolYear = asf.SchoolYear
        AND ascs.SchoolIdentifier = asf.SchoolIdentifier
        AND ascs.TenantId = asf.TenantId
        AND ascs.CourseIdentifier = asf.CourseIdentifier
        AND ascs.SectionIdentifier = asf.SectionIdentifier
    WHERE ascs.tenantid = 38 
    ) a where rn=1
)
SELECT
    agg.SchoolYear,
    agg.SchoolCategory,
    agg.SchoolIdentifier,
    agg.SchoolName,
    agg.DistrictStudentId,
    agg.StudentName,
    agg.Grade,
    agg.Gender,
    agg.Race,
    c.StandardId,
    c.identifier AS StandardIdentifier,
    c.[name] AS StandardName,
    c.ParentStandardId,
    NULL AS ParentIdentifier,
    NULL AS ParentName,
    c.StoreCode,
    CASE 
        WHEN c.StoreCode = 'Q1' THEN 'Fall'
        WHEN c.StoreCode IN ('Q2', 'Q3') THEN 'Winter'
        WHEN c.StoreCode = 'Q4' THEN 'Spring'
        ELSE c.StoreCode
    END AS Term,
    CASE 
        WHEN c.StandardGrade IS NOT NULL
            THEN CONCAT('Level - ', c.StandardGrade)
        ELSE c.StandardGrade
    END AS StandardGrade,
    sc.CourseTitle,
    sc.SectionName,
    sc.DistrictStaffId,
    sc.TeacherFullName,
    agg.MembershipDaysCount,
    agg.PresentDaysCount,
    agg.AbsentDaysCount,
    agg.IsChronic,
    agg.AbsentPercentage,
    agg.Presentrate,
    agg.AbsentRate,
    agg.CurrentMonthAttendance,
    agg.ELL,
    agg.SpecialEdStatus,
    agg.[504Status],
    agg.IEP,
    agg.TenantId
FROM WHPS_PAT_StudentStandards c
INNER JOIN AggSt agg
    ON c.SchoolYear = agg.SchoolYear
    AND c.student_number = agg.districtstudentid
    AND c.TenantId = agg.TenantId
LEFT JOIN TeacherCourses sc
    ON agg.districtstudentid = sc.DistrictStudentId
    AND agg.TenantId = sc.TenantId
    AND agg.schoolyear = sc.SchoolYear
    AND agg.SchoolIdentifier = sc.SchoolIdentifier
    AND agg.GradeCode = sc.Grade
WHERE c.StandardGrade IS NOT NULL
    AND agg.TenantId = 38
GO


