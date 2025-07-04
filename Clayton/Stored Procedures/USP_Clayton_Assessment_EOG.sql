USE [AnalyticVue_Clayton]
GO

/****** Object:  StoredProcedure [dbo].[USP_Clayton_Assessment_EOG]    Script Date: 03-07-2025 18:54:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Clayton_Assessment_EOG]
(
	@SchoolYear VARCHAR(50)
)
AS
BEGIN

    /**Disabling All Indexes**/

	EXEC [dbo].[USP_DisableAllIndexes] 'Clayton_Assessment_EOG'

	EXEC [dbo].[USP_DisableAllIndexes] 'Main.Clayton_EOG'
	
	EXEC [dbo].[USP_DisableAllIndexes] 'main.Clayton_AnalyticVue_ICStudents'

    --alter table Clayton_Assessment_EOG add [TestTakenDate] date

	DELETE FROM Clayton_Assessment_EOG WHERE schoolYear = @SchoolYear

    /*insert info*/
    INSERT INTO dbo.Clayton_Assessment_EOG
    (
        [LEAIdentifier],
        [activeEnrollment],
        [activeYear],
        [activeCalendarIDs],
        /*ID'S*/
        [personID],
        [personIDMasked],
        [GTID],
        [GTIDMasked],
        [SchoolIdentifier],
        [stateSchoolID],
        /*school info*/
        [schoolName],
        [schoolNameShort],
        [schoolLevel],
        [region],
        [cluster],
        /*student info*/
        [studentNumber],
        [studentNumberMasked],
        [lastName],
        [firstName],
        [firstInitial],
        [middleName],
        [middleInitial],
        [alias],
        [studentNameWithID],
        [studentFullName],
        [DOB],
        [gender],
        [genderLong],
        [raceEthnicity],
        [raceEthnicityShort],
        [ELLIndicator],
        [giftedIndicator],
        [MTSSIndicator],
        [MTSSLevel],
        [EIPRemedialIndicator],
        [remedialIndicator],
        [SWDIndicator],
        [disability1],
        [s504Indicator],
        [cohortYear],
        [estimatedCohortYear],
        [grade9Date],
        /*enrollment info*/
        [calendarID],
        [calendarName],
        [calendarStateExclude],
        [gradeLevel],
        [GradeDescription],
        [serviceType],
        [enrollmentStartDate],
        [enrollmentStartStatus],
        [enrollmentStartStatusDesc],
        [enrollmentEndDate],
        [enrollmentEndStatus],
        [enrollmentEndStatusDesc],
        [dropOut],
        [startYear],
        [endYear],
        [schoolYear],
        [summerSchoolFlag],
        /*fte school info*/
        [calendarID_FTE1_SOR],
        [schoolName_FTE1_SOR],
        [calendarID_FTE3_SOR],
        [schoolName_FTE3_SOR],
        [inFTE1Count],
        [inFTE3Count],
        /*GMAS EOG Assessment info*/
        [testSchoolCode],
        [testSchoolName],
        [testType],
        [SS],
        [achLvl],
        [achLevelLong],
        [condSem],
        [condSem_H],
        [condSem_L],
        [lexile],
        [lexileL],
        [lexile_L],
        [lexile_H],
        [AboveLexile],
        [OnLexile],
        [BelowLexile],
        [LexileStretchBand],
        [reading_Status],
        [ReadingStatusIndicatorDescription],
        [StretchBand],
        [testAdmin],
        [testDate],
        [MasteryCategoryDom1],
        [MasteryCategoryDom2],
        [MasteryCategoryDom3],
        [MasteryCategoryDom4],
        [MasteryCategoryDom5],
        [MasteryCategoryDom6],
        [MasteryCategoryDom7],
        [MasteryCategoryDom8],
        [MasteryCategoryDom9],
        [MasteryCategoryDom10],
        [MasteryCategoryDom11],
        [MasteryCategoryDom1Description],
        [MasteryCategoryDom2Description],
        [MasteryCategoryDom3Description],
        [MasteryCategoryDom4Description],
        [MasteryCategoryDom5Description],
        [MasteryCategoryDom6Description],
        [MasteryCategoryDom7Description],
        [MasteryCategoryDom8Description],
        [MasteryCategoryDom9Description],
        [MasteryCategoryDom10Description],
        [MasteryCategoryDom11Description],
        [DomainName1],
        [DomainName2],
        [DomainName3],
        [DomainName4],
        [DomainName5],
        [DomainName6],
        [DomainName7],
        [DomainName8],
        [DomainName9],
        [DomainName10],
        [DomainName11],
        [AchCategoryDom1],
        [AchCategoryDom2],
        [AchCategoryDom3],
        [AchCategoryDom4],
        [AchCategoryDom5],
        [AchCategoryDom6],
        [AchCategoryDom7],
        [AchCategoryDom8],
        [AchCategoryDom9],
        [AchCategoryDom10],
        [AchCategoryDom1Description],
        [AchCategoryDom2Description],
        [AchCategoryDom3Description],
        [AchCategoryDom4Description],
        [AchCategoryDom5Description],
        [AchCategoryDom6Description],
        [AchCategoryDom7Description],
        [AchCategoryDom8Description],
        [AchCategoryDom9Description],
        [AchCategoryDom10Description],
        TenantId
    )
    SELECT DISTINCT
        /*active enrollment*/
        '631' LEAIdentifier,
        NULL AS [activeEnrollment],
        NULL AS [activeYear],
        NULL AS [activeCalendarIDs],
        /*ID'S*/
        personID AS [personID],
        NULL [personIDMasked],
        E.GTID_RPT AS [GTID],
        NULL [GTIDMasked],
        [testSchoolCode] AS [SchoolIdentifier],
        [testSchoolCode] AS [stateSchoolID],
        /*school info*/
        k.NameofInstitution AS [schoolName],
        NULL AS [schoolNameShort],
        NULL AS [schoolLevel],
        NULL AS [region],
        NULL AS [cluster],
        /*student info*/
        s.studentnumber AS [studentNumber],
        NULL [studentNumberMasked],
        e.[lastName] AS [lastName],
        e.[firstName] AS [firstName],
        NULL [firstInitial],
        NULL AS [middleName],
        NULL AS [middleInitial],
        NULL AS [alias],
        NULL AS [studentNameWithID],
        e.lastName + ' ,' + e.firstName AS [studentFullName],
        e.DOB AS [DOB],
        e.Gender AS [gender],
		CASE
            WHEN E.GENDER = 'F' THEN 'Female'
            WHEN E.GENDER = 'M' THEN 'Male'
            ELSE 'Not Selected'
        End AS [genderLong],
        NULL AS [raceEthnicity],
        NULL AS [raceEthnicityShort],
        CASE
            WHEN e.EL_RPT = '1' THEN 'Yes'
            ELSE 'No'
        End AS [ELLIndicator],
        NULL AS [giftedIndicator],
        NULL AS MTSSIndicator,
        NULL AS MTSSLevel,
        NULL AS EIPRemedialIndicator,
        NULL remedialIndicator,
        NULL AS [SWDIndicator],
        NULL AS [disability1],
        NULL AS s504Indicator,
        NULL AS [cohortYear],
        NULL AS [estimatedCohortYear],
        NULL AS [grade9Date],
        /*enrollment info*/
        NULL AS [calendarID],
        NULL AS [calendarName],
        NULL AS [calendarStateExclude],
        rg.GradeCode AS [gradeLevel],
        rg.[GradeDescription],
        NULL AS [serviceType],
        NULL AS [enrollmentStartDate],
        NULL AS [enrollmentStartStatus],
        NULL AS [enrollmentStartStatusDesc],
        NULL AS [enrollmentEndDate],
        NULL AS [enrollmentEndStatus],
        NULL AS [enrollmentEndStatusDesc],
        NULL AS [dropOut],
        NULL AS [startYear],
        e.[SchoolYear] AS [endYear],
        e.[SchoolYear] AS [SchoolYear],
        NULL AS [summerSchoolFlag],
        /*fte info*/
        NULL AS [calendarID_FTE1_SOR],
        NULL AS [schoolName_FTE1_SOR],
        NULL AS [calendarID_FTE3_SOR],
        NULL AS [schoolName_FTE3_SOR],
        NULL AS [inFTE1Count],
        NULL AS [inFTE3Count],
        /*GMAS EOG Assessment info*/
        e.[testSchoolCode] as [testSchoolCode],
        e.[testSchoolName] as [testSchoolName],
        e.[Subject] as [testType],
        e.[SS],
        e.ACHLevel [achLvl],
        ra.ACHLevelDescription [achLevelLong],
        CondSEM [condSem],
        CondSEMHigh [condSem_H],
        e.CondSEMLow [condSem_L],
        [lexile],
        e.[lexileL],
        e.[LexileLow],
        e.[LexileHigh],
		CASE
            WHEN CAST(E.[LEXILE] AS INT) > CAST(RL.[HIGHRANGENUMERIC] AS INT) THEN 'YES'
            WHEN CAST(E.[LEXILE] AS INT) IS NULL THEN NULL
            ELSE 'NO'
        END [ABOVELEXILE],
        CASE
            WHEN CAST(E.[LEXILE] AS INT) BETWEEN CAST(RL.[LOWRANGENUMERIC] AS INT) AND CAST(RL.[HIGHRANGENUMERIC] AS INT) THEN 'YES'
            WHEN CAST(E.[LEXILE] AS INT) IS NULL THEN NULL
            ELSE 'NO'
        END [ONLEXILE],
        CASE
            WHEN CAST(E.[LEXILE] AS INT) < CAST(RL.[LOWRANGENUMERIC] AS INT) THEN 'YES'
            WHEN CAST(E.[LEXILE] AS INT) IS NULL THEN NULL
            ELSE 'NO'
        END [BELOWLEXILE],
        CASE
            WHEN CAST(E.[LEXILE] AS INT) <= -400 THEN 'BR400 and above'
            WHEN CAST(E.[LEXILE] AS INT) = 0 THEN '0L'
            WHEN CAST(E.[LEXILE] AS INT) >= 1900 THEN '1900L and above'
            WHEN CAST(E.[LEXILE] AS INT) IS NULL THEN NULL
            WHEN SIGN(CAST(E.[LEXILE] AS INT)) = -1 THEN
                REPLACE(
                           'BR' + CAST(ROUND(CAST(E.[LEXILE] AS INT), -2, 1) - 99 AS VARCHAR) + ' - BR'
                           + CAST(ROUND(CAST(E.[LEXILE] AS INT), -2, 1) AS VARCHAR),
                           'BR-99 - BR0',
                           'BR99 - BR1'
                       )
            WHEN SIGN(CAST(E.[LEXILE] AS INT)) = 1 THEN
                REPLACE(
                           CAST(ROUND(CAST(E.[LEXILE] AS INT), -2, 1) AS VARCHAR) + 'L - '
                           + CAST(ROUND(CAST(E.[LEXILE] AS INT), -2, 1) + 99 AS VARCHAR) + 'L',
                           '0L - 99L',
                           '1L - 99L'
                       )
        END [LEXILESTRETCHBAND],
        [READING_STATUS],
        CASE
            WHEN CAST(E.[READING_STATUS] AS INT) = 1 THEN 'Reading Below Grade Level'
            WHEN CAST(E.[READING_STATUS] AS INT) = 2 THEN 'Reading At or Above Grade Level'
        END [READINGSTATUSINDICATORDESCRIPTION],
		[StretchBand],
        e.[testAdmin],
        e.[testDate],
        e.[MasteryCategoryDom1],
        e.[MasteryCategoryDom2],
        e.[MasteryCategoryDom3],
        e.[MasteryCategoryDom4],
        e.[MasteryCategoryDom5],
        e.[MasteryCategoryDom6],
        e.[MasteryCategoryDom7],
        e.[MasteryCategoryDom8],
        e.[MasteryCategoryDom9],
        NULL AS [MasteryCategoryDom10],
        NULL AS [MasteryCategoryDom11],
        d1.CatergoryDomainDescEOGDescription AS [MasteryCategoryDom1Description],
        d2.CatergoryDomainDescEOGDescription AS [MasteryCategoryDom2Description],
        d3.CatergoryDomainDescEOGDescription AS [MasteryCategoryDom3Description],
        d4.CatergoryDomainDescEOGDescription AS [MasteryCategoryDom4Description],
        d5.CatergoryDomainDescEOGDescription AS [MasteryCategoryDom5Description],
        d6.CatergoryDomainDescEOGDescription AS [MasteryCategoryDom6Description],
        d7.CatergoryDomainDescEOGDescription AS [MasteryCategoryDom7Description],
        d8.CatergoryDomainDescEOGDescription AS [MasteryCategoryDom8Description],
        d9.CatergoryDomainDescEOGDescription AS [MasteryCategoryDom9Description],
        NULL AS [MasteryCategoryDom10Description],
        NULL AS [MasteryCategoryDom11Description],
        NULL AS [DomainName1],
        NULL AS [DomainName2],
        NULL AS [DomainName3],
        NULL AS [DomainName4],
        NULL AS [DomainName5],
        NULL AS [DomainName6],
        NULL AS [DomainName7],
        NULL AS [DomainName8],
        NULL AS [DomainName9],
        NULL AS [DomainName10],
        NULL AS [DomainName11],
        e.[AchCategoryDom1],
        e.[AchCategoryDom2],
        e.[AchCategoryDom3],
        e.[AchCategoryDom4],
        e.[AchCategoryDom5],
        e.[AchCategoryDom6],
        e.[AchCategoryDom7],
        e.[AchCategoryDom8],
        e.[AchCategoryDom9],
        e.[AchCategoryDom10],
        da1.ACHLevelDescription AS [AchCategoryDom1Description],
        da2.ACHLevelDescription AS [AchCategoryDom2Description],
        da3.ACHLevelDescription AS [AchCategoryDom3Description],
        da4.ACHLevelDescription AS [AchCategoryDom4Description],
        da5.ACHLevelDescription AS [AchCategoryDom5Description],
        da6.ACHLevelDescription AS [AchCategoryDom6Description],
        da7.ACHLevelDescription AS [AchCategoryDom7Description],
        da8.ACHLevelDescription AS [AchCategoryDom8Description],
        da9.ACHLevelDescription AS [AchCategoryDom9Description],
        da10.ACHLevelDescription AS [AchCategoryDom10Description],
        e.TenantId
    FROM
    (
	SELECT *
        FROM
        (
            SELECT GTID_RPT,
                   TESTSCHOOLCODE,
                   TESTSCHOOLNAME,
                   LEXILE,
                   LEXILEL,
                   LEXILELOW,
                   LEXILEHIGH,
                   READING_STATUS,
                   STRETCHBAND,
                   TESTADMIN,
                   TESTDATE,
                   TESTEDGRADE,
                   SCHOOLYEAR,
                   TENANTID,
                   ASSMNT_SCI,
                   COL,
                   LASTNAME,
                   FIRSTNAME,
                   GENDER,
                   STUDENTID_DRCUSE,
                   DOB,
                   ETHNICITYRACE_RPT,
                   CASE
                       WHEN ASSMNT_SCI = 1
                            AND [Subject] = 'Sci' THEN
                           'Sci'
                       WHEN ASSMNT_SCI = 2
                            AND [Subject] = 'Sci' THEN
                           'HS Phys Sci'
                       WHEN [Subject] = 'Soc' THEN
                           'Soc'
                       WHEN [Subject] = 'Math' THEN
                           'Math'
                       WHEN [Subject] = 'ELA' THEN
                           'ELA'
                       ELSE
                           NULL
                   END [Subject],
                   [Value],
                   EL_RPT
            FROM
            (
                SELECT GTID_RPT,
                       SCHCODE_RPT AS [testSchoolCode],
                       SCHNAME_RPT AS [testSchoolName],
                       [Lexile],
                       [lexileL],
                       [LexileLow],
                       [LexileHigh],
                       TESTEDGRADE_RPT AS TESTEDGRADE,
                       READINGSTATUS [reading_Status],
                       [StretchBand] [StretchBand],
                       [testAdmin],
                       STULASTNAME_RPT AS LASTNAME,
                       STUFIRSTNAME_RPT AS FIRSTNAME,
                       STUGENDER_RPT AS GENDER,
                       STUDENTID_DRCUSE,
                       STUDOBMONTH_RPT + '/' + STUDOBDAY_RPT + '/' + STUDOBYEAR_RPT AS DOB,
                       ETHNICITYRACE_RPT,
                       [testDate],
                       SCHOOLYEAR,
                       TENANTID,
                       ASSMNT_SCI,
                       LEFT([Col], Charindex('_', [Col]) - 1) [Col],
                       RIGHT([Col], Len([Col]) - Charindex('_', [Col])) [Subject],
                       Cast([Value] AS INT) [Value],
                       EL_RPT
                FROM [Main].[Clayton_EOG] UNPIVOT([Value] FOR [Col] IN([SS_ELA], [SS_Math], [SS_Sci], [SS_Soc], ACHLEVEL_ELA, ACHLEVEL_MATH, ACHLEVEL_SCI, ACHLEVEL_SOC, CONDSEM_ELA, CONDSEM_MATH, CONDSEM_SCI, CONDSEM_SOC, CONDSEMHIGH_ELA, CONDSEMHIGH_MATH, CONDSEMHIGH_SCI, CONDSEMHIGH_SOC, CONDSEMLOW_ELA, CONDSEMLOW_MATH, CONDSEMLOW_SCI, CONDSEMLOW_SOC, [MasteryCategoryDom1_ELA], [MasteryCategoryDom2_ELA], [MasteryCategoryDom3_ELA], [MasteryCategoryDom4_ELA], [MasteryCategoryDom5_ELA], [MasteryCategoryDom6_ELA], [MasteryCategoryDom7_ELA], [MasteryCategoryDom8_ELA], [MasteryCategoryDom9_ELA], [MasteryCategoryDom1_Math], [MasteryCategoryDom2_Math], [MasteryCategoryDom3_Math], [MasteryCategoryDom4_Math], [MasteryCategoryDom5_Math], [MasteryCategoryDom6_Math], [MasteryCategoryDom7_Math], [MasteryCategoryDom8_Math], [MasteryCategoryDom1_Sci], [MasteryCategoryDom2_Sci], [MasteryCategoryDom3_Sci], [MasteryCategoryDom4_Sci], [MasteryCategoryDom5_Sci], [MasteryCategoryDom6_Sci], [MasteryCategoryDom7_Sci], [MasteryCategoryDom8_Sci], [MasteryCategoryDom1_Soc], [MasteryCategoryDom2_Soc], [MasteryCategoryDom3_Soc], [MasteryCategoryDom4_Soc], [MasteryCategoryDom5_Soc], [MasteryCategoryDom6_Soc], [MasteryCategoryDom7_Soc], [MasteryCategoryDom8_Soc], [AchCategoryDom1_ELA], [AchCategoryDom2_ELA], [AchCategoryDom3_ELA], [AchCategoryDom4_ELA], [AchCategoryDom5_ELA], [AchCategoryDom6_ELA], [AchCategoryDom7_ELA], [AchCategoryDom8_ELA], [AchCategoryDom9_ELA], [AchCategoryDom1_Math], [AchCategoryDom2_Math], [AchCategoryDom3_Math], [AchCategoryDom4_Math], [AchCategoryDom5_Math], [AchCategoryDom6_Math], [AchCategoryDom7_Math], [AchCategoryDom8_Math], [AchCategoryDom9_Math], [AchCategoryDom10_Math], [AchCategoryDom1_Sci], [AchCategoryDom2_Sci], [AchCategoryDom3_Sci], [AchCategoryDom4_Sci], [AchCategoryDom5_Sci], [AchCategoryDom6_Sci], [AchCategoryDom7_Sci], [AchCategoryDom8_Sci], [AchCategoryDom1_Soc], [AchCategoryDom2_Soc], [AchCategoryDom3_Soc], [AchCategoryDom4_Soc], [AchCategoryDom5_Soc], [AchCategoryDom6_Soc], [AchCategoryDom7_Soc], [AchCategoryDom8_Soc])
				)U 
				WHERE SchoolYear = @SchoolYear
            ) O
            WHERE [Subject] IN ( 'Soc', 'Math', 'ELA' )
                  OR (
                         [Subject] = 'Sci'
                         AND ASSMNT_SCI IN ( 1, 2 )
                     )
        ) AS T
        PIVOT
        (
            Avg(VALUE)
            FOR [Col] IN ([SS], [ACHLevel], [CondSEM], [CondSEMHigh], [CondSEMLow], [MasteryCategoryDom1],
                          [MasteryCategoryDom2], [MasteryCategoryDom3], [MasteryCategoryDom4], [MasteryCategoryDom5],
                          [MasteryCategoryDom6], [MasteryCategoryDom7], [MasteryCategoryDom8], [MasteryCategoryDom9],
                          [AchCategoryDom1], [AchCategoryDom2], [AchCategoryDom3], [AchCategoryDom4],
                          [AchCategoryDom5], [AchCategoryDom6], [AchCategoryDom7], [AchCategoryDom8],
                          [AchCategoryDom9], [AchCategoryDom10]
                         )
        ) P
    ) E
        LEFT JOIN [dbo].[RefGrade] RG
            ON E.TESTEDGRADE = RG.GRADECODE
               AND E.TENANTID = RG.TENANTID
        INNER JOIN MAIN.CLAYTON_ANALYTICVUE_ICSTUDENTS AS S
            ON E.GTID_RPT = S.STATEID
               AND E.SCHOOLYEAR = S.SCHOOLYEAR
        INNER JOIN MAIN.K12SCHOOL AS K
            ON E.TESTSCHOOLCODE = K.SCHOOLIDENTIFIER
               AND E.SCHOOLYEAR = K.SCHOOLYEAR
        INNER JOIN [RefACHLevel] RA
            ON ISNULL(NULLIF(CAST(E.ACHLEVEL AS VARCHAR), ''), 'N/A') = RA.ACHLEVELCODE
               AND RA.TENANTID = E.TENANTID
        INNER JOIN [RefMasteryCatergoryDomainDescription_EOG] D1
            ON ISNULL(NULLIF(CAST(E.MASTERYCATEGORYDOM1 AS VARCHAR), ''), 'N/A') = D1.CATERGORYDOMAINDESCEOGCODE
               AND D1.TENANTID = E.TENANTID
        INNER JOIN [RefMasteryCatergoryDomainDescription_EOG] D2
            ON ISNULL(NULLIF(CAST(E.MASTERYCATEGORYDOM2 AS VARCHAR), ''), 'N/A') = D2.CATERGORYDOMAINDESCEOGCODE
               AND D2.TENANTID = E.TENANTID
        INNER JOIN [RefMasteryCatergoryDomainDescription_EOG] D3
            ON ISNULL(NULLIF(CAST(E.MASTERYCATEGORYDOM3 AS VARCHAR), ''), 'N/A') = D3.CATERGORYDOMAINDESCEOGCODE
               AND D3.TENANTID = E.TENANTID
        INNER JOIN [RefMasteryCatergoryDomainDescription_EOG] D4
            ON ISNULL(NULLIF(CAST(E.MASTERYCATEGORYDOM4 AS VARCHAR), ''), 'N/A') = D4.CATERGORYDOMAINDESCEOGCODE
               AND D4.TENANTID = E.TENANTID
        INNER JOIN [RefMasteryCatergoryDomainDescription_EOG] D5
            ON ISNULL(NULLIF(CAST(E.MASTERYCATEGORYDOM5 AS VARCHAR), ''), 'N/A') = D5.CATERGORYDOMAINDESCEOGCODE
               AND D5.TENANTID = E.TENANTID
        INNER JOIN [RefMasteryCatergoryDomainDescription_EOG] D6
            ON ISNULL(NULLIF(CAST(E.MASTERYCATEGORYDOM6 AS VARCHAR), ''), 'N/A') = D6.CATERGORYDOMAINDESCEOGCODE
               AND D6.TENANTID = E.TENANTID
        INNER JOIN [RefMasteryCatergoryDomainDescription_EOG] D7
            ON ISNULL(NULLIF(CAST(E.MASTERYCATEGORYDOM7 AS VARCHAR), ''), 'N/A') = D7.CATERGORYDOMAINDESCEOGCODE
               AND D7.TENANTID = E.TENANTID
        INNER JOIN [RefMasteryCatergoryDomainDescription_EOG] D8
            ON ISNULL(NULLIF(CAST(E.MASTERYCATEGORYDOM8 AS VARCHAR), ''), 'N/A') = D8.CATERGORYDOMAINDESCEOGCODE
               AND D8.TENANTID = E.TENANTID
        INNER JOIN [RefMasteryCatergoryDomainDescription_EOG] D9
            ON ISNULL(NULLIF(CAST(E.MASTERYCATEGORYDOM9 AS VARCHAR), ''), 'N/A') = D9.CATERGORYDOMAINDESCEOGCODE
               AND D9.TENANTID = E.TENANTID
        INNER JOIN [RefACHLevel] DA1
            ON ISNULL(NULLIF(CAST(E.ACHCATEGORYDOM1 AS VARCHAR), ''), 'N/A') = DA1.ACHLEVELCODE
               AND DA1.TENANTID = E.TENANTID
        INNER JOIN [RefACHLevel] DA2
            ON ISNULL(NULLIF(CAST(E.ACHCATEGORYDOM2 AS VARCHAR), ''), 'N/A') = DA2.ACHLEVELCODE
               AND DA2.TENANTID = E.TENANTID
        INNER JOIN [RefACHLevel] DA3
            ON ISNULL(NULLIF(CAST(E.ACHCATEGORYDOM3 AS VARCHAR), ''), 'N/A') = DA3.ACHLEVELCODE
               AND DA3.TENANTID = E.TENANTID
        INNER JOIN [RefACHLevel] DA4
            ON ISNULL(NULLIF(CAST(E.ACHCATEGORYDOM4 AS VARCHAR), ''), 'N/A') = DA4.ACHLEVELCODE
               AND DA4.TENANTID = E.TENANTID
        INNER JOIN [RefACHLevel] DA5
            ON ISNULL(NULLIF(CAST(E.ACHCATEGORYDOM5 AS VARCHAR), ''), 'N/A') = DA5.ACHLEVELCODE
               AND DA5.TENANTID = E.TENANTID
        INNER JOIN [RefACHLevel] DA6
            ON ISNULL(NULLIF(CAST(E.ACHCATEGORYDOM6 AS VARCHAR), ''), 'N/A') = DA6.ACHLEVELCODE
               AND DA6.TENANTID = E.TENANTID
        INNER JOIN [RefACHLevel] DA7
            ON ISNULL(NULLIF(CAST(E.ACHCATEGORYDOM7 AS VARCHAR), ''), 'N/A') = DA7.ACHLEVELCODE
               AND DA7.TENANTID = E.TENANTID
        INNER JOIN [RefACHLevel] DA8
            ON ISNULL(NULLIF(CAST(E.ACHCATEGORYDOM8 AS VARCHAR), ''), 'N/A') = DA8.ACHLEVELCODE
               AND DA8.TENANTID = E.TENANTID
        INNER JOIN [RefACHLevel] DA9
            ON ISNULL(NULLIF(CAST(E.ACHCATEGORYDOM9 AS VARCHAR), ''), 'N/A') = DA9.ACHLEVELCODE
               AND DA9.TENANTID = E.TENANTID
        INNER JOIN [RefACHLevel] DA10
            ON ISNULL(NULLIF(CAST(E.ACHCATEGORYDOM10 AS VARCHAR), ''), 'N/A') = DA10.ACHLEVELCODE
               AND DA10.TENANTID = E.TENANTID
        LEFT JOIN
        (
            SELECT *
            FROM CLAYTON_REFERENCE_LEXILE_CHART_EOC_EOG
            WHERE MEANING = 'At Grade Level'
        ) RL
            ON RL.GRADELEVEL = E.TESTEDGRADE
               AND (CAST(E.SCHOOLYEAR AS INT)
               BETWEEN CAST(RL.YEARSTART AS INT) AND CAST(RL.YEAREND AS INT)
                   )
    WHERE 1=1

