--exec usp_getreportanalyticsquestion @questioncode='q115',@tenantid=38

--exec [dbo].[datavisulaizerreportsspdriven] @tenantid=26,@spname='datavisulaizerassessmentreport',@categoryfields=' isnull(x.schoolyear,'''') as [school year],  isnull(x.grade,'''') as [grade],  dbo.[refgrade].sortorder as [refgrade]',@seriesfields=' x.proficiencydescription as [proficiencydescription]',@groupbyseries=' x.proficiencydescription ',@groupbycolumns=' x.schoolyear,  x.grade ,  dbo.[refgrade].sortorder',@wherecondtion=' x.subject in ( ''mathematics'') and x.assessment in ( ''mcas'') and x.schoolyear in ( ''2024'') and x.islatest = 1',@sortorderfileds='[school year]  asc ,  [refgrade] asc,  [grade]  asc',@joinstables=' inner join dbo.[refgrade] on  x.grade = dbo.[refgrade].[gradedescription] and x.tenantid =dbo.[refgrade].tenantid  ',@userid=15,@subquerycondition='[school year], [grade]',@dynamicfields=' [school year]  varchar(max),  [grade]  varchar(max),  [refgrade]  int',@finalselectcolumns=' [school year],  [grade]',@istesttaken=1,@isfilteredoncohort=0,@subcategorycolumns=' [school year],  [grade], [refgrade]',@studentlist =null

select * from idm.tenant;
--26	duxbury public schools
--38	west hartford public schools
--44	monomoy regional school district
--53	regional school district 10
select * from idm.ddarole where tenantid = 38;
select * from idm.apperrorlog order by 1 desc;

select distinct dataset from fn_dashboardreportsdetails(38) where  dataset like '%whps_baselineclaim_ds%'
select * from fn_dashboardreportsdetails(38) where  dashboardname='acuity matrix'
select * from fn_dashboardreportsdetails(38) where  groupname in ('blitz reports','district - assessments with grades','teacher blitz grade level assessments')
--8932
--8933
--8934
--8935
--8936
--8937
--8939
--whpspatalllevelmovementds
--whpspatlevelmovementstudentds

select * from rptdomainrelatedviews where viewname like 'dbo.whpsbaselineclaimds'

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

--count
--percentagecount
--none
--percentagedistinctcount
--percentage
--sum
--distinct count
--avg

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
	where reportdetailsid in (8948)
	)
select *
from cte
where rn > 1


select * from idm.studentssubgroup where tenantid = 38

--subgroupname
--code
--statusid
--sortorder
--tenantid
--createdby
--createddate
--modifiedby
--modifieddate
--displayindashboard
--displayrosterview
--columnname

--insert into idm.studentssubgroup
--select 'schoolyear' as subgroupname, 'sy' as code ,1 as statusid,17 as	sortorder,38 as 	tenantid,'ddaadmin' as 	createdby, getdate() as createddate,null as modifiedby, null as modifieddate,
--1 as displayindashboard, 1 as displayrosterview, 'schoolyear' as columnname

--update idm.studentssubgroup set subgroupname = 'school year' where studentssubgroupid=471



--create nonclustered index [ncisx_reportusers_r] on [dbo].[reportusers] ([reportdetailsid]) 

--drop index ncisx_reportusers_r on  reportusers

select * from dbo.whps_studentsummarywithallass
--exec sp_depends whps_blitzreportdistrict_vw
--exec sp_helptext whpsassessmentallds_vw

select * from reffiletemplates where tenantid = 38 and filetemplatename like '%att%';

--1) we have "null" and "n/a" in period
--select distinct [period] from main.whps_aimswebplus order by [period]
--2) we have null for [relatedform] from which we are deriving subject
--select distinct [relatedform] from main.whps_aimswebplus order by 1
--3) we have administrationdate & period missmatch example: spring dates but period is winter
--select distinct cast(e.administrationdate as date) as administrationdate,period
--from main.whps_aimswebplus e
--order by cast(e.administrationdate as date)  desc

select  e.administrationdate,period,r.termcode from main.whps_aimswebplus e
join refterm r
    on e.schoolyear = r.schoolyear
	    and r.termcode in  ('spring','winter','fall','summer')
    and r.tenantid = 38
	--and (period is null or period = 'n/a')
where cast(e.administrationdate as date) between r.startdate and r.enddate
and e.schoolyear = 2025
order by cast(e.administrationdate as date) desc

select s.nameofinstitution,c.schoolcategorycode from main.k12school s
join refschoolcategory c on s.tenantid = c.tenantid
and s.schoolcategoryid = c.schoolcategoryid
where s.tenantid = 38 and schoolyear = 2025
order by c.sortorder

 
--update refterm
--set displayorder = case termcode
--    when 'q1' then 1
--    when 'q2' then 2
--    when 'e1' then 3
--    when 's1' then 4
--    when 'b1' then 5
--    when 'b2' then 6
--    when 'q3' then 7
--    when 'q4' then 8
--    when 'e2' then 9
--    when 's2' then 10
--    when 'b3' then 11
--    when 'b4' then 12
--end
--where tenantid = 38
--  and schoolyear = 2025
--  and termcode in ('q1','q2','e1','s1','b1','b2','q3','q4','e2','s2','b3','b4');







select ds.[schoolname] as [schoolname]
	,ds.[acuitytier] as [acuitytier]
	,count(distinct ds.[districtstudentid]) as [districtstudentid]
	,(
		select count(distinct subds.[districtstudentid])
		from dbo.whpsacuitymatrixds as subds with (nolock)
		left join dbo.refproficiencylevel on subds.[acuitytier] = dbo.refproficiencylevel.proficiencydescription
			and subds.tenantid = dbo.refproficiencylevel.tenantid
		where subds.[acuitytier] = ds.[acuitytier]
			and subds.[gradecode] = ('6')
			and subds.[schoolyear] in (2025)
			and (subds.tenantid = 38)
		) as [seriestotalcount]
from dbo.whpsacuitymatrixds as ds with (nolock)
left join dbo.refproficiencylevel on ds.[acuitytier] = dbo.refproficiencylevel.proficiencydescription
	and ds.tenantid = dbo.refproficiencylevel.tenantid
where (
		(ds.[gradecode] = '6')
		--(ds.[schoolyear] in (2025))
		and (ds.tenantid = 38)
		)
group by ds.[schoolname]
	,ds.[acuitytier]
	,dbo.refproficiencylevel.sortorder
order by ds.[schoolname] asc
	,dbo.refproficiencylevel.sortorder asc
	,ds.[acuitytier] asc

--sp_helptext whps_acuitymatrix_vw


	select distinct schoolyear from aggrptk12studentdetails
	select distinct schoolyear from whps_acuitymatrix_vw
	select distinct schoolyear from whps_homeroomteacher_vw

--	dbo.aggrptk12studentdetails
--dbo.whps_acuitymatrix_vw
--dbo.whps_homeroomteacher_vw




select ds.schoolyear as [school year]
	,count(ds.districtstudentid) as [count]
	,(
		select count(subds.districtstudentid)
		from dbo.aggrptk12studentdetails as subds with (nolock)
		where subds.schoolyear = ds.schoolyear
			and subds.[grade] in ('k', 'grade 1', 'grade 2', 'grade 3', 'grade 4', 'grade 5', 'grade 6', 'grade 7', 'grade 8', 'grade 9', 'grade 10', 'grade 11', 'grade 12', 'grade 13')
			and (subds.tenantid = 38)
		) as [seriestotalcount]
from dbo.aggrptk12studentdetails as ds with (nolock)
where (
		(ds.grade in ('k', 'grade 1', 'grade 2', 'grade 3', 'grade 4', 'grade 5', 'grade 6', 'grade 7', 'grade 8', 'grade 9', 'grade 10', 'grade 11', 'grade 12', 'grade 13'))
		and (isnumeric(ds.presentrate) = 1)
		and (cast(ds.presentrate as decimal(18, 2)) >= '95')
		and (ds.tenantid = 38)
		)
group by ds.schoolyear
	,ds.[schoolyear]
order by ds.[schoolyear] asc


select * from reportdetails 
where tenantid = 38  
and domainrelatedviewid in (3671,3670) 
and reportfiledetails like '%q1_per%' 
and reporttypeid = 101
order by 1 desc


--8950
--8949
--8948
--8945
--8944
--8943
--8942
--8853
--8851



select * from aggrptk12studentdetails where 1=1 and schoolyear= 2024 and districtstudentid = '117733'

select * from reportdetails where reportdetailsid = 7032

select * from main.k12studentdailyattendance where tenantid = 38 and schoolyear = 2025

select * from aggrptk12studentdetails where tenantid = 38


select * from reffiletemplates where tenantid = 38

select * from main.whps_periodattendance where tenantid = 38 and schoolyear = 2025
select * from main.whps_attendance where tenantid = 38 and schoolyear = 2024

select * from import_k12studentdailyattendance_vw_38_bkp
select * into #tempk12studentdailyattendance2022 from import_k12studentdailyattendance_vw_38

select * from refmetric
select * from #tempk12studentdailyattendance2022

