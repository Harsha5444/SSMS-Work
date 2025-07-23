DROP TABLE #AllReportsColumnOrder
DROP TABLE #AllReportsAliasOrder  
DROP TABLE #OrderMismatchReports

-- Create temp tables to store results for all reports
CREATE TABLE #AllReportsColumnOrder (
    ReportDetailsId INT,
    SortOrder INT,
    ColumnName NVARCHAR(255),
    ColumnType NVARCHAR(50),
    ExtractedOrder INT
)

CREATE TABLE #AllReportsAliasOrder (
    ReportDetailsId INT,
    OriginalName NVARCHAR(255),
    AliasName NVARCHAR(255),
    AliasOrder INT
)

CREATE TABLE #OrderMismatchReports (
    ReportDetailsId INT,
    TotalColumns INT,
    TotalAliases INT,
    MismatchCount INT,
    HasOrderMismatch BIT
)

-- Cursor to process all reports
DECLARE @ReportId INT
DECLARE @JsonData NVARCHAR(MAX)
DECLARE @Counter INT = 1

DECLARE report_cursor CURSOR FOR
SELECT ReportDetailsId, reportfiledetails 
FROM ReportDetails 
WHERE reportfiledetails IS NOT NULL
and cast(CreatedDate as date) not in ('2024-07-26') and CreatedBy<>'DDAUser@DDA'
 --and ReportDetailsId = 278
AND ISJSON(reportfiledetails) = 1

OPEN report_cursor
FETCH NEXT FROM report_cursor INTO @ReportId, @JsonData

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Counter = 1
    
    -- Extract CategoryColumns if they exist
    IF JSON_QUERY(@JsonData, '$.CategoryColumns') IS NOT NULL
    BEGIN
        INSERT INTO #AllReportsColumnOrder (ReportDetailsId, SortOrder, ColumnName, ColumnType, ExtractedOrder)
        SELECT 
            @ReportId,
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)),
            value,
            'Category',
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL))
        FROM OPENJSON(JSON_QUERY(@JsonData, '$.CategoryColumns'))
        WHERE value IS NOT NULL
        
        SET @Counter = @Counter + (SELECT COUNT(*) FROM OPENJSON(JSON_QUERY(@JsonData, '$.CategoryColumns')))
    END
    
-- Extract SeriesColumn if it exists and is an array
IF JSON_QUERY(@JsonData, '$.SeriesColumn') IS NOT NULL
BEGIN
    INSERT INTO #AllReportsColumnOrder (ReportDetailsId, SortOrder, ColumnName, ColumnType, ExtractedOrder)
    SELECT 
        @ReportId,
        @Counter + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1,
        value,
        'Series',
        @Counter + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1
    FROM OPENJSON(JSON_QUERY(@JsonData, '$.SeriesColumn'))
    WHERE value IS NOT NULL
    
    SET @Counter = @Counter + (SELECT COUNT(*) FROM OPENJSON(JSON_QUERY(@JsonData, '$.SeriesColumn')))
END
    -- Extract ValueColumn if it exists
    IF JSON_QUERY(@JsonData, '$.ValueColumn') IS NOT NULL
    BEGIN
        INSERT INTO #AllReportsColumnOrder (ReportDetailsId, SortOrder, ColumnName, ColumnType, ExtractedOrder)
        SELECT 
            @ReportId,
            @Counter + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1,
            JSON_VALUE(value, '$.Value'),
            'Value',
            @Counter + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1
        FROM OPENJSON(JSON_QUERY(@JsonData, '$.ValueColumn'))
        WHERE JSON_VALUE(value, '$.Value') IS NOT NULL
    END
    
    -- Extract AliasNameList if it exists
    IF JSON_QUERY(@JsonData, '$.AliasNameList') IS NOT NULL
    BEGIN
        INSERT INTO #AllReportsAliasOrder (ReportDetailsId, OriginalName, AliasName, AliasOrder)
        SELECT 
            @ReportId,
            JSON_VALUE(value, '$.Name'),
            JSON_VALUE(value, '$.AliasName'),
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL))
        FROM OPENJSON(JSON_QUERY(@JsonData, '$.AliasNameList'))
        WHERE JSON_VALUE(value, '$.Name') IS NOT NULL
    END

    FETCH NEXT FROM report_cursor INTO @ReportId, @JsonData
END

CLOSE report_cursor
DEALLOCATE report_cursor

-- Analyze order mismatches for each report
INSERT INTO #OrderMismatchReports (ReportDetailsId, TotalColumns, TotalAliases, MismatchCount, HasOrderMismatch)
SELECT 
    co.ReportDetailsId,
    COUNT(DISTINCT co.ColumnName) as TotalColumns,
    COUNT(DISTINCT ao.OriginalName) as TotalAliases,
    SUM(CASE WHEN co.ColumnName IS NULL OR ao.OriginalName IS NULL OR co.ColumnName != ao.OriginalName OR co.SortOrder != ao.AliasOrder THEN 1 ELSE 0 END) as MismatchCount,
    CASE WHEN SUM(CASE WHEN co.ColumnName IS NULL OR ao.OriginalName IS NULL OR co.ColumnName != ao.OriginalName OR co.SortOrder != ao.AliasOrder THEN 1 ELSE 0 END) > 0 THEN 1 ELSE 0 END as HasOrderMismatch
