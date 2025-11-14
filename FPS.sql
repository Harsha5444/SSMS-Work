select CONVERT(VARCHAR(20), DateTimeStamp, 100) AS DataBaseTime,CONVERT(VARCHAR(20),(DateTimeStamp AT TIME ZONE 'UTC' AT TIME ZONE 'India Standard Time'),100) AS IST_Time,* from errorlogforusp order by ErrorId desc;
select CONVERT(VARCHAR(20), LogDateTime, 100) AS DataBaseTime,CONVERT(VARCHAR(20),(LogDateTime AT TIME ZONE 'UTC' AT TIME ZONE 'India Standard Time'),100) AS IST_Time,* from idm.apperrorlog order by EventId desc;
--==============================================================


SELECT distinct o.type_desc AS ObjectType,SCHEMA_NAME(o.schema_id) AS SchemaName,
    o.name AS ObjectName,o.create_date,o.modify_date
FROM sys.sql_expression_dependencies d
INNER JOIN sys.objects o ON d.referencing_id = o.object_id
INNER JOIN sys.objects ro ON d.referenced_id = ro.object_id
WHERE ro.name = 'FHS_Academy_ILP' AND ro.type = 'U' -- User tables only
    AND o.type IN ('V', 'P', 'FN', 'IF', 'TF') -- Views, Stored Procedures, Functions
ORDER BY o.type_desc, SchemaName, ObjectName;

--==============================================================

SELECT RecurringScheduleJobId,BatchId,BatchName,YearId,LastRunDate,DataSourceType,RecurringType,RecurringTime
,CAST(CAST(RecurringTime AS datetime) AT TIME ZONE 'UTC'AT TIME ZONE 'India Standard Time'AS time) AS IST_Time,DayoftheWeek,StatusId
FROM [dbo].[RecurringScheduleJob]
where tenantid = 35 
and statusid = 1
ORDER BY RecurringTime


SELECT 
CONVERT(VARCHAR(20), a.ScheduledDateTime, 100) AS DataBaseTime,
CONVERT(VARCHAR(20),(a.ScheduledDateTime AT TIME ZONE 'UTC' AT TIME ZONE 'India Standard Time'),100) AS IST_Time
,RIGHT('0' + CAST(DATEDIFF(SECOND, a.ProcessStartDate, a.ProcessEndDate) / 3600 AS VARCHAR), 2) + ':' +
RIGHT('0' + CAST((DATEDIFF(SECOND, a.ProcessStartDate, a.ProcessEndDate) % 3600) / 60 AS VARCHAR), 2) + ':' +
RIGHT('0' + CAST(DATEDIFF(SECOND, a.ProcessStartDate, a.ProcessEndDate) % 60 AS VARCHAR), 2) AS TimeTaken
,BatchId,DisplayBatchCD,BatchName,ProcessStartDate
,ProcessEndDate,ProcessStatusId,DDAConversionStatusId,DeltaProcessStatusId,StageLoadStatusId,BRProcessStatusId
,MasterLoadStatusId,SuccessFileGenerationStatusId,AggregateStatusId,IsImmediate,EmailRequired
,IsActive
FROM BatchSchedule a where a.tenantid = 28
ORDER BY a.BatchID DESC;

select * from refetlprocessstatus where tenantid = 35
 
/*
UPDATE a SET RecurringTime = '03:20:00.0000000' FROM RecurringScheduleJob a WHERE RecurringScheduleJobId = 72
*/
  
SELECT *
-- UPDATE b SET b.processstatusid = 2
-- UPDATE b SET ScheduledDateTime = GETDATE()
FROM BatchSchedule b WHERE BatchId = 92284
 
--==============================================================



select * from idm.Tenant
--28	Framingham Public Schools
--35	East Hartford Public Schools
--36	NSBoro
--37	Rochelle Schools