select *
    --schoolyear,
    --count(*) as total_students,
    --sum(case when presentrate <= 90.00 then 1 else 0 end) as chronic_absentees,
    --cast(sum(case when presentrate <= 90.00 then 1 else 0 end) * 100.0 / count(*) as decimal(10,1)) as chronic_percentage
from 
    dbo.aggrptk12studentdetails with (nolock)
where 
    tenantid = 38
    and grade in ('k', 'grade 1', 'grade 2', 'grade 3', 'grade 4', 'grade 5', 
                 'grade 6', 'grade 7', 'grade 8', 'grade 9', 'grade 10', 
                 'grade 11', 'grade 12', 'grade 13')
    and schoolyear in (2023)
group by 
    schoolyear
order by 
    schoolyear


select distinct cast(att_date as date) from [main].[whps_attendance] 
where 1=1
and schoolyear = 2024 
and student_number ='119366'
and (
		[presence_status_cd] <> 'present'
		or [att_code] in (
			't'
			,'t15'
			,'tex'
			,'tux'
			)
		)
--and [att_code] not in (
--				't'
--				,'t15'
--				,'tex'
--				,'tux'
--				)
order by cast(att_date as date) desc

select cast(attendancedate as date),schoolidentifier from main.k12studentdailyattendance
where 1=1
and schoolyear = 2024
and districtstudentid = '119366'
and attendancestatusid in (select attendancestatusid from refattendancestatus where tenantid = 38 and attendancestatusdescription='absent')
order by cast(attendancedate as date) desc



select * from import_k12studentdailyattendance_vw_38
where 1=1
and schoolyear = 2024
and districtstudentid = '119366'
and [attendancestatus] in ('abs')


--119350
--122517

--select attendancestatusid from refattendancestatus where tenantid = 38 and attendancestatusdescription='present'

--select * from refattendancestatus where tenantid = 38


with sourcecounts as (
    select 
        student_number as studentid,
        [schoolid] as schoolidentifier,
        count(distinct cast(att_date as date)) as sourceabsencecount
    from [main].[whps_attendance] a
    where schoolyear = 2024
    and [presence_status_cd] <> 'present'
    and [att_code] not in ('t', 't15', 'tex', 'tux')
    group by student_number,[schoolid]
),
productioncounts as (
    select 
        districtstudentid as studentid,
        schoolidentifier,
        count(distinct cast(attendancedate as date)) as productionabsencecount
    from main.k12studentdailyattendance
    where schoolyear = 2024
    and attendancestatusid in (
        select attendancestatusid 
        from refattendancestatus 
        where tenantid = 38 
        and attendancestatusdescription = 'absent'
    )
    group by districtstudentid,schoolidentifier
),
allstudents as (
    select distinct student_number as studentid,[schoolid] as schoolidentifier
    from [main].[whps_attendance]
    where schoolyear = 2024
    
    union
    
    select distinct districtstudentid as studentid,schoolidentifier
    from main.k12studentdailyattendance
    where schoolyear = 2024
)
select 
    a.studentid,
    isnull(s.sourceabsencecount, 0) as sourceabsencecount,
    isnull(p.productionabsencecount, 0) as productionabsencecount,
    isnull(s.sourceabsencecount, 0) - isnull(p.productionabsencecount, 0) as difference,
    case 
        when s.sourceabsencecount is null then 'missing in source'
        when p.productionabsencecount is null then 'missing in production'
        when s.sourceabsencecount = p.productionabsencecount then 'match'
        else 'mismatch'
    end as status
from allstudents a
left join sourcecounts s on a.studentid = s.studentid and a.schoolidentifier = s.schoolidentifier
left join productioncounts p on a.studentid = p.studentid and s.schoolidentifier = p.schoolidentifier and a.schoolidentifier = p.schoolidentifier
order by abs(isnull(s.sourceabsencecount, 0) - isnull(p.productionabsencecount, 0)) desc, a.studentid;



select *
from linkedreportmappedfileds lrmf
where lrmf.tenantid = 38
  and exists (
        select 1
        from linkedreportmappedfileds sub
        where sub.tenantid = lrmf.tenantid
          and sub.reportdetailsid = lrmf.reportdetailsid
          and sub.childcolumnname = lrmf.parentcolumnname
          and lrmf.isvaluefield = 1
    )
  or exists (
        select 1
        from linkedreportmappedfileds sub
        where sub.tenantid = lrmf.tenantid
          and sub.reportdetailsid = lrmf.reportdetailsid
          and sub.parentcode = lrmf.parentcode
          and sub.parentcolumnname = lrmf.parentcolumnname
          and (
                sub.isvaluefield = 0
                or sub.childreportid is not null
                or sub.childcolumnname is not null
              )
    )
order by lrmf.parentcode, lrmf.parentcolumnname;



with sourcecounts as (
    select 
        student_number as studentid,
        [schoolid] as schoolidentifier,
        count(distinct cast(att_date as date)) as sourceabsencecount
    from [main].[whps_attendance] a
    where schoolyear = 2024
    and [presence_status_cd] <> 'present'
    and [att_code] not in ('t', 't15', 'tex', 'tux')
    group by student_number,[schoolid]
),
productioncounts as (
    select 
        districtstudentid as studentid,
        schoolidentifier,
        count(distinct cast(attendancedate as date)) as productionabsencecount
    from main.k12studentdailyattendance
    where schoolyear = 2024
    and attendancestatusid in (
        select attendancestatusid 
        from refattendancestatus 
        where tenantid = 38 
        and attendancestatusdescription = 'absent'
    )
    group by districtstudentid,schoolidentifier
)
select 
    s.studentid,
    s.schoolidentifier,
    isnull(s.sourceabsencecount, 0) as sourceabsencecount,
    isnull(p.productionabsencecount, 0) as productionabsencecount,
    isnull(s.sourceabsencecount, 0) - isnull(p.productionabsencecount, 0) as difference,
    case 
        when s.sourceabsencecount = p.productionabsencecount then 'match'
        else 'mismatch'
    end as status
from sourcecounts s
inner join productioncounts p on s.studentid = p.studentid and s.schoolidentifier = p.schoolidentifier
order by abs(isnull(s.sourceabsencecount, 0) - isnull(p.productionabsencecount, 0)) , s.studentid;




select distinct student_number from main.whps_students where tenantid = 38 and schoolyear = 2026 --9861
select distinct districtstudentid from main.k12studentenrollment where tenantid = 38 and schoolyear = 2026 --9860

select distinct student_number from main.whps_students where tenantid = 38 and schoolyear = 2025 --9375
select distinct districtstudentid from main.k12studentenrollment where tenantid = 38 and schoolyear = 2025 --9375

select distinct student_number from main.whps_students where tenantid = 38 and schoolyear = 2024 --9286
select distinct districtstudentid from main.k12studentenrollment where tenantid = 38 and schoolyear = 2024 --9532



select 
    coalesce(w.schoolyear, k.schoolyear) as schoolyear,
    w.whps_student_count,
    k.enrollment_student_count,
    a.aggrpt_student_count
from (
    select schoolyear, count(distinct student_number) as whps_student_count
    from main.whps_students
    where tenantid = 38
    group by schoolyear
) w
full outer join (
    select schoolyear, count(distinct districtstudentid) as enrollment_student_count
    from main.k12studentenrollment
    where tenantid = 38
    group by schoolyear
) k
    on w.schoolyear = k.schoolyear
full outer join (
    select schoolyear, count(distinct districtstudentid) as aggrpt_student_count
    from aggrptk12studentdetails
    where tenantid = 38
    group by schoolyear
) a
    on w.schoolyear = a.schoolyear
order by schoolyear


select * from main.whps_students where schoolyear = 2026 and  student_number='118127'
select * from main.k12studentenrollment where schoolyear = 2026 and  districtstudentid='118127'
select * from aggrptk12studentdetails where schoolyear = 2026 and  districtstudentid='118127'

select * from stage.whps_students_audit where schoolyear = 2026 and  student_number='118127'
select * from stage.whps_students_noaction where schoolyear = 2026 and  student_number='118127'

select 
    ws.schoolyear,
    ws.student_number
from main.whps_students ws
where ws.tenantid = 38 and schoolyear = 2026
  and not exists (
        select 1
        from main.k12studentenrollment ke
        where ke.tenantid = ws.tenantid
          and ke.schoolyear = ws.schoolyear
          and ke.districtstudentid = ws.student_number
    )
order by ws.schoolyear, ws.student_number;

select 
    ws.*
from main.whps_students ws
where ws.tenantid = 38 and schoolyear = 2026
  and not exists (
        select 1
        from aggrptk12studentdetails a
        where a.tenantid = ws.tenantid
          and a.schoolyear = ws.schoolyear
          and a.districtstudentid = ws.student_number
    )
order by ws.schoolyear, ws.student_number;

select * from recurringschedulejob where tenantid = 38 and statusid = 1 order by recurringtime

select * from main.duxbury_studentsections

select * from reffiletemplates where tenantid =  26

select * from main.k12lea where  tenantid =  26


