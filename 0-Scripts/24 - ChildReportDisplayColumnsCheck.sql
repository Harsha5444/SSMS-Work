-- Declare dataset and column names
DECLARE @DatasetName NVARCHAR(255) = 'Clayton_EOG_DomainScores_DS';
DECLARE @ColumnName NVARCHAR(100) = 'GTID';

-- Declare IDs
DECLARE @DomainRelatedViewId INT;
DECLARE @FieldId INT;
DECLARE @DebugOnly INT = 1; -- Set to 1 for debug mode, 0 to apply updates

-- Step 1: Get DomainRelatedViewId and FieldId for the given dataset and column
SELECT 
    @DomainRelatedViewId = rdrv.DomainRelatedViewId,
    @FieldId = CAST(rvf.RptViewFieldsId AS INT)
FROM RptDomainRelatedViews rdrv
JOIN RptViewFields rvf ON rdrv.DomainRelatedViewId = rvf.DomainRelatedViewId
WHERE rdrv.DisplayName = @DatasetName 
  AND rvf.DisplayName = @ColumnName;

SELECT 
    @DatasetName AS DatasetName,
    @DomainRelatedViewId AS DomainRelatedViewId,
    @ColumnName AS ColumnName,
    @FieldId AS FieldId;

-- Step 2: Prepare the JSON block to insert if missing
DECLARE @ColumnJSON NVARCHAR(MAX) = (
    SELECT 
        @FieldId AS Value,
        @ColumnName AS Text,
        0 AS [Key]
    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER, INCLUDE_NULL_VALUES
);

SELECT @ColumnJSON;

-- Step 3: Identify reports needing update
DECLARE @ReportsToUpdate TABLE (
    ReportDetailsId INT PRIMARY KEY,
    ReportDetailsName NVARCHAR(255),
    CurrentJson NVARCHAR(MAX),
    NeedsUpdate BIT
);

-- Step 4: Populate @ReportsToUpdate with those that do NOT contain the column already
INSERT INTO @ReportsToUpdate
SELECT 
    rd.ReportDetailsId,
    rd.ReportDetailsName,
    rd.ReportFileDetails AS CurrentJson,
    CASE 
        WHEN JSON_QUERY(rd.ReportFileDetails, '$.ChildReportdisplaycolumnList') IS NOT NULL 
             AND EXISTS (
                 SELECT 1 
                 FROM OPENJSON(JSON_QUERY(rd.ReportFileDetails, '$.ChildReportdisplaycolumnList'))
                 WHERE JSON_VALUE([value], '$.Text') = @ColumnName
             ) 
        THEN 0 
        ELSE 1 
    END AS NeedsUpdate
FROM ReportDetails rd
WHERE rd.DomainRelatedViewId = @DomainRelatedViewId and rd.ReportTypeId<>1
  AND (
        JSON_QUERY(rd.ReportFileDetails, '$.ChildReportdisplaycolumnList') IS NULL
        OR NOT EXISTS (
            SELECT 1 
            FROM OPENJSON(JSON_QUERY(rd.ReportFileDetails, '$.ChildReportdisplaycolumnList'))
            WHERE JSON_VALUE([value], '$.Text') = @ColumnName
        )
    );

-- Step 5: Preview changes before applying update (Debug Mode Check)
IF @DebugOnly = 1
BEGIN
    -- Show proposed changes without applying
    SELECT 
        r.ReportDetailsId,
        r.ReportDetailsName,
        r.CurrentJson,
        CASE 
            WHEN r.NeedsUpdate = 1 THEN
                JSON_MODIFY(
                    ISNULL(r.CurrentJson, '{}'),
                    'append $.ChildReportdisplaycolumnList',
                    JSON_QUERY(@ColumnJSON)
                )
            ELSE r.CurrentJson
        END AS ProposedJson,
        r.NeedsUpdate
    FROM @ReportsToUpdate r;
    
    -- Generate the SQL update statements as text (for debugging purposes)
    SELECT 
        'UPDATE ReportDetails SET ReportFileDetails = ''' + 
        REPLACE(
            CAST(
                CASE 
                    WHEN r.NeedsUpdate = 1 THEN
                        JSON_MODIFY(
                            ISNULL(r.CurrentJson, '{}'),
                            'append $.ChildReportdisplaycolumnList',
                            JSON_QUERY(@ColumnJSON)
                        )
                    ELSE r.CurrentJson
                END AS NVARCHAR(MAX)
            ), 
            '''', '''''') + -- Escape single quotes for SQL
        ''' WHERE ReportDetailsId = ' + CAST(r.ReportDetailsId AS NVARCHAR(20)) + ';' AS UpdateStatement
    FROM @ReportsToUpdate r
    WHERE r.NeedsUpdate = 1;
END
ELSE
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        UPDATE rd
        SET rd.ReportFileDetails = 
            CASE 
                WHEN r.NeedsUpdate = 1 THEN
                    JSON_MODIFY(
                        ISNULL(rd.ReportFileDetails, '{}'),
                        'append $.ChildReportdisplaycolumnList',
                        JSON_QUERY(@ColumnJSON)
                    )
                ELSE rd.ReportFileDetails
            END
        FROM ReportDetails rd
        JOIN @ReportsToUpdate r ON rd.ReportDetailsId = r.ReportDetailsId
        WHERE r.NeedsUpdate = 1;
        
        COMMIT TRANSACTION;
        
        SELECT 'ReportDetails updates completed successfully' AS Result;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        SELECT 
            'Error' AS Result,
            ERROR_MESSAGE() AS ErrorMessage,
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_LINE() AS ErrorLine,
            ERROR_PROCEDURE() AS ErrorProcedure;
    END CATCH;
END
