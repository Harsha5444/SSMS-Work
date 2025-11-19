select FORMAT(CAST([DateTimestamp] AT TIME ZONE 'UTC' AT TIME ZONE 'India Standard Time' AS DATETIME),'MMM dd h:mm:ss tt') AS IST_Time,*
from errorlogforusp order by ErrorId desc;
select FORMAT(CAST([Logdatetime] AT TIME ZONE 'UTC' AT TIME ZONE 'India Standard Time' AS DATETIME),'MMM dd h:mm:ss tt') AS IST_Time,*
from idm.apperrorlog order by EventId desc;

--====================================================================================================

SELECT SPID,ER.percent_complete,
	CAST(((DATEDIFF(s,start_time,GetDate()))/3600) as varchar) + ' hour(s), '
		+ CAST((DATEDIFF(s,start_time,GetDate())%3600)/60 as varchar) + 'min, '
		+ CAST((DATEDIFF(s,start_time,GetDate())%60) as varchar) + ' sec' as running_time,
	CAST((estimated_completion_time/3600000) as varchar) + ' hour(s), '
		+ CAST((estimated_completion_time %3600000)/60000 as varchar) + 'min, '
		+ CAST((estimated_completion_time %60000)/1000 as varchar) + ' sec' as est_time_to_go,
	DATEADD(second,estimated_completion_time/1000, getdate()) as est_completion_time,
ER.command,ER.blocking_session_id, SP.DBID,LASTWAITTYPE, 
DB_NAME(SP.DBID) AS DBNAME,
SUBSTRING(est.text, (ER.statement_start_offset/2)+1, 
		((CASE ER.statement_end_offset
			WHEN -1 THEN DATALENGTH(est.text)
			ELSE ER.statement_end_offset
			END - ER.statement_start_offset)/2) + 1) AS QueryText,
TEXT,CPU,HOSTNAME,LOGIN_TIME,LOGINAME,
SP.status,PROGRAM_NAME,NT_DOMAIN, NT_USERNAME 
FROM SYSPROCESSES SP 
INNER JOIN sys.dm_exec_requests ER
ON sp.spid = ER.session_id
CROSS APPLY SYS.DM_EXEC_SQL_TEXT(er.sql_handle) EST
--WHERE DB_NAME(SP.DBID) = 'AnalyticVue_Clayton'
ORDER BY CPU DESC;

--====================================================================================================

select [LogStatId],[ProcessName],[TableRowsBefore],[TotalRowsInserted],[TableRowsAfter],cast([TableRowsAfter] as int)-cast([TableRowsBefore]  as int)as CountChange,
FORMAT(CAST([StartTime] AT TIME ZONE 'UTC' AT TIME ZONE 'India Standard Time' AS DATETIME),'MMM dd h:mm:ss tt') AS [OurStartTime],
FORMAT(CAST([Endtime] AT TIME ZONE 'UTC' AT TIME ZONE 'India Standard Time' AS DATETIME),'MMM dd h:mm:ss tt') AS [OurEndTime],
[StartTime],[EndTime],[ElapsedTime],[TotalExecutionTime],[EstimatedCPUtime],[EstimatedI/O],[TenantId] from WHPS_ProcessLogStatistics (nolock)
order by [LogStatId] desc;

select * from AVue_TemplateDependentAggTablesLoading

 --====================================================================================================


SELECT distinct o.type_desc AS ObjectType,SCHEMA_NAME(o.schema_id) AS SchemaName,
    o.name AS ObjectName,o.create_date,o.modify_date
FROM sys.sql_expression_dependencies d
INNER JOIN sys.objects o ON d.referencing_id = o.object_id
INNER JOIN sys.objects ro ON d.referenced_id = ro.object_id
WHERE ro.name = 'WHPSAssessmentAllDS_Table' AND ro.type = 'U' -- User tables only
    AND o.type IN ('V', 'P', 'FN', 'IF', 'TF') -- Views, Stored Procedures, Functions
ORDER BY o.type_desc, SchemaName, ObjectName;


SELECT 
    OBJECT_SCHEMA_NAME(o.object_id) AS schema_name,
    o.name AS object_name,
    o.type_desc AS object_type,
    OBJECT_DEFINITION(o.object_id) AS definition
FROM 
    sys.objects o
