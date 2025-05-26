SELECT ic.studentnumber AS DistrictStudentId
	,CONCAT (ISNULL(ic.lastName, ''),', ',ISNULL(ic.firstName, ''),' ',ISNULL(ic.middleName, '')) AS StudentFullName
	,ic.SchoolYear
	,sc.SchoolIdentifier
	,'Clayton County' AS LeaName
	,sc.NameofInstitution AS SchoolName
	,CASE ic.gender WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' ELSE ic.gender END AS Gender
	,rg.GradeDescription AS Grade
	,cat.SchoolCategoryCode AS SchoolCategory
	,ic.raceEthnicity AS Race
	,CASE ic.gender WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' ELSE ic.gender END AS GenderCode
	,rg.GradeCode
	,ic.stateID AS StateStudentId
	,ISNULL(pvt.[Migrant], 'No') AS Migrant
	,ISNULL([GiftedStatus], 'No') AS GiftedandTalented
	,NULL AS ELL
	,NULL AS FRL
	,ISNULL(dist.DisabilityTypeDescription, 'No') AS Disability
	,ISNULL([Special Education Services], 'No') AS SpecialEdStatus
	,ISNULL([Section 504 Placement], 'No') AS [504Status]
	,ISNULL([Georgia Alternate Assessment], 'No') AS GAA
	,ISNULL([Student Success Team], 'No') AS [Student Success Team]
	,ISNULL([Limited English Proficient], 'No') AS [Limited English Proficient]
	,ISNULL(pvt.[Homeless], 'No') AS [Homeless]
	,NULL AS EIP
	,ic.TenantId
	,NULL AS REIP
	,NULL AS IEP
	,NULL AS Magnet
FROM (
	SELECT *
	FROM (
		SELECT *
			,ROW_NUMBER() OVER (
				PARTITION BY studentnumber
				,schoolyear ORDER BY startdate DESC
				) AS rno
		FROM main.clayton_analyticvue_icstudents WITH (NOLOCK)
		Where Schoolyear <> '2025'
		) a
	WHERE rno = 1
	) ic
LEFT JOIN RefGrade rg WITH (NOLOCK)
	ON rg.TenantId = ic.TenantId
		AND rg.GradeCode = ic.grade
LEFT JOIN Main.K12School sc WITH (NOLOCK)
	ON ic.schoolyear = sc.schoolyear
		AND ic.tenantid = sc.tenantid
		AND CASE WHEN ic.schoolnumber = '6008'
				AND ic.SchoolName LIKE '%High%' THEN '0036008' WHEN ic.schoolnumber = '6008'
				AND ic.SchoolName LIKE '%Middle%' THEN '0026008' WHEN ic.schoolnumber = '6008'
				AND ic.SchoolName LIKE '%Elem%' THEN '0016008' WHEN ic.schoolnumber = '6422'
				AND ic.SchoolName LIKE '%High%' THEN '0096422' WHEN ic.schoolnumber = '6422'
				AND ic.SchoolName LIKE '%Middle%' THEN '0236422' WHEN ic.schoolnumber = '6422'
				AND ic.SchoolName LIKE '%Elem%' THEN '1286422' WHEN ic.schoolnumber = '6004'
				AND ic.SchoolName LIKE '%High%' THEN '0086004' WHEN ic.schoolnumber = '6004'
				AND ic.SchoolName LIKE '%Middle%' THEN '0226004' WHEN ic.schoolnumber = '0114'
				AND ic.SchoolName = '24-25 Elite Scholars Middle' THEN '0990114' ELSE ic.schoolnumber END = sc.SchoolIdentifier
LEFT JOIN RefSchoolCategory cat WITH (NOLOCK)
	ON sc.SchoolCategoryId = cat.SchoolCategoryId
LEFT JOIN Main.K12DisabilityStudent dis WITH (NOLOCK)
	ON dis.SchoolYear = ic.schoolyear
		AND dis.DistrictStudentId = ic.studentnumber
		AND dis.TenantId = ic.TenantId
LEFT JOIN dbo.RefDisabilityType dist WITH (NOLOCK)
	ON dist.DisabilityTypeId = dis.PrimaryDisabilityTypeCodeId
		AND dist.TenantId = ic.TenantId
INNER JOIN (
	SELECT SchoolYear
		,DistrictStudentId
		,SchoolIdentifier
		,sp.TenantId
		,ProgramTypeDescription
		,ProgramParticipationStatusDescription
	FROM [Main].[K12StudentProgram] sp
	LEFT JOIN refprogramtype pt
		ON sp.ProgramTypeId = pt.ProgramTypeId
			AND sp.TenantId = pt.TenantId
	LEFT JOIN RefProgramParticipationStatus rp
		ON sp.ProgramParticipationStatusId = rp.ProgramParticipationStatusId
			AND sp.TenantId = rp.TenantId
	WHERE ProgramTypeDescription IN (
			'Migrant'
			,'GiftedStatus'
			,'Special Education Services'
			,'Section 504 Placement'
			,'Georgia Alternate Assessment'
			,'Magnet'
			,'Student Success Team'
			,'Limited English Proficient'
			,'Homeless'
			,'Early Intervention Program'
			,'RemedialEducationEIP'
			)
	) AS src
PIVOT(MIN(ProgramParticipationStatusDescription) FOR ProgramTypeDescription IN (
			[Migrant]
			,[GiftedStatus]
			,[Special Education Services]
			,[Section 504 Placement]
			,[Georgia Alternate Assessment]
			,[Magnet]
			,[Student Success Team]
			,[Limited English Proficient]
			,[Homeless]
			,[Early Intervention Program]
			,[RemedialEducationEIP]
			)) AS Pvt
	ON ic.SchoolYear = pvt.SchoolYear
		AND ic.studentnumber = pvt.DistrictStudentId
		AND ic.schoolnumber = pvt.SchoolIdentifier
		AND ic.TenantId = pvt.TenantId
WHERE ic.TenantId = 50
