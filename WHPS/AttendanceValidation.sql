select distinct CAST(ATT_DATE AS DATE) from [Main].[WHPS_Attendance] 
where 1=1
and schoolyear = 2024 
and student_number ='119350'
and (
		[Presence_Status_CD] <> 'Present'
		OR [ATT_CODE] IN (
			'T'
			,'T15'
			,'TEX'
			,'TUX'
			)
		)
and [ATT_CODE] not in (
				'T'
				,'T15'
				,'TEX'
				,'TUX'
				)
order by CAST(ATT_DATE AS DATE) desc

select * from main.K12StudentDailyAttendance
where 1=1
and schoolyear = 2024
and districtstudentid = '119350'
and AttendanceStatusId in (select AttendanceStatusId from refattendancestatus where tenantid = 38 and AttendanceStatusDescription='Absent')
order by cast(attendancedate as date) desc

select * from Import_K12StudentDailyAttendance_Vw_38
where 1=1
and schoolyear = 2024
and districtstudentid = '119350'
and [AttendanceStatus] in ('ABS')


select AttendanceStatusId from refattendancestatus where tenantid = 38 and AttendanceStatusDescription='Present'

select * from refattendancestatus where tenantid = 38