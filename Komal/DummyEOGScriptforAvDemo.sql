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
        studentnumber as Districtstudentid,
        endyear as SchoolYear,
        ROUND(CAST(SUM(daysPresent) AS FLOAT) * 100 / SUM(scheduledDays), 2) AS PresentPercentage,
        MAX(chronicallyAbsent) AS chronicallyAbsent 
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
),PrevYear
AS (
	SELECT SchoolYear + 1 AS SchoolYear 
		,Districtstudentid
		,ISNULL([MAPRITScore(Fall)], 0) [MAPRITScore(Fall)_Previous]
		,ISNULL([MAPRITScore(Winter)], 0) [MAPRITScore(Winter)_Previous]
		,ISNULL([MAPRITScore(Spring)], 0) [MAPRITScore(Spring)_Previous]
		,ISNULL(EOGScaleScore, 0) [EOGScaleScore_Previous]
	FROM Base
	)
select top 6000
SchoolYear, DistrictStudentId, StudentFullName, GradeCode, ChronicallyAbsent, SubjectAreaName, Race, Gender, Disability, TotalIncidents,
PresentPercentage, MAPRITScore_Fall, MAPRITScore_Winter, MAPRITScore_Spring, EOGScaleScore_Previous, TenantId from
(
SELECT
    b.SchoolYear,
    b.DistrictStudentId,
    b.StudentFullName,
    b.GradeCode,
    b.ChronicallyAbsent,
    b.SubjectAreaName,
    b.Race,
    b.Gender,
    b.Disability,
    cast(b.TotalIncidents as int) as TotalIncidents,
    cast(b.presentPercentage as decimal(10,2)) as PresentPercentage,
    cast(b.[MAPRITScore(Fall)] as int) as MAPRITScore_Fall,
    cast(b.[MAPRITScore(Winter)] as int) as MAPRITScore_Winter,
    cast(b.[MAPRITScore(Spring)] as int) as MAPRITScore_Spring, 
    cast(p.EOGScaleScore_Previous as int) as EOGScaleScore_Previous,
    11 as TenantId,
    row_number () over(partition by b.DistrictStudentId,b.schoolyear order by b.DistrictStudentId) as rn
FROM Base b  
LEFT JOIN PrevYear p ON b.SchoolYear = p.SchoolYear
	AND b.DistrictStudentId = p.DistrictStudentId
WHERE  p.[EOGScaleScore_Previous] is not null and [MAPRITScore(Fall)] is not null and [MAPRITScore(Winter)] is not null  and [MAPRITScore(Spring)] is not null
and b.schoolyear = 2025
)a 
where rn = 1





drop table [DummyRIT_latest]
CREATE TABLE [dbo].[DummyRIT_latest](
	[SchoolYear] [varchar](4) NOT NULL,
	[DistrictStudentId] [varchar](500) NULL,
	[StudentFullName] [varchar](500) NULL,
	[GradeCode] [int] NULL,
	[ChronicallyAbsent] [varchar](3) NOT NULL,
	[SubjectAreaName] [varchar](4) NOT NULL,
	[Race] [varchar](500) NULL,
	[Gender] [varchar](500) NULL,
	[Disability] [varchar](500) NULL,
	[TotalIncidents] [int] NULL,
	[PresentPercentage] [decimal](10, 2) NULL,
	[EOGScaleScore] [int] NULL,
	[MAPRITScore_Fall] [int] NULL,
	[MAPRITScore_Winter] [int] NULL,
	[MAPRITScore_Spring] [int] NULL,
	[TenantId] [int] NULL
) 
GO




select * from DummyEOG_latest
select * from  DummyRIT_latest

--truncate table DummyRIT_latest


insert into DummyRIT_latest
select '2023' SchoolYear, DistrictStudentId, StudentFullName, case when GradeCode = 'PK' then -1 when GradeCode = 'K' then 0 else GradeCode end as gradecode, ChronicallyAbsent, 'Math' SubjectAreaName, Race, Gender, Disability, TotalIncidents, PresentPercentage,EOGScaleScore, MAPRITScore_Fall, MAPRITScore_Winter, MAPRITScore_Spring, TenantId  from DummyEOG_latest

;WITH RandomAgg AS (
    SELECT 
        DistrictStudentId,
        StudentFullName,
        GradeCode,
        Race,
        Gender,
        ROW_NUMBER() OVER (ORDER BY NEWID()) AS rn
    FROM AggRptK12StudentDetails
    WHERE SchoolYear = 2023 and tenantid = 11
),
DummyWithRow AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
    FROM DummyEOG_latest
)
UPDATE d
SET 
    d.DistrictStudentId = a.DistrictStudentId,
    d.StudentFullName = a.StudentFullName,
    d.GradeCode       = a.GradeCode,
    d.Race            = a.Race,
    d.Gender          = a.Gender
FROM DummyEOG_latest d
INNER JOIN DummyWithRow dw ON d.DistrictStudentId = dw.DistrictStudentId
INNER JOIN RandomAgg a ON dw.rn = a.rn;
