CREATE OR ALTER PROCEDURE USP_Delete_All_Tenantid_Data
	@tenantid INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @tableschema NVARCHAR(255)
	DECLARE @tableName NVARCHAR(255)
	DECLARE @sql NVARCHAR(MAX)
	DECLARE @totalRowsDeleted INT = 0

	-- Disable constraints on all tables
	EXEC sp_msforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'

	-- Cursor to iterate all base tables
	DECLARE tableCursor CURSOR
	FOR
	SELECT TABLE_SCHEMA, TABLE_NAME
	FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_TYPE = 'BASE TABLE'

	OPEN tableCursor

	FETCH NEXT
	FROM tableCursor
	INTO @tableschema, @tableName

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF EXISTS (
				SELECT 1
				FROM INFORMATION_SCHEMA.COLUMNS
				WHERE TABLE_SCHEMA = @tableschema
					AND TABLE_NAME = @tableName
					AND COLUMN_NAME = 'tenantid'
				)
		BEGIN
			SET @sql = 'DELETE FROM ' + QUOTENAME(@tableschema) + '.' + QUOTENAME(@tableName) + ' WHERE tenantid = ''' + CAST(@tenantid AS VARCHAR(100)) + ''''

			EXEC sp_executesql @sql

			SET @totalRowsDeleted = @totalRowsDeleted + @@ROWCOUNT
		END

		FETCH NEXT
		FROM tableCursor
		INTO @tableschema, @tableName
	END

	CLOSE tableCursor

	DEALLOCATE tableCursor

	-- Re-enable constraints
	EXEC sp_msforeachtable 'ALTER TABLE ? CHECK CONSTRAINT ALL'

	-- Output total rows deleted
	SELECT @totalRowsDeleted AS TotalRowsDeleted
END
GO


