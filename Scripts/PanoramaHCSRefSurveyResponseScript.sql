DECLARE @TableName NVARCHAR(128) = '[henryk12+ Fall 2024 TPOS Survey Raw Data Exports]';
DECLARE @StartColumn INT = 22;
DECLARE @EndColumn INT = 39;

-- Optional reference columns
DECLARE @termcolumn INT = 40;
DECLARE @survery_year_column INT = 41;
DECLARE @survery_category_column INT = 42;

-- Create a temp table to hold the generated SQL statements
IF OBJECT_ID('tempdb..#sqlstatements') IS NOT NULL DROP TABLE #sqlstatements;

CREATE TABLE #sqlstatements (
    id INT IDENTITY(1,1),
    query NVARCHAR(MAX)
);

DECLARE @i INT = @StartColumn;
DECLARE @sql NVARCHAR(MAX);

WHILE @i <= @EndColumn - 2  -- Ensure i+2 does not exceed column range
BEGIN
    SET @sql = 
        'SELECT DISTINCT ' +
        'column' + CAST(@termcolumn AS NVARCHAR) + ' AS Term, ' +
        'column' + CAST(@survery_year_column AS NVARCHAR) + ' AS Survey_Year, ' +
        'column' + CAST(@survery_category_column AS NVARCHAR) + ' AS Survey_Category, ' +
        'column' + CAST(@i AS NVARCHAR) + ' AS QuestionValue, ' +
        'column' + CAST(@i + 1 AS NVARCHAR) + ' AS QuestionText, ' +
        'column' + CAST(@i + 2 AS NVARCHAR) + ' AS QuestionSortOrder ' +
        'FROM ' + @TableName + ' ' +
        'WHERE column' + CAST(@i AS NVARCHAR) + ' IS NOT NULL';

    INSERT INTO #sqlstatements(query) VALUES (@sql);

    SET @i += 3; -- Move to next group
END

-- View generated SQL statements
SELECT * FROM #sqlstatements;
