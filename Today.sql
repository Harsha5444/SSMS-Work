Select top 10 * from clayton_assessment_eoc 
Select top 10 * from clayton_assessment_eog

select distinct testtype from Clayton_Assessment_EOC
select distinct testtype from Clayton_Assessment_EOG

select distinct testdate from Clayton_Assessment_EOC
select distinct testdate from Clayton_Assessment_EOG

select distinct testtakendate from Clayton_Assessment_EOC
select distinct testtakendate from Clayton_Assessment_EOG

select * from main.assessmentdetails where assessmentcode = 'eog' and schoolyear = 2022

select schoolyear,studentnumber,testType,testadmin,count(studentnumber) from clayton_assessment_eoc
group by schoolyear,studentnumber,testType,testadmin
having count(studentnumber)>1

select schoolyear,studentnumber,testType,testadmin,count(studentnumber) from clayton_assessment_eog
group by schoolyear,studentnumber,testType,testadmin
having count(studentnumber)>1

		/* select schoolyear,gtid,testType,testadmin,count(gtid) from clayton_assessment_eog
		group by schoolyear,gtid,testType,testadmin
		having count(gtid) > 1  --2641868288 */

select * from clayton_assessment_eoc where schoolyear = 2022 and studentnumber = '0342093' and testType='Biology' and	testadmin='Spring'

select * from clayton_assessment_eog where schoolyear = 2024 and gtid = '2641868288' and testType='Sci' and testadmin='SPRING'
--0432644
--1511131
select * from main.clayton_analyticvue_icstudents where studentnumber = '0432644'
select * from main.clayton_analyticvue_icstudents where studentnumber = '1511131'
select * from main.clayton_analyticvue_icstudents where stateid = '2641868288' and schoolyear = 2024

select getdate()

select distinct CONVERT(DATE, 
    RIGHT(RIGHT('0' + testdate, 6), 2) + -- YY
    LEFT(RIGHT('0' + testdate, 6), 2) + -- MM
    SUBSTRING(RIGHT('0' + testdate, 6), 3, 2), 1) 
from Clayton_Assessment_EOG

select row_number () over (partition by schoolyear,studentnumber,testType,testadmin order by testtakendate desc) as TestTakendateRowNumber, * 
from clayton_assessment_eoc where schoolyear = 2023 and studentnumber = '0349604' and testType='United States History' and testadmin='Spring'

select * from Clayton_Assessment_EOC where testtakendaterank = 2

select * from ReportDetails

select gtid,count(distinct studentnumber) from Clayton_Assessment_EOG
group by gtid
having count(distinct studentnumber)>1

/*
4067225449
9518590583
3473203987
2641868288
5821973421
*/


/*same stateid having multiple studentnumbers*/

--no schoolyear
select stateID,count(distinct studentnumber) from main.Clayton_AnalyticVue_ICStudents
group by stateID
having count(distinct studentnumber)>1

select * from main.clayton_analyticvue_icstudents where stateid = '7033890228'


--with schoolyear
select schoolyear,stateID,count(distinct studentnumber) from main.Clayton_AnalyticVue_ICStudents
group by schoolyear,stateID
having count(distinct studentnumber)>1

select * from main.clayton_analyticvue_icstudents where stateid = '3063023762'

		
		/*same studentnumber having multiple stateIDs*/

		--no schoolyear
		select studentnumber,count(distinct stateID) from main.Clayton_AnalyticVue_ICStudents
		group by studentnumber
		having count(distinct stateID)>1

		select * from main.clayton_analyticvue_icstudents where studentnumber = '0439981'

		--with schoolyear
		select schoolyear,studentnumber,count(distinct stateID) from main.Clayton_AnalyticVue_ICStudents
		group by schoolyear,studentnumber
		having count(distinct stateID)>1

		select * from main.clayton_analyticvue_icstudents where stateid = '0439981'