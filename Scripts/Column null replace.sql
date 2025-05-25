select  * from [SEL Raw Data Exports for 6th-12th grades] 
--drop table [SEL Raw Data Exports for 6th-12th grades]
where Student_ID in ('201917','200964')

--Thinking_about_everything_in_your_life_right_now_what_feels_the_hardest_for_you_TEXT
SELECT 
    REPLACE(REPLACE(Thinking_about_everything_in_your_life_right_now_what_feels_the_hardest_for_you_TEXT, CHAR(10), ' '), CHAR(13), ' ') AS column_name
FROM [dbo].[henryk12+ Fall 2023 SEL Raw Data Exports for 3rd-5th Grades]
where Student_ID in ('201917','200964')


--DECLARE @columnName NVARCHAR(128)
--DECLARE @tableName NVARCHAR(256) = '[dbo].[henryk12+ Fall 2023 SEL Raw Data Exports for 3rd-5th Grades]'
--DECLARE @sql NVARCHAR(MAX)
--DECLARE @processedColumns INT = 0

--DECLARE column_cursor CURSOR FOR
--SELECT column_name
--FROM information_schema.columns
--WHERE table_name = 'henryk12+ Fall 2023 SEL Raw Data Exports for 3rd-5th Grades'
--AND table_schema = 'dbo'
--AND data_type IN ('varchar', 'nvarchar', 'char', 'nchar', 'text', 'ntext')

--OPEN column_cursor
--FETCH NEXT FROM column_cursor INTO @columnName

--WHILE @@FETCH_STATUS = 0
--BEGIN
--    SET @sql = 
--    'UPDATE ' + @tableName + '
--    SET [' + @columnName + '] = 
--        CASE 
--            WHEN ltrim(rtrim([' + @columnName + '])) = '''' THEN NULL
--            ELSE ltrim(rtrim(replace(replace(replace(
--                [' + @columnName + '], 
--                '' '', ''~|~''), 
--                ''~|~ '', ''~|~''), 
--                ''~|~'', '' '')))
--        END
--    WHERE 
--        [' + @columnName + '] LIKE ''%  %'' OR
--        ltrim(rtrim([' + @columnName + '])) = '''' OR
--        LEFT([' + @columnName + '], 1) = '' '' OR
--        RIGHT([' + @columnName + '], 1) = '' '''
    
--    BEGIN TRY
--        EXEC sp_executesql @sql
--        SET @processedColumns = @processedColumns + 1
--    END TRY
--    BEGIN CATCH
--        -- Optional: Log error if needed
--        PRINT 'Error processing column [' + @columnName + ']: ' + ERROR_MESSAGE()
--    END CATCH
    
--    FETCH NEXT FROM column_cursor INTO @columnName
--END

--CLOSE column_cursor
--DEALLOCATE column_cursor

--PRINT 'Processing complete. ' + CAST(@processedColumns AS VARCHAR(10)) + ' columns were updated.'