select * from RefFileTemplates where tenantid = 35 and filetemplatename like '%dibels%'
select * from fn_DashboardReportsDetails(35) where dashboardname = 'Discipline'
select * from fn_DashboardReportsDetails(35) where dashboardname = 'SBAC Performance Outcomes Dashboard'
--SBAC_Math (dbo.SBACMath)
exec sp_helptext SBACMath
--FROM Main.EH_SBAC_Math AS EH_SBAC_Math  
select * from fn_DashboardReportsDetails(28) where ReportId = 3231
select ActionTypeCode,SuspensionType from refactiontype where tenantid = 35 and SuspensionType is not null
--FPS_MCAS_2023 for Admins
--FPS_MCAS_Tierwithdemo
--FPS_MCAS2024withDemo
--FPS_MCAS2025_Prelimwithdemo
--FPS_MCASELA2024SchoolsOnly
--FPSiReady5LevelsDS
--FPSMCAS2025ELAwithdemo
select distinct SanctionType1,SanctionType2 from main.eh_lognew

--[FPSMCAS2023forAdmins]
exec sp_depends Rochelle_Attendance_Vw
select * from rptdomainrelatedviews where tenantid = 37

select * from RptDomainRelatedViews where tenantid = 35 and viewname like '%sbac%'
select * from ReportDetails  order by 1 desc
select * from Main.EH_SBAC_Math where tenantid = 35

select * from idm.tenant

kill 292

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
	ORDER BY CPU DESC
 
 select * from main.k12lea where tenantid=28 and schoolyear = 2026
 select * from main.k12school where tenantid=28 and schoolyear = 2026
 select * from refyear where tenantid=28 and yearvalue = '2026'
 select * from aggrptk12studentdetails where tenantid = 28 and schoolyear = 2025

select * from schoolevent where tenantid = 37 and schoolyear = 2025

 select getdate()


 select * from refyear where tenantid=28 and yearvalue = '2026'



select * from RefYear where TenantId=35 
select * from refproficiencylevel where TenantId=35 and sy=2026 --66
select * from refterm where TenantId=35 and schoolyear=2026 --16
select * from filetemplatefieldbyyear where TenantId=35 and YearId in (52) --YearId in (44,52) 5751
 

select * from fn_DashboardReportsDetails(35) where DashboardName in ('District')

select * from reportdetails where reportdetailsid = 3209
--3209

------update a set a.ReportDetailsName= concat(trim(a.ReportDetailsName),' Old')
------FROM reportdetails a
------where a.DomainRelatedViewId is null 
------and a.tenantid = 35 
------and a.reportdetailsname like '%sbac%' 
------and a.reportdetailsid  in (851,852,857,2198,2201,2202,2203,3082)

------UPDATE a
------SET a.ReportDetailsName = 
------    CONCAT(
------        LEFT(LTRIM(RTRIM(a.ReportDetailsName)), LEN(LTRIM(RTRIM(a.ReportDetailsName))) - 3),
------        'Old'
------    )
------FROM reportdetails a
------WHERE a.DomainRelatedViewId IS NULL
------  AND a.tenantid = 35
------  AND a.reportdetailsname LIKE '%sbac%'
------  AND a.reportdetailsid IN (851, 852, 857, 2198, 2201, 2202, 2203, 3082);


 
SELECT du.DDAUserId
	,du.DistrictStaffId
	,du.FirstName + ' ' + du.LastName AS UserName
	,du.UserLoginId
	,du.PrimaryEmailId
	,o.OrgName
	,r.RoleName
	,string_agg(m.ModuleName, '/ ') AS Modules
	,du.TenantId
FROM IDM.DDAUser AS du
LEFT JOIN IDM.UserRoleOrg AS duro ON du.TenantId = duro.TenantId
	AND du.DDAUserId = duro.DDAUserId
	AND duro.IsDefaultRole = 1
	AND duro.StatusId = 1
LEFT JOIN IDM.Org AS o ON o.TenantId = du.TenantId
	AND o.orgid = duro.orgid
LEFT JOIN IDM.DDARole AS r ON r.TenantId = du.TenantId
	AND r.RoleId = duro.RoleId
LEFT JOIN IDM.RoleModule AS rm ON rm.TenantId = duro.TenantId
	AND rm.roleid = duro.RoleId
LEFT JOIN IDM.Module AS m ON m.tenantid = du.TenantId
	AND m.ModuleId = rm.ModuleId
	AND m.StatusId = 1
LEFT JOIN refstatus AS rs ON 
	du.statusid = rs.statusid
	AND m.statusid = rs.statusid
WHERE 1 = 1
	AND du.statusid = 1
	AND rolename = 'District Admin' and du.tenantid = 35
