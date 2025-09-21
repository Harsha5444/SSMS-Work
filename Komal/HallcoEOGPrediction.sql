WITH MAPBase AS (  ---38480
    SELECT [SchoolYear]
        ,[Districtstudentid]
        ,[SubjectAreaName]
        ,[RITScore(Fall)]
        ,[RITScore(Winter)]
        ,[RITScore(Spring)]
        ,[TestPercentile(Fall)]
        ,[TestPercentile(Winter)] 
        ,[TestPercentile(Spring)]
        ,TenantId
    FROM (        
       select 
        SchoolYear,
            StudentID as Districtstudentid,
            [Subject] as SubjectAreaName ,
            'RITScore(' + substring(Termname,1,charindex(' ',Termname)-1) + ')' as Termcode,
            TestRITScore as MetricValue,
            TenantId
        from main.Hallco_MAP_AssessmentResults
        where [Subject] = 'Mathematics' 

        union all

         select 
        SchoolYear,
            StudentID as Districtstudentid,
            [Subject] as SubjectAreaName ,
            'TestPercentile(' + substring(Termname,1,charindex(' ',Termname)-1) + ')' as Termcode,
            TestPercentile as MetricValue,
            TenantId
        from main.Hallco_MAP_AssessmentResults
        where [Subject] = 'Mathematics' 

        ) t
    PIVOT(MAX(MetricValue) FOR Termcode IN ( [RITScore(Fall)], [RITScore(Winter)], [RITScore(Spring)],[TestPercentile(Fall)], [TestPercentile(Winter)], [TestPercentile(Spring)])) u
),
EOGBase AS ( 
	SELECT SchoolYear
			,studentnumber as DistrictStudentId
			,'Math' as [SubjectAreaName]
			,Orders as ScaleScore
			,Tenantid
		FROM (
			SELECT TestAdmin
				,GTID_RPT
				,a.SchoolYear
				,s.studentnumber
				,SS_ELA
				,SS_Math
				,SS_Sci
				,SS_Soc
				,a.Tenantid
			FROM main.Hallco_EOG a
			INNER JOIN main.hallco_icstudents s ON a.tenantid = s.tenantid
				AND a.schoolyear = s.endyear
				AND a.gtid_rpt = s.stateID
				AND SchCode_RPT = schoolnumber
			WHERE s.servicetype = 'P'
			) p
		UNPIVOT(Orders FOR SubjectAreaCode IN (SS_ELA, SS_Math, SS_Sci, SS_Soc)) AS unpvt
		where SubjectAreaCode = 'SS_Math'
)
,DisciplineCounts AS (
    SELECT 
        SchoolYear,
        Districtstudentid,
        COUNT(Incidentnumber) TotalIncidents,
        TenantId
    FROM dbo.[DisciplineIncidentCountsDS] WITH (NOLOCK)
    GROUP BY schoolyear, districtstudentid, TenantId
)
,Base AS (
    SELECT
        agg.SchoolYear
        ,agg.Districtstudentid
        ,agg.StudentFullName as StudentFullName
        ,agg.GradeCode as  GradeCode
        ,agg.Presentrate as presentPercentage
        ,agg.IsChronic as ChronicallyAbsent
        ,agg.Race as Race
        ,agg.GenderCode as Gender
        ,agg.SpecialEdStatus as Disability
        ,'Free Lunch' as FRL 
        ,agg.TenantId
        ,a.[RITScore(Fall)] as [MAPRITScore(Fall)]
        ,a.[RITScore(Winter)] as [MAPRITScore(Winter)]
        ,a.[RITScore(Spring)] as [MAPRITScore(Spring)]
        ,a.[TestPercentile(Fall)]   [MAPTestPercentile(Fall)]
        ,a.[TestPercentile(Winter)] [MAPTestPercentile(Winter)]
        ,a.[TestPercentile(Spring)] [MAPTestPercentile(Spring)]
        ,t.ScaleScore as EOGScaleScore
        ,t.[SubjectAreaName]
        ,ISNULL(c.TotalIncidents, 0)  as TotalIncidents
    FROM Aggrptk12Studentdetails agg
    INNER JOIN EOGBase t ON agg.SchoolYear = t.SchoolYear AND agg.DistrictStudentId = t.DistrictStudentId and agg.TenantId = t.TenantId
    Inner JOIN MAPBase a ON a.DistrictStudentId = t.DistrictStudentId AND a.schoolyear = t.SchoolYear and a.TenantId = t.TenantId 
    LEFT JOIN DisciplineCounts c ON agg.SchoolYear = c.SchoolYear AND agg.DistrictStudentId = c.DistrictStudentId AND c.TenantId = agg.TenantId
)
SELECT 
    b.SchoolYear,
    b.DistrictStudentId,
    b.StudentFullName,
    b.GradeCode,
    b.[SubjectAreaName],
    b.[MAPRITScore(Fall)],
    b.[MAPRITScore(Winter)],
    b.[MAPRITScore(Spring)], 
    b.[MAPTestPercentile(Fall)],
    b.[MAPTestPercentile(Winter)],
    b.[MAPTestPercentile(Spring)],
    b.EOGScaleScore,
    b.presentPercentage,
    b.ChronicallyAbsent,
    b.Race,
    b.Gender,
    b.Disability,
    b.FRL,
    b.TotalIncidents
FROM Base b  
--WHERE EOGScaleScore is not null 
ORDER BY Schoolyear,GradeCode, Race, Gender;

