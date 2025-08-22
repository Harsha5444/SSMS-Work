IF OBJECT_ID('tempdb..#TblTenant') IS NOT NULL
	DROP TABLE #TblTenant

IF OBJECT_ID('tempdb..#Modulereference') IS NOT NULL
	DROP TABLE #Modulereference

IF OBJECT_ID('tempdb..#Module') IS NOT NULL
	DROP TABLE #Module

CREATE TABLE #TblTenant (
	Id INT IDENTITY(1, 1)
	,TenantId INT
	)

DECLARE @count INT
	,@LoadType VARCHAR(3)
DECLARE @TenantId INT
DECLARE @IncrementId INT = 1;

IF EXISTS (
		SELECT 1
		FROM IDM.Tenant
		WHERE TenantId = 1
		)
BEGIN
	INSERT INTO #TblTenant
	SELECT TenantId
	FROM IDM.Tenant
	WHERE Tenantid = 1

	SET @LoadType = 'P'
END
ELSE
BEGIN
	INSERT INTO #TblTenant
	SELECT TenantId
	FROM IDM.Tenant

	SET @LoadType = 'S'
END

SELECT @count = count(TenantId)
FROM #TblTenant

WHILE (@IncrementId <= @count)
BEGIN
	IF OBJECT_ID('tempdb..#Modulereference') IS NOT NULL
		DROP TABLE #Modulereference

	IF OBJECT_ID('tempdb..#Module') IS NOT NULL
		DROP TABLE #Module

	SELECT @TenantId = TenantId
	FROM #TblTenant
	WHERE Id = @IncrementId;

	CREATE TABLE #Modulereference (
		ModuleCode VARCHAR(200)
		,PermissionCode VARCHAR(200)
		)

	INSERT INTO #Modulereference (
		ModuleCode
		,PermissionCode
		)
	SELECT ModuleCode
		,PermissionCode
	FROM (
		SELECT 'AIT' ModuleCode
			,'CRET' AS PermissionCode
		
		UNION ALL
		
		SELECT 'AIT' ModuleCode
			,'DELT' AS PermissionCode
		
		UNION ALL
		
		SELECT 'AIT' ModuleCode
			,'EDIT' AS PermissionCode
		
		UNION ALL
		
		SELECT 'AIT' ModuleCode
			,'READ' AS PermissionCode
		
		UNION ALL
		
		SELECT 'AIT' ModuleCode
			,'ADMN' AS PermissionCode
		
		UNION ALL
		
		SELECT 'MPG' ModuleCode
			,'CRET' AS PermissionCode
		
		UNION ALL
		
		SELECT 'MPG' ModuleCode
			,'DELT' AS PermissionCode
		
		UNION ALL
		
		SELECT 'MPG' ModuleCode
			,'EDIT' AS PermissionCode
		
		UNION ALL
		
		SELECT 'MPG' ModuleCode
			,'READ' AS PermissionCode
		
		UNION ALL
		
		SELECT 'MPG' ModuleCode
			,'ADMN' AS PermissionCode
		
		UNION ALL
		
		SELECT 'LPG' ModuleCode
			,'CRET' AS PermissionCode
		
		UNION ALL
		
		SELECT 'LPG' ModuleCode
			,'DELT' AS PermissionCode
		
		UNION ALL
		
		SELECT 'LPG' ModuleCode
			,'EDIT' AS PermissionCode
		
		UNION ALL
		
		SELECT 'LPG' ModuleCode
			,'READ' AS PermissionCode
		
		UNION ALL
		
		SELECT 'LPG' ModuleCode
			,'ADMN' AS PermissionCode
		
		UNION ALL
		
		SELECT 'SLP' ModuleCode
			,'CRET' AS PermissionCode
		
		UNION ALL
		
		SELECT 'SLP' ModuleCode
			,'DELT' AS PermissionCode
		
		UNION ALL
		
		SELECT 'SLP' ModuleCode
			,'EDIT' AS PermissionCode
		
		UNION ALL
		
		SELECT 'SLP' ModuleCode
			,'READ' AS PermissionCode
		
		UNION ALL
		
		SELECT 'SLP' ModuleCode
			,'ADMN' AS PermissionCode
		
		UNION ALL
		
		SELECT 'WKS' ModuleCode
			,'CRET' AS PermissionCode
		
		UNION ALL
		
		SELECT 'WKS' ModuleCode
			,'DELT' AS PermissionCode
		
		UNION ALL
		
		SELECT 'WKS' ModuleCode
			,'EDIT' AS PermissionCode
		
		UNION ALL
		
		SELECT 'WKS' ModuleCode
			,'READ' AS PermissionCode
		
		UNION ALL
		
		SELECT 'WKS' ModuleCode
			,'ADMN' AS PermissionCode
		) a

	CREATE TABLE #Module (
		ModuleId INT
		,ModuleName VARCHAR(100) NOT NULL
		,ModuleDesc VARCHAR(1000) NULL
		,ParentModuleId BIGINT NULL
		,PageLink VARCHAR(500) NULL
		,IsDynamicPage BIT NULL
		,Icon VARCHAR(25) NULL
		,ShortName VARCHAR(100) NULL
		,IsDisplayInRoleMatrix BIT NULL
		,Code VARCHAR(50) NOT NULL
		,SortOrder INT NULL
		,IsDefault BIT NULL
		,TenantId INT NOT NULL
		,StatusId SMALLINT NOT NULL
		,CreatedBy VARCHAR(150) NOT NULL
		,CreatedDate DATETIME NOT NULL
		,ISSecondary BIT
		)

	INSERT INTO #Module (
		ModuleId
		,IsSecondary
		,ModuleName
		,ModuleDesc
		,ParentModuleId
		,PageLink
		,IsDynamicPage
		,Icon
		,ShortName
		,IsDisplayInRoleMatrix
		,Code
		,SortOrder
		,IsDefault
		,TenantId
		,StatusId
		,CreatedBy
		,CreatedDate
		)
	SELECT ModuleId
		,ISSecondary
		,[ModuleName]
		,[ModuleDesc]
		,[ParentModuleId]
		,[PageLink]
		,[IsDynamicPage]
		,[Icon]
		,[ShortName]
		,[IsDisplayInRoleMatrix]
		,[Code]
		,[SortOrder]
		,[IsDefault]
		,[TenantId]
		,[StatusId]
		,[CreatedBy]
		,[CreatedDate]
	FROM (
		SELECT 50 AS [ModuleId]
			,0 AS ISSecondary
			,N'AITools' AS [ModuleName]
			,N'AITools' AS [ModuleDesc]
			,NULL AS [ParentModuleId]
			,NULL AS [PageLink]
			,NULL AS [IsDynamicPage]
			,NULL AS [Icon]
			,N'AITools' AS [ShortName]
			,1 AS [IsDisplayInRoleMatrix]
			,N'AIT' AS [Code]
			,120 AS [SortOrder]
			,1 AS [IsDefault]
			,@TenantId AS TenantId
			,1 AS [StatusId]
			,N'DDAUser@DDA' AS [CreatedBy]
			,getdate() AS [CreatedDate]
		
		UNION
		
		SELECT 51 AS [ModuleId]
			,1 AS ISSecondary
			,N'MTSS Plan Generator' AS [ModuleName]
			,N'MTSS Plan Generator' AS [ModuleDesc]
			,50 AS [ParentModuleId]
			,N'/MTSSPlanGenerator/MTSSAI' AS [PageLink]
			,NULL AS [IsDynamicPage]
			,NULL AS [Icon]
			,N'PlanGenerator' AS [ShortName]
			,1 AS [IsDisplayInRoleMatrix]
			,N'MPG' AS [Code]
			,121 AS [SortOrder]
			,1 AS [IsDefault]
			,@TenantId AS TenantId
			,1 AS [StatusId]
			,N'DDAUser@DDA' AS [CreatedBy]
			,getdate() AS [CreatedDate]
		
		UNION
		
		SELECT 52 AS [ModuleId]
			,1 AS ISSecondary
			,N'Lesson Plan Generator' AS [ModuleName]
			,N'Lesson Plan Generator' AS [ModuleDesc]
			,50 AS [ParentModuleId]
			,N'/MTSSPlanGenerator/AILessonPlan' AS [PageLink]
			,NULL AS [IsDynamicPage]
			,NULL AS [Icon]
			,N'LessonGenerator' AS [ShortName]
			,1 AS [IsDisplayInRoleMatrix]
			,N'LPG' AS [Code]
			,122 AS [SortOrder]
			,1 AS [IsDefault]
			,@TenantId AS TenantId
			,1 AS [StatusId]
			,N'DDAUser@DDA' AS [CreatedBy]
			,getdate() AS [CreatedDate]
		
		UNION
		
		SELECT 53 AS [ModuleId]
			,1 AS ISSecondary
			,N'School Improvement Plan' AS [ModuleName]
			,N'School Improvement Plan' AS [ModuleDesc]
			,50 AS [ParentModuleId]
			,N'/SchoolAnalysis/SchoolPlan' AS [PageLink]
			,NULL AS [IsDynamicPage]
			,NULL AS [Icon]
			,N'ImprovementPlan' AS [ShortName]
			,1 AS [IsDisplayInRoleMatrix]
			,N'SLP' AS [Code]
			,123 AS [SortOrder]
			,1 AS [IsDefault]
			,@TenantId AS TenantId
			,1 AS [StatusId]
			,N'DDAUser@DDA' AS [CreatedBy]
			,getdate() AS [CreatedDate]
		
		UNION
		
		SELECT 54 AS [ModuleId]
			,1 AS ISSecondary
			,N'WorkSheets' AS [ModuleName]
			,N'WorkSheets' AS [ModuleDesc]
			,50 AS [ParentModuleId]
			,N'/WorkSheetsAI/Worksheets' AS [PageLink]
			,NULL AS [IsDynamicPage]
			,NULL AS [Icon]
			,N'WorkSheets' AS [ShortName]
			,1 AS [IsDisplayInRoleMatrix]
			,N'WKS' AS [Code]
			,124 AS [SortOrder]
			,1 AS [IsDefault]
			,@TenantId AS TenantId
			,1 AS [StatusId]
			,N'DDAUser@DDA' AS [CreatedBy]
			,getdate() AS [CreatedDate]
		) a

	IF (@LoadType = 'P')
	BEGIN
		INSERT INTO IDM.Module (
			[ModuleName]
			,[ModuleDesc]
			,[ParentModuleId]
			,[PageLink]
			,[IsDynamicPage]
			,[Icon]
			,[ShortName]
			,[IsDisplayInRoleMatrix]
			,[Code]
			,[SortOrder]
			,[IsDefault]
			,[TenantId]
			,[StatusId]
			,[CreatedBy]
			,[CreatedDate]
			)
		SELECT [ModuleName]
			,[ModuleDesc]
			,[ParentModuleId]
			,[PageLink]
			,[IsDynamicPage]
			,[Icon]
			,[ShortName]
			,[IsDisplayInRoleMatrix]
			,[Code]
			,[SortOrder]
			,[IsDefault]
			,@TenantId
			,[StatusId]
			,[CreatedBy]
			,[CreatedDate]
		FROM #Module MM
		WHERE NOT EXISTS (
				SELECT 1
				FROM IDM.Module TM
				WHERE TM.TENANTID = mm.TenantId
					AND MM.Code = TM.Code
				)

		UPDATE d
		SET d.ParentModuleId = e.ModuleId
		FROM (
			SELECT a.Code
				,b.Code AS [PARENTCODE]
			FROM #Module a
			INNER JOIN #Module b ON a.ParentModuleId = b.ModuleId
			WHERE a.ParentModuleId IS NOT NULL
				AND a.issecondary = 1
				AND b.issecondary = 0
			) c
		INNER JOIN IDM.Module d ON d.Code = c.CODE
		INNER JOIN idm.Module e ON e.Code = c.PARENTCODE
			AND d.TenantId = e.TenantId
		WHERE d.TenantId = @TenantId

		INSERT INTO IDM.RoleModule (
			RoleId
			,ModuleId
			,TenantId
			,StatusId
			,CreatedBy
			,CreatedDate
			)
		SELECT RoleId
			,ModuleId
			,TenantId
			,StatusId
			,CreatedBy
			,CreatedDate
		FROM (
			SELECT rl.RoleId
				,md.ModuleId
				,@TenantId AS TenantId
				,1 AS statusid
				,'DDAAdmin' AS CreatedBy
				,Getdate() AS CreatedDate
			FROM idm.DDARole rl
			INNER JOIN idm.Module md ON md.TenantId = rl.TenantId
			WHERE rl.TenantId = @TenantId
				AND rl.IsDefault = 1
				AND rl.Code = 'SYSADMIN'
				AND md.code IN ('AIT', 'MPG', 'LPG', 'SLP', 'WKS')
			
			UNION ALL
			
			SELECT rl.RoleId
				,md.ModuleId
				,@TenantId AS TenantId
				,1 AS statusid
				,'DDAAdmin' AS CreatedBy
				,Getdate() AS CreatedDate
			FROM idm.DDARole rl
			INNER JOIN idm.Module md ON md.TenantId = rl.TenantId
			WHERE rl.TenantId = @TenantId
				AND rl.IsDefault = 1
				AND rl.Code = 'TNTADMIN'
				AND md.code IN ('AIT', 'MPG', 'LPG', 'SLP', 'WKS')
			) a
		WHERE NOT EXISTS (
				SELECT 1
				FROM IDM.RoleModule b
				WHERE a.RoleId = b.RoleId
					AND a.ModuleId = b.ModuleId
					AND b.TenantId = @TenantId
				)
	END

	IF (@LoadType = 'S')
	BEGIN
		INSERT INTO IDM.Module (
			[ModuleName]
			,[ModuleDesc]
			,[ParentModuleId]
			,[PageLink]
			,[IsDynamicPage]
			,[Icon]
			,[ShortName]
			,[IsDisplayInRoleMatrix]
			,[Code]
			,[SortOrder]
			,[IsDefault]
			,[TenantId]
			,[StatusId]
			,[CreatedBy]
			,[CreatedDate]
			)
		SELECT [ModuleName]
			,[ModuleDesc]
			,[ParentModuleId]
			,[PageLink]
			,[IsDynamicPage]
			,[Icon]
			,[ShortName]
			,[IsDisplayInRoleMatrix]
			,[Code]
			,[SortOrder]
			,[IsDefault]
			,@TenantId
			,[StatusId]
			,[CreatedBy]
			,[CreatedDate]
		FROM #Module MM
		WHERE NOT EXISTS (
				SELECT 1
				FROM IDM.Module TM
				WHERE TM.TENANTID = mm.TenantId
					AND MM.Code = TM.Code
				)

		UPDATE d
		SET d.ParentModuleId = e.ModuleId
		FROM (
			SELECT a.Code
				,b.Code AS [PARENTCODE]
			FROM #Module a
			INNER JOIN #Module b ON a.ParentModuleId = b.ModuleId
			WHERE a.ParentModuleId IS NOT NULL
				AND a.issecondary = 1
				AND b.issecondary = 0
			) c
		INNER JOIN IDM.Module d ON d.Code = c.CODE
		INNER JOIN idm.Module e ON e.Code = c.PARENTCODE
			AND d.TenantId = e.TenantId
		WHERE d.TenantId = @TenantId

		INSERT INTO IDM.RoleModule (
			RoleId
			,ModuleId
			,TenantId
			,StatusId
			,CreatedBy
			,CreatedDate
			)
		SELECT RoleId
			,ModuleId
			,TenantId
			,StatusId
			,CreatedBy
			,CreatedDate
		FROM (
			SELECT rl.RoleId
				,md.ModuleId
				,@TenantId AS TenantId
				,1 AS statusid
				,'DDAAdmin' AS CreatedBy
				,Getdate() AS CreatedDate
			FROM idm.DDARole rl
			INNER JOIN idm.Module md ON md.TenantId = rl.TenantId
			WHERE rl.TenantId = @TenantId
				AND rl.IsDefault = 1
				AND rl.Code = 'TNTADMIN'
				AND md.code IN ('AIT', 'MPG', 'LPG', 'SLP', 'WKS')
			) a
		WHERE NOT EXISTS (
				SELECT 1
				FROM IDM.RoleModule b
				WHERE a.RoleId = b.RoleId
					AND a.ModuleId = b.ModuleId
					AND b.TenantId = @TenantId
				)
	END

	-- loading Role module permission for both primary and secondary Tenants
	--*************** loading RoleModulePermission data 
	INSERT INTO IDM.ModulePermission (
		ModuleId
		,PermissionId
		,TenantId
		,StatusId
		,CreatedBy
		,CreatedDate
		)
	SELECT ModuleId
		,PermissionId
		,TenantId
		,StatusId
		,CreatedBy
		,CreatedDate
	FROM (
		SELECT DISTINCT md.ModuleId
			,rp.PermissionId
			,@TenantId AS TenantId
			,1 AS statusid
			,'DDAAdmin' AS CreatedBy
			,Getdate() AS CreatedDate
		FROM idm.Module md
		INNER JOIN #Modulereference a ON a.ModuleCode = md.Code
		INNER JOIN dbo.RefPermission rp ON rp.PermissionCode = a.PermissionCode
		WHERE rp.TenantId = @TenantId
			AND md.TenantId = @TenantId
			AND md.code IN ('AIT', 'MPG', 'LPG', 'SLP', 'WKS')
		) a
	WHERE NOT EXISTS (
			SELECT 1
			FROM IDM.ModulePermission b
			WHERE a.ModuleId = b.ModuleId
				AND a.PermissionId = b.PermissionId
				AND a.TenantId = b.TenantId
			)

	INSERT INTO IDM.RoleModulePermission (
		RoleId
		,ModuleId
		,PermissionId
		,TenantId
		,StatusId
		,CreatedBy
		,CreatedDate
		)
	SELECT RoleId
		,ModuleId
		,PermissionId
		,TenantId
		,StatusId
		,CreatedBy
		,CreatedDate
	FROM (
		SELECT rm.RoleId
			,rm.ModuleId
			,mp.PermissionId
			,@TenantId AS TenantId
			,1 AS statusid
			,'DDAAdmin' AS CreatedBy
			,Getdate() AS CreatedDate
		FROM idm.RoleModule rm
		INNER JOIN idm.ModulePermission mp ON rm.ModuleId = mp.ModuleId
			AND rm.TenantId = mp.TenantId
		INNER JOIN idm.DDARole rl ON rl.RoleId = rm.RoleId
			AND rl.TenantId = rm.TenantId
		WHERE rl.IsDefault = 1
			AND rl.TenantId = @TenantId
			AND rm.ModuleId IN (
				SELECT ModuleId
				FROM idm.module
				WHERE code IN ('AIT', 'MPG', 'LPG', 'SLP', 'WKS')
				)
		) a
	WHERE NOT EXISTS (
			SELECT 1
			FROM IDM.RoleModulePermission b
			WHERE a.RoleId = b.RoleId
				AND a.ModuleId = b.ModuleId
				AND a.PermissionId = b.PermissionId
				AND a.TenantId = b.TenantId
			)

	INSERT INTO [IDM].LicensingPackageModule (
		LicensingPackageId
		,moduleid
		,StatusId
		,CreatedBy
		,CreatedDate
		)
	SELECT LicensingPackageId
		,ModuleId
		,StatusId
		,CreatedBy
		,CreatedDate
	FROM (
		SELECT m.ModuleId
			,lp.LicensingPackageId
			,1 AS statusid
			,'DDAAdmin' AS CreatedBy
			,Getdate() AS CreatedDate
		FROM idm.LicensingPackage lp
		CROSS JOIN IDM.Module m
		WHERE m.StatusId = 1
			AND lp.StatusId = 1
			AND m.TenantId = @TenantId
			AND m.code IN ('AIT', 'MPG', 'LPG', 'SLP', 'WKS')
		) a
	WHERE NOT EXISTS (
			SELECT 1
			FROM [IDM].LicensingPackageModule b
			WHERE a.LicensingPackageId = b.LicensingPackageId
				AND a.ModuleId = b.ModuleId
			)

	SET @IncrementId = @IncrementId + 1;
END
