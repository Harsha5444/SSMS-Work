select FORMAT(CAST([DateTimestamp] AT TIME ZONE 'Eastern Standard Time' AT TIME ZONE 'India Standard Time' AS DATETIME),'MMM dd h:mm:ss tt')
AS IST_Time,* from errorlogforusp order by ErrorId desc;
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
FORMAT(CAST([StartTime] AT TIME ZONE 'Eastern Standard Time' AT TIME ZONE 'India Standard Time' AS DATETIME),'MMM dd h:mm:ss tt') AS [OurStartTime],
FORMAT(CAST([Endtime] AT TIME ZONE 'Eastern Standard Time' AT TIME ZONE 'India Standard Time' AS DATETIME),'MMM dd h:mm:ss tt') AS [OurEndTime],
[StartTime],[EndTime],[ElapsedTime],[TotalExecutionTime],[EstimatedCPUtime],[EstimatedI/O],[TenantId] 
from HCS_ProcessLogStatistics (nolock)
order by [LogStatId] desc;


 --====================================================================================================

SELECT distinct o.type_desc AS ObjectType,SCHEMA_NAME(o.schema_id) AS SchemaName,
    o.name AS ObjectName,o.create_date,o.modify_date
FROM sys.sql_expression_dependencies d
INNER JOIN sys.objects o ON d.referencing_id = o.object_id
INNER JOIN sys.objects ro ON d.referenced_id = ro.object_id
WHERE ro.name = 'Henryinsights_IncidentIQAssetExport' AND ro.type = 'U' -- User tables only
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
,CAST(CAST(RecurringTime AS datetime) AT TIME ZONE 'Eastern Standard Time'AT TIME ZONE 'India Standard Time'AS time) AS IST_Time,DayoftheWeek,StatusId
FROM [dbo].[RecurringScheduleJob]
where tenantid = 4 
and statusid = 1  and DataSourceType in( 'SFTP','Dataset')
ORDER BY RecurringTime


SELECT 
FORMAT(a.ScheduledDateTime ,'MMM dd h:mm:ss tt') AS DataBaseTime,
FORMAT(CAST(a.[ScheduledDateTime] AT TIME ZONE 'Eastern Standard Time' AT TIME ZONE 'India Standard Time' AS DATETIME),'MMM dd h:mm:ss tt') AS IST_Time
,RIGHT('0' + CAST(DATEDIFF(SECOND, a.ProcessStartDate, a.ProcessEndDate) / 3600 AS VARCHAR), 2) + ':' +
RIGHT('0' + CAST((DATEDIFF(SECOND, a.ProcessStartDate, a.ProcessEndDate) % 3600) / 60 AS VARCHAR), 2) + ':' +
RIGHT('0' + CAST(DATEDIFF(SECOND, a.ProcessStartDate, a.ProcessEndDate) % 60 AS VARCHAR), 2) AS TimeTaken
,BatchId,DisplayBatchCD,BatchName,ProcessStartDate
,ProcessEndDate,ProcessStatusId,DDAConversionStatusId,DeltaProcessStatusId,StageLoadStatusId,BRProcessStatusId
,MasterLoadStatusId,SuccessFileGenerationStatusId,AggregateStatusId,IsImmediate,EmailRequired
,IsActive
FROM BatchSchedule a where a.tenantid = 4
ORDER BY a.BatchID DESC;

select * from refetlprocessstatus where tenantid = 4
 
/*
UPDATE a SET RecurringTime = '03:50:00.0000000' FROM RecurringScheduleJob a WHERE RecurringScheduleJobId = 80
*/
  
SELECT *
-- UPDATE b SET b.processstatusid = 2
-- UPDATE b SET ScheduledDateTime = GETDATE()
FROM BatchSchedule b WHERE BatchId = 2812
 
--====================================================================================================

