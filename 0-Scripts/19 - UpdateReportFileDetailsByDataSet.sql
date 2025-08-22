DECLARE @DatasetName NVARCHAR(255) = 'Clayton_Assessment_EOG_DS';
DECLARE @ColumnName NVARCHAR(100) = 'Magnet';
DECLARE @ColumnAliasName NVARCHAR(100) = 'Magnet School Type';
DECLARE @DebugOnly BIT = 1; -- Set to 0 to actually update
DECLARE @TenantId INT = 50;
DECLARE @CreatedBy NVARCHAR(255) = 'AnalyticVue.Admin@Clayton';

-- Get DomainRelatedViewId and FieldId 
DECLARE @DomainRelatedViewId INT;
DECLARE @FieldId NVARCHAR(50);
DECLARE @DefaultValue SQL_VARIANT = NULL;

SELECT 
    @DomainRelatedViewId = rdrv.DomainRelatedViewId,
    @FieldId = CAST(rvf.RptViewFieldsId AS NVARCHAR(50))
FROM RptDomainRelatedViews rdrv
JOIN RptViewFields rvf ON rdrv.DomainRelatedViewId = rvf.DomainRelatedViewId
WHERE rdrv.DisplayName = @DatasetName 
  AND rvf.DisplayName = @ColumnName;

-- Show what we found
SELECT 
    @DatasetName AS DatasetName,
    @DomainRelatedViewId AS DomainRelatedViewId,
    @ColumnName AS ColumnName,
    @FieldId AS FieldId;

-- Create the JSON object
DECLARE @ColumnJSON NVARCHAR(MAX) = (
    SELECT 
        @ColumnName AS DisplayName,
        @ColumnName AS ColumnName,
        @ColumnAliasName AS AliasName,
        0 AS SortOrder,
        @FieldId AS FiledId,
        @DefaultValue AS DefaultValue
    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER, INCLUDE_NULL_VALUES
);

-- Create a table to hold reports that need updating
DECLARE @ReportsToUpdate TABLE (
    ReportDetailsId INT PRIMARY KEY,
    ReportDetailsName NVARCHAR(255),
    CurrentJson NVARCHAR(MAX),
    NeedsAdvanceFilterUpdate BIT,
    NeedsSubGroupUpdate BIT
);

