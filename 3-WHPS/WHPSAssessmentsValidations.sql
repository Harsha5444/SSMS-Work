select top 100* from AggrptAssessmentSubgroupData where tenantid = 38

select distinct  AssessmentCode  from AggrptAssessmentSubgroupData where tenantid = 38 order by AssessmentCode

select SchoolYear,AssessmentCode,count(*) as TotalRecords from AggrptAssessmentSubgroupData where tenantid = 38
group by SchoolYear,AssessmentCode
order by SchoolYear,AssessmentCode

select * from RefFileTemplates where tenantid = 38 and IsDynamic is not null
order by FileTemplateName

--select * from RefFileTemplates where tenantid = 38 and IsDynamic is not null and FileTemplateName like  '%sat%'
--order by FileTemplateName
--WHPS_PSAT89_Source_Data
--WHPS_PSATNMSQT_Source_Data
--WHPS_SAT_Source_Data

--select * from fn_DashboardReportsDetails(38) where dashboardname = 'SAT/PSAT'
--select * from fn_DashboardReportsDetails(38) where dashboardname = 'AP - Advanced Placement'
--select * from fn_DashboardReportsDetails(38) where dashboardname = 'i-Ready'
--select * from fn_DashboardReportsDetails(38) where dashboardname = 'LAS Links'
--select * from fn_DashboardReportsDetails(38) where dashboardname = 'LAS Links Growth'
exec sp_depends WHPS_LASGrowth_VW

--exec sp_helptext WHPSSATStudentSS_VW
--exec sp_helptext WHPSAPAllYearsViewChartDs
        --exec sp_helptext WHPS_AP_AllYears_View

--=============================================[AIMSWebPlus]==============================================
select * from RefFileTemplates where tenantid = 38 and IsDynamic is not null and filetemplatename like '%AimsWeb%'
order by FileTemplateName

select schoolyear,count(*) from Main.WHPS_AimsWebPlus
group by schoolyear
order by schoolyear

select SchoolYear,AssessmentCode,count(*) as TotalRecords from AggrptAssessmentSubgroupData where tenantid = 38 and AssessmentCode='AIMSWebPlus'
group by SchoolYear,AssessmentCode
order by SchoolYear,AssessmentCode

SELECT 
    a.SchoolYear,
    a.AssessmentCode,
    COUNT(*) AS TotalRecords,
    sa.SubjectAreaCodes,
    gc.GradeCodes
FROM AggrptAssessmentSubgroupData a
CROSS APPLY (
    SELECT STRING_AGG(s.SubjectAreaCode, ',') AS SubjectAreaCodes
    FROM (
        SELECT DISTINCT SubjectAreaCode
        FROM AggrptAssessmentSubgroupData x
        WHERE x.TenantId = a.TenantId
          AND x.SchoolYear = a.SchoolYear
          AND x.AssessmentCode = a.AssessmentCode
    ) s
) sa
CROSS APPLY (
    SELECT STRING_AGG(g.GradeCode, ',') WITHIN GROUP (ORDER BY g.GradeCode) AS GradeCodes
    FROM (
        SELECT DISTINCT GradeCode
        FROM AggrptAssessmentSubgroupData y
        WHERE y.TenantId = a.TenantId
          AND y.SchoolYear = a.SchoolYear
          AND y.AssessmentCode = a.AssessmentCode
    ) g
) gc
WHERE a.TenantId = 38
  AND a.AssessmentCode = 'AIMSWebPlus'
GROUP BY a.SchoolYear, a.AssessmentCode, sa.SubjectAreaCodes, gc.GradeCodes
ORDER BY a.SchoolYear, a.AssessmentCode;

--============================================[AP]==============================================
select * from RefFileTemplates where tenantid = 38 and IsDynamic is not null and  filetemplatename like '%AP%'
order by FileTemplateName

select schoolyear,count(*) from Main.WHPS_AP
group by schoolyear
order by schoolyear

select schoolyear,count(*) from Main.WHPS_AP_AllYears
group by schoolyear
order by schoolyear

select schoolyear,count(*) from Main.WHPS_AP_SOURCE
group by schoolyear
order by schoolyear

select schoolyear,count(*) from Main.WHPS_APDualCCPEnrollments
group by schoolyear
order by schoolyear

select SchoolYear,AssessmentCode,count(*) as TotalRecords from AggrptAssessmentSubgroupData where tenantid = 38 and AssessmentCode='AP'
group by SchoolYear,AssessmentCode
order by SchoolYear,AssessmentCode

SELECT 
    a.SchoolYear,
    a.AssessmentCode,
    COUNT(*) AS TotalRecords,
    sa.SubjectAreaCodes,
    gc.GradeCodes
