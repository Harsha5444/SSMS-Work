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
