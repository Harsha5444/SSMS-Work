WITH Base
AS (
	SELECT a.SchoolYear
		,a.Districtstudentid
		,b.StudentFullName
		,ISNULL(a.GradeCode, 'Unknown') GradeCode
		,a.[RITScore(Fall)] [MAPRITScore(Fall)]
		,a.[RITScore(Winter)] [MAPRITScore(Winter)]
		,a.[RITScore(Spring)] [MAPRITScore(Spring)]
		,t.ScaleScore EOGScaleScore
		,ISNULL(b.presentPercentage, '0.0') presentPercentage
		,ISNULL(b.chronicallyAbsent, 'N') ChronicallyAbsent
		,CASE 
			WHEN b.raceEthnicity = 'White (W)'
				THEN 5
			WHEN b.raceEthnicity = 'Black/African American (B)'
				THEN 3
			WHEN b.raceEthnicity = 'Hispanic/Latino (H)'
				THEN 4
			WHEN b.raceEthnicity = 'Asian (A)'
				THEN 2
			WHEN b.raceEthnicity = 'More than one race indicated (M)'
				THEN 7
			WHEN b.raceEthnicity = 'Native Hawaiian/Pacific Islander (PI)'
				THEN 1
			WHEN b.raceEthnicity = 'American Indian/Alaska Native (AI)'
				THEN 6
			ELSE 8
			END Race
		,CASE 
			WHEN b.genderLong = 'Male (M)'
				THEN 1
			ELSE 0
			END Gender
		,CASE 
			WHEN b.swdindicator = 'Y'
				THEN 1
			ELSE 0
			END Disability
		,0 FRL
		,ISNULL(c.TotalIncidents, 0) TotalIncidents
	FROM (
		SELECT [SchoolYear]
			,[Districtstudentid]
			,[GradeCode]
			,[RITScore(Fall)]
			,[RITScore(Winter)]
			,[RITScore(Spring)]
		FROM (
			SELECT *
			FROM (
				SELECT h.SchoolYear
					,p.AssessmentCode
					,p.SubjectAreaCode
					,h.Districtstudentid
					,g.GradeCode
					,g.GradeDescription
					,'RITScore(' + k.Termcode + ')' Termcode
					,CAST(h.MetricValue AS INT) [RITScore]
					,ROW_NUMBER() OVER (
						PARTITION BY p.AssessmentCode
						,p.SubjectAreaCode
						,h.StudentCurrentGradeId
						,h.termid
						,h.Districtstudentid ORDER BY h.SchoolYear DESC
							,CAST(h.TestTakenDate AS DATE) DESC
						) AS RN
				FROM main.k12studentgenericassessment h
				INNER JOIN main.assessmentdetails p ON h.AssessmentCodeId = p.assessmentdetailsid
				INNER JOIN RefGrade g ON g.gradeid = h.StudentCurrentGradeId
				INNER JOIN refterm k ON h.termid = k.termid
				INNER JOIN refmetric o ON o.metricid = h.MetricCodeId
				WHERE AssessmentCodeId IN (
						SELECT assessmentdetailsid
						FROM main.assessmentdetails
						WHERE AssessmentCode LIKE '%MAP%'
							AND SubjectAreaCode LIKE '%math%'
							AND strandareacode IS NULL
						)
					AND MetricCodeId IN (select MetricId from refmetric where MetricCode = 'RITScore')
				) t
			WHERE RN = 1
			) o
		PIVOT(MAX(RITScore) FOR Termcode IN ([RITScore(Fall)], [RITScore(Winter)], [RITScore(Spring)])) u
		) a
	INNER JOIN (
		SELECT h.SchoolYear
			,h.Districtstudentid
			,CAST(h.MetricValue AS INT) [ScaleScore]
			,g.GradeCode
		FROM main.k12studentgenericassessment h
		INNER JOIN main.assessmentdetails p ON h.AssessmentCodeId = p.assessmentdetailsid
		INNER JOIN RefGrade g ON g.gradeid = h.StudentCurrentGradeId
		WHERE AssessmentCodeId IN (
				SELECT assessmentdetailsid
				FROM main.assessmentdetails
				WHERE AssessmentCode LIKE '%EOG%'
					AND SubjectAreaCode LIKE '%math%'
					AND strandareacode IS NULL
				)
			AND MetricCodeId IN (select MetricId from refmetric where MetricCode = '03479')
		) t ON a.SchoolYear = t.SchoolYear
		AND a.GradeCode = t.GradeCode
		AND a.DistrictStudentId = t.DistrictStudentId
	INNER JOIN (
		SELECT StudentFullName
			,studentnumber
			,endyear
			,ROUND(CAST(daysPresent AS FLOAT) * 100 / scheduledDays, 2) PresentPercentage
			,chronicallyAbsent
			,raceEthnicity
			,genderLong
			,swdindicator
		FROM (
			SELECT studentFullName
				,studentnumber
				,endyear
				,SUM(daysPresent) daysPresent
				,SUM(scheduledDays) scheduledDays
				,chronicallyAbsent
				,raceEthnicity
				,genderLong
				,swdindicator
				,ROW_NUMBER() OVER (
					PARTITION BY studentnumber
					,endYear ORDER BY daysPresent DESC
					) AS rn
			FROM [HCS_attendanceSummary_7YR]
			GROUP BY StudentFullName
				,studentnumber
				,endyear
				,chronicallyAbsent
				,daysPresent
				,raceEthnicity
				,genderLong
				,swdindicator
			) y
		WHERE rn = 1
			AND daysPresent <> 0
		) b ON a.DistrictStudentId = b.studentnumber
		AND a.schoolyear = b.endYear
	LEFT JOIN (
		SELECT EndYear
			,studentNumber
			,COUNT(incidentID) TotalIncidents
		FROM HCS_behavior_7YR
		GROUP BY EndYear
			,studentNumber
		) c ON a.SchoolYear = c.EndYear
		AND a.DistrictStudentId = c.studentnumber
	WHERE (
			(
				b.presentPercentage > 90
				AND chronicallyAbsent = 'N'
				)
			OR (
				b.presentPercentage <= 90
				AND chronicallyAbsent = 'Y'
				)
			)
	)
	,PrevYear
