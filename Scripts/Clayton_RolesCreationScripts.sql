select * from Clayton_AnalyticVueRoles order by [status] desc--where Local_Job_Code = '720E'
--update Clayton_AnalyticVueRoles set status = '*Job Code Not Found'  where [status] = 'Not Found'
select * from dbo.SSODetails
--update dbo.SSODetails set StatusId=2 where SSODetailsId=1
select * from idm.ddauser order by 1 desc


SELECT 
    trim(StaffFirstName) AS FirstName,	
    trim(StaffMiddleName) AS MiddleName,
    trim(StaffLastName) AS LastName,	
    trim(StaffEmailAddress) as   Email,                
    trim(StaffNumber) AS DistrictStaffId
FROM Main.Clayton_AnalyticVue_StaffExtract 
WHERE LocalJobCode IN (SELECT codes FROM dbo.StaffCodes_Test)
AND NOT EXISTS (
    SELECT 1 
    FROM idm.DDAUser existing
    WHERE existing.DistrictStaffId = StaffNumber
       OR (
           UPPER(ISNULL(existing.FirstName, '')) = UPPER(ISNULL(StaffFirstName, ''))
           AND UPPER(ISNULL(existing.LastName, '')) = UPPER(ISNULL(StaffLastName, ''))
           AND UPPER(ISNULL(existing.MiddleName, '')) = UPPER(ISNULL(StaffMiddleName, ''))
       )
) and LocalJobCode = '907H' 

select * from Main.Clayton_AnalyticVue_StaffExtract where LocalJobCode = '01AH'

select DDAUserId from idm.ddauser where cast(CreatedDate as date) = cast( getdate() as date)

select * from idm.userroleorg where DDAUserId in (select DDAUserId from idm.ddauser where cast(CreatedDate as date) = cast( getdate() as date))






