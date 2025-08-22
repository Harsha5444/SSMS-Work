CREATE PROCEDURE [dbo].[USP_ClaytonStudents5YR_Loading] 
AS
BEGIN
	SET ANSI_NULLS ON;

	SET QUOTED_IDENTIFIER OFF;

	SET NOCOUNT ON;
	SET XACT_ABORT ON;

DROP TABLE [Clayton_Students_5YR];
CREATE TABLE [dbo].[Clayton_Students_5YR](
 [Clayton_Students_5YR_ID] INT IDENTITY(1,1) PRIMARY KEY
,[SchoolYear]              VARCHAR(150)
,[LEAIdentifier]		   VARCHAR(150)
,[PersonID]				   VARCHAR(150)
,[SchoolIdentifier]		   VARCHAR(150)
,[K12SchoolIdentifier]     VARCHAR(150)
,[SchoolName]			   VARCHAR(150)
,[K12SchoolName]		   VARCHAR(150)
,[EnrollmentID]			   VARCHAR(150)
,[StateStudentId]		   VARCHAR(150)
,[DistrictStudentId]	   VARCHAR(150)
,[FirstName]			   VARCHAR(150)
,[MiddleName]			   VARCHAR(150)
,[LastorSurname]		   VARCHAR(150)
,[StudentFullName]		   VARCHAR(150)
,[Grade]				   VARCHAR(150)
,[Gender]				   VARCHAR(150)
,[Race]					   VARCHAR(150)
,[BirthDate]			   VARCHAR(150)
,[Ethnicity]			   VARCHAR(150)
,[BirthCountry]			   VARCHAR(150)
,[BirthCity]			   VARCHAR(150)
,[BirthCounty]			   VARCHAR(150)
,[StartDate]			   VARCHAR(150)
,[StartStatus]			   VARCHAR(150)
,[EndDate]				   VARCHAR(150)
,[EndStatus]			   VARCHAR(150)
,[StartYear]			   VARCHAR(150)
,[Active]				   VARCHAR(150)
,[CohortYear]			   VARCHAR(150)
,[ServiceType]			   VARCHAR(150)
,[SpecialEducationStatus]  VARCHAR(150)
,[504Status]			   VARCHAR(150)
,[LEP]					   VARCHAR(150)
,[GAA]					   VARCHAR(150)
,[GiftedandTalented]	   VARCHAR(150)
,[Homeless]				   VARCHAR(150)
,[Migrant]				   VARCHAR(150)
,[EIP]					   VARCHAR(150)
,[REIP]					   VARCHAR(150)
,[IEP]					   VARCHAR(150)
,[Magnet]				   VARCHAR(150)
,[FRL]					   VARCHAR(150)
,[ELL]					   VARCHAR(150)
,[DisabilityDescription]   VARCHAR(150)
,[DisabilityStatus]		   VARCHAR(150)
,[EndYear]				   VARCHAR(150)
,[TenantId]				   VARCHAR(150)
,[CreatedDate]			   DATETIME DEFAULT GETDATE()
);

WITH IcStudents
AS (
	SELECT endYear ,districtID ,personID ,SchoolNumber ,enrollmentID ,stateID ,studentNumber ,lastName
		 ,firstName ,middleName ,gender ,dob ,raceEthnicity ,hispanicEthnicity ,birthCountry ,birthCity
		 ,birthCounty ,grade ,startDate ,startStatus ,endDate ,endStatus ,SchoolName ,startYear
		 ,active ,SpecialEdStatus ,disability1 ,cohortYear ,serviceType ,SchoolYear ,TenantId
	FROM (
		SELECT endYear ,districtID ,personID ,SchoolNumber ,enrollmentID ,stateID ,studentNumber
			 ,lastName ,firstName ,middleName ,gender ,dob ,raceEthnicity ,hispanicEthnicity
			 ,birthCountry ,birthCity ,birthCounty ,grade ,startDate ,startStatus ,endDate
			 ,endStatus ,SchoolName ,startYear ,active
			 ,IIF(specialEdStatus = 'Y', 'Yes', IIF(specialEdStatus = 'N', 'No', specialEdStatus)) AS SpecialEdStatus
			 ,disability1 ,cohortYear ,serviceType ,SchoolYear ,TenantId
			 ,ROW_NUMBER() OVER (
				PARTITION BY studentnumber
				,schoolyear ORDER BY startdate DESC
				) AS rno
		FROM main.clayton_analyticvue_icstudents WITH (NOLOCK)
		) a
	WHERE rno = 1
	)

INSERT INTO [Clayton_Students_5YR] 
(SchoolYear,LEAIdentifier,PersonID,SchoolIdentifier,K12SchoolIdentifier,SchoolName,K12SchoolName,EnrollmentID,StateStudentId,DistrictStudentId,FirstName,MiddleName,LastorSurname,StudentFullName
,Grade,Gender,Race,BirthDate,Ethnicity,BirthCountry,BirthCity,BirthCounty,StartDate,StartStatus,EndDate,EndStatus,StartYear,Active
,CohortYear,ServiceType,SpecialEducationStatus,[504Status],LEP,GAA,GiftedandTalented,Homeless,Migrant,EIP,REIP,IEP,Magnet
,FRL,ELL,DisabilityDescription,DisabilityStatus,EndYear,TenantId)

