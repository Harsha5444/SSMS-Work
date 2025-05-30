SELECT  ca.REPORTED_SCH_YEAR AS SchoolYear,
	ps.leaname AS DistrictName,
	ca.DISTRICT_NUMBER AS LeaIdentifer,
	ca.SCHOOL_NAME AS SchoolName,
	ps.SchoolIdentifier AS SchoolIdentifier,
	ca.GTID AS StateStudentID,
	ca.LAST_NAME AS LastName,
	ca.FIRST_NAME AS FirstName,
	ps.StudentFullName,
	ca.BIRTH_DATE AS Dob,
	ps.Gender,
	ps.Grade,
	ca.SCALE_SCORE AS ScaleScore,
	LEFT(ca.ACHIEVEMENT_LEVEL, CHARINDEX('-', ca.ACHIEVEMENT_LEVEL) - 1) AS AchivementLevel,
	SUBSTRING(ca.ACHIEVEMENT_LEVEL, CHARINDEX('-', ca.ACHIEVEMENT_LEVEL) + 1, LEN(ca.ACHIEVEMENT_LEVEL) - CHARINDEX('-', ca.ACHIEVEMENT_LEVEL)) AS Achivement_Score,
	CASE
        WHEN CAST(SUBSTRING(ca.ACHIEVEMENT_LEVEL, CHARINDEX('-', ca.ACHIEVEMENT_LEVEL) + 1, LEN(ca.ACHIEVEMENT_LEVEL) - CHARINDEX('-', ca.ACHIEVEMENT_LEVEL)) AS DECIMAL(3,1)) BETWEEN 1.0 AND 2.1 THEN '1.0 - 2.1'
        WHEN CAST(SUBSTRING(ca.ACHIEVEMENT_LEVEL, CHARINDEX('-', ca.ACHIEVEMENT_LEVEL) + 1, LEN(ca.ACHIEVEMENT_LEVEL) - CHARINDEX('-', ca.ACHIEVEMENT_LEVEL)) AS DECIMAL(3,1)) BETWEEN 2.2 AND 2.8 THEN '2.2 - 2.8'
        WHEN CAST(SUBSTRING(ca.ACHIEVEMENT_LEVEL, CHARINDEX('-', ca.ACHIEVEMENT_LEVEL) + 1, LEN(ca.ACHIEVEMENT_LEVEL) - CHARINDEX('-', ca.ACHIEVEMENT_LEVEL)) AS DECIMAL(3,1)) BETWEEN 2.9 AND 3.1 THEN '2.9 - 3.1'
        WHEN CAST(SUBSTRING(ca.ACHIEVEMENT_LEVEL, CHARINDEX('-', ca.ACHIEVEMENT_LEVEL) + 1, LEN(ca.ACHIEVEMENT_LEVEL) - CHARINDEX('-', ca.ACHIEVEMENT_LEVEL)) AS DECIMAL(3,1)) BETWEEN 3.2 AND 3.4 THEN '3.2 - 3.4'
        WHEN CAST(SUBSTRING(ca.ACHIEVEMENT_LEVEL, CHARINDEX('-', ca.ACHIEVEMENT_LEVEL) + 1, LEN(ca.ACHIEVEMENT_LEVEL) - CHARINDEX('-', ca.ACHIEVEMENT_LEVEL)) AS DECIMAL(3,1)) BETWEEN 3.5 AND 3.7 THEN '3.5 - 3.7'
        WHEN CAST(SUBSTRING(ca.ACHIEVEMENT_LEVEL, CHARINDEX('-', ca.ACHIEVEMENT_LEVEL) + 1, LEN(ca.ACHIEVEMENT_LEVEL) - CHARINDEX('-', ca.ACHIEVEMENT_LEVEL)) AS DECIMAL(3,1)) BETWEEN 3.8 AND 4.0 THEN '3.8 - 4.0'
        WHEN CAST(SUBSTRING(ca.ACHIEVEMENT_LEVEL, CHARINDEX('-', ca.ACHIEVEMENT_LEVEL) + 1, LEN(ca.ACHIEVEMENT_LEVEL) - CHARINDEX('-', ca.ACHIEVEMENT_LEVEL)) AS DECIMAL(3,1)) BETWEEN 4.1 AND 4.2 THEN '4.1 - 4.2'
        WHEN CAST(SUBSTRING(ca.ACHIEVEMENT_LEVEL, CHARINDEX('-', ca.ACHIEVEMENT_LEVEL) + 1, LEN(ca.ACHIEVEMENT_LEVEL) - CHARINDEX('-', ca.ACHIEVEMENT_LEVEL)) AS DECIMAL(3,1)) >= 4.3 THEN '4.3+'
        ELSE NULL
    END AS CompositeScore,
	ca.SGP_LEVEL AS StudentGrowthPercentileLevel,
	ps.DistrictStudentId,
	'Access' AS assessmentcode,
	'ELL' AS Subject,
	ca.TenantId,
	ps.GAA,
	ps.[504status],
	ps.SpecialEdStatus,
	ps.disability,
	ps.Giftedandtalented,
	ps.EIP,
	ps.REIP,
	ps.Homeless,
	ps.ELL,
	ps.FRL,
	ps.IEP AS IEP,
	ps.Race AS Race,
	ps.SchoolCategory AS SchoolCategory,
	ps.Magnet AS Magnet