--=====================================
UPDATE A
    SET A.domainname1 = B.catergorydomainnameeogcode
    FROM DBO.clayton_assessment_eog A
        JOIN [refmasterycatergorydomainname_eog] B
            ON A.[testtype] = CASE
                                  WHEN B.contentarea = 'English Language Arts' THEN 'ELA'
                                  WHEN B.contentarea = 'Mathematics' THEN 'Math'
                                  WHEN B.contentarea = 'Science' THEN 'Sci'
                                  WHEN B.contentarea = 'Social Studies' THEN 'Soc'
                                  WHEN B.contentarea = 'HS Physical Science' THEN 'HS Phys Sci'
                              END
               AND Charindex(A.gradelevel, B.gradelevel) <> 0
               AND A.tenantid = B.tenantid
               AND B.masterycategorydomainnumber = 1
	WHERE a.schoolYear = @SchoolYear

--=====================================			   
	UPDATE A
    SET A.domainname2 = B.catergorydomainnameeogcode
    FROM DBO.clayton_assessment_eog A
        JOIN [refmasterycatergorydomainname_eog] B
            ON A.[testtype] = CASE
                                  WHEN B.contentarea = 'English Language Arts' THEN 'ELA'
                                  WHEN B.contentarea = 'Mathematics' THEN 'Math'
                                  WHEN B.contentarea = 'Science' THEN 'Sci'
                                  WHEN B.contentarea = 'Social Studies' THEN 'Soc'
                                  WHEN B.contentarea = 'HS Physical Science' THEN 'HS Phys Sci'
                              END
               AND Charindex(A.gradelevel, B.gradelevel) <> 0
               AND A.tenantid = B.tenantid
               AND B.masterycategorydomainnumber = 2
	WHERE a.schoolYear = @SchoolYear

