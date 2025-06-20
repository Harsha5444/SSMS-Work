DECLARE pr CURSOR FOR 
SELECT DISTINCT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_SCHEMA = 'stage' 
AND TABLE_NAME LIKE '%_audit'

EXCEPT 

SELECT DISTINCT TABLE_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_SCHEMA = 'stage' 
AND TABLE_NAME LIKE '%_audit' 
AND COLUMN_NAME IN ('CreatedBy', 'CreatedDate');

DECLARE @tablename VARCHAR(MAX), @sql NVARCHAR(MAX);

OPEN pr;
FETCH NEXT FROM pr INTO @tablename;

WHILE (@@FETCH_STATUS = 0)
BEGIN

    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'stage' AND TABLE_NAME = @tablename AND COLUMN_NAME = 'CreatedBy')
    BEGIN
        SET @sql = N'ALTER TABLE [stage].[' + @tablename + '] ADD CreatedBy VARCHAR(150) NULL;';
        EXEC sp_executesql @sql;
    END


    IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'stage' AND TABLE_NAME = @tablename AND COLUMN_NAME = 'CreatedDate')
    BEGIN
        SET @sql = N'ALTER TABLE [stage].[' + @tablename + '] ADD CreatedDate DATETIME NULL;';
        EXEC sp_executesql @sql;
    END

    FETCH NEXT FROM pr INTO @tablename;
END

CLOSE pr;
DEALLOCATE pr;