FROM main.clayton_Access ca 
LEFT JOIN clayton_studentprogram ps ON ca.GTID = ps.StateStudentId
	AND ca.schoolyear = ps.schoolyear
	AND ca.tenantid = ps.tenantid

--============================[Validation Script]============================

--============================[This is previous view]============================
--CREATE view [dbo].[Clayton_Access_AchivementLevel_Vw]
--as
--SELECT distinct
--    ca.REPORTED_SCH_YEAR AS SchoolYear,
--    ca.DISTRICT_NAME AS DistrictName,
--    ca.DISTRICT_NUMBER AS LeaIdentifer,
--    ca.SCHOOL_NAME AS SchoolName,
--    ca.SCHOOL_NUMBER AS SchoolIdentifier,
--    ca.GTID AS StateStudentID,
--    ca.LAST_NAME AS LastName,
--    ca.FIRST_NAME AS FirstName,
--    LAST_NAME + ' , ' + FIRST_NAME AS StudentFullName,
--    ca.BIRTH_DATE AS Dob,
--    CASE WHEN cai.Gender = 'M' THEN 'Male' 
--         WHEN cai.Gender = 'F' THEN 'Female' 
--         ELSE 'NotSelected' 
--    END AS Gender,
--    CASE WHEN ca.GRADE NOT IN ('10', '11', '12', 'PK', 'KK') 
--         THEN 'Grade ' + ca.GRADE 
--         ELSE 'Grade ' + ca.GRADE 
--    END AS Grade,
--    ca.SCALE_SCORE AS ScaleScore,
--    LEFT(ca.ACHIEVEMENT_LEVEL, CHARINDEX('-', ca.ACHIEVEMENT_LEVEL)-1) AS AchivementLevel,
--    SUBSTRING(ca.ACHIEVEMENT_LEVEL, CHARINDEX('-', ca.ACHIEVEMENT_LEVEL) + 1, LEN(ca.ACHIEVEMENT_LEVEL)-CHARINDEX('-', ca.ACHIEVEMENT_LEVEL)) AS Achivement_Score,
--	CASE
--        WHEN CAST(SUBSTRING(ca.ACHIEVEMENT_LEVEL, CHARINDEX('-', ca.ACHIEVEMENT_LEVEL) + 1, LEN(ca.ACHIEVEMENT_LEVEL) - CHARINDEX('-', ca.ACHIEVEMENT_LEVEL)) AS DECIMAL(3,1)) BETWEEN 1.0 AND 2.1 THEN '1.0 - 2.1'
--        WHEN CAST(SUBSTRING(ca.ACHIEVEMENT_LEVEL, CHARINDEX('-', ca.ACHIEVEMENT_LEVEL) + 1, LEN(ca.ACHIEVEMENT_LEVEL) - CHARINDEX('-', ca.ACHIEVEMENT_LEVEL)) AS DECIMAL(3,1)) BETWEEN 2.2 AND 2.8 THEN '2.2 - 2.8'
--        WHEN CAST(SUBSTRING(ca.ACHIEVEMENT_LEVEL, CHARINDEX('-', ca.ACHIEVEMENT_LEVEL) + 1, LEN(ca.ACHIEVEMENT_LEVEL) - CHARINDEX('-', ca.ACHIEVEMENT_LEVEL)) AS DECIMAL(3,1)) BETWEEN 2.9 AND 3.1 THEN '2.9 - 3.1'
--        WHEN CAST(SUBSTRING(ca.ACHIEVEMENT_LEVEL, CHARINDEX('-', ca.ACHIEVEMENT_LEVEL) + 1, LEN(ca.ACHIEVEMENT_LEVEL) - CHARINDEX('-', ca.ACHIEVEMENT_LEVEL)) AS DECIMAL(3,1)) BETWEEN 3.2 AND 3.4 THEN '3.2 - 3.4'
--        WHEN CAST(SUBSTRING(ca.ACHIEVEMENT_LEVEL, CHARINDEX('-', ca.ACHIEVEMENT_LEVEL) + 1, LEN(ca.ACHIEVEMENT_LEVEL) - CHARINDEX('-', ca.ACHIEVEMENT_LEVEL)) AS DECIMAL(3,1)) BETWEEN 3.5 AND 3.7 THEN '3.5 - 3.7'
--        WHEN CAST(SUBSTRING(ca.ACHIEVEMENT_LEVEL, CHARINDEX('-', ca.ACHIEVEMENT_LEVEL) + 1, LEN(ca.ACHIEVEMENT_LEVEL) - CHARINDEX('-', ca.ACHIEVEMENT_LEVEL)) AS DECIMAL(3,1)) BETWEEN 3.8 AND 4.0 THEN '3.8 - 4.0'
--        WHEN CAST(SUBSTRING(ca.ACHIEVEMENT_LEVEL, CHARINDEX('-', ca.ACHIEVEMENT_LEVEL) + 1, LEN(ca.ACHIEVEMENT_LEVEL) - CHARINDEX('-', ca.ACHIEVEMENT_LEVEL)) AS DECIMAL(3,1)) BETWEEN 4.1 AND 4.2 THEN '4.1 - 4.2'
--        WHEN CAST(SUBSTRING(ca.ACHIEVEMENT_LEVEL, CHARINDEX('-', ca.ACHIEVEMENT_LEVEL) + 1, LEN(ca.ACHIEVEMENT_LEVEL) - CHARINDEX('-', ca.ACHIEVEMENT_LEVEL)) AS DECIMAL(3,1)) >= 4.3 THEN '4.3+'
--        ELSE NULL
--    END AS CompositeScore,
--    ca.SGP_LEVEL AS StudentGrowthPercentileLevel,
--    cai.studentNumber AS DistrictStudentId,
--    'Access' AS assessmentcode,
--    'ELL' AS Subject,
--    ca.TenantId,
--    CASE WHEN ps.GAA = 'Y' THEN 'YES' ELSE 'NO' END AS GAA,
--    CASE WHEN ps.s504 = 'Y' THEN 'YES' ELSE 'NO' END AS [504status],
--    CASE WHEN ps.sped = 'Y' THEN 'YES' ELSE 'NO' END AS SpecialEdStatus,
--    ps.disability,
--    CASE WHEN ps.giftedstatus = 'Y' THEN 'YES' ELSE 'NO' END AS Giftedandtalented,
--    CASE WHEN ps.eip = 'Y' THEN 'YES' ELSE 'NO' END AS EIP,
--    CASE WHEN ps.remedialeducationeip = 'Y' THEN 'YES' ELSE 'NO' END AS REIP,
--    CASE WHEN ps.homeless = 'Y' THEN 'YES' ELSE 'NO' END AS Homeless,
--    CASE WHEN cai.ell = 'y' THEN 'YES' ELSE 'NO' END AS ELL,
--    CASE WHEN cai.frl = 'y' THEN 'Free Lunch' ELSE 'Full Price' END AS FRL,
--    NULL AS IEP,
--    CASE 
--        WHEN cai.raceethnicity IN ('H','4') THEN 'Hispanic'
--        WHEN cai.raceethnicity IN ('I','1') THEN 'American Indian'
--        WHEN cai.raceethnicity IN ('A','2') THEN 'Asian' 
--        WHEN cai.raceethnicity IN ('B','3') THEN 'Black' 
--        WHEN cai.raceethnicity IN ('W','5') THEN 'White' 
--        WHEN cai.raceethnicity IN ('P','6') THEN 'Pacific Islander' 
--        WHEN cai.raceethnicity IN ('O','7') THEN 'Two or More Races' 
--        WHEN cai.raceethnicity IN ('NS','8') THEN 'Not Selected' 
--    END AS RACE,
--    CASE 
--        WHEN ca.SCHOOL_NAME LIKE '%high%' THEN 'High'
--        WHEN ca.SCHOOL_NAME LIKE '%Middle%' THEN 'Middle'
--        WHEN ca.SCHOOL_NAME LIKE '%elementary%' THEN 'Elementary' 
--    END AS SchoolCategory,
--    CASE 
--        WHEN ps.magnet = 'Y' AND ps.MagnetSchoolType = 'Program Within School' THEN 'Program Within School'
--        WHEN ps.magnet = 'Y' AND ps.MagnetSchoolType = 'School-Wide Magnet' THEN 'School-Wide Magnet'
--        ELSE NULL 
--    END AS Magnet
--FROM 
--    main.clayton_Access ca
--JOIN 
--    main.Clayton_AnalyticVue_ICStudents cai 
--    ON ca.GTID = cai.stateID  
--    AND ca.tenantid = cai.tenantid
--JOIN 
--    main.clayton_analyticvue_ICprograms ps
--    ON cai.studentNumber = ps.studentnumber  
--    AND cai.schoolyear = ps.schoolyear 
--    AND cai.SchoolNumber = ps.Number
--    AND cai.tenantid = ps.tenantid;