GROUP BY du.DDAUserId
	,du.DistrictStaffId
	,du.FirstName
	,du.LastName
	,du.UserLoginId
	,du.PrimaryEmailId
	,o.OrgName
	,r.RoleName
	,du.TenantId
ORDER BY du.TenantId
	,o.OrgName
	,du.DDAUserId DESC
 
 select distinct assessment from assessmentinfo where tenantid = 37
 select distinct assessmentname from main.assessmentdetails where tenantid = 37

 

select * from main.EH_Students_NextSchool

select * from main.EH_StoredGrades where STUDENT_NUMBER='999015296' and schoolyear = 2024 and SECTION_NUMBER = 1 and COURSE_NUMBER = 'SSH07'

select * from main.EH_Sections
select * from main.EH_Teachers
select * from main.EH_Courses
select * from main.EH_StudentSections
select * from main.ChronicAbs

select * from RefFileTemplates where tenantid = 35 and FileTemplatename like '%sat%'

select * from sys.tables where name like '%sat%' and name like '%eh%'

select distinct schoolyear,assessmentcode
from main.assessmentdetails 
where tenantid = 35 and assessmentcode in ('SBAC', 'NGSS', 'MathSkills', 'IAB', 'DIBELS') and schoolyear >=2023
order by 2

select * from EH_StudentSummaryWithAllAss where SAT_MathScore is not null
select * from EH_StudentSummaryWithAllAss where districtstudentid = '999105138' and schoolyear =2024

select * from aggrptassessmentsubgroupdata where districtstudentid = '999105138' and schoolyear =2024
select * from aggrptk12studentdetails where tenantid = 35

SELECT *
FROM aggrptassessmentsubgroupdata
WHERE tenantid = 35
	AND IsLatest = 1
	AND ProficiencyDescription IS NOT NULL
	AND districtstudentid = '999105138'
	AND schoolyear = 2024
	AND AssessmentCode NOT IN ('SBAC', 'NGSS', 'MathSkills', 'IAB', 'DIBELS')

select * from refgrade where tenantid = 35
select * from reportdetails where tenantid = 35 order by 1 desc

		select distinct schoolyear as AVSchoolyear,AssessmentCode
		,cast(TestTakenDate as date) as TestTakenDate
		,case when cast(TestTakenDate as date) between y.begindate and y.enddate then 'True' else 'False' end as IsValid
		,y2.yearcode as ActualYear
		from AggrptAssessmentSubgroupData s
		join refyear y on s.tenantid = y.tenantid and s.schoolyear = y.yearcode 
		join refyear y2 on s.tenantid = y2.tenantid and cast(TestTakenDate as date) between y2.begindate and y2.enddate
		where s.tenantid = 35 and cast(TestTakenDate as date) not between y.begindate and y.enddate
		order by AssessmentCode,schoolyear,cast(TestTakenDate as date)

select * from AggrptAssessmentSubgroupData where assessmentcode = 'sbac' and tenantid = 35
select * from dataimportviews where tenantid = 28  

SELECT 
    t.name AS TableName,
    t.create_date
FROM sys.tables t
--WHERE CAST(t.create_date AS DATE) = '2025-08-14'
--where t.name like '%ref%'
ORDER BY t.create_date DESC;

select AssessmentLevelCode,	AssessmentLevelDescription,SortOrder
TenantId
,StatusId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate from AnalyticVue_FPS..FPSACCESSAssessmentLevel

select * from FPSACCESSAssessmentLevel

select * from WHPSAssessmentAllDS



select * from [dbo].[Import_SBAC_NGSS_K12StudentGenericAssessment_Vw_35]
select * from [dbo].[Import_SAT_PSAT_K12StudentGenericAssessment_Vw_35]
select * from [dbo].[Import_MathSkills_K12StudentGenericAssessment_Vw_35]
select * from [dbo].[Import_IAB_K12StudentGenericAssessment_Vw_35]
select * from [dbo].[Import_DIBELS_K12StudentGenericAssessment_Vw_35]


select * from Main.EH_DIBELS --ClientDate

select * from Main.EH_IAB_ELA  --TestCompletionDate
select * from Main.EH_IAB_MATH  --TestCompletionDate


