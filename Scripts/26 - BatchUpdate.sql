DECLARE @BatchId INT = 22545 
DECLARE @TenantId INT = 48 
DECLARE @SQL NVARCHAR(MAX)
DECLARE @DatabaseName NVARCHAR(50)

IF @TenantId IN (17, 18, 29, 33, 39, 34, 40, 41, 42, 43, 45)
	SET @DatabaseName = 'AnalyticVue_District'
ELSE IF @TenantId IN (28, 35, 36, 37)
	SET @DatabaseName = 'AnalyticVue_FPS'
ELSE IF @TenantId = 50
	SET @DatabaseName = 'AnalyticVue_Clayton'
ELSE IF @TenantId IN (20, 26, 27, 30, 38, 31, 44)
	SET @DatabaseName = 'AnalyticVue_OBS'
ELSE IF @TenantId = 47
	SET @DatabaseName = 'AnalyticVue_Hallco'
ELSE IF @TenantId IN (46, 48, 49, 51, 52)
	SET @DatabaseName = 'AnalyticVue_Norwood'

SET @SQL = N'
USE ' + @DatabaseName + ';
UPDATE bs
SET 
    ProcessEndDate = GETDATE(),
    ProcessStatusId = rps.ProcessStatusId
FROM batchschedule bs
INNER JOIN RefETLProcessStatus rps ON rps.TenantId = bs.TenantId
WHERE bs.TenantId = ' + CAST(@TenantId AS NVARCHAR(10)) + '
    AND bs.BatchId = ' + CAST(@BatchId AS NVARCHAR(10)) + '
    AND rps.ProcessStatus = ''Processed'''
PRINT @SQL