--=====================================
	UPDATE A
    SET A.domainname3 = B.catergorydomainnameeogcode
    FROM DBO.clayton_assessment_eog A
        JOIN [refmasterycatergorydomainname_eog] B
            ON A.[testtype] = CASE
                                  WHEN B.contentarea = 'English Language Arts' THEN 'ELA'
                                  WHEN B.contentarea = 'Mathematics' THEN 'Math'
                                  WHEN B.contentarea = 'Science' THEN 'Sci'
                                  WHEN B.contentarea = 'Social Studies' THEN 'Soc'
                                  WHEN B.contentarea = 'HS Physical Science' THEN 'HS Phys Sci'
                              END
               AND Charindex(A.gradelevel, B.gradelevel) <> 0
               AND A.tenantid = B.tenantid
               AND B.masterycategorydomainnumber = 3
	WHERE a.schoolYear = @SchoolYear

--=====================================			   
	UPDATE A
    SET A.domainname4 = B.catergorydomainnameeogcode
    FROM DBO.clayton_assessment_eog A
        JOIN [refmasterycatergorydomainname_eog] B
            ON A.[testtype] = CASE
                                  WHEN B.contentarea = 'English Language Arts' THEN 'ELA'
                                  WHEN B.contentarea = 'Mathematics' THEN 'Math'
                                  WHEN B.contentarea = 'Science' THEN 'Sci'
                                  WHEN B.contentarea = 'Social Studies' THEN 'Soc'
                                  WHEN B.contentarea = 'HS Physical Science' THEN 'HS Phys Sci'
                              END
               AND Charindex(A.gradelevel, B.gradelevel) <> 0
               AND A.tenantid = B.tenantid
               AND B.masterycategorydomainnumber = 4  
	WHERE a.schoolYear = @SchoolYear

