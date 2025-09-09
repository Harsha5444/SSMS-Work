--EOG Score Prediction with Percentile Rank
WITH MAPBase AS (
    SELECT [SchoolYear]
        ,[Districtstudentid]
        ,[GradeCode]
        ,[RITScore(Fall)]
        ,[RITScore(Winter)]
        ,[RITScore(Spring)]
        ,[PercentileRank(Fall)]
        ,[PercentileRank(Winter)]
        ,[PercentileRank(Spring)]
    FROM (
        SELECT *
        FROM (
            SELECT h.SchoolYear
                ,p.AssessmentCode
                ,p.SubjectAreaCode
                ,h.Districtstudentid
                ,g.GradeCode
                ,g.GradeDescription
                ,CASE 
                    WHEN m.MetricCode = 'RITScore' 
                        THEN 'RITScore(' + k.Termcode + ')'
                    WHEN m.MetricCode = '00502' 
                        THEN 'PercentileRank(' + k.Termcode + ')'
                END Termcode
                ,CAST(h.MetricValue AS INT) MetricValue
                ,ROW_NUMBER() OVER (
                    PARTITION BY p.AssessmentCode
                             ,p.SubjectAreaCode
                             ,h.StudentCurrentGradeId
                             ,h.termid
                             ,h.Districtstudentid
                             ,m.MetricCode
                    ORDER BY h.SchoolYear DESC, CAST(h.TestTakenDate AS DATE) DESC
                ) AS RN
            FROM main.k12studentgenericassessment h
            INNER JOIN main.assessmentdetails p ON h.AssessmentCodeId = p.assessmentdetailsid
            INNER JOIN RefGrade g ON g.gradeid = h.StudentCurrentGradeId
            INNER JOIN refterm k ON h.termid = k.termid
            INNER JOIN refmetric m ON h.MetricCodeId = m.MetricId
            WHERE AssessmentCodeId IN (
                    SELECT assessmentdetailsid
                    FROM main.assessmentdetails
                    WHERE AssessmentCode LIKE '%MAP%'
                        AND SubjectAreaCode LIKE '%math%'
                        AND strandareacode IS NULL
                )
              AND m.MetricCode IN ('RITScore','00502')
        ) t
        WHERE RN = 1
    ) o
    PIVOT(
        MAX(MetricValue) 
        FOR Termcode IN (
            [RITScore(Fall)], [RITScore(Winter)], [RITScore(Spring)],
            [PercentileRank(Fall)], [PercentileRank(Winter)], [PercentileRank(Spring)]
        )
    ) u
),
EOGBase AS (
    SELECT h.SchoolYear
        ,h.Districtstudentid
        ,g.GradeCode
        ,MAX(CASE WHEN m.MetricCode = '03479' THEN CAST(h.MetricValue AS INT) END) ScaleScore
        ,MAX(CASE WHEN m.MetricCode = '00502' THEN CAST(h.MetricValue AS INT) END) PercentileRank
    FROM main.k12studentgenericassessment h
    INNER JOIN main.assessmentdetails p ON h.AssessmentCodeId = p.assessmentdetailsid
    INNER JOIN RefGrade g ON g.gradeid = h.StudentCurrentGradeId
    INNER JOIN refmetric m ON h.MetricCodeId = m.MetricId
    WHERE AssessmentCodeId IN (
            SELECT assessmentdetailsid
            FROM main.assessmentdetails
            WHERE AssessmentCode LIKE '%EOG%'
                AND SubjectAreaCode LIKE '%math%'
                AND strandareacode IS NULL
        )
      AND m.MetricCode IN ('03479','00502')
    GROUP BY h.SchoolYear, h.Districtstudentid, g.GradeCode
),
Base AS (
    SELECT a.SchoolYear
        ,a.Districtstudentid
        ,b.StudentFullName
        ,ISNULL(a.GradeCode, 'Unknown') GradeCode
        ,a.[RITScore(Fall)] [MAPRITScore(Fall)]
        ,a.[RITScore(Winter)] [MAPRITScore(Winter)]
        ,a.[RITScore(Spring)] [MAPRITScore(Spring)]
        ,a.[PercentileRank(Fall)] [MAPPercentile(Fall)]
        ,a.[PercentileRank(Winter)] [MAPPercentile(Winter)]
        ,a.[PercentileRank(Spring)] [MAPPercentile(Spring)]
        ,t.ScaleScore EOGScaleScore
        ,t.PercentileRank EOGPercentileRank
        ,ISNULL(b.presentPercentage, '0.0') presentPercentage
        ,ISNULL(b.chronicallyAbsent, 'N') ChronicallyAbsent
        ,CASE 
            WHEN b.raceEthnicity = 'White (W)' THEN 5
            WHEN b.raceEthnicity = 'Black/African American (B)' THEN 3
            WHEN b.raceEthnicity = 'Hispanic/Latino (H)' THEN 4
            WHEN b.raceEthnicity = 'Asian (A)' THEN 2
            WHEN b.raceEthnicity = 'More than one race indicated (M)' THEN 7
            WHEN b.raceEthnicity = 'Native Hawaiian/Pacific Islander (PI)' THEN 1
            WHEN b.raceEthnicity = 'American Indian/Alaska Native (AI)' THEN 6
            ELSE 8
        END Race
        ,CASE WHEN b.genderLong = 'Male (M)' THEN 1 ELSE 0 END Gender
        ,CASE WHEN b.swdindicator = 'Y' THEN 1 ELSE 0 END Disability
        ,0 FRL
        ,ISNULL(c.TotalIncidents, 0) TotalIncidents
    FROM MAPBase a
    INNER JOIN EOGBase t 
        ON a.SchoolYear = t.SchoolYear
       AND a.GradeCode = t.GradeCode
       AND a.DistrictStudentId = t.DistrictStudentId
    INNER JOIN (
        SELECT StudentFullName
            ,studentnumber
            ,endyear
            ,ROUND(CAST(daysPresent AS FLOAT) * 100 / scheduledDays, 2) PresentPercentage
            ,chronicallyAbsent
            ,raceEthnicity
            ,genderLong
            ,swdindicator
        FROM (
            SELECT studentFullName
                ,studentnumber
                ,endyear
                ,SUM(daysPresent) daysPresent
                ,SUM(scheduledDays) scheduledDays
                ,chronicallyAbsent
                ,raceEthnicity
                ,genderLong
                ,swdindicator
                ,ROW_NUMBER() OVER (
                    PARTITION BY studentnumber, endYear 
                    ORDER BY daysPresent DESC
                ) AS rn
            FROM [HCS_attendanceSummary_7YR]
            GROUP BY StudentFullName, studentnumber, endyear,
                     chronicallyAbsent, daysPresent, raceEthnicity, genderLong, swdindicator
        ) y
        WHERE rn = 1
          AND daysPresent <> 0
    ) b ON a.DistrictStudentId = b.studentnumber
       AND a.schoolyear = b.endYear
    LEFT JOIN (
        SELECT EndYear, studentNumber, COUNT(incidentID) TotalIncidents
        FROM HCS_behavior_7YR
        GROUP BY EndYear, studentNumber
    ) c ON a.SchoolYear = c.EndYear
       AND a.DistrictStudentId = c.studentnumber
    WHERE (
            (b.presentPercentage > 90 AND chronicallyAbsent = 'N')
         OR (b.presentPercentage <= 90 AND chronicallyAbsent = 'Y')
    )
),
PrevYear AS (
    SELECT SchoolYear + 1 AS SchoolYear
        ,Districtstudentid
        ,[MAPRITScore(Fall)] [MAPRITScore(Fall)_Previous]
        ,[MAPRITScore(Winter)] [MAPRITScore(Winter)_Previous]
        ,[MAPRITScore(Spring)] [MAPRITScore(Spring)_Previous]
        ,[MAPPercentile(Fall)] [MAPPercentile(Fall)_Previous]
        ,[MAPPercentile(Winter)] [MAPPercentile(Winter)_Previous]
        ,[MAPPercentile(Spring)] [MAPPercentile(Spring)_Previous]
        ,EOGScaleScore [EOGScaleScore_Previous]
        ,EOGPercentileRank [EOGPercentileRank_Previous]
    FROM Base
)
SELECT 
    b.SchoolYear,
    b.DistrictStudentId,
    b.StudentFullName,
    b.GradeCode,
    b.[MAPRITScore(Fall)], p.[MAPRITScore(Fall)_Previous],
    b.[MAPRITScore(Winter)], p.[MAPRITScore(Winter)_Previous],
    b.[MAPRITScore(Spring)], p.[MAPRITScore(Spring)_Previous],
    b.[MAPPercentile(Fall)], p.[MAPPercentile(Fall)_Previous],
    b.[MAPPercentile(Winter)], p.[MAPPercentile(Winter)_Previous],
    b.[MAPPercentile(Spring)], p.[MAPPercentile(Spring)_Previous],
    b.EOGScaleScore, p.[EOGScaleScore_Previous],
    b.EOGPercentileRank, p.[EOGPercentileRank_Previous],
    b.presentPercentage,
    b.ChronicallyAbsent,
    b.Race,
    b.Gender,
    b.Disability,
    b.FRL,
    b.TotalIncidents --into #temp_HCS_VAlidation