select * from Main.EH_SBAC_ELA  --DateTaken
select * from Main.EH_SBAC_Math  --DateTaken

select * from Main.EH_NGSS  --DateTaken

select * from Main.EH_SAT  --LATEST_SAT_DATE
select * from Main.EH_PSAT  --LATEST_PSAT_DATE

select * from Main.EH_K_5MathSkills --no testdate column

SELECT DISTINCT 
    s.SchoolYear AS AVSchoolYear,
    'SBAC_ELA' AS AssessmentCode,
    CAST(s.DateTaken AS DATE) AS TestTakenDate,
    CASE WHEN CAST(s.DateTaken AS DATE) BETWEEN y.BeginDate AND y.EndDate 
         THEN 'True' ELSE 'False' END AS IsValid,
    y2.YearCode AS ActualYear
FROM Main.EH_SBAC_ELA s
JOIN refyear y  ON s.TenantId = y.TenantId AND s.SchoolYear = y.YearCode
JOIN refyear y2 ON s.TenantId = y2.TenantId AND CAST(s.DateTaken AS DATE) BETWEEN y2.BeginDate AND y2.EndDate
WHERE s.TenantId = 35
  AND CAST(s.DateTaken AS DATE) NOT BETWEEN y.BeginDate AND y.EndDate
ORDER BY s.SchoolYear, CAST(s.DateTaken AS DATE);

SELECT DISTINCT 
    s.SchoolYear AS AVSchoolYear,
    'SBAC_MATH' AS AssessmentCode,
    CAST(s.DateTaken AS DATE) AS TestTakenDate,
    CASE WHEN CAST(s.DateTaken AS DATE) BETWEEN y.BeginDate AND y.EndDate 
         THEN 'True' ELSE 'False' END AS IsValid,
    y2.YearCode AS ActualYear
FROM Main.EH_SBAC_Math s
JOIN refyear y  ON s.TenantId = y.TenantId AND s.SchoolYear = y.YearCode
JOIN refyear y2 ON s.TenantId = y2.TenantId AND CAST(s.DateTaken AS DATE) BETWEEN y2.BeginDate AND y2.EndDate
WHERE s.TenantId = 35
  AND CAST(s.DateTaken AS DATE) NOT BETWEEN y.BeginDate AND y.EndDate
ORDER BY s.SchoolYear, CAST(s.DateTaken AS DATE);

SELECT DISTINCT 
    s.SchoolYear AS AVSchoolYear,
    'SAT' AS AssessmentCode,
    CAST(s.LATEST_SAT_DATE AS DATE) AS TestTakenDate,
    CASE WHEN CAST(s.LATEST_SAT_DATE AS DATE) BETWEEN y.BeginDate AND y.EndDate 
         THEN 'True' ELSE 'False' END AS IsValid,
    y2.YearCode AS ActualYear
FROM Main.EH_SAT s
JOIN refyear y  ON s.TenantId = y.TenantId AND s.SchoolYear = y.YearCode
JOIN refyear y2 ON s.TenantId = y2.TenantId AND CAST(s.LATEST_SAT_DATE AS DATE) BETWEEN y2.BeginDate AND y2.EndDate
WHERE s.TenantId = 35
  AND CAST(s.LATEST_SAT_DATE AS DATE) NOT BETWEEN y.BeginDate AND y.EndDate
ORDER BY s.SchoolYear, CAST(s.LATEST_SAT_DATE AS DATE);

SELECT DISTINCT 
    s.SchoolYear AS AVSchoolYear,
    'PSAT' AS AssessmentCode,
    CAST(s.LATEST_PSAT_DATE AS DATE) AS TestTakenDate,
    CASE WHEN CAST(s.LATEST_PSAT_DATE AS DATE) BETWEEN y.BeginDate AND y.EndDate 
         THEN 'True' ELSE 'False' END AS IsValid,
    y2.YearCode AS ActualYear
FROM Main.EH_PSAT s
JOIN refyear y  ON s.TenantId = y.TenantId AND s.SchoolYear = y.YearCode
JOIN refyear y2 ON s.TenantId = y2.TenantId AND CAST(s.LATEST_PSAT_DATE AS DATE) BETWEEN y2.BeginDate AND y2.EndDate
WHERE s.TenantId = 35
  AND CAST(s.LATEST_PSAT_DATE AS DATE) NOT BETWEEN y.BeginDate AND y.EndDate
