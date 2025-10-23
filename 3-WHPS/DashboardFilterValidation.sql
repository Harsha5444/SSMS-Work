----select reportdetailsid,ReportDetailsName , reportfiledetails, DomainRelatedViewId,ChildReportId from ReportDetails where tenantid = 38 and reportfiledetails is not null
--select * from fn_DashboardReportsDetails(38) where ReportId = '6651'--'6580'
--select columnname from idm.StudentsSubgroup where tenantid = 38 and statusid = 1
--select * from RptDomainRelatedViews where domainrelatedviewid = 2696
--select columnname from rptviewfields where domainrelatedviewid = 2696

if object_id('tempdb..#WHPS_DashboardFiltersvalidation') IS NOT NULL
 begin
 DROP TABLE #WHPS_DashboardFiltersvalidation;
 end

create table #WHPS_DashboardFiltersvalidation(
reportdetailsid int,
reportname varchar(100)
)

insert into #WHPS_DashboardFiltersvalidation
select reportid as reportdetailsid,reportname from (
select distinct reportid,reportname,dataset from fn_DashboardReportsDetails(38)
--union
--select distinct ChildReportId, ChildReportName, ChildReportDataSet from fn_DashboardReportsDetails(38) where ChildReportId is not null
)a where dataset is not null

--select b.ReportDetailsId, b.ReportDetailsName, b.DomainRelatedViewId, b.ReportFileDetails from #WHPS_DashboardFiltersvalidation a
--join ReportDetails b
--on a.reportdetailsid = b.reportdetailsid


;with basecols as (
    select distinct columnname
    from idm.studentssubgroup
    where tenantid = 38
      and statusid = 1
),
reportviews as (
    select 
        r.reportdetailsid,
        r.reportdetailsname,
        r.domainrelatedviewid
    from #WHPS_DashboardFiltersvalidation w
    join reportdetails r
        on w.reportdetailsid = r.reportdetailsid
    where r.domainrelatedviewid is not null
),
ViewFieldsClean AS (
    SELECT 
        DomainRelatedViewId,
        LTRIM(RTRIM(REPLACE(REPLACE(ColumnName,'[',''),']',''))) AS ColumnName
    FROM RptViewFields where tenantid = 38
),
Final as (
select 
    rv.reportdetailsid,
    rv.reportdetailsname,
    rv.domainrelatedviewid,
    b.columnname as subgroupcolumn,
    v.columnname as viewcolumn,
    case 
        WHEN v.ColumnName IS NOT NULL THEN 'Present in View'
        ELSE 'Missing in View'
    end as status
from reportviews rv
cross join basecols b
left join ViewFieldsClean v
    on v.domainrelatedviewid = rv.domainrelatedviewid
   and v.columnname = b.columnname
--order by rv.reportdetailsid, b.columnname
)
select 
f.ReportDetailsId,
    f.ReportDetailsName,
    f.DomainRelatedViewId,
    d.ViewName,  
    f.SubgroupColumn,
    f.Status
from final  f
join rptdomainrelatedviews d
    on f.domainrelatedviewid = d.domainrelatedviewid
where [status] = 'Missing in View' --and d.viewname = 'dbo.WHPSQuestESDS'
order by 1,3




select * from WHPS_StudentSummaryWithAllAss where schoolyear = 2026

select  *
    from idm.studentssubgroup
    where tenantid = 38
      and statusid = 1
      order by sortorder

select * from WHPSLASLinksDS

select * from ReportDetails where reportdetailsid = '8852'

SELECT  
    JSON_VALUE(value, '$.AliasName') AS AliasName
FROM ReportDetails
CROSS APPLY OPENJSON(ReportFileDetails, '$.AdvanceFilter')
WHERE ReportDetailsId = '8870';

--WHPS_Quest_MS_DS
--WHPS_Quest_ES_DS
--WHPS_PAT_ALLLevelMovementDS
--WHPS_PATLevelMovementStudentDS

select * from WHPS_PATLevelMovementStudent_Vw
select * from WHPS_PAT_LevelMovement

