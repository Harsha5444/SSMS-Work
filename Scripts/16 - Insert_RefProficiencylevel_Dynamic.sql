-- Create a temporary table to hold the generated SQL
CREATE TABLE #GeneratedSQL (SQLStatement NVARCHAR(MAX), SortKey INT);

-- Parameters 
DECLARE @SchoolYears TABLE (SchoolYear VARCHAR(4));
INSERT INTO @SchoolYears VALUES ('2020'),('2021'),('2022'),('2023'),('2024'),('2025');

DECLARE @AssessmentCodes TABLE (AssessmentCode VARCHAR(20));
INSERT INTO @AssessmentCodes VALUES ('PSAT89'),('PSATNMSQT'),('SAT');

DECLARE @SubjectAreas TABLE (SubjectAreaCode VARCHAR(20));
INSERT INTO @SubjectAreas VALUES ('EBRW'),('Mathematics');

DECLARE @ProficiencyLevels TABLE (
    ProficiencyLevel VARCHAR(20),
    SortOrder INT,
    ColorCode VARCHAR(7)
);
INSERT INTO @ProficiencyLevels VALUES 
    ('Not Yet Approaching',  1, '#ff0000'),
    ('Approaching',  2, '#fff000'),
    ('Meets/Exceeds',  3, '#32cd32');

-- Generate SQL for RefProficiencylevel with proper ordering
INSERT INTO #GeneratedSQL
SELECT 
    CONCAT(
        'SELECT ''', sy.SchoolYear, ''', ''',
        pl.ProficiencyLevel, ''', ''',
        pl.ProficiencyLevel, ''', ',
        pl.SortOrder, ', ''',
        pl.ColorCode, ''', NULL, NULL, ''',
        ac.AssessmentCode, ''', ''',
        sa.SubjectAreaCode, ''', ''PROFLVL'', ',
        pl.SortOrder, ', 50, 1, ''DDAUser@DDA'', GETDATE(), NULL, NULL'
    ) AS SQLStatement,
    ROW_NUMBER() OVER (ORDER BY sy.SchoolYear, ac.AssessmentCode, pl.SortOrder, sa.SubjectAreaCode) AS SortKey
FROM @SchoolYears sy 
CROSS JOIN @AssessmentCodes ac 
CROSS JOIN @ProficiencyLevels pl 
CROSS JOIN @SubjectAreas sa;

-- Add UNION ALL between statements (except the last one)
WITH OrderedSQL AS (
    SELECT SQLStatement, SortKey, 
           ROW_NUMBER() OVER (ORDER BY SortKey) AS RowNum,
           COUNT(*) OVER () AS TotalRows
    FROM #GeneratedSQL
)
UPDATE OrderedSQL
SET SQLStatement = CASE 
    WHEN RowNum < TotalRows THEN SQLStatement + ' UNION ALL' 
    ELSE SQLStatement 
END;

-- Output the results in the desired order
SELECT SQLStatement FROM #GeneratedSQL ORDER BY SortKey;

DROP TABLE #GeneratedSQL;