select  ds.[period] as [period], ds.[whpsproflevel] as [whpsproflevel],count(distinct  ds.[districtstudentid]) as [% students]  from dbo.whpsproflevelaimswebplusds as ds with (nolock)  left join dbo.refproficiencylevel on ds.[whpsproflevel] = dbo.refproficiencylevel.proficiencydescription and  ds.tenantid =dbo.refproficiencylevel.tenantid    where  ((ds.[schoolyear] in (2025)) and (ds.[schoolyear] in (2025)) and (ds.tenantid = 38))   group by ds.[period],ds.[whpsproflevel],dbo.refproficiencylevel.sortorder  order by dbo.refproficiencylevel.sortorder asc,ds.[whpsproflevel] asc 

select  ds.[period] as [period], ds.[whpsproflevel] as [whpsproflevel],count(  ds.[districtstudentid]) as [% students]  from dbo.whpsproflevelaimswebplusds as ds with (nolock)  left join dbo.refproficiencylevel on ds.[whpsproflevel] = dbo.refproficiencylevel.proficiencydescription and  ds.tenantid =dbo.refproficiencylevel.tenantid    where  ((ds.[schoolyear] in (2025)) and (ds.[schoolyear] in (2025)) and (ds.tenantid = 38))   group by ds.[period],ds.[whpsproflevel],dbo.refproficiencylevel.sortorder  order by dbo.refproficiencylevel.sortorder asc,ds.[whpsproflevel] asc 

--sp_helptext studentlevelassessmentdataset
--sp_helptext assessmentsubgrpprofds

select 
    t.name as tablename,
    t.create_date
from sys.views t
--where cast(t.create_date as date) = '2025-08-14'
--where t.name like '%ref%'
order by t.create_date desc;


select * from refaimswebplustermlevel
select * from whpsireadytermlevelsds

select * from rptdomainrelatedviews where domainrelatedviewid=2857
select * from idm.datasetcolumn where domainrelatedviewid=2857
select * from rptviewfields where domainrelatedviewid=2857

--update rptviewfields set lookuptable='whpsi_readylevel',lookupcolumn='assessmentlevelcode'
--where rptviewfieldsid='59832'

--select * from [whpsi_readylevel]

--insert into [whpsi_readylevel]

--select assessmentlevelcode,	assessmentleveldescription,sortorder,
--'38' as tenantid
--,statusid
--,createdby
--,getdate() as createddate
--,modifiedby
--,modifieddate from analyticvue_fps..fpsaccessassessmentlevel

--create table [dbo].[whpsi_readylevel](
--	[assessmentlevelid] [int] identity(1,1) not null,
--	[assessmentlevelcode] [varchar](50) not null,
--	[assessmentleveldescription] [varchar](255) null,
--	[sortorder] [int] null,
--	[tenantid] [int] not null,
--	[statusid] [int] not null,
--	[createdby] [varchar](100) null,
--	[createddate] [datetime] null,
--	[modifiedby] [varchar](100) null,
--	[modifieddate] [datetime] null,
--primary key clustered 
--(
--	[assessmentlevelid] asc
--)with (pad_index = off, statistics_norecompute = off, ignore_dup_key = off, allow_row_locks = on, allow_page_locks = on, optimize_for_sequential_key = off) on [primary]
--) on [primary]
--go

--alter table [dbo].[whpsi_readylevel] add  default (getdate()) for [createddate]
--go



--select ds.[termdescription] as [termdescription]
--	,ds.[proficiencydescription] as [proficiencydescription]
--	,count(ds.[districtstudentid]) as [districtstudentid]
--from dbo.whpsassessmentallds as ds with (nolock)
--left join dbo.refterm on ds.[termdescription] = dbo.refterm.termdescription
--	and ds.tenantid = dbo.refterm.tenantid
--left join dbo.[whpsi_readylevel] on ds.[proficiencydescription] = dbo.[whpsi_readylevel].assessmentlevelcode
--	and ds.tenantid = dbo.[whpsi_readylevel].tenantid
--where (
--		(ds.[assessment] = 'i-ready')
--		and (ds.[termdescription] in ('fall', 'spring', 'winter'))
--		and (ds.[subjectareaname] = 'reading')
--		and (ds.[schoolyear] in (2025))
--		and (ds.[termdescription] in ('fall', 'winter', 'spring'))
--		and (ds.tenantid = 38)
--		)
--group by ds.[termdescription]
--	,ds.[proficiencydescription]
--	,dbo.refterm.sortorder
--	,dbo.whpsi - readylevel.sortorder
--order by dbo.refterm.sortorder asc
--	,ds.[termdescription] asc
--	,dbo.[whpsi_readylevel].sortorder asc
--	,ds.[proficiencydescription] asc


select * from prompts




select distinct 
    a.recurringschedulejobid,
    'whps' as district,
    a.datasourcetype,
    a.recurringtype,
    a.batchname,
    c.filetemplatename,
    convert(varchar(20), dateadd(hour, -6, a.recurringtime), 100) as est,  -- am/pm format
    convert(varchar(20), a.recurringtime, 100) as utc,
    convert(varchar(20), dateadd(minute, 330, a.recurringtime), 100) as ist,
    a.recurringtime
from recurringschedulejob a
join recurringschedulejobtemplate b 
    on a.recurringschedulejobid = b.recurringschedulejobid
   and a.tenantid = b.tenantid
join reffiletemplates c 
    on b.filetemplateid = c.filetemplateid
   and a.tenantid = c.tenantid
join refyear y on a.tenantid = y.tenantid and a.yearid = y.yearid
where a.tenantid = 38 and y.yearcode = '2026' and a.statusid = 2 --and cast(a.lastrundate as date) <> cast(getdate() as date)
order by a.recurringtime asc;

 

select b.nameofinstitution,a.* from  [dbo].[import_k12staffsectionassignment_coteachers_vw_26] a
join  main.k12school b on  a.schoolyear = b.schoolyear and a.schoolidentifier = b.schoolidentifier
where b.tenantid = 26 and a.schoolyear = 2026

select * from idm.ddauser where districtstaffid = '111028282'


select * from [main].[whps_attendance] where schoolyear = 2026 and student_number='189989'

select *  from main.k12studentdailyattendance where schoolyear = 2026 and tenantid = 38 and districtstudentid = '189989'

select * from whpsattendancedaterangeds


select distinct 
    a.recurringschedulejobid,
    'duxbury' as district,
    a.datasourcetype,
    a.recurringtype,
    a.batchname,
    c.filetemplatename,
    convert(varchar(20), dateadd(hour, -6, a.recurringtime), 100) as est,  -- am/pm format
    convert(varchar(20), a.recurringtime, 100) as utc,
    convert(varchar(20), dateadd(minute, 330, a.recurringtime), 100) as ist,
    a.recurringtime
from recurringschedulejob a
join recurringschedulejobtemplate b 
    on a.recurringschedulejobid = b.recurringschedulejobid
   and a.tenantid = b.tenantid
join reffiletemplates c 
    on b.filetemplateid = c.filetemplateid
   and a.tenantid = c.tenantid
join refyear y on a.tenantid = y.tenantid and a.yearid = y.yearid
where a.tenantid = 26 and y.yearcode = '2026' and a.statusid = 1 and cast(a.lastrundate as date) <> cast(getdate() as date)
order by a.recurringtime asc;

select * from batchschedule where batchid = 91065
select * from filerecordcountstats where batchid = 90948
select * from reffiletemplates where filetemplateid = 94

select * from filerecordcountstats where tenantid = 26 and tenantfiletemplatename like '%coteachers%'
select * from main.duxbury_enrollment where schoolyear = 2026 and tenantid = 26

select * from main.k12disabilitystudent  where schoolyear = 2026 and tenantid = 26
select * from main.k12specialeducationstudent  where schoolyear = 2026 and tenantid = 26
select * from main.k12studentenrollment  where schoolyear = 2026 and tenantid = 26
select * from main.k12studentotherraces  where schoolyear = 2026 and tenantid = 26
select * from main.k12studentprogram  where schoolyear = 2026 and tenantid = 26

select count(1) from main.k12staffsectionassignment where schoolyear = 2026 and tenantid = 26


select distinct b.nameofinstitution ,a.schoolidentifier,	districtstaffid from [dbo].[import_k12staffsectionassignment_coteachers_vw_26] a
join main.k12school b on a.schoolidentifier = b.schoolidentifier and b.tenantid = 26

select * from import_k12staffsectionassignment_vw_26 
select * from [import_k12staffsectionassignment_coteachers_vw_26]

exec [dbo].[usp_getstudentsforstaffbysectioncourse] @userid=318,@tenantid=26,@schoolyear='2026',@schoolid='820004',@sectionid=null,@courseid=null,@grade=null,@staffids='114035471',@startrecord='0',@records='50',@sortby='studentname',@sorttype='asc',@isallrecords=0,@isfilterfirsttime=0,@valuefilters=null,@colorfilters=null,@subgroupfilters=null,@cohortfilters=null,@iscohortgradecolumn=0,@cohorttitle=null,@filterfield=null,@userroles='6,7',@isfromteacherview=0,@metrcgroupid=3,@isexport=0

exec [dbo].[usp_getnotificationsforstaffbysectioncourse] @userid=318,@tenantid=26,@schoolyear='2026',@schoolid='820004',@sectionid=null,@courseid=null,@staffids='114035471',@grade=null,@cohortfilters=null,@subgroupfilters=null