FROM Base b
LEFT JOIN PrevYear p 
    ON b.SchoolYear = p.SchoolYear
   AND b.DistrictStudentId = p.DistrictStudentId
	--WHERE b.DistrictStudentId = '176736'

--SELECT DISTINCT 
--    GradeCode,
--    [MAPRITScore(Fall)],
--    [MAPRITScore(Winter)],
--    [MAPRITScore(Spring)],
--    [MAPPercentile(Fall)],
--    [MAPPercentile(Winter)],
--    [MAPPercentile(Spring)],
--    EOGScaleScore,
--    EOGScaleScore_Previous,
--    EOGPercentileRank,
--    EOGPercentileRank_Previous,
--    presentPercentage,
--    ChronicallyAbsent,
--    Race,
--    Gender,
--    Disability,
--    FRL,
--    TotalIncidents
--FROM #temp_HCS_VAlidation
--WHERE EOGScaleScore <> EOGScaleScore_Previous
--  AND [MAPRITScore(Fall)] IS NOT NULL
--  AND [MAPRITScore(Winter)] IS NOT NULL
--  AND [MAPRITScore(Spring)] IS NOT NULL
--ORDER BY GradeCode, Race, Gender;



WITH MAPBase AS (
    SELECT [SchoolYear]
        ,[Districtstudentid]
        ,[GradeCode]
        ,[RITScore(Fall)]
        ,[RITScore(Winter)]
        ,[RITScore(Spring)]
        ,[PercentileRank(Fall)]
        ,[PercentileRank(Winter)]
        ,[PercentileRank(Spring)]
        ,TenantId
    FROM (
        SELECT *
        FROM (
            SELECT h.SchoolYear
                ,p.AssessmentCode
                ,p.SubjectAreaCode
                ,h.Districtstudentid
                ,g.GradeCode
                ,g.GradeDescription
                ,CASE 
                    WHEN m.MetricCode = 'RITScore' 
                        THEN 'RITScore(' + k.Termcode + ')'
                    WHEN m.MetricCode = '00502' 
                        THEN 'PercentileRank(' + k.Termcode + ')'
                END Termcode
                ,CAST(h.MetricValue AS INT) MetricValue
                ,ROW_NUMBER() OVER (
                    PARTITION BY p.AssessmentCode
                             ,p.SubjectAreaCode
                             ,h.StudentCurrentGradeId
                             ,h.termid
                             ,h.Districtstudentid
                             ,m.MetricCode
                    ORDER BY h.SchoolYear DESC, CAST(h.TestTakenDate AS DATE) DESC
                ) AS RN
                ,h.TenantId
            FROM main.k12studentgenericassessment h
            INNER JOIN main.assessmentdetails p ON h.AssessmentCodeId = p.assessmentdetailsid and h.tenantid = p.tenantid
            INNER JOIN dbo.RefGrade g ON g.gradeid = h.StudentCurrentGradeId and g.tenantid = h.tenantid
            INNER JOIN dbo.refterm k ON h.termid = k.termid and k.TenantId = h.TenantId
            INNER JOIN dbo.refmetric m ON h.MetricCodeId = m.MetricId and m.TenantId = h.TenantId
            WHERE AssessmentCodeId IN (
                    SELECT assessmentdetailsid
                    FROM main.assessmentdetails
                    WHERE AssessmentCode LIKE '%MAP%'
                        AND SubjectAreaCode LIKE '%math%'
                        AND strandareacode IS NULL
                        and TenantId = h.TenantId
                )
              AND m.MetricCode IN ('RITScore','00502')
        ) t
        WHERE RN = 1
    ) o
    PIVOT(
        MAX(MetricValue) 
        FOR Termcode IN (
            [RITScore(Fall)], [RITScore(Winter)], [RITScore(Spring)],
            [PercentileRank(Fall)], [PercentileRank(Winter)], [PercentileRank(Spring)]
        )
    ) u
),
EOGBase AS (
    SELECT h.SchoolYear
        ,h.Districtstudentid
        ,g.GradeCode
        ,MAX(CASE WHEN m.MetricCode = '03479' THEN CAST(h.MetricValue AS INT) END) ScaleScore
        ,MAX(CASE WHEN m.MetricCode = '00502' THEN CAST(h.MetricValue AS INT) END) PercentileRank
        ,h.TenantId
    FROM main.k12studentgenericassessment h
    INNER JOIN main.assessmentdetails p ON h.AssessmentCodeId = p.assessmentdetailsid and h.TenantId = p.TenantId
    INNER JOIN dbo.RefGrade g ON g.gradeid = h.StudentCurrentGradeId and g.TenantId = h.TenantId
    INNER JOIN dbo.refmetric m ON h.MetricCodeId = m.MetricId and m.TenantId = h.TenantId
    WHERE h.AssessmentCodeId IN (
            SELECT assessmentdetailsid
            FROM main.assessmentdetails
            WHERE AssessmentCode LIKE '%EOG%'
                AND SubjectAreaCode LIKE '%math%'
                AND strandareacode IS NULL
                and TenantId = h.TenantId
        )
      AND m.MetricCode IN ('03479','00502')
    GROUP BY h.SchoolYear, h.Districtstudentid, g.GradeCode,h.TenantId
)
,Base AS (
    SELECT agg.SchoolYear
        ,agg.Districtstudentid
        ,agg.StudentFullName
        ,agg.GradeCode as  GradeCode
        ,a.[RITScore(Fall)] as [MAPRITScore(Fall)]
        ,a.[RITScore(Winter)] as [MAPRITScore(Winter)]
        ,a.[RITScore(Spring)] as [MAPRITScore(Spring)]
        ,a.[PercentileRank(Fall)] as [MAPPercentile(Fall)]
        ,a.[PercentileRank(Winter)] as [MAPPercentile(Winter)]
        ,a.[PercentileRank(Spring)] as [MAPPercentile(Spring)]
        ,t.ScaleScore as EOGScaleScore
        ,t.PercentileRank as EOGPercentileRank
        ,agg.Presentrate as presentPercentage
        ,agg.IsChronic as ChronicallyAbsent
        ,agg.Race as Race
        ,agg.Gender as Gender
        ,agg.SpecialEdStatus as Disability
        ,agg.frl as FRL 
        ,c.TotalIncidents as TotalIncidents
        ,a.TenantId
    FROM dbo.aggrptk12studentdetails agg
    LEFT JOIN EOGBase t 
        ON agg.SchoolYear = t.SchoolYear
       AND agg.DistrictStudentId = t.DistrictStudentId
       and agg.TenantId = t.TenantId
    LEFT JOIN MAPBase a ON a.DistrictStudentId = agg.DistrictStudentId
       AND a.schoolyear = agg.SchoolYear
       and a.TenantId = agg.TenantId
    LEFT JOIN (
        SELECT schoolyear as EndYear,districtstudentid as studentNumber, COUNT(Incidentnumber) TotalIncidents,TenantId
        FROM dbo.[DisciplineIncidentCountsDS]
        GROUP BY schoolyear, districtstudentid,TenantId
    ) c ON a.SchoolYear = c.EndYear
       AND a.DistrictStudentId = c.studentnumber
       and c.TenantId = a.TenantId
),
PrevYear AS (
    SELECT SchoolYear + 1 AS SchoolYear
        ,Districtstudentid
        ,[MAPRITScore(Fall)] [MAPRITScore(Fall)_Previous]
        ,[MAPRITScore(Winter)] [MAPRITScore(Winter)_Previous]
        ,[MAPRITScore(Spring)] [MAPRITScore(Spring)_Previous]
        ,[MAPPercentile(Fall)] [MAPPercentile(Fall)_Previous]
        ,[MAPPercentile(Winter)] [MAPPercentile(Winter)_Previous]
        ,[MAPPercentile(Spring)] [MAPPercentile(Spring)_Previous]
        ,EOGScaleScore [EOGScaleScore_Previous]
        ,EOGPercentileRank [EOGPercentileRank_Previous]
    FROM Base
)
SELECT 
    b.SchoolYear,
    b.DistrictStudentId,
    b.StudentFullName,
    b.GradeCode,
    b.[MAPRITScore(Fall)], p.[MAPRITScore(Fall)_Previous],
    b.[MAPRITScore(Winter)], p.[MAPRITScore(Winter)_Previous],
    b.[MAPRITScore(Spring)], p.[MAPRITScore(Spring)_Previous],
    b.[MAPPercentile(Fall)], p.[MAPPercentile(Fall)_Previous],
    b.[MAPPercentile(Winter)], p.[MAPPercentile(Winter)_Previous],
    b.[MAPPercentile(Spring)], p.[MAPPercentile(Spring)_Previous],
    b.EOGScaleScore, p.[EOGScaleScore_Previous],
    b.EOGPercentileRank, p.[EOGPercentileRank_Previous],
    b.presentPercentage,
    b.ChronicallyAbsent,
    b.Race,
    b.Gender,
    b.Disability,
    b.FRL,
    b.TotalIncidents 
