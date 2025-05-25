ALTER PROCEDURE [dbo].[USP_ClaytonStudents5YR_Loading]
AS
BEGIN
	SET ANSI_NULLS ON;
	SET QUOTED_IDENTIFIER OFF;
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	BEGIN TRY
		DECLARE @StartTime DATETIME2;
		DECLARE @EndTime DATETIME2;
		DECLARE @TotalRowsInserted INT = 0;
		DECLARE @TableRowsBefore INT;
		DECLARE @TableRowsAfter INT;
		DECLARE @ProcessName NVARCHAR(150) = '[Clayton_Students_5YR]'

		SET @StartTime = CAST(SYSDATETIME() AS DATETIME);

		SELECT @TableRowsBefore = COUNT(*)
		FROM [Clayton_Students_5YR]

		BEGIN TRANSACTION

		DECLARE @TemplateLatestYear INT

		SET @TemplateLatestYear = (
				SELECT TOP 1 Schoolyear
				FROM [Main].[Clayton_Analyticvue_ICStudents]
				WHERE Tenantid = 50
				ORDER BY Schoolyear DESC
				)

		EXEC [dbo].[USP_DisableAllIndexes] 'Clayton_Students_5YR'

		DELETE
		FROM [Clayton_Students_5YR]
		WHERE SchoolYear = @TemplateLatestYear

		--CREATE TABLE [dbo].[Clayton_Students_5YR] (
		--	[Clayton_Students_5YR_ID] INT IDENTITY(1, 1) PRIMARY KEY
		--	,[SchoolYear] VARCHAR(150)
		--	,[LEAIdentifier] VARCHAR(150)
		--	,[PersonID] VARCHAR(150)
		--	,[SchoolIdentifier] VARCHAR(150)
		--	,[ICSchoolIdentifier] VARCHAR(150)
		--	,[SchoolName] VARCHAR(150)
		--	,[ICSchoolName] VARCHAR(150)
		--  ,[SchoolCategory] VARCHAR(150)
		--	,[EnrollmentID] VARCHAR(150)
		--	,[StateStudentId] VARCHAR(150)
		--	,[DistrictStudentId] VARCHAR(150)
		--	,[FirstName] VARCHAR(150)
		--	,[MiddleName] VARCHAR(150)
		--	,[LastorSurname] VARCHAR(150)
		--	,[StudentFullName] VARCHAR(150)
		--	,[Grade] VARCHAR(150)
		--	,[Gender] VARCHAR(150)
		--	,[Race] VARCHAR(150)
		--	,[BirthDate] VARCHAR(150)
		--	,[Ethnicity] VARCHAR(150)
		--	,[BirthCountry] VARCHAR(150)
		--	,[BirthCity] VARCHAR(150)
		--	,[BirthCounty] VARCHAR(150)
		--	,[StartDate] VARCHAR(150)
		--	,[StartStatus] VARCHAR(150)
		--	,[EndDate] VARCHAR(150)
		--	,[EndStatus] VARCHAR(150)
		--	,[StartYear] VARCHAR(150)
		--	,[Active] VARCHAR(150)
		--	,[CohortYear] VARCHAR(150)
		--	,[ServiceType] VARCHAR(150)
		--	,[SpecialEdStatus] VARCHAR(150)
		--	,[504Status] VARCHAR(150)
		--	,[LEP] VARCHAR(150)
		--	,[GAA] VARCHAR(150)
		--	,[GiftedandTalented] VARCHAR(150)
		--	,[Homeless] VARCHAR(150)
		--	,[Migrant] VARCHAR(150)
		--	,[EIP] VARCHAR(150)
		--	,[REIP] VARCHAR(150)
		--	,[IEP] VARCHAR(150)
		--	,[Magnet] VARCHAR(150)
		--	,[FRL] VARCHAR(150)
		--	,[ELL] VARCHAR(150)
		--	,[DisabilityDescription] VARCHAR(150)
		--	,[Disability] VARCHAR(150)
		--	,[EndYear] VARCHAR(150)
		--	,[TenantId] INT
		--	,[CreatedDate] DATETIME DEFAULT GETDATE()
		--	CONSTRAINT [FK_Clayton_Students_5YR_Tenant] FOREIGN KEY ([TenantId]) REFERENCES [IDM].[Tenant]([TenantId])
		--	) ON [PRIMARY]

		--CREATE NONCLUSTERED INDEX IX_Clayton_Students_5YR_Search ON dbo.Clayton_Students_5YR 
		--( SchoolYear, SchoolIdentifier, DistrictStudentId, Grade, Gender, TenantId) 
		--INCLUDE 
		--(SpecialEdStatus, [504Status], LEP, GAA, GiftedandTalented, Homeless, Migrant, EIP, REIP, IEP, Magnet, FRL, ELL, Disability);

		INSERT INTO [Clayton_Students_5YR] (
			SchoolYear
			,LEAIdentifier
			,PersonID
			,SchoolIdentifier
			,ICSchoolIdentifier
			,SchoolName
			,ICSchoolName
			,SchoolCategory
			,EnrollmentID
			,StateStudentId
			,DistrictStudentId
			,FirstName
			,MiddleName
			,LastorSurname
			,StudentFullName
			,Grade
			,Gender
			,Race
			,BirthDate
			,Ethnicity
			,BirthCountry
			,BirthCity
			,BirthCounty
			,StartDate
			,StartStatus
			,EndDate
			,EndStatus
			,StartYear
			,Active
			,CohortYear
			,ServiceType
			,SpecialEdStatus
			,[504Status]
			,LEP
			,GAA
			,GiftedandTalented
			,Homeless
			,Migrant
			,EIP
			,REIP
			,IEP
			,Magnet
			,FRL
			,ELL
			,DisabilityDescription
			,Disability
			,EndYear
			,TenantId
			)
		SELECT DISTINCT ic.SchoolYear
			,ic.districtID AS LEAIdentifier
			,ic.personID AS PersonID
			,sc.SchoolIdentifier AS SchoolIdentifier
			,ic.Schoolnumber AS ICSchoolIdentifier
			,sc.NameofInstitution AS SchoolName
			,ic.Schoolname AS ICSchoolName
			,cat.SchoolCategoryCode AS SchoolCategory
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
			,COALESCE(IIF(ic.specialEdStatus = 'Y', 'Yes', IIF(ic.specialEdStatus = 'N', 'No', ic.specialEdStatus)), p.SpecialEdStatus) AS SpecialEdStatus
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
			,IIF(ic.disability1 IS NOT NULL, 'Yes', p.Disability) AS Disability
			,ic.endYear AS EndYear
			,CAST(ic.TenantId as INT) AS TenantId
		FROM (
			SELECT *, ROW_NUMBER() OVER (PARTITION BY studentnumber, schoolyear ORDER BY startdate DESC) AS rno
			FROM main.clayton_analyticvue_icstudents WITH (NOLOCK)
			) ic
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
				AND CASE 
					WHEN ic.schoolnumber = '6008' AND ic.SchoolName LIKE '%High%' THEN '0036008'
					WHEN ic.schoolnumber = '6008' AND ic.SchoolName LIKE '%Middle%' THEN '0026008'
					WHEN ic.schoolnumber = '6008' AND ic.SchoolName LIKE '%Elem%' THEN '0016008'
					WHEN ic.schoolnumber = '6422' AND ic.SchoolName LIKE '%High%' THEN '0096422'
					WHEN ic.schoolnumber = '6422' AND ic.SchoolName LIKE '%Middle%' THEN '0236422'
					WHEN ic.schoolnumber = '6422' AND ic.SchoolName LIKE '%Elem%' THEN '1286422'
					WHEN ic.schoolnumber = '6004' AND ic.SchoolName LIKE '%High%' THEN '0086004'
					WHEN ic.schoolnumber = '6004' AND ic.SchoolName LIKE '%Middle%' THEN '0226004'
					WHEN ic.schoolnumber = '0114' AND ic.SchoolName = '24-25 Elite Scholars Middle' THEN '0990114'
					ELSE ic.schoolnumber
				END = sc.SchoolIdentifier
		 LEFT JOIN refschoolcategory cat WITH (NOLOCK)
			ON sc.SchoolCategoryId = cat.SchoolCategoryId
		WHERE ic.rno = 1
			AND ic.schoolyear = @TemplateLatestYear
		ORDER BY ic.schoolyear,ic.Schoolnumber,ic.studentNumber;

		SET @TotalRowsInserted = @@ROWCOUNT;

		EXEC [dbo].[USP_EnableAllIndexes] 'Clayton_Students_5YR'

		UPDATE STATISTICS [AnalyticVue_Clayton].[dbo].[Clayton_Students_5YR]

		SELECT @TableRowsAfter = COUNT(*)
		FROM [Clayton_Students_5YR]

		SET @EndTime = CAST(SYSDATETIME() AS DATETIME)

		DECLARE @ElapsedTime INT = DATEDIFF(MILLISECOND, @StartTime, @EndTime);

		INSERT INTO [dbo].[Clayton_ProcessLogStatistics] (
			[ProcessName]
			,[TableRowsBefore]
			,[TotalRowsInserted]
			,[TableRowsAfter]
			,[StartTime]
			,[EndTime]
			,[ElapsedTime]
			,[TotalExecutionTime]
			,[EstimatedCPUtime]
			,[EstimatedI/O]
			,[TenantId]
			)
		SELECT @ProcessName
			,@TableRowsBefore
			,@TotalRowsInserted
			,@TableRowsAfter
			,@StartTime
			,@EndTime
			,@ElapsedTime
			,CAST(@ElapsedTime / 1000 AS VARCHAR(10)) + ' seconds ' + CAST(@ElapsedTime % 1000 AS VARCHAR(10)) + ' milliseconds'
			,CAST(@@CPU_BUSY AS VARCHAR(20)) + ' milliseconds'
			,CAST(@@IO_BUSY AS VARCHAR(20)) + ' milliseconds'
			,50

		COMMIT TRAN
	END TRY

	BEGIN CATCH
		IF XACT_STATE() = - 1
		BEGIN
			ROLLBACK TRAN
		END
		
		DECLARE @ErrorFromProc VARCHAR(500)
		DECLARE @ProcErrorMessage VARCHAR(1000)
		DECLARE @SeverityLevel INT

		SELECT @ErrorFromProc = '[dbo].[USP_ClaytonStudents5YR_Loading]'
			,@ProcErrorMessage = Error_message() + ' ; Error Number: ' + CAST(ERROR_NUMBER() AS VARCHAR(10)) + ' ; Error State: ' + CAST(ERROR_STATE() AS VARCHAR(10)) + ' ; Error Line: ' + CAST(ERROR_LINE() AS VARCHAR(10))
			,@SeverityLevel = Error_severity()

		INSERT INTO [dbo].[errorlogforusp] (
			ErrorFromProc
			,errormessage
			,severitylevel
			,datetimestamp
			)
		VALUES (
			@ErrorFromProc
			,@ProcErrorMessage
			,@SeverityLevel
			,Getdate()
			)
	END CATCH
END
GO


