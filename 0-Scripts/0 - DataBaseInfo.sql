--1. Tables with Row Counts and Sizes
SELECT t.NAME AS TableName
	,s.Name AS SchemaName
	,p.rows AS RowCounts
	,SUM(a.total_pages) * 8 AS TotalSpaceKB
	,SUM(a.used_pages) * 8 AS UsedSpaceKB
	,(SUM(a.total_pages) - SUM(a.used_pages)) * 8 AS UnusedSpaceKB
FROM sys.tables t
INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN sys.partitions p ON i.object_id = p.OBJECT_ID
	AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
GROUP BY t.Name
	,s.Name
	,p.Rows
ORDER BY TotalSpaceKB DESC;

--2. Schema Organization and Relationships (Foreign Keys)
SELECT fk.name AS FK_Name
	,OBJECT_NAME(fk.parent_object_id) AS Parent_Table
	,COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS Parent_Column
	,OBJECT_NAME(fk.referenced_object_id) AS Referenced_Table
	,COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS Referenced_Column
	,fk.delete_referential_action_desc AS Delete_Action
	,fk.update_referential_action_desc AS Update_Action
FROM sys.foreign_keys fk
INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
ORDER BY Parent_Table
	,Referenced_Table;

--3. View Definitions (including referenced tables)
SELECT v.name AS ViewName
	,s.name AS SchemaName
	,OBJECT_DEFINITION(v.object_id) AS ViewDefinition
	,STRING_AGG(OBJECT_NAME(sed.referenced_id), ', ') AS ReferencedTables
FROM sys.VIEWS v
JOIN sys.schemas s ON v.schema_id = s.schema_id
OUTER APPLY (
	SELECT DISTINCT referenced_id
	FROM sys.sql_expression_dependencies
	WHERE referencing_id = v.object_id
		AND referenced_id IS NOT NULL
		AND referenced_class = 1
	) sed -- Class = 1 for Tables
GROUP BY v.name
	,s.name
	,OBJECT_DEFINITION(v.object_id)
ORDER BY s.name
	,v.name;

--4. Column Information (Data Types and Constraints)
SELECT t.name AS TableName
	,s.name AS SchemaName
	,c.name AS ColumnName
	,ty.name AS DataType
	,c.max_length
	,c.precision
	,c.scale
	,c.is_nullable
	,c.is_identity
	,OBJECT_NAME(dc.object_id) AS DefaultConstraintName
	,dc.DEFINITION AS DefaultValue
	,pk.name AS PK_ConstraintName
	,uk.name AS UK_ConstraintName
	,cc.name AS CheckConstraintName
	,cc.DEFINITION AS CheckDefinition
	,c.is_computed
	,c.is_replicated
	,c.is_sparse
FROM sys.columns c
JOIN sys.tables t ON c.object_id = t.object_id
JOIN sys.schemas s ON t.schema_id = s.schema_id
JOIN sys.types ty ON c.user_type_id = ty.user_type_id
LEFT JOIN sys.default_constraints dc ON c.default_object_id = dc.object_id
LEFT JOIN sys.index_columns ic ON c.object_id = ic.object_id
	AND c.column_id = ic.column_id
LEFT JOIN sys.key_constraints pk ON ic.object_id = pk.parent_object_id
	AND pk.type = 'PK'
	AND ic.index_id = pk.unique_index_id
LEFT JOIN sys.key_constraints uk ON ic.object_id = uk.parent_object_id
	AND uk.type = 'UQ'
	AND ic.index_id = uk.unique_index_id
LEFT JOIN (
	SELECT cc.object_id
		,cc.parent_object_id
		,cc.parent_column_id
		,cc.name
		,cc.DEFINITION
	FROM sys.check_constraints cc
	) cc ON c.object_id = cc.parent_object_id
	AND c.column_id = cc.parent_column_id
ORDER BY s.name
	,t.name
	,c.column_id;