FROM Base b
LEFT JOIN PrevYear p 
    ON b.SchoolYear = p.SchoolYear
   AND b.DistrictStudentId = p.DistrictStudentId



--===========================







DECLARE @DatabaseList TABLE (DatabaseName NVARCHAR(128))
INSERT INTO @DatabaseList VALUES 
    ('AnalyticVue_norwood'),
    ('AnalyticVue_district'),
    ('AnalyticVue_clayton'),
    ('AnalyticVue_Hallco'),
    ('AnalyticVue_obs'),
    ('AnalyticVue_fps')

DECLARE @DatabaseName NVARCHAR(128)
DECLARE @SQL NVARCHAR(MAX)
DECLARE @AllResults TABLE (
    DatabaseName NVARCHAR(128),
    SchoolYear INT,
    DistrictStudentId NVARCHAR(50),
    StudentFullName NVARCHAR(255),
    GradeCode NVARCHAR(10),
    [MAPRITScore(Fall)] INT,
    [MAPRITScore(Fall)_Previous] INT,
    [MAPRITScore(Winter)] INT,
    [MAPRITScore(Winter)_Previous] INT,
    [MAPRITScore(Spring)] INT,
    [MAPRITScore(Spring)_Previous] INT,
    [MAPPercentile(Fall)] INT,
    [MAPPercentile(Fall)_Previous] INT,
    [MAPPercentile(Winter)] INT,
    [MAPPercentile(Winter)_Previous] INT,
    [MAPPercentile(Spring)] INT,
    [MAPPercentile(Spring)_Previous] INT,
    EOGScaleScore INT,
    [EOGScaleScore_Previous] INT,
    EOGPercentileRank INT,
    [EOGPercentileRank_Previous] INT,
    presentPercentage DECIMAL(5,2),
    ChronicallyAbsent BIT,
    Race NVARCHAR(50),
    Gender NVARCHAR(10),
    Disability NVARCHAR(50),
    FRL NVARCHAR(50),
    TotalIncidents INT
)

