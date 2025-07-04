IF OBJECT_ID('tempdb..#ReportMismatches') IS NOT NULL
	DROP TABLE #ReportMismatches;

CREATE TABLE #ReportMismatches (
	ReportDetailsId INT
	,ReportDetailsName NVARCHAR(255)
	,filter_type NVARCHAR(50)
	,column_name NVARCHAR(100)
	,filed_id NVARCHAR(20)
	,json_display_name NVARCHAR(100)
	,json_alias_name NVARCHAR(100)
	,db_display_name NVARCHAR(100)
	,mismatch_reason NVARCHAR(100)
	);

WITH ReportData
AS (
	SELECT rd.ReportDetailsId
		,rd.ReportDetailsName
		,rd.reportfiledetails
	FROM reportdetails rd
	WHERE rd.reportfiledetails IS NOT NULL
		AND ISJSON(rd.reportfiledetails) = 1
		AND RD.createdby NOT IN ('DDAUser@DDA', 'adam.admin@LAD', 'avadmin', 'adam.admin@TVU2')
	)
	,FilterMismatches
AS (
	SELECT r.ReportDetailsId
		,r.ReportDetailsName
		,'AdvanceFilter' AS filter_type
		,af.DisplayName AS json_display_name
		,af.FiledId AS filed_id
		,af.ColumnName AS column_name
		,af.AliasName AS json_alias_name
		,rvf.displayname AS db_display_name
	FROM ReportData r
	CROSS APPLY OPENJSON(r.reportfiledetails, '$.AdvanceFilter') WITH (
			DisplayName NVARCHAR(100) '$.DisplayName'
			,FiledId NVARCHAR(20) '$.FiledId'
			,ColumnName NVARCHAR(100) '$.ColumnName'
			,AliasName NVARCHAR(100) '$.AliasName'
			) af
	LEFT JOIN rptviewfields rvf ON rvf.RptViewFieldsId = TRY_CAST(af.FiledId AS INT)
	WHERE (
			af.DisplayName != rvf.displayname
			OR rvf.displayname IS NULL
			)
		AND af.FiledId IS NOT NULL
	
	UNION ALL
	
	-- Check SubGroupColumns mismatches
	SELECT r.ReportDetailsId
		,r.ReportDetailsName
		,'SubGroupColumns' AS filter_type
		,sg.DisplayName AS json_display_name
		,sg.FiledId AS filed_id
		,sg.ColumnName AS column_name
		,sg.AliasName AS json_alias_name
		,rvf.displayname AS db_display_name
	FROM ReportData r
	CROSS APPLY OPENJSON(r.reportfiledetails, '$.SubGroupColumns') WITH (
			DisplayName NVARCHAR(100) '$.DisplayName'
			,FiledId NVARCHAR(20) '$.FiledId'
			,ColumnName NVARCHAR(100) '$.ColumnName'
			,AliasName NVARCHAR(100) '$.AliasName'
			) sg
	LEFT JOIN rptviewfields rvf ON rvf.RptViewFieldsId = TRY_CAST(sg.FiledId AS INT)
	WHERE (
			sg.DisplayName != rvf.displayname
			OR rvf.displayname IS NULL
			)
		AND sg.FiledId IS NOT NULL
	)
INSERT INTO #ReportMismatches
SELECT ReportDetailsId
	,ReportDetailsName
	,filter_type
	,column_name
	,filed_id
	,json_display_name
	,json_alias_name
	,db_display_name
	,CASE WHEN db_display_name IS NULL THEN 'Field ID not found in rptviewfields' WHEN json_display_name != db_display_name THEN 'DisplayName mismatch' ELSE 'Unknown issue' END AS mismatch_reason
FROM FilterMismatches;

---- Step 3: Review the mismatches
--SELECT 
--    COUNT(*) as total_mismatches,
--    SUM(CASE WHEN filter_type = 'AdvanceFilter' THEN 1 ELSE 0 END) as advance_filter_mismatches,
--    SUM(CASE WHEN filter_type = 'SubGroupColumns' THEN 1 ELSE 0 END) as subgroup_mismatches
--FROM #ReportMismatches;
---- Show detailed mismatches
--SELECT * FROM #ReportMismatches ORDER BY ReportDetailsId, filter_type, column_name;
WITH beforechanges
AS (
	SELECT rd.ReportDetailsId
		,rd.ReportDetailsName
		,'BEFORE' AS change_type
		,JSON_QUERY(rd.reportfiledetails, '$.AdvanceFilter') AS current_advance_filter
		,NULL AS new_advance_filter
	FROM reportdetails rd
	WHERE EXISTS (
			SELECT 1
			FROM #ReportMismatches rm
			WHERE rm.ReportDetailsId = rd.ReportDetailsId
				AND rm.filter_type = 'AdvanceFilter'
				AND rm.db_display_name IS NOT NULL
			)
	)
	,afterchanges
