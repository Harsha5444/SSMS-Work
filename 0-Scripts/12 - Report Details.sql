DECLARE 
    @reportid INT = NULL,
    @tenantid INT = 50,
    @dataset NVARCHAR(100) = 'Clayton_Assessment_EOC_DS',
    @reportname NVARCHAR(100) = NULL,
    @childreportid INT = NULL,
    @sql NVARCHAR(MAX),
    @params NVARCHAR(MAX)


IF @tenantid IS NULL
BEGIN
    RAISERROR('The parameter @tenantid is required and cannot be NULL.', 16, 1);
    RETURN; 
END

SET @sql = '
SELECT 
    rd.ReportDetailsId AS [ParentReportId],
    rd.ReportDetailsName AS [ParentReportName],
    rdd.DataDomainName AS [Domain Name],
    rrt.ReportTypeDescription AS [Report Type],
    rdrv.DisplayName AS [Data Set],
    ''dbo.'' + idmds_parent.tablename AS [ParentReportViewName], 
    child_rd.ReportDetailsId AS [ChildReportId],
    child_rd.ReportDetailsName AS [ChildReportName],
    child_rdd.DataDomainName AS [ChildReportDomainName],
    child_rrt.ReportTypeDescription AS [ChildReportType],
    child_rdrv.DisplayName AS [ChildReportDataSet],
    ''dbo.'' + idmds_child.tablename AS [ChildReportViewName],  
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

WHERE rd.TenantId = @tenantid 
'
--and rdd.DataDomainName = 'Attendance'
--and rdd.DataDomainName = 'Dropout'
--and rdd.DataDomainName = 'Directory'
--and rdd.DataDomainName = 'Assessment'
--and rdd.DataDomainName = 'Special Education'
--and rdd.DataDomainName = 'Course Section'
--and rdd.DataDomainName = 'Employment'
--and rdd.DataDomainName = 'Discipline'
--and rdd.DataDomainName = 'Program'
--and rdd.DataDomainName = 'Section Assignment'
--and rdd.DataDomainName = 'Instructional'
--and rdd.DataDomainName = 'Graduation'
--and rdd.DataDomainName = 'Assignment'
--and rdd.DataDomainName = 'Education'
--and rdd.DataDomainName = 'Programs'

IF @reportid IS NOT NULL
    SET @sql = @sql + ' AND rd.ReportDetailsId = @reportid'
    
IF @dataset IS NOT NULL
    SET @sql = @sql + ' AND rdrv.DisplayName = @dataset'
    
IF @reportname IS NOT NULL
    SET @sql = @sql + ' AND rd.ReportDetailsName = @reportname'
    
IF @childreportid IS NOT NULL
    SET @sql = @sql + ' AND child_rd.ReportDetailsId = @childreportid'

SET @sql = @sql + ' ORDER BY rd.ReportDetailsId DESC'


SET @params = N'@reportid INT, @tenantid INT, @dataset NVARCHAR(100), @reportname NVARCHAR(100), @childreportid INT'


EXEC sp_executesql @sql, @params, @reportid, @tenantid, @dataset, @reportname, @childreportid