AS (
	SELECT SchoolYear + 1 AS SchoolYear -- shift forward for join
		,Districtstudentid
		,ISNULL([MAPRITScore(Fall)], 0) [MAPRITScore(Fall)_Previous]
		,ISNULL([MAPRITScore(Winter)], 0) [MAPRITScore(Winter)_Previous]
		,ISNULL([MAPRITScore(Spring)], 0) [MAPRITScore(Spring)_Previous]
		,ISNULL(EOGScaleScore, 0) [EOGScaleScore_Previous]
	FROM Base
	)
SELECT 
	b.SchoolYear,
    b.DistrictStudentId,
    b.StudentFullName,
    b.GradeCode,
    b.[MAPRITScore(Fall)],
    p.[MAPRITScore(Fall)_Previous],
    b.[MAPRITScore(Winter)],
    p.[MAPRITScore(Winter)_Previous],
    b.[MAPRITScore(Spring)],
    p.[MAPRITScore(Spring)_Previous],
    b.EOGScaleScore,
    p.[EOGScaleScore_Previous],
    b.presentPercentage,
    b.ChronicallyAbsent,
    b.Race,
    b.Gender,
    b.Disability,
    b.FRL,
    b.TotalIncidents into #temp_HCS_VAlidation
FROM Base b
LEFT JOIN PrevYear p ON b.SchoolYear = p.SchoolYear
	AND b.DistrictStudentId = p.DistrictStudentId
	--WHERE b.DistrictStudentId = '176736'


select distinct GradeCode,
[MAPRITScore(Fall)],
[MAPRITScore(Winter)],
[MAPRITScore(Spring)],
EOGScaleScore,
EOGScaleScore_Previous,
presentPercentage,
ChronicallyAbsent,
Race,
Gender,
Disability,
FRL,
TotalIncidents from #temp_HCS_VAlidation where EOGScaleScore <> EOGScaleScore_Previous
and [MAPRITScore(Fall)] is not null
and [MAPRITScore(Winter)] is not null
and [MAPRITScore(Spring)] is not null

 