select * from fn_dashboardreportsdetails(4) where groupname = 'PSO Dashboards'
select * from fn_dashboardreportsdetails(4) where dashboardname = 'P.O.W.E.R. Profiles - AAS'
select * from fn_dashboardreportsdetails(4) where dataset = 'HCSiReadyPersonalizedInstructionDS'
select * from fn_dashboardreportsdetails(4) where reportid in (2339)

--====================================================================================================

select * from rptdomainrelatedviews where tenantid = 4 and ViewName = 'dbo.HCSiReadyPersonalizedInstructionDS'

select * from idm.datasetcolumn where tenantid = 4 and DomainRelatedViewId = 420

select * from rptviewfields where tenantid = 4 and DomainRelatedViewId = 420 

select * from IDM.DataSetFormulaColumn where tenantid = 4 

select * from IDM.DataSetJoinColumnInfo where tenantid = 4 
and datasetcolumnid in (select datasetcolumnid from idm.datasetcolumn where tenantid = 4 and DomainRelatedViewId = 420)

select * from idm.datasetcolumn where tenantid = 4 and DomainRelatedViewId = 420

--====================================================================================================


--[dbo].[CreateHCSAssessmentiReady]

select* from RptDomainRelatedViews where viewname = 'dbo.HCSiReadyPersonalizedInstructionDS'
--update a set DataType = 'int' from rptviewfields a where domainrelatedviewid = 415 and RptViewFieldsId=37709
--update a set DataType = 'int' from idm.datasetcolumn a where domainrelatedviewid = 415 and DataSetColumnId=64945

select * from reffiletemplates where filetemplatename like '%usage%'
select * from TenantFileTemplateMapper where filetemplateid = 162

select * from TenantTemplateFieldMapper where TenantFileTemplateMapperId=443

select * from ErrorLogForUSP order by 1 desc

--delete from dbo.HCS_Assessment_AMIRAUsage where weeknumber = 12 
--delete from dbo.HCS_Assessment_AMIRAUsage_audit where weeknumber = 12 

--delete from main.HenryInsights_AMIRA_Usage where [Week] = '12'
--delete from Stage.HenryInsights_AMIRA_Usage_Audit  where [Week] = '12'
--delete from Stage.HenryInsights_AMIRA_Usage_NoAction  where [Week] = '12'
--delete from Stage.HenryInsights_AMIRA_Usage_FailedRecords  where [Week] = '12'

select distinct subject from dbo.HCS_Assessment_iReady


select * from fn_dashboardreportsdetails(4) where  reportid in (
4059
,4062
,4069
)

select * from BatchSchedule where batchid = 2758
select * from batchschedule where batchid = 2762
select * from filerecordcountstats where batchid = 2762
select * from reffiletemplates where filetemplateid = 128
select FileTemplateFieldId from filetemplatefield where filetemplateid = 128
select * from br.BusinessRule  where FileTemplateFieldId in (select FileTemplateFieldId from filetemplatefield where filetemplateid = 128
) and yearid = 9
select * from refyear
select * from stage.Henryinsights_AMIRA_FailedRecords where batchid = 2762

select * from recurringschedulejob

select * from main.HenryInsights_Diagnostic_Results_Math where StudentID='220497'
select * from main.HenryInsights_Diagnostic_Results_ELA where StudentID='220497'

--NormingWindow - ProjectionNoAdditionalGrowth - ProjectionTypicalGrowth - ProjectionStretchGrowth


select count(*) --delete
from main.HenryInsights_Diagnostic_Results_ELA where tenantid = 4 and schoolyear = 2026
select count(*) --delete
from stage.HenryInsights_Diagnostic_Results_ELA_audit where tenantid = 4 and schoolyear = 2026
select count(*) --delete
from stage.HenryInsights_Diagnostic_Results_ELA_noaction where tenantid = 4 and schoolyear = 2026
select count(*) --delete
from stage.HenryInsights_Diagnostic_Results_ELA_failedrecords where tenantid = 4 and schoolyear = 2026
 
