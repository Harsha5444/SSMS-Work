--=======================================================================================================
--Hallco Script
--=======================================================================================================

WITH MAPBase AS (
    SELECT [SchoolYear]
        ,[Districtstudentid]
        ,[SubjectAreaName]
        ,[GradeCode]
        ,[RITScore(Fall)]
        ,[RITScore(Winter)]
        ,[RITScore(Spring)]
        ,TenantId
    FROM (        
        SELECT SchoolYear,Districtstudentid,SubjectAreaName,GradeCode,Termcode,MetricValue,TenantId
        FROM (
            SELECT h.SchoolYear                
                ,h.Districtstudentid
                ,p.SubjectAreaName
                ,g.GradeCode
                ,'RITScore(' + k.Termcode + ')' as Termcode
                ,CAST(h.MetricValue AS INT) MetricValue
                ,ROW_NUMBER() OVER ( PARTITION BY p.AssessmentCode,p.SubjectAreaCode,p.SubjectAreaName,h.StudentCurrentGradeId,h.termid,h.Districtstudentid,m.MetricCode ORDER BY h.SchoolYear DESC, CAST(h.TestTakenDate AS DATE) DESC ) AS RN
                ,h.TenantId
            FROM main.k12studentgenericassessment h
            INNER JOIN main.assessmentdetails p ON h.AssessmentCodeId = p.assessmentdetailsid and h.tenantid = p.tenantid
            INNER Join RefGrade g on g.GradeId = h.StudentCurrentGradeId and g.TenantId  = h.TenantId
            INNER JOIN dbo.refterm k ON h.termid = k.termid and k.TenantId = h.TenantId
            INNER JOIN dbo.refmetric m ON h.MetricCodeId = m.MetricId and m.TenantId = h.TenantId
            WHERE p.AssessmentCode LIKE '%MAP%' AND p.strandareacode IS NULL AND m.MetricCode = 'RITScore'
        ) t
        WHERE RN = 1
    ) o
    PIVOT(MAX(MetricValue) FOR Termcode IN ( [RITScore(Fall)], [RITScore(Winter)], [RITScore(Spring)])) u
),
EOGBase AS (
    SELECT h.SchoolYear  ,h.Districtstudentid  ,h.[SubjectAreaName]  ,H.GradeCode ,H.ScaleScore ,h.TenantId
    FROM AggrptAssessmentSubgroupData h
    WHERE h.assessmentcode = 'EOG' and islatest = 1
),
AttendanceSummary AS (
    SELECT 
        studentnumber,
        endyear,
        ROUND(CAST(SUM(daysPresent) AS FLOAT) * 100 / SUM(scheduledDays), 2) AS PresentPercentage,
        MAX(chronicallyAbsent) AS chronicallyAbsent 
    FROM HCS_attendanceSummary_7YR WITH (NOLOCK)
    GROUP BY studentnumber, endyear
    HAVING SUM(daysPresent) <> 0
),
BehaviorIncidents AS (
    SELECT 
        EndYear,
        studentNumber,
        COUNT(incidentID) AS TotalIncidents
    FROM HCS_behavior_7YR WITH (NOLOCK)
    GROUP BY EndYear, studentNumber
),
Base AS (
    SELECT agg.endyear as SchoolYear
        ,agg.studentNumber as  Districtstudentid
        ,agg.studentFullName as StudentFullName
        ,ISNULL(agg.gradeLevel, 'Unknown')  as GradeCode
        ,a.[SubjectAreaName]
        ,a.[RITScore(Fall)] [MAPRITScore(Fall)]
        ,a.[RITScore(Winter)] [MAPRITScore(Winter)]
        ,a.[RITScore(Spring)] [MAPRITScore(Spring)]
        ,t.ScaleScore EOGScaleScore
        ,ISNULL(b.presentPercentage, '0.0') presentPercentage
        ,CASE WHEN ISNULL(b.chronicallyAbsent, 'N') = 'N' THEN 0 ELSE 1 END ChronicallyAbsent
        ,agg.raceEthnicity as  Race
        ,agg.gender as  Gender
        ,CASE WHEN agg.disability1 is null THEN 'No' ELSE 'Yes' END Disability
        ,'Free Lunch' as FRL
        ,ISNULL(c.TotalIncidents, 0) TotalIncidents
    FROM (select distinct tenantID,studentNumber,studentFullName,gender,raceEthnicity,gradeLevel,endYear,SWDIndicator,disability1 from HCS_students_7YR) agg    
    INNER JOIN EOGBase t ON t.SchoolYear = agg.endYear AND t.GradeCode = agg.gradeLevel AND t.DistrictStudentId = agg.studentNumber
    LEFT JOIN MAPBase a  ON a.SchoolYear = t.SchoolYear AND a.GradeCode = t.GradeCode AND a.DistrictStudentId = t.DistrictStudentId AND a.[SubjectAreaName] = t.[SubjectAreaName]
    LEFT JOIN AttendanceSummary b ON agg.studentNumber = b.studentnumber AND agg.endYear = b.endyear
    LEFT JOIN BehaviorIncidents c ON agg.studentNumber = c.studentNumber AND agg.endYear = c.EndYear
)
SELECT 
    b.SchoolYear,
    b.DistrictStudentId,
    b.StudentFullName,
    b.GradeCode,
    b.[SubjectAreaName],
    b.[MAPRITScore(Fall)],
    b.[MAPRITScore(Winter)],
    b.[MAPRITScore(Spring)],
    b.EOGScaleScore, 
    LAG(b.EOGScaleScore)over ( PARTITION by b.DistrictStudentId,[SubjectAreaName] order by schoolyear asc) EOGScaleScore_Previous,
    b.presentPercentage,
    b.ChronicallyAbsent,
    b.Race,
    b.Gender,
    b.Disability,
    b.FRL,
    b.TotalIncidents
