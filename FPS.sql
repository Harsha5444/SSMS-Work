select * from idm.Tenant
--28	Framingham Public Schools
--35	East Hartford Public Schools
--36	NSBoro
--37	Rochelle Schools

select * from RefFileTemplates where tenantid = 28 and filetemplatename like '%mcas%'
select distinct dataset from fn_DashboardReportsDetails(28) where dashboardname like '%mcas%'

--FPS_MCAS_2023 for Admins
--FPS_MCAS_Tierwithdemo
--FPS_MCAS2024withDemo
--FPS_MCAS2025_Prelimwithdemo
--FPS_MCASELA2024SchoolsOnly
--FPSiReady5LevelsDS
--FPSMCAS2025ELAwithdemo

--[FPSMCAS2023forAdmins]