FROM AggrptAssessmentSubgroupData a
CROSS APPLY (
    SELECT STRING_AGG(s.SubjectAreaCode, ',') AS SubjectAreaCodes
    FROM (
        SELECT DISTINCT SubjectAreaCode
        FROM AggrptAssessmentSubgroupData x
        WHERE x.TenantId = a.TenantId
          AND x.SchoolYear = a.SchoolYear
          AND x.AssessmentCode = a.AssessmentCode
    ) s
) sa
CROSS APPLY (
    SELECT STRING_AGG(g.GradeCode, ',') WITHIN GROUP (ORDER BY g.GradeCode) AS GradeCodes
    FROM (
        SELECT DISTINCT GradeCode
        FROM AggrptAssessmentSubgroupData y
        WHERE y.TenantId = a.TenantId
          AND y.SchoolYear = a.SchoolYear
          AND y.AssessmentCode = a.AssessmentCode
    ) g
) gc
WHERE a.TenantId = 38
  AND a.AssessmentCode = 'AP'
GROUP BY a.SchoolYear, a.AssessmentCode, sa.SubjectAreaCodes, gc.GradeCodes
ORDER BY a.SchoolYear, a.AssessmentCode;

--================================================[i-Ready]=======================================================
select * from RefFileTemplates where tenantid = 38 and IsDynamic is not null and  filetemplatename like '%diag%'
order by FileTemplateName

select schoolyear,count(*) from main.WHPS_diagnostic_results_ela
group by schoolyear
order by schoolyear

select schoolyear,count(*) from main.WHPS_diagnostic_results_math
group by schoolyear
order by schoolyear

select SchoolYear,AssessmentCode,count(*) as TotalRecords from AggrptAssessmentSubgroupData where tenantid = 38 and AssessmentCode='i-Ready'
group by SchoolYear,AssessmentCode
order by SchoolYear,AssessmentCode

SELECT 
    a.SchoolYear,
    a.AssessmentCode,
    COUNT(*) AS TotalRecords,
    sa.SubjectAreaCodes,
    gc.GradeCodes
FROM AggrptAssessmentSubgroupData a
CROSS APPLY (
    SELECT STRING_AGG(s.SubjectAreaCode, ',') AS SubjectAreaCodes
    FROM (
        SELECT DISTINCT SubjectAreaCode
        FROM AggrptAssessmentSubgroupData x
        WHERE x.TenantId = a.TenantId
          AND x.SchoolYear = a.SchoolYear
          AND x.AssessmentCode = a.AssessmentCode
    ) s
) sa
CROSS APPLY (
    SELECT STRING_AGG(g.GradeCode, ',') WITHIN GROUP (ORDER BY g.GradeCode) AS GradeCodes
    FROM (
        SELECT DISTINCT GradeCode
        FROM AggrptAssessmentSubgroupData y
        WHERE y.TenantId = a.TenantId
          AND y.SchoolYear = a.SchoolYear
          AND y.AssessmentCode = a.AssessmentCode
    ) g
) gc
WHERE a.TenantId = 38
  AND a.AssessmentCode = 'i-Ready'
GROUP BY a.SchoolYear, a.AssessmentCode, sa.SubjectAreaCodes, gc.GradeCodes
ORDER BY a.SchoolYear, a.AssessmentCode;

--==================================================[LAS Links]================================================
select * from RefFileTemplates where tenantid = 38 and IsDynamic is not null and  filetemplatename like '%las%'
order by FileTemplateName

select schoolyear,count(*) from Main.WHPS_LASGrowthTargets
group by schoolyear
order by schoolyear
select schoolyear,count(*) from Main.WHPS_LASGrowthTargetsResults
group by schoolyear
order by schoolyear
select schoolyear,count(*) from main.WHPS_LASLinks
group by schoolyear
order by schoolyear


select SchoolYear,AssessmentCode,count(*) as TotalRecords from AggrptAssessmentSubgroupData where tenantid = 38 and AssessmentCode='LASLinks'
group by SchoolYear,AssessmentCode
order by SchoolYear,AssessmentCode

SELECT 
    a.SchoolYear,
    a.AssessmentCode,
    COUNT(*) AS TotalRecords,
    sa.SubjectAreaCodes,
    gc.GradeCodes
FROM AggrptAssessmentSubgroupData a
CROSS APPLY (
    SELECT STRING_AGG(s.SubjectAreaCode, ',') AS SubjectAreaCodes
    FROM (
        SELECT DISTINCT SubjectAreaCode
        FROM AggrptAssessmentSubgroupData x
        WHERE x.TenantId = a.TenantId
          AND x.SchoolYear = a.SchoolYear
          AND x.AssessmentCode = a.AssessmentCode
    ) s
) sa
CROSS APPLY (
    SELECT STRING_AGG(g.GradeCode, ',') WITHIN GROUP (ORDER BY g.GradeCode) AS GradeCodes
    FROM (
        SELECT DISTINCT GradeCode
        FROM AggrptAssessmentSubgroupData y
        WHERE y.TenantId = a.TenantId
          AND y.SchoolYear = a.SchoolYear
          AND y.AssessmentCode = a.AssessmentCode
    ) g
) gc
WHERE a.TenantId = 38
  AND a.AssessmentCode = 'LASLinks'
GROUP BY a.SchoolYear, a.AssessmentCode, sa.SubjectAreaCodes, gc.GradeCodes
ORDER BY a.SchoolYear, a.AssessmentCode;
--===================================================[SAT]===========================================
select * from RefFileTemplates where tenantid = 38 and IsDynamic is not null and  filetemplatename like '%sat%'
order by FileTemplateName

