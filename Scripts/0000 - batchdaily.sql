-- Set tenant ID
DECLARE @tenantid INT = 50

-- Database selection based on tenant ID
IF @Tenantid IN (17,18,29,33,39,34,40,41,42,43,45)
    USE AnalyticVue_District;
ELSE IF @Tenantid IN (28,35,36,37)
    USE AnalyticVue_FPS;
ELSE IF @Tenantid = 50
    USE AnalyticVue_Clayton;
ELSE IF @Tenantid IN (20,26,27,30,38,31,44)
    USE AnalyticVue_OBS;
ELSE IF @Tenantid = 47
    USE AnalyticVue_Hallco;
ELSE IF @Tenantid IN (46,48,49,51,52)
    USE AnalyticVue_Norwood;

-- Declare variables
DECLARE @whereclause NVARCHAR(MAX) = ' WHERE bs.tenantid = @tenantid ';
DECLARE @SQL NVARCHAR(MAX);

-- Main query
SET @SQL = '
SELECT 
    *,
    CONCAT(
        FLOOR(DATEDIFF(SECOND, ProcessStartDate, ProcessEndDate) / 60),
        '':'',
        FORMAT(DATEDIFF(SECOND, ProcessStartDate, ProcessEndDate) % 60, ''00'')
    ) AS TotalSeconds,
    ISNULL(FORMAT(DATEADD(HOUR, -5, ScheduledTimeDetailed), ''hh:mm:ss tt''), ''0'') AS EST_Time,
    ScheduledTimeDetailed AS UST_Time,
    ISNULL(FORMAT(DATEADD(MINUTE, 330, ScheduledTimeDetailed), ''hh:mm:ss tt''), ''0'') AS IST_Time,
    CASE 
        WHEN WarningLevel = ''High'' THEN 4
        WHEN WarningLevel = ''Medium'' THEN 3
        WHEN WarningLevel = ''Low'' THEN 2
        WHEN WarningLevel = ''NoFailed'' THEN 1 
    END AS sortorder
FROM (
    SELECT DISTINCT
        ISNULL(bs.batchid, '''') AS BaatchId,
        bs.batchname AS BatchName,
        frcs.tenantfiletemplatename AS TenantFileTemplateName,
        rs.sourcetypedescription AS SourceType,
        CASE 
            WHEN CAST(scheduleddatetime AS DATE) = CAST(GETDATE() AS DATE) THEN ''Today''
            WHEN CAST(scheduleddatetime AS DATE) = CAST(GETDATE() - 1 AS DATE) THEN ''Yesterday''
            WHEN CAST(scheduleddatetime AS DATE) = CAST(GETDATE() - 2 AS DATE) THEN ''DayBeforeYesterday''
            ELSE ''N/A''
        END AS ScheduledDay,
        processstatus AS ProcessStatus,
        ISNULL(cleanrecords, 0) AS CleanRecords,
        ISNULL(noactionrecords, 0) AS NoActionRecords,
        ISNULL(failedrecords, 0) AS FailedRecords,
        ISNULL(cleanrecords, 0) + ISNULL(noactionrecords, 0) + ISNULL(failedrecords, 0) AS TotalRecords,
        CASE
            WHEN ISNULL(cleanrecords, 0) + ISNULL(noactionrecords, 0) + ISNULL(failedrecords, 0) = 0 THEN ''High''
            WHEN ISNULL(failedrecords, 0) > 0.5 * (ISNULL(cleanrecords, 0) + ISNULL(noactionrecords, 0) + ISNULL(failedrecords, 0)) THEN ''High''
            WHEN ISNULL(failedrecords, 0) BETWEEN 0.3 * (ISNULL(cleanrecords, 0) + ISNULL(noactionrecords, 0) + ISNULL(failedrecords, 0)) 
                AND 0.5 * (ISNULL(cleanrecords, 0) + ISNULL(noactionrecords, 0) + ISNULL(failedrecords, 0)) THEN ''Medium''
            WHEN ISNULL(failedrecords, 0) = 0 AND (ISNULL(cleanrecords, 0) + ISNULL(noactionrecords, 0)) > 0 THEN ''NoFailed''
            ELSE ''Low''
        END AS WarningLevel,
        STRING_AGG(ISNULL(errormessage, ''0''), ''/'') AS ErrorMessage,
        CAST(ISNULL(FORMAT(scheduleddatetime, ''MM-dd-yyyy hh:mm:ss''), ''0'') AS DATETIME) AS ScheduledDateTimeDetailed,
        ISNULL(FORMAT(scheduleddatetime, ''hh:mm:ss tt''), ''0'') AS ScheduledTimeDetailed,
        CASE 
            WHEN ISNULL(FORMAT(processstartdate, ''MM-dd-yyyy hh:mm:ss''), ''0'') = ''0'' THEN NULL 
            ELSE ISNULL(FORMAT(processstartdate, ''MM-dd-yyyy hh:mm:ss''), ''0'') 
        END AS ProcessStartDate,
        CASE 
            WHEN ISNULL(FORMAT(processenddate, ''MM-dd-yyyy hh:mm:ss''), ''0'') = ''0'' THEN NULL 
            ELSE ISNULL(FORMAT(processenddate, ''MM-dd-yyyy hh:mm:ss''), ''0'') 
        END AS ProcessEndDate,
        bs.tenantid AS TenantID
    FROM batchschedule bs WITH (NOLOCK)
    LEFT JOIN dbo.filerecordcountstats frcs WITH (NOLOCK) 
        ON bs.batchid = frcs.batchid
    LEFT JOIN br.failedbrrecordcountstats brcs WITH (NOLOCK) 
        ON frcs.filetemplateid = brcs.filetemplateid 
        AND frcs.filerecordcountstatsid = brcs.filerecordcountstatsid
    LEFT JOIN dbo.reffiletemplates rft WITH (NOLOCK) 
        ON rft.filetemplateid = frcs.filetemplateid
    LEFT JOIN fileprocessingtimestats fpts WITH (NOLOCK) 
        ON fpts.filerecordcountstatsid = frcs.filerecordcountstatsid 
        AND fpts.batchid = frcs.batchid
    LEFT JOIN refetlprocessstatus rp WITH (NOLOCK) 
        ON rp.processstatusid = bs.processstatusid
    LEFT JOIN dbo.refsourcetype rs WITH (NOLOCK) 
        ON bs.sourcetypeid = rs.sourcetypeid
    LEFT JOIN dbo.refscheduletype rst WITH (NOLOCK) 
        ON bs.scheduletypeid = rst.scheduletypeid
    ' + @whereclause + '
    AND CAST(scheduleddatetime AS DATE) = CAST(GETDATE() AS DATE)
    GROUP BY
        bs.batchid, bs.batchname, frcs.tenantfiletemplatename, rs.sourcetypedescription,
        processstatus, cleanrecords, noactionrecords, failedrecords, scheduleddatetime,
        processstartdate, processenddate, rst.typename, bs.tenantid
) a
ORDER BY sortorder DESC';

EXEC sp_executesql @SQL, N'@tenantid INT', @tenantid;