WHERE 
    o.type IN ('V', 'P') -- V = View, P = Stored Procedure
    AND OBJECT_DEFINITION(o.object_id) LIKE '%insert into [dbo].[BatchSchedule]%';

--====================================================================================================

SELECT RecurringScheduleJobId,BatchId,BatchName,YearId,LastRunDate,DataSourceType,RecurringType,RecurringTime
,CAST(CAST(RecurringTime AS datetime) AT TIME ZONE 'UTC'AT TIME ZONE 'India Standard Time'AS time) AS IST_Time,DayoftheWeek,StatusId
FROM [dbo].[RecurringScheduleJob]
where tenantid = 38 
and statusid = 1
ORDER BY RecurringTime


SELECT 
FORMAT(a.ScheduledDateTime ,'MMM dd h:mm:ss tt') AS DataBaseTime,
FORMAT(CAST(a.[ScheduledDateTime] AT TIME ZONE 'UTC' AT TIME ZONE 'India Standard Time' AS DATETIME),'MMM dd h:mm:ss tt') AS IST_Time
,RIGHT('0' + CAST(DATEDIFF(SECOND, a.ProcessStartDate, a.ProcessEndDate) / 3600 AS VARCHAR), 2) + ':' +
RIGHT('0' + CAST((DATEDIFF(SECOND, a.ProcessStartDate, a.ProcessEndDate) % 3600) / 60 AS VARCHAR), 2) + ':' +
RIGHT('0' + CAST(DATEDIFF(SECOND, a.ProcessStartDate, a.ProcessEndDate) % 60 AS VARCHAR), 2) AS TimeTaken
,BatchId,DisplayBatchCD,BatchName,ProcessStartDate
,ProcessEndDate,ProcessStatusId,DDAConversionStatusId,DeltaProcessStatusId,StageLoadStatusId,BRProcessStatusId
,MasterLoadStatusId,SuccessFileGenerationStatusId,AggregateStatusId,IsImmediate,EmailRequired
,IsActive
FROM BatchSchedule  a with (nolock) where a.tenantid = 38
ORDER BY a.BatchID DESC;

select * from refetlprocessstatus where tenantid = 38
 
/*
UPDATE a SET RecurringTime = '03:20:00.0000000' FROM RecurringScheduleJob a WHERE RecurringScheduleJobId = 72
*/
  
SELECT *
-- UPDATE b SET b.processstatusid = 2
-- UPDATE b SET ScheduledDateTime = GETDATE()
FROM BatchSchedule b WHERE BatchId = 92284
 
--====================================================================================================

select * from reportdetails where tenantid = 38 order by 1 desc;

select distinct json_value([value], '$.code') as code
from reportdetails r
cross apply openjson(r.reportfiledetails, '$.valuecolumn')
where json_value([value], '$.code') is not null and tenantid = 38;

select r.*
from reportdetails r
join (select distinct reportid from fn_dashboardreportsdetails(38)) fn on r.reportdetailsid = fn.reportid
where exists (
    select 1
    from openjson(r.reportfiledetails, '$.valuecolumn') as v
    where json_value(v.[value], '$.code') = 'percentagedistinctcount'
) and r.tenantid = 38  
and reportdetailsid not in
('6643','6755','6953','6580','6581','6585','6589','6595','6632','6651','6654','6655','6664','6665','6848','6849','6850','6851')
order by reportdetailsid;


SELECT DISTINCT  
       j.[ColumnName],  
       j.[AliasName]
FROM ReportDetails r
CROSS APPLY OPENJSON(r.ReportFileDetails, '$.AdvanceFilter')
     WITH (
         ColumnName NVARCHAR(200) '$.ColumnName',
         AliasName NVARCHAR(200) '$.AliasName'
     ) j
WHERE r.ReportDetailsId in (8907, 8908, 8909, 8910, 8911, 8912, 8913, 8914, 8920, 8921, 8922, 8923, 8924, 8925, 8926, 8927, 8868, 8870, 8878, 8879, 8880, 8881, 8882, 8890, 8891, 8892, 8893, 8894, 8895, 8852, 8851, 8853, 8951, 8936, 8937, 8939, 8932, 8933, 8934, 8935, 8948, 8949, 8950, 8944, 8943, 8942, 8945)
order by 1


