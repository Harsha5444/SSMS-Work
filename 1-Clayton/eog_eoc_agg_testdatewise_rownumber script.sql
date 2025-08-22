SELECT TOP 10 *
FROM clayton_assessment_eoc

SELECT TOP 10 *
FROM clayton_assessment_eog

SELECT DISTINCT testtype
FROM Clayton_Assessment_EOC

SELECT DISTINCT testtype
FROM Clayton_Assessment_EOG

SELECT DISTINCT testdate
FROM Clayton_Assessment_EOC

SELECT DISTINCT testdate
FROM Clayton_Assessment_EOG

SELECT DISTINCT testtakendate
FROM Clayton_Assessment_EOC

SELECT DISTINCT testtakendate
FROM Clayton_Assessment_EOG

SELECT *
FROM main.assessmentdetails
WHERE assessmentcode = 'eog'
	AND schoolyear = 2022

SELECT schoolyear
	,studentnumber
	,testType
	,testadmin
	,count(studentnumber)
FROM clayton_assessment_eoc
GROUP BY schoolyear
	,studentnumber
	,testType
	,testadmin
HAVING count(studentnumber) > 1

SELECT schoolyear
	,studentnumber
	,testType
	,testadmin
	,count(studentnumber)
FROM clayton_assessment_eog
GROUP BY schoolyear
	,studentnumber
	,testType
	,testadmin
HAVING count(studentnumber) > 1

/* select schoolyear,gtid,testType,testadmin,count(gtid) from clayton_assessment_eog
		group by schoolyear,gtid,testType,testadmin
		having count(gtid) > 1  --2641868288 */
SELECT *
FROM clayton_assessment_eoc
WHERE schoolyear = 2022
	AND studentnumber = '0342093'
	AND testType = 'Biology'
	AND testadmin = 'Spring'

SELECT *
FROM clayton_assessment_eog
WHERE schoolyear = 2024
	AND gtid = '2641868288'
	AND testType = 'Sci'
	AND testadmin = 'SPRING'

--0432644
--1511131
SELECT *
FROM main.clayton_analyticvue_icstudents
WHERE studentnumber = '0432644'

SELECT *
FROM main.clayton_analyticvue_icstudents
WHERE studentnumber = '1511131'

SELECT *
FROM main.clayton_analyticvue_icstudents
WHERE stateid = '2641868288'
	AND schoolyear = 2024

SELECT getdate()

SELECT DISTINCT CONVERT(DATE, RIGHT(RIGHT('0' + testdate, 6), 2) + -- YY
		LEFT(RIGHT('0' + testdate, 6), 2) + -- MM
		SUBSTRING(RIGHT('0' + testdate, 6), 3, 2), 1)
FROM Clayton_Assessment_EOG

SELECT row_number() OVER (
		PARTITION BY schoolyear
		,studentnumber
		,testType
		,testadmin ORDER BY testtakendate DESC
		) AS TestTakendateRowNumber
	,*
FROM clayton_assessment_eoc
WHERE schoolyear = 2023
	AND studentnumber = '0349604'
	AND testType = 'United States History'
	AND testadmin = 'Spring'

SELECT *
FROM Clayton_Assessment_EOC
WHERE testtakendaterank = 2

SELECT *
FROM ReportDetails

SELECT gtid
	,count(DISTINCT studentnumber)
FROM Clayton_Assessment_EOG
GROUP BY gtid
HAVING count(DISTINCT studentnumber) > 1

/*
4067225449
9518590583
3473203987
2641868288
5821973421
*/
/*same stateid having multiple studentnumbers*/
--no schoolyear
SELECT stateID
	,count(DISTINCT studentnumber)
FROM main.Clayton_AnalyticVue_ICStudents
GROUP BY stateID
HAVING count(DISTINCT studentnumber) > 1

SELECT *
FROM main.clayton_analyticvue_icstudents
WHERE stateid = '7033890228'

--with schoolyear
SELECT schoolyear
	,stateID
	,count(DISTINCT studentnumber)
FROM main.Clayton_AnalyticVue_ICStudents
GROUP BY schoolyear
	,stateID
HAVING count(DISTINCT studentnumber) > 1

SELECT *
FROM main.clayton_analyticvue_icstudents
WHERE stateid = '3063023762'

/*same studentnumber having multiple stateIDs*/
--no schoolyear
SELECT studentnumber
	,count(DISTINCT stateID)
FROM main.Clayton_AnalyticVue_ICStudents
GROUP BY studentnumber
HAVING count(DISTINCT stateID) > 1

SELECT *
FROM main.clayton_analyticvue_icstudents
WHERE studentnumber = '0439981'

--with schoolyear
SELECT schoolyear
	,studentnumber
	,count(DISTINCT stateID)
FROM main.Clayton_AnalyticVue_ICStudents
GROUP BY schoolyear
	,studentnumber
HAVING count(DISTINCT stateID) > 1

SELECT *
FROM main.clayton_analyticvue_icstudents
WHERE stateid = '0439981'


SELECT schoolyear
	,*
FROM CCPSK12StudentDetails
WHERE statestudentid = '4067225449'

select * from reportdetails order by 1 desc

select * from Clayton_AcademicProgress_Middle



