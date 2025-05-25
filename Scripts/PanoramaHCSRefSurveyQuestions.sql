if object_id('RefSurveyQuestions', 'U') is not null
begin
    drop table RefSurveyQuestions;
end;

create table RefSurveyQuestions
([SurveyQuestionsId] [int] IDENTITY(1,1) NOT NULL,
MinYear int,
MaxYear int,
Term varchar(50),
SurveyType  varchar(200),
QuestionCode varchar(50),
QuestionText varchar(500),
SortOrder int,
	[TenantId] [int]  default 28675,
	[StatusId] [smallint] default 1,
	[CreatedBy] [varchar](150)  default 'DDAUser@DDA',
	[CreatedDate] [datetime]  default getdate(),
	[ModifiedBy] [varchar](150) NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_RefSurveyQuestions] PRIMARY KEY CLUSTERED ([SurveyQuestionsId] ASC)
,CONSTRAINT [FK_SurveyQuestions_RefStatus] FOREIGN KEY([StatusId]) REFERENCES [dbo].[RefStatus] ([StatusId])
,CONSTRAINT [FK_SurveyQuestions_Tenant] FOREIGN KEY([TenantId]) REFERENCES [IDM].[Tenant] ([TenantId]));

INSERT INTO RefSurveyQuestions (MinYear,MaxYear,Term,SurveyType,QuestionCode,QuestionText,SortOrder)


SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student Supports' as SurveyType, 'Q1' as QuestionCode, 'How well do people at your school understand you as a person?' as QuestionText, 1 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student Supports' as SurveyType, 'Q2' as QuestionCode, 'How much support do the adults at your school give you?' as QuestionText, 2 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student Supports' as SurveyType, 'Q3' as QuestionCode, 'How much respect do students at your school show you?' as QuestionText, 3 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student Supports' as SurveyType, 'Q4' as QuestionCode, 'Overall, how much do you feel like you belong at your school?' as QuestionText, 4 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student Supports' as SurveyType, 'Q5' as QuestionCode, 'How connected do you feel to the adults at your school?' as QuestionText, 5 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student Supports' as SurveyType, 'Q6' as QuestionCode, 'How much respect do students in your school show you?' as QuestionText, 6 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student Supports' as SurveyType, 'Q7' as QuestionCode, 'How much do you matter to others at this school?' as QuestionText, 7 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student SEL' as SurveyType, 'Q1' as QuestionCode, 'How often do you stay focused on the same goal for several months at a time?' as QuestionText, 1 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student SEL' as SurveyType, 'Q2' as QuestionCode, 'If you fail to reach an important goal, how likely are you to try again?' as QuestionText, 2 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student SEL' as SurveyType, 'Q3' as QuestionCode, 'When you are working on a project that matters a lot to you, how focused can you stay when there are lots of distractions?' as QuestionText, 3 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student SEL' as SurveyType, 'Q4' as QuestionCode, 'If you have a problem while working towards an important goal, how well can you keep working?' as QuestionText, 4 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student SEL' as SurveyType, 'Q5' as QuestionCode, 'Some people pursue some of their goals for a long time, and others change their goals frequently. Over the next several years, how likely are you to continue to pursue one of your current goals?' as QuestionText, 5 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student SEL' as SurveyType, 'Q6' as QuestionCode, 'How often do you feel excited?' as QuestionText, 6 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student SEL' as SurveyType, 'Q7' as QuestionCode, 'How often do you feel happy' as QuestionText, 7 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student SEL' as SurveyType, 'Q8' as QuestionCode, 'How often do you feel loved?' as QuestionText, 8 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student SEL' as SurveyType, 'Q9' as QuestionCode, 'How often do you feel safe?' as QuestionText, 9 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student SEL' as SurveyType, 'Q10' as QuestionCode, 'How often do you feel hopeful?' as QuestionText, 10 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student SEL' as SurveyType, 'Q11' as QuestionCode, 'How often do you feel angry?' as QuestionText, 11 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student SEL' as SurveyType, 'Q12' as QuestionCode, 'How often do you feel lonely?' as QuestionText, 12 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student SEL' as SurveyType, 'Q13' as QuestionCode, 'How often do you feel sad?' as QuestionText, 13 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student SEL' as SurveyType, 'Q14' as QuestionCode, 'How often do you feel worried?' as QuestionText, 14 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student SEL' as SurveyType, 'Q15' as QuestionCode, 'How often do you feel mad?' as QuestionText, 15 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student SEL' as SurveyType, 'Q16' as QuestionCode, 'How often do you feel frustrated?' as QuestionText, 16 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student SEL' as SurveyType, 'Q17' as QuestionCode, 'Thinking about everything in your life right now, what makes you feel the happiest?' as QuestionText, 17 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student SEL' as SurveyType, 'Q18' as QuestionCode, 'Thinking about everything in your life right now, what feels the hardest for you?' as QuestionText, 18 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student SEL' as SurveyType, 'Q19' as QuestionCode, 'Do you have a teacher or other adult from school who you can count on to help you, no matter what?' as QuestionText, 19 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student SEL' as SurveyType, 'Q20' as QuestionCode, 'Do you have a family member or other adult outside of school who you can count on to help you, no matter what?' as QuestionText, 20 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student SEL' as SurveyType, 'Q21' as QuestionCode, 'Do you have a friend from school who you can count on to help you, no matter what?' as QuestionText, 21 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student SEL' as SurveyType, 'Q22' as QuestionCode, 'Do you have a teacher or other adult from school who you can be completely yourself around?' as QuestionText, 22 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student SEL' as SurveyType, 'Q23' as QuestionCode, 'Do you have a family member or other adult outside of school who you can be completely yourself around?' as QuestionText, 23 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student SEL' as SurveyType, 'Q24' as QuestionCode, 'Do you have a friend from school who you can be completely yourself around?' as QuestionText, 24 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student SEL' as SurveyType, 'Q25' as QuestionCode, 'What can teachers or other adults at school do to better support you?' as QuestionText, 25 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student SEL' as SurveyType, 'Q26' as QuestionCode, 'How often do you stay focused on the same goal for more than 3 months at a time?' as QuestionText, 26 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student SEL' as SurveyType, 'Q27' as QuestionCode, 'If you fail at an important goal, how likely are you to try again?' as QuestionText, 27 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Student SEL' as SurveyType, 'Q28' as QuestionCode, 'What can teachers or other adults at school do to better help you?' as QuestionText, 28 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Staff Supports' as SurveyType, 'Q1' as QuestionCode, 'How often do you feel engaged?' as QuestionText, 1 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Staff Supports' as SurveyType, 'Q2' as QuestionCode, 'How often do you feel excited?' as QuestionText, 2 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Staff Supports' as SurveyType, 'Q3' as QuestionCode, 'How often do you feel exhausted?' as QuestionText, 3 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Staff Supports' as SurveyType, 'Q4' as QuestionCode, 'How often do you feel frustrated?' as QuestionText, 4 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Staff Supports' as SurveyType, 'Q5' as QuestionCode, 'How often do you feel happy?' as QuestionText, 5 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Staff Supports' as SurveyType, 'Q6' as QuestionCode, 'How often do you feel hopeful?' as QuestionText, 6 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Staff Supports' as SurveyType, 'Q7' as QuestionCode, 'How often do you feel overwhelmed?' as QuestionText, 7 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Staff Supports' as SurveyType, 'Q8' as QuestionCode, 'How often do you feel safe?' as QuestionText, 8 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Staff Supports' as SurveyType, 'Q9' as QuestionCode, 'How often do you feel stressed out?' as QuestionText, 9 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Staff Supports' as SurveyType, 'Q10' as QuestionCode, 'How often do you feel worried?' as QuestionText, 10 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Staff Supports' as SurveyType, 'Q11' as QuestionCode, 'How effective do you feel at your job right now?' as QuestionText, 11 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Staff Supports' as SurveyType, 'Q12' as QuestionCode, 'How much does your work matter to you?' as QuestionText, 12 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Staff Supports' as SurveyType, 'Q13' as QuestionCode, 'How meaningful for you is the work that you do?' as QuestionText, 13 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Staff Supports' as SurveyType, 'Q14' as QuestionCode, 'Overall, how satisfied are you with your job right now?' as QuestionText, 14 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Staff Supports' as SurveyType, 'Q15' as QuestionCode, 'What can school or district leaders do to better support your well-being?' as QuestionText, 15 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Staff Supports' as SurveyType, 'Q16' as QuestionCode, 'What has helped you most in managing work-related stress?' as QuestionText, 16 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Staff Supports' as SurveyType, 'Q17' as QuestionCode, 'How well do your colleagues at school understand you as a person?' as QuestionText, 17 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Staff Supports' as SurveyType, 'Q18' as QuestionCode, 'How connected do you feel to other adults at your school?' as QuestionText, 18 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Staff Supports' as SurveyType, 'Q19' as QuestionCode, 'How much respect do colleagues in your school show you?' as QuestionText, 19 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Staff Supports' as SurveyType, 'Q20' as QuestionCode, 'How much do you matter to others at your school?' as QuestionText, 20 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Staff Supports' as SurveyType, 'Q21' as QuestionCode, 'Overall, how much do you feel like you belong at your school?' as QuestionText, 21 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Staff Supports' as SurveyType, 'Q22' as QuestionCode, 'Please select your school cluster' as QuestionText, 22 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Teacher Supports' as SurveyType, 'Q1' as QuestionCode, 'How often do you feel engaged?' as QuestionText, 1 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Teacher Supports' as SurveyType, 'Q2' as QuestionCode, 'How often do you feel excited?' as QuestionText, 2 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Teacher Supports' as SurveyType, 'Q3' as QuestionCode, 'How often do you feel exhausted?' as QuestionText, 3 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Teacher Supports' as SurveyType, 'Q4' as QuestionCode, 'How often do you feel frustrated?' as QuestionText, 4 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Teacher Supports' as SurveyType, 'Q5' as QuestionCode, 'How often do you feel happy?' as QuestionText, 5 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Teacher Supports' as SurveyType, 'Q6' as QuestionCode, 'How often do you feel hopeful?' as QuestionText, 6 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Teacher Supports' as SurveyType, 'Q7' as QuestionCode, 'How often do you feel overwhelmed?' as QuestionText, 7 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Teacher Supports' as SurveyType, 'Q8' as QuestionCode, 'How often do you feel safe?' as QuestionText, 8 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Teacher Supports' as SurveyType, 'Q9' as QuestionCode, 'How often do you feel stressed out?' as QuestionText, 9 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Teacher Supports' as SurveyType, 'Q10' as QuestionCode, 'How often do you feel worried?' as QuestionText, 10 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Teacher Supports' as SurveyType, 'Q11' as QuestionCode, 'How effective do you feel at your job right now?' as QuestionText, 11 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Teacher Supports' as SurveyType, 'Q12' as QuestionCode, 'How much does your work matter to you?' as QuestionText, 12 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Teacher Supports' as SurveyType, 'Q13' as QuestionCode, 'How meaningful for you is the work that you do?' as QuestionText, 13 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Teacher Supports' as SurveyType, 'Q14' as QuestionCode, 'Overall, how satisfied are you with your job right now?' as QuestionText, 14 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Teacher Supports' as SurveyType, 'Q15' as QuestionCode, 'What can school or district leaders do to better support your well-being?' as QuestionText, 15 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Teacher Supports' as SurveyType, 'Q16' as QuestionCode, 'What has helped you most in managing work-related stress?' as QuestionText, 16 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Teacher Supports' as SurveyType, 'Q17' as QuestionCode, 'How well do your colleagues at school understand you as a person?' as QuestionText, 17 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Teacher Supports' as SurveyType, 'Q18' as QuestionCode, 'How connected do you feel to other adults at your school?' as QuestionText, 18 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Teacher Supports' as SurveyType, 'Q19' as QuestionCode, 'How much respect do colleagues in your school show you?' as QuestionText, 19 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Teacher Supports' as SurveyType, 'Q20' as QuestionCode, 'How much do you matter to others at your school?' as QuestionText, 20 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Teacher Supports' as SurveyType, 'Q21' as QuestionCode, 'Overall, how much do you feel like you belong at your school?' as QuestionText, 21 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'Teacher Supports' as SurveyType, 'Q22' as QuestionCode, 'Please select your school cluster' as QuestionText, 22 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'TPOS' as SurveyType, 'Q1' as QuestionCode, 'If this student fails to reach an important goal, how likely is s/he to try again?' as QuestionText, 1 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'TPOS' as SurveyType, 'Q2' as QuestionCode, 'How often does this student stay focused on the same goal for several months at a time?' as QuestionText, 2 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'TPOS' as SurveyType, 'Q3' as QuestionCode, 'Overall, how focused is this student in your class?' as QuestionText, 3 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'TPOS' as SurveyType, 'Q4' as QuestionCode, 'During the past 30 days, how considerate was this student of his/her classmates’ feelings?' as QuestionText, 4 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'TPOS' as SurveyType, 'Q5' as QuestionCode, 'How confident is this student in his or her ability to learn all the material presented in your class?' as QuestionText, 5 as SortOrder
UNION ALL SELECT '2023' as MinYear, NULL as MaxYear, 'Fall' as Term, 'TPOS' as SurveyType, 'Q6' as QuestionCode, 'How often is this student able to control his/her emotions when s/he needs to?' as QuestionText, 6 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student Supports' as SurveyType, 'Q1' as QuestionCode, 'How well do people at your school understand you as a person?' as QuestionText, 1 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student Supports' as SurveyType, 'Q2' as QuestionCode, 'How much support do the adults at your school give you?' as QuestionText, 2 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student Supports' as SurveyType, 'Q3' as QuestionCode, 'How much respect do students at your school show you?' as QuestionText, 3 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student Supports' as SurveyType, 'Q4' as QuestionCode, 'Overall, how much do you feel like you belong at your school?' as QuestionText, 4 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student Supports' as SurveyType, 'Q5' as QuestionCode, 'How connected do you feel to the adults at your school?' as QuestionText, 5 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student Supports' as SurveyType, 'Q6' as QuestionCode, 'How much respect do students in your school show you?' as QuestionText, 6 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student Supports' as SurveyType, 'Q7' as QuestionCode, 'How much do you matter to others at this school?' as QuestionText, 7 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student SEL' as SurveyType, 'Q1' as QuestionCode, 'How often do you stay focused on the same goal for several months at a time?' as QuestionText, 1 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student SEL' as SurveyType, 'Q2' as QuestionCode, 'If you fail to reach an important goal, how likely are you to try again?' as QuestionText, 2 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student SEL' as SurveyType, 'Q3' as QuestionCode, 'When you are working on a project that matters a lot to you, how focused can you stay when there are lots of distractions?' as QuestionText, 3 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student SEL' as SurveyType, 'Q4' as QuestionCode, 'If you have a problem while working towards an important goal, how well can you keep working?' as QuestionText, 4 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student SEL' as SurveyType, 'Q5' as QuestionCode, 'Some people pursue some of their goals for a long time, and others change their goals frequently. Over the next several years, how likely are you to continue to pursue one of your current goals?' as QuestionText, 5 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student SEL' as SurveyType, 'Q6' as QuestionCode, 'How often do you feel excited?' as QuestionText, 6 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student SEL' as SurveyType, 'Q7' as QuestionCode, 'How often do you feel happy?' as QuestionText, 7 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student SEL' as SurveyType, 'Q8' as QuestionCode, 'How often do you feel loved?' as QuestionText, 8 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student SEL' as SurveyType, 'Q9' as QuestionCode, 'How often do you feel safe?' as QuestionText, 9 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student SEL' as SurveyType, 'Q10' as QuestionCode, 'How often do you feel hopeful?' as QuestionText, 10 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student SEL' as SurveyType, 'Q11' as QuestionCode, 'How often do you feel angry?' as QuestionText, 11 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student SEL' as SurveyType, 'Q12' as QuestionCode, 'How often do you feel lonely?' as QuestionText, 12 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student SEL' as SurveyType, 'Q13' as QuestionCode, 'How often do you feel sad?' as QuestionText, 13 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student SEL' as SurveyType, 'Q14' as QuestionCode, 'How often do you feel worried?' as QuestionText, 14 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student SEL' as SurveyType, 'Q15' as QuestionCode, 'How often do you feel frustrated?' as QuestionText, 15 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student SEL' as SurveyType, 'Q16' as QuestionCode, 'How often do you feel mad?' as QuestionText, 16 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student SEL' as SurveyType, 'Q17' as QuestionCode, 'Thinking about everything in your life right now, what makes you feel the happiest?' as QuestionText, 17 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student SEL' as SurveyType, 'Q18' as QuestionCode, 'Thinking about everything in your life right now, what feels the hardest for you?' as QuestionText, 18 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student SEL' as SurveyType, 'Q19' as QuestionCode, 'Do you have a teacher or other adult from school who you can count on to help you, no matter what?' as QuestionText, 19 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student SEL' as SurveyType, 'Q20' as QuestionCode, 'Do you have a family member or other adult outside of school who you can count on to help you, no matter what?' as QuestionText, 20 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student SEL' as SurveyType, 'Q21' as QuestionCode, 'Do you have a friend from school who you can count on to help you, no matter what?' as QuestionText, 21 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student SEL' as SurveyType, 'Q22' as QuestionCode, 'Do you have a teacher or other adult from school who you can be completely yourself around?' as QuestionText, 22 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student SEL' as SurveyType, 'Q23' as QuestionCode, 'Do you have a family member or other adult outside of school who you can be completely yourself around?' as QuestionText, 23 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student SEL' as SurveyType, 'Q24' as QuestionCode, 'Do you have a friend from school who you can be completely yourself around?' as QuestionText, 24 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student SEL' as SurveyType, 'Q25' as QuestionCode, 'What can teachers or other adults at school do to better support you?' as QuestionText, 25 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student SEL' as SurveyType, 'Q26' as QuestionCode, 'How often do you stay focused on the same goal for more than 3 months at a time?' as QuestionText, 26 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student SEL' as SurveyType, 'Q27' as QuestionCode, 'If you fail at an important goal, how likely are you to try again?' as QuestionText, 27 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Student SEL' as SurveyType, 'Q28' as QuestionCode, 'What can teachers or other adults at school do to better help you?' as QuestionText, 28 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Staff Supports' as SurveyType, 'Q1' as QuestionCode, 'How often do you feel engaged?' as QuestionText, 1 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Staff Supports' as SurveyType, 'Q2' as QuestionCode, 'How often do you feel excited?' as QuestionText, 2 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Staff Supports' as SurveyType, 'Q3' as QuestionCode, 'How often do you feel exhausted?' as QuestionText, 3 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Staff Supports' as SurveyType, 'Q4' as QuestionCode, 'How often do you feel frustrated?' as QuestionText, 4 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Staff Supports' as SurveyType, 'Q5' as QuestionCode, 'How often do you feel happy?' as QuestionText, 5 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Staff Supports' as SurveyType, 'Q6' as QuestionCode, 'How often do you feel hopeful?' as QuestionText, 6 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Staff Supports' as SurveyType, 'Q7' as QuestionCode, 'How often do you feel overwhelmed?' as QuestionText, 7 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Staff Supports' as SurveyType, 'Q8' as QuestionCode, 'How often do you feel safe?' as QuestionText, 8 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Staff Supports' as SurveyType, 'Q9' as QuestionCode, 'How often do you feel stressed out?' as QuestionText, 9 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Staff Supports' as SurveyType, 'Q10' as QuestionCode, 'How often do you feel worried?' as QuestionText, 10 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Staff Supports' as SurveyType, 'Q11' as QuestionCode, 'How effective do you feel at your job right now?' as QuestionText, 11 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Staff Supports' as SurveyType, 'Q12' as QuestionCode, 'How much does your work matter to you?' as QuestionText, 12 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Staff Supports' as SurveyType, 'Q13' as QuestionCode, 'How meaningful for you is the work that you do?' as QuestionText, 13 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Staff Supports' as SurveyType, 'Q14' as QuestionCode, 'Overall, how satisfied are you with your job right now?' as QuestionText, 14 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Staff Supports' as SurveyType, 'Q15' as QuestionCode, 'What can school or district leaders do to better support your well-being?' as QuestionText, 15 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Staff Supports' as SurveyType, 'Q16' as QuestionCode, 'What has helped you most in managing work-related stress?' as QuestionText, 16 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Staff Supports' as SurveyType, 'Q17' as QuestionCode, 'How well do your colleagues at school understand you as a person?' as QuestionText, 17 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Staff Supports' as SurveyType, 'Q18' as QuestionCode, 'How connected do you feel to other adults at your school?' as QuestionText, 18 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Staff Supports' as SurveyType, 'Q19' as QuestionCode, 'How much respect do colleagues in your school show you?' as QuestionText, 19 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Staff Supports' as SurveyType, 'Q20' as QuestionCode, 'How much do you matter to others at your school?' as QuestionText, 20 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Staff Supports' as SurveyType, 'Q21' as QuestionCode, 'Overall, how much do you feel like you belong at your school?' as QuestionText, 21 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Staff Supports' as SurveyType, 'Q22' as QuestionCode, 'Please select your school cluster' as QuestionText, 22 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Teacher Supports' as SurveyType, 'Q1' as QuestionCode, 'How often do you feel engaged?' as QuestionText, 1 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Teacher Supports' as SurveyType, 'Q2' as QuestionCode, 'How often do you feel excited?' as QuestionText, 2 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Teacher Supports' as SurveyType, 'Q3' as QuestionCode, 'How often do you feel exhausted?' as QuestionText, 3 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Teacher Supports' as SurveyType, 'Q4' as QuestionCode, 'How often do you feel frustrated?' as QuestionText, 4 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Teacher Supports' as SurveyType, 'Q5' as QuestionCode, 'How often do you feel happy?' as QuestionText, 5 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Teacher Supports' as SurveyType, 'Q6' as QuestionCode, 'How often do you feel hopeful?' as QuestionText, 6 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Teacher Supports' as SurveyType, 'Q7' as QuestionCode, 'How often do you feel overwhelmed?' as QuestionText, 7 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Teacher Supports' as SurveyType, 'Q8' as QuestionCode, 'How often do you feel safe?' as QuestionText, 8 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Teacher Supports' as SurveyType, 'Q9' as QuestionCode, 'How often do you feel stressed out?' as QuestionText, 9 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Teacher Supports' as SurveyType, 'Q10' as QuestionCode, 'How often do you feel worried?' as QuestionText, 10 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Teacher Supports' as SurveyType, 'Q11' as QuestionCode, 'How effective do you feel at your job right now?' as QuestionText, 11 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Teacher Supports' as SurveyType, 'Q12' as QuestionCode, 'How much does your work matter to you?' as QuestionText, 12 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Teacher Supports' as SurveyType, 'Q13' as QuestionCode, 'How meaningful for you is the work that you do?' as QuestionText, 13 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Teacher Supports' as SurveyType, 'Q14' as QuestionCode, 'Overall, how satisfied are you with your job right now?' as QuestionText, 14 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Teacher Supports' as SurveyType, 'Q15' as QuestionCode, 'What can school or district leaders do to better support your well-being?' as QuestionText, 15 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Teacher Supports' as SurveyType, 'Q16' as QuestionCode, 'What has helped you most in managing work-related stress?' as QuestionText, 16 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Teacher Supports' as SurveyType, 'Q17' as QuestionCode, 'How well do your colleagues at school understand you as a person?' as QuestionText, 17 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Teacher Supports' as SurveyType, 'Q18' as QuestionCode, 'How connected do you feel to other adults at your school?' as QuestionText, 18 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Teacher Supports' as SurveyType, 'Q19' as QuestionCode, 'How much respect do colleagues in your school show you?' as QuestionText, 19 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Teacher Supports' as SurveyType, 'Q20' as QuestionCode, 'How much do you matter to others at your school?' as QuestionText, 20 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Teacher Supports' as SurveyType, 'Q21' as QuestionCode, 'Overall, how much do you feel like you belong at your school?' as QuestionText, 21 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'Teacher Supports' as SurveyType, 'Q22' as QuestionCode, 'Please select your school cluster' as QuestionText, 22 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'TPOS' as SurveyType, 'Q1' as QuestionCode, 'If this student fails to reach an important goal, how likely is s/he to try again?' as QuestionText, 1 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'TPOS' as SurveyType, 'Q2' as QuestionCode, 'How often does this student stay focused on the same goal for several months at a time?' as QuestionText, 2 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'TPOS' as SurveyType, 'Q3' as QuestionCode, 'Overall, how focused is this student in your class?' as QuestionText, 3 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'TPOS' as SurveyType, 'Q4' as QuestionCode, 'During the past 30 days, how considerate was this student of his/her classmates’ feelings?' as QuestionText, 4 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'TPOS' as SurveyType, 'Q5' as QuestionCode, 'How confident is this student in his or her ability to learn all the material presented in your class?' as QuestionText, 5 as SortOrder
UNION ALL SELECT '2024' as MinYear, NULL as MaxYear, 'Spring' as Term, 'TPOS' as SurveyType, 'Q6' as QuestionCode, 'How often is this student able to control his/her emotions when s/he needs to?' as QuestionText, 6 as SortOrder