SELECT DISTINCT  
       j.[Name] AS ColumnName,  
       j.[AliasName]
FROM ReportDetails r
CROSS APPLY OPENJSON(r.ReportFileDetails, '$.AliasNameList')
     WITH (
         [Name] NVARCHAR(200) '$.Name',
         AliasName NVARCHAR(200) '$.AliasName'
     ) j
WHERE r.ReportDetailsId IN (
    8851, 8852, 8853, 8932, 8933, 8934, 8935, 
    8936, 8937, 8939, 8942, 8943, 8944, 8945, 
    8948, 8949, 8950, 8951
)
ORDER BY j.[Name], j.AliasName;

--count
--percentagecount
--none
--percentagedistinctcount
--percentage
--sum
--distinct count
--avg
--====================================================================================================
with cte
as (
	select *
		,row_number() over (
			partition by reportdetailsid
			,ddauserid
			,tenantid
			,statusid
			,orgid
			,organizationtypecode order by reportusersid asc
			) as rn
	from reportusers
	--where reportdetailsid in (8943)
	)
select *
from cte
where rn > 1

--====================================================================================================

select * from rptdomainrelatedviews where domainrelatedviewid=2857
select * from idm.datasetcolumn where domainrelatedviewid=2857
select * from rptviewfields where domainrelatedviewid=2857

--update rptviewfields set lookuptable='whpsi_readylevel',lookupcolumn='assessmentlevelcode'
--where rptviewfieldsid='59832'


select * from RptDomainRelatedViews where DisplayName='WHPS_LASLinksDS'
select * from RptDomainRelatedViews where viewname='dbo.WHPSAPAllYearsViewChartDs'

select * from reportdetails where domainrelatedviewid = '2847' 

select * from IDM.DataSetColumn where DomainRelatedViewId=2880
select * from RptViewFields where DomainRelatedViewId=2880
  
select * from IDM.DataSetFormulaColumn where DataSetColumnId in (select DataSetColumnId from IDM.DataSetColumn where DomainRelatedViewId=2880)
select * from IDM.DataSetJoinColumnInfo where DataSetColumnId in (select DataSetColumnId from IDM.DataSetColumn where DomainRelatedViewId=2880)


--update a set a.tablename = 'AggRptK12StudentDetails' ,a.ColumnSchema = 'dbo', a.Formula = REPLACE(a.Formula,'K12School','[AggRptK12StudentDetails]')
--from IDM.DataSetColumn a where DomainRelatedViewId=2847
--and DataSetColumnId = 17386

--update a set a.tablename = 'AggRptK12StudentDetails' ,a.ColumnSchema = 'dbo', a.Formula = REPLACE(a.Formula,'K12School','[AggRptK12StudentDetails]')
--from IDM.DataSetColumn a where DomainRelatedViewId=2847
--and DataSetColumnId = 17387


--delete from IDM.DataSetJoinColumnInfo where DataSetJoinColumnInfoId in (708,709,711)

--update a
--set a.jointype = 'Inner Join'
--from IDM.DataSetJoinColumnInfo a 
--where DataSetJoinColumnInfoId in (712,713)

--====================================================================================================



--Blitz Report - Assessments - Middle
--Blitz Report - Assessments - High
--Blitz Report - Assessments - Elementary
--Students Blitz Report - Teacher - High

select ReportDetailsId,ReportFileDetails from reportdetails where tenantid = 38 
and ReportDetailsId in 
(9003)

select * from rptdomainrelatedviews where tenantid = 38 and ViewName = 'dbo.whpsblitzreportds'

select * from idm.datasetcolumn where tenantid = 38 and DomainRelatedViewId = 3670

select * from rptviewfields where tenantid = 38 and DomainRelatedViewId = 3670 

select * from IDM.DataSetFormulaColumn where tenantid = 38 

select * from IDM.DataSetJoinColumnInfo where tenantid = 38 
and datasetcolumnid in (select datasetcolumnid from idm.datasetcolumn where tenantid = 38 and DomainRelatedViewId = 3670)

select * from idm.datasetcolumn where tenantid = 38 and DomainRelatedViewId = 420






--School Year, Student School, Grade, Teacher, Dept
--School Year, School Name, Grade, Teacher, Dept


select * from LinkedReportMappedFileds where  ReportDetailsId in (9003)