ORDER BY s.SchoolYear, CAST(s.LATEST_PSAT_DATE AS DATE);




select * from main.k12studentgenericassessment where assessmentcodeid in (
select assessmentdetailsid from main.assessmentdetails where tenantid = 35 and assessmentcode = 'dibels')


select * from fn_DashboardReportsDetails(37) where dashboardname = 'discipline'

select * from main.k12lea where tenantid = 37
select * from reportdetails where tenantid = 37 order by 1 desc

--Rochelle COMMUNITY SCHOOL DISTRICT



select * from idm.apperrorlog order by 1 desc

select * from [IDM].[StudentsSubgroup] where tenantid=35

--insert into idm.StudentsSubgroup
--select 'School Year' as SubgroupName, 'SY' as Code ,1 as StatusId,16 as	SortOrder,35 as 	TenantId,'DDAAdmin' as 	CreatedBy, Getdate() as CreatedDate,null as ModifiedBy, null as ModifiedDate,
--1 as DisplayInDashboard, 0 as DisplayRosterView, 'SchoolYear' as ColumnName

--update idm.StudentsSubgroup set SubgroupName = 'School Year' where StudentsSubgroupId=471



exec sp_depends ehdisciplinelogds

select * from EHDisciplineLogDS where districtstudentid = '999010896'

select distinct student_number from Main.eh_lognew where (sanctiontype2 = '1000' ) and schoolyear = 2025

exec [dbo].[USP_GetStudentAbsenceRptData] @tenantid='35',@SchoolId=NULL,@keyvalue='D-AR',@SchoolYear='2026'

select * from AggRptK12StudentAbsentReasons where tenantid = 35 and schoolyear = 2026 and AbsentReason='unExcused Absence' and schoolidentifier is not null
select avg(absentreasonrate) from AggRptK12StudentAbsentReasons where tenantid = 35 and schoolyear = 2026 and AbsentReason='Excused Absence' and schoolidentifier is not null
--USP_DataGenDynamic_K12StudentAttendance

select * from #TempAI_ALLTenantsData 
ORDER BY SchoolYear desc, SchoolName, Gender desc, Race desc;

select SchoolYear,SchoolName,sum(enrollmentno) as enrollmentno from #TempAI_ALLTenantsData 
group by schoolyear,schoolname
ORDER BY SchoolYear desc, SchoolName

select * from staffsummaryviewFields where tenantid = 28 and statusid = 1 order by sortorder
select * from staffsummaryviewFields where tenantid = 28 and statusid = 1 and GroupHeader='i-Ready Proficiency'
select * from staffsummaryviewFields order by 1 desc
--insert into staffsummaryviewFields
select 'MCASMathProficiencyStudentData','FPSMCASMathProficiencyLevelStudentData',NULL,'MCASMathProfciencyLevel','Math','MCAS Proficiency','0',null,null,0,null,null,null,null,'String',null,null,null,2024,'k12StudentGenericAssessment','MCAS','Math',1,0,0,8,28,1,'ddauser@dda',getdate(),null,null,0,0,1,0,0,0,0,null union all
select 'MCASSciProficiencyStudentData','FPSMCASSciProficiencyLevelStudentData',NULL,'MCASSciProfciencyLevel','Sci','MCAS Proficiency','0',null,null,0,null,null,null,null,'String',null,null,null,2024,'k12StudentGenericAssessment','MCAS','Sci',1,0,0,8,28,1,'ddauser@dda',getdate(),null,null,0,0,1,0,0,0,0,null union all
select 'MCASELAProficiencyStudentData','FPSMCASELAProficiencyLevelStudentData',NULL,'MCASELAProfciencyLevel','ELA','MCAS Proficiency','0',null,null,0,null,null,null,null,'String',null,null,null,2024,'k12StudentGenericAssessment','MCAS','ELA',1,0,0,8,28,1,'ddauser@dda',getdate(),null,null,0,0,1,0,0,0,0,null

--StaffSummaryViewFieldsId
--237
--236
--235

select * from idm.apperrorlog order by 1 desc
select * from errorlogforusp order by 1 desc

