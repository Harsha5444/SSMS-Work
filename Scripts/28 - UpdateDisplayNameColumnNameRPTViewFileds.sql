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

WITH beforechanges
AS (
	SELECT rd.ReportDetailsId
		,rd.ReportDetailsName
		,'BEFORE' AS change_type
		,rd.reportfiledetails AS current_full_json
		,NULL AS new_full_json
	FROM reportdetails rd
	WHERE EXISTS (
			SELECT 1
			FROM #ReportMismatches rm
			WHERE rm.ReportDetailsId = rd.ReportDetailsId
				AND rm.db_display_name IS NOT NULL
			)
	)
	,UpdatedAdvanceFilter
AS (
	SELECT rd.ReportDetailsId
		,'[' + STRING_AGG(CASE WHEN rm.filter_type = 'AdvanceFilter'
					AND rm.filed_id = JSON_VALUE(af_item.[value], '$.FiledId')
					AND rm.db_display_name IS NOT NULL THEN JSON_MODIFY(JSON_MODIFY(af_item.[value], '$.DisplayName', rm.db_display_name), '$.ColumnName', rm.db_display_name) ELSE af_item.[value] END, ',') + ']' AS updated_advance_filter
	FROM reportdetails rd
	CROSS APPLY OPENJSON(rd.reportfiledetails, '$.AdvanceFilter') af_item
	LEFT JOIN #ReportMismatches rm ON rm.ReportDetailsId = rd.ReportDetailsId
		AND rm.filter_type = 'AdvanceFilter'
		AND rm.filed_id = JSON_VALUE(af_item.[value], '$.FiledId')
	WHERE EXISTS (
			SELECT 1
			FROM #ReportMismatches rm2
			WHERE rm2.ReportDetailsId = rd.ReportDetailsId
				AND rm2.db_display_name IS NOT NULL
			)
		AND JSON_QUERY(rd.reportfiledetails, '$.AdvanceFilter') IS NOT NULL
	GROUP BY rd.ReportDetailsId
	)
	,UpdatedSubGroupColumns
AS (
	SELECT rd.ReportDetailsId
		,'[' + STRING_AGG(CASE WHEN rm.filter_type = 'SubGroupColumns'
					AND rm.filed_id = JSON_VALUE(sg_item.[value], '$.FiledId')
					AND rm.db_display_name IS NOT NULL THEN JSON_MODIFY(JSON_MODIFY(sg_item.[value], '$.DisplayName', rm.db_display_name), '$.ColumnName', rm.db_display_name) ELSE sg_item.[value] END, ',') + ']' AS updated_subgroup_columns
	FROM reportdetails rd
	CROSS APPLY OPENJSON(rd.reportfiledetails, '$.SubGroupColumns') sg_item
	LEFT JOIN #ReportMismatches rm ON rm.ReportDetailsId = rd.ReportDetailsId
		AND rm.filter_type = 'SubGroupColumns'
		AND rm.filed_id = JSON_VALUE(sg_item.[value], '$.FiledId')
	WHERE EXISTS (
			SELECT 1
			FROM #ReportMismatches rm2
			WHERE rm2.ReportDetailsId = rd.ReportDetailsId
				AND rm2.db_display_name IS NOT NULL
			)
		AND JSON_QUERY(rd.reportfiledetails, '$.SubGroupColumns') IS NOT NULL
	GROUP BY rd.ReportDetailsId
	)
	,afterchanges
AS (
	SELECT rd.ReportDetailsId
		,rd.ReportDetailsName
		,'AFTER' AS change_type
		,NULL AS current_full_json
		,CASE WHEN uaf.updated_advance_filter IS NOT NULL
				AND usg.updated_subgroup_columns IS NOT NULL THEN JSON_MODIFY(JSON_MODIFY(rd.reportfiledetails, '$.AdvanceFilter', JSON_QUERY(uaf.updated_advance_filter)), '$.SubGroupColumns', JSON_QUERY(usg.updated_subgroup_columns)) WHEN uaf.updated_advance_filter IS NOT NULL THEN JSON_MODIFY(rd.reportfiledetails, '$.AdvanceFilter', JSON_QUERY(uaf.updated_advance_filter)) WHEN usg.updated_subgroup_columns IS NOT NULL THEN JSON_MODIFY(rd.reportfiledetails, '$.SubGroupColumns', JSON_QUERY(usg.updated_subgroup_columns)) ELSE rd.reportfiledetails END AS new_full_json
	FROM reportdetails rd
	LEFT JOIN UpdatedAdvanceFilter uaf ON uaf.ReportDetailsId = rd.ReportDetailsId
	LEFT JOIN UpdatedSubGroupColumns usg ON usg.ReportDetailsId = rd.ReportDetailsId
	WHERE EXISTS (
			SELECT 1
			FROM #ReportMismatches rm
			WHERE rm.ReportDetailsId = rd.ReportDetailsId
				AND rm.db_display_name IS NOT NULL
			)
	)
--update a
--set a.ReportFileDetails = b.new_full_json
--from reportdetails a 
--join afterchanges b on a.ReportDetailsId = b.ReportDetailsId

select * from afterchanges

--SELECT a.ReportDetailsId
--	,a.ReportDetailsName
--	,a.change_type
--	,a.current_full_json
--	,b.change_type
--	,b.new_full_json
--FROM beforechanges a
--JOIN afterchanges b ON a.ReportDetailsId = b.ReportDetailsId
--new_full_json

--select * from #ReportMismatches where reportdetailsid = 445

--select * from reportdetails where reportdetailsid = 445

--select * from rptviewfields where RptViewFieldsId = 2869

--select * from RptDomainRelatedViews where DomainRelatedViewId= 153