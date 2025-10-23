WITH RecursiveCTE
AS (
	-- Anchor part
	SELECT 
		AP.DisplayName
		,Tabname
		,GradeDescription
		,rg.sortorder
		,CAST(NULLIF(CHARINDEX('<div id="dashboardchart', TabProfileContent), 0) AS INT) AS start_pos
		,TabProfileContent
		,CAST(NULL AS NVARCHAR(MAX)) AS extracted_id
	FROM AnalyticProfileDashboard APD
	INNER JOIN AnalyticProfile AP ON apd.tenantid = ap.tenantid
		AND apd.AnalyticProfileId = ap.AnalyticProfileId
	INNER JOIN AnalyticProfilePublish APP ON apd.tenantid = APP.tenantid
		AND apd.AnalyticProfileId = APP.AnalyticProfileId
	INNER JOIN refgrade RG ON RG.tenantid = APP.tenantid
		AND RG.gradeid = app.gradeid
	WHERE apd.tenantid = 4 and TabProfileContent is not null --and Tabname = 'Course Section'
	
	UNION ALL
	
	-- Recursive part
	SELECT  DisplayName
		,Tabname
		,GradeDescription
		,sortorder
		,CAST(CHARINDEX('<div id="dashboardchart', TabProfileContent, start_pos + 1) AS INT) AS start_pos
		,TabProfileContent
		,CAST(SUBSTRING(TabProfileContent, start_pos + 24, CHARINDEX('"', TabProfileContent, start_pos + 24) - (start_pos + 24)) AS NVARCHAR(MAX)) AS extracted_id
	FROM RecursiveCTE
	WHERE start_pos > 0
),
ExtractedData AS (
	SELECT  
		DisplayName,
		Tabname,
		SUBSTRING(extracted_id, CHARINDEX('_', extracted_id) + 1, LEN(extracted_id)) AS ReportDetailsId,
		GradeDescription,
		SortOrder
	FROM RecursiveCTE
	WHERE extracted_id IS NOT NULL
),
AggregatedGrades AS (
	SELECT  
		DisplayName,
		Tabname,
		ReportDetailsId,
		STUFF((
			SELECT ',' + ED2.GradeDescription
			FROM ExtractedData ED2
			WHERE ED2.ReportDetailsId = ED1.ReportDetailsId
			ORDER BY ED2.SortOrder
			FOR XML PATH(''), TYPE
			).value('.', 'NVARCHAR(MAX)'), 1, 1, '') AS GradeList
	FROM ExtractedData ED1
	GROUP BY DisplayName, Tabname, ReportDetailsId
)
SELECT 
	DisplayName,
	Tabname as SectionName,
	ReportDetailsId,
	GradeList
FROM AggregatedGrades
ORDER BY Tabname,ReportDetailsId;