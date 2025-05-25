SELECT * FROM [henryk12+ Spring 2025 Teacher Raw Data Exports]
SELECT * FROM RefSurveyQuestions

----======================================================================================================================================
--Add Term, Survey Year, Survey Category column and add DATA
----======================================================================================================================================

--alter table [henryk12+ Spring 2025 Teacher Raw Data Exports] add [Column76] varchar(50),[Column77] Varchar(50),[Column78] varchar(50)
--update [henryk12+ Spring 2025 Teacher Raw Data Exports] set [Column76] = 'Spring',[Column77] = '2025',         [Column78] = 'Staff Supports'
--update [henryk12+ Spring 2025 Teacher Raw Data Exports] set [Column76] = 'Term',  [Column77]= 'Survery_Year',  [Column78] = 'Survery_Category'
--WHERE Column1 = 'Client Name'

----======================================================================================================================================
--Remove TEXT from headers
----======================================================================================================================================
IF OBJECT_ID('tempdb..#UpdateStatements') IS NOT NULL
    DROP TABLE #UpdateStatements;
CREATE TABLE #UpdateStatements (
    Id INT IDENTITY(1,1),
    SqlText NVARCHAR(MAX)
);
DECLARE @col INT = 11;              
DECLARE @endCol INT = 74;           
DECLARE @step INT = 3;              
DECLARE @sql NVARCHAR(MAX) = '';
DECLARE @colList NVARCHAR(MAX) = '';
WHILE @col <= @endCol
BEGIN
    SET @colList = @colList + '    Column' + CAST(@col AS VARCHAR) + ' = REPLACE(Column' + CAST(@col AS VARCHAR) + ', ''TEXT'', ''''),' + CHAR(13);
    SET @col = @col + @step;
END
SET @colList = LEFT(@colList, LEN(@colList) - 2);
SET @sql = 'UPDATE [henryk12+ Spring 2025 Teacher Raw Data Exports]
SET ' + CHAR(13) + @colList + '
WHERE Column1 = ''Client Name'';';
INSERT INTO #UpdateStatements(SqlText)
VALUES (@sql);
SELECT * FROM #UpdateStatements;

----======================================================================================================================================
--Append excited,happy...with - 'How often do you feel'
----======================================================================================================================================
IF OBJECT_ID('tempdb..#UpdateStatements') IS NOT NULL
    DROP TABLE #UpdateStatements;
CREATE TABLE #UpdateStatements (
    Id INT IDENTITY(1,1),
    SqlText NVARCHAR(MAX)
);
DECLARE @col INT = 11;              
DECLARE @endCol INT = 74;           
DECLARE @step INT = 3;              
DECLARE @setClause NVARCHAR(MAX) = '';
DECLARE @sql NVARCHAR(MAX);
WHILE @col <= @endCol
BEGIN
    SET @setClause += '    Column' + CAST(@col AS VARCHAR) + ' = CASE WHEN TRIM(Column' + CAST(@col AS VARCHAR) + ') IN ' + 
                      '(''excited'', ''happy'', ''loved'', ''safe'', ''mad'', ''lonely'', ''sad'', ''worried'', ' + 
                      '''hopeful'', ''angry'', ''engaged'', ''exhausted'', ''frustrated'', ''overwhelmed'', ''stressed out'') ' +
                      'THEN CONCAT(''How often do you feel '', TRIM(Column' + CAST(@col AS VARCHAR) + '), ''?'') ELSE Column' + CAST(@col AS VARCHAR) + ' END,' + CHAR(13);
    SET @col = @col + @step;
END
SET @setClause = LEFT(@setClause, LEN(@setClause) - 2);
SET @sql = 'UPDATE [henryk12+ Spring 2025 Teacher Raw Data Exports]' + CHAR(13) +
           'SET' + CHAR(13) + @setClause + CHAR(13) +
           'WHERE Column1 = ''Client Name'';';
INSERT INTO #UpdateStatements(SqlText)
VALUES (@sql);
SELECT * FROM #UpdateStatements;

----======================================================================================================================================
--Join with RefSurveyQuestions to Replace Questions with Q1, Q2 ...
----======================================================================================================================================
IF OBJECT_ID('tempdb..#UpdateStatements') IS NOT NULL
DROP TABLE #UpdateStatements;
CREATE TABLE #UpdateStatements (
    Id INT IDENTITY(1,1),
    SqlText NVARCHAR(MAX)
);
DECLARE @col INT = 11;
DECLARE @sql NVARCHAR(MAX);
WHILE @col <= 74
BEGIN
    SET @sql = '
    UPDATE a
    SET Column' + CAST(@col AS VARCHAR) + ' = b.QuestionCode
    FROM [henryk12+ Spring 2025 Teacher Raw Data Exports] a
    JOIN RefSurveyQuestions b ON a.Column' + CAST(@col AS VARCHAR) + ' LIKE ''%'' + b.QuestionText + ''%''
    WHERE b.Term = ''Spring''
      AND b.SurveyType = ''Staff Supports''
      AND a.Column1 = ''Client Name'';';
    INSERT INTO #UpdateStatements(SqlText)
    VALUES (@sql);
    SET @col = @col+3;
