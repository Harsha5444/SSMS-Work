WITH MAPBase
AS (
	---38480
	SELECT [SchoolYear]
		,[Districtstudentid]
		,[SubjectAreaName]
		,[RITScore(Fall)]
		,[RITScore(Winter)]
		,[RITScore(Spring)]
		,[TestPercentile(Fall)]
		,[TestPercentile(Winter)]
		,[TestPercentile(Spring)]
		,TenantId
	FROM (
		SELECT SchoolYear
			,StudentID AS Districtstudentid
			,[Subject] AS SubjectAreaName
			,'RITScore(' + substring(Termname, 1, charindex(' ', Termname) - 1) + ')' AS Termcode
			,TestRITScore AS MetricValue
			,TenantId
		FROM main.Hallco_MAP_AssessmentResults
		WHERE [Subject] = 'Mathematics'
		
		UNION ALL
		
		SELECT SchoolYear
			,StudentID AS Districtstudentid
			,[Subject] AS SubjectAreaName
			,'TestPercentile(' + substring(Termname, 1, charindex(' ', Termname) - 1) + ')' AS Termcode
			,TestPercentile AS MetricValue
			,TenantId
		FROM main.Hallco_MAP_AssessmentResults
		WHERE [Subject] = 'Mathematics'
		) t
	PIVOT(MAX(MetricValue) FOR Termcode IN ([RITScore(Fall)], [RITScore(Winter)], [RITScore(Spring)], [TestPercentile(Fall)], [TestPercentile(Winter)], [TestPercentile(Spring)])) u
	)
	,EOGBase
AS (
	SELECT SchoolYear
		,studentnumber AS DistrictStudentId
		,'Math' AS [SubjectAreaName]
		,Orders AS ScaleScore
		,Tenantid
	FROM (
		SELECT TestAdmin
			,GTID_RPT
			,a.SchoolYear
			,s.studentnumber
			,SS_ELA
			,SS_Math
			,SS_Sci
			,SS_Soc
			,a.Tenantid
		FROM main.Hallco_EOG a
		INNER JOIN main.hallco_icstudents s ON a.tenantid = s.tenantid
			AND a.schoolyear = s.endyear
			AND a.gtid_rpt = s.stateID
			AND SchCode_RPT = schoolnumber
		WHERE s.servicetype = 'P'
		) p
	UNPIVOT(Orders FOR SubjectAreaCode IN (SS_ELA, SS_Math, SS_Sci, SS_Soc)) AS unpvt
	WHERE SubjectAreaCode = 'SS_Math'
	)
	,DisciplineCounts
AS (
	SELECT SchoolYear
		,offenderIdentifier AS Districtstudentid
		,COUNT(Incidentnumber) TotalIncidents
		,TenantId
	FROM main.K12DisciplineOffenders WITH (NOLOCK)
	GROUP BY schoolyear
		,offenderIdentifier
		,TenantId
	)
	,Base
AS (
	SELECT agg.SchoolYear
		,agg.Districtstudentid
		,agg.StudentFullName AS StudentFullName
		,agg.GradeCode AS GradeCode
		,agg.Presentrate AS presentPercentage
		,agg.IsChronic AS ChronicallyAbsent
		,agg.Race AS Race
		,agg.GenderCode AS Gender
		,agg.SpecialEdStatus AS Disability
		,'Free Lunch' AS FRL
		,agg.TenantId
		,a.[RITScore(Fall)] AS [MAPRITScore(Fall)]
		,a.[RITScore(Winter)] AS [MAPRITScore(Winter)]
		,a.[RITScore(Spring)] AS [MAPRITScore(Spring)]
		,a.[TestPercentile(Fall)] [MAPTestPercentile(Fall)]
		,a.[TestPercentile(Winter)] [MAPTestPercentile(Winter)]
		,a.[TestPercentile(Spring)] [MAPTestPercentile(Spring)]
		,t.ScaleScore AS EOGScaleScore
		,t.[SubjectAreaName]
		,ISNULL(c.TotalIncidents, 0) AS TotalIncidents
	FROM Aggrptk12Studentdetails agg
	INNER JOIN EOGBase t ON agg.SchoolYear = t.SchoolYear
		AND agg.DistrictStudentId = t.DistrictStudentId
		AND agg.TenantId = t.TenantId
	INNER JOIN MAPBase a ON a.DistrictStudentId = t.DistrictStudentId
		AND a.schoolyear = t.SchoolYear
		AND a.TenantId = t.TenantId
	LEFT JOIN DisciplineCounts c ON agg.SchoolYear = c.SchoolYear
		AND agg.DistrictStudentId = c.DistrictStudentId
		AND c.TenantId = agg.TenantId
	)
SELECT b.SchoolYear
	,b.DistrictStudentId
	,b.StudentFullName
	,b.GradeCode
	,b.[SubjectAreaName]
	,b.[MAPRITScore(Fall)]
	,b.[MAPRITScore(Winter)]
	,b.[MAPRITScore(Spring)]
	,b.[MAPTestPercentile(Fall)]
	,b.[MAPTestPercentile(Winter)]
	,b.[MAPTestPercentile(Spring)]
	,b.EOGScaleScore
	,b.presentPercentage
	,b.ChronicallyAbsent
	,b.Race
	,b.Gender
	,b.Disability
	,b.FRL
	,b.TotalIncidents
FROM Base b
--WHERE EOGScaleScore is not null 
ORDER BY Schoolyear
	,GradeCode
	,Race
	,Gender;