select * from main.k12staffsectionassignment where districtstaffid='111036916' and schoolyear = 2026  --theophilos
select * from main.k12staffsectionassignment where districtstaffid='111021501' and schoolyear = 2026  --armstrong
select * from main.k12staffsectionassignment where districtstaffid='125121185' and schoolyear = 2026  --mcneil

select distinct districtstaffid from [dbo].[import_k12staffsectionassignment_coteachers_vw_26]


select b.roleid
	,b.isdefaultrole
	,a.*
from idm.ddauser a
inner join idm.userroleorg b on a.ddauserid = b.ddauserid
	and a.tenantid = b.tenantid
where districtstaffid in (
		select distinct districtstaffid
		from [dbo].[import_k12staffsectionassignment_coteachers_vw_26]
		)
	and a.tenantid = 26
	and isdefaultrole = 1


select b.roleid
	,b.isdefaultrole
	,a.*
from idm.ddauser a
inner join idm.userroleorg b on a.ddauserid = b.ddauserid
	and a.tenantid = b.tenantid
where districtstaffid in ('111020745', '111021501', '111029310', '111030656', '111030784', '111031805', '111031886', '111032779', '111033655', '111034800', '111035862', '111037536', '111037892', '111038395', '112026830', '112030224', '112032348', '112034585', '112034880', '112035384', '112035667', '112035815', '112036579', '112038495', '112038832', '113031374', '113036449', '114038173', '114038175', '114038211', '114038632', '114038648', '114038650', '114038814', '114038818', '114038843', '114038855', '114038875', '125121185', '125126579')
	and a.tenantid = 26
	and isdefaultrole = 1


select * from duxburyabsenteesbyreasonds where schoolyear = 2026

exec sp_helptext duxburyabsenteesbyreasonds




select  * from reffiletemplates where tenantid = 38 and filetemplatename like '%ngss%'
select  * from tenantfiletemplatemapper where tenantid = 38 and tenantfilename like '%sba%'
--2827
select  * from tenantfiletemplatemapper where tenantid = 38 and tenantfilename like '%ngss%'
--2863
--2838
select  * from tenantfiletemplatemapper where tenantid = 38 and filetemplateid in (2848,2849)




select distinct schoolyear from main.whps_ngss where tenantid = 38
--2019
--2021
--2022
select  distinct schoolyear from main.whps_ngss_source where tenantid = 38
--2024
--2023

select distinct schoolyear from main.whps_sbac where tenantid = 38
--2019
--2021
--2022
select distinct schoolyear from main.whps_sbac_ela_source where tenantid = 38
--2024
--2023
select distinct schoolyear from main.whps_sbac_math_source where tenantid = 38
--2024
--2023


select * from main.whps_sbac where tenantid = 38
select * from main.whps_sbac_ela_source where tenantid = 38
select * from main.whps_sbac_math_source where tenantid = 38

select * from main.whps_ngss where tenantid = 38
select * from main.whps_ngss_source where tenantid = 38

--===============================================

select * from main.whps_sbac_sourcedata
select * from main.whps_ngss_sourcedata

select * from main.whps_sbac_sourcedata where vertical_scale_score is null
select * from main.whps_ngss_sourcedata where scale_score is null

--[import_sbac_ngss_k12studentgenericassessment_vw_38]
--[import_sbac_ngss_assessmentdetails_vw_38]
select * from dataimportviews where tenantid = 38
select * from refgrade where tenantid = 38

--insert into dataimportviews
--select 'import_sbac_ngss_k12studentgenericassessment_vw_38','import_sbac_ngss_k12studentgenericassessment_vw_38',38,1,1,'ddauser@dda',getdate(),null,null
--union select 'import_sbac_ngss_assessmentdetails_vw_38','import_sbac_ngss_assessmentdetails_vw_38',38,1,1,'ddauser@dda',getdate(),null,null


select * from main.k12studentgenericassessment with (nolock) where tenantid = 38 and schoolyear = 2025 and assessmentcodeid in
(select assessmentdetailsid from main.assessmentdetails where tenantid = 38 and assessmentcode = 'sbac' and schoolyear = 2025)



select * from main.k12studentgenericassessment with (nolock) where tenantid = 38 and schoolyear = 2025 and assessmentcodeid in
(select assessmentdetailsid from main.assessmentdetails where tenantid = 38 and assessmentcode = 'ngss' and schoolyear = 2025)


exec sp_helptext whpssbacds

select * from whpsassessmentallds
select * from whpsireadysbacds
select * from whpssbacdsnew
select * from whps_sbac_ds_new
select * from whpssbaccyearstudentsds

select reportfiledetails from reportdetails where reportdetailsid = 8852

--update reportdetails
--set reportfiledetails = json_modify(
--        json_modify(reportfiledetails, '$.displaylatestyeardata', cast(0 as bit)),
--        '$.displaylastyeardata', cast(1 as bit)
--    )
--where reportdetailsid in ('8047','8050')

select distinct schoolyear from whps_aimswebplustermlevels
select * from refcharttype where tenantid = 38


select * from reportdetails where reportdetailsid in ('8318')
--reporttypeid in (354,351,355)

--whpsacuitymatrixds

select * from [whps_acuitymatrix_vw] where schoolyear = 2026 and gradecode = 9 and  schoolname = 'strive'

select ds.[schoolname] as [schoolname]
	,ds.[acuitytier] as [acuitytier]
	,count(distinct ds.[districtstudentid]) as [student %]
from dbo.whpsacuitymatrixds as ds with (nolock)
left join dbo.refproficiencylevel on ds.[acuitytier] = dbo.refproficiencylevel.proficiencydescription
	and ds.tenantid = dbo.refproficiencylevel.tenantid
where (
		(ds.[gradecode] = '9')
		and (ds.[schoolyear] in (2026))
		and (ds.tenantid = 38)
		)
group by ds.[schoolname]
	,ds.[acuitytier]
	,dbo.refproficiencylevel.sortorder
order by ds.[schoolname] asc
	,dbo.refproficiencylevel.sortorder asc
	,ds.[acuitytier] asc


select * from refproficiencylevel where tenantid = 38 and assessmentcode = 'acuity matrix' and sy = 2025

--insert into refproficiencylevel
--select '2026','cannot calculate score','cannot calculate score',5,'#808080',null,null,'acuity matrix','reading','proflvl',5,38,1,'ddauser@dda',getdate(),null,null
--union select '2025','cannot calculate score','cannot calculate score',5,'#808080',null,null,'acuity matrix','reading','proflvl',5,38,1,'ddauser@dda',getdate(),null,null


select * from idm.studentssubgroup where tenantid = 38 and statusid = 1 order by sortorder 
select * from dashboardsubgroups where tenantid = 38 and dashboardid = 285
select * from dashboard where tenantid = 38 and dashboardname like '%aim%'

select distinct schoolyear from aggrptassessmentsubgroupdata where tenantid = 38 and assessmentcode like '%aim%'

exec sp_helptext whps_ireadytermlevels

select max(schoolyear) from main.whps_aimswebplus


select  ds.[term] as [term], ds.[level] as [level],count(distinct  ds.[districtstudentid]) as [districtstudentid]  from dbo.whpsireadytermlevelsds as ds with (nolock)  left join dbo.refaimswebplustermlevel on ds.[level] = dbo.refaimswebplustermlevel.levelcode and  ds.tenantid =dbo.refaimswebplustermlevel.tenantid    where  ((ds.[subjectareaname] = 'reading') and (ds.[level] is not null ) and (ds.[schoolyear] in (2025)) and (ds.tenantid = 38))   group by ds.[term],ds.[level],dbo.refaimswebplustermlevel.sortorder  order by ds.[term] asc,dbo.refaimswebplustermlevel.sortorder asc,ds.[level] asc 

select  ds.[term] as [term], ds.[level] as [level],count(distinct ds.[districtstudentid]) as [districtstudentid]  from dbo.whpsireadytermlevelsds as ds with (nolock)  left join dbo.refaimswebplustermlevel on ds.[level] = dbo.refaimswebplustermlevel.levelcode and  ds.tenantid =dbo.refaimswebplustermlevel.tenantid    where  ((isnull(ds.[subjectareaname],' ') = 'mathematics') and (ds.[level] is not null ) and (isnull(ds.[schoolyear],' ') in (2025)) and (ds.tenantid = 38))   group by ds.[term],ds.[level],dbo.refaimswebplustermlevel.sortorder  order by ds.[term] asc,dbo.refaimswebplustermlevel.sortorder asc,ds.[level] asc 


--create nonclustered index [ncdix_aggplpstudentcoursesections_sdtc] on [dbo].[aggplpstudentcoursesections] ([schoolyear],[districtstudentid],[tenantid],[courseidentifier]) 

select * from whpsacuitymatrixds where districtstudentid='115467'

drop index ncidx_aggrptassessmentsubgroupdata_tasg on aggrptassessmentsubgroupdata;

create nonclustered index [ncidx_aggrptassessmentsubgroupdata_tasg]
on [dbo].[aggrptassessmentsubgroupdata] ([tenantid],[assessmentcode],[subjectareacode],[gradecode]) 
include ([schoolyear],[schoolidentifier],[proficiencydescription],[districtstudentid],[schoolname],[termdescription],[testtakendate],[percentilerank])



