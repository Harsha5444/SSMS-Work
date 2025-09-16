IF OBJECT_ID('tempdb..#TempSSVF_TBL') IS NOT NULL
    DROP TABLE #TempSSVF_TBL;

CREATE TABLE #TempSSVF_TBL
(
    id INT PRIMARY KEY IDENTITY(1,1),
    ViewName VARCHAR(128),
    TableName VARCHAR(128)
);


INSERT INTO #TempSSVF_TBL (ViewName, TableName)
SELECT 
    FieldDataSource as ViewName,
    FieldDataSource + '_SSTbl' as TableName  
FROM StaffSummaryViewFields
WHERE FieldDataSource NOT LIKE '%_SSTbl';


DELETE FROM #TempSSVF_TBL
WHERE NOT EXISTS (SELECT 1 FROM sys.views WHERE name = ViewName)
   OR EXISTS (SELECT 1 FROM sys.tables WHERE name = TableName);


IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'RosterViewTableMapping')
BEGIN
    CREATE TABLE [dbo].[RosterViewTableMapping] (
        RosterViewTableMappingId INT IDENTITY(1,1) PRIMARY KEY,
        DynamicViewName VARCHAR(128) NOT NULL,
        DynamicTableName VARCHAR(128) NOT NULL,
        ObjectsUsed NVARCHAR(MAX) NULL,  
        StausId INT NOT NULL DEFAULT 1,
        TenantId INT NOT NULL,
        CreatedBy VARCHAR(50) NULL,
        CreatedDate DATETIME DEFAULT(GETDATE()),
        ModifiedBy VARCHAR(50) NULL,
        ModifiedDate DATETIME DEFAULT(GETDATE())
    );
END;


DECLARE @count INT, @maxid INT;
DECLARE @sql NVARCHAR(MAX);
DECLARE @viewname VARCHAR(128);
DECLARE @tablename VARCHAR(128);
DECLARE @Objects NVARCHAR(MAX);

SET @count = 1;
SET @maxid = (SELECT MAX(id) FROM #TempSSVF_TBL);

WHILE @count <= @maxid
BEGIN
    SELECT @viewname = ViewName, @tablename = TableName 
    FROM #TempSSVF_TBL 
    WHERE id = @count;
    
    IF @viewname IS NOT NULL
    BEGIN

        IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = @tablename)
        BEGIN

            SET @sql = 'SELECT * INTO ' + QUOTENAME(@tablename) + ' FROM ' + QUOTENAME(@viewname);
            EXEC sp_executesql @sql;

            SET @Objects = NULL;
            SELECT @Objects = STRING_AGG(QUOTENAME(s.name) + '.' + QUOTENAME(o.name), ', ')
            FROM sys.sql_expression_dependencies d
            INNER JOIN sys.objects o ON d.referenced_id = o.object_id
            INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
            WHERE d.referencing_id = OBJECT_ID(@viewname)
              AND o.type IN ('U', 'V');

            INSERT INTO [RosterViewTableMapping] (DynamicViewName, DynamicTableName, ObjectsUsed, StausId, TenantId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)
            SELECT @viewname, @tablename, ISNULL(@Objects, 'No dependencies found'), 1, 4, 'DDAUser@DDA', GETDATE(), NULL, NULL
            WHERE NOT EXISTS (SELECT 1 FROM RosterViewTableMapping r WHERE r.DynamicTableName = @tablename);

            UPDATE ssvf
            SET ssvf.FieldDataSource = @tablename
            FROM StaffSummaryViewFields ssvf
            WHERE ssvf.FieldDataSource = @viewname;
        END
    END
    
    SET @count = @count + 1;
END;

DROP TABLE #TempSSVF_TBL;