-- Identify reports that need updates (don't already have the column)
INSERT INTO @ReportsToUpdate
SELECT 
    rd.ReportDetailsId,
    rd.ReportDetailsName,
    rd.ReportFileDetails AS CurrentJson,
    CASE WHEN JSON_QUERY(rd.ReportFileDetails, '$.AdvanceFilter') IS NOT NULL 
         AND EXISTS (
             SELECT 1 FROM OPENJSON(JSON_QUERY(rd.ReportFileDetails, '$.AdvanceFilter'))
             WHERE JSON_VALUE([value], '$.ColumnName') = @ColumnName
         ) THEN 0 ELSE 1 END AS NeedsAdvanceFilterUpdate,
    CASE WHEN JSON_QUERY(rd.ReportFileDetails, '$.SubGroupColumns') IS NOT NULL 
         AND EXISTS (
             SELECT 1 FROM OPENJSON(JSON_QUERY(rd.ReportFileDetails, '$.SubGroupColumns'))
             WHERE JSON_VALUE([value], '$.ColumnName') = @ColumnName
         ) THEN 0 ELSE 1 END AS NeedsSubGroupUpdate
FROM ReportDetails rd
WHERE rd.DomainRelatedViewId = @DomainRelatedViewId
AND (
    JSON_QUERY(rd.ReportFileDetails, '$.AdvanceFilter') IS NULL OR
    NOT EXISTS (
        SELECT 1 FROM OPENJSON(JSON_QUERY(rd.ReportFileDetails, '$.AdvanceFilter'))
        WHERE JSON_VALUE([value], '$.ColumnName') = @ColumnName
    ) OR
    JSON_QUERY(rd.ReportFileDetails, '$.SubGroupColumns') IS NULL OR
    NOT EXISTS (
        SELECT 1 FROM OPENJSON(JSON_QUERY(rd.ReportFileDetails, '$.SubGroupColumns'))
        WHERE JSON_VALUE([value], '$.ColumnName') = @ColumnName
    )
);

-- Show reports that need updating with proposed changes
SELECT 
    r.ReportDetailsId,
    r.ReportDetailsName,
    r.CurrentJson,
    CASE 
        WHEN r.NeedsAdvanceFilterUpdate = 1 AND r.NeedsSubGroupUpdate = 1 THEN
            JSON_MODIFY(
                JSON_MODIFY(
                    ISNULL(r.CurrentJson, '{}'),
                    'append $.AdvanceFilter',
                    JSON_QUERY(@ColumnJSON)
                ),
                'append $.SubGroupColumns',
                JSON_QUERY(@ColumnJSON)
            )
        WHEN r.NeedsAdvanceFilterUpdate = 1 THEN
            JSON_MODIFY(
                ISNULL(r.CurrentJson, '{}'),
                'append $.AdvanceFilter',
                JSON_QUERY(@ColumnJSON)
            )
        WHEN r.NeedsSubGroupUpdate = 1 THEN
            JSON_MODIFY(
                ISNULL(r.CurrentJson, '{}'),
                'append $.SubGroupColumns',
                JSON_QUERY(@ColumnJSON)
            )
        ELSE r.CurrentJson
    END AS ProposedJson,
    r.NeedsAdvanceFilterUpdate,
    r.NeedsSubGroupUpdate
FROM @ReportsToUpdate r;

-- Generate UPDATE statements only for reports that need changes
SELECT 
    r.ReportDetailsId,
    r.ReportDetailsName,
    'UPDATE ReportDetails SET ReportFileDetails = ''' + 
    REPLACE(
        CAST(
            CASE 
                WHEN r.NeedsAdvanceFilterUpdate = 1 AND r.NeedsSubGroupUpdate = 1 THEN
                    JSON_MODIFY(
                        JSON_MODIFY(
                            ISNULL(r.CurrentJson, '{}'),
                            'append $.AdvanceFilter',
                            JSON_QUERY(@ColumnJSON)
                        ),
                        'append $.SubGroupColumns',
                        JSON_QUERY(@ColumnJSON)
                    )
                WHEN r.NeedsAdvanceFilterUpdate = 1 THEN
                    JSON_MODIFY(
                        ISNULL(r.CurrentJson, '{}'),
                        'append $.AdvanceFilter',
                        JSON_QUERY(@ColumnJSON)
                    )
                WHEN r.NeedsSubGroupUpdate = 1 THEN
                    JSON_MODIFY(
                        ISNULL(r.CurrentJson, '{}'),
                        'append $.SubGroupColumns',
                        JSON_QUERY(@ColumnJSON)
                    )
                ELSE r.CurrentJson
            END AS NVARCHAR(MAX)
        ), 
        '''', '''''') + -- Escape single quotes for SQL
    ''' WHERE ReportDetailsId = ' + CAST(r.ReportDetailsId AS NVARCHAR(20)) + ';' AS UpdateStatement
FROM @ReportsToUpdate r
WHERE r.NeedsAdvanceFilterUpdate = 1 OR r.NeedsSubGroupUpdate = 1;

-- Only update if debug mode is off
IF @DebugOnly = 0
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Update parent reports' JSON (only what needs updating)
        UPDATE rd
        SET rd.ReportFileDetails = 
            CASE 
                WHEN r.NeedsAdvanceFilterUpdate = 1 AND r.NeedsSubGroupUpdate = 1 THEN
                    JSON_MODIFY(
                        JSON_MODIFY(
                            ISNULL(rd.ReportFileDetails, '{}'),
                            'append $.AdvanceFilter',
                            JSON_QUERY(@ColumnJSON)
                        ),
                        'append $.SubGroupColumns',
                        JSON_QUERY(@ColumnJSON)
                    )
                WHEN r.NeedsAdvanceFilterUpdate = 1 THEN
                    JSON_MODIFY(
                        ISNULL(rd.ReportFileDetails, '{}'),
                        'append $.AdvanceFilter',
                        JSON_QUERY(@ColumnJSON)
                    )
                WHEN r.NeedsSubGroupUpdate = 1 THEN
                    JSON_MODIFY(
                        ISNULL(rd.ReportFileDetails, '{}'),
                        'append $.SubGroupColumns',
                        JSON_QUERY(@ColumnJSON)
                    )
                ELSE rd.ReportFileDetails
            END
        FROM ReportDetails rd
        JOIN @ReportsToUpdate r ON rd.ReportDetailsId = r.ReportDetailsId
        WHERE r.NeedsAdvanceFilterUpdate = 1 OR r.NeedsSubGroupUpdate = 1;
        
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
ELSE
BEGIN
    SELECT 'Debug mode - only showing proposed ReportDetails changes. Set @DebugOnly = 0 to execute updates.' AS Result;
END