--=====================================
	UPDATE A
    SET A.domainname5 = B.catergorydomainnameeogcode
    FROM DBO.clayton_assessment_eog A
        JOIN [refmasterycatergorydomainname_eog] B
            ON A.[testtype] = CASE
                                  WHEN B.contentarea = 'English Language Arts' THEN 'ELA'
                                  WHEN B.contentarea = 'Mathematics' THEN 'Math'
                                  WHEN B.contentarea = 'Science' THEN 'Sci'
                                  WHEN B.contentarea = 'Social Studies' THEN 'Soc'
                                  WHEN B.contentarea = 'HS Physical Science' THEN 'HS Phys Sci'
                              END
               AND Charindex(A.gradelevel, B.gradelevel) <> 0
               AND A.tenantid = B.tenantid
               AND B.masterycategorydomainnumber = 5
	WHERE a.schoolYear = @SchoolYear

--=====================================			   
	UPDATE A
    SET A.domainname6 = B.catergorydomainnameeogcode
    FROM DBO.clayton_assessment_eog A
        JOIN [refmasterycatergorydomainname_eog] B
            ON A.[testtype] = CASE
                                  WHEN B.contentarea = 'English Language Arts' THEN 'ELA'
                                  WHEN B.contentarea = 'Mathematics' THEN 'Math'
                                  WHEN B.contentarea = 'Science' THEN 'Sci'
                                  WHEN B.contentarea = 'Social Studies' THEN 'Soc'
                                  WHEN B.contentarea = 'HS Physical Science' THEN 'HS Phys Sci'
                              END
               AND Charindex(A.gradelevel, B.gradelevel) <> 0
               AND A.tenantid = B.tenantid
               AND B.masterycategorydomainnumber = 6
	WHERE a.schoolYear = @SchoolYear

