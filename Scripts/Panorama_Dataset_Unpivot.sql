WITH UnpivotedData AS (
    SELECT 
    Client_Name, District_Name, School_Name, School_ID, Student_First_Name, Student_Last_Name, Student_Email, Student_Panorama_ID,
    Student_ID, Student_Grade_Level, Student_Gender, Student_Race, Student_Spec_ED_Programs, Unique_Response_ID, Survey_Type,
    Response_Language, Response_Start_Time, Response_Duration_minutes, Term, Survey_Category, Survey_Year, Question_Code, Question_Response
FROM 
    main.Panorama_Student_Survey
CROSS APPLY (
    VALUES 
            ('Q1', Q1), ('Q2', Q2), ('Q3', Q3), ('Q4', Q4), ('Q5', Q5),
            ('Q6', Q6), ('Q7', Q7), ('Q8', Q8), ('Q9', Q9), ('Q10', Q10), 
            ('Q11', Q11), ('Q12', Q12), ('Q13', Q13), ('Q14', Q14), ('Q15', Q15),
            ('Q16', Q16), ('Q17', Q17), ('Q18', Q18), ('Q19', Q19), ('Q20', Q20),
            ('Q21', Q21), ('Q22', Q22), ('Q23', Q23), ('Q24', Q24), ('Q25', Q25),
            ('Q26', Q26), ('Q27', Q27), ('Q28', Q28)
) AS UnpivotedData(Question_Code, Question_Response)
WHERE Question_Response IS NOT NULL
),
JoinedWithRef AS (
    SELECT 
        Client_Name, District_Name, School_Name, School_ID, Student_First_Name, Student_Last_Name, Student_Email, Student_Panorama_ID,
    Student_ID, Student_Grade_Level, Student_Gender, Student_Race, Student_Spec_ED_Programs, Unique_Response_ID, Survey_Type,
    Response_Language, Response_Start_Time, Response_Duration_minutes, Question_Code, Question_Response, r.QuestionText, r.SortOrder,
        r.Term, r.SurveyType, u.Survey_Year AS SurveyYear
    FROM 
        UnpivotedData u
    JOIN 
        RefSurveyQuestions r
    ON 
        u.Question_Code = r.QuestionCode
        AND r.SurveyType = u.survey_Category
        AND r.Term = u.Term
		AND r.MinYear = u.Survey_Year
)
select * from JoinedWithRef
SELECT 
     SurveyYear, Term, SurveyType AS SurveryCategory, School_Name,Student_Panorama_ID,Unique_Response_ID, Survey_Type,
    Response_Language, Response_Start_Time, Response_Duration_minutes,
    MAX(CASE WHEN Question_Code = 'Q1' THEN QuestionText END) AS Q1_Values,
    MAX(CASE WHEN Question_Code = 'Q1' THEN Question_Response END) AS Q1_Text,
    MAX(CASE WHEN Question_Code = 'Q2' THEN QuestionText END) AS Q2_Values,
    MAX(CASE WHEN Question_Code = 'Q2' THEN Question_Response END) AS Q2_Text,
    MAX(CASE WHEN Question_Code = 'Q3' THEN QuestionText END) AS Q3_Values,
    MAX(CASE WHEN Question_Code = 'Q3' THEN Question_Response END) AS Q3_Text,
    MAX(CASE WHEN Question_Code = 'Q4' THEN QuestionText END) AS Q4_Values,
    MAX(CASE WHEN Question_Code = 'Q4' THEN Question_Response END) AS Q4_Text,
    MAX(CASE WHEN Question_Code = 'Q5' THEN QuestionText END) AS Q5_Values,
    MAX(CASE WHEN Question_Code = 'Q5' THEN Question_Response END) AS Q5_Text,
    MAX(CASE WHEN Question_Code = 'Q6' THEN QuestionText END) AS Q6_Values,
    MAX(CASE WHEN Question_Code = 'Q6' THEN Question_Response END) AS Q6_Text,
    MAX(CASE WHEN Question_Code = 'Q7' THEN QuestionText END) AS Q7_Values,
    MAX(CASE WHEN Question_Code = 'Q7' THEN Question_Response END) AS Q7_Text,
    MAX(CASE WHEN Question_Code = 'Q8' THEN QuestionText END) AS Q8_Values,
    MAX(CASE WHEN Question_Code = 'Q8' THEN Question_Response END) AS Q8_Text,
    MAX(CASE WHEN Question_Code = 'Q9' THEN QuestionText END) AS Q9_Values,
    MAX(CASE WHEN Question_Code = 'Q9' THEN Question_Response END) AS Q9_Text,
    MAX(CASE WHEN Question_Code = 'Q10' THEN QuestionText END) AS Q10_Values,
    MAX(CASE WHEN Question_Code = 'Q10' THEN Question_Response END) AS Q10_Text,
    MAX(CASE WHEN Question_Code = 'Q11' THEN QuestionText END) AS Q11_Values,
    MAX(CASE WHEN Question_Code = 'Q11' THEN Question_Response END) AS Q11_Text,
	MAX(CASE WHEN Question_Code = 'Q12' THEN QuestionText END) AS Q12_Values,
    MAX(CASE WHEN Question_Code = 'Q12' THEN Question_Response END) AS Q12_Text,
    MAX(CASE WHEN Question_Code = 'Q13' THEN QuestionText END) AS Q13_Values,
    MAX(CASE WHEN Question_Code = 'Q13' THEN Question_Response END) AS Q13_Text,
    MAX(CASE WHEN Question_Code = 'Q14' THEN QuestionText END) AS Q14_Values,
    MAX(CASE WHEN Question_Code = 'Q14' THEN Question_Response END) AS Q14_Text,
    MAX(CASE WHEN Question_Code = 'Q15' THEN QuestionText END) AS Q15_Values,
    MAX(CASE WHEN Question_Code = 'Q15' THEN Question_Response END) AS Q15_Text,
    MAX(CASE WHEN Question_Code = 'Q16' THEN QuestionText END) AS Q16_Values,
    MAX(CASE WHEN Question_Code = 'Q16' THEN Question_Response END) AS Q16_Text,
    MAX(CASE WHEN Question_Code = 'Q17' THEN QuestionText END) AS Q17_Values,
    MAX(CASE WHEN Question_Code = 'Q17' THEN Question_Response END) AS Q17_Text,
    MAX(CASE WHEN Question_Code = 'Q18' THEN QuestionText END) AS Q18_Values,
    MAX(CASE WHEN Question_Code = 'Q18' THEN Question_Response END) AS Q18_Text,
    MAX(CASE WHEN Question_Code = 'Q19' THEN QuestionText END) AS Q19_Values,
    MAX(CASE WHEN Question_Code = 'Q19' THEN Question_Response END) AS Q19_Text,
    MAX(CASE WHEN Question_Code = 'Q20' THEN QuestionText END) AS Q20_Values,
    MAX(CASE WHEN Question_Code = 'Q20' THEN Question_Response END) AS Q20_Text,
    MAX(CASE WHEN Question_Code = 'Q21' THEN QuestionText END) AS Q21_Values,
    MAX(CASE WHEN Question_Code = 'Q21' THEN Question_Response END) AS Q21_Text,
    MAX(CASE WHEN Question_Code = 'Q22' THEN QuestionText END) AS Q22_Values,
    MAX(CASE WHEN Question_Code = 'Q22' THEN Question_Response END) AS Q22_Text,
    MAX(CASE WHEN Question_Code = 'Q23' THEN QuestionText END) AS Q23_Values,
    MAX(CASE WHEN Question_Code = 'Q23' THEN Question_Response END) AS Q23_Text,
    MAX(CASE WHEN Question_Code = 'Q24' THEN QuestionText END) AS Q24_Values,
    MAX(CASE WHEN Question_Code = 'Q24' THEN Question_Response END) AS Q24_Text,
    MAX(CASE WHEN Question_Code = 'Q25' THEN QuestionText END) AS Q25_Values,
    MAX(CASE WHEN Question_Code = 'Q25' THEN Question_Response END) AS Q25_Text,
    MAX(CASE WHEN Question_Code = 'Q26' THEN QuestionText END) AS Q26_Values,
    MAX(CASE WHEN Question_Code = 'Q26' THEN Question_Response END) AS Q26_Text,
    MAX(CASE WHEN Question_Code = 'Q27' THEN QuestionText END) AS Q27_Values,
    MAX(CASE WHEN Question_Code = 'Q27' THEN Question_Response END) AS Q27_Text,
    MAX(CASE WHEN Question_Code = 'Q28' THEN QuestionText END) AS Q28_Values,
    MAX(CASE WHEN Question_Code = 'Q28' THEN Question_Response END) AS Q28_Text
FROM 
    JoinedWithRef
GROUP BY
    School_Name,Student_Panorama_ID,Unique_Response_ID, Survey_Type,
    Response_Language, Response_Start_Time, Response_Duration_minutes, Term, SurveyType, SurveyYear;

--select * from refmetric