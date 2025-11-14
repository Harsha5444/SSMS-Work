-- Declare parameters
DECLARE @OldAliasName NVARCHAR(100) = 'Student School';
DECLARE @NewAliasName NVARCHAR(100) = 'School Name';

-- Update using CTE
WITH UpdatedJSON AS (
    SELECT 
        rd.ReportDetailsId,
        JSON_MODIFY(
            rd.ReportFileDetails,
            '$.SubGroupColumns',
            JSON_QUERY(
                '[' +
                STRING_AGG(
                    CASE 
                        WHEN JSON_VALUE(sg.value, '$.AliasName') = @OldAliasName THEN
                            JSON_MODIFY(sg.value, '$.AliasName', @NewAliasName)
                        ELSE
                            sg.value
                    END,
                    ','
                ) +
                ']'
            )
        ) AS NewJSON
    FROM reportdetails rd
    CROSS APPLY OPENJSON(rd.ReportFileDetails, '$.SubGroupColumns') sg
    WHERE rd.tenantid = 38
      AND rd.ReportDetailsId IN (
          9003,9004,9005,9006,9007,9008,9009,9010,8868,8870,8878,8879,8880,8881,8882,
          8890,8891,8892,8893,8894,8895,8907,8908,8909,8910,8911,8912,8913,8914,
          8920,8921,8922,8923,8924,8925,8926,8927
      )
    GROUP BY rd.ReportDetailsId, rd.ReportFileDetails
)
select * from UpdatedJSON
--UPDATE rd
--SET ReportFileDetails = uj.NewJSON
--FROM reportdetails rd
--INNER JOIN UpdatedJSON uj ON rd.ReportDetailsId = uj.ReportDetailsId;