ALTER PROCEDURE [dbo].[USP_UpdateAliasNameInReports]
    @OldAliasName VARCHAR(200),
    @NewAliasName VARCHAR(200),
    @TenantId INT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Declare internal variables with proper formatting for search and replace
    DECLARE @FormattedOldAliasName VARCHAR(202);
    DECLARE @FormattedNewAliasName VARCHAR(202);
    
    -- Add double quotes to the alias names for the actual search and replace
    SET @FormattedOldAliasName = '"' + @OldAliasName + '"';
    SET @FormattedNewAliasName = '"' + @NewAliasName + '"';
    
    BEGIN TRY
        -- Begin transaction
        BEGIN TRANSACTION;
        
        -- Create temporary table to store affected datasets
        IF OBJECT_ID('tempdb..#DatasetMatchList') IS NOT NULL   
            DROP TABLE #DatasetMatchList;
            
        -- Find all domain related views containing the old alias name
        SELECT DISTINCT DomainRelatedViewId 
        INTO #DatasetMatchList 
        FROM ReportDetails
        WHERE ReportFileDetails LIKE '%"AliasName":' + @FormattedOldAliasName + '%' 
          AND TenantId = @TenantId;
        
        -- Update the alias name in the report details
        UPDATE rd
        SET rd.ReportFileDetails = REPLACE(rd.ReportFileDetails, @FormattedOldAliasName, @FormattedNewAliasName)
        FROM ReportDetails rd
        JOIN #DatasetMatchList ds ON rd.DomainRelatedViewId = ds.DomainRelatedViewId
        WHERE rd.ReportFileDetails LIKE '%"AliasName":' + @FormattedOldAliasName + '%'
          AND rd.TenantId = @TenantId;
          
        -- Return affected datasets with their names and update status
        --SELECT 
        --    d.DomainRelatedViewId,
        --    rv.DisplayName AS DatasetName,
        --    'Updated "' + @OldAliasName + '" to "' + @NewAliasName + '"' AS Status,
        --    @@ROWCOUNT AS UpdatedRowCount
        --FROM #DatasetMatchList d
        --JOIN RptDomainRelatedViews rv ON d.DomainRelatedViewId = rv.DomainRelatedViewId;
        
        -- Clean up temporary table
        DROP TABLE #DatasetMatchList;
        
        -- Commit transaction if everything succeeded
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback transaction if there's an error and transaction is active
        IF XACT_STATE() = -1  
        BEGIN  
            ROLLBACK TRANSACTION;
        END  
        
        -- Declare variables for error logging
        DECLARE @ERRORFROMPROC VARCHAR(500);
        DECLARE @ERRORMESSAGE VARCHAR(1000);
        
        -- Get error details
        SELECT @ERRORFROMPROC = ERROR_PROCEDURE(),
               @ERRORMESSAGE = ERROR_MESSAGE();
        
        -- Log error to the application error log
        INSERT INTO IDM.APPERRORLOG (
            REQUESTURL,
            [MESSAGE],
            LOGDATETIME,
            TENANTID,
            ERRORTYPE
        )
        VALUES (
            @ERRORFROMPROC,
            @ERRORMESSAGE,
            GETDATE(),
            @TenantId,
            'DB'
        );
        
        -- Clean up temporary table if it exists
        IF OBJECT_ID('tempdb..#DatasetMatchList') IS NOT NULL   
            DROP TABLE #DatasetMatchList;
        
        -- Re-throw the error
        THROW;
    END CATCH;
END
GO