-- Dynamic Filter Dependency Verification System for SQL Server 2017
-- Drop existing temp tables
IF OBJECT_ID('tempdb..#FiltersExpanded') IS NOT NULL DROP TABLE #FiltersExpanded;
IF OBJECT_ID('tempdb..#Filters') IS NOT NULL DROP TABLE #Filters;
IF OBJECT_ID('tempdb..#FilterHierarchy') IS NOT NULL DROP TABLE #FilterHierarchy;
IF OBJECT_ID('tempdb..#ValidFilters') IS NOT NULL DROP TABLE #ValidFilters;
IF OBJECT_ID('tempdb..#FilterValues') IS NOT NULL DROP TABLE #FilterValues;

DECLARE @dashboardId INT = 6435,
        @tenantid INT = 13152,
        @GroupDashboardID VARCHAR(10) = 'Ind',
        @Statusid INT = 1;

-- Step 1: Create base tables
CREATE TABLE #Filters (
    RowOrder INT IDENTITY(1,1) PRIMARY KEY,
    StudentsSubgroupId INT,
    Filter NVARCHAR(200),
    FilterByField NVARCHAR(200),
    ComparisonValue NVARCHAR(MAX),
    DependentField NVARCHAR(MAX)
);

CREATE TABLE #FilterValues (
    RowOrder INT,
    StudentsSubgroupId INT,
    Filter NVARCHAR(200),
    FilterByField NVARCHAR(200),
    ComparisonValue NVARCHAR(200),
    DependentField NVARCHAR(200),
    FilterLevel INT,
    ParentFilterField NVARCHAR(200)
);

CREATE TABLE #ValidFilters (
    RowOrder INT,
    StudentsSubgroupId INT,
    Filter NVARCHAR(200),
    FilterByField NVARCHAR(200),
    ComparisonValue NVARCHAR(200),
    DependentField NVARCHAR(200),
    IsValid BIT DEFAULT 1,
    ValidationQuery NVARCHAR(MAX)
);

-- Step 2: Load initial filters
INSERT INTO #Filters (StudentsSubgroupId, Filter, FilterByField, ComparisonValue, DependentField)
SELECT 
    ds.StudentsSubgroupId,
    ss.SubgroupName,
    ss.ColumnName,
    ds.DefaultValue,
    ds.DependentField
FROM DashboardSubGroups ds
JOIN idm.StudentsSubgroup ss 
     ON ss.StudentsSubgroupId = ds.StudentsSubgroupId
    AND ss.TenantId = ds.TenantId
WHERE ds.DashboardId = @dashboardId
  AND ds.TenantId = @tenantid
  AND ss.StatusId = @Statusid
ORDER BY ds.StudentsSubgroupId;

-- Step 3: Expand comma-separated values and create hierarchy
WITH FilterHierarchy AS (
    SELECT 
        f.RowOrder,
        f.StudentsSubgroupId,
        f.Filter,
        f.FilterByField,
        LTRIM(RTRIM(s.value)) AS ComparisonValue,
        LTRIM(RTRIM(d.value)) AS DependentField,
        ROW_NUMBER() OVER (PARTITION BY f.RowOrder ORDER BY (SELECT NULL)) as FilterLevel,
        LAG(f.FilterByField) OVER (ORDER BY f.RowOrder) as ParentFilterField
    FROM #Filters f
    CROSS APPLY STRING_SPLIT(ISNULL(f.ComparisonValue, ''), ',') s
    CROSS APPLY STRING_SPLIT(ISNULL(f.DependentField, ''), ',') d
    WHERE LTRIM(RTRIM(s.value)) IS NOT NULL AND LTRIM(RTRIM(s.value)) != ''
      --AND s.ordinal = d.ordinal -- CRITICAL: Ensure values align between both splits
)
INSERT INTO #FilterValues (RowOrder, StudentsSubgroupId, Filter, FilterByField, ComparisonValue, DependentField, FilterLevel, ParentFilterField)
SELECT RowOrder, StudentsSubgroupId, Filter, FilterByField, ComparisonValue, DependentField, FilterLevel, ParentFilterField
FROM FilterHierarchy;

-- Step 4: Add filters without comparison values (these are always valid)
INSERT INTO #ValidFilters (RowOrder, StudentsSubgroupId, Filter, FilterByField, ComparisonValue, DependentField, IsValid)
SELECT 
    f.RowOrder,
    f.StudentsSubgroupId,
    f.Filter,
    f.FilterByField,
    NULL as ComparisonValue,
    f.DependentField,
    1 as IsValid
FROM #Filters f
WHERE f.ComparisonValue IS NULL OR f.ComparisonValue = '';

-- Step 5: Dynamic validation for filters with comparison values
DECLARE @CurrentLevel INT = 1,
        @MaxLevel INT,
        @SQL NVARCHAR(MAX),
        @CurrentFilter NVARCHAR(200),
        @CurrentField NVARCHAR(200),
        @CurrentValue NVARCHAR(200),
        @CurrentRowOrder INT,
        @CurrentStudentsSubgroupId INT,
        @CurrentDependentField NVARCHAR(200),
        @PreviousConditions NVARCHAR(MAX) = '',
        @ValidationQuery NVARCHAR(MAX),
        @RecordExists BIT;

SELECT @MaxLevel = MAX(FilterLevel) FROM #FilterValues;

