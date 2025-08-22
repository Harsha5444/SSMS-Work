DECLARE @DatasetName NVARCHAR(255) = 'Clayton_Assessment_EOG_DS';
DECLARE @ColumnName NVARCHAR(100) = 'Magnet';
DECLARE @DebugOnly BIT = 1; -- Set to 0 to actually insert
DECLARE @TenantId INT = 50;
DECLARE @CreatedBy NVARCHAR(255) = 'AnalyticVue.Admin@Clayton';

-- Get DomainRelatedViewId and FieldId 
DECLARE @DomainRelatedViewId INT;
DECLARE @FieldId NVARCHAR(50);

SELECT 
    @DomainRelatedViewId = rdrv.DomainRelatedViewId,
    @FieldId = CAST(rvf.RptViewFieldsId AS NVARCHAR(50))
FROM RptDomainRelatedViews rdrv
JOIN RptViewFields rvf ON rdrv.DomainRelatedViewId = rvf.DomainRelatedViewId
WHERE rdrv.DisplayName = @DatasetName 
  AND rvf.DisplayName = @ColumnName;

-- Find all reports using this domain view
DECLARE @ReportsUsingDomainView TABLE (
    ReportDetailsId INT,
    ReportDetailsName NVARCHAR(255)
);

INSERT INTO @ReportsUsingDomainView
SELECT ReportDetailsId, ReportDetailsName 
FROM ReportDetails 
WHERE DomainRelatedViewId = @DomainRelatedViewId;

-- Find child reports that need field mapping (those linked to parent reports with this domain view)
DECLARE @ChildReportsToMap TABLE (
    ParentReportId INT,
    ChildReportId INT,
    ParentReportName NVARCHAR(255),
    ChildReportName NVARCHAR(255)
);

-- Get child reports that need mapping (only if they don't already have this column mapped)
INSERT INTO @ChildReportsToMap
SELECT DISTINCT
    lrmf.ReportDetailsId AS ParentReportId,
    rd.ReportDetailsId AS ChildReportId,
    parent.ReportDetailsName AS ParentReportName,
    rd.ReportDetailsName AS ChildReportName
FROM LinkedReportMappedFileds lrmf
JOIN ReportDetails rd ON lrmf.ChildReportId = rd.ReportDetailsId
JOIN ReportDetails parent ON lrmf.ReportDetailsId = parent.ReportDetailsId
WHERE lrmf.ReportDetailsId IN (SELECT ReportDetailsId FROM @ReportsUsingDomainView)
AND rd.DomainRelatedViewId = @DomainRelatedViewId
AND NOT EXISTS (
    SELECT 1 
    FROM LinkedReportMappedFileds existing
    WHERE existing.ReportDetailsId = lrmf.ReportDetailsId
      AND existing.ChildReportId = rd.ReportDetailsId
      AND existing.ParentColumnName = @ColumnName
);

-- Show what we found
SELECT * FROM @ChildReportsToMap;

-- Generate INSERT statements for needed child report mappings
SELECT 
    cr.ParentReportId,
    cr.ParentReportName,
    cr.ChildReportId,
    cr.ChildReportName,
    'INSERT INTO LinkedReportMappedFileds (ReportDetailsId, ChildReportId, ParentCode, ParentColumnName, ChildCode, ChildColumnName, IsValueField, DisplayName, TenantId, StatusId, CreatedBy, CreatedDate) VALUES (' +
    CAST(cr.ParentReportId AS NVARCHAR(20)) + ', ' +
    CAST(cr.ChildReportId AS NVARCHAR(20)) + ', ''' +
    @ColumnName + ''', ''' +
    @ColumnName + ''', ''' +
    @FieldId + ''', ''' +
    @ColumnName + ''', 0, ''' +
    @ColumnName + ''', ' +
    CAST(@TenantId AS NVARCHAR(10)) + ', 1, ''' +
    @CreatedBy + ''', GETDATE());' AS InsertStatement
FROM @ChildReportsToMap cr;

-- Only insert if debug mode is off
IF @DebugOnly = 0
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Insert mappings for child reports (only needed ones)
        INSERT INTO LinkedReportMappedFileds (
            ReportDetailsId,
            ChildReportId,
            ParentCode,
            ParentColumnName,
            ChildCode,
            ChildColumnName,
            IsValueField,
            DisplayName,
            TenantId,
            StatusId,
            CreatedBy,
            CreatedDate
        )
        SELECT 
            cr.ParentReportId,
            cr.ChildReportId,
            @ColumnName AS ParentCode,
            @ColumnName AS ParentColumnName,
            @FieldId AS ChildCode,
            @ColumnName AS ChildColumnName,
            0 AS IsValueField,
            @ColumnName AS DisplayName,
            @TenantId AS TenantId,
            1 AS StatusId,
            @CreatedBy AS CreatedBy,
            GETDATE() AS CreatedDate
        FROM @ChildReportsToMap cr;
        
        COMMIT TRANSACTION;
        
        SELECT 'LinkedReportMappedFileds inserts completed successfully' AS Result;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        SELECT 
            'Error' AS Result,
            ERROR_MESSAGE() AS ErrorMessage,
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_LINE() AS ErrorLine,
            ERROR_PROCEDURE() AS ErrorProcedure;
    END CATCH;
END
ELSE
BEGIN
    SELECT 'Debug mode - only showing proposed LinkedReportMappedFileds inserts. Set @DebugOnly = 0 to execute inserts.' AS Result;
END