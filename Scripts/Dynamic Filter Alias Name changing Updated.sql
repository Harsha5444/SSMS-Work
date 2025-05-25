DECLARE 
    @AliasName VARCHAR(200) = '"REIP Indicator"',
    @NewAliasName VARCHAR(200) = '"REP Indicator"',
    @TenantId INT = 50;


IF OBJECT_ID('tempdb..#Datasets') IS NOT NULL   DROP TABLE #V_Datasets;

SELECT DISTINCT DomainRelatedViewId INTO #V_Datasets FROM ReportDetails
WHERE ReportFileDetails LIKE '%"AliasName":' + @AliasName + '%' AND TenantId = @TenantId;

UPDATE rd
SET rd.ReportFileDetails = REPLACE(rd.ReportFileDetails, @AliasName, @NewAliasName)
FROM ReportDetails rd
JOIN #V_Datasets ds ON rd.DomainRelatedViewId = ds.DomainRelatedViewId
WHERE rd.ReportFileDetails LIKE '%"AliasName":' + @AliasName + '%'
  AND rd.TenantId = @TenantId;

SELECT 
    d.DomainRelatedViewId,
    rv.DisplayName AS DatasetName,
    'Updated "' + @AliasName + '" to "' + @NewAliasName + '"' AS Status
FROM #V_Datasets d
JOIN RptDomainRelatedViews rv ON d.DomainRelatedViewId = rv.DomainRelatedViewId;

DROP TABLE #V_Datasets;