--============================[This is current View]============================
--SELECT  ca.REPORTED_SCH_YEAR AS SchoolYear,
--	ps.leaname AS DistrictName,
--	ca.DISTRICT_NUMBER AS LeaIdentifer,
--	ca.SCHOOL_NAME AS SchoolName,
--	ps.SchoolIdentifier AS SchoolIdentifier,
--	ca.GTID AS StateStudentID,
--	ca.LAST_NAME AS LastName,
--	ca.FIRST_NAME AS FirstName,
--	ps.StudentFullName,
--	ca.BIRTH_DATE AS Dob,
--	ps.Gender,
--	ps.Grade,
--	ca.SCALE_SCORE AS ScaleScore,
--	LEFT(ca.ACHIEVEMENT_LEVEL, CHARINDEX('-', ca.ACHIEVEMENT_LEVEL) - 1) AS AchivementLevel,
--	SUBSTRING(ca.ACHIEVEMENT_LEVEL, CHARINDEX('-', ca.ACHIEVEMENT_LEVEL) + 1, LEN(ca.ACHIEVEMENT_LEVEL) - CHARINDEX('-', ca.ACHIEVEMENT_LEVEL)) AS Achivement_Score,
--	CASE
--        WHEN CAST(SUBSTRING(ca.ACHIEVEMENT_LEVEL, CHARINDEX('-', ca.ACHIEVEMENT_LEVEL) + 1, LEN(ca.ACHIEVEMENT_LEVEL) - CHARINDEX('-', ca.ACHIEVEMENT_LEVEL)) AS DECIMAL(3,1)) BETWEEN 1.0 AND 2.1 THEN '1.0 - 2.1'
--        WHEN CAST(SUBSTRING(ca.ACHIEVEMENT_LEVEL, CHARINDEX('-', ca.ACHIEVEMENT_LEVEL) + 1, LEN(ca.ACHIEVEMENT_LEVEL) - CHARINDEX('-', ca.ACHIEVEMENT_LEVEL)) AS DECIMAL(3,1)) BETWEEN 2.2 AND 2.8 THEN '2.2 - 2.8'
--        WHEN CAST(SUBSTRING(ca.ACHIEVEMENT_LEVEL, CHARINDEX('-', ca.ACHIEVEMENT_LEVEL) + 1, LEN(ca.ACHIEVEMENT_LEVEL) - CHARINDEX('-', ca.ACHIEVEMENT_LEVEL)) AS DECIMAL(3,1)) BETWEEN 2.9 AND 3.1 THEN '2.9 - 3.1'
--        WHEN CAST(SUBSTRING(ca.ACHIEVEMENT_LEVEL, CHARINDEX('-', ca.ACHIEVEMENT_LEVEL) + 1, LEN(ca.ACHIEVEMENT_LEVEL) - CHARINDEX('-', ca.ACHIEVEMENT_LEVEL)) AS DECIMAL(3,1)) BETWEEN 3.2 AND 3.4 THEN '3.2 - 3.4'
--        WHEN CAST(SUBSTRING(ca.ACHIEVEMENT_LEVEL, CHARINDEX('-', ca.ACHIEVEMENT_LEVEL) + 1, LEN(ca.ACHIEVEMENT_LEVEL) - CHARINDEX('-', ca.ACHIEVEMENT_LEVEL)) AS DECIMAL(3,1)) BETWEEN 3.5 AND 3.7 THEN '3.5 - 3.7'
--        WHEN CAST(SUBSTRING(ca.ACHIEVEMENT_LEVEL, CHARINDEX('-', ca.ACHIEVEMENT_LEVEL) + 1, LEN(ca.ACHIEVEMENT_LEVEL) - CHARINDEX('-', ca.ACHIEVEMENT_LEVEL)) AS DECIMAL(3,1)) BETWEEN 3.8 AND 4.0 THEN '3.8 - 4.0'
--        WHEN CAST(SUBSTRING(ca.ACHIEVEMENT_LEVEL, CHARINDEX('-', ca.ACHIEVEMENT_LEVEL) + 1, LEN(ca.ACHIEVEMENT_LEVEL) - CHARINDEX('-', ca.ACHIEVEMENT_LEVEL)) AS DECIMAL(3,1)) BETWEEN 4.1 AND 4.2 THEN '4.1 - 4.2'
--        WHEN CAST(SUBSTRING(ca.ACHIEVEMENT_LEVEL, CHARINDEX('-', ca.ACHIEVEMENT_LEVEL) + 1, LEN(ca.ACHIEVEMENT_LEVEL) - CHARINDEX('-', ca.ACHIEVEMENT_LEVEL)) AS DECIMAL(3,1)) >= 4.3 THEN '4.3+'
--        ELSE NULL
--    END AS CompositeScore,
--	ca.SGP_LEVEL AS StudentGrowthPercentileLevel,
--	ps.DistrictStudentId,
--	'Access' AS assessmentcode,
--	'ELL' AS Subject,
--	ca.TenantId,
--	ps.GAA,
--	ps.[504status],
--	ps.SpecialEdStatus,
--	ps.disability,
--	ps.Giftedandtalented,
--	ps.EIP,
--	ps.REIP,
--	ps.Homeless,
--	ps.ELL,
--	ps.FRL,
--	ps.IEP AS IEP,
--	ps.Race AS Race,
--	ps.SchoolCategory AS SchoolCategory,
--	ps.Magnet AS Magnet
--FROM main.clayton_Access ca 
--LEFT JOIN clayton_studentprogram ps ON ca.GTID = ps.StateStudentId
--	AND ca.schoolyear = ps.schoolyear
--	AND ca.tenantid = ps.tenantid

--============================[Previous Counts]============================
select * from Clayton_Access_AchivementLevel_Vw --6763
select  distinct StateStudentID  from Clayton_Access_AchivementLevel_Vw  --4316
select  schoolyear, count(distinct StateStudentID)  from Clayton_Access_AchivementLevel_Vw group by SchoolYear
--2022	2967
--2023	3792

--============================[Current Counts]============================
select * from #temp_test_access  --8598
select distinct StateStudentID from #temp_test_access  --5633
select  schoolyear, count(distinct StateStudentID) from #temp_test_access group by SchoolYear
--2022	3944
--2023	4654

--============================[Main table Counts]============================
select schoolyear, count(distinct GTID)  from main.Clayton_Access  group by SchoolYear
--2022	3944
--2023	4655

select distinct GTID from  main.Clayton_Access
except
select distinct StateStudentID from #temp_test_access  

select * from main.Clayton_Access where gtid = '9177562003'
select * from clayton_studentprogram where statestudentid = '9177562003'
select * from main.clayton_analyticvue_icstudents where stateid = '9177562003'

--One Student from main table in 2023 is 
--missing because he is not having any records in 
--icstudents or Clayton_studentprogram in 2023