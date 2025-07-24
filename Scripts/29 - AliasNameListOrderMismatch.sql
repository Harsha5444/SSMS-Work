IF OBJECT_ID('tempdb..#AllReportsColumnOrder') IS NOT NULL
    DROP TABLE #AllReportsColumnOrder

IF OBJECT_ID('tempdb..#AllReportsAliasOrder') IS NOT NULL
    DROP TABLE #AllReportsAliasOrder

IF OBJECT_ID('tempdb..#OrderMismatchReports') IS NOT NULL
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
 --and ReportDetailsId = 280
AND ISJSON(reportfiledetails) = 1
AND reporttypeid IN ('1','2')


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
GROUP BY co.ReportDetailsId;


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
        COALESCE(a.AliasOrder, '(NO ALIASES)') as AliasOrder,
        CASE 
            WHEN c.ColumnOrder = a.AliasOrder THEN 'PERFECT_MATCH'
            WHEN c.ColumnOrder IS NULL THEN 'MISSING_COLUMNS'
            WHEN a.AliasOrder IS NULL THEN 'MISSING_ALIASES'
            ELSE 'ORDER_MISMATCH' 
        END as OrderStatus
    FROM ColumnOrderCTE c
    FULL OUTER JOIN AliasOrderCTE a ON c.ReportDetailsId = a.ReportDetailsId
)
SELECT 
    ReportDetailsId,
    ColumnOrder as ExtractedColumnOrder,
    AliasOrder as AliasNameListOrder,
    OrderStatus 
FROM CombinedData
WHERE OrderStatus = 'ORDER_MISMATCH'  -- Only show mismatches
ORDER BY ReportDetailsId

-- Clean up
DROP TABLE #AllReportsColumnOrder
DROP TABLE #AllReportsAliasOrder  
DROP TABLE #OrderMismatchReports


--select * from reportdetails where ReportDetailsId=280


--635
--638
--927
--928
--929
--932
--935
--936
--937
--938
--940
--942
--943
--944
--949
--950
--951
--953
--955
--958
--959
--971
--973
--976
--977
--978
--979
--980
--981
--982
--983
--988
--990
--991
--992
--1006
--1007
--1010
--1020
--1027
--1028
--1029
--1030
--1046
--1047
--1053
--1055
--1056
--1062
--1072
--1073
--1074
--1075
--1076
--1077
--1078
--1079
--1080
--1082
--1083
--1084
--1092
--1093
--1094
--1095
--1096
--1097
--1098
--1099
--1100
--1101
--1102
--1103
--1104
--1105
--1106
--1107
--1108
--1109
--1113
--1114
--1115
--1116
--1117
--1118
--1120
--1121
--1123
--1129
--1130
--1140
--1159
--1165
--1166
--1167
--1168
--1171
--1191
--1192
--1194
--1198
--1203





















---- Create temp table to store all reports we need to process
--IF OBJECT_ID('tempdb..#ReportsToProcess') IS NOT NULL
--    DROP TABLE #ReportsToProcess

--SELECT 
--    ReportDetailsId, 
--    reportfiledetails AS OriginalJSON
--INTO #ReportsToProcess
--FROM ReportDetails 
--WHERE reportfiledetails IS NOT NULL
--AND CAST(CreatedDate AS DATE) NOT IN ('2024-07-26') 
--AND CreatedBy <> 'DDAUser@DDA'
--AND ISJSON(reportfiledetails) = 1
--AND reporttypeid IN ('1','2')

---- Add columns for modified JSON and status
--ALTER TABLE #ReportsToProcess ADD ModifiedJSON NVARCHAR(MAX)
--ALTER TABLE #ReportsToProcess ADD Processed BIT 
--update #ReportsToProcess set Processed = 0

---- Variables for cursor processing
--DECLARE @ReportId INT
--DECLARE @OriginalJson NVARCHAR(MAX)
--DECLARE @ModifiedJson NVARCHAR(MAX)
--DECLARE @ColumnOrder TABLE (SortOrder INT, ColumnName NVARCHAR(255))
--DECLARE @Counter INT
--DECLARE @AliasListJson NVARCHAR(MAX)

---- Cursor to process each report
--DECLARE report_cursor CURSOR FOR
--SELECT ReportDetailsId, OriginalJSON FROM #ReportsToProcess WHERE Processed = 0

--OPEN report_cursor
--FETCH NEXT FROM report_cursor INTO @ReportId, @OriginalJson

--WHILE @@FETCH_STATUS = 0
--BEGIN
--    -- Reset variables for this report
--    SET @Counter = 1
--    DELETE FROM @ColumnOrder
    
--    -- Extract column order from the JSON
    