FROM Base b
WHERE EOGScaleScore is not null 
ORDER BY Schoolyear,GradeCode, Race, Gender;

--=======================================================================================================
--Clayton Script
--=======================================================================================================

WITH MAPBase AS (
    SELECT [SchoolYear]
        ,[Districtstudentid]
        ,[SubjectAreaName]
        ,[RITScore(Fall)]
        ,[RITScore(Winter)]
        ,[RITScore(Spring)]
        ,TenantId
    FROM (        
        SELECT SchoolYear,Districtstudentid,SubjectAreaName,Termcode,MetricValue,TenantId
        FROM (
            SELECT h.SchoolYear                
                ,h.Districtstudentid
                ,p.SubjectAreaName
                ,'RITScore(' + k.Termcode + ')' as Termcode
                ,CAST(h.MetricValue AS INT) MetricValue
                ,ROW_NUMBER() OVER ( PARTITION BY p.AssessmentCode,p.SubjectAreaCode,p.SubjectAreaName,h.StudentCurrentGradeId ,h.termid,h.Districtstudentid,m.MetricCode ORDER BY h.SchoolYear DESC, CAST(h.TestTakenDate AS DATE) DESC ) AS RN
                ,h.TenantId
            FROM main.k12studentgenericassessment h
            INNER JOIN main.assessmentdetails p ON h.AssessmentCodeId = p.assessmentdetailsid and h.tenantid = p.tenantid
            INNER JOIN dbo.refterm k ON h.termid = k.termid and k.TenantId = h.TenantId
            INNER JOIN dbo.refmetric m ON h.MetricCodeId = m.MetricId and m.TenantId = h.TenantId
            WHERE p.AssessmentCode LIKE '%MAP%' AND p.strandareacode IS NULL AND m.MetricCode = '00501'
        ) t
        WHERE RN = 1
    ) o
    PIVOT(MAX(MetricValue) FOR Termcode IN ( [RITScore(Fall)], [RITScore(Winter)], [RITScore(Spring)])) u
),
EOGBase AS ( 
    SELECT h.SchoolYear  ,h.Districtstudentid  ,h.[SubjectAreaName]  ,H.GradeCode ,H.ScaleScore ,h.TenantId
    FROM AggrptAssessmentSubgroupData h
    WHERE h.assessmentcode = 'EOG' and islatest = 1
)
,DisciplineCounts AS (
    SELECT 
        schoolyear as EndYear,
        districtstudentid as studentNumber,
        COUNT(Incidentnumber) TotalIncidents,
        TenantId
    FROM dbo.[DisciplineIncidentCountsDS] WITH (NOLOCK)
    GROUP BY schoolyear, districtstudentid, TenantId
)
,Base AS (
    SELECT
        agg.SchoolYear
        ,agg.Districtstudentid
        ,agg.StudentFullName
        ,agg.GradeCode as  GradeCode
        ,agg.Presentrate as presentPercentage
        ,agg.IsChronic as ChronicallyAbsent
        ,agg.Race as Race
        ,agg.GenderCode as Gender
        ,agg.SpecialEdStatus as Disability
        ,'Free Lunch' as FRL 
        ,agg.TenantId
        ,a.[RITScore(Fall)] as [MAPRITScore(Fall)]
        ,a.[RITScore(Winter)] as [MAPRITScore(Winter)]
        ,a.[RITScore(Spring)] as [MAPRITScore(Spring)]
        ,t.ScaleScore as EOGScaleScore
        ,t.[SubjectAreaName]
        ,ISNULL(c.TotalIncidents, 0)  as TotalIncidents
    FROM dbo.aggrptk12studentdetails agg
    INNER JOIN EOGBase t ON agg.SchoolYear = t.SchoolYear AND agg.DistrictStudentId = t.DistrictStudentId and agg.TenantId = t.TenantId
    LEFT JOIN MAPBase a ON a.DistrictStudentId = t.DistrictStudentId AND a.schoolyear = t.SchoolYear and a.TenantId = t.TenantId 
    and CASE WHEN t.SubjectAreaName = 'English Language Arts' THEN 'Language Arts' ELSE t.SubjectAreaName END = a.SubjectAreaName
    LEFT JOIN DisciplineCounts c ON a.SchoolYear = c.EndYear AND a.DistrictStudentId = c.studentnumber AND c.TenantId = a.TenantId
)
SELECT 
    b.SchoolYear,
    b.DistrictStudentId,
    b.StudentFullName,
    b.GradeCode,
    b.[SubjectAreaName],
    b.[MAPRITScore(Fall)],
    b.[MAPRITScore(Winter)],
    b.[MAPRITScore(Spring)], 
    b.EOGScaleScore,
    LAG(b.EOGScaleScore)over ( PARTITION by b.DistrictStudentId,[SubjectAreaName] order by schoolyear asc) EOGScaleScore_Previous,
    b.presentPercentage,
    b.ChronicallyAbsent,
    b.Race,
    b.Gender,
    b.Disability,
    b.FRL,
    b.TotalIncidents
FROM Base b  
WHERE EOGScaleScore is not null 
ORDER BY Schoolyear,GradeCode, Race, Gender;