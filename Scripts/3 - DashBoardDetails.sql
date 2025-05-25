use AnalyticVue_Norwood
SELECT 
    rd.ReportDetailsId AS [ParentReportId],
    rd.ReportDetailsName AS [ParentReportName],
    rdd.DataDomainName AS [Domain Name],
    rrt.ReportTypeDescription AS [Report Type],
    rdrv.DisplayName AS [Data Set],
    'dbo.' + idmds_parent.tablename AS [ParentReportViewName], 
    child_rd.ReportDetailsId AS [ChildReportId],
    child_rd.ReportDetailsName AS [ChildReportName],
    child_rdd.DataDomainName AS [ChildReportDomainName],
    child_rrt.ReportTypeDescription AS [ChildReportType],
    child_rdrv.DisplayName AS [ChildReportDataSet],
    'dbo.' + idmds_child.tablename AS [ChildReportViewName],  
    rd.TenantId

FROM 
    ReportDetails rd
LEFT JOIN 
    RefDataDomain rdd ON rd.DataDomainId = rdd.DataDomainId
LEFT JOIN 
    RefReportType rrt ON rd.ReportTypeId = rrt.ReportTypeId
LEFT JOIN 
    RptDomainRelatedViews rdrv ON rd.DomainRelatedViewId = rdrv.DomainRelatedViewId
LEFT JOIN 
    ReportDetails child_rd ON rd.ChildReportId = child_rd.ReportDetailsId
LEFT JOIN 
    RefDataDomain child_rdd ON child_rd.DataDomainId = child_rdd.DataDomainId
LEFT JOIN 
    RefReportType child_rrt ON child_rd.ReportTypeId = child_rrt.ReportTypeId
LEFT JOIN 
    RptDomainRelatedViews child_rdrv ON child_rd.DomainRelatedViewId = child_rdrv.DomainRelatedViewId
LEFT JOIN (
    
    SELECT DISTINCT DomainRelatedViewId, 
           (SELECT TOP 1 tablename FROM idm.DataSetColumn AS sub 
            WHERE sub.DomainRelatedViewId = main.DomainRelatedViewId) AS tablename
    FROM idm.DataSetColumn AS main
) AS idmds_parent ON rd.DomainRelatedViewId = idmds_parent.DomainRelatedViewId

LEFT JOIN (
    
    SELECT DISTINCT DomainRelatedViewId, 
           (SELECT TOP 1 tablename FROM idm.DataSetColumn AS sub 
            WHERE sub.DomainRelatedViewId = main.DomainRelatedViewId) AS tablename
    FROM idm.DataSetColumn AS main
) AS idmds_child ON child_rd.DomainRelatedViewId = idmds_child.DomainRelatedViewId

WHERE rd.TenantId = 46 AND rd.ReportDetailsId in 

(1435,1436,1437,1438,1439,1442,1443,1444,1446,1447,1448,1449,1450)