select * from WHPSPATALLLevelMovementDS
select * from WHPSPATLevelMovementStudentDS
exec sp_depends WHPSPATALLLevelMovementDS
exec sp_helptext WHPS_PAT_LevelMovement
select * from dbo.WHPS_StudentSummaryWithAllAss where schoolyear = 2025
create view WHPS_iReadyTerms as
 --select * from RefTerm where tenantid=38 and schoolyear=2026
select 'Fall' Term,  1 as SortOrder, 38 as TenantId
Union select 'Winter' Term,  2 as SortOrder, 38 as TenantId
Union select 'Spring' Term,  3 as SortOrder, 38 as TenantId
select distinct TermDescription from WHPSAssessmentAllDS
--exec [usp_updatedatasetfield] 'WHPSiReadySBACDS', 'GradeCode', 'Grade', 38
--exec [usp_updatedatasetfield] 'WHPSSATPSATSSDS', 'ellindicator', 'ELL', 38
--exec [usp_updatedatasetfield] 'WHPSSATPSATSSDS', 'c_504_status', '504Status', 38
--exec [usp_updatedatasetfield] 'WHPSSATPSATSSDS', 'COHORT_YEAR', 'CohortGraduationYear', 38
alter view WHPS_LASProficiencyLevelsSort as
select 'Level 1 - Beginning' as ProficiencyLevel , 1 as SortOrder, 38 as TenantId
union all select 'Level 2 - Early Intermediate' as ProficiencyLevel , 2 as SortOrder, 38 as TenantId
union all select 'Level 3- Intermediate' as ProficiencyLevel , 3 as SortOrder, 38 as TenantId
union all select 'Level 4 - Proficient' as ProficiencyLevel , 4 as SortOrder, 38 as TenantId
union all select 'Level 5 - Above Proficient' as ProficiencyLevel , 5 as SortOrder, 38 as TenantId

--Level 2 - Early Intermediate
--Level 1 - Beginning
--Level 4 - Proficient
--Level 3- Intermediate
--Level 5 - Above Proficient


c_504_status, specialeducation, ellindicator, Racecd

select distinct alt_proficiency_level_name from dbo.WHPSLASLinksDS

school_building, Status504
select * from fn_DashboardReportsDetails(38) where dashboardname = 'Acuity Matrix'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'AimsWeb Plus'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'AP - Advanced Placement'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'i-Ready'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'LAS Links'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'LAS Links Growth'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'SAT/PSAT'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'SBAC'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'SBAC Longitudinal Performance'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'NGSS'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'STAR'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'Student Growth - AimsWeb Plus'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'Student Growth - i-Ready'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'Discipline Dashboard (WHPS)'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'Discipline - High School Report'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'Discipline - Middle School Report'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'Discipline - Reach and Strive'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'Blitz Report - District'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'Blitz Report (District)'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'Blitz Report - Teacher'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'Blitz Report - Assessments - Middle'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'Blitz Report - Assessments - High'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'District Grade Level Assessments Grade 6'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'District Grade Level Assessments Grade 7'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'District Grade Level Assessments Grade 8'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'District Grade Level Assessments Grade 9'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'District Grade Level Assessments Grade 10'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'District Grade Level Assessments Grade 11'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'District Grade Level Assessments Grade 12'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'Teacher Blitz Reports: Grade Level Assessments Grade 6'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'Teacher Blitz Reports: Grade Level Assessments Grade 7'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'Teacher Blitz Reports: Grade Level Assessments Grade 8'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'Teacher Blitz Reports: Grade Level Assessments Grade 9'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'Teacher Blitz Reports: Grade Level Assessments Grade 10'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'Teacher Blitz Reports: Grade Level Assessments Grade 11'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'Teacher Blitz Reports: Grade Level Assessments Grade 12'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'Attendance Dashboard (WHPS)'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'District (WHPS)'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'Enrollment Dashboard (WHPS)'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'Principal (WHPS)'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'Quest'
select * from fn_DashboardReportsDetails(38) where dashboardname = 'PAT Level Movement'



