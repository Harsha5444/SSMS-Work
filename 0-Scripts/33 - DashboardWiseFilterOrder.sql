WITH ReportsDetails
AS (
	SELECT r.ReportDetailsId
		,r.ReportDetailsName AS ReportName
		,af.AdvanceFilter_AliasNames AS AdvanceFilters
		,sg.SubGroupColumns_AliasName AS SubGroupColumns
		,r.DomainRelatedViewId
		,r.ReportTypeId
		,r.TenantId
	FROM reportdetails r
	CROSS APPLY (
		SELECT CASE WHEN JSON_QUERY(r.ReportFileDetails, '$.AdvanceFilter') IS NOT NULL
					AND JSON_QUERY(r.ReportFileDetails, '$.AdvanceFilter') != 'null' THEN (
							SELECT STRING_AGG(JSON_VALUE(af.value, '$.AliasName'), ', ')
							FROM OPENJSON(r.ReportFileDetails, '$.AdvanceFilter') af
							) ELSE NULL END AS AdvanceFilter_AliasNames
		) af
	CROSS APPLY (
		SELECT CASE WHEN JSON_QUERY(r.ReportFileDetails, '$.SubGroupColumns') IS NOT NULL
					AND JSON_QUERY(r.ReportFileDetails, '$.SubGroupColumns') != 'null' THEN (
							SELECT STRING_AGG(JSON_VALUE(af.value, '$.AliasName'), ', ')
							FROM OPENJSON(r.ReportFileDetails, '$.SubGroupColumns') af
							) ELSE NULL END AS SubGroupColumns_AliasName
		) sg
	WHERE r.tenantid = 38
		AND r.ReportDetailsId IN (
			SELECT DISTINCT ReportId
			FROM fn_DashboardReportsDetails(38)
			WHERE dashboardname = 'ngss'
			
			UNION
			
			SELECT DISTINCT ChildReportId
			FROM fn_DashboardReportsDetails(38)
			WHERE dashboardname = 'ngss'
			)
	)
SELECT ReportDetailsId
	,ReportName
	,T.ReportTypeDescription AS ReportType
	,D.ViewName AS DatasetName
	,AdvanceFilters
	,SubGroupColumns
FROM ReportsDetails R
JOIN RefReportType T ON r.ReportTypeId = T.ReportTypeId
	AND R.tenantid = t.tenantid
JOIN RptDomainRelatedViews D ON r.DomainRelatedViewId = d.DomainRelatedViewId
	AND r.TenantId = d.TenantId
ORDER BY T.ReportTypeDescription DESC
	,D.ViewName

----select * from refgrade where tenantid = 38
--SELECT *
--FROM WHPSiReadyTermLevelsDS sp_helptext WHPS_IReadyTermLevels

--select * from RptDomainRelatedViews where viewname = 'dbo.WHPSiReadyTermLevelsDS'

--CREATE VIEW [dbo].[WHPSiReadyTermLevelsDS]
--AS
--SELECT WHPS_IReadyTermLevels.[SchoolYear] AS [SchoolYear]
--	,WHPS_IReadyTermLevels.[LEAIdentifier] AS [LEAIdentifier]
--	,WHPS_IReadyTermLevels.[SchoolIdentifier] AS [SchoolIdentifier]
--	,WHPS_IReadyTermLevels.[SchoolName] AS [SchoolName]
--	,WHPS_IReadyTermLevels.[AssessmentName] AS [AssessmentName]
--	,WHPS_IReadyTermLevels.[SubjectAreaName] AS [SubjectAreaName]
--	,WHPS_IReadyTermLevels.[GradeCode] AS [GradeCode]
--	,WHPS_IReadyTermLevels.[GradeDescription] AS [Grade]
--	,WHPS_IReadyTermLevels.[DistrictStudentId] AS [DistrictStudentId]
--	,WHPS_IReadyTermLevels.[StudentFullName] AS [StudentFullName]
--	,WHPS_IReadyTermLevels.[Term] AS [Term]
--	,WHPS_IReadyTermLevels.[Level] AS [Level]
--	,WHPS_IReadyTermLevels.[Gender] AS [Gender]
--	,WHPS_IReadyTermLevels.[Race] AS [Race]
--	,WHPS_IReadyTermLevels.[ELL] AS [ELL]
--	,WHPS_IReadyTermLevels.[CohortGraduationYear] AS [CohortGraduationYear]
--	,WHPS_IReadyTermLevels.[SpecialEdStatus] AS [SpecialEdStatus]
--	,WHPS_IReadyTermLevels.[504Status] AS [504Status]
--	,WHPS_IReadyTermLevels.[FallProfLvl] AS [FallProfLvl]
--	,WHPS_IReadyTermLevels.[WinterProfLvl] AS [WinterProfLvl]
--	,WHPS_IReadyTermLevels.[SpringProfLvl] AS [SpringProfLvl]
--	,WHPS_IReadyTermLevels.[HomeroomTeacherID] AS [HomeroomTeacherID]
--	,WHPS_IReadyTermLevels.[HomeroomTeacher] AS [HomeroomTeacher]
--	,[WHPS_IReadyTermLevels].[IEP] AS [IEP]
--	,[WHPS_IReadyTermLevels].TenantId
--FROM [dbo].[WHPS_IReadyTermLevels] AS [WHPS_IReadyTermLevels]
--WHERE [WHPS_IReadyTermLevels].TenantId = 38


