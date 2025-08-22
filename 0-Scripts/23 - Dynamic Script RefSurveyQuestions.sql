DECLARE @MinYear VARCHAR(10) = '2024';
DECLARE @MaxYear VARCHAR(10) = NULL;
DECLARE @Term VARCHAR(10) = 'Fall';
DECLARE @SurveyType VARCHAR(50) = 'Student Supports';
DECLARE @QuestionDescriptions VARCHAR(MAX) = 'How often do you feel engaged?//How often do you feel excited?//How often do you feel exhausted?//How often do you feel frustrated?//How often do you feel happy?//How often do you feel hopeful?//How often do you feel overwhelmed?//How often do you feel safe?//How often do you feel stressed out?//How often do you feel worried?//How effective do you feel at your job right now?//How much does your work matter to you?//How meaningful for you is the work that you do?//Overall, how satisfied are you with your job right now?//What can school or district leaders do to better support your well-being?//What has helped you most in managing work-related stress?//How well do your colleagues at school understand you as a person?//How connected do you feel to other adults at your school?//How much respect do colleagues in your school show you?//How much do you matter to others at your school?//Overall, how much do you feel like you belong at your school?//Please select your school cluster//If this student fails to reach an important goal, how likely is s/he to try again?//How often does this student stay focused on the same goal for several months at a time?//Overall, how focused is this student in your class?//During the past 30 days, how considerate was this student of his/her classmates feelings?//How confident is this student in his or her ability to learn all the material presented in your class?//How often is this student able to control his/her emotions when s/he needs to?';
DECLARE @StartQuestionCode INT = 1;

CREATE TABLE #SelectStatements (
    RowID INT IDENTITY(1,1),
    SelectStatement VARCHAR(MAX)
);

-- Remove empty questions and split by double slashes
DECLARE @Pos INT = 1;
DECLARE @NextPos INT;
DECLARE @Question VARCHAR(MAX);

-- Add double slashes to end to handle last question
DECLARE @SearchString VARCHAR(MAX) = @QuestionDescriptions + '//';

WHILE @Pos <= LEN(@SearchString)
BEGIN
    SET @NextPos = CHARINDEX('//', @SearchString, @Pos);
    
    -- Only process if we found a delimiter
    IF @NextPos > 0
    BEGIN
        SET @Question = SUBSTRING(@SearchString, @Pos, @NextPos - @Pos);
        
        -- Only insert non-empty questions
        IF LEN(LTRIM(RTRIM(@Question))) > 0
        BEGIN
            INSERT INTO #SelectStatements (SelectStatement)
            VALUES (
                CASE WHEN (SELECT COUNT(*) FROM #SelectStatements) > 0 THEN 'UNION ALL ' ELSE '' END +
                'SELECT ''' + @MinYear + ''' as MinYear, ' + 
                CASE WHEN @MaxYear IS NULL THEN 'NULL' ELSE '''' + @MaxYear + '''' END + ' as MaxYear, ' + 
                '''' + @Term + ''' as Term, ' +
                '''' + @SurveyType + ''' as SurveyType, ' +
                '''Q' + CAST(@StartQuestionCode + (SELECT COUNT(*) FROM #SelectStatements) AS VARCHAR(10)) + ''' as QuestionCode, ' +
                '''' + REPLACE(@Question, '''', '''''') + ''' as QuestionText, ' +
                CAST(@StartQuestionCode + (SELECT COUNT(*) FROM #SelectStatements) AS VARCHAR(10)) + ' as SortOrder'
            );
        END
        
        SET @Pos = @NextPos + 2; -- Move past the double slash
    END
    ELSE
    BEGIN
        SET @Pos = LEN(@SearchString) + 1; -- Exit loop
    END
END

-- Return all SELECT statements (first one won't have UNION ALL)
SELECT SelectStatement FROM #SelectStatements ORDER BY RowID;

DROP TABLE #SelectStatements;