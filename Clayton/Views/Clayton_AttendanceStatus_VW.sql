ALTER VIEW [dbo].[Clayton_AttendanceStatus_VW] --1638623
AS
SELECT id.studentNumber,
     a.statestudentid,
	a.SchoolName
	,a.Grade
	,a.Gender
	,a.Race
	,a.[504Status]
	,a.GiftedandTalented
	,a.AgeGroup
	,CASE 
		WHEN Agegroup < 6
			THEN 'Students under age 6'
		WHEN Agegroup >= 6
			AND Agegroup <= 15
			THEN 'Students age between 6 and 15'
		WHEN Agegroup >= 16
			THEN 'Students age 16 and over'
		END AS AgeCategory
	,a.SchoolCategory
	,a.SchoolIdentifier
	,a.SpecialEdStatus
	,a.ELL
	,a.FRL
	,a.Homeless
	,a.DisabilityReason AS Disability
	,a.StudentFullName
	,CASE 
		WHEN ap.EIP = 'y'
			THEN 'Yes'
		ELSE 'No'
		END AS EIP
	,CASE 
		WHEN ap.GAA = 'y'
			THEN 'Yes'
		ELSE 'No'
		END AS GAA
	,CASE 
		WHEN ap.RemedialEducationEIP IS NOT NULL
			AND ap.RemedialEducationEIP != ''
			THEN 'Yes'
		ELSE 'No'
		END AS REIP
	,[date]
	,CASE 
		WHEN magnet = 'Y'
			AND MagnetSchoolType = 'Program Within School'
			THEN 'Program Within School'
		WHEN magnet = 'N'
			AND MagnetSchoolType = 'Program Within School'
			THEN NULL
		ELSE MagnetSchoolType
		END AS Magnet
	,AbsenceType
	,serviceType
	,EnrollmentStartDate
	,id.EnrollmentEndDate
	,WithdrawalCode
	,WithdrawalCodeDescription
	,TotalDaysPresent
	,TotalDaysAbsent
	,AverageDailyAttendance
	,AbsenteeismPercentage
	,SchoolOverrideCode
	,SchoolOverrideName
	,UnexcusedTardy
	,ExcusedTardy
	,[Period]
	,id.SchoolYear
	,id.TenantId
	,[Status]
	,[Type]
	,NULL AS IEP
	,CASE 
		WHEN [Type] = 'E'
			AND [Status] = 'T'
			THEN 'ExcusedTardy'
		WHEN [Type] = 'E'
			AND [Status] = 'A'
			THEN 'ExcusedAbsence'
		WHEN [Type] = 'U'
			AND [Status] = 'T'
			THEN 'UnExcusedTardy'
		WHEN [Type] = 'U'
			AND [Status] = 'A'
			THEN 'UnExcusedAbsence'
		END AS AbsenceStatus
FROM main.clayton_analyticvue_icdayattendance id
JOIN aggrptk12studentdetails a ON a.DistrictStudentId = id.studentNumber
	AND a.SchoolIdentifier = id.SchoolNumber
	AND a.TenantId = id.TenantId
	AND a.SchoolYear = id.SchoolYear
LEFT JOIN main.clayton_analyticvue_icprograms ap ON id.studentNumber = ap.studentNumber
	AND id.SchoolNumber = ap.Number
	AND id.SchoolYear = ap.SchoolYear
	AND id.TenantId = ap.TenantId