SELECT 
SchoolYear,LEAIdentifier,PersonID,SchoolIdentifier,K12SchoolIdentifier,SchoolName,K12SchoolName,EnrollmentID,StateStudentId,DistrictStudentId,FirstName,MiddleName,LastorSurname,StudentFullName
,Grade,Gender,Race,BirthDate,Ethnicity,BirthCountry,BirthCity,BirthCounty,StartDate,StartStatus,EndDate,EndStatus,StartYear,Active
,CohortYear,ServiceType,SpecialEducationStatus,[504Status],LEP,GAA,GiftedandTalented,Homeless,Migrant,EIP,REIP,IEP,Magnet
,FRL,ELL,DisabilityDescription,DisabilityStatus,EndYear,TenantId FROM (
SELECT distinct 
	ic.SchoolYear
	,ic.districtID AS LEAIdentifier
	,ic.personID AS PersonID
	,ic.Schoolnumber AS SchoolIdentifier
	,sc.SchoolIdentifier AS K12SchoolIdentifier
	,ic.Schoolname AS SchoolName
	,sc.NameofInstitution AS K12SchoolName
	,ic.enrollmentID AS EnrollmentID
	,ic.stateID AS StateStudentId
	,ic.studentNumber AS DistrictStudentId
	,ic.firstName AS FirstName
	,ic.middleName AS MiddleName
	,ic.lastName AS LastorSurname
	,CONCAT (ISNULL(ic.lastName, ''),', ',ISNULL(ic.firstName, ''),' ',ISNULL(ic.middleName, '')) AS StudentFullName
	,rg.GradeDescription AS Grade
	,CASE ic.gender	WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female'	ELSE ic.gender END AS Gender
	,ic.raceEthnicity AS Race
	,ic.dob AS BirthDate
	,IIF(ic.hispanicEthnicity = 'Y', 'Yes', IIF(ic.hispanicEthnicity = 'N', 'No', ic.hispanicEthnicity)) AS Ethnicity
	,ic.birthCountry AS BirthCountry
	,ic.birthCity AS BirthCity
	,ic.birthCounty AS BirthCounty
	,ic.startDate AS StartDate
	,ic.startStatus AS StartStatus
	,ic.endDate AS EndDate
	,ic.endStatus AS EndStatus
	,ic.startYear AS StartYear
	,ic.active AS Active
	,ic.cohortYear AS CohortYear
	,ic.serviceType AS ServiceType
	,COALESCE(ic.SpecialEdStatus, p.SpecialEdStatus) AS SpecialEducationStatus
	,p.[504Status]
	,p.[Limited English Proficient] AS LEP
	,p.GAA
	,p.GiftedandTalented
	,p.Homeless
	,p.Migrant
	,p.EIP
	,p.REIP
	,p.IEP
	,p.Magnet
	,p.FRL
	,p.ELL
	,ic.disability1 AS DisabilityDescription
	,IIF(ic.disability1 IS NOT NULL, 'Yes', p.Disability) AS DisabilityStatus
	,endYear AS EndYear
	,ic.TenantId 
FROM IcStudents ic
LEFT JOIN Clayton_StudentProgram p WITH (NOLOCK)
	ON ic.tenantid = p.tenantid
		AND ic.schoolyear = p.schoolyear
		AND ic.studentNumber = p.DistrictStudentId
		AND ic.schoolnumber = p.SchoolIdentifier
LEFT JOIN refgrade rg WITH (NOLOCK)
	ON rg.TenantId = ic.TenantId
		AND rg.GradeCode = ic.grade
LEFT JOIN main.k12school sc WITH (NOLOCK) 
	ON ic.schoolyear = sc.schoolyear
		AND ic.tenantid = sc.tenantid
		AND Case 
			when ic.schoolnumber = '6008' And ic.SchoolName Like '%High%' Then '0036008'
			when ic.schoolnumber = '6008' And ic.SchoolName Like '%Middle%' Then '0026008'
			when ic.schoolnumber = '6008' And ic.SchoolName Like '%Elem%' Then '0016008'
			when ic.schoolnumber = '6422' And ic.SchoolName Like '%High%' Then '0096422'
			when ic.schoolnumber = '6422' And ic.SchoolName Like '%Middle%' Then '0236422'
			when ic.schoolnumber = '6422' And ic.SchoolName Like '%Elem%' Then '1286422'
			when ic.schoolnumber = '6004' And ic.SchoolName Like '%High%' Then '0086004'
			when ic.schoolnumber = '6004' And ic.SchoolName Like '%Middle%' Then '0226004'
			when ic.schoolnumber = '0114' And ic.SchoolName = '24-25 Elite Scholars Middle' Then '0990114'
			Else ic.schoolnumber End = sc.SchoolIdentifier
) a ORDER BY SchoolYear, SchoolIdentifier,  DistrictStudentId;

CREATE NONCLUSTERED INDEX IX_Clayton_Students_5YR_Search ON dbo.Clayton_Students_5YR (
    SchoolYear, SchoolIdentifier, DistrictStudentId, Grade, Gender, TenantId
) INCLUDE (
    SpecialEducationStatus, [504Status], LEP, GAA, GiftedandTalented, Homeless, Migrant, 
    EIP, REIP, IEP, Magnet, FRL, ELL, DisabilityStatus
);

