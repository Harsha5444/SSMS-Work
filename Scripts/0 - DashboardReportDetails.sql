WITH RecursiveCTE
AS (
	SELECT DashboardId
		,dashboardname
		,CHARINDEX('<div id="dashboardchart', DashboardContent) AS start_pos
		,DashboardContent
	FROM dashboard WITH (NOLOCK)
	WHERE tenantid = 50
	
	UNION ALL
	
	SELECT DashboardId
		,dashboardname
		,CHARINDEX('<div id="dashboardchart', DashboardContent, start_pos + 1)
		,DashboardContent
	FROM RecursiveCTE
	WHERE start_pos > 0
	)
	,ExtractedIDs
AS (
	SELECT DISTINCT DashboardId
		,DashboardName
		,SUBSTRING(DashboardContent, start_pos + 24, CHARINDEX('"', DashboardContent, start_pos + 24) - (start_pos + 24)) AS extracted_id
	FROM RecursiveCTE
	WHERE start_pos > 0
	)
	,DashboardReports
AS (
	SELECT DISTINCT DashboardId
		,DashboardName
		,SUBSTRING(extracted_id, CHARINDEX('_', extracted_id) + 1, LEN(extracted_id)) AS reportdetailsid
	FROM ExtractedIDs
	WHERE extracted_id IS NOT NULL
	)
	,ViewDependencies
AS (
	SELECT v.name AS view_name
		,STUFF((
				SELECT ' / ' + SCHEMA_NAME(OBJECTPROPERTY(d.referenced_id, 'SchemaId')) + '.' + OBJECT_NAME(d.referenced_id)
				FROM sys.sql_expression_dependencies d
				WHERE d.referencing_id = v.object_id
					AND d.referenced_id IS NOT NULL
				ORDER BY SCHEMA_NAME(OBJECTPROPERTY(d.referenced_id, 'SchemaId'))
					,OBJECT_NAME(d.referenced_id)
				FOR XML PATH('')
				), 1, 3, '') AS dependency_tables
	FROM sys.VIEWS v
	)
SELECT t.TenantName AS [TenantName]
	,dgd.GroupName
	,dr.DashboardName
	,rd.ReportDetailsId AS [ReportId]
	,rd.ReportDetailsName AS [ReportName]
	,rdd.DataDomainName AS [DomainName]
	,rrt.ReportTypeDescription AS [ReportType]
	,coalesce(rdrv.DisplayName, json_value(rd.ReportFileDetails, '$.FileName'), NULL) AS [DataSet]
	,idmds_parent.tablename AS [ViewName]
	,vd.dependency_tables AS [ViewDependencies]
	,child_rd.ReportDetailsId AS [ChildReportId]
	,child_rd.ReportDetailsName AS [ChildReportName]
	,child_rdd.DataDomainName AS [ChildReportDomainName]
	,child_rrt.ReportTypeDescription AS [ChildReportType]
	,child_rdrv.DisplayName AS [ChildReportDataSet]
	,idmds_child.tablename AS [ChildReportViewName]
	,rd.TenantId
FROM DashboardReports dr
LEFT JOIN (
	SELECT DISTINCT dashboardid
		,dashboardgroupdefid
	FROM DashboardGroups WITH (NOLOCK)
	) dg
	ON dr.DashboardId = dg.DashboardId
LEFT JOIN (
	SELECT DISTINCT DashboardGroupDefID
		,groupname
	FROM DashboardGroupDef WITH (NOLOCK)
	) dgd
	ON dg.DashboardGroupDefID = dgd.DashboardGroupDefID
INNER JOIN ReportDetails rd WITH (NOLOCK)
	ON dr.reportdetailsid = CAST(rd.reportdetailsid AS VARCHAR(50))
INNER JOIN idm.Tenant t WITH (NOLOCK)
	ON rd.TenantId = t.TenantId
LEFT JOIN RefDataDomain rdd WITH (NOLOCK)
	ON rd.DataDomainId = rdd.DataDomainId
LEFT JOIN RefReportType rrt WITH (NOLOCK)
	ON rd.ReportTypeId = rrt.ReportTypeId
LEFT JOIN RptDomainRelatedViews rdrv WITH (NOLOCK)
	ON rd.DomainRelatedViewId = rdrv.DomainRelatedViewId
LEFT JOIN ReportDetails child_rd WITH (NOLOCK)
	ON rd.ChildReportId = child_rd.ReportDetailsId
LEFT JOIN RefDataDomain child_rdd WITH (NOLOCK)
	ON child_rd.DataDomainId = child_rdd.DataDomainId
LEFT JOIN RefReportType child_rrt WITH (NOLOCK)
	ON child_rd.ReportTypeId = child_rrt.ReportTypeId
LEFT JOIN RptDomainRelatedViews child_rdrv WITH (NOLOCK)
	ON child_rd.DomainRelatedViewId = child_rdrv.DomainRelatedViewId
LEFT JOIN (
	SELECT DISTINCT DomainRelatedViewId
		,MAX(tablename) AS tablename
	FROM idm.DataSetColumn WITH (NOLOCK)
	GROUP BY DomainRelatedViewId
	) AS idmds_parent
	ON rd.DomainRelatedViewId = idmds_parent.DomainRelatedViewId
LEFT JOIN (
	SELECT DISTINCT DomainRelatedViewId
		,MAX(tablename) AS tablename
	FROM idm.DataSetColumn WITH (NOLOCK)
	GROUP BY DomainRelatedViewId
	) AS idmds_child
	ON child_rd.DomainRelatedViewId = idmds_child.DomainRelatedViewId
LEFT JOIN ViewDependencies vd
	ON idmds_parent.tablename = vd.view_name
LEFT JOIN ViewDependencies child_vd
	ON idmds_child.tablename = child_vd.view_name