-- Process each filter level
WHILE @CurrentLevel <= @MaxLevel
BEGIN
    DECLARE filter_cursor CURSOR LOCAL FORWARD_ONLY FOR
    SELECT FilterByField, ComparisonValue, RowOrder, StudentsSubgroupId, Filter, DependentField
    FROM #FilterValues 
    WHERE FilterLevel = @CurrentLevel;
    
    OPEN filter_cursor;
    FETCH NEXT FROM filter_cursor INTO @CurrentField, @CurrentValue, @CurrentRowOrder, @CurrentStudentsSubgroupId, @CurrentFilter, @CurrentDependentField;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Build validation query
        SET @ValidationQuery = 'SELECT @RecordCount = COUNT(*) FROM aggrptk12studentdetails WHERE 1=1';
        
        -- Add previous level conditions
        IF @PreviousConditions != ''
            SET @ValidationQuery = @ValidationQuery + ' AND ' + @PreviousConditions;
            
        -- Add current filter condition
        SET @ValidationQuery = @ValidationQuery + ' AND ' + QUOTENAME(@CurrentField) + ' = ''' + REPLACE(@CurrentValue, '''', '''''') + '''';
        
        -- Execute validation
        BEGIN TRY
            DECLARE @RecordCount INT;
            
            SET @SQL = 'DECLARE @RecordCount INT; ' + @ValidationQuery + '; SELECT @RecordCount;';
            
            CREATE TABLE #TempResult (RecordCount INT);
            INSERT INTO #TempResult EXEC sp_executesql @SQL;
            SELECT @RecordCount = RecordCount FROM #TempResult;
            DROP TABLE #TempResult;
            
            SET @RecordExists = CASE WHEN @RecordCount > 0 THEN 1 ELSE 0 END;
        END TRY
        BEGIN CATCH
            SET @RecordExists = 0; -- If query fails, mark as invalid
        END CATCH
        
        -- Insert validation result
        INSERT INTO #ValidFilters (RowOrder, StudentsSubgroupId, Filter, FilterByField, ComparisonValue, DependentField, IsValid, ValidationQuery)
        VALUES (@CurrentRowOrder, @CurrentStudentsSubgroupId, @CurrentFilter, @CurrentField, @CurrentValue, @CurrentDependentField, @RecordExists, @ValidationQuery);
        
        FETCH NEXT FROM filter_cursor INTO @CurrentField, @CurrentValue, @CurrentRowOrder, @CurrentStudentsSubgroupId, @CurrentFilter, @CurrentDependentField;
    END
    
    CLOSE filter_cursor;
    DEALLOCATE filter_cursor;
    
    -- Build conditions for next level
    SELECT @PreviousConditions = COALESCE(
        STRING_AGG(
            QUOTENAME(FilterByField) + ' = ''' + REPLACE(ComparisonValue, '''', '''''') + '''', 
            ' AND '
        ) WITHIN GROUP (ORDER BY FilterLevel),
        ''
    )
    FROM #FilterValues 
    WHERE FilterLevel <= @CurrentLevel;
    
    SET @CurrentLevel = @CurrentLevel + 1;
END

-- Step 6: Create final expanded filters table with only valid filters
CREATE TABLE #FiltersExpanded (
    RowOrder INT,
    StudentsSubgroupId INT,
    Filter NVARCHAR(200),
    FilterByField NVARCHAR(200),
    ComparisonValue NVARCHAR(200),
    DependentField NVARCHAR(200),
    Condition NVARCHAR(MAX),
    IsValid BIT,
    ValidationQuery NVARCHAR(MAX)
);

-- Insert valid filters with conditions
INSERT INTO #FiltersExpanded (RowOrder, StudentsSubgroupId, Filter, FilterByField, ComparisonValue, DependentField, Condition, IsValid, ValidationQuery)
SELECT 
    vf.RowOrder,
    vf.StudentsSubgroupId,
    vf.Filter,
    vf.FilterByField,
    vf.ComparisonValue,
    vf.DependentField,
    CASE 
        WHEN vf.ComparisonValue IS NULL OR vf.ComparisonValue = '' 
        THEN NULL
        ELSE QUOTENAME(vf.FilterByField) + ' = ''' + REPLACE(vf.ComparisonValue, '''', '''''') + ''''
    END as Condition,
    vf.IsValid,
    vf.ValidationQuery
FROM #ValidFilters vf
WHERE vf.IsValid = 1
ORDER BY vf.RowOrder;

-- Step 7: Final result - only valid filters
SELECT 
    RowOrder,
    StudentsSubgroupId,
    Filter,
    FilterByField,
    ComparisonValue,
    DependentField,
    Condition,
    'Validated and has data' as ValidationStatus
FROM #FiltersExpanded
WHERE IsValid = 1
ORDER BY RowOrder, StudentsSubgroupId;

-- Optional: Show validation details for debugging
SELECT 
    'Validation Summary' as ReportType,
    Filter,
    FilterByField,
    ComparisonValue,
    CASE WHEN IsValid = 1 THEN 'Valid - Has Data' ELSE 'Invalid - No Data' END as Status,
    ValidationQuery
FROM #ValidFilters
ORDER BY RowOrder;

---- Cleanup
--DROP TABLE #Filters;
--DROP TABLE #FilterValues;  
--DROP TABLE #ValidFilters;
--DROP TABLE #FiltersExpanded;