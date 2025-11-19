Create VIEW [dbo].[WHPS_PAT_LevelMovement]  --39210
AS
WITH StudentDetails AS (
    SELECT 
DistrictStudentId,FirstName,MiddleName,LastorSurname,StudentFullName,BirthDate,SchoolYear,LEAIdentifier,SchoolIdentifier,LeaName
,SchoolName,Gender,Grade,MilitaryAffiliated,Truant,SchoolCategory,Race,Migrant,GiftedandTalented,Tribal,EnrollmentBeginDate
,EnrollmentEndDate,GenderCode,GradeCode,MilitaryAffiliatedCode,SchoolCategoryCode,TribalCode,DropOut,ELL,Graduate,
MembershipDaysCount,PresentDaysCount,AbsentDaysCount,UA_AbsentDaysCount,IsChronic,AbsentPercentage,AgeGroup,DropOutReason,
TardyDaysCount,Presentrate,AbsentRate,TardyRate,ExitType,ExitStatus,CohortGraduationYear,CurrentMonthAttendance,
PreviousMonthAttendance,StateStudentId,FRL,DisabilityStatus,DisabilityReason,
SpecialEdStatus,[504Status],TenantId,Ethnicity,IepStatus,HispanicLatino,FosterChild,Homeless,HomeLanguage,
EllProgram,CountryOfOrigon,Team,FEL,SchoolType,HighNeeds,IEP
    FROM AggRptK12StudentDetails 
    WHERE TenantId = 38
),
WHPS_PAT_StudentStandards AS (
SELECT distinct WSS.[SchoolId] AS [SchoolId]
	,WSS.[identifier] AS [identifier]
	,WSS.[name] AS [name]
	,WSS.[parentstandardid] AS [parentstandardid]
	,WSS.[parentstandardid_nvl] AS [parentstandardid_nvl]
	,'Level - ' + convert(VARCHAR, WSS.[standardgrade]) AS [standardgrade]
	,WSS.[standardid] AS [standardid]
	,CASE 
		WHEN [storecode] = 'Q2'
			THEN 'Q3'
		ELSE [storecode]
		END AS [storecode]
	,WSS.[student_number] AS [student_number]
	,WSS.[studentid] AS [studentid]
	,WSS.[studentsdcid] AS [studentsdcid]
	,WSS.[SchoolYear] AS [SchoolYear]
	,WSS.TenantId
FROM Main.WHPS_StudentStandards AS WSS
WHERE (WSS.identifier LIKE '%PAT.%')
	AND WSS.standardgrade IS NOT NULL
	AND WSS.TenantId = 38
),
StandardsFallToWinter AS (
    SELECT 
        a.SchoolYear,
        [Name],
        'Q1 - Q3' AS StoreCode,
        'Fall - Winter' AS Term,
        ISNULL(a.[Q1], 'No Score') AS FromLevel,
        ISNULL(a.[Q3], 'No Score') AS ToLevel,
        CAST(REPLACE(a.[Q3], 'Level - ', '') AS INT) - CAST(REPLACE(a.[Q1], 'Level - ', '') AS INT) AS StatusValue,
        CASE 
            WHEN CAST(REPLACE(a.[Q3], 'Level - ', '') AS INT) - CAST(REPLACE(a.[Q1], 'Level - ', '') AS INT) > 0 THEN 'Level Up'
            WHEN CAST(REPLACE(a.[Q3], 'Level - ', '') AS INT) - CAST(REPLACE(a.[Q1], 'Level - ', '') AS INT) < 0 THEN 'Level Down'
            WHEN CAST(REPLACE(a.[Q3], 'Level - ', '') AS INT) - CAST(REPLACE(a.[Q1], 'Level - ', '') AS INT) = 0 THEN 'Equal'
            ELSE 'No Movement'
        END AS Status,
        a.student_number AS DistrictStudentId,
        a.TenantId
    FROM (
        SELECT SchoolYear, student_number, [name], storecode, STANDARDGRADE, TenantId 
        FROM WHPS_PAT_StudentStandards 
    ) T
    PIVOT(MAX(STANDARDGRADE) FOR storecode IN ([Q1], [Q3])) A
),
StandardsWinterToSpring AS (
    SELECT 
        a.SchoolYear,
        [Name],
        'Q3 - Q4' AS StoreCode,
        'Winter - Spring' AS Term,
        ISNULL(a.[Q3], 'No Score') AS FromLevel,
        ISNULL(a.[Q4], 'No Score') AS ToLevel,
        CAST(REPLACE(a.[Q4], 'Level - ', '') AS INT) - CAST(REPLACE(a.[Q3], 'Level - ', '') AS INT) AS StatusValue,
        CASE 
            WHEN CAST(REPLACE(a.[Q4], 'Level - ', '') AS INT) - CAST(REPLACE(a.[Q3], 'Level - ', '') AS INT) > 0 THEN 'Level Up'
            WHEN CAST(REPLACE(a.[Q4], 'Level - ', '') AS INT) - CAST(REPLACE(a.[Q3], 'Level - ', '') AS INT) < 0 THEN 'Level Down'
            WHEN CAST(REPLACE(a.[Q4], 'Level - ', '') AS INT) - CAST(REPLACE(a.[Q3], 'Level - ', '') AS INT) = 0 THEN 'Equal'
            ELSE 'No Movement'
        END AS Status,
        a.student_number AS DistrictStudentId,
        a.TenantId
    FROM (
        SELECT SchoolYear, student_number, [name], storecode, STANDARDGRADE, TenantId 
        FROM WHPS_PAT_StudentStandards 
    ) T
    PIVOT(MAX(STANDARDGRADE) FOR storecode IN ([Q3], [Q4])) A
),
StudentStandards AS (
    SELECT 
        SchoolYear, [Name], StoreCode, Term, FromLevel, ToLevel, Status, StatusValue,
        DistrictStudentId, TenantId
    FROM StandardsFallToWinter
    UNION ALL 
    SELECT 
        SchoolYear, [Name], StoreCode, Term, FromLevel, ToLevel, Status, StatusValue,
        DistrictStudentId, TenantId
    FROM StandardsWinterToSpring
),
UnpivotData AS (
    SELECT 
        SchoolYear,
        [Name],
        StoreCode,
        Term,
        FromLevel,
        ToLevel,
        StatusValue,
        DistrictStudentId,
        TenantId,
        MovementLevel,
        Colname
    FROM (SELECT 
        ss.SchoolYear,
        ss.[Name],
        ss.StoreCode,
        ss.Term,
        ss.FromLevel,
        ss.ToLevel,
        ss.StatusValue,
        ss.DistrictStudentId,
        ss.TenantId,
        -- Movement Categories
        CAST('All Students' AS VARCHAR(50)) AS allstudents,
        CAST(CASE 
            WHEN ss.StatusValue > 0 THEN 'All Upward Movement'
        END AS VARCHAR(50)) AS AllUpwardMovement,
        CAST(CASE 
            WHEN ss.StatusValue < 0 THEN 'All Downward Movement'
        END AS VARCHAR(50)) AS AllDownwardMovement,
        CAST(CASE 
            WHEN ss.StatusValue < -1 THEN 'Multi-Level Downward Movement'
        END AS VARCHAR(50)) AS MultiLevelDownwardMovement,
        CAST(CASE 
            WHEN ss.StatusValue > 1 THEN 'Multi-Level Upward Movement'
        END AS VARCHAR(50)) AS MultiLevelUpwardMovement,
        CAST(CASE 
            WHEN ss.StatusValue < -1 OR ss.StatusValue > 1 THEN 'All Multi-Level Movement'
        END AS VARCHAR(50)) AS AllMultiLevelMovement
    FROM StudentStandards ss) AS MovementCategories
    UNPIVOT (
        MovementLevel FOR Colname IN (
            AllUpwardMovement,
            AllDownwardMovement,
            MultiLevelDownwardMovement,
            MultiLevelUpwardMovement,
            AllMultiLevelMovement,
            allstudents
        )
    ) AS Unpivoted
    WHERE MovementLevel IS NOT NULL
)
SELECT 
    ud.SchoolYear,
    ud.[Name],
    ud.StoreCode,
    ud.Term,
    ud.FromLevel,
    ud.ToLevel,
    CASE 
        WHEN ud.StatusValue > 0 THEN 'Level Up'
        WHEN ud.StatusValue < 0 THEN 'Level Down'
        WHEN ud.StatusValue = 0 THEN 'Equal'
        ELSE 'No Movement'
    END AS [Status],
    ud.DistrictStudentId,
    agg.StudentFullName,
    agg.SchoolIdentifier,
    agg.SchoolCategory,
    agg.SchoolName,
    agg.Gender,
    agg.Grade,
    agg.Truant,
    agg.Race,
    agg.Migrant,
    agg.GiftedandTalented,
    agg.Tribal,
    agg.EnrollmentBeginDate,
    agg.EnrollmentEndDate,
    agg.GenderCode,
    agg.TribalCode,
    agg.ELL,
    agg.StateStudentId,
    agg.FRL,
    agg.SpecialEdStatus,
    agg.[504Status],
    agg.IepStatus,
    agg.EllProgram,
    agg.FEL,
    agg.HighNeeds,
    ISNULL(agg.IEP, 'No') AS IEP,
    ud.TenantId,
    ud.MovementLevel,
    ud.Colname,
    IsNull(CASE 
            WHEN agg.IsChronic = 1 THEN 'Yes'
            WHEN agg.IsChronic = 0 THEN 'No'
        END, 'No') AS IsChronic,
    agg.MembershipDaysCount,
    agg.PresentDaysCount,
    agg.AbsentDaysCount,
    agg.AbsentPercentage,
    agg.Presentrate,
    agg.AbsentRate,
    agg.CurrentMonthAttendance
FROM UnpivotData ud
JOIN AggRptK12StudentDetails agg ON ud.SchoolYear = agg.SchoolYear
    AND ud.TenantId = agg.TenantId
    AND ud.DistrictStudentId = agg.DistrictStudentId
GO


