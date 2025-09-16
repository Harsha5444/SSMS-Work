WITH MAPBase AS (  ---87695
    SELECT [SchoolYear]
        ,[Districtstudentid]
        ,[SubjectAreaName]
        ,[RITScore(Fall)]
        ,[RITScore(Winter)]
        ,[RITScore(Spring)]
        ,TenantId
    FROM (        
       select  
            SchoolYear,
            StudentID as Districtstudentid,
            [Subject] as SubjectAreaName ,
            'RITScore(' + TestTerm + ')' as Termcode,
            TestRITScore as MetricValue,
            TenantId
            from clayton_assessment_map where [Subject] = 'Mathematics' --316308
        ) t
    PIVOT(MAX(MetricValue) FOR Termcode IN ( [RITScore(Fall)], [RITScore(Winter)], [RITScore(Spring)])) u
),
EOGBase AS ( 
    select SchoolYear,studentNumber as Districtstudentid,testType as [SubjectAreaName],SS as ScaleScore,TenantId 
    from clayton_assessment_eog where testType = 'Math'
)
,DisciplineCounts AS (
    SELECT 
        SchoolYear,
        Districtstudentid,
        COUNT(Incidentnumber) TotalIncidents,
        TenantId
    FROM dbo.[DisciplineIncidentCountsDS] WITH (NOLOCK)
    GROUP BY schoolyear, districtstudentid, TenantId
)
,Base AS (
    SELECT
        agg.SchoolYear
        ,agg.Districtstudentid
        ,agg.StudentName as StudentFullName
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
    FROM CCPSK12StudentDetails agg
    INNER JOIN EOGBase t ON agg.SchoolYear = t.SchoolYear AND agg.DistrictStudentId = t.DistrictStudentId and agg.TenantId = t.TenantId
    Inner JOIN MAPBase a ON a.DistrictStudentId = t.DistrictStudentId AND a.schoolyear = t.SchoolYear and a.TenantId = t.TenantId 
    LEFT JOIN DisciplineCounts c ON agg.SchoolYear = c.SchoolYear AND agg.DistrictStudentId = c.DistrictStudentId AND c.TenantId = agg.TenantId
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
    b.presentPercentage,
    b.ChronicallyAbsent,
    b.Race,
    b.Gender,
    b.Disability,
    b.FRL,
    b.TotalIncidents
FROM Base b  
--WHERE EOGScaleScore is not null 
ORDER BY Schoolyear,GradeCode, Race, Gender;
