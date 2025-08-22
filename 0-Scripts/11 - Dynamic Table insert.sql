-- Create a temporary table to hold the generated SQL
CREATE TABLE #GeneratedSQL (SQLStatement NVARCHAR(MAX), SortKey INT);

-- Parameters 
DECLARE @Subjects TABLE (Subject VARCHAR(100), SubjectSort INT);
INSERT INTO @Subjects VALUES 
('Digital Literacy and Computer Science', 1),
('English Language Arts and Literacy', 2),
('Mathematics', 3),
('Science and Technology/Engineering', 4);

-- Subject domains mapping table
DECLARE @SubjectDomains TABLE (
    Subject VARCHAR(100),
    Domain VARCHAR(100),
    DomainSort INT
);

-- Digital Literacy and Computer Science domains
INSERT INTO @SubjectDomains VALUES
('Digital Literacy and Computer Science', 'Computing and Society', 1),
('Digital Literacy and Computer Science', 'Digital Tools and Collaboration', 2),
('Digital Literacy and Computer Science', 'Computing Science', 3),
('Digital Literacy and Computer Science', 'Computational Thinking', 4);

-- English Language Arts and Literacy domains
INSERT INTO @SubjectDomains VALUES
('English Language Arts and Literacy', 'Reading', 1),
('English Language Arts and Literacy', 'Writing', 2),
('English Language Arts and Literacy', 'Speaking and Listening', 3),
('English Language Arts and Literacy', 'Language', 4),
('English Language Arts and Literacy', 'Reading Foundational Skills', 5),
('English Language Arts and Literacy', 'Reading Literature', 6),
('English Language Arts and Literacy', 'Reading Informational Text', 7),
('English Language Arts and Literacy', 'Standards', 8),
('English Language Arts and Literacy', 'Reading in History/Social Science', 9),
('English Language Arts and Literacy', 'Reading in Science/CTE', 10),
('English Language Arts and Literacy', 'Writing in Content Areas', 11),
('English Language Arts and Literacy', 'Speaking & Listening in Content Areas', 12);

-- Mathematics domains
INSERT INTO @SubjectDomains VALUES
('Mathematics', 'Counting & Cardinality', 1),
('Mathematics', 'Measurement & Data', 2),
('Mathematics', 'Geometry', 3),
('Mathematics', 'Operations & Algebraic Thinking', 4),
('Mathematics', 'Number & Operations in Base Ten', 5),
('Mathematics', 'Number & Operations—Fractions', 6),
('Mathematics', 'Ratios & Proportional Relationships', 7),
('Mathematics', 'The Number System', 8),
('Mathematics', 'Expressions & Equations', 9),
('Mathematics', 'Statistics & Probability', 10),
('Mathematics', 'Functions', 11),
('Mathematics', 'Real Number System', 12),
('Mathematics', 'Quantities', 13),
('Mathematics', 'Seeing Structure', 14),
('Mathematics', 'Arithmetic with Polynomials', 15),
('Mathematics', 'Creating Equations', 16),
('Mathematics', 'Reasoning with Equations', 17),
('Mathematics', 'Interpreting Functions', 18),
('Mathematics', 'Building Functions', 19),
('Mathematics', 'Linear, Quadratic, and Exponential Models', 20),
('Mathematics', 'Categorical and Quantitative Data', 21),
('Mathematics', 'Congruence', 22),
('Mathematics', 'Similarity, Triangles, and Trigonometry', 23),
('Mathematics', 'Circles', 24),
('Mathematics', 'Geometric Properties with Equations', 25),
('Mathematics', 'Geometric Measurement', 26),
('Mathematics', 'Modeling with Geometry', 27),
('Mathematics', 'Conditional Probability', 28),
('Mathematics', 'Complex Number System', 29),
('Mathematics', 'Vector and Matrix Quantities', 30),
('Mathematics', 'Trigonometric Functions', 31),
('Mathematics', 'Making Inferences', 32),
('Mathematics', 'Using Probability', 33);

-- Science and Technology/Engineering domains
INSERT INTO @SubjectDomains VALUES
('Science and Technology/Engineering', 'Earth and Space Sciences', 1),
('Science and Technology/Engineering', 'Life Science', 2),
('Science and Technology/Engineering', 'Physical Science', 3),
('Science and Technology/Engineering', 'Technology/Engineering', 4),
('Science and Technology/Engineering', 'Biology', 5),
('Science and Technology/Engineering', 'Chemistry', 6),
('Science and Technology/Engineering', 'Physics', 7);

DECLARE @Grades TABLE (Grade VARCHAR(20), SortOrder INT);
INSERT INTO @Grades VALUES 
('Prekindergarten', 1),
('Kindergarten', 2),
('Grade 1', 3),
('Grade 2', 4),
('Grade 3', 5),
('Grade 4', 6),
('Grade 5', 7),
('Grade 6', 8),
('Grade 7', 9),
('Grade 8', 10),
('Grade 9', 11),
('Grade 10', 12),
('Grade 11', 13),
('Grade 12', 14);

--DECLARE @Languages TABLE (Language VARCHAR(20), SortOrder INT);
--INSERT INTO @Languages VALUES 
--('English', 1),
--('Spanish', 2),
--('Portuguese', 3),
--('French', 4);

-- Generate SQL for each combination
INSERT INTO #GeneratedSQL
SELECT 
    CONCAT(
        'SELECT ''', g.Grade, ''' AS Grade, ''',
        s.Subject, ''' AS Subject, ''',
        d.Domain, ''' AS Domain, ''',
        '13152'' AS TenantID, ''',
		'DDAUser@DDA'' as CreatedBy, ',
		'GetDate() as CreatedDate'
    ) AS SQLStatement,
    -- Sort by Subject, then Grade, then Domain, then Language
    (s.SubjectSort * 1000000) + (g.SortOrder * 10000) + (d.DomainSort * 100) AS SortKey
FROM @Subjects s
JOIN @SubjectDomains d ON s.Subject = d.Subject
CROSS JOIN @Grades g;

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