END;
SELECT * FROM #UpdateStatements;

----======================================================================================================================================
--Replace , with ' ' space and '  'double space with single space for header row
----======================================================================================================================================
IF OBJECT_ID('tempdb..#UpdateStatements') IS NOT NULL
    DROP TABLE #UpdateStatements;
CREATE TABLE #UpdateStatements (
    Id INT IDENTITY(1,1),
    SqlText NVARCHAR(MAX)
);
DECLARE @col INT = 1;             
DECLARE @endCol INT = 78;         
DECLARE @sql NVARCHAR(MAX);
WHILE @col <= @endCol
BEGIN
     SET @sql = 'UPDATE [henryk12+ Spring 2025 Teacher Raw Data Exports]
SET Column' + CAST(@col AS VARCHAR) + ' = REPLACE(REPLACE(Column' + CAST(@col AS VARCHAR) + ', '','', '' ''), ''  '', '' '')
WHERE Column1 = ''Client Name''';    
    INSERT INTO #UpdateStatements(SqlText)
    VALUES (@sql);    
    SET @col = @col + 1;
END
SELECT * FROM #UpdateStatements;

----======================================================================================================================================
--Replace ' ' space with _ underscore and ( and ) with '' empty space
----======================================================================================================================================
IF OBJECT_ID('tempdb..#UpdateStatements') IS NOT NULL
    DROP TABLE #UpdateStatements;
CREATE TABLE #UpdateStatements (
    Id INT IDENTITY(1,1),
    SqlText NVARCHAR(MAX)
);
DECLARE @col INT = 1;
DECLARE @endCol INT = 78;
DECLARE @sql NVARCHAR(MAX);
WHILE @col <= @endCol
BEGIN
    SET @sql = 'UPDATE [henryk12+ Spring 2025 Teacher Raw Data Exports]
SET Column' + CAST(@col AS VARCHAR) + ' = REPLACE(REPLACE(REPLACE(Column' + CAST(@col AS VARCHAR) + ', ''('', ''''), '')'', ''''), '' '', ''_'')
WHERE Column1 = ''Client Name''';
    INSERT INTO #UpdateStatements(SqlText)
    VALUES (@sql);
    SET @col = @col + 1;
END
SELECT * FROM #UpdateStatements;

----======================================================================================================================================
--Remove CHAR(10), CHAR(13), CHAR(34) from all columns
----======================================================================================================================================
CREATE TABLE #UpdateScripts (
    TableName NVARCHAR(255),
    ColumnName NVARCHAR(255),
    UpdateScript NVARCHAR(MAX)
);
DECLARE @TableName NVARCHAR(255) = '[henryk12+ Spring 2025 Teacher Raw Data Exports]';
DECLARE @ColumnName NVARCHAR(255);
DECLARE @SQL NVARCHAR(MAX);
DECLARE ColumnCursor CURSOR FOR
SELECT 
    c.name AS ColumnName
FROM 
    sys.tables t
INNER JOIN 
    sys.columns c ON t.object_id = c.object_id
INNER JOIN 
    sys.types ty ON c.user_type_id = ty.user_type_id
WHERE 
    ty.name IN ('varchar', 'nvarchar', 'char', 'nchar', 'text', 'ntext')
    AND t.is_ms_shipped = 0
    AND t.name = REPLACE(REPLACE(@TableName, '[', ''), ']', '');
OPEN ColumnCursor;
FETCH NEXT FROM ColumnCursor INTO @ColumnName;
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @SQL = 'UPDATE ' + @TableName + ' SET [' + @ColumnName + '] = REPLACE(REPLACE(REPLACE([' + @ColumnName + '], CHAR(10), '' ''), CHAR(13), '' ''), CHAR(34), '' '') ' +
               'WHERE [' + @ColumnName + '] LIKE ''%'' + CHAR(10) + ''%'' OR [' + @ColumnName + '] LIKE ''%'' + CHAR(13) + ''%'' OR [' + @ColumnName + '] LIKE ''%'' + CHAR(34) + ''%'';';
    INSERT INTO #UpdateScripts (TableName, ColumnName, UpdateScript)
    VALUES (@TableName, @ColumnName, @SQL);    
    FETCH NEXT FROM ColumnCursor INTO @ColumnName;
END
CLOSE ColumnCursor;
DEALLOCATE ColumnCursor;
SELECT * FROM #UpdateScripts;
DROP TABLE #UpdateScripts;