select schoolyear,count(*) from Main.WHPS_PSAT89_Source   group by schoolyear order by schoolyear
select schoolyear,count(*) from Main.WHPS_PSAT89_Source_Data   group by schoolyear order by schoolyear
select schoolyear,count(*) from Main.WHPS_PSATNM_Source   group by schoolyear order by schoolyear
select schoolyear,count(*) from Main.WHPS_SAT_Source_Data group by schoolyear order by schoolyear

select SchoolYear,AssessmentCode,count(*) as TotalRecords from AggrptAssessmentSubgroupData where tenantid = 38 and AssessmentCode='PSAT89'
group by SchoolYear,AssessmentCode
order by SchoolYear,AssessmentCode
select SchoolYear,AssessmentCode,count(*) as TotalRecords from AggrptAssessmentSubgroupData where tenantid = 38 and AssessmentCode='PSATNM'
group by SchoolYear,AssessmentCode
order by SchoolYear,AssessmentCode
select SchoolYear,AssessmentCode,count(*) as TotalRecords from AggrptAssessmentSubgroupData where tenantid = 38 and AssessmentCode='SAT'
group by SchoolYear,AssessmentCode
order by SchoolYear,AssessmentCode




SELECT 
    a.SchoolYear,
    a.AssessmentCode,
    COUNT(*) AS TotalRecords,
    sa.SubjectAreaCodes,
    gc.GradeCodes
FROM AggrptAssessmentSubgroupData a
CROSS APPLY (
    SELECT STRING_AGG(s.SubjectAreaCode, ',') AS SubjectAreaCodes
    FROM (
        SELECT DISTINCT SubjectAreaCode
        FROM AggrptAssessmentSubgroupData x
        WHERE x.TenantId = a.TenantId
          AND x.SchoolYear = a.SchoolYear
          AND x.AssessmentCode = a.AssessmentCode
    ) s
) sa
CROSS APPLY (
    SELECT STRING_AGG(g.GradeCode, ',') WITHIN GROUP (ORDER BY g.GradeCode) AS GradeCodes
    FROM (
        SELECT DISTINCT GradeCode
        FROM AggrptAssessmentSubgroupData y
        WHERE y.TenantId = a.TenantId
          AND y.SchoolYear = a.SchoolYear
          AND y.AssessmentCode = a.AssessmentCode
    ) g
) gc
WHERE a.TenantId = 38
  AND a.AssessmentCode = 'SAT'
GROUP BY a.SchoolYear, a.AssessmentCode, sa.SubjectAreaCodes, gc.GradeCodes
ORDER BY a.SchoolYear, a.AssessmentCode;

--===================================================[SBAC]===========================================
select * from RefFileTemplates where tenantid = 38 and IsDynamic is not null and  filetemplatename like '%sbac%'
order by FileTemplateName

select schoolyear,count(*) from Main.WHPS_SBAC               group by schoolyear order by schoolyear
select schoolyear,count(*) from Main.WHPS_SBAC_ELA_Source    group by schoolyear order by schoolyear
select schoolyear,count(*) from Main.WHPS_SBAC_Math_Source   group by schoolyear order by schoolyear
select schoolyear,count(*) from Main.WHPS_SBAC_SourceData    group by schoolyear order by schoolyear


select SchoolYear,AssessmentCode,count(*) as TotalRecords from AggrptAssessmentSubgroupData where tenantid = 38 and AssessmentCode='SBAC'
group by SchoolYear,AssessmentCode
order by SchoolYear,AssessmentCode


SELECT 
    a.SchoolYear,
    a.AssessmentCode,
    COUNT(*) AS TotalRecords,
    sa.SubjectAreaCodes,
    gc.GradeCodes
FROM AggrptAssessmentSubgroupData a
CROSS APPLY (
    SELECT STRING_AGG(s.SubjectAreaCode, ',') AS SubjectAreaCodes
    FROM (
        SELECT DISTINCT SubjectAreaCode
        FROM AggrptAssessmentSubgroupData x
        WHERE x.TenantId = a.TenantId
          AND x.SchoolYear = a.SchoolYear
          AND x.AssessmentCode = a.AssessmentCode
    ) s
) sa
CROSS APPLY (
    SELECT STRING_AGG(g.GradeCode, ',') WITHIN GROUP (ORDER BY g.GradeCode) AS GradeCodes
    FROM (
        SELECT DISTINCT GradeCode
        FROM AggrptAssessmentSubgroupData y
        WHERE y.TenantId = a.TenantId
          AND y.SchoolYear = a.SchoolYear
          AND y.AssessmentCode = a.AssessmentCode
    ) g
) gc
WHERE a.TenantId = 38
  AND a.AssessmentCode = 'SBAC'
GROUP BY a.SchoolYear, a.AssessmentCode, sa.SubjectAreaCodes, gc.GradeCodes
ORDER BY a.SchoolYear, a.AssessmentCode;

--==================================================[NGSS]============================================
select * from RefFileTemplates where tenantid = 38 and IsDynamic is not null and  filetemplatename like '%NGSS%'
order by FileTemplateName