--    -- CategoryColumns
--    IF JSON_QUERY(@OriginalJson, '$.CategoryColumns') IS NOT NULL
--    BEGIN
--        INSERT INTO @ColumnOrder (SortOrder, ColumnName)
--        SELECT 
--            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)),
--            value
--        FROM OPENJSON(JSON_QUERY(@OriginalJson, '$.CategoryColumns'))
--        WHERE value IS NOT NULL
        
--        SET @Counter = @Counter + (SELECT COUNT(*) FROM OPENJSON(JSON_QUERY(@OriginalJson, '$.CategoryColumns')))
--    END
    
--    -- SeriesColumn
--    IF JSON_QUERY(@OriginalJson, '$.SeriesColumn') IS NOT NULL
--    BEGIN
--        INSERT INTO @ColumnOrder (SortOrder, ColumnName)
--        SELECT 
--            @Counter + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1,
--            value
--        FROM OPENJSON(JSON_QUERY(@OriginalJson, '$.SeriesColumn'))
--        WHERE value IS NOT NULL
        
--        SET @Counter = @Counter + (SELECT COUNT(*) FROM OPENJSON(JSON_QUERY(@OriginalJson, '$.SeriesColumn')))
--    END
    
--    -- ValueColumn
--    IF JSON_QUERY(@OriginalJson, '$.ValueColumn') IS NOT NULL
--    BEGIN
--        INSERT INTO @ColumnOrder (SortOrder, ColumnName)
--        SELECT 
--            @Counter + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1,
--            JSON_VALUE(value, '$.Value')
--        FROM OPENJSON(JSON_QUERY(@OriginalJson, '$.ValueColumn'))
--        WHERE JSON_VALUE(value, '$.Value') IS NOT NULL
--    END
    
--    -- Only proceed if we have columns and AliasNameList exists
--    IF EXISTS (SELECT 1 FROM @ColumnOrder) 
--    AND JSON_QUERY(@OriginalJson, '$.AliasNameList') IS NOT NULL
--    BEGIN
--        -- Build ordered AliasNameList JSON manually for SQL Server 2017 compatibility
--        SELECT @AliasListJson = '[' + 
--            STUFF((
--                SELECT ',' + 
--                    '{"Name":"' + a.Name + '","AliasName":"' + ISNULL(a.AliasName, '') + '"}'
--                FROM OPENJSON(JSON_QUERY(@OriginalJson, '$.AliasNameList'))
--                WITH (
--                    Name NVARCHAR(255) '$.Name',
--                    AliasName NVARCHAR(255) '$.AliasName'
--                ) a
--                INNER JOIN @ColumnOrder c ON a.Name = c.ColumnName
--                ORDER BY c.SortOrder
--                FOR XML PATH(''), TYPE
--            ).value('.', 'NVARCHAR(MAX)'), 1, 1, '') + ']'
        
--        -- Update the original JSON with the reordered AliasNameList
--        SET @ModifiedJson = JSON_MODIFY(@OriginalJson, '$.AliasNameList', JSON_QUERY(@AliasListJson))
        
--        -- Update the temp table with modified JSON
--        UPDATE #ReportsToProcess
--        SET ModifiedJSON = @ModifiedJson,
--            Processed = 1
--        WHERE ReportDetailsId = @ReportId
--    END
--    ELSE
--    BEGIN
--        -- Mark as processed but no changes needed
--        UPDATE #ReportsToProcess
--        SET ModifiedJSON = OriginalJSON,
--            Processed = 1
--        WHERE ReportDetailsId = @ReportId
--    END
    
--    FETCH NEXT FROM report_cursor INTO @ReportId, @OriginalJson
--END

--CLOSE report_cursor
--DEALLOCATE report_cursor

---- Final output showing before/after comparison
--with ReportsToUpdate 
--as
--(
--SELECT 
--    ReportDetailsId,
--    OriginalJSON,
--    ModifiedJSON,
--    CASE 
--        WHEN OriginalJSON = ModifiedJson OR ModifiedJson IS NULL THEN 'NO_CHANGES'
--        ELSE 'MODIFIED'
--    END AS ChangeStatus
--FROM #ReportsToProcess
--WHERE ModifiedJSON IS NOT NULL
--AND (OriginalJSON <> ModifiedJSON OR ModifiedJSON IS NULL)
--)
--select a.ReportDetailsId,a.reportfiledetails,b.ModifiedJSON
--from reportdetails a
--join ReportsToUpdate b
--on a.ReportDetailsId = b.ReportDetailsId
----update a
----set a.reportfiledetails = b.ModifiedJSON
----from reportdetails a
----join ReportsToUpdate b
----on a.ReportDetailsId = b.ReportDetailsId


---- Clean up
--DROP TABLE #ReportsToProcess



