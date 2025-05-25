use AnalyticVue_norwood
DECLARE @tenantid INT,  @Dashboardreportquery NVARCHAR(MAX);
SET @tenantid = 46;    
IF @Tenantid IN (33, 34,45)
    BEGIN
        USE AnalyticVue_District;
    END
    ELSE IF @Tenantid = 36
    BEGIN
        USE AnalyticVue_FPS;
    END
	ELSE IF @Tenantid = 50
    BEGIN
        USE AnalyticVue_Clayton;
    END
    ELSE IF @Tenantid IN (30,38, 31)
    BEGIN
        USE AnalyticVue_OBS;
    END
    ELSE IF @Tenantid = 47
    BEGIN
        USE AnalyticVue_Hallco;
    END
    ELSE IF @Tenantid = 49
    BEGIN
        USE AnalyticVue_Norwood;
    END
SET @Dashboardreportquery = '
WITH RecursiveCTE AS (
    -- Anchor part
    SELECT 
        dashboardname,
        CAST(NULLIF(CHARINDEX(''<div id="dashboardchart'', DashboardContent), 0) AS INT) AS start_pos,
        DashboardContent,
        CAST(NULL AS NVARCHAR(MAX)) AS extracted_id
    FROM dashboard  
    WHERE tenantid = ' + CAST(@tenantid AS NVARCHAR(10)) + '
    UNION ALL
    -- Recursive part
    SELECT 
        dashboardname,
        CAST(CHARINDEX(''<div id="dashboardchart'', DashboardContent, start_pos + 1) AS INT) AS start_pos,
        DashboardContent,
        CAST(SUBSTRING(
            DashboardContent,
            start_pos + 24,
            CHARINDEX(''"'', DashboardContent, start_pos + 24) - (start_pos + 24)
        ) AS NVARCHAR(MAX)) AS extracted_id
    FROM RecursiveCTE
    WHERE start_pos > 0
)
SELECT 
    dashboardname AS DashboardName,
    SUBSTRING(extracted_id, CHARINDEX(''_'', extracted_id) + 1, LEN(extracted_id))
	--''('' + STRING_AGG(SUBSTRING(extracted_id, CHARINDEX(''_'', extracted_id) + 1, LEN(extracted_id)), '','') +'')'' AS ReportdetailsId
FROM RecursiveCTE
WHERE extracted_id IS NOT NULL
GROUP BY dashboardname;'

PRINT @Dashboardreportquery;

EXEC sp_executesql @Dashboardreportquery;
