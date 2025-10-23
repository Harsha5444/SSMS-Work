WITH MAPBase AS (  ---87427
    SELECT [SchoolYear]
        ,[Districtstudentid]
        ,[SubjectAreaName]
        ,[RITScore(Fall)]
        ,[RITScore(Winter)]
        ,[RITScore(Spring)]
        ,[TestPercentile(Fall)]
        ,[TestPercentile(Winter)] 
        ,[TestPercentile(Spring)]
        ,TenantId
    FROM (        
          select  
            SchoolYear,
            StudentID as Districtstudentid,
            [Subject] as SubjectAreaName ,
            'RITScore(' + TestTerm + ')' as Termcode,
            TestRITScore as MetricValue,
            TenantId
            from [HCS_Assessment_MAP_7YR] where [Subject] = 'Mathematics'

            union all

             select  
            SchoolYear,
            StudentID as Districtstudentid,
            [Subject] as SubjectAreaName ,
            'TestPercentile(' + TestTerm + ')' as Termcode,
            TestPercentile as MetricValue,
            TenantId
            from [HCS_Assessment_MAP_7YR] where [Subject] = 'Mathematics'
    ) o
    PIVOT(MAX(MetricValue) FOR Termcode IN ( [RITScore(Fall)], [RITScore(Winter)], [RITScore(Spring)] ,[TestPercentile(Fall)], [TestPercentile(Winter)], [TestPercentile(Spring)] )) u
),
EOGBase AS (
select SchoolYear,studentNumber as Districtstudentid,testType as [SubjectAreaName],SS as ScaleScore,TenantId from [dbo].[HCS_Assessment_EOG_7YR]
where testType='Math'
),
AttendanceSummary AS (
SELECT 
    studentnumber AS DistrictStudentID,
    endyear AS SchoolYear,
    ROUND(CAST(SUM(daysPresent) AS FLOAT) * 100 / SUM(scheduledDays), 2) AS PresentPercentage,
    CASE 
        WHEN (CAST(SUM(daysPresent) AS FLOAT) * 100 / SUM(scheduledDays)) >= 90 THEN '0' 
        ELSE '1' 
    END AS ChronicallyAbsent
FROM HCS_attendanceSummary_7YR WITH (NOLOCK)
GROUP BY studentnumber, endyear

),
BehaviorIncidents AS (
    SELECT 
        EndYear as SchoolYear,
        studentNumber as Districtstudentid,
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
        ,a.[TestPercentile(Fall)]   [MAPTestPercentile(Fall)]
        ,a.[TestPercentile(Winter)] [MAPTestPercentile(Winter)]
        ,a.[TestPercentile(Spring)] [MAPTestPercentile(Spring)]
        ,t.ScaleScore EOGScaleScore
        ,ISNULL(b.presentPercentage, '0.0') presentPercentage
        ,CASE WHEN ISNULL(b.chronicallyAbsent, 'N') = 'N' THEN 0 ELSE 1 END ChronicallyAbsent
        ,agg.raceEthnicity as  Race
        ,agg.gender as  Gender
        ,CASE WHEN agg.disability1 is null THEN 'No' ELSE 'Yes' END Disability
        ,'Free Lunch' as FRL
        ,ISNULL(c.TotalIncidents, 0) TotalIncidents
    FROM (select distinct tenantID,studentNumber,studentFullName,gender,raceEthnicity,gradeLevel,endYear,SWDIndicator,disability1 from HCS_students_7YR) agg    
    INNER JOIN EOGBase t ON t.SchoolYear = agg.endYear AND t.DistrictStudentId = agg.studentNumber
    Inner JOIN MAPBase a  ON a.SchoolYear = t.schoolYear AND a.DistrictStudentId = t.DistrictStudentId
    LEFT JOIN AttendanceSummary b ON agg.studentNumber = b.DistrictStudentId AND agg.endYear = b.SchoolYear
    LEFT JOIN BehaviorIncidents c ON agg.studentNumber = c.DistrictStudentId AND agg.endYear = c.SchoolYear
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
    b.[MAPTestPercentile(Fall)],
    b.[MAPTestPercentile(Winter)],
    b.[MAPTestPercentile(Spring)],
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