select * from ReportDetails where reportdetailsid = 6651
select * from RptDomainRelatedViews where DomainRelatedViewId=2741
select * from RptDomainRelatedViews where displayname='WHPS_LASLinksDS'
select * from RptDomainRelatedViews where tenantid = 38 and isdynamic = 1



select * from dbo.RptViewFields where DomainRelatedViewId=2847 order by sortorder
select * from IDM.DataSetColumn where DomainRelatedViewId=2847

--insert into RptViewFields
--select 2741, 'IEP', 'IEP', 'VARCHAR', NULL, NULL, 28, NULL, 38, 1, 'DDAUser@DDA', Getdate(), NULL, NULL, NULL



SELECT 
    r.ReportDetailsId,
    r.ReportDetailsName,
    r.ReportFileDetails
FROM ReportDetails r
CROSS APPLY OPENJSON(r.ReportFileDetails, '$.AdvanceFilter')
WITH (
    AliasName NVARCHAR(200) '$.AliasName'
) af
WHERE r.TenantId = 38
  AND r.ReportFileDetails IS NOT NULL
  AND af.AliasName LIKE '%Lea%'
  AND r.ReportDetailsId IN (
      SELECT DISTINCT ReportId 
      FROM fn_DashboardReportsDetails(38)
      union 
      SELECT DISTINCT ChildReportId 
      FROM fn_DashboardReportsDetails(38)
  );

SELECT 
    r.ReportDetailsId,
    r.ReportDetailsName,
    r.ReportFileDetails
FROM ReportDetails r
CROSS APPLY OPENJSON(r.ReportFileDetails, '$.AdvanceFilter')
WITH (
    AliasName NVARCHAR(200) '$.AliasName'
) af
WHERE r.TenantId = 38
  AND r.ReportFileDetails IS NOT NULL
  AND af.AliasName LIKE '%Org%'
  AND r.ReportDetailsId IN (
      SELECT DISTINCT ReportId 
      FROM fn_DashboardReportsDetails(38)
      union 
      SELECT DISTINCT ChildReportId 
      FROM fn_DashboardReportsDetails(38)
  );
--6643

select distinct DataSetOG from fn_DashboardReportsDetails(38) --where reportid in (6643,6829)
where DataSetOG is not  null



SELECT 
    AssessmentName,
    STRING_AGG(SchoolYear, ', ') WITHIN GROUP (ORDER BY SchoolYear) AS SchoolYears
FROM (
    SELECT DISTINCT 
        a.SchoolYear,
        b.AssessmentName
    FROM main.k12studentgenericassessment a
    JOIN main.assessmentdetails b
        ON a.AssessmentCodeId = b.AssessmentDetailsId
       AND a.SchoolYear = b.SchoolYear
       AND a.TenantId = b.TenantId
    WHERE a.TenantId = 38
) a
GROUP BY AssessmentName
ORDER BY AssessmentName;


select * from main.assessmentdetails where tenantid = 38

select* from refgrade where tenantid = 38

drop view WHPSAimsWebPlusElementryGrades_Vw

Create view WHPS_EleGrades_Vw
as
select  'AimsWebPlus' as Assessment , 'K' as GradeDescription, '0' as GradeCode , 1 as SortOrder , 38 as TenantId , 'DDAUser@DDA' as CreatedBy , getdate() as CreatedDate, NULL as ModifiedBy, NULL as ModifiedDate
union select 'AimsWebPlus' as Assessment ,  'Grade 1' as GradeDescription, '1' as GradeCode , 2 as SortOrder , 38 as TenantId , 'DDAUser@DDA' as CreatedBy , getdate() as CreatedDate, NULL as ModifiedBy, NULL as ModifiedDate
union select 'AimsWebPlus' as Assessment ,  'Grade 2'  as GradeDescription, '2' as GradeCode , 3 as SortOrder , 38 as TenantId , 'DDAUser@DDA' as CreatedBy , getdate() as CreatedDate, NULL as ModifiedBy, NULL as ModifiedDate
union select 'AimsWebPlus' as Assessment ,  'Grade 3'  as GradeDescription, '3' as GradeCode , 4 as SortOrder , 38 as TenantId , 'DDAUser@DDA' as CreatedBy , getdate() as CreatedDate, NULL as ModifiedBy, NULL as ModifiedDate
union select 'AimsWebPlus' as Assessment ,  'Grade 4'  as GradeDescription, '4' as GradeCode , 5 as SortOrder , 38 as TenantId , 'DDAUser@DDA' as CreatedBy , getdate() as CreatedDate, NULL as ModifiedBy, NULL as ModifiedDate
union select 'AimsWebPlus' as Assessment ,  'Grade 5' as GradeDescription, '5' as GradeCode , 6 as SortOrder , 38 as TenantId , 'DDAUser@DDA' as CreatedBy , getdate() as CreatedDate, NULL as ModifiedBy, NULL as ModifiedDate

