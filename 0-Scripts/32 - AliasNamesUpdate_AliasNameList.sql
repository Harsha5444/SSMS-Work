-- Safety cleanup if cursor already exists
IF CURSOR_STATUS('global', 'alias_cursor') >= -1
BEGIN
    CLOSE alias_cursor;
    DEALLOCATE alias_cursor;
END



--	    
--SchoolName	        School Name
--SpecialEdStatus 	Special Education Status
--termid	            Term Id


-- Step 1: Input parameters
DECLARE @ColumnName NVARCHAR(100) = 'Race';
DECLARE @NewAlias NVARCHAR(100) = 'Race/Ethnicity';

-- Step 2: Variables for processing
DECLARE @ReportId INT;
DECLARE @json NVARCHAR(MAX);
DECLARE @indexAlias INT;
DECLARE @oldAlias NVARCHAR(100);
DECLARE @updated BIT;

-- Step 3: Temp table to store log
DECLARE @UpdateLog TABLE (
    ReportId INT,
    OldAlias NVARCHAR(100),
    NewAlias NVARCHAR(100)
);

-- Step 4: Cursor to loop through matching JSONs
DECLARE alias_cursor CURSOR FOR
SELECT ReportDetailsId, ReportFileDetails
FROM ReportDetails
WHERE ReportFileDetails LIKE '%"Name":"' + @ColumnName + '"%' 
  AND ReportDetailsId   
  IN (
    8851, 8852, 8853, 8932, 8933, 8934, 8935, 
    8936, 8937, 8939, 8942, 8943, 8944, 8945, 
    8948, 8949, 8950, 8951
)

OPEN alias_cursor;
FETCH NEXT FROM alias_cursor INTO @ReportId, @json;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @indexAlias = NULL;
    SET @updated = 0;

    -- ===== AliasNameList Update =====
    SELECT @indexAlias = [key]
    FROM OPENJSON(@json, '$.AliasNameList')
    WHERE JSON_VALUE([value], '$.Name') = @ColumnName;

    IF @indexAlias IS NOT NULL
    BEGIN
        SELECT @oldAlias = JSON_VALUE(@json, CONCAT('$.AliasNameList[', @indexAlias, '].AliasName'));

        IF ISNULL(@oldAlias, '') <> @NewAlias
        BEGIN
            SET @json = JSON_MODIFY(@json, CONCAT('$.AliasNameList[', @indexAlias, '].AliasName'), @NewAlias);
            INSERT INTO @UpdateLog (ReportId, OldAlias, NewAlias)
            VALUES (@ReportId, ISNULL(@oldAlias, 'NULL'), @NewAlias);
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

    FETCH NEXT FROM alias_cursor INTO @ReportId, @json;
END

CLOSE alias_cursor;
DEALLOCATE alias_cursor;

-- ===== Show results =====
SELECT 
    ReportId AS [ReportDetailsId],
    OldAlias AS [Old Alias],
    NewAlias AS [New Alias]
FROM @UpdateLog
ORDER BY ReportId;