select * from StaffSummaryViewFieldsByUser where tenantid = 28 and statusid = 1 order by 1 desc

--insert into StaffSummaryViewFieldsByUser
select 235,null,8,28,1,'ddauser@dda',getdate(),null,null union all
select 236,null,8,28,1,'ddauser@dda',getdate(),null,null union all 
select 237,null,8,28,1,'ddauser@dda',getdate(),null,null

--insert into StaffSummaryViewFieldByGrade
select 
'235' as StaffSummaryViewFieldsId
,GradeId
,SortOrder
,TenantId
,StatusId
,CreatedBy
,getdate() as CreatedDate
,ModifiedBy
,ModifiedDate
from StaffSummaryViewFieldByGrade where tenantid = 28 and statusid = 1 and  StaffSummaryViewFieldsId=149 and gradeid < 11 and gradeid >2
union all
select 
'236' as StaffSummaryViewFieldsId
,GradeId
,SortOrder
,TenantId
,StatusId
,CreatedBy
,getdate() as CreatedDate
,ModifiedBy
,ModifiedDate
from StaffSummaryViewFieldByGrade where tenantid = 28 and statusid = 1 and  StaffSummaryViewFieldsId=149 and gradeid < 11 and gradeid >2
union all
select 
'237' as StaffSummaryViewFieldsId
,GradeId
,SortOrder
,TenantId
,StatusId
,CreatedBy
,getdate() as CreatedDate
,ModifiedBy
,ModifiedDate
from StaffSummaryViewFieldByGrade where tenantid = 28 and statusid = 1 and  StaffSummaryViewFieldsId=149 and gradeid < 11 and gradeid >2



exec USP_GetIReadyDomainReportDrilldownData_lvl5 @UserId=1,@TenantId=28,@SchoolYear='2026',@sectionId=NULL,@courseId=NULL,@subject='Reading',
@SchoolId='AdultESL,BAR,BRO,CAM,DUN,FHS,FUL,HAR,HEM,JUN,KNG,MCC,POT,STA,ALT,WAL',@Grade=NULL,@StaffIds=NULL,
@STARTRECORD=0,@RECORDS=5606,@SORTBY='StudentName',@SORTTYPE='asc',@IsALLRecords=0,@ValueFilters=NULL,@ColorFilters=NULL,@FieldDataType='',
@CohortFilters=NULL,@SubgroupFilter=NULL,
@ProficiencyLevel='3 or More Grade Levels Below',@StandardAreaCode='Vocabulary',@IsCohortStudents=0


SELECT DISTINCT 
    a.RecurringScheduleJobId,
    'Rochelle' AS District,
    a.DataSourceType,
    a.RecurringType,
    a.BatchName,
    c.FileTemplateName,
    CONVERT(VARCHAR(20), DATEADD(HOUR, -6, a.RecurringTime), 100) AS EST,  -- AM/PM format
    CONVERT(VARCHAR(20), a.RecurringTime, 100) AS UTC,
    CONVERT(VARCHAR(20), DATEADD(MINUTE, 330, a.RecurringTime), 100) AS IST,
    a.RecurringTime
FROM RecurringScheduleJob a
JOIN RecurringScheduleJobTemplate b 
    ON a.RecurringScheduleJobId = b.RecurringScheduleJobId
   AND a.TenantId = b.TenantId
JOIN RefFileTemplates c 
    ON b.FileTemplateID = c.FileTemplateId
   AND a.TenantId = c.TenantId
JOIN Refyear y on a.tenantid = y.tenantid and a.yearid = y.yearid
WHERE a.TenantId = 35 and y.yearcode = '2026' AND a.statusid = 2 --and cast(a.lastrundate as date) <> cast(getdate() as date)
ORDER BY a.RecurringTime ASC;


SELECT tenantid,tenantname,tenantcode FROM AnalyticVue_Hallco.idm.tenant UNION ALL
SELECT tenantid,tenantname,tenantcode FROM AnalyticVue_norwood.idm.tenant UNION ALL
SELECT tenantid,tenantname,tenantcode FROM AnalyticVue_district.idm.tenant UNION ALL
SELECT tenantid,tenantname,tenantcode FROM AnalyticVue_obs.idm.tenant UNION ALL
SELECT tenantid,tenantname,tenantcode FROM AnalyticVue_fps.idm.tenant UNION ALL
SELECT tenantid,tenantname,tenantcode FROM AnalyticVue_clayton.idm.tenant

