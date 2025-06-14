-- ===========================
-- 2022 QUERIES
-- ===========================

-- Basic EOC data for 2022
select * from main.clayton_eoc where schoolyear = 2022 and GTID_RPT in (
    select distinct GTID_RPT from main.clayton_eoc where schoolyear = 2022
    except
    select distinct GTID from dbo.clayton_assessment_eoc where schoolyear = 2022
)

-- Assessment EOC data for 2022
select * from dbo.clayton_assessment_eoc where schoolyear = 2022 and GTID='1004095468'

-- School information for 2022
select distinct schoolname,schoolnumber from main.clayton_analyticvue_icstudents where schoolyear = 2022 and schoolname like '%elite%'
select * from main.k12school where schoolyear = 2022 and NameofInstitution like '%elite%'

-- School identifier mapping for 2022
select distinct SchCode_RPT,schname_rpt from [Main].[Clayton_EOC] where schoolyear = 2022 and SchCode_RPT in (
    select distinct SchCode_RPT from [Main].[Clayton_EOC] where schoolyear = 2022
    intersect
    select distinct SchoolIdentifier from Main.K12School where schoolyear = 2022
)

select distinct SchoolIdentifier,NameofInstitutiON from Main.K12School where schoolyear = 2022 and SchoolIdentifier in (
    select distinct SchCode_RPT from [Main].[Clayton_EOC] where schoolyear = 2022
    intersect
    select distinct SchoolIdentifier from Main.K12School where schoolyear = 2022
)

-- Complex join query for 2022
select e.* FROM [Main].[Clayton_EOC] e WITH (NOLOCK)
INNER JOIN (
    SELECT * FROM (
        SELECT *, row_number() OVER (PARTITION BY schoolyear, studentnumber ORDER BY startdate) AS rn
        FROM main.clayton_analyticvue_icstudents
    ) a WHERE rn = 1
) AS s ON e.GTID_RPT = s.Stateid AND e.schoolyear = s.schoolyear
INNER JOIN main.k12school AS k ON RIGHT('0000' + e.SchCode_RPT, 4) = k.SchoolIdentifier AND e.schoolyear = k.SchoolYear
where e.schoolyear = 2022

-- Import view query for 2022
select * from Import_EOC_K12Studentgenericassessment_Vw_50 where schoolyear = 2022 and districtstudentid = '0428224'

-- ===========================
-- 2023 QUERIES
-- ===========================

-- Basic EOG and EOC data for 2023
select * from main.clayton_eog where schoolyear = 2023
select * from dbo.clayton_assessment_eoc where schoolyear = 2023

-- GTID comparison for 2023
select distinct GTID_RPT from main.clayton_eoc where schoolyear = 2023
except
select distinct GTID from dbo.clayton_assessment_eoc where schoolyear = 2023

-- ===========================
-- 2024 QUERIES
-- ===========================

-- Stored procedure execution for 2024
--exec [USP_Clayton_Assessment_EOC] 2024

-- ===========================
-- MULTI-YEAR QUERIES
-- ===========================

-- School identifier intersection (all years)
select distinct RIGHT('0000' + SchCode_RPT, 4) from [Main].[Clayton_EOC] 
intersect
select distinct SchoolIdentifier from Main.K12School

-- Missing records across multiple years
SELECT DISTINCT e.GTID, e.schoolyear FROM dbo.clayton_assessment_eoc e
WHERE e.schoolyear IN (2022, 2023, 2024)
AND NOT EXISTS (
    SELECT 1 FROM dbo.Import_EOC_K12Studentgenericassessment_Vw_50 v
    WHERE v.schoolyear = e.schoolyear AND v.districtstudentid = e.studentnumber
)

-- Specific record lookups
select * from main.clayton_eoc where schoolyear = 2022 and GTID_RPT = '1004095468'

---===============================================================================================

select count(*) from main.clayton_eog where schoolyear = 2022  --23839
select count(*) from main.clayton_eog where schoolyear = 2023  --23120
select count(*) from main.clayton_eog where schoolyear = 2024  --22421

select count(*) from clayton_assessment_eog where schoolyear = 2022  --59978
select count(*) from clayton_assessment_eog where schoolyear = 2023  --58048
select count(*) from clayton_assessment_eog where schoolyear = 2024  --56344

select count(distinct GTID_RPT) from main.clayton_eog where schoolyear = 2022  --23839
select count(distinct GTID_RPT) from main.clayton_eog where schoolyear = 2023  --23119
select count(distinct GTID_RPT) from main.clayton_eog where schoolyear = 2024  --22419

select count(distinct GTID) from clayton_assessment_eog where schoolyear = 2022  --23823
select count(distinct GTID) from clayton_assessment_eog where schoolyear = 2023  --23119
select count(distinct GTID) from clayton_assessment_eog where schoolyear = 2024  --22405