AS (
	SELECT rd.ReportDetailsId
		,rd.ReportDetailsName
		,'AFTER' AS change_type
		,NULL AS current_advance_filter
		,(
			SELECT '[' + STRING_AGG(CASE WHEN rm.filter_type = 'AdvanceFilter'
							AND rm.filed_id = JSON_VALUE(af_item.[value], '$.FiledId')
							AND rm.db_display_name IS NOT NULL THEN JSON_MODIFY(af_item.[value], '$.DisplayName', rm.db_display_name) ELSE af_item.[value] END, ',') + ']'
			FROM OPENJSON(rd.reportfiledetails, '$.AdvanceFilter') af_item
			LEFT JOIN #ReportMismatches rm ON rm.ReportDetailsId = rd.ReportDetailsId
				AND rm.filter_type = 'AdvanceFilter'
				AND rm.filed_id = JSON_VALUE(af_item.[value], '$.FiledId')
			) AS new_advance_filter
	FROM reportdetails rd
	WHERE EXISTS (
			SELECT 1
			FROM #ReportMismatches rm
			WHERE rm.ReportDetailsId = rd.ReportDetailsId
				AND rm.filter_type = 'AdvanceFilter'
				AND rm.db_display_name IS NOT NULL
			)
	)
SELECT a.ReportDetailsId
	,a.ReportDetailsName
	,a.change_type
	,a.current_advance_filter
	,b.change_type
	,b.new_advance_filter
FROM beforechanges a
JOIN afterchanges b ON a.ReportDetailsId = b.ReportDetailsId

SELECT *
FROM ReportDetails_bkp
WHERE reportdetailsid = 281

---- Step 4: UPDATE SCRIPT - Fix AdvanceFilter DisplayName mismatches
--UPDATE rd
--SET reportfiledetails = (
--    SELECT STRING_AGG(
--        CASE 
--            WHEN rm.filter_type = 'AdvanceFilter' AND rm.filed_id = af_item.FiledId 
--                 AND rm.db_display_name IS NOT NULL
--            THEN JSON_MODIFY(af_item.[value], '$.DisplayName', rm.db_display_name)
--            ELSE af_item.[value]
--        END, 
--        ','
--    )
--    FROM OPENJSON(rd.reportfiledetails, '$.AdvanceFilter') af_item
--    LEFT JOIN #ReportMismatches rm ON rm.ReportDetailsId = rd.ReportDetailsId 
--                                   AND rm.filter_type = 'AdvanceFilter'
--                                   AND rm.filed_id = JSON_VALUE(af_item.[value], '$.FiledId')
--    FOR JSON PATH, ROOT('AdvanceFilter')
--)
--FROM reportdetails rd
--WHERE EXISTS (
--    SELECT 1 FROM #ReportMismatches rm 
--    WHERE rm.ReportDetailsId = rd.ReportDetailsId 
--    AND rm.filter_type = 'AdvanceFilter'
--    AND rm.db_display_name IS NOT NULL
--);
---- Step 5: UPDATE SCRIPT - Fix SubGroupColumns DisplayName mismatches  
--UPDATE rd
--SET reportfiledetails = (
--    SELECT STRING_AGG(
--        CASE 
--            WHEN rm.filter_type = 'SubGroupColumns' AND rm.filed_id = sg_item.FiledId 
--                 AND rm.db_display_name IS NOT NULL
--            THEN JSON_MODIFY(sg_item.[value], '$.DisplayName', rm.db_display_name)
--            ELSE sg_item.[value]
--        END, 
--        ','
--    )
--    FROM OPENJSON(rd.reportfiledetails, '$.SubGroupColumns') sg_item
--    LEFT JOIN #ReportMismatches rm ON rm.ReportDetailsId = rd.ReportDetailsId 
--                                   AND rm.filter_type = 'SubGroupColumns'
--                                   AND rm.filed_id = JSON_VALUE(sg_item.[value], '$.FiledId')
--    FOR JSON PATH, ROOT('SubGroupColumns')
--)
--FROM reportdetails rd
--WHERE EXISTS (
--    SELECT 1 FROM #ReportMismatches rm 
--    WHERE rm.ReportDetailsId = rd.ReportDetailsId 
--    AND rm.filter_type = 'SubGroupColumns'
--    AND rm.db_display_name IS NOT NULL
--);
SELECT *
FROM clayton_dashboardreportdetails
WHERE ReportId IN (
		SELECT reportdetailsid
		FROM ReportDetails
		WHERE ChildReportId = 281
		)

SELECT *
FROM reportdetails
WHERE reportdetailsid = 281

SELECT reportdetailsid
FROM ReportDetails
WHERE ChildReportId = 281

SELECT *
FROM idm.AppErrorLog
ORDER BY 1 DESC

