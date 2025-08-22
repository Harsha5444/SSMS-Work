IF OBJECT_ID('tempdb..#TblTenant') IS NOT NULL
    DROP TABLE #TblTenant
	IF OBJECT_ID('tempdb..#Modulereference') IS NOT NULL
    DROP TABLE #Modulereference
	IF OBJECT_ID('tempdb..#Module') IS NOT NULL
    DROP TABLE #Module
	
CREATE TABLE #TblTenant
(
	 Id  int IDENTITY (1,1)
    , TenantId  int
)

Declare @count int,@LoadType varchar(3)
Declare @TenantId int
Declare @IncrementId int=1;



if exists ( select 1 from IDM.Tenant where TenantId = 1 )
begin
	insert into #TblTenant
	select TenantId from IDM.Tenant where Tenantid = 1
	SET @LoadType='P'

END
ELSE BEGIN
	insert into #TblTenant
	select TenantId from IDM.Tenant
	SET @LoadType='S'

END

	select @count=count(TenantId) from #TblTenant 

while (@IncrementId<=@count)

BEGIN 
  IF OBJECT_ID('tempdb..#Modulereference') IS NOT NULL
    DROP TABLE #Modulereference
	IF OBJECT_ID('tempdb..#Module') IS NOT NULL
    DROP TABLE #Module

		select @TenantId=TenantId from #TblTenant where Id=@IncrementId;

					CREATE TABLE #Modulereference ( ModuleCode VARCHAR(200),PermissionCode VARCHAR(200))

				insert into #Modulereference (ModuleCode,PermissionCode)
				select ModuleCode,PermissionCode
				from (
						SELECT 'AIT' ModuleCode, 'CRET' AS PermissionCode
						UNION ALL 
						SELECT 'AIT' ModuleCode, 'DELT' AS PermissionCode
						UNION ALL 
						SELECT 'AIT' ModuleCode, 'EDIT' AS PermissionCode
						UNION ALL 
						SELECT 'AIT' ModuleCode, 'READ' AS PermissionCode
						UNION ALL 
						SELECT 'AIT' ModuleCode, 'ADMN' AS PermissionCode
						UNION ALL
						SELECT 'WKS' ModuleCode, 'CRET' AS PermissionCode
						UNION ALL 
						SELECT 'WKS' ModuleCode, 'DELT' AS PermissionCode
						UNION ALL 
						SELECT 'WKS' ModuleCode, 'EDIT' AS PermissionCode
						UNION ALL 
						SELECT 'WKS' ModuleCode, 'READ' AS PermissionCode
						UNION ALL 
						SELECT 'WKS' ModuleCode, 'ADMN' AS PermissionCode	
				) a


	CREATE TABLE #Module(ModuleId int, ModuleName varchar(100) NOT NULL, ModuleDesc varchar(1000) NULL,ParentModuleId bigint NULL,
			PageLink varchar(500) NULL,IsDynamicPage bit NULL,Icon varchar(25) NULL,ShortName varchar(100) NULL,IsDisplayInRoleMatrix bit NULL
			,Code varchar(50) NOT NULL,SortOrder int NULL,IsDefault bit NULL,TenantId int NOT NULL,StatusId smallint NOT NULL
			,CreatedBy varchar(150) NOT NULL,CreatedDate datetime NOT NULL,ISSecondary bit)


						INSERT into #Module (ModuleId,IsSecondary,ModuleName, ModuleDesc, ParentModuleId, PageLink, IsDynamicPage, Icon, ShortName, IsDisplayInRoleMatrix, Code
									, SortOrder, IsDefault, TenantId, StatusId, CreatedBy, CreatedDate
								)
				select ModuleId, ISSecondary, [ModuleName], [ModuleDesc], [ParentModuleId], [PageLink], [IsDynamicPage], [Icon], [ShortName], [IsDisplayInRoleMatrix], [Code], [SortOrder], [IsDefault], [TenantId], [StatusId], [CreatedBy], [CreatedDate]
		from (
					   select 50 as [ModuleId], 0 as ISSecondary, N'AITools' as [ModuleName], N'AITools' as [ModuleDesc],  
						null as [ParentModuleId], null as [PageLink], 
						NULL as [IsDynamicPage],NULL as [Icon], N'AITools' as [ShortName], 1 as [IsDisplayInRoleMatrix], N'AIT' as [Code], 120 as [SortOrder], 
						1 as [IsDefault], @TenantId as TenantId, 1 as [StatusId], N'DDAUser@DDA' as [CreatedBy],getdate() as [CreatedDate]
						union
						select 51 as [ModuleId], 1 as ISSecondary, N'WorkSheets' as [ModuleName], N'WorkSheets' as [ModuleDesc],  
						50 as [ParentModuleId], N'/WorkSheetsAI/Worksheets' as [PageLink], 
						NULL as [IsDynamicPage],NULL as [Icon], N'WorkSheets' as [ShortName], 1 as [IsDisplayInRoleMatrix], N'WKS' as [Code], 121 as [SortOrder], 
						1 as [IsDefault], @TenantId as TenantId, 1 as [StatusId], N'DDAUser@DDA' as [CreatedBy],getdate() as [CreatedDate]
 
				) a
		


		IF ( @LoadType = 'P' )
		BEGIN

					INSERT into IDM.Module([ModuleName], [ModuleDesc], [ParentModuleId], [PageLink], [IsDynamicPage], [Icon], [ShortName], [IsDisplayInRoleMatrix], [Code]
									, [SortOrder], [IsDefault], [TenantId], [StatusId], [CreatedBy], [CreatedDate]
									)
			select [ModuleName], [ModuleDesc], [ParentModuleId], [PageLink], [IsDynamicPage], [Icon], [ShortName], [IsDisplayInRoleMatrix], [Code]
							, [SortOrder], [IsDefault], @TenantId, [StatusId], [CreatedBy], [CreatedDate]
			FROM #Module MM
			WHERE NOT EXISTS ( SELECT 1 FROM IDM.Module TM WHERE TM.TENANTID=mm.TenantId AND MM.Code=TM.Code )
				
			UPDATE d set d.ParentModuleId = e.ModuleId
			FROM ( 
						SELECT a.Code, b.Code AS [PARENTCODE]
						FROM #Module a
						INNER JOIN #Module b  ON a.ParentModuleId = b.ModuleId 
						WHERE a.ParentModuleId IS NOT NULL and a.issecondary = 1 and b.issecondary = 0
					) c
			INNER JOIN IDM.Module d ON d.Code = c.CODE 
			inner join idm.Module e on e.Code = c.PARENTCODE and d.TenantId = e.TenantId
			where d.TenantId = @TenantId


			insert into IDM.RoleModule( RoleId, ModuleId, TenantId, StatusId, CreatedBy, CreatedDate )
			select RoleId, ModuleId, TenantId, StatusId, CreatedBy, CreatedDate
			from (
				select rl.RoleId, md.ModuleId
					,@TenantId as TenantId,1 as statusid,'DDAAdmin' as CreatedBy,Getdate() as CreatedDate
				from idm.DDARole rl
				inner join idm.Module md
					on md.TenantId = rl.TenantId 
				where rl.TenantId = @TenantId and rl.IsDefault = 1 and rl.Code = 'SYSADMIN' 
				and md.code IN ('AIT','WKS')

				UNION ALL

				select rl.RoleId, md.ModuleId
					,@TenantId as TenantId,1 as statusid,'DDAAdmin' as CreatedBy,Getdate() as CreatedDate
				from idm.DDARole rl
				inner join idm.Module md
					on md.TenantId = rl.TenantId 
				where rl.TenantId = @TenantId and rl.IsDefault = 1 and rl.Code = 'TNTADMIN'
				and md.code IN  ('AIT','WKS')
			) a
			where not exists ( select 1 from IDM.RoleModule b where a.RoleId = b.RoleId and a.ModuleId = b.ModuleId and b.TenantId = @TenantId )
		END

		IF ( @LoadType = 'S' )
		BEGIN

					INSERT into IDM.Module([ModuleName], [ModuleDesc], [ParentModuleId], [PageLink], [IsDynamicPage], [Icon], [ShortName], [IsDisplayInRoleMatrix], [Code]
									, [SortOrder], [IsDefault], [TenantId], [StatusId], [CreatedBy], [CreatedDate]
									)
			select [ModuleName], [ModuleDesc], [ParentModuleId], [PageLink], [IsDynamicPage], [Icon], [ShortName], [IsDisplayInRoleMatrix], [Code]
							, [SortOrder], [IsDefault], @TenantId, [StatusId], [CreatedBy], [CreatedDate]
			FROM #Module MM
			WHERE  NOT EXISTS ( SELECT 1 FROM IDM.Module TM WHERE TM.TENANTID=mm.TenantId AND MM.Code=TM.Code )
			
			UPDATE d set d.ParentModuleId = e.ModuleId
			FROM ( 
						SELECT a.Code, b.Code AS [PARENTCODE]
						FROM #Module a
						INNER JOIN #Module b  ON a.ParentModuleId = b.ModuleId 
						WHERE a.ParentModuleId IS NOT NULL and a.issecondary = 1 and b.issecondary = 0
					) c
			INNER JOIN IDM.Module d ON d.Code = c.CODE 
			inner join idm.Module e on e.Code = c.PARENTCODE and d.TenantId = e.TenantId
			where d.TenantId = @TenantId
	
			
			insert into IDM.RoleModule( RoleId, ModuleId, TenantId, StatusId, CreatedBy, CreatedDate )
			select RoleId, ModuleId, TenantId, StatusId, CreatedBy, CreatedDate
			from (
				select rl.RoleId, md.ModuleId
					,@TenantId as TenantId,1 as statusid,'DDAAdmin' as CreatedBy,Getdate() as CreatedDate
				from idm.DDARole rl
				inner join idm.Module md
					on md.TenantId = rl.TenantId 
				where rl.TenantId = @TenantId and rl.IsDefault = 1 and rl.Code = 'TNTADMIN' AND md.code IN  ('AIT','WKS')
					
			) a
			where not exists ( select 1 from IDM.RoleModule b where a.RoleId = b.RoleId and a.ModuleId = b.ModuleId and b.TenantId = @TenantId )
		END
		
		-- loading Role module permission for both primary and secondary Tenants

				--*************** loading RoleModulePermission data 

				
			insert into IDM.ModulePermission( ModuleId, PermissionId, TenantId, StatusId, CreatedBy, CreatedDate)
				select ModuleId, PermissionId, TenantId, StatusId, CreatedBy, CreatedDate
				from (
						select distinct  md.ModuleId,rp.PermissionId
							,@TenantId as TenantId,1 as statusid,'DDAAdmin' as CreatedBy,Getdate() as CreatedDate
						from idm.Module md
						inner join #Modulereference a
							on a.ModuleCode = md.Code
						inner join dbo.RefPermission rp
							on rp.PermissionCode = a.PermissionCode
						where rp.TenantId = @TenantId and md.TenantId = @TenantId and md.code IN ('AIT','WKS')
				) a
				where not exists ( select 1 from IDM.ModulePermission b where a.ModuleId = b.ModuleId and a.PermissionId = b.PermissionId and a.TenantId = b.TenantId )  



				insert into IDM.RoleModulePermission( RoleId, ModuleId, PermissionId, TenantId, StatusId, CreatedBy,CreatedDate )
				select RoleId, ModuleId, PermissionId, TenantId, StatusId, CreatedBy,CreatedDate
				from (
						select rm.RoleId,rm.ModuleId,mp.PermissionId
							,@TenantId as TenantId,1 as statusid,'DDAAdmin' as CreatedBy,Getdate() as CreatedDate
						from idm.RoleModule rm
						inner join idm.ModulePermission mp
						on rm.ModuleId = mp.ModuleId and rm.TenantId = mp.TenantId
						inner join idm.DDARole rl
						on rl.RoleId = rm.RoleId and rl.TenantId = rm.TenantId
						where rl.IsDefault = 1 and rl.TenantId = @TenantId AND rm.ModuleId IN (SELECT ModuleId FROM idm.module WHERE code IN ('AIT','WKS'))
				) a
				where not exists ( select 1 from IDM.RoleModulePermission b where a.RoleId  =b.RoleId and a.ModuleId  =b.ModuleId 
									and a.PermissionId = b.PermissionId and a.TenantId = b.TenantId )

				INSERT INTO [IDM].LicensingPackageModule(LicensingPackageId, moduleid , StatusId, CreatedBy, CreatedDate)
				select  LicensingPackageId, ModuleId, StatusId, CreatedBy, CreatedDate 
				from (
					select m.ModuleId,lp.LicensingPackageId
							,1 as statusid,'DDAAdmin' as CreatedBy,Getdate() as CreatedDate
					from idm.LicensingPackage lp
					cross join IDM.Module m
					where m.StatusId = 1 and lp.StatusId = 1 and m.TenantId = @TenantId and m.code IN ('AIT','WKS')
				) a
				where not exists (select 1 from [IDM].LicensingPackageModule b where a.LicensingPackageId = b.LicensingPackageId and a.ModuleId = b.ModuleId )

				
					
					set @IncrementId=@IncrementId+1;
		END 