DECLARE db_cursor CURSOR FOR 
SELECT DatabaseName FROM @DatabaseList

OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @DatabaseName

WHILE @@FETCH_STATUS = 0
BEGIN

    SET @SQL = N'
    USE ' + QUOTENAME(@DatabaseName) + ';
    
    WITH MAPBase AS (
    SELECT [SchoolYear]
        ,[Districtstudentid]
        ,[GradeCode]
        ,[RITScore(Fall)]
        ,[RITScore(Winter)]
        ,[RITScore(Spring)]
        ,[PercentileRank(Fall)]
        ,[PercentileRank(Winter)]
        ,[PercentileRank(Spring)]
        ,TenantId
    FROM (
        SELECT *
        FROM (
            SELECT h.SchoolYear
                ,p.AssessmentCode
                ,p.SubjectAreaCode
                ,h.Districtstudentid
                ,g.GradeCode
                ,g.GradeDescription
                ,CASE 
                    WHEN m.MetricCode = ''RITScore''
                        THEN ''RITScore('' + k.Termcode + '')''
                    WHEN m.MetricCode = ''00502'' 
                        THEN ''PercentileRank('' + k.Termcode + '')''
                END Termcode
                ,CAST(h.MetricValue AS INT) MetricValue
                ,ROW_NUMBER() OVER (
                    PARTITION BY p.AssessmentCode
                             ,p.SubjectAreaCode
                             ,h.StudentCurrentGradeId
                             ,h.termid
                             ,h.Districtstudentid
                             ,m.MetricCode
                    ORDER BY h.SchoolYear DESC, CAST(h.TestTakenDate AS DATE) DESC
                ) AS RN
                ,h.TenantId
            FROM main.k12studentgenericassessment h
            INNER JOIN main.assessmentdetails p ON h.AssessmentCodeId = p.assessmentdetailsid and h.tenantid = p.tenantid
            INNER JOIN dbo.RefGrade g ON g.gradeid = h.StudentCurrentGradeId and g.tenantid = h.tenantid
            INNER JOIN dbo.refterm k ON h.termid = k.termid and k.TenantId = h.TenantId
            INNER JOIN dbo.refmetric m ON h.MetricCodeId = m.MetricId and m.TenantId = h.TenantId
            WHERE AssessmentCodeId IN (
                    SELECT assessmentdetailsid
                    FROM main.assessmentdetails
                    WHERE AssessmentCode LIKE ''%MAP%''
                        AND SubjectAreaCode LIKE ''%math%''
                        AND strandareacode IS NULL
                        and TenantId = h.TenantId
                )
              AND m.MetricCode IN (''RITScore'',''00502'')
        ) t
        WHERE RN = 1
    ) o
    PIVOT(
        MAX(MetricValue) 
        FOR Termcode IN (
            [RITScore(Fall)], [RITScore(Winter)], [RITScore(Spring)],
            [PercentileRank(Fall)], [PercentileRank(Winter)], [PercentileRank(Spring)]
        )
    ) u
),
EOGBase AS (
    SELECT h.SchoolYear
        ,h.Districtstudentid
        ,g.GradeCode
        ,MAX(CASE WHEN m.MetricCode = ''03479'' THEN CAST(h.MetricValue AS INT) END) ScaleScore
        ,MAX(CASE WHEN m.MetricCode = ''00502'' THEN CAST(h.MetricValue AS INT) END) PercentileRank
        ,h.TenantId
    FROM main.k12studentgenericassessment h
    INNER JOIN main.assessmentdetails p ON h.AssessmentCodeId = p.assessmentdetailsid and h.TenantId = p.TenantId
    INNER JOIN dbo.RefGrade g ON g.gradeid = h.StudentCurrentGradeId and g.TenantId = h.TenantId
    INNER JOIN dbo.refmetric m ON h.MetricCodeId = m.MetricId and m.TenantId = h.TenantId
    WHERE h.AssessmentCodeId IN (
            SELECT assessmentdetailsid
            FROM main.assessmentdetails
            WHERE AssessmentCode LIKE ''%EOG%''
                AND SubjectAreaCode LIKE ''%math%''
                AND strandareacode IS NULL
                and TenantId = h.TenantId
        )
      AND m.MetricCode IN (''03479'',''00502'')
    GROUP BY h.SchoolYear, h.Districtstudentid, g.GradeCode,h.TenantId
)
,Base AS (
    SELECT agg.SchoolYear
        ,agg.Districtstudentid
        ,agg.StudentFullName
        ,agg.GradeCode as  GradeCode
        ,a.[RITScore(Fall)] as [MAPRITScore(Fall)]
        ,a.[RITScore(Winter)] as [MAPRITScore(Winter)]
        ,a.[RITScore(Spring)] as [MAPRITScore(Spring)]
        ,a.[PercentileRank(Fall)] as [MAPPercentile(Fall)]
        ,a.[PercentileRank(Winter)] as [MAPPercentile(Winter)]
        ,a.[PercentileRank(Spring)] as [MAPPercentile(Spring)]
        ,t.ScaleScore as EOGScaleScore
        ,t.PercentileRank as EOGPercentileRank
        ,agg.Presentrate as presentPercentage
        ,agg.IsChronic as ChronicallyAbsent
        ,agg.Race as Race
        ,agg.Gender as Gender
        ,agg.SpecialEdStatus as Disability
        ,agg.frl as FRL 
        ,c.TotalIncidents as TotalIncidents
        ,a.TenantId
    FROM dbo.aggrptk12studentdetails agg
    LEFT JOIN EOGBase t 
        ON agg.SchoolYear = t.SchoolYear
       AND agg.DistrictStudentId = t.DistrictStudentId
       and agg.TenantId = t.TenantId
    LEFT JOIN MAPBase a ON a.DistrictStudentId = agg.DistrictStudentId
       AND a.schoolyear = agg.SchoolYear
       and a.TenantId = agg.TenantId
    LEFT JOIN (
        SELECT schoolyear as EndYear,districtstudentid as studentNumber, COUNT(Incidentnumber) TotalIncidents,TenantId
        FROM dbo.[DisciplineIncidentCountsDS]
        GROUP BY schoolyear, districtstudentid,TenantId
    ) c ON a.SchoolYear = c.EndYear
       AND a.DistrictStudentId = c.studentnumber
       and c.TenantId = a.TenantId
),
PrevYear AS (
    SELECT SchoolYear + 1 AS SchoolYear
        ,Districtstudentid
        ,[MAPRITScore(Fall)] [MAPRITScore(Fall)_Previous]
        ,[MAPRITScore(Winter)] [MAPRITScore(Winter)_Previous]
        ,[MAPRITScore(Spring)] [MAPRITScore(Spring)_Previous]
        ,[MAPPercentile(Fall)] [MAPPercentile(Fall)_Previous]
        ,[MAPPercentile(Winter)] [MAPPercentile(Winter)_Previous]
        ,[MAPPercentile(Spring)] [MAPPercentile(Spring)_Previous]
        ,EOGScaleScore [EOGScaleScore_Previous]
        ,EOGPercentileRank [EOGPercentileRank_Previous]
    FROM Base
)
    
    INSERT INTO @AllResults
    SELECT 
        ''' + @DatabaseName + ''' as DatabaseName,
        b.SchoolYear,
        b.DistrictStudentId,
        b.StudentFullName,
        b.GradeCode,
        b.[MAPRITScore(Fall)], p.[MAPRITScore(Fall)_Previous],
        b.[MAPRITScore(Winter)], p.[MAPRITScore(Winter)_Previous],
        b.[MAPRITScore(Spring)], p.[MAPRITScore(Spring)_Previous],
        b.[MAPPercentile(Fall)], p.[MAPPercentile(Fall)_Previous],
        b.[MAPPercentile(Winter)], p.[MAPPercentile(Winter)_Previous],
        b.[MAPPercentile(Spring)], p.[MAPPercentile(Spring)_Previous],
        b.EOGScaleScore, p.[EOGScaleScore_Previous],
        b.EOGPercentileRank, p.[EOGPercentileRank_Previous],
        b.presentPercentage,
        b.ChronicallyAbsent,
        b.Race,
        b.Gender,
        b.Disability,
        b.FRL,
        b.TotalIncidents
    FROM Base b
    LEFT JOIN PrevYear p 
        ON b.SchoolYear = p.SchoolYear
       AND b.DistrictStudentId = p.DistrictStudentId'

    print @SQL

    FETCH NEXT FROM db_cursor INTO @DatabaseName
