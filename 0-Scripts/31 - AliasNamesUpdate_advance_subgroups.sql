-- Safety cleanup if cursor already exists
IF CURSOR_STATUS('global', 'report_cursor') >= -1
BEGIN
    CLOSE report_cursor;
    DEALLOCATE report_cursor;
END

-- Step 1: Input parameters
DECLARE @ColumnName NVARCHAR(100) = 'termname';
DECLARE @NewAlias NVARCHAR(100) = 'Term Name';

-- Step 2: Variables for processing
DECLARE @ReportId INT;
DECLARE @json NVARCHAR(MAX);
DECLARE @indexAdvance INT;
DECLARE @indexSubGroup INT;
DECLARE @oldAlias NVARCHAR(100);
DECLARE @updated BIT;

-- Step 3: Temp table to store log
DECLARE @UpdateLog TABLE (
    ReportId INT,
    Section NVARCHAR(50),
    OldAlias NVARCHAR(100),
    NewAlias NVARCHAR(100)
);

-- Step 4: Cursor to loop through matching JSONs
DECLARE report_cursor CURSOR FOR
SELECT ReportDetailsId, ReportFileDetails
FROM ReportDetails
WHERE ReportFileDetails LIKE '%"ColumnName":"' + @ColumnName + '"%' and ReportDetailsId 
in (8907, 8908, 8909, 8910, 8911, 8912, 8913, 8914, 8920, 8921, 8922, 8923, 8924, 8925, 8926, 8927, 8868, 8870, 8878, 8879, 8880, 8881, 8882, 8890, 8891, 8892, 8893, 8894, 8895, 8852, 8851, 8853, 8951, 8936, 8937, 8939, 8932, 8933, 8934, 8935, 8948, 8949, 8950, 8944, 8943, 8942, 8945)

OPEN report_cursor;
FETCH NEXT FROM report_cursor INTO @ReportId, @json;

WHILE @@FETCH_STATUS = 0
BEGIN
    -- Reset indexes and flags
    SET @indexAdvance = NULL;
    SET @indexSubGroup = NULL;
    SET @updated = 0;

    -- ===== AdvanceFilter Update =====
    SELECT @indexAdvance = [key]
    FROM OPENJSON(@json, '$.AdvanceFilter')
    WHERE JSON_VALUE([value], '$.ColumnName') = @ColumnName;

    IF @indexAdvance IS NOT NULL
    BEGIN
        SELECT @oldAlias = JSON_VALUE(@json, CONCAT('$.AdvanceFilter[', @indexAdvance, '].AliasName'));

        IF ISNULL(@oldAlias, '') <> @NewAlias
        BEGIN
            SET @json = JSON_MODIFY(@json, CONCAT('$.AdvanceFilter[', @indexAdvance, '].AliasName'), @NewAlias);
            INSERT INTO @UpdateLog (ReportId, Section, OldAlias, NewAlias)
            VALUES (@ReportId, 'AdvanceFilter', ISNULL(@oldAlias, 'NULL'), @NewAlias);
            SET @updated = 1;
        END
    END

    -- ===== SubGroupColumns Update =====
    SELECT @indexSubGroup = [key]
    FROM OPENJSON(@json, '$.SubGroupColumns')
    WHERE JSON_VALUE([value], '$.ColumnName') = @ColumnName;

    IF @indexSubGroup IS NOT NULL
    BEGIN
        SELECT @oldAlias = JSON_VALUE(@json, CONCAT('$.SubGroupColumns[', @indexSubGroup, '].AliasName'));

        IF ISNULL(@oldAlias, '') <> @NewAlias
        BEGIN
            SET @json = JSON_MODIFY(@json, CONCAT('$.SubGroupColumns[', @indexSubGroup, '].AliasName'), @NewAlias);
            INSERT INTO @UpdateLog (ReportId, Section, OldAlias, NewAlias)
            VALUES (@ReportId, 'SubGroupColumns', ISNULL(@oldAlias, 'NULL'), @NewAlias);
            SET @updated = 1;
        END
    END

    -- ===== Final update if any changes made =====
    IF @updated = 1
    BEGIN
        UPDATE ReportDetails
        SET ReportFileDetails = @json
        WHERE ReportDetailsId = @ReportId;
        --select @json
    END

    FETCH NEXT FROM report_cursor INTO @ReportId, @json;
END

CLOSE report_cursor;
DEALLOCATE report_cursor;

-- ===== Show results in table format =====
SELECT 
    ReportId AS [ReportDetailsId],
    Section,
    OldAlias AS [Old Alias],
    NewAlias AS [New Alias]
FROM @UpdateLog;