exec USP_GetIReadyDomainReportDrilldownData_lvl5 @UserId=1,@TenantId=28,@SchoolYear='2026',@sectionId=NULL,@courseId=NULL,@subject='Reading',
@SchoolId='AdultESL,BAR,BRO,CAM,DUN,FHS,FUL,HAR,HEM,JUN,KNG,MCC,POT,STA,ALT,WAL',@Grade=NULL,@StaffIds=NULL,
@STARTRECORD=0,@RECORDS=5606,@SORTBY='StudentName',@SORTTYPE='asc',@IsALLRecords=0,@ValueFilters=NULL,@ColorFilters=NULL,@FieldDataType='',
@CohortFilters=NULL,@SubgroupFilter=NULL,
@ProficiencyLevel='3 or More Grade Levels Below',@StandardAreaCode='Vocabulary',@IsCohortStudents=0
 
 
 select * from reportdetails where reportdetailsid = 3231


exec sp_depends FPS_MCASItemStudentTeacherResults_Maths_View


select * from fn_DashboardReportsDetails(28) where ReportId = 3231

select distinct schoolname from FPS_AggrptMCASItemStudentResults
select * from FPS_AggrptMCASItemStudentResults where schoolname is null

select * from main.k12school where tenantid = 28 and schoolyear = 2025


select distinct sprp_sch,sprp_sch_name from main.fps_mcas_2025

--sprp_sch_name
--sprp_sch

select  87427+87695+38480



select * from fn_dashboardreportsdetails(35) where  dashboardname='LAS Links'
select * from fn_dashboardreportsdetails(35) where  dashboardname='LAS Links APTA – Literacy & Oral'
select * from fn_dashboardreportsdetails(35) where  dashboardname='SBAC Performance Outcomes Dashboard'
select * from fn_dashboardreportsdetails(35) where  dashboardname='SBAC Math'

--EHLASLinksDS (dbo.EHLASLinksDS)

exec sp_helptext EHLASLinksDS

exec sp_helptext EH_LASGrowth_VW



--update reportdetails
--set reportfiledetails = json_modify(
--        json_modify(reportfiledetails, '$.displaylatestyeardata', cast(0 as bit)),
--        '$.displaylastyeardata', cast(1 as bit)
--    )
--where reportdetailsid in (
--'3093'
--,'3095'
--)

--main.EH_LAsGrowthTargets

select * from idm.AppErrorLog order by 1 desc
select * from ErrorLogForUSP order by 1 desc

--3680
--3682

select * from ReportDetails where reportdetailsname like '%not met%'order by 1 desc
select * from ReportDetails where reportdetailsname like '%capped%'order by 1 desc
select * from ReportDetails order by 1 desc

--update  dashboard
--set statusid = 1
--where tenantid = 28 and DashboardId=299

select *from dashboard where tenantid = 28 and DashboardId=299

SELECT a.[SchoolYear]
	,a.[DistrictStudentId]
	,a.[StateStudentID]
	,a.[StudentFullName]
	,a.[SchoolIdentifier]
	,a.[SchoolName]
	,a.[Gender]
	,a.[Grade]
	,a.[SchoolCategory]
	,a.[Race]
	,a.[Subject]
	,a.[DateTaken]
	,a.[TestReason]
	,a.[TestOppNumber]
	,a.[TestCompletionDate]
	,a.[ScaleScore]
	,a.[PerformanceIndex]
	,a.[PIndex]
	,a.[AchievementLevel]
	,a.[AchievementSubLevel]
	,a.[GrowthTarget]
	,a.[GrowthStatus]
	,a.[ScaleScoreStandardError]
	,a.[SummativePerformance]
	,b.SchoolYear AS FromYear
	,a.SchoolYear AS ToYear
	,b.AchievementLevel AS FromLevel
	,a.AchievementLevel AS ToLevel
	,CASE 
		WHEN CAST(REPLACE(a.AchievementLevel, 'Level - ', '') AS INT) - CAST(REPLACE(b.AchievementLevel, 'Level - ', '') AS INT) > 0
			THEN CONCAT (
					CAST(REPLACE(a.AchievementLevel, 'Level - ', '') AS INT) - CAST(REPLACE(b.AchievementLevel, 'Level - ', '') AS INT)
					,' Level Up'
					)
		WHEN CAST(REPLACE(a.AchievementLevel, 'Level - ', '') AS INT) - CAST(REPLACE(b.AchievementLevel, 'Level - ', '') AS INT) < 0
			THEN CONCAT (
					CAST(REPLACE(b.AchievementLevel, 'Level - ', '') AS INT) - CAST(REPLACE(a.AchievementLevel, 'Level - ', '') AS INT)
					,' Level Down'
					)
		WHEN CAST(REPLACE(a.AchievementLevel, 'Level - ', '') AS INT) - CAST(REPLACE(b.AchievementLevel, 'Level - ', '') AS INT) = 0
			THEN 'No Change'
		ELSE 'No Prior Data'
		END AS [Status]
	,a.[ELL]
	,a.[CohortGraduationYear]
	,a.[FRL]
	,a.[SpecialEdStatus]
	,a.[504Status]
	,a.[TenantId]
	,a.[IEP]
	,a.[HighNeedsCategory]
