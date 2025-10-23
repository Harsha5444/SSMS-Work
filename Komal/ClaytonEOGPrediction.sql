WITH MAPBase
AS (
	---87695
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
			,'RITScore(' + TestTerm + ')' AS Termcode
			,TestRITScore AS MetricValue
			,TenantId
		FROM clayton_assessment_map
		WHERE [Subject] = 'Mathematics' --316308
		
		UNION ALL
		
		SELECT SchoolYear
			,StudentID AS Districtstudentid
			,[Subject] AS SubjectAreaName
			,'TestPercentile(' + TestTerm + ')' AS Termcode
			,TestPercentile AS MetricValue
			,TenantId
		FROM clayton_assessment_map
		WHERE [Subject] = 'Mathematics' --316308
		) t
	PIVOT(MAX(MetricValue) FOR Termcode IN ([RITScore(Fall)], [RITScore(Winter)], [RITScore(Spring)], [TestPercentile(Fall)], [TestPercentile(Winter)], [TestPercentile(Spring)])) u
	)
	,EOGBase
AS (
	SELECT SchoolYear
		,studentNumber AS Districtstudentid
		,testType AS [SubjectAreaName]
		,SS AS ScaleScore
		,TenantId
	FROM clayton_assessment_eog
	WHERE testType = 'Math'
	)
	,DisciplineCounts
AS (
	SELECT SchoolYear
		,offenderIdentifier as Districtstudentid
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
		,agg.StudentName AS StudentFullName
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
	FROM CCPSK12StudentDetails agg
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