--select  ds.[schoolname] as [schoolname], ds.[acuitytier] as [acuitytier],count(distinct  ds.[districtstudentid]) as [districtstudentid]  from dbo.whpsacuitymatrixds as ds with (nolock)  left join dbo.refproficiencylevel on ds.[acuitytier] = dbo.refproficiencylevel.proficiencydescription and  ds.tenantid =dbo.refproficiencylevel.tenantid    where  ((ds.[gradecode] = '10') and (ds.[schoolyear] in (2026)) and (ds.tenantid = 38))   group by ds.[schoolname],ds.[acuitytier],dbo.refproficiencylevel.sortorder  order by ds.[schoolname] asc,dbo.refproficiencylevel.sortorder asc,ds.[acuitytier] asc 
--go
--select  ds.[schoolname] as [schoolname], ds.[acuitytier] as [acuitytier],count(distinct  ds.[districtstudentid]) as [districtstudentid]  from dbo.whpsacuitymatrixds as ds with (nolock)  left join dbo.refproficiencylevel on ds.[acuitytier] = dbo.refproficiencylevel.proficiencydescription and  ds.tenantid =dbo.refproficiencylevel.tenantid    where  ((ds.[gradecode] = '6') and (ds.[schoolyear] in (2026)) and (ds.tenantid = 38))   group by ds.[schoolname],ds.[acuitytier],dbo.refproficiencylevel.sortorder  order by ds.[schoolname] asc,dbo.refproficiencylevel.sortorder asc,ds.[acuitytier] asc 
--go
--select  ds.[schoolname] as [schoolname], ds.[acuitytier] as [acuitytier],count(distinct  ds.[districtstudentid]) as [districtstudentid]  from dbo.whpsacuitymatrixds as ds with (nolock)  left join dbo.refproficiencylevel on ds.[acuitytier] = dbo.refproficiencylevel.proficiencydescription and  ds.tenantid =dbo.refproficiencylevel.tenantid    where  ((ds.[gradecode] = '9') and (ds.[schoolyear] in (2026)) and (ds.tenantid = 38))   group by ds.[schoolname],ds.[acuitytier],dbo.refproficiencylevel.sortorder  order by ds.[schoolname] asc,dbo.refproficiencylevel.sortorder asc,ds.[acuitytier] asc 
--go
--select  ds.[schoolname] as [schoolname], ds.[acuitytier] as [acuitytier],count(distinct  ds.[districtstudentid]) as [districtstudentid]  from dbo.whpsacuitymatrixds as ds with (nolock)  left join dbo.refproficiencylevel on ds.[acuitytier] = dbo.refproficiencylevel.proficiencydescription and  ds.tenantid =dbo.refproficiencylevel.tenantid    where  ((ds.[gradecode] = '8') and (ds.[schoolyear] in (2026)) and (ds.tenantid = 38))   group by ds.[schoolname],ds.[acuitytier],dbo.refproficiencylevel.sortorder  order by ds.[schoolname] asc,dbo.refproficiencylevel.sortorder asc,ds.[acuitytier] asc 
--go
--select  ds.[schoolname] as [schoolname], ds.[acuitytier] as [acuitytier],count(distinct  ds.[districtstudentid]) as [districtstudentid]  from dbo.whpsacuitymatrixds as ds with (nolock)  left join dbo.refproficiencylevel on ds.[acuitytier] = dbo.refproficiencylevel.proficiencydescription and  ds.tenantid =dbo.refproficiencylevel.tenantid    where  ((ds.[gradecode] = '7') and (ds.[schoolyear] in (2026)) and (ds.tenantid = 38))   group by ds.[schoolname],ds.[acuitytier],dbo.refproficiencylevel.sortorder  order by ds.[schoolname] asc,dbo.refproficiencylevel.sortorder asc,ds.[acuitytier] asc 
--go
--select  ds.[schoolname] as [schoolname], ds.[acuitytier] as [acuitytier],count(distinct  ds.[districtstudentid]) as [districtstudentid]  from dbo.whpsacuitymatrixds as ds with (nolock)  left join dbo.refproficiencylevel on ds.[acuitytier] = dbo.refproficiencylevel.proficiencydescription and  ds.tenantid =dbo.refproficiencylevel.tenantid    where  ((ds.[gradecode] = '7') and (ds.[schoolyear] in (2026)) and (ds.tenantid = 38))   group by ds.[schoolname],ds.[acuitytier],dbo.refproficiencylevel.sortorder  order by ds.[schoolname] asc,dbo.refproficiencylevel.sortorder asc,ds.[acuitytier] asc 
--go
--select  ds.[schoolname] as [schoolname], ds.[acuitytier] as [acuitytier],count(distinct  ds.[districtstudentid]) as [districtstudentid]  from dbo.whpsacuitymatrixds as ds with (nolock)  left join dbo.refproficiencylevel on ds.[acuitytier] = dbo.refproficiencylevel.proficiencydescription and  ds.tenantid =dbo.refproficiencylevel.tenantid    where  ((ds.[gradecode] = '8') and (ds.[schoolyear] in (2026)) and (ds.tenantid = 38))   group by ds.[schoolname],ds.[acuitytier],dbo.refproficiencylevel.sortorder  order by ds.[schoolname] asc,dbo.refproficiencylevel.sortorder asc,ds.[acuitytier] asc 
--go
--select  ds.[schoolname] as [schoolname], ds.[acuitytier] as [acuitytier],count(distinct  ds.[districtstudentid]) as [districtstudentid]  from dbo.whpsacuitymatrixds as ds with (nolock)  left join dbo.refproficiencylevel on ds.[acuitytier] = dbo.refproficiencylevel.proficiencydescription and  ds.tenantid =dbo.refproficiencylevel.tenantid    where  ((ds.[gradecode] = '9') and (ds.[schoolyear] in (2026)) and (ds.tenantid = 38))   group by ds.[schoolname],ds.[acuitytier],dbo.refproficiencylevel.sortorder  order by ds.[schoolname] asc,dbo.refproficiencylevel.sortorder asc,ds.[acuitytier] asc 
--go
--select  ds.[schoolname] as [schoolname], ds.[acuitytier] as [acuitytier],count(distinct  ds.[districtstudentid]) as [districtstudentid]  from dbo.whpsacuitymatrixds as ds with (nolock)  left join dbo.refproficiencylevel on ds.[acuitytier] = dbo.refproficiencylevel.proficiencydescription and  ds.tenantid =dbo.refproficiencylevel.tenantid    where  ((ds.[gradecode] = '10') and (ds.[schoolyear] in (2026)) and (ds.tenantid = 38))   group by ds.[schoolname],ds.[acuitytier],dbo.refproficiencylevel.sortorder  order by ds.[schoolname] asc,dbo.refproficiencylevel.sortorder asc,ds.[acuitytier] asc 
--go
select  ds.[schoolname] as [schoolname], ds.[acuitytier] as [acuitytier],count(distinct  ds.[districtstudentid]) as [districtstudentid]  from dbo.whpsacuitymatrixds as ds with (nolock)  left join dbo.refproficiencylevel on ds.[acuitytier] = dbo.refproficiencylevel.proficiencydescription and  ds.tenantid =dbo.refproficiencylevel.tenantid    where  ((ds.[gradecode] = '6') and (ds.[schoolyear] in (2026)) and (ds.tenantid = 38))   group by ds.[schoolname],ds.[acuitytier],dbo.refproficiencylevel.sortorder  order by ds.[schoolname] asc,dbo.refproficiencylevel.sortorder asc,ds.[acuitytier] asc 
go
select  ds.[period] as [period], ds.[whpsproflevel] as [whpsproflevel],count(distinct  ds.[districtstudentid]) as [districtstudentid]  from dbo.whpsproflevelaimswebplusds as ds with (nolock)  left join dbo.refproficiencylevel on ds.[whpsproflevel] = dbo.refproficiencylevel.proficiencydescription and  ds.tenantid =dbo.refproficiencylevel.tenantid    where  ((ds.[schoolyear] in (2025)) and (ds.tenantid = 38))   group by ds.[period],ds.[whpsproflevel],dbo.refproficiencylevel.sortorder  order by dbo.refproficiencylevel.sortorder asc,ds.[whpsproflevel] asc 
go
select  ds.[schoolname] as [schoolname], ds.[whpsproflevel] as [whpsproflevel],count(  ds.[districtstudentid]) as [districtstudentid]  from dbo.whpsproflevelaimswebplusds as ds with (nolock)  left join dbo.refproficiencylevel on ds.[whpsproflevel] = dbo.refproficiencylevel.proficiencydescription and  ds.tenantid =dbo.refproficiencylevel.tenantid    where  ((ds.[period] = 'winter') and (ds.[schoolyear] in (2025)) and (ds.tenantid = 38))   group by ds.[schoolname],ds.[whpsproflevel],dbo.refproficiencylevel.sortorder  order by ds.[schoolname] asc,dbo.refproficiencylevel.sortorder asc,ds.[whpsproflevel] asc 
go
select  ds.[schoolname] as [schoolname], ds.[whpsproflevel] as [whpsproflevel],count(  ds.[districtstudentid]) as [districtstudentid]  from dbo.whpsproflevelaimswebplusds as ds with (nolock)  left join dbo.refproficiencylevel on ds.[whpsproflevel] = dbo.refproficiencylevel.proficiencydescription and  ds.tenantid =dbo.refproficiencylevel.tenantid    where  ((ds.[period] = 'spring') and (ds.[schoolyear] in (2025)) and (ds.tenantid = 38))   group by ds.[schoolname],ds.[whpsproflevel],dbo.refproficiencylevel.sortorder  order by ds.[schoolname] asc,dbo.refproficiencylevel.sortorder desc,ds.[whpsproflevel] desc 
go
select  ds.[whpsproflevel] as [whpsproflevel],count(distinct ds.[districtstudentid]) as [count],( select count(distinct subds.[districtstudentid]) from dbo.whpsproflevelaimswebplusds as subds with (nolock) left join dbo.refproficiencylevel on subds.[whpsproflevel] = dbo.refproficiencylevel.proficiencydescription and  subds.tenantid =dbo.refproficiencylevel.tenantid  where subds.[period] = ('spring') and  subds.[schoolyear] in (2025) and (subds.tenantid =38)) as [seriestotalcount]  from dbo.whpsproflevelaimswebplusds as ds with (nolock)  left join dbo.refproficiencylevel on ds.[whpsproflevel] = dbo.refproficiencylevel.proficiencydescription and  ds.tenantid =dbo.refproficiencylevel.tenantid    where  ((ds.[period] = 'spring') and (ds.[schoolyear] in (2025)) and (ds.tenantid = 38))   group by ds.[whpsproflevel],dbo.refproficiencylevel.sortorder  order by dbo.refproficiencylevel.sortorder asc,ds.[whpsproflevel] asc 
go
select  ds.[whpsproflevel] as [whpsproflevel],count(distinct ds.[districtstudentid]) as [count],( select count(distinct subds.[districtstudentid]) from dbo.whpsproflevelaimswebplusds as subds with (nolock) left join dbo.refproficiencylevel on subds.[whpsproflevel] = dbo.refproficiencylevel.proficiencydescription and  subds.tenantid =dbo.refproficiencylevel.tenantid  where subds.[period] = ('fall') and  subds.[schoolyear] in (2025) and (subds.tenantid =38)) as [seriestotalcount]  from dbo.whpsproflevelaimswebplusds as ds with (nolock)  left join dbo.refproficiencylevel on ds.[whpsproflevel] = dbo.refproficiencylevel.proficiencydescription and  ds.tenantid =dbo.refproficiencylevel.tenantid    where  ((ds.[period] = 'fall') and (ds.[schoolyear] in (2025)) and (ds.tenantid = 38))   group by ds.[whpsproflevel],dbo.refproficiencylevel.sortorder  order by dbo.refproficiencylevel.sortorder asc,ds.[whpsproflevel] asc 
go
select  ds.[schoolname] as [schoolname], ds.[whpsproflevel] as [whpsproflevel],count(  ds.[districtstudentid]) as [districtstudentid]  from dbo.whpsproflevelaimswebplusds as ds with (nolock)  left join dbo.refproficiencylevel on ds.[whpsproflevel] = dbo.refproficiencylevel.proficiencydescription and  ds.tenantid =dbo.refproficiencylevel.tenantid    where  ((ds.[period] = 'fall') and (ds.[schoolyear] in (2025)) and (ds.tenantid = 38))   group by ds.[schoolname],ds.[whpsproflevel],dbo.refproficiencylevel.sortorder  order by ds.[schoolname] asc,dbo.refproficiencylevel.sortorder asc,ds.[whpsproflevel] asc 
go
select  ds.[whpsproflevel] as [whpsproflevel],count(distinct ds.[districtstudentid]) as [count],( select count(distinct subds.[districtstudentid]) from dbo.whpsproflevelaimswebplusds as subds with (nolock) left join dbo.refproficiencylevel on subds.[whpsproflevel] = dbo.refproficiencylevel.proficiencydescription and  subds.tenantid =dbo.refproficiencylevel.tenantid  where subds.[period] = ('winter') and  subds.[schoolyear] in (2025) and (subds.tenantid =38)) as [seriestotalcount]  from dbo.whpsproflevelaimswebplusds as ds with (nolock)  left join dbo.refproficiencylevel on ds.[whpsproflevel] = dbo.refproficiencylevel.proficiencydescription and  ds.tenantid =dbo.refproficiencylevel.tenantid    where  ((ds.[period] = 'winter') and (ds.[schoolyear] in (2025)) and (ds.tenantid = 38))   group by ds.[whpsproflevel],dbo.refproficiencylevel.sortorder  order by dbo.refproficiencylevel.sortorder asc,ds.[whpsproflevel] asc 
go
select  ds.[schoolyear] as [schoolyear],count(distinct ds.[districtstudentid]) as [count]  from dbo.whpsapallyearsviewchartds as ds with (nolock)   where  (ds.tenantid = 38)   group by ds.[schoolyear]  order by ds.[schoolyear] asc 
go
select  ds.[schoolyear] as [schoolyear],count(ds.[districtstudentid]) as [count],( select count(subds.[districtstudentid]) from dbo.whpsapallyearsviewchartds as subds with (nolock)   where subds.[leaidentifier] in ('1550011') and (subds.tenantid =38)) as [seriestotalcount]  from dbo.whpsapallyearsviewchartds as ds with (nolock)   where  ((ds.[leaidentifier] in ('1550011')) and (ds.tenantid = 38))   group by ds.[schoolyear]  order by ds.[schoolyear] asc 
go
select  ds.[schoolyear] as [schoolyear], ds.[subject] as [subject], ds.[proficiency_level] as [proficiency_level],count(  ds.[districtstudentid]) as [districtstudentid]  from dbo.whpsapallyearsviewchartds as ds with (nolock)   where  ((ds.[subject] in ('ap research', 'ap seminar')) and (ds.[leaidentifier] in ('1550011')) and (ds.tenantid = 38))   group by ds.[schoolyear],ds.[subject],ds.[proficiency_level]  order by ds.[schoolyear] asc,ds.[proficiency_level] asc,ds.[subject] asc 
go
select  ds.[subject] as [subject], ds.[scores] as [scores],count(  ds.[districtstudentid]) as [districtstudentid]  from dbo.whpsapscoredistributionds as ds with (nolock)  left join dbo.refproficiencylevel on ds.[scores] = dbo.refproficiencylevel.proficiencydescription and  ds.tenantid =dbo.refproficiencylevel.tenantid    where  ((ds.[schoolyear] in (2024)) and (ds.tenantid = 38))   group by ds.[subject],ds.[scores],dbo.refproficiencylevel.sortorder  order by ds.[subject] asc,dbo.refproficiencylevel.sortorder desc,ds.[scores] desc 
go
select  ds.[schoolyear] as [schoolyear], ds.[proficiency_level] as [proficiency_level], ds.[proficiency_level_name] as [proficiency_level_name],count(  ds.[districtstudentid]) as [districtstudentid]  from dbo.whpsapallyearsviewchartds as ds with (nolock)   where  (ds.tenantid = 38)   group by ds.[schoolyear],ds.[proficiency_level],ds.[proficiency_level_name]  order by ds.[schoolyear] asc,ds.[proficiency_level] asc 
go
select  ds.[subject] as [subject], ds.[schoolyear] as [schoolyear],count(distinct  ds.[districtstudentid]) as [districtstudentid],( select count(distinct subds.[districtstudentid]) from dbo.whpsapallyearsviewchartds as subds with (nolock)   where  subds.[subject] = ds.[subject] and subds.[schoolyear] = ds.[schoolyear] and  subds.[schoolyear] in (2024) and (subds.tenantid =38)) as [seriestotalcount]  from dbo.whpsapallyearsviewchartds as ds with (nolock)   where  ((ds.[original_score] >= '3') and (ds.[schoolyear] in (2024)) and (ds.tenantid = 38))   group by ds.[subject],ds.[schoolyear]  order by ds.[subject] asc,ds.[schoolyear] asc 
go
select  ds.[grade] as [grade], ds.[proficiencydescription] as [proficiencydescription],count(  ds.[districtstudentid]) as [districtstudentid]  from dbo.whpsassessmentallds as ds with (nolock)  left join dbo.refgrade on ds.[grade] = dbo.refgrade.gradedescription and  ds.tenantid =dbo.refgrade.tenantid   left join dbo.whpsi_readylevel on ds.[proficiencydescription] = dbo.whpsi_readylevel.assessmentlevelcode and  ds.tenantid =dbo.whpsi_readylevel.tenantid    where  ((ds.[assessment] = 'i-ready') and (ds.[subjectareaname] = 'mathematics') and (ds.[termdescription] = 'spring') and (ds.[schoolyear] in (2026)) and (ds.tenantid = 38))   group by ds.[grade],ds.[proficiencydescription],dbo.refgrade.sortorder,dbo.whpsi_readylevel.sortorder  order by dbo.refgrade.sortorder asc,ds.[grade] asc,dbo.whpsi_readylevel.sortorder asc,ds.[proficiencydescription] asc 
go
select  ds.[grade] as [grade], ds.[proficiencydescription] as [proficiencydescription],count(  ds.[districtstudentid]) as [districtstudentid]  from dbo.whpsassessmentallds as ds with (nolock)  left join dbo.refgrade on ds.[grade] = dbo.refgrade.gradedescription and  ds.tenantid =dbo.refgrade.tenantid   left join dbo.whpsi_readylevel on ds.[proficiencydescription] = dbo.whpsi_readylevel.assessmentlevelcode and  ds.tenantid =dbo.whpsi_readylevel.tenantid    where  ((ds.[assessment] = 'i-ready') and (ds.[subjectareaname] = 'reading') and (ds.[termdescription] = 'fall') and (ds.[schoolyear] in (2026)) and (ds.tenantid = 38))   group by ds.[grade],ds.[proficiencydescription],dbo.refgrade.sortorder,dbo.whpsi_readylevel.sortorder  order by dbo.refgrade.sortorder asc,ds.[grade] asc,dbo.whpsi_readylevel.sortorder asc,ds.[proficiencydescription] asc 
go
select  ds.[grade] as [grade], ds.[proficiencydescription] as [proficiencydescription],count(  ds.[districtstudentid]) as [districtstudentid]  from dbo.whpsassessmentallds as ds with (nolock)  left join dbo.refgrade on ds.[grade] = dbo.refgrade.gradedescription and  ds.tenantid =dbo.refgrade.tenantid   left join dbo.whpsi_readylevel on ds.[proficiencydescription] = dbo.whpsi_readylevel.assessmentlevelcode and  ds.tenantid =dbo.whpsi_readylevel.tenantid    where  ((ds.[assessment] = 'i-ready') and (ds.[subjectareaname] = 'mathematics') and (ds.[termdescription] = 'fall') and (ds.[schoolyear] in (2026)) and (ds.tenantid = 38))   group by ds.[grade],ds.[proficiencydescription],dbo.refgrade.sortorder,dbo.whpsi_readylevel.sortorder  order by dbo.refgrade.sortorder asc,ds.[grade] asc,dbo.whpsi_readylevel.sortorder asc,ds.[proficiencydescription] asc 