--=====================================
	UPDATE A
    SET A.domainname7 = B.catergorydomainnameeogcode
    FROM DBO.clayton_assessment_eog A
        JOIN [refmasterycatergorydomainname_eog] B
            ON A.[testtype] = CASE
                                  WHEN B.contentarea = 'English Language Arts' THEN 'ELA'
                                  WHEN B.contentarea = 'Mathematics' THEN 'Math'
                                  WHEN B.contentarea = 'Science' THEN 'Sci'
                                  WHEN B.contentarea = 'Social Studies' THEN 'Soc'
                                  WHEN B.contentarea = 'HS Physical Science' THEN 'HS Phys Sci'
                              END
               AND Charindex(A.gradelevel, B.gradelevel) <> 0
               AND A.tenantid = B.tenantid
               AND B.masterycategorydomainnumber = 7
	WHERE a.schoolYear = @SchoolYear

--=====================================			   
	UPDATE A
    SET A.domainname8 = B.catergorydomainnameeogcode
    FROM DBO.clayton_assessment_eog A
        JOIN [refmasterycatergorydomainname_eog] B
            ON A.[testtype] = CASE
                                  WHEN B.contentarea = 'English Language Arts' THEN 'ELA'
                                  WHEN B.contentarea = 'Mathematics' THEN 'Math'
                                  WHEN B.contentarea = 'Science' THEN 'Sci'
                                  WHEN B.contentarea = 'Social Studies' THEN 'Soc'
                                  WHEN B.contentarea = 'HS Physical Science' THEN 'HS Phys Sci'
                              END
               AND Charindex(A.gradelevel, B.gradelevel) <> 0
               AND A.tenantid = B.tenantid
               AND B.masterycategorydomainnumber = 8
	WHERE a.schoolYear = @SchoolYear

