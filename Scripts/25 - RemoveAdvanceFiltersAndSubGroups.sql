DECLARE @FieldToRemove NVARCHAR(100) = 'FRL'; -- Parameter for the field to remove
DECLARE @ReportIds TABLE (ReportId INT);

INSERT INTO @ReportIds VALUES (318); -- Your report IDs

WITH ReportData AS (
    SELECT 
        rd.ReportDetailsId,
        rd.ReportDetailsName,
        rd.reportfiledetails AS CurrentJson,
        JSON_MODIFY(
            JSON_MODIFY(
                rd.reportfiledetails, 
                '$.AdvanceFilter', 
                CASE WHEN JSON_QUERY(rd.reportfiledetails, '$.AdvanceFilter') IS NOT NULL
                     THEN (
                         SELECT *
                         FROM OPENJSON(JSON_QUERY(rd.reportfiledetails, '$.AdvanceFilter'))
                         WITH (
                             DisplayName NVARCHAR(100) '$.DisplayName',
                             ColumnName NVARCHAR(100) '$.ColumnName',
                             AliasName NVARCHAR(100) '$.AliasName',
                             SortOrder INT '$.SortOrder',
                             FiledId NVARCHAR(20) '$.FiledId',
                             DefaultValue NVARCHAR(MAX) '$.DefaultValue'
                         )
                         WHERE NOT (DisplayName = @FieldToRemove AND ColumnName = @FieldToRemove)
                         FOR JSON PATH, INCLUDE_NULL_VALUES
                     )
                     ELSE JSON_QUERY(rd.reportfiledetails, '$.AdvanceFilter')
                END
            ),
            '$.SubGroupColumns',
            CASE WHEN JSON_QUERY(rd.reportfiledetails, '$.SubGroupColumns') IS NOT NULL
                 THEN (
                     SELECT *
                     FROM OPENJSON(JSON_QUERY(rd.reportfiledetails, '$.SubGroupColumns'))
                     WITH (
                         DisplayName NVARCHAR(100) '$.DisplayName',
                         ColumnName NVARCHAR(100) '$.ColumnName',
                         AliasName NVARCHAR(100) '$.AliasName',
                         SortOrder INT '$.SortOrder',
                         FiledId NVARCHAR(20) '$.FiledId',
                         DefaultValue NVARCHAR(MAX) '$.DefaultValue'
                     )
                     WHERE NOT (DisplayName = @FieldToRemove AND ColumnName = @FieldToRemove)
                     FOR JSON PATH, INCLUDE_NULL_VALUES
                 )
                 ELSE JSON_QUERY(rd.reportfiledetails, '$.SubGroupColumns')
            END
        ) AS ProposedJson
    FROM @ReportIds r
    JOIN reportdetails rd ON r.ReportId = rd.ReportDetailsId
)

SELECT 
    ReportDetailsId,
    ReportDetailsName,
    CurrentJson,
    ProposedJson,
    'UPDATE reportdetails SET reportfiledetails = ''' + 
    REPLACE(ProposedJson, '''', '''''') + 
    ''' WHERE ReportDetailsId = ' + CAST(ReportDetailsId AS VARCHAR(10)) + ';' AS UpdateStatement
FROM ReportData;