FROM EH_SBAC_StudentPerformanceGrowth_Vw a
LEFT JOIN EH_SBAC_StudentPerformanceGrowth_Vw b ON a.DistrictStudentId = b.DistrictStudentId
	AND a.Subject = b.Subject
	AND a.SchoolYear = (b.SchoolYear + 1)





---==============================================SBAC performce validation 

select  * from Main.EH_SBAC_Math where schoolyear = 2023 and SummativePerformance in ('Level 3','Level 4')
select  * from Main.EH_SBAC_ELA where schoolyear = 2023 and SummativePerformance in ('Level 3','Level 4')

select  * from Main.EH_SBAC_Math where schoolyear = 2024 and DistrictStudentId = '999015040'
select  * from Main.EH_SBAC_Math where schoolyear = 2025 and DistrictStudentId = '999015040'

select  * from Main.EH_SBAC_ELA where schoolyear = 2024 and DistrictStudentId = '999015040'
select  * from Main.EH_SBAC_ELA where schoolyear = 2025 and DistrictStudentId = '999015040'

select * from FPSHSgradesterm12026
select * from reffiletemplates where tenantid = 28 and filetemplatename like '%ilp%'

select * from main.FPS_FHSgrades

select 
StudentName
,LASID as DistrictStudentId
,EnrollStatus_012 as EnrollmentStatus
,Guidance_Counselor as [GuidanceCounselor]
,Course
,Term
,YearID
,Teacher
,Credit
,[First]
,[Second]
,Third
,Fourth
,FINAL
,SchoolYear
,TenantId
,Department
,Support
from main.FPS_FHSgradesLatestYear	where schoolyear = 2026
select * from stage.FPS_FHSgradesLatestYear_audit	where schoolyear = 2026
select * from stage.FPS_FHSgradesLatestYear_failedrecords where schoolyear = 2026

select * from main.FPS_FHSgradesLatestYear	where schoolyear = 2026 and lasid = 162512
select * from stage.FPS_FHSgradesLatestYear_failedrecords where schoolyear = 2026 and lasid = 162512

select * from main.FHS_Academy_ILP

select * from main.FPS_FHSgradesLatestYear where schoolyear = 2026 

 
select count(*) --delete
from main.FPS_MCAS_ItemAnalysis_Math_ELA_Science where tenantid = 28 and schoolyear = 2026
select count(*) --delete
from stage.FPS_MCAS_ItemAnalysis_Math_ELA_Science_audit where tenantid = 28 and schoolyear = 2026
select count(*) --delete
from stage.FPS_MCAS_ItemAnalysis_Math_ELA_Science_noaction where tenantid = 28 and schoolyear = 2026
select count(*) --delete
from stage.FPS_MCAS_ItemAnalysis_Math_ELA_Science_failedrecords where tenantid = 28 and schoolyear = 2026


select * from MAIN.FPS_MCAS_ItemAnalysis_Math_ELA_Science
--[dbo].[USP_UpdateCurrentSuccessRecordsCount]

--exec [dbo].[USP_UpdateCurrentSuccessRecordsCount] 28