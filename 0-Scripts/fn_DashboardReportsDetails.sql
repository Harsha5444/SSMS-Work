CREATE FUNCTION dbo.fn_DashboardReportsDetails(@TenantId INT)      
RETURNS @Results TABLE (      
    TenantName NVARCHAR(255),      
    DashboardName NVARCHAR(255),      
    ReportId INT,      
    ReportName NVARCHAR(255),      
    DomainName NVARCHAR(255),      
    ReportType NVARCHAR(255),      
    DataSet NVARCHAR(255),      
    ViewName NVARCHAR(255),      
    ChildReportId INT,      
    ChildReportName NVARCHAR(255),      
    ChildReportDomainName NVARCHAR(255),      
    ChildReportType NVARCHAR(255),      
    ChildReportDataSet NVARCHAR(255),      
    ChildReportViewName NVARCHAR(255),      
    TenantId INT      
)      
AS      
BEGIN      
         
    DECLARE @DashboardReports TABLE (      
        DashboardName NVARCHAR(255),      
        reportdetailsid NVARCHAR(50)      
    );      
            
    WITH RecursiveCTE AS (      
        SELECT dashboardname,      
               CHARINDEX('<div id="dashboardchart', DashboardContent) AS start_pos,      
               DashboardContent      
        FROM dashboard WITH (NOLOCK)      
        WHERE tenantid = @TenantId      
              
        UNION ALL      
              
        SELECT dashboardname,      
               CHARINDEX('<div id="dashboardchart', DashboardContent, start_pos + 1),      
               DashboardContent      
        FROM RecursiveCTE      
        WHERE start_pos > 0      
    )      
    INSERT INTO @DashboardReports (DashboardName, reportdetailsid)      
    SELECT DISTINCT DashboardName,      
           SUBSTRING(extracted_id, CHARINDEX('_', extracted_id) + 1, LEN(extracted_id)) AS reportdetailsid      
    FROM (      
        SELECT DISTINCT dashboardname AS DashboardName,      
               SUBSTRING(DashboardContent, start_pos + 24, CHARINDEX('"', DashboardContent, start_pos + 24) - (start_pos + 24)) AS extracted_id      
        FROM RecursiveCTE      
        WHERE start_pos > 0      
    ) AS ExtractedIDs      
    WHERE extracted_id IS NOT NULL      
    OPTION (MAXRECURSION 1000);      
          
    INSERT INTO @Results      
    SELECT       
        t.TenantName AS [TenantName],      
        dr.DashboardName,      
        rd.ReportDetailsId AS [ReportId],      
        rd.ReportDetailsName AS [ReportName],      
        rdd.DataDomainName AS [DomainName],      
        rrt.ReportTypeDescription AS [ReportType],      
        COALESCE(rdrv.DisplayName, JSON_VALUE(rd.ReportFileDetails, '$.FileName'), NULL) AS [DataSet],      
        idmds_parent.tablename AS [ViewName],      
        child_rd.ReportDetailsId AS [ChildReportId],      
        child_rd.ReportDetailsName AS [ChildReportName],      
        child_rdd.DataDomainName AS [ChildReportDomainName],      
        child_rrt.ReportTypeDescription AS [ChildReportType],      
        child_rdrv.DisplayName AS [ChildReportDataSet],      
        idmds_child.tablename AS [ChildReportViewName],      
        rd.TenantId      
    FROM @DashboardReports dr      
    INNER JOIN ReportDetails rd WITH (NOLOCK) ON dr.reportdetailsid = CAST(rd.reportdetailsid AS VARCHAR(50))      
    INNER JOIN idm.Tenant t WITH (NOLOCK) ON rd.TenantId = t.TenantId      
    LEFT JOIN RefDataDomain rdd WITH (NOLOCK) ON rd.DataDomainId = rdd.DataDomainId      
    LEFT JOIN RefReportType rrt WITH (NOLOCK) ON rd.ReportTypeId = rrt.ReportTypeId      
    LEFT JOIN RptDomainRelatedViews rdrv WITH (NOLOCK) ON rd.DomainRelatedViewId = rdrv.DomainRelatedViewId      
    LEFT JOIN ReportDetails child_rd WITH (NOLOCK) ON rd.ChildReportId = child_rd.ReportDetailsId      
    LEFT JOIN RefDataDomain child_rdd WITH (NOLOCK) ON child_rd.DataDomainId = child_rdd.DataDomainId      
    LEFT JOIN RefReportType child_rrt WITH (NOLOCK) ON child_rd.ReportTypeId = child_rrt.ReportTypeId      
    LEFT JOIN RptDomainRelatedViews child_rdrv WITH (NOLOCK) ON child_rd.DomainRelatedViewId = child_rdrv.DomainRelatedViewId      
    LEFT JOIN (      
        SELECT DISTINCT DomainRelatedViewId, MAX(tablename) AS tablename      
        FROM idm.DataSetColumn WITH (NOLOCK)      
 GROUP BY DomainRelatedViewId      
    ) AS idmds_parent ON rd.DomainRelatedViewId = idmds_parent.DomainRelatedViewId      
    LEFT JOIN (      
        SELECT DISTINCT DomainRelatedViewId, MAX(tablename) AS tablename      
        FROM idm.DataSetColumn WITH (NOLOCK)      
        GROUP BY DomainRelatedViewId      
    ) AS idmds_child ON child_rd.DomainRelatedViewId = idmds_child.DomainRelatedViewId      
 ORDER BY dr.DashboardName;          
    RETURN;      
END; 