select * from whpssatpsatssds

--usp_updatedatasetfield

--[whpsi-readytermlevels_ds]


--exec [usp_updatedatasetfield] 'whpssatpsatssds', 'grade_level', 'grade', 38
--exec [usp_updatedatasetfield] 'whps_i-readytermlevels_ds', 'gradedescription', 'grade', 38
--exec [usp_updatedatasetfield] 'whps_aimswebplustermlevels_ds', 'gradedescription', 'grade', 38

select distinct schoolyear from main.whps_laslinks

select * from main.whps_sat

select * from reffiletemplates where tenantid = 38 and filetemplatename like '%pat%'

select distinct schoolyear from main.whps_sat_source_data

select * from sys.tables where name like '%blitz%'



--select schoolyear,districtstudentid,assessment,subjectareaname,termdescription,testtakendate from whpsassessmentallds
--where schoolyear = 2026 and proficiencydescription ='3 or more grade levels below' and termdescription in  ('fall','spring','winter')
--and assessment ='i-ready' and subjectareaname= 'reading' and districtstudentid='120546'


--level 3termdescription
--null

select * from main.whps_blitzreport  where schoolyear = 2025

select * from whpsactivitydetailsviewds --5sec

Alter VIEW [dbo].WHPSBlitzReportDistrictDS
AS
SELECT [WHPS_BlitzReportDistrict_Vw].[highneeds] AS [highneeds],
	[WHPS_BlitzReportDistrict_Vw].[ETHNICITY] AS [ETHNICITY],
	[WHPS_BlitzReportDistrict_Vw].[counselor] AS [counselor],
	[WHPS_BlitzReportDistrict_Vw].[Student_Number] AS [Student_Number],
	[WHPS_BlitzReportDistrict_Vw].[GRADE_LEVEL] AS [GRADE_LEVEL],
	[WHPS_BlitzReportDistrict_Vw].[crdc_504] AS [crdc_504],
	[WHPS_BlitzReportDistrict_Vw].[sped] AS [sped],
	[WHPS_BlitzReportDistrict_Vw].[ell] AS [ell],
	[WHPS_BlitzReportDistrict_Vw].[gender] AS [gender],
	[WHPS_BlitzReportDistrict_Vw].[SASID] AS [SASID],
	[WHPS_BlitzReportDistrict_Vw].[StudentName] AS [StudentName],
	[WHPS_BlitzReportDistrict_Vw].[last_name] AS [last_name],
	[WHPS_BlitzReportDistrict_Vw].[first_name] AS [first_name],
	[WHPS_BlitzReportDistrict_Vw].[SchoolYear] AS [SchoolYear],
	[WHPS_BlitzReportDistrict_Vw].[StudentId] AS [StudentId],
	[WHPS_BlitzReportDistrict_Vw].[StudentSchool] AS [StudentSchool],
	[WHPS_BlitzReportDistrict_Vw].[SchoolIdentifier] AS [SchoolIdentifier],
	[WHPS_BlitzReportDistrict_Vw].[parentcombinedname] AS [parentcombinedname],
	[WHPS_BlitzReportDistrict_Vw].[el_zone] AS [el_zone],
	[WHPS_BlitzReportDistrict_Vw].[ms_zone] AS [ms_zone],
	[WHPS_BlitzReportDistrict_Vw].[hs_zone] AS [hs_zone],
	[WHPS_BlitzReportDistrict_Vw].[OpenChoice] AS [OpenChoice],
	[WHPS_BlitzReportDistrict_Vw].[SAT_TotalScore] AS [SAT_TotalScore],
	[WHPS_BlitzReportDistrict_Vw].[SAT_ReadingScore] AS [SAT_ReadingScore],
	[WHPS_BlitzReportDistrict_Vw].[SAT_ReadingBenchmark] AS [SAT_ReadingBenchmark],
	[WHPS_BlitzReportDistrict_Vw].[SAT_ReadingMetScore] AS [SAT_ReadingMetScore],
	[WHPS_BlitzReportDistrict_Vw].[SAT_MathScore] AS [SAT_MathScore],
	[WHPS_BlitzReportDistrict_Vw].[SAT_MathBenchmark] AS [SAT_MathBenchmark],
	[WHPS_BlitzReportDistrict_Vw].[SAT_MathMetScore] AS [SAT_MathMetScore],
	[WHPS_BlitzReportDistrict_Vw].[PSAT_TotalScore] AS [PSAT_TotalScore],
	[WHPS_BlitzReportDistrict_Vw].[PSAT_ReadingScore] AS [PSAT_ReadingScore],
	[WHPS_BlitzReportDistrict_Vw].[PSAT_ReadingBenchmark] AS [PSAT_ReadingBenchmark],
	[WHPS_BlitzReportDistrict_Vw].[PSAT_ReadingMetScore] AS [PSAT_ReadingMetScore],
	[WHPS_BlitzReportDistrict_Vw].[PSAT_MathScore] AS [PSAT_MathScore],
	[WHPS_BlitzReportDistrict_Vw].[PSAT_MathBenchmark] AS [PSAT_MathBenchmark],
	[WHPS_BlitzReportDistrict_Vw].[PSAT_MathMetScore] AS [PSAT_MathMetScore],
	[WHPS_BlitzReportDistrict_Vw].[AIMSWebPlus_Mathematics_ProfLevel] AS [AIMSWebPlus_Mathematics_ProfLevel],
	[WHPS_BlitzReportDistrict_Vw].[AIMSWebPlus_Mathematics_ScaleScore] AS [AIMSWebPlus_Mathematics_ScaleScore],
	[WHPS_BlitzReportDistrict_Vw].[AIMSWebPlus_OralReadingFluency_ProfLevel] AS [AIMSWebPlus_OralReadingFluency_ProfLevel],
	[WHPS_BlitzReportDistrict_Vw].[AIMSWebPlus_OralReadingFluency_ScaleScore] AS [AIMSWebPlus_OralReadingFluency_ScaleScore],
	[WHPS_BlitzReportDistrict_Vw].[AIMSWebPlus_Reading_ProfLevel] AS [AIMSWebPlus_Reading_ProfLevel],
	[WHPS_BlitzReportDistrict_Vw].[AIMSWebPlus_Reading_ScaleScore] AS [AIMSWebPlus_Reading_ScaleScore],
	[WHPS_BlitzReportDistrict_Vw].[i-Ready_Mathematics_ProfLevel] AS [i-Ready_Mathematics_ProfLevel],
	[WHPS_BlitzReportDistrict_Vw].[i-Ready_Mathematics_ScaleScore] AS [i-Ready_Mathematics_ScaleScore],
	[WHPS_BlitzReportDistrict_Vw].[i-Ready_Reading_ProfLevel] AS [i-Ready_Reading_ProfLevel],
	[WHPS_BlitzReportDistrict_Vw].[i-Ready_Reading_ScaleScore] AS [i-Ready_Reading_ScaleScore],
	[WHPS_BlitzReportDistrict_Vw].[NGSS_Science_ProfLevel] AS [NGSS_Science_ProfLevel],
	[WHPS_BlitzReportDistrict_Vw].[NGSS_Science_ScaleScore] AS [NGSS_Science_ScaleScore],
	[WHPS_BlitzReportDistrict_Vw].[SBAC_EnglishLanguageArts_ProfLevel] AS [SBAC_EnglishLanguageArts_ProfLevel],
	[WHPS_BlitzReportDistrict_Vw].[SBAC_EnglishLanguageArts_ScaleScore] AS [SBAC_EnglishLanguageArts_ScaleScore],
	[WHPS_BlitzReportDistrict_Vw].[SBAC_Mathematics_ProfLevel] AS [SBAC_Mathematics_ProfLevel],
	[WHPS_BlitzReportDistrict_Vw].[SBAC_Mathematics_ScaleScore] AS [SBAC_Mathematics_ScaleScore],
	[WHPS_BlitzReportDistrict_Vw].[STAR_Reading_ProfLevel] AS [STAR_Reading_ProfLevel],
	[WHPS_BlitzReportDistrict_Vw].[STAR_Reading_ScaleScore] AS [STAR_Reading_ScaleScore],
	[WHPS_BlitzReportDistrict_Vw].[AssessmentYear] AS [AssessmentYear],
	[WHPS_BlitzReportDistrict_Vw].TenantId