--5. Usage Patterns and Dependencies Between Objects
SELECT OBJECT_SCHEMA_NAME(sed.referencing_id) + '.' + OBJECT_NAME(sed.referencing_id) AS ReferencingObject
	,o1.type_desc AS ReferencingType
	,COALESCE(OBJECT_SCHEMA_NAME(sed.referenced_id) + '.' + OBJECT_NAME(sed.referenced_id), sed.referenced_entity_name) AS ReferencedObject
	,o2.type_desc AS ReferencedType
	,sed.is_caller_dependent
	,sed.is_ambiguous
FROM sys.sql_expression_dependencies sed
LEFT JOIN sys.objects o1 ON sed.referencing_id = o1.object_id
LEFT JOIN sys.objects o2 ON sed.referenced_id = o2.object_id
WHERE sed.referenced_id IS NOT NULL
	OR sed.referenced_entity_name IS NOT NULL
ORDER BY ReferencingObject
	,ReferencedObject;

--6. Table Ownership and Creation/Modification Timestamps
SELECT t.name AS TableName
	,s.name AS SchemaName
	,SCHEMA_NAME(t.schema_id) AS OWNER
	,t.create_date AS CreationDate
	,t.modify_date AS LastModified
	,u.name AS CreatedBy
FROM sys.tables t
JOIN sys.schemas s ON t.schema_id = s.schema_id
LEFT JOIN sys.sysusers u ON s.principal_id = u.uid
ORDER BY t.name;

--7. Indexes Information
SELECT t.name AS TableName
	,s.name AS SchemaName
	,i.name AS IndexName
	,i.type_desc AS IndexType
	,i.is_primary_key
	,i.is_unique
	,i.is_unique_constraint
	,i.fill_factor
	,i.is_disabled
	,STRING_AGG(c.name, ', ') WITHIN
GROUP (
		ORDER BY ic.key_ordinal
		) AS IndexColumns
FROM sys.indexes i
JOIN sys.tables t ON i.object_id = t.object_id
JOIN sys.schemas s ON t.schema_id = s.schema_id
JOIN sys.index_columns ic ON i.object_id = ic.object_id
	AND i.index_id = ic.index_id
JOIN sys.columns c ON ic.object_id = c.object_id
	AND ic.column_id = c.column_id
WHERE i.is_hypothetical = 0
GROUP BY t.name
	,s.name
	,i.name
	,i.type_desc
	,i.is_primary_key
	,i.is_unique
	,i.is_unique_constraint
	,i.fill_factor
	,i.is_disabled
ORDER BY s.name
	,t.name
	,i.name;

--8. Stored Procedures and Functions List
SELECT o.name AS ObjectName
	,s.name AS SchemaName
	,o.type_desc AS ObjectType
	,o.create_date AS CreationDate
	,o.modify_date AS LastModified
	,OBJECT_DEFINITION(o.object_id) AS DEFINITION
FROM sys.objects o
JOIN sys.schemas s ON o.schema_id = s.schema_id
WHERE o.type IN (
		'P'
		,'FN'
		,'IF'
		,'TF'
		,'AF'
		)
ORDER BY o.type
	,s.name
	,o.name;

--9. Database and Schema Size Overview
SELECT DB_NAME() AS DatabaseName
	,CONCAT (
		(
			SELECT SUM(size) * 8
			FROM sys.database_files
			WHERE type_desc = 'ROWS'
			)
		,' KB ('
		,CAST((
				SELECT SUM(size) * 8 / 1024.0
				FROM sys.database_files
				WHERE type_desc = 'ROWS'
				) AS DECIMAL(18, 2))
		,' MB, '
		,CAST((
				SELECT SUM(size) * 8 / (1024.0 * 1024.0)
				FROM sys.database_files
				WHERE type_desc = 'ROWS'
				) AS DECIMAL(18, 2))
		,' GB)'
		) AS DataSize
	,CONCAT (
		(
			SELECT SUM(size) * 8
			FROM sys.database_files
			WHERE type_desc = 'LOG'
			)
		,' KB ('
		,CAST((
				SELECT SUM(size) * 8 / 1024.0
				FROM sys.database_files
				WHERE type_desc = 'LOG'
				) AS DECIMAL(18, 2))
		,' MB, '
		,CAST((
				SELECT SUM(size) * 8 / (1024.0 * 1024.0)
				FROM sys.database_files
				WHERE type_desc = 'LOG'
				) AS DECIMAL(18, 2))
		,' GB)'
		) AS LogSize
	,(
		SELECT COUNT(*)
		FROM sys.schemas
		) AS SchemaCount
	,(
		SELECT COUNT(*)
		FROM sys.tables
		) AS TableCount
	,(
		SELECT COUNT(*)
		FROM sys.VIEWS
		) AS ViewCount
	,(
		SELECT COUNT(*)
		FROM sys.procedures
		) AS ProcedureCount
	,(
		SELECT COUNT(*)
		FROM sys.triggers
		) AS TriggerCount;