END

CLOSE db_cursor
DEALLOCATE db_cursor

SELECT * FROM @AllResults
 




--drop table #temp_HCS_VAlidation


WITH MAPBase AS (
    SELECT [SchoolYear]
        ,[Districtstudentid]
        ,[GradeCode]
        ,[RITScore(Fall)]
        ,[RITScore(Winter)]
        ,[RITScore(Spring)]
        ,[ScaleScore(Fall)]
        ,[ScaleScore(Winter)]
        ,[ScaleScore(Spring)]
        ,[PercentileRank(Fall)]
        ,[PercentileRank(Winter)]
        ,[PercentileRank(Spring)]
        ,TenantId
    FROM (
        SELECT *
        FROM (
            SELECT h.SchoolYear
                ,p.AssessmentCode
                ,p.SubjectAreaCode
                ,h.Districtstudentid
                ,g.GradeCode
                ,g.GradeDescription
                ,CASE 
                    WHEN m.MetricCode = 'RITScore' 
                        THEN 'RITScore(' + k.Termcode + ')'
                    WHEN m.MetricCode = '03479' 
                        THEN 'ScaleScore(' + k.Termcode + ')'
                    WHEN m.MetricCode = '00502' 
                        THEN 'PercentileRank(' + k.Termcode + ')'
                END Termcode
                ,CAST(h.MetricValue AS INT) MetricValue
                ,ROW_NUMBER() OVER (
                    PARTITION BY p.AssessmentCode
                             ,p.SubjectAreaCode
                             ,h.StudentCurrentGradeId
                             ,h.termid
                             ,h.Districtstudentid
                             ,m.MetricCode
                    ORDER BY h.SchoolYear DESC, CAST(h.TestTakenDate AS DATE) DESC
                ) AS RN
                ,h.TenantId
            FROM main.k12studentgenericassessment h
            INNER JOIN main.assessmentdetails p ON h.AssessmentCodeId = p.assessmentdetailsid and h.tenantid = p.tenantid
            INNER JOIN dbo.RefGrade g ON g.gradeid = h.StudentCurrentGradeId and g.tenantid = h.tenantid
            INNER JOIN dbo.refterm k ON h.termid = k.termid and k.TenantId = h.TenantId
            INNER JOIN dbo.refmetric m ON h.MetricCodeId = m.MetricId and m.TenantId = h.TenantId
            WHERE AssessmentCodeId IN (
                    SELECT assessmentdetailsid
                    FROM main.assessmentdetails
                    WHERE AssessmentCode LIKE '%MAP%'
                        AND SubjectAreaCode LIKE '%math%'
                        AND strandareacode IS NULL
                        and TenantId = h.TenantId
                )
              AND m.MetricCode IN ('RITScore','00502','03479')
        ) t
        WHERE RN = 1
    ) o
    PIVOT(
        MAX(MetricValue) 
        FOR Termcode IN (
            [RITScore(Fall)], [RITScore(Winter)], [RITScore(Spring)],
            [ScaleScore(Fall)], [ScaleScore(Winter)], [ScaleScore(Spring)],
            [PercentileRank(Fall)], [PercentileRank(Winter)], [PercentileRank(Spring)]
        )
    ) u
),
EOGBase AS (
    SELECT h.SchoolYear
        ,h.Districtstudentid
        ,g.GradeCode
        ,MAX(CASE WHEN m.MetricCode = '03479' THEN CAST(h.MetricValue AS INT) END) ScaleScore
        ,MAX(CASE WHEN m.MetricCode = '00502' THEN CAST(h.MetricValue AS INT) END) PercentileRank
        ,h.TenantId
    FROM main.k12studentgenericassessment h
    INNER JOIN main.assessmentdetails p ON h.AssessmentCodeId = p.assessmentdetailsid and h.TenantId = p.TenantId
    INNER JOIN dbo.RefGrade g ON g.gradeid = h.StudentCurrentGradeId and g.TenantId = h.TenantId
    INNER JOIN dbo.refmetric m ON h.MetricCodeId = m.MetricId and m.TenantId = h.TenantId
    WHERE h.AssessmentCodeId IN (
            SELECT assessmentdetailsid
            FROM main.assessmentdetails
            WHERE AssessmentCode LIKE '%EOG%'
                AND SubjectAreaCode LIKE '%math%'
                AND strandareacode IS NULL
                and TenantId = h.TenantId
        )
      AND m.MetricCode IN ('03479','00502')
    GROUP BY h.SchoolYear, h.Districtstudentid, g.GradeCode,h.TenantId
)
,Base AS (
    SELECT agg.SchoolYear
        ,agg.Districtstudentid
        ,agg.StudentFullName
        ,agg.GradeCode as  GradeCode
        ,a.[RITScore(Fall)] as [MAPRITScore(Fall)]
        ,a.[RITScore(Winter)] as [MAPRITScore(Winter)]
        ,a.[RITScore(Spring)] as [MAPRITScore(Spring)]
        ,a.[ScaleScore(Fall)]
        ,a.[ScaleScore(Winter)]
        ,a.[ScaleScore(Spring)]
        ,a.[PercentileRank(Fall)] as [MAPPercentile(Fall)]
        ,a.[PercentileRank(Winter)] as [MAPPercentile(Winter)]
        ,a.[PercentileRank(Spring)] as [MAPPercentile(Spring)]
        ,t.ScaleScore as EOGScaleScore
        ,t.PercentileRank as EOGPercentileRank
        ,agg.Presentrate as presentPercentage
        ,agg.IsChronic as ChronicallyAbsent
        ,agg.Race as Race
        ,agg.Gender as Gender
        ,agg.SpecialEdStatus as Disability
        ,agg.frl as FRL 
        ,c.TotalIncidents as TotalIncidents
        ,a.TenantId
    FROM dbo.aggrptk12studentdetails agg
    LEFT JOIN EOGBase t 
        ON agg.SchoolYear = t.SchoolYear
       AND agg.DistrictStudentId = t.DistrictStudentId
       and agg.TenantId = t.TenantId
    LEFT JOIN MAPBase a ON a.DistrictStudentId = agg.DistrictStudentId
       AND a.schoolyear = agg.SchoolYear
       and a.TenantId = agg.TenantId
    LEFT JOIN (
        SELECT schoolyear as EndYear,districtstudentid as studentNumber, COUNT(Incidentnumber) TotalIncidents,TenantId
        FROM dbo.[DisciplineIncidentCountsDS]
        GROUP BY schoolyear, districtstudentid,TenantId
    ) c ON a.SchoolYear = c.EndYear
       AND a.DistrictStudentId = c.studentnumber
       and c.TenantId = a.TenantId
),
PrevYear AS (
    SELECT SchoolYear + 1 AS SchoolYear
        ,Districtstudentid
        ,[MAPRITScore(Fall)] [MAPRITScore(Fall)_Previous]
        ,[MAPRITScore(Winter)] [MAPRITScore(Winter)_Previous]
        ,[MAPRITScore(Spring)] [MAPRITScore(Spring)_Previous]
        ,[MAPPercentile(Fall)] [MAPPercentile(Fall)_Previous]
        ,[MAPPercentile(Winter)] [MAPPercentile(Winter)_Previous]
        ,[MAPPercentile(Spring)] [MAPPercentile(Spring)_Previous]
        ,EOGScaleScore [EOGScaleScore_Previous]
        ,EOGPercentileRank [EOGPercentileRank_Previous]
    FROM Base
)
insert into #temp_HCS_VAlidation
SELECT 
    b.SchoolYear,
    b.DistrictStudentId,
    b.StudentFullName,
    b.GradeCode,
    b.[MAPRITScore(Fall)],
    b.[MAPRITScore(Winter)],
    b.[MAPRITScore(Spring)], 
    b.[ScaleScore(Fall)],
    b.[ScaleScore(Winter)],
    b.[ScaleScore(Spring)],
    b.[MAPPercentile(Fall)], p.[MAPPercentile(Fall)_Previous],
    b.[MAPPercentile(Winter)], p.[MAPPercentile(Winter)_Previous],
    b.[MAPPercentile(Spring)], p.[MAPPercentile(Spring)_Previous],
    b.EOGScaleScore, p.[EOGScaleScore_Previous],
    b.EOGPercentileRank, p.[EOGPercentileRank_Previous],
    b.presentPercentage,
    b.ChronicallyAbsent,
    b.Race,
    b.Gender,
    b.Disability,
    b.FRL,
    b.TotalIncidents,
    b.tenantid 
FROM Base b  
LEFT JOIN PrevYear p 
    ON b.SchoolYear = p.SchoolYear
   AND b.DistrictStudentId = p.DistrictStudentId



SELECT  
    GradeCode,
    [MAPPercentile(Fall)],
    [MAPPercentile(Winter)],
    [MAPPercentile(Spring)],
    EOGScaleScore,
    EOGScaleScore_Previous,
    EOGPercentileRank,
    EOGPercentileRank_Previous,
    presentPercentage,
    ChronicallyAbsent,
    Race,
    Gender,
    Disability,
    FRL,
    TotalIncidents,
    tenantid
FROM #temp_HCS_VAlidation

WHERE EOGScaleScore is not null and EOGScaleScore_Previous is not null
  --AND [MAPRITScore(Fall)] IS NOT NULL
  --AND [MAPRITScore(Winter)] IS NOT NULL
  --AND [MAPRITScore(Spring)] IS NOT NULL
ORDER BY GradeCode, Race, Gender;