--=====================================
	UPDATE A
    SET A.domainname9 = B.catergorydomainnameeogcode
    FROM DBO.clayton_assessment_eog A
        JOIN [refmasterycatergorydomainname_eog] B
            ON A.[testtype] = CASE
                                  WHEN B.contentarea = 'English Language Arts' THEN 'ELA'
                                  WHEN B.contentarea = 'Mathematics' THEN 'Math'
                                  WHEN B.contentarea = 'Science' THEN 'Sci'
                                  WHEN B.contentarea = 'Social Studies' THEN 'Soc'
                                  WHEN B.contentarea = 'HS Physical Science' THEN 'HS Phys Sci'
                              END
               AND Charindex(A.gradelevel, B.gradelevel) <> 0
               AND A.tenantid = B.tenantid
               AND B.masterycategorydomainnumber = 9
	WHERE a.schoolYear = @SchoolYear

--=====================================			   
	UPDATE A
    SET A.domainname10 = B.catergorydomainnameeogcode
    FROM DBO.clayton_assessment_eog A
        JOIN [refmasterycatergorydomainname_eog] B
            ON A.[testtype] = CASE
                                  WHEN B.contentarea = 'English Language Arts' THEN 'ELA'
                                  WHEN B.contentarea = 'Mathematics' THEN'Math'
                                  WHEN B.contentarea = 'Science' THEN 'Sci'
                                  WHEN B.contentarea = 'Social Studies' THEN 'Soc'
                                  WHEN B.contentarea = 'HS Physical Science' THEN 'HS Phys Sci'
                              END
               AND Charindex(A.gradelevel, B.gradelevel) <> 0
               AND A.tenantid = B.tenantid
               AND B.masterycategorydomainnumber = 10
	WHERE a.schoolYear = @SchoolYear