---============================================
 
select count(*) --delete
from main.HenryInsights_Diagnostic_Results_Math where tenantid = 4 and schoolyear = 2026
select count(*) --delete
from stage.HenryInsights_Diagnostic_Results_Math_audit where tenantid = 4 and schoolyear = 2026
select count(*) --delete
from stage.HenryInsights_Diagnostic_Results_Math_noaction where tenantid = 4 and schoolyear = 2026
select count(*) --delete
from stage.HenryInsights_Diagnostic_Results_Math_failedrecords where tenantid = 4 and schoolyear = 2026


select * from HCS_Assessment_iReady where startdate = '11/04/2025'

select * from assessmentautomation

select PercentLessonsPassed from HCSiReadyPersonalizedInstructionDS

select * from reportdetails where DomainRelatedViewId=420 and reportfiledetails like '%DateRangeFull%'

select ReportDetailsId,ReportFileDetails from reportdetails where tenantid = 4 
and ReportDetailsId in 
(4346
)

select distinct week from main.HenryInsights_AMIRA_Usage where schoolyear = 2026
select distinct weeknumber from [HCS_Assessment_AMIRAUsage]


exec sp_depends HCSUserAVActivityDS
--dbo.HCS_UsageData_Vw
select * from filerecordcountstats where batchid = 2776

select * from RefFileTemplates where filetemplatename like '%iq%'

--Henryinsights_IncidentIQAssetExport
--Henryinsights_IncidentIQTicketsExport

exec sp_depends HCSIncidentIQAssestTicketsExportAVDS
exec sp_depends HCSIncidentIQAssetsExportAVDS
exec sp_depends HCSIncidentIQTicketsExportAVDS

--dbo.HCS_IncidentIQ_Assets_Tickets_Export_Vw
--dbo.HCS_IncidentIQAssetExport_Vw
--dbo.HCS_IncidentIQTicketsExport_Vw

--dbo.HCSIncidentIQAssestTicketsExportAVDS		HCSIncidentIQAssestTicketsExportAVDS
--dbo.HCSIncidentIQAssetsExportAVDS				HCSIncidentIQAssetsExportAVDS
--dbo.HCSIncidentIQTicketsExportAVDS			HCSIncidentIQTicketsExportAVDS


 select * from fn_dashboardreportsdetails(4) where dataset like '%HCSIncidentIQAssestTicketsExportAVDS%'
 select * from fn_dashboardreportsdetails(4) where dataset like '%HCSIncidentIQAssetsExportAVDS%'
 select * from fn_dashboardreportsdetails(4) where dataset like '%HCSIncidentIQTicketsExportAVDS%'


select * from main.Henryinsights_IncidentIQAssetExport
select * from main.Henryinsights_IncidentIQTicketsExport

select *from assessmentautomation
select * from [HCS_Assessment_iReadyPIS] where subject = 'reading' order by  cast(daterangestart as date)  desc

select * from [RefMAPRTIBandRanges] where minyear = '2026' 
select * from [RefMAPRTIBandRanges] where minyear = '2026' and Subject='Reading'

select * from [RefMAPRTIBandRanges] where minyear = '2020' and Subject='Algebra 1' and Term='Spring'

select concat(minscore,'-',maxscore),grade,* from [RefMAPRTIBandRanges] where cast(CreatedDate as date)='2025-11-18' 
and Subject = 'Reading' and term = 'Spring' 




--781	Mathematics	Winter	08	A - Beginning	Beginning	200	210  --100 210
--951	Mathematics	Spring	07	A - Beginning	Beginning	105	200  --105 210

--update [RefMAPRTIBandRanges] set maxscore = 210 where MAPRTIBandId=951



select * from main.HenryInsights_ASSESS_MAP_All where schoolyear = 2026 and TermName='Winter 2025-2026'
select * from stage.HenryInsights_ASSESS_MAP_All_audit where batchid = 2812