select count(*) --delete
from main.whps_blitzreport where schoolyear = 2026 and tenantid = 38
select count(*) --delete
from stage.whps_blitzreport_audit where schoolyear = 2026 and tenantid = 38
select count(*) --delete
from stage.whps_blitzreport_noaction where schoolyear = 2026 and tenantid = 38
select count(*) --delete
from stage.whps_blitzreport_failedrecords where schoolyear = 2026 and tenantid = 38


select * from AVue_TemplateDependentAggTablesLoading
--delete from AVue_TemplateDependentAggTablesLoading where TemplateDependentAggTablesLoadingId=4

--insert into AVue_TemplateDependentAggTablesLoading
--select 'WHPS_StudentStandards','[dbo].[USP_WHPS_PAT_LevelMovement_Loading]','Aggregate',38,1,null,'DDAUser@DDA',getdate(),null,null,'@SchoolYear,@TenantId'


select distinct assessment from assessmentinfo where tenantid = 38
select distinct assessmentname from main.assessmentdetails where tenantid = 26

---=====================================================
SELECT ReportId,ReportName,AdvanceFilters,SubGroupColumns FROM fn_DashboardReportsDetails(38) 
WHERE DashboardName = 'Blitz Report - Assessments - Elementary'
union all 
SELECT ReportId,ReportName,AdvanceFilters,SubGroupColumns FROM fn_DashboardReportsDetails(38)
WHERE DashboardName = 'Blitz Report - Assessments - Middle'
union all
SELECT ReportId,ReportName,AdvanceFilters,SubGroupColumns FROM fn_DashboardReportsDetails(38) 
WHERE DashboardName = 'Blitz Report - Assessments - High'

select * from dashboard where tenantid = 38

SELECT ReportDetailsId, ReportFileDetails
FROM reportdetails 
WHERE tenantid = 38 
AND ReportDetailsId IN (SELECT ReportId FROM fn_DashboardReportsDetails(38) 
WHERE DashboardName = 'Blitz Report - Assessments - High')
AND NOT EXISTS (
    SELECT 1 
    FROM OPENJSON(ReportFileDetails, '$.ChildReportdisplaycolumnList') 
    WHERE JSON_VALUE(value, '$.Text') = 'AssessmentYear'
);


--UPDATE reportdetails 
--SET ReportFileDetails =
----select ReportFileDetails ,
--JSON_MODIFY(
--    ReportFileDetails,
--    'append $.ChildReportdisplaycolumnList',
--    JSON_QUERY('{"Value": 78733, "Text": "AssessmentYear", "Key": 0}')
--)
----from reportdetails
--WHERE tenantid = 38 
--AND ReportDetailsId IN (
--8907
--,8908
--,8909
--,8910
--,8911
--,8912
--,8913
--,8914
--,8920
--,8921
--,8922
--,8923
--,8924
--,8925
--,8926
--,8927
--);

SELECT 
    DashboardName,
    ReportId,
    ReportName,
    ReportType,
    AdvanceFilters,
    SubGroupColumns,
    ChildReportId,
    ChildReportName
FROM fn_DashboardReportsDetails(38)
ORDER BY DashboardName, ReportId;

select * from idm.StudentsSubgroup where tenantid = 38 and statusid=1