select distinct grade from aggrptk12studentdetails where tenantid = 38 order by 1


select distinct WHPSProfLevel from dbo.WHPSProfLevelAimsWebPlusDS

exec sp_depends WHPSProfLevelAimsWebPlusDS
exec sp_depends WHPS_AimsWebPlusProficiency_Vw

exec sp_helptext RefBlitzAIMSWebPlusLevels
select * from Main.WHPS_AimsWebPlus
select distinct WHPSProfLevel from WHPS_AimsWebPlusProficiency_Vw

select * from sys.views where name like '%AimsWebPlus%'

select * from RefBlitzAIMSWebPlusLevels

create view dbo.WHPS_AIMSWebPlusProflevels_Vw   
as    
SELECT  'Below Goal' AS ProficiencyCode, 'Below Goal' AS ProficiencyDescription, 1 AS SortOrder, 'AIMSWebPlus' AS AssessmentCode, 38 AS TenantID, 1 as StatusID  
UNION ALL  
SELECT  'Progressing to Goal', 'Progressing to Goal',  2, 'AIMSWebPlus', 38,1
UNION ALL  
SELECT  'Meets Goal', 'Meets Goal',  3, 'AIMSWebPlus', 38,1  

select schoolyear,count(*) from dbo.AggRptK12StudentDetails where iep is null and tenantid = 38 
group by schoolyear
select schoolyear,count(*) from dbo.AggRptK12StudentDetails where [504status] is null and tenantid = 38 
group by schoolyear
select schoolyear,count(*) from dbo.AggRptK12StudentDetails where specialedstatus is null and tenantid = 38 
group by schoolyear
select schoolyear,count(*) from dbo.AggRptK12StudentDetails where ell is null and tenantid = 38 
group by schoolyear
select schoolyear,count(*) from dbo.AggRptK12StudentDetails where race is null and tenantid = 38 
group by schoolyear
select schoolyear,count(*) from dbo.AggRptK12StudentDetails where ethnicity is null and tenantid = 38 
group by schoolyear


select * from RptDomainRelatedViews where DisplayName='WHPS_Assessment_All_DS'
select * from RptDomainRelatedViews where viewname='dbo.STARAssessmetScoreDS'

select * from reportdetails where domainrelatedviewid = '2847' 

select * from IDM.DataSetColumn where DomainRelatedViewId=2841
--insert into IDM.DataSetColumn
--select 'AggRptK12StudentDetails', 'SchoolCategory', 'SchoolCategory', NULL, 47, NULL, 0, NULL, NULL, NULL, 0, 2847, 'dbo', 'varchar', 1, 'AggRptK12StudentDetails.[SchoolCategory]', 0, 38, 1, 'Analyticvue.Admin@WHPS', getdate(), NULL, NULL

select * from RptViewFields where DomainRelatedViewId=2841
--insert into RptViewFields
--select 2841, '[IEP]', 'IEP', 'varchar', NULL, NULL, 47, NULL, 38, 1, 'Analyticvue.Admin@WHPS', getdate(), NULL, NULL, NULL
  
  --update rptviewfields
  --set LookupTable='dbo.RefGrade', LookupColumn='GradeDescription'
  --where RptViewFieldsId=73054

  select * from RptViewFields where LookupTable like '%prof%'
  --dbo.RefGrade	GradeDescription