FROM [dbo].[WHPS_BlitzReportDistrict_Vw] AS [WHPS_BlitzReportDistrict_Vw]
WHERE [WHPS_BlitzReportDistrict_Vw].TenantId = 38


exec sp_helptext whpsblitzreportdistrictds

set statistics time on;
select * from whpsblitzreportdistrictds
set statistics time off;

set statistics time on;
select * from WHPS_StudentAcuityScores_Vw
set statistics time off;

set statistics time on;
select * from whps_acuitymatrix_vw
set statistics time off;



select * from WHPSAcuityMatrixDS

select * from WHPS_StudentAcuityScores_Vw
select * from whps_acuitymatrix_vw

select * from WHPSStudentAcuityScoresDS

select * from WHPSAcuityMatrixDS

select * from WHPSProfLevelAimsWebPlusDS
WHPSStudentAcuityScoresDS


--select * from fn_dashboardreportsdetails(38) where  dashboardname = 'acuity matrix'
--select * from fn_dashboardreportsdetails(38) where  dashboardname = 'student growth - i-ready'
--select * from fn_dashboardreportsdetails(38) where  dashboardname = 'student growth - aimsweb plus'
--select * from fn_dashboardreportsdetails(38) where  dashboardname = 'sbac longitudinal performance'
--select * from fn_dashboardreportsdetails(38) where  dashboardname = 'sbac'
--select * from fn_dashboardreportsdetails(38) where  dashboardname = 'student performance'
--select * from fn_dashboardreportsdetails(38) where  dashboardname = 'sat/psat'
--select * from fn_dashboardreportsdetails(38) where  dashboardname = 'las links growth'
--select * from fn_dashboardreportsdetails(38) where  dashboardname = 'las links'
--select * from fn_dashboardreportsdetails(38) where  dashboardname = 'i-ready'
--select * from fn_dashboardreportsdetails(38) where  dashboardname = 'ap - advanced placement'
select * from fn_dashboardreportsdetails(38) where  dashboardname = 'aimsweb plus'
--select * from fn_dashboardreportsdetails(38) where  dashboardname = 'discipline dashboard (whps)'
--select * from fn_dashboardreportsdetails(38) where  dashboardname = 'blitz report - teacher'
--select * from fn_dashboardreportsdetails(38) where  dashboardname = 'Discipline - High School Report'
--select * from fn_dashboardreportsdetails(38) where  dashboardname = 'All Assessments'
--select * from fn_dashboardreportsdetails(38) where  dashboardname = 'Attendance Dashboard (WHPS)'
--select * from fn_dashboardreportsdetails(38) where  dashboardname = 'District (WHPS)'
--select * from fn_dashboardreportsdetails(38) where  dashboardname = 'Enrollment Dashboard (WHPS)'
--select * from fn_dashboardreportsdetails(38) where  dashboardname = 'principal (WHPS)'
--select * from fn_dashboardreportsdetails(38) where  dashboardname = 'IT Data Imports'
select * from fn_dashboardreportsdetails(38) where  dashboardname = 'AP - Advanced Placement'
select * from fn_dashboardreportsdetails(38) where  dashboardname = 'Quest'
select * from fn_dashboardreportsdetails(38) where reportname like '%reason%'
select * from fn_dashboardreportsdetails(38) where dataset like '%WHPS_AP_ScoreDistributionDS%'


