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
-- Optional: Uncomment to execute all generated scripts automatically
/*
DECLARE @ExecSQL NVARCHAR(MAX);
DECLARE ExecCursor CURSOR FOR SELECT UpdateScript FROM #UpdateScripts;
OPEN ExecCursor;
FETCH NEXT FROM ExecCursor INTO @ExecSQL;
WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT 'Executing: ' + @ExecSQL;
    EXEC sp_executesql @ExecSQL;
    FETCH NEXT FROM ExecCursor INTO @ExecSQL;
END
CLOSE ExecCursor;
DEALLOCATE ExecCursor;
*/

-- Clean up (comment this out if you want to keep the temp table)
 ---=========================================================================================
 
--DECLARE @MinYear VARCHAR(10) = '2024';
--DECLARE @MaxYear VARCHAR(10) = NULL;
--DECLARE @Term VARCHAR(10) = 'Fall';
--DECLARE @SurveyType VARCHAR(50) = 'Student Supports';
--DECLARE @QuestionDescriptions VARCHAR(MAX) = 'How often do you stay focused on the same goal for several months at a time?/If you fail to reach an important goal, how likely are you to try again?/When you are working on a project that matters a lot to you, how focused can you stay when there are lots of distractions?/If you have a problem while working towards an important goal, how well can you keep working?/Some people pursue some of their goals for a long time, and others change their goals frequently. Over the next several years, how likely are you to continue to pursue one of your current goals?/How often do you feel excited?/How often do you feel happy?/How often do you feel loved?/How often do you feel safe?/How often do you feel hopeful?/How often do you feel angry?/How often do you feel lonely?/How often do you feel sad?/How often do you feel worried?/How often do you feel frustrated?/How often do you feel mad?/Thinking about everything in your life right now, what makes you feel the happiest?/Thinking about everything in your life right now, what feels the hardest for you?/Do you have a teacher or other adult from school who you can count on to help you, no matter what?/Do you have a family member or other adult outside of school who you can count on to help you, no matter what?/Do you have a friend from school who you can count on to help you, no matter what?/Do you have a teacher or other adult from school who you can be completely yourself around?/Do you have a family member or other adult outside of school who you can be completely yourself around?/Do you have a friend from school who you can be completely yourself around?/What can teachers or other adults at school do to better support you?/How often do you stay focused on the same goal for more than 3 months at a time?/If you fail at an important goal, how likely are you to try again?/What can teachers or other adults at school do to better help you?';
--DECLARE @StartQuestionCode INT = 1;

--CREATE TABLE #SelectStatements (
--    RowID INT IDENTITY(1,1),
--    SelectStatement VARCHAR(MAX)
--);

--DECLARE @Pos INT = 1;
--DECLARE @NextPos INT;
--DECLARE @Question VARCHAR(MAX);

--WHILE @Pos <= LEN(@QuestionDescriptions)
--BEGIN
--    SET @NextPos = CHARINDEX('/', @QuestionDescriptions + '/', @Pos);
--    SET @Question = SUBSTRING(@QuestionDescriptions, @Pos, @NextPos - @Pos);
    
--    INSERT INTO #SelectStatements (SelectStatement)
--    VALUES (
--        'UNION ALL SELECT ''' + @MinYear + ''' as MinYear, ' + 
--        CASE WHEN @MaxYear IS NULL THEN 'NULL' ELSE '''' + @MaxYear + '''' END + ' as MaxYear, '+ ''''+@Term +''' as Term, ' +
--        '''' + @SurveyType + ''' as SurveyType, ' +
--        '''Q' + CAST(@StartQuestionCode + (SELECT COUNT(*) FROM #SelectStatements) AS VARCHAR(10)) + ''' as QuestionCode, ' +
--        '''' + REPLACE(@Question, '''', '''''') + ''' as QuestionText, ' +
--        CAST(@StartQuestionCode + (SELECT COUNT(*) FROM #SelectStatements) AS VARCHAR(10)) + ' as SortOrder'
--    );
    
--    SET @Pos = @NextPos + 1;
--END

--SELECT SelectStatement FROM #SelectStatements ORDER BY RowID;

--DROP TABLE #SelectStatements;

