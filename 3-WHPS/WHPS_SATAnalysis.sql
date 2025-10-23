--Source Count
SELECT schoolyear
	,count(DISTINCT STATE_STUDENT_ID) StdCnt
FROM Main.WHPS_SAT_Source_Data ss
WHERE ss.schoolyear = 2026
GROUP BY schoolyear

--After Join StateId Count
SELECT DISTINCT ss.SchoolYear
	,count(DISTINCT se.STUDENT_NUMBER) AS DistrictStudentId
FROM Main.WHPS_SAT_Source_Data ss
JOIN [Main].[WHPS_Students] se ON ss.STATE_STUDENT_ID = se.STATE_STUDENTNUMBER
	AND ss.schoolyear = se.schoolyear
WHERE ss.schoolyear = 2026
GROUP BY ss.schoolyear

----Discarded StatestudentId's
SELECT DISTINCT ss.SchoolYear
	,ss.STATE_STUDENT_ID AS DistrictStudentId
FROM Main.WHPS_SAT_Source_Data ss
LEFT JOIN [Main].[WHPS_Students] se ON ss.STATE_STUDENT_ID = se.STATE_STUDENTNUMBER
	AND ss.schoolyear = se.schoolyear
WHERE ss.schoolyear = 2026
	AND se.STATE_STUDENTNUMBER IS NULL

----Count after filtering Saturdays and sundays
SELECT DISTINCT ss.SchoolYear
	,count(DISTINCT se.STUDENT_NUMBER) AS DistrictStudentId
FROM Main.WHPS_SAT_Source_Data ss
JOIN [Main].[WHPS_Students] se ON ss.STATE_STUDENT_ID = se.STATE_STUDENTNUMBER
	AND ss.schoolyear = se.schoolyear
WHERE ss.schoolyear = 2026
	AND DATENAME(WEEKDAY, convert(VARCHAR(10), cast(LATEST_SAT_DATE AS DATE), 101)) NOT IN ('Saturday', 'Sunday')
GROUP BY ss.schoolyear

----District Student Ids discarded after filtering Saturdays and sundays
SELECT DISTINCT ss.SchoolYear
	,se.STUDENT_NUMBER AS DistrictStudentId
FROM Main.WHPS_SAT_Source_Data ss
JOIN [Main].[WHPS_Students] se ON ss.STATE_STUDENT_ID = se.STATE_STUDENTNUMBER
	AND ss.schoolyear = se.schoolyear
WHERE ss.schoolyear = 2026

EXCEPT

SELECT DISTINCT ss.SchoolYear
	,se.STUDENT_NUMBER AS DistrictStudentId
FROM Main.WHPS_SAT_Source_Data ss
JOIN [Main].[WHPS_Students] se ON ss.STATE_STUDENT_ID = se.STATE_STUDENTNUMBER
	AND ss.schoolyear = se.schoolyear
WHERE ss.schoolyear = 2026
	AND DATENAME(WEEKDAY, convert(VARCHAR(10), cast(LATEST_SAT_DATE AS DATE), 101)) NOT IN ('Saturday', 'Sunday')