select * from fn_dashboardreportsdetails(38) where childreportid = '6970'

select top 100 * from DisciplineIncidentSCLevelCountsDS where tenantid = 38
select * from DisciplineIncidentCountsDS  where tenantid = 38

--select * from idm.tenant

--whpsassessmentallds
--whps_proflevel_aimswebplus_ds
--whpsproflevelaimswebplusds
select * from WHPSQuestESDS
exec sp_depends WHPS_PATLevelMovementStudent_Vw
exec sp_depends WHPS_ElemQuestAssessmentInfo_Vw
exec sp_depends WHPS_MiddleQuestAssessmentInfo_Vw

--WHPS_ElemQuestAssessmentInfo_Vw
--WHPS_MiddleQuestAssessmentInfo_Vw

select * from dbo.AssessmentSubgrpProfDS
select * from [whpsireadytermlevelsds]
select * from [idm].[studentssubgroup] where tenantid = 38


exec sp_depends whpslaslinksds
exec sp_depends whpssbacdsnew
exec sp_depends whpssbacds
exec sp_depends whpsaimswebplustermlevelsds
exec sp_depends whpssatpsatssds
exec sp_helptext WHPSProfLevelAimsWebPlusDS
exec sp_helptext WHPSStudentAcuityScoresDS
exec sp_helptext StudentsDisciplineAverageDS
exec sp_helptext K12SpecialEducationStudent_View
exec sp_helptext WHPS_ElemQuestAssessmentInfo_Vw
exec sp_helptext WHPS_MiddleQuestAssessmentInfo_Vw

select * from aggrptk12studentdetails where schoolyear = 2026 and tenantid = 38

select * from main.k12studentdailyattendance where schoolyear = 2026 and tenantid = 38
select * from dbo.RefAttendanceStatus where tenantid = 38

select * from main.WHPS_Attendance where schoolyear = 2026
select * from main.WHPS_PeriodAttendance where schoolyear = 2026

select * from IDM.AppErrorLog order by 1 desc

select * from K12SpecialEducationStudent_View


select distinct reportdetailsid from linkedreportmappedfileds where childreportid='6970'

select * from WHPSAcuityMatrixDS

select * from fn_dashboardreportsdetails(38) where  dashboardname = 'acuity matrix'

exec sp_helptext WHPSAcuityMatrixDS
exec sp_helptext [WHPS_AcuityMatrix_Vw]


select * from refproficiencyacuity where tenantid = 38 and assessmentcode = 'Acuity Matrix' and sy = 2026

CREATE VIEW RefProficiencyAcuityLevels AS
SELECT '2026' AS SchoolYear, 'On watch' AS ProficiencyCode, 'On watch' AS ProficiencyDescription, 3 AS Value, '#1c8704' AS ColorCode, NULL AS Min, NULL AS Max, 'Acuity Matrix' AS AssessmentCode, 'Reading' AS SubjectAreaCode, 'PROFLVL' AS MetricCode, 3 AS SortOrder, 38 AS TenantId, 1 AS StatusId
UNION ALL
SELECT '2026', 'Progressing as expected for grade level', 'Progressing as expected for grade level', 4, '#005F89', NULL, NULL, 'Acuity Matrix', 'Reading', 'PROFLVL', 4, 38, 1
UNION ALL
SELECT '2026', 'Tier 2', 'Intervention', 2, '#FEC900', NULL, NULL, 'Acuity Matrix', 'Reading', 'PROFLVL', 2, 38, 1
UNION ALL
SELECT '2026', 'Tier 3', 'Urgent Intervention', 1, '#CD1900', NULL, NULL, 'Acuity Matrix', 'Reading', 'PROFLVL', 1, 38, 1
UNION ALL
SELECT '2026', 'Cannot Calculate Score', 'Cannot Calculate Score', 5, '#808080', NULL, NULL, 'Acuity Matrix', 'Reading', 'PROFLVL', 5, 38, 1;

select * from assessmentinfo where tenantid = 38

select * from refproficiencyacuitylevels where ProficiencyDescription in(
select ProficiencyDescription  from refproficiencylevel where tenantid = 38 and assessmentcode = 'acuity matrix' and SY=2026)
and tenantid = 38 and assessmentcode <> 'acuity matrix' and SY=2026

select distinct  Assessment,GradeCode from assessmentinfo where tenantid = 38 and Assessment in
('STAR'
,'SBAC'
,'SAT'
,'PSATNM'
,'PSAT89'
,'PSAT/SAT'
,'PAT'
,'NGSS'
,'NWEA'
,'LASLinks'
,'i-Ready'
,'AP'
,'AIMSWebPlus')
order by 1

sp_helptext StudentsDisciplineAverageDS


select * from fn_dashboardreportsdetails(38) where  dashboardname = 'AP - Advanced Placement'

select * from idm.apperrorlog order by 1 desc

select * from WHPSAPAllYearsViewChartDs


--Acuity Matrix
select * from idm.studentssubgroup where tenantid = '38' and statusid = 1 order by sortorder

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
