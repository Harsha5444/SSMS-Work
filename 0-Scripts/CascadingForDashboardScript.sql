ALTER PROCEDURE [dbo].[USP_GetDashboardSubgroupChildElements] (
	@optionflag VARCHAR(200)
	,@Tenantid INT
	,@SchoolYear VARCHAR(100) = NULL
	,@Schoolids VARCHAR(Max) = NULL
	,@dashboardId INT = NULL
	,@parentSelections NVARCHAR(max) = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	IF OBJECT_ID('tempdb..#ParentSelectionstbl') IS NOT NULL
		DROP TABLE #ParentSelectionstbl;

	IF OBJECT_ID('tempdb..#OptionFlagDetails') IS NOT NULL
		DROP TABLE #OptionFlagDetails;

	IF OBJECT_ID('tempdb..#OptionFlagDependencies') IS NOT NULL
		DROP TABLE #OptionFlagDependencies;

	BEGIN TRY
		CREATE TABLE #ParentSelectionstbl (
			FilterCode NVARCHAR(50)
			,FilterValue NVARCHAR(200)
			);

		INSERT INTO #ParentSelectionstbl
		SELECT LTRIM(RTRIM(SUBSTRING(s.value, 1, CHARINDEX('=', s.value) - 1))) AS FilterCode
			,LTRIM(RTRIM(v.value)) AS FilterValue
		FROM STRING_SPLIT(@parentSelections, ';') s
		CROSS APPLY STRING_SPLIT(SUBSTRING(s.value, CHARINDEX('=', s.value) + 1, LEN(s.value)), ',') v
		WHERE s.value IS NOT NULL
			AND s.value != ''
			AND CHARINDEX('=', s.value) > 0
			AND v.value IS NOT NULL
			AND v.value != '';

		CREATE TABLE #OptionFlagDetails (
			OptionFlagID INT
			,OptionFlagName VARCHAR(100)
			,OptionFlagCode VARCHAR(50)
			)

		INSERT INTO #OptionFlagDetails
		SELECT StudentsSubgroupId
			,SubgroupName
			,Code
		FROM idm.StudentsSubgroup
		WHERE TenantId = @Tenantid
			AND Code = @optionflag;

		CREATE TABLE #OptionFlagDependencies (
			DependentField INT
			,DependentFieldName VARCHAR(100)
			,DependentFieldCode VARCHAR(50)
			)

		INSERT INTO #OptionFlagDependencies
		SELECT DISTINCT CAST(LTRIM(RTRIM(df.clean_value)) AS INT) AS DependentField
			,S.SubgroupName AS DependentFieldName
			,S.Code AS DependentFieldCode
		FROM DashboardSubGroups D
		CROSS APPLY (
			SELECT LTRIM(RTRIM(value)) AS clean_value
			FROM STRING_SPLIT(D.DependentField, ',')
			WHERE LTRIM(RTRIM(value)) != ''
			) df
		INNER JOIN idm.StudentsSubgroup S ON D.TenantId = S.TenantId
			AND S.StudentsSubgroupId = CAST(df.clean_value AS INT)
		WHERE D.TenantId = @TenantId
			AND D.DashboardId = @DashboardId
			AND D.StudentsSubgroupId IN (
				SELECT OptionFlagID
				FROM #OptionFlagDetails
				);

		DECLARE @SCHOOLIDSTBL TABLE (VALUE INT)

		INSERT INTO @SCHOOLIDSTBL
		SELECT Value
		FROM string_split(@Schoolyear, ',')

		DECLARE @LatestAggYear VARCHAR(20)

		SELECT TOP 1 @LatestAggYear = SchoolYear
		FROM AggRptK12StudentDetails
		WHERE TenantId = @Tenantid
		ORDER BY SchoolYear DESC

		IF (
				@optionflag = 'G'
				OR @optionflag = 'S'
				OR @optionflag = 'MA'
				OR @optionflag = 'SC'
				OR @optionflag = 'TR'
				OR @optionflag = 'H'
				OR @optionflag = 'ELLP'
				)
		BEGIN
			SELECT Isnull([Value], 'Others') AS [Value]
			FROM (
				SELECT DISTINCT CASE 
						WHEN @optionflag = 'S'
							THEN ds.Gender
						WHEN @optionflag = 'G'
							THEN ds.Grade
						WHEN @optionflag = 'MA'
							THEN ISNULL(ds.MilitaryAffiliated, 'Unknown')
						WHEN @optionflag = 'TR'
							THEN ds.Tribal
						WHEN @optionflag = 'ELLP'
							THEN ds.EllProgram
						WHEN @optionflag = 'SC'
							THEN ds.SchoolCategory
						WHEN @optionflag = 'H'
							THEN ds.Homeless
						END AS [Value]
					,ds.Tenantid
				FROM AggRptK12StudentDetails ds(NOLOCK)
				WHERE ds.tenantid = @tenantid
					AND (
						@Schoolyear IS NULL
						OR ds.schoolyear IN (
							SELECT VALUE
							FROM @SCHOOLIDSTBL
							)
						)
					AND (
						NOT EXISTS ( 
							SELECT 1 FROM #OptionFlagDependencies 
							WHERE DependentFieldCode IN (SELECT FilterCode FROM #ParentSelectionstbl)
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'O')
							AND REPLACE(TRIM(ds.SchoolName), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'O')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'D')
							AND REPLACE(TRIM(ds.LEAName), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'D')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'S')
							AND REPLACE(TRIM(ds.Gender), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'S')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'G')
							AND REPLACE(TRIM(ds.Grade), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'G')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'MA')
							AND REPLACE(TRIM(ds.MilitaryAffiliated), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'MA')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'M')
							AND REPLACE(TRIM(ds.Migrant), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'M')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'GT')
							AND REPLACE(TRIM(ds.GiftedandTalented), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'GT')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'RE')
							AND REPLACE(TRIM(ds.Race), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'RE')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'T')
							AND REPLACE(TRIM(ds.Truant), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'T')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'TR')
							AND REPLACE(TRIM(ds.Tribal), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'TR')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'SC')
							AND REPLACE(TRIM(ds.SchoolCategory), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'SC')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'ELL')
							AND REPLACE(TRIM(ds.ELL), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'ELL')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'FRL')
							AND REPLACE(TRIM(ds.FRL), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'FRL')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = '504')
							AND REPLACE(TRIM(ds.[504Status]), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = '504')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'SPED')
							AND REPLACE(TRIM(ds.SpecialEdStatus), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'SPED')
						)
					)
				) a
			LEFT JOIN dbo.RefGrade rgr ON a.[Value] = rgr.GradeDescription
				AND rgr.TenantId = a.TenantId
			LEFT JOIN dbo.RefGender rg ON a.[Value] = rg.GenderDescription
				AND rg.TenantId = a.TenantId
			LEFT JOIN dbo.RefMilitaryConnectedStudentIndicator mcs ON a.[Value] = mcs.MilitaryConnectedStudentIndicatorDescription
				AND a.TenantId = mcs.TenantId
			LEFT JOIN dbo.RefTribalAffiliation rtr ON rtr.TribalAffiliationDescription = a.[Value]
				AND rtr.TenantId = a.TenantId
			LEFT JOIN dbo.RefSchoolCategory sc ON a.[Value] = sc.SchoolCategoryDescription
				AND a.TenantId = sc.TenantId
			ORDER BY rgr.SortOrder ASC
				,rg.SortOrder ASC
				,mcs.SortOrder ASC
				,rtr.SortOrder ASC
				,sc.SortOrder ASC
		END
		ELSE IF (@optionflag = 'SY')
		BEGIN
			SELECT TOP 5 [Value]
			FROM (
				SELECT DISTINCT YearCode AS [Value]
				FROM RefYear
				WHERE TenantId = @Tenantid
				) SUB
			ORDER BY [Value] DESC
		END
		ELSE IF (@optionflag = 'Term')
		BEGIN
			SELECT [Value]
			FROM (
				SELECT DISTINCT TermCode AS [Value]
				FROM RefTerm
				WHERE TenantId = @Tenantid
					AND TermCode IN ('Fall', 'Spring', 'Summer', 'Winter')
				) SUB
			ORDER BY [Value]
		END
		ELSE IF (@optionflag = 'EIP')
		BEGIN
			SELECT 'Yes' [Value]
			
			UNION ALL
			
			SELECT 'No' [Value]
		END
		ELSE IF (@optionflag = 'TCHR')
		BEGIN
			SELECT [Value]
			FROM (
				SELECT DISTINCT TeacherFullName + ' (' + DistrictStaffId + ')' AS [Value]
				FROM AggStaffFilters
				WHERE TeachingAssignmentRole = 'Teacher'
					AND TenantId = @Tenantid
					AND (
						@Schoolyear IS NULL
						OR schoolyear IN (
							SELECT VALUE
							FROM @SCHOOLIDSTBL
							)
						)
				) SUB
			ORDER BY [Value]
		END
		ELSE IF (@optionflag = 'Cohort')
		BEGIN
			SELECT DISTINCT CohortTitle AS [Value]
			FROM AggRptCohortStudentList
			WHERE TenantId = @Tenantid
			ORDER BY CohortTitle
		END
		ELSE IF (@optionflag = 'SpedP')
		BEGIN
			DECLARE @SQL NVARCHAR(1000)
				,@LatestYear VARCHAR(20)

			SELECT @LatestYear = max(SchoolYear)
			FROM DomainReportFilters
			WHERE TenantId = @Tenantid
				AND DataDomainCode = 'SENRL'

			SET @SQL = 'SELECT DISTINCT Sped_program as [Value] FROM [FPSEnrollmentDS] where TenantId=' + Cast(@Tenantid AS VARCHAR(20)) + '
					AND SchoolYear=' + @LatestYear + ' and Sped_program is not null ORDER BY Sped_program'

			EXEC (@SQL)
		END
		ELSE IF (@optionflag = 'Pathway')
		BEGIN
			SELECT DISTINCT ds.team AS [Value]
			FROM AggRptK12StudentDetails ds
			WHERE ds.TenantId = @Tenantid
				AND ds.SchoolYear = @LatestAggYear
				AND (
						NOT EXISTS ( 
							SELECT 1 FROM #OptionFlagDependencies 
							WHERE DependentFieldCode IN (SELECT FilterCode FROM #ParentSelectionstbl)
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'O')
							AND REPLACE(TRIM(ds.SchoolName), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'O')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'D')
							AND REPLACE(TRIM(ds.LEAName), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'D')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'S')
							AND REPLACE(TRIM(ds.Gender), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'S')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'G')
							AND REPLACE(TRIM(ds.Grade), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'G')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'MA')
							AND REPLACE(TRIM(ds.MilitaryAffiliated), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'MA')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'M')
							AND REPLACE(TRIM(ds.Migrant), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'M')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'GT')
							AND REPLACE(TRIM(ds.GiftedandTalented), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'GT')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'RE')
							AND REPLACE(TRIM(ds.Race), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'RE')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'T')
							AND REPLACE(TRIM(ds.Truant), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'T')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'TR')
							AND REPLACE(TRIM(ds.Tribal), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'TR')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'SC')
							AND REPLACE(TRIM(ds.SchoolCategory), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'SC')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'ELL')
							AND REPLACE(TRIM(ds.ELL), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'ELL')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'FRL')
							AND REPLACE(TRIM(ds.FRL), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'FRL')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = '504')
							AND REPLACE(TRIM(ds.[504Status]), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = '504')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'SPED')
							AND REPLACE(TRIM(ds.SpecialEdStatus), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'SPED')
						)
					)
			ORDER BY ds.team
		END
		ELSE IF (@optionflag = 'Homeless')
		BEGIN
			SELECT DISTINCT ds.Homeless AS [Value]
			FROM AggRptK12StudentDetails ds
			WHERE ds.TenantId = @Tenantid
				AND ds.SchoolYear = @LatestAggYear
				AND (
						NOT EXISTS ( 
							SELECT 1 FROM #OptionFlagDependencies 
							WHERE DependentFieldCode IN (SELECT FilterCode FROM #ParentSelectionstbl)
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'O')
							AND REPLACE(TRIM(ds.SchoolName), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'O')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'D')
							AND REPLACE(TRIM(ds.LEAName), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'D')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'S')
							AND REPLACE(TRIM(ds.Gender), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'S')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'G')
							AND REPLACE(TRIM(ds.Grade), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'G')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'MA')
							AND REPLACE(TRIM(ds.MilitaryAffiliated), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'MA')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'M')
							AND REPLACE(TRIM(ds.Migrant), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'M')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'GT')
							AND REPLACE(TRIM(ds.GiftedandTalented), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'GT')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'RE')
							AND REPLACE(TRIM(ds.Race), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'RE')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'T')
							AND REPLACE(TRIM(ds.Truant), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'T')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'TR')
							AND REPLACE(TRIM(ds.Tribal), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'TR')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'SC')
							AND REPLACE(TRIM(ds.SchoolCategory), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'SC')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'ELL')
							AND REPLACE(TRIM(ds.ELL), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'ELL')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'FRL')
							AND REPLACE(TRIM(ds.FRL), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'FRL')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = '504')
							AND REPLACE(TRIM(ds.[504Status]), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = '504')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'SPED')
							AND REPLACE(TRIM(ds.SpecialEdStatus), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'SPED')
						)
					)
			ORDER BY ds.Homeless
		END
		ELSE IF (@optionflag = 'DS')
		BEGIN
			SELECT DISTINCT ds.DisabilityReason AS [Value]
			FROM AggRptK12StudentDetails ds
			WHERE ds.TenantId = @Tenantid
				AND ds.SchoolYear = @LatestAggYear
				AND ds.DisabilityReason IS NOT NULL
				AND (
						NOT EXISTS ( 
							SELECT 1 FROM #OptionFlagDependencies 
							WHERE DependentFieldCode IN (SELECT FilterCode FROM #ParentSelectionstbl)
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'O')
							AND REPLACE(TRIM(ds.SchoolName), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'O')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'D')
							AND REPLACE(TRIM(ds.LEAName), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'D')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'S')
							AND REPLACE(TRIM(ds.Gender), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'S')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'G')
							AND REPLACE(TRIM(ds.Grade), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'G')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'MA')
							AND REPLACE(TRIM(ds.MilitaryAffiliated), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'MA')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'M')
							AND REPLACE(TRIM(ds.Migrant), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'M')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'GT')
							AND REPLACE(TRIM(ds.GiftedandTalented), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'GT')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'RE')
							AND REPLACE(TRIM(ds.Race), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'RE')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'T')
							AND REPLACE(TRIM(ds.Truant), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'T')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'TR')
							AND REPLACE(TRIM(ds.Tribal), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'TR')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'SC')
							AND REPLACE(TRIM(ds.SchoolCategory), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'SC')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'ELL')
							AND REPLACE(TRIM(ds.ELL), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'ELL')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'FRL')
							AND REPLACE(TRIM(ds.FRL), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'FRL')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = '504')
							AND REPLACE(TRIM(ds.[504Status]), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = '504')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'SPED')
							AND REPLACE(TRIM(ds.SpecialEdStatus), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'SPED')
						)
					)
			ORDER BY ds.DisabilityReason
		END
		ELSE IF (@optionflag = 'ETD')
		BEGIN
			SELECT DISTINCT CASE 
					WHEN cast(Ethnicity AS INT) = '1'
						THEN 'White'
					WHEN cast(Ethnicity AS INT) = '2'
						THEN 'Black'
					WHEN cast(Ethnicity AS INT) = '3'
						THEN 'Asian'
					WHEN cast(Ethnicity AS INT) = '4'
						THEN 'American or Alaska Native'
					WHEN cast(Ethnicity AS INT) = '5'
						THEN 'Native Hawaiian or Other Pacific Islander'
					WHEN cast(Ethnicity AS INT) BETWEEN '6'
							AND '31'
						THEN 'Mixed Ethnicity'
					WHEN Ethnicity >= 33
						THEN 'Hispanic'
					END AS [Value]
			FROM AggRptK12StudentDetails ds
			WHERE ds.TenantId = @Tenantid
				AND ds.SchoolYear = @LatestAggYear
				AND ds.Ethnicity IS NOT NULL
				AND (
						NOT EXISTS ( 
							SELECT 1 FROM #OptionFlagDependencies 
							WHERE DependentFieldCode IN (SELECT FilterCode FROM #ParentSelectionstbl)
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'O')
							AND REPLACE(TRIM(ds.SchoolName), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'O')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'D')
							AND REPLACE(TRIM(ds.LEAName), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'D')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'S')
							AND REPLACE(TRIM(ds.Gender), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'S')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'G')
							AND REPLACE(TRIM(ds.Grade), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'G')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'MA')
							AND REPLACE(TRIM(ds.MilitaryAffiliated), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'MA')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'M')
							AND REPLACE(TRIM(ds.Migrant), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'M')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'GT')
							AND REPLACE(TRIM(ds.GiftedandTalented), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'GT')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'RE')
							AND REPLACE(TRIM(ds.Race), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'RE')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'T')
							AND REPLACE(TRIM(ds.Truant), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'T')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'TR')
							AND REPLACE(TRIM(ds.Tribal), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'TR')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'SC')
							AND REPLACE(TRIM(ds.SchoolCategory), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'SC')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'ELL')
							AND REPLACE(TRIM(ds.ELL), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'ELL')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'FRL')
							AND REPLACE(TRIM(ds.FRL), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'FRL')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = '504')
							AND REPLACE(TRIM(ds.[504Status]), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = '504')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'SPED')
							AND REPLACE(TRIM(ds.SpecialEdStatus), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'SPED')
						)
					)
			ORDER BY Value
		END
		ELSE IF (@optionflag = 'IEP')
		BEGIN
			DECLARE @SQL3 NVARCHAR(1000)
				,@LatestYear3 VARCHAR(20)

			SELECT TOP 1 @LatestYear3 = ds.SchoolYear
			FROM AggRptK12StudentDetails ds
			WHERE ds.TenantId = @Tenantid
			AND (
						NOT EXISTS ( 
							SELECT 1 FROM #OptionFlagDependencies 
							WHERE DependentFieldCode IN (SELECT FilterCode FROM #ParentSelectionstbl)
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'O')
							AND REPLACE(TRIM(ds.SchoolName), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'O')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'D')
							AND REPLACE(TRIM(ds.LEAName), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'D')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'S')
							AND REPLACE(TRIM(ds.Gender), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'S')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'G')
							AND REPLACE(TRIM(ds.Grade), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'G')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'MA')
							AND REPLACE(TRIM(ds.MilitaryAffiliated), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'MA')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'M')
							AND REPLACE(TRIM(ds.Migrant), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'M')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'GT')
							AND REPLACE(TRIM(ds.GiftedandTalented), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'GT')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'RE')
							AND REPLACE(TRIM(ds.Race), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'RE')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'T')
							AND REPLACE(TRIM(ds.Truant), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'T')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'TR')
							AND REPLACE(TRIM(ds.Tribal), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'TR')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'SC')
							AND REPLACE(TRIM(ds.SchoolCategory), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'SC')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'ELL')
							AND REPLACE(TRIM(ds.ELL), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'ELL')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'FRL')
							AND REPLACE(TRIM(ds.FRL), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'FRL')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = '504')
							AND REPLACE(TRIM(ds.[504Status]), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = '504')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'SPED')
							AND REPLACE(TRIM(ds.SpecialEdStatus), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'SPED')
						)
					)
			ORDER BY ds.SchoolYear DESC

			SET @SQL3 = 'SELECT DISTINCT case when IEP is null then ''No'' else IEP end as [Value] FROM AggRptK12StudentDetails where TenantId=' + Cast(@Tenantid AS VARCHAR(20)) + '
					AND SchoolYear=' + @LatestYear3 + ' ORDER BY [Value]'

			EXEC (@SQL3)
		END
		ELSE IF (@optionflag = 'Magnet')
		BEGIN
			SELECT 'Program Within School' AS Value
			
			UNION
			
			SELECT 'Neighborhood Magnet School' AS Value
			
			UNION
			
			SELECT 'School-Wide Magnet' AS Value
		END
		ELSE
		BEGIN
			SELECT Isnull([Value], 'Others') AS [Value]
			FROM (
				SELECT DISTINCT CASE 
						WHEN @optionflag = 'GT'
							THEN ds.GiftedandTalented
						WHEN @optionflag = 'M'
							THEN ds.Migrant
						WHEN @optionflag = 'T'
							THEN ISNULL(ds.Truant, 'No')
						WHEN @optionflag = 'O'
							THEN ds.SchoolName
						WHEN @optionflag = 'D'
							THEN ds.LeaName
						WHEN @optionflag = 'RE'
							THEN rd.race
						WHEN @optionflag = 'ELLP'
							THEN ds.EllProgram
						WHEN @optionflag = 'ELL'
							THEN ISNULL(ds.ELL, 'UnKnown')
						WHEN @optionflag = 'FRL'
							THEN FRL
						WHEN @optionflag = '504'
							THEN [504Status]
						WHEN @optionflag = 'SPED'
							THEN [SpecialEdStatus]
						END AS [Value]
					,ds.Tenantid
				FROM AggRptK12StudentDetails ds(NOLOCK)
				INNER JOIN AggK12studentRaceDetails rd(NOLOCK) ON rd.DistrictStudentId = ds.DistrictStudentId
					AND rd.SchoolYear = ds.SchoolYear
					AND rd.LEAIdentifier = ds.LEAIdentifier
					AND rd.SchoolIdentifier = ds.SchoolIdentifier
					AND rd.TenantId = ds.TenantId
				WHERE ds.tenantid = @tenantid
					AND (
						@Schoolyear IS NULL
						OR ds.schoolyear IN (
							SELECT VALUE
							FROM @SCHOOLIDSTBL
							)
						)
					AND (
						NOT EXISTS ( 
							SELECT 1 FROM #OptionFlagDependencies 
							WHERE DependentFieldCode IN (SELECT FilterCode FROM #ParentSelectionstbl)
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'O')
							AND REPLACE(TRIM(ds.SchoolName), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'O')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'D')
							AND REPLACE(TRIM(ds.LEAName), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'D')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'S')
							AND REPLACE(TRIM(ds.Gender), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'S')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'G')
							AND REPLACE(TRIM(ds.Grade), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'G')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'MA')
							AND REPLACE(TRIM(ds.MilitaryAffiliated), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'MA')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'M')
							AND REPLACE(TRIM(ds.Migrant), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'M')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'GT')
							AND REPLACE(TRIM(ds.GiftedandTalented), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'GT')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'RE')
							AND REPLACE(TRIM(ds.Race), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'RE')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'T')
							AND REPLACE(TRIM(ds.Truant), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'T')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'TR')
							AND REPLACE(TRIM(ds.Tribal), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'TR')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'SC')
							AND REPLACE(TRIM(ds.SchoolCategory), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'SC')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'ELL')
							AND REPLACE(TRIM(ds.ELL), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'ELL')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'FRL')
							AND REPLACE(TRIM(ds.FRL), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'FRL')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = '504')
							AND REPLACE(TRIM(ds.[504Status]), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = '504')
						)
						OR 
						(
							EXISTS (SELECT 1 FROM #OptionFlagDependencies WHERE DependentFieldCode = 'SPED')
							AND REPLACE(TRIM(ds.SpecialEdStatus), ' ', '') IN (SELECT FilterValue FROM #ParentSelectionstbl WHERE FilterCode = 'SPED')
						)
					)
				) a
			ORDER BY Value ASC
		END
	END TRY

	BEGIN CATCH
		IF XACT_STATE() = - 1
		BEGIN
			ROLLBACK TRANSACTION
		END

		DECLARE @ErrorFromProc VARCHAR(500)
		DECLARE @ProcErrorMessage VARCHAR(1000)
		DECLARE @SeverityLevel INT

		SELECT @ErrorFromProc = '[dbo].[USP_GetDashboardSubgroupChildElements]'
			,@ProcErrorMessage = Error_message()
			,@SeverityLevel = Error_severity()

		INSERT INTO dbo.[errorlogforusp] (
			ErrorFromProc
			,errormessage
			,severitylevel
			,datetimestamp
			,TenantId
			)
		VALUES (
			@ErrorFromProc
			,@ProcErrorMessage
			,@SeverityLevel
			,Getdate()
			,@Tenantid
			)
	END CATCH
END
GO