--=====================================	
	UPDATE A
    SET A.domainname11 = B.catergorydomainnameeogcode
    FROM DBO.clayton_assessment_eog A
        JOIN [refmasterycatergorydomainname_eog] B
            ON A.[testtype] = CASE
                                  WHEN B.contentarea = 'English Language Arts' THEN 'ELA'
                                  WHEN B.contentarea = 'Mathematics' THEN 'Math'
                                  WHEN B.contentarea = 'Science' THEN 'Sci'
                                  WHEN B.contentarea = 'Social Studies' THEN 'Soc'
                                  WHEN B.contentarea = 'HS Physical Science' THEN 'HS Phys Sci'
                              END
               AND Charindex(A.gradelevel, B.gradelevel) <> 0
               AND A.tenantid = B.tenantid
               AND B.masterycategorydomainnumber = 11
	WHERE a.schoolYear = @SchoolYear

--=====================================	
	UPDATE A
    SET SCHOOLLEVEL = Upper(GRADEBAND)
    FROM clayton_assessment_eog A
        INNER JOIN MAIN.clayton_analyticvue_icschools B
            ON A.schoolidentifier = B.number
	WHERE a.schoolYear = @SchoolYear

--=====================================			
	UPDATE E
    SET [RACEETHNICITY] = CASE
                              WHEN E.[raceethnicity] IN ( 'B', '3' ) THEN 'Black'
                              WHEN E.[raceethnicity] = 'W' THEN 'White'
                              WHEN E.[raceethnicity] IN ( 'I', '1' ) THEN 'American Indian'
                              WHEN E.[raceethnicity] = '6' THEN 'Pacific Islander'
                              WHEN E.[raceethnicity] IN ( 'A', '4' ) THEN 'Asian'
                              WHEN E.[raceethnicity] IN ( 'M', '7' ) THEN 'Two or More Races'
                              WHEN E.[raceethnicity] IN ( 'H' ) THEN 'Hispanic'
                              ELSE 'Not Selected'
                          END
    FROM clayton_assessment_eog E
	WHERE e.schoolYear = @SchoolYear

--=====================================
	UPDATE E
    SET [GIFTEDINDICATOR] = CASE
                                WHEN GIFTEDSTATUS = 'Y' THEN  'Yes'
                                ELSE 'No'
                            END,
        [S504INDICATOR] = CASE
                              WHEN S504 = 'Y' THEN 'Yes'
                              ELSE 'No'
                          END,
        [DISABILITY1] = DISABILITY,
        [SWDINDICATOR] = CASE
                             WHEN SPED = 'Y' THEN 'Yes'
                             ELSE 'No'
                         END,
        E.[eipremedialindicator] = CASE
                                       WHEN EIP = 'Y' THEN 'Yes'
                                       ELSE 'No'
                                   END
    FROM clayton_assessment_eog E
        LEFT JOIN MAIN.clayton_analyticvue_icprograms P
            ON E.studentnumber = P.studentnumber
	WHERE e.schoolYear = @SchoolYear