---=====================================================================================
SELECT
    GroupName,
    DashboardName,
    ReportId,
    ReportName,
    ReportType,

    -- Fixed Filters: show Y/N (now checking with quotes)
    CASE WHEN AdvanceFilters LIKE '%"School Year"%' THEN 'Y' ELSE 'N' END AS [School Year],
    CASE WHEN AdvanceFilters LIKE '%"School Category"%' THEN 'Y' ELSE 'N' END AS [School Category],
    CASE WHEN AdvanceFilters LIKE '%"School Name"%' THEN 'Y' ELSE 'N' END AS [School Name],
    CASE WHEN AdvanceFilters LIKE '%"Grade"%' THEN 'Y' ELSE 'N' END AS [Grade],
    CASE WHEN AdvanceFilters LIKE '%"Gender"%' THEN 'Y' ELSE 'N' END AS [Gender],
    CASE WHEN AdvanceFilters LIKE '%"Race/Ethnicity"%' THEN 'Y' ELSE 'N' END AS [Race/Ethnicity],
    CASE WHEN AdvanceFilters LIKE '%"ELL"%' THEN 'Y' ELSE 'N' END AS [ELL],
    CASE WHEN AdvanceFilters LIKE '%"Special Education Status"%' THEN 'Y' ELSE 'N' END AS [Special Education Status],
    CASE WHEN AdvanceFilters LIKE '%"504 Status"%' THEN 'Y' ELSE 'N' END AS [504 Status],
    CASE WHEN AdvanceFilters LIKE '%"IEP"%' THEN 'Y' ELSE 'N' END AS [IEP],
    CASE WHEN AdvanceFilters LIKE '%"Assessment Year"%' THEN 'Y' ELSE 'N' END AS [Assessment Year],

    -- Remaining Filters (Report Defined)
    LTRIM(RTRIM(
        REPLACE(
            REPLACE(
                REPLACE(
                    REPLACE(
                        REPLACE(
                            REPLACE(
                                REPLACE(
                                    REPLACE(
                                        REPLACE(
                                            REPLACE(
                                                REPLACE(AdvanceFilters,
                                                    '"School Year", ', ''),
                                                '"School Category", ', ''),
                                            '"School Name", ', ''),
                                        '"Grade", ', ''),
                                    '"Gender", ', ''),
                                '"Race/Ethnicity", ', ''),
                            '"ELL", ', ''),
                        '"Special Education Status", ', ''),
                    '"504 Status", ', ''),
                '"IEP", ', ''),
            '"Assessment Year", ', '')
    )) AS ReportDefinedFilters,
    ChildReportId,
    ChildReportName,
    ChildReportAdvanceFilters
FROM fn_DashboardReportsDetails(38)
where 
--(GroupName in ('Assessments','Discipline','Blitz Reports (District)','Blitz Reports (Teacher)','District - Assessments with Grades','Teacher Blitz Grade Level Assessments','PAT')
--)
 DashboardName in ('Attendance Dashboard (WHPS)','Blitz Report - Teacher','District (WHPS)','Enrollment Dashboard (WHPS)'
,'IT Data Imports','Principal','Principal (WHPS)','Quest','Student Performance')
and dashboardname not in ('Assessments with Courses','Blitz Report - Teacher','Discipline -  School')
ORDER BY GroupName,DashboardName, ReportId;
---=====================================================================================


select * from fn_dashboardreportsdetails(38) where dashboardname = 'PAT level movement'
select * from fn_dashboardreportsdetails(38) where dashboardname = 'PAT Standards Performance'
select ReportId	,ReportName,	ReportType ,DataSet, ChildReportDataSet,
ChildReportId,
ChildReportName,
ChildReportDataSet from fn_dashboardreportsdetails(38) where dashboardname = 'Attendance Dashboard (WHPS)'



select * from rptdomainrelatedviews where tenantid = 38 and DomainRelatedViewId=2696
select * from  rptviewfields   where DomainRelatedViewId=2696
select * from idm.datasetcolumn where DomainRelatedViewId=2696
--dbo.TotalPercentageUniqueStudentsDS

--insert into rptviewfields
--select 2764 as DomainRelatedViewId,'HispanicLatino'as	ColumnName,'HispanicLatino'as	DisplayName,'VARCHAR'	as DataType,
--null as LookupTable	, NULl as LookupColumn	,17 as SortOrder	, NULL as ColumnTableName	, 38 as TenantId	, 1 as StatusId	, 'DDAUser@DDA' as CreatedBy	,getdate() as CreatedDate	,NULL as ModifiedBy	,NULL as ModifiedDate	,NULL as SortbyColumnName
--NULL	NULL	16	NULL	38	1		2023-05-11 08:28:36.600	NULL	NULL	NULL

--dbo.WHPS_PATStandards_Vw

--dbo.WHPS_PATLevelMovementStudent_Vw
--dbo.WHPS_PAT_LevelMovement

select * from reportdetails order by 1 desc 
select * from idm.ddauser
	--,agg.MembershipDaysCount
	--,agg.PresentDaysCount
	--,agg.AbsentDaysCount
	--,agg.IsChronic
	--,agg.AbsentPercentage
	--,agg.Presentrate
	--,agg.AbsentRate
	--,agg.CurrentMonthAttendance