FROM #AllReportsColumnOrder co
FULL OUTER JOIN #AllReportsAliasOrder ao ON co.ReportDetailsId = ao.ReportDetailsId AND co.SortOrder = ao.AliasOrder
GROUP BY co.ReportDetailsId

-- Show summary of all reports with order issues
SELECT 
    'SUMMARY: Reports with Order Mismatches' as ReportType,
    COUNT(*) as TotalReportsWithMismatches
FROM #OrderMismatchReports 
WHERE HasOrderMismatch = 1

---- Show detailed list of reports with mismatches
--SELECT 
--    omr.ReportDetailsId,
--    omr.TotalColumns,
--    omr.TotalAliases,
--    omr.MismatchCount,
--    'ORDER_MISMATCH' as Status
--FROM #OrderMismatchReports omr
--WHERE omr.HasOrderMismatch = 1
--ORDER BY omr.ReportDetailsId

---- Detailed analysis: Show extraction order vs alias order for ALL reports
--SELECT 
--    COALESCE(co.ReportDetailsId, ao.ReportDetailsId) as ReportDetailsId,
--    STRING_AGG(COALESCE(co.ColumnName, '(NULL)'), ', ') WITHIN GROUP (ORDER BY COALESCE(co.SortOrder, ao.AliasOrder)) as ExtractedColumnOrder,
--    STRING_AGG(COALESCE(ao.OriginalName, '(NULL)'), ', ') WITHIN GROUP (ORDER BY ao.AliasOrder) as AliasNameOrder,
--    CASE 
--        WHEN STRING_AGG(COALESCE(co.ColumnName, '(NULL)'), ', ') WITHIN GROUP (ORDER BY COALESCE(co.SortOrder, ao.AliasOrder)) = 
--             STRING_AGG(COALESCE(ao.OriginalName, '(NULL)'), ', ') WITHIN GROUP (ORDER BY ao.AliasOrder) 
--        THEN 'PERFECT_MATCH' 
--        ELSE 'ORDER_MISMATCH' 
--    END as OrderStatus
--FROM #AllReportsColumnOrder co
--FULL OUTER JOIN #AllReportsAliasOrder ao ON co.ReportDetailsId = ao.ReportDetailsId
--GROUP BY COALESCE(co.ReportDetailsId, ao.ReportDetailsId)
--ORDER BY 
--    CASE 
--        WHEN STRING_AGG(COALESCE(co.ColumnName, '(NULL)'), ', ') WITHIN GROUP (ORDER BY COALESCE(co.SortOrder, ao.AliasOrder)) = 
--             STRING_AGG(COALESCE(ao.OriginalName, '(NULL)'), ', ') WITHIN GROUP (ORDER BY ao.AliasOrder) 
--        THEN 1 ELSE 0 
--    END, 
--    COALESCE(co.ReportDetailsId, ao.ReportDetailsId)

-- Clean up
--DROP TABLE #AllReportsColumnOrder
--DROP TABLE #AllReportsAliasOrder  
--DROP TABLE #OrderMismatchReports

WITH ColumnOrderCTE AS (
    SELECT 
        ReportDetailsId,
        STRING_AGG(ColumnName, ', ') WITHIN GROUP (ORDER BY SortOrder) as ColumnOrder
    FROM #AllReportsColumnOrder
    GROUP BY ReportDetailsId
),
AliasOrderCTE AS (
    SELECT 
        ReportDetailsId,
        STRING_AGG(OriginalName, ', ') WITHIN GROUP (ORDER BY AliasOrder) as AliasOrder
    FROM #AllReportsAliasOrder
    GROUP BY ReportDetailsId
),
CombinedData AS (
    SELECT 
        COALESCE(c.ReportDetailsId, a.ReportDetailsId) as ReportDetailsId,
        COALESCE(c.ColumnOrder, '(NO COLUMNS)') as ColumnOrder,
        COALESCE(a.AliasOrder, '(NO ALIASES)') as AliasOrder
    FROM ColumnOrderCTE c
    FULL OUTER JOIN AliasOrderCTE a ON c.ReportDetailsId = a.ReportDetailsId
)
SELECT 
    ReportDetailsId,
    ColumnOrder as ExtractedColumnOrder,
    AliasOrder as AliasNameOrder,
    CASE 
        WHEN ColumnOrder = AliasOrder THEN 'PERFECT_MATCH'
        WHEN ColumnOrder = '(NO COLUMNS)' THEN 'MISSING_COLUMNS'
        WHEN AliasOrder = '(NO ALIASES)' THEN 'MISSING_ALIASES'
        ELSE 'ORDER_MISMATCH' 
    END as OrderStatus
FROM CombinedData
ORDER BY 
    CASE 
        WHEN ColumnOrder = AliasOrder THEN 1
        ELSE 0 
    END,
    ReportDetailsId