--=====================================			
	UPDATE e
    SET e.testadmin = LEFT(e.testadmin, Charindex(' ', e.testadmin) - 1)
	FROM clayton_assessment_eog E
	WHERE e.schoolYear = @SchoolYear

--=====================================
	UPDATE E
    SET E.[homeless] = CASE
                           WHEN P.homeless = 'Y' THEN 'Yes'
                           ELSE 'No'
                       END
    FROM clayton_assessment_eog E
        LEFT JOIN MAIN.clayton_analyticvue_icprograms P
            ON E.studentnumber = P.studentnumber
	WHERE e.schoolYear = @SchoolYear

--=====================================			
	UPDATE E
    SET [FRL] = CASE
                    WHEN P.frl = 'Y' THEN
                        'Yes'
                    ELSE
                        'No'
                END
    FROM [dbo].[clayton_assessment_eog] E
        LEFT JOIN MAIN.clayton_analyticvue_icfrlell P
            ON E.studentnumber = P.studentnumber
	WHERE e.schoolYear = @SchoolYear

--=====================================	
	UPDATE A
    SET SCHOOLNAME = NAMEOFINSTITUTION
    FROM [dbo].[clayton_assessment_eog] A
        INNER JOIN MAIN.k12school B
            ON A.[testschoolcode] = B.schoolidentifier
	WHERE A.schoolYear = @SchoolYear

--=====================================
    --GAA,IEP
	UPDATE E
    SET [GAA] = CASE
                    WHEN P.gaa = 'Y' THEN
                        'Yes'
                    ELSE
                        'No'
                END,
        [REMEDIALINDICATOR] = CASE
                                  WHEN E.[remedialindicator] = 'Y' THEN
                                      'Yes'
                                  ELSE
                                      'No'
                              END,
    [MAGNET] = CASE WHEN  P.number IN('0380','0307','0114','0990114','0215') AND  P.magnetschooltype = 'School-Wide Magnet'  THEN 'School-Wide Magnet'
                WHEN  P.magnet = 'Y' AND  P.number IN('0204','2062','0100','3052','0207','4058') THEN 'Neighborhood Magnet School'
        WHEN  P.magnet = 'Y' AND  P.magnetschooltype = 'Program Within School' THEN 'Program Within School'
                ELSE NULL END

    FROM [dbo].[clayton_assessment_eog] E
        LEFT JOIN MAIN.clayton_analyticvue_icprograms P
            ON E.studentnumber = P.studentnumber
      AND E.schoolyear = P.schoolyear
	WHERE e.schoolYear = @SchoolYear

--=====================================	  
	UPDATE E
    SET [CURRENTSCHOOLIDENTIFIER] = P.schoolnumber,
        [CURRENTSCHOOLNAME] = PCH.nameofinstitution
    FROM [dbo].[clayton_assessment_eog] E
        LEFT JOIN MAIN.clayton_analyticvue_icstudents P
            ON E.studentnumber = P.studentnumber
               AND P.schoolyear =
               (
                   SELECT Max(schoolyear) FROM MAIN.clayton_analyticvue_icstudents
               )
        LEFT JOIN MAIN.k12school PCH
      ON (CASE
          WHEN P.schoolnumber IS NULL THEN NULL
          WHEN P.schoolnumber = '6008' AND P.schoolname LIKE '%High%' THEN '0036008'
          WHEN P.schoolnumber = '6008' AND P.schoolname LIKE '%Middle%' THEN '0026008'
          WHEN P.schoolnumber = '6008' AND P.schoolname LIKE '%Elem%' THEN '0016008'
          WHEN P.schoolnumber = '6422' AND P.schoolname LIKE '%High%' THEN '0096422'
          WHEN P.schoolnumber = '6422' AND P.schoolname LIKE '%Middle%' THEN '0236422'
          WHEN P.schoolnumber = '6422' AND P.schoolname LIKE '%Elem%' THEN '1286422'
          WHEN P.schoolnumber = '6004' AND P.schoolname LIKE '%High%' THEN '0086004'
          WHEN P.schoolnumber = '6004' AND P.schoolname LIKE '%Middle%' THEN '0226004'
          WHEN P.schoolnumber = '0114' AND P.schoolname = '24-25 Elite Scholars Middle' THEN '0990114'
          ELSE P.schoolnumber
        END) = PCH.schoolidentifier
		AND P.schoolyear = PCH.schoolyear
	  WHERE e.schoolYear = @SchoolYear

--=====================================	  
	UPDATE E
    SET [CurrentGrade] = CURR_RG.GRADEDESCRIPTION
    FROM [dbo].[Clayton_Assessment_EOG] E
        LEFT JOIN MAIN.CLAYTON_ANALYTICVUE_ICSTUDENTS P
            ON E.STUDENTNUMBER = P.STUDENTNUMBER
               AND P.SCHOOLYEAR IN (
                                       SELECT Max(SCHOOLYEAR) FROM MAIN.CLAYTON_ANALYTICVUE_ICSTUDENTS
                                   )
        LEFT JOIN [dbo].[RefGrade] CURR_RG
            ON P.GRADE = CURR_RG.GRADECODE
	WHERE e.schoolYear = @SchoolYear

--=====================================
    UPDATE e
    SET e.TestTakenDate = CONVERT(DATE, 
    RIGHT(testdate, 2) + LEFT(testdate, 2) + SUBSTRING(testdate, 3, 2), 1)
    From Clayton_Assessment_EOG e
    where e.schoolyear = @SchoolYear

    /**Enabling All Indexes**/
	
	EXEC [dbo].[USP_EnableAllIndexes] 'Clayton_Assessment_EOG'

	EXEC [dbo].[USP_EnableAllIndexes] 'Main.Clayton_EOG'
	
	EXEC [dbo].[USP_EnableAllIndexes] 'main.Clayton_AnalyticVue_ICStudents'

END
GO