--10. Comprehensive Query Performance Tracking with Datetime Filtering

DECLARE @StartTime DATETIME = '2025-04-28 10:00:00'
	,-- Modify start time
	@EndTime DATETIME = '2025-04-28 18:00:00';-- Modify end time
	-- If you want to use relative time instead, uncomment these:
	-- DECLARE 
	--     @StartTime DATETIME = DATEADD(HOUR, -24, GETDATE()), -- Last 24 hours
	--     @EndTime DATETIME = GETDATE();

WITH QueryHistory
AS (
	SELECT CONVERT(DATETIME, GETDATE()) AS collection_time
		,ISNULL(DB_NAME(t.dbid), 'Unknown') AS database_name
		,
		--ISNULL(OBJECT_SCHEMA_NAME(t.objectid, t.dbid), 'Ad-hoc') AS schema_name,
		--ISNULL(OBJECT_NAME(t.objectid, t.dbid), 'Dynamic SQL') AS object_name,
		t.TEXT AS query_text
		,
		--qs.execution_count,
		qs.total_logical_reads
		,qs.total_physical_reads
		,qs.total_elapsed_time / 1000.0 AS total_elapsed_time_ms
		,qs.total_worker_time / 1000.0 AS total_worker_time_ms
		,qs.last_execution_time
		,
		-- Check if the query was executed within the specified time range
		CASE 
			WHEN qs.last_execution_time BETWEEN @StartTime
					AND @EndTime
				THEN 1
			ELSE 0
			END AS is_in_time_range
		,qs.max_elapsed_time / 1000.0 AS max_elapsed_time_ms
		,
		-- Additional context
		CASE 
			WHEN t.TEXT LIKE '%INSERT%'
				THEN 'Insert'
			WHEN t.TEXT LIKE '%UPDATE%'
				THEN 'Update'
			WHEN t.TEXT LIKE '%DELETE%'
				THEN 'Delete'
			WHEN t.TEXT LIKE '%SELECT%'
				THEN 'Select'
			ELSE 'Other'
			END AS query_type
		,
		-- Identify potential performance issues
		CASE 
			WHEN qs.total_elapsed_time / qs.execution_count > 1000000
				THEN 'High Average Latency'
			WHEN qs.total_logical_reads / qs.execution_count > 10000
				THEN 'High Logical Reads'
			ELSE 'Normal'
			END AS performance_flag
	FROM sys.dm_exec_query_stats qs
	CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) t
	CROSS APPLY sys.dm_exec_query_plan(qs.plan_handle) qp
	)
SELECT database_name
	,
	--schema_name,
	--object_name,
	query_type
	,performance_flag
	,
	--execution_count,
	last_execution_time
	,total_elapsed_time_ms
	,replace(SUBSTRING(query_text, 1, 2000), '=', '') AS truncated_query_text
	,
	-- Detailed time-based analytics
	DATEDIFF(SECOND, @StartTime, last_execution_time) AS seconds_after_start
	,DATEDIFF(SECOND, last_execution_time, @EndTime) AS seconds_before_end
FROM QueryHistory
WHERE is_in_time_range = 1
	AND database_name NOT IN (
		'master'
		,'model'
		,'msdb'
		,'tempdb'
		)
	AND query_type = 'Insert'
ORDER BY total_elapsed_time_ms DESC
	,last_execution_time DESC;