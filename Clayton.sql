select * from main.clayton_analyticvue_icstudents where SchoolName like '%7 Pillars CA High%' and schoolyear =2023
select * from AggRptK12StudentDetails where SchoolName = '7 Pillars Career Academy High' and schoolyear =2023

select * from CCPSK12StudentDetails  where SchoolName = '7 Pillars Career Academy High' and schoolyear =2023



select * from Clayton_SecondaryEnrollment_Programs where schoolyear = 2026 and schoolname = 'Ash Street Elementary'
select * from main.clayton_analyticvue_icstudents  where schoolyear = 2026 and schoolOverride=3050

---=============================
SELECT STUFF((
    SELECT DISTINCT '; ' + raceEthnicity as Race
    FROM main.clayton_analyticvue_icstudents 
    WHERE raceEthnicity IS NOT NULL
    ORDER BY Race
    FOR XML PATH(''), TYPE
).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS RaceList;


SELECT d.NameofInstitution,d.SchoolYear,
       STUFF((
           SELECT DISTINCT ', ' + s.race
           FROM CCPSK12StudentDetails s
           WHERE s.SchoolIdentifier = d.SchoolIdentifier and s.SchoolYear = d.SchoolYear
           FOR XML PATH(''), TYPE
       ).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS RaceList
FROM main.K12School d;



SELECT 
    schoolyear AS AcademicYear,
    SchoolName,
    Gender,
    Race,
    COUNT(districtstudentid) AS EnrollmentCount
FROM AnalyticVue_clayton.dbo.CCPSK12StudentDetails
where race is not null
GROUP BY schoolyear, SchoolName, Gender, Race
ORDER BY AcademicYear, SchoolName, Gender, Race
FOR JSON PATH;

SELECT 
    schoolyear AS AcademicYear,
    SchoolName,
    Gender,
    Race,
    COUNT(districtstudentid) AS EnrollmentCount
FROM AnalyticVue_clayton.dbo.CCPSK12StudentDetails
where race is not null --and SchoolName = 'Adamson Middle' and Gender = 'Female' and race = 'black'
GROUP BY schoolyear, SchoolName, Gender, Race
ORDER BY AcademicYear, SchoolName, Gender, Race


WITH DateList AS (
    SELECT CAST(GETDATE() AS DATE) AS d
    UNION ALL
    SELECT DATEADD(DAY, 1, CAST(GETDATE() AS DATE))
)
SELECT 
    d AS Today,
    lead(d) OVER (ORDER BY d) AS Yesterday
FROM DateList;


select * from LinkedReportMappedFileds where reportdetailsid =1431

select distinct a.reportdetailsid,b.ReportDetailsName from LinkedReportMappedFileds  a 
join ReportDetails b on a.reportdetailsid = b.reportdetailsid
where ChildCode is null and
ChildColumnName is null and isvaluefield <> 1
 