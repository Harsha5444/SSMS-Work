CREATE OR ALTER PROCEDURE [dbo].[USP_CreateMCASItemAnalysis_Tables] (@TenantId INT)
AS
BEGIN
	SET XACT_ABORT ON;
	SET NOCOUNT ON

	BEGIN TRY
		DECLARE @TenantCode VARCHAR(MAX);

		SET @TenantCode = (
				SELECT TenantCode
				FROM idm.Tenant
				WHERE TenantId = @TenantId
				);

		BEGIN
			DECLARE @Tbl1 NVARCHAR(MAX)
				,@Tbl2 NVARCHAR(MAX)
				,@Tbl3 NVARCHAR(MAX)
				,@Tbl4 NVARCHAR(MAX)

			IF NOT EXISTS (
					SELECT 1
					FROM INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = 'AggrptMCASItemAnalysis'
					)
			BEGIN
				SET @Tbl1 = 
					' CREATE TABLE [dbo].[AggrptMCASItemAnalysis] (  [SchoolYear] [varchar](20) NULL,[LEAIdentifier] [varchar](200) NULL,[SchoolIdentifier] [varchar](200) NULL,[AssessmentCode] [varchar](200) NULL,[ItemId] [varchar](200) NULL ,[ItemMaxScore] [varchar](200) NULL,[Itemtext] [varchar](2000) NULL,[ItemMinScore] [varchar](200) NULL,[SubjectAreaCode] [varchar](200) NULL,[ItemTypeCode] [varchar](200) NULL,[IsPublished] [varchar](20) NULL,[IsAdaptive] [varchar](200) NULL,[Grade] [varchar](200) NULL,[AssessmentItemCode] [varchar](200) NULL,[Reporting_Category] [varchar](200) NULL,[Reporting_Category_Number] [varchar](200) NULL,[MA_Curriculum_Framework] [varchar](2000) NULL,[Correct_Answer] [varchar](200) NULL,[State_Percent_Possible] [varchar](200) NULL,[District_Percent_Possible] [varchar](200) NULL,[School_Percent_Possible] [varchar](20) NULL,[School_State_Diff] [varchar](200) NULL,[School_Average_Points] [varchar](200) NULL,[District_Average_Points] [varchar](200) NULL,[State_Average_Points] [varchar](200) NULL,[TenantId] [int] NULL,[GradeDescription] [varchar](200) NULL,[LeaName] [varchar](200) NULL,[SchoolName] [varchar](200) NULL,[Avg_Correct] [varchar](200) NULL,[Diff_From_State] [varchar](200) NULL,[SubjectAreaDescription] [varchar](20) NULL,[SortOrder] [int] NULL,[ItemTypeDescription] [varchar](200) NULL,[Avg_School_Correct] [int] NULL 	) ON [PRIMARY]  ; '

				EXEC (@Tbl1)
			END

			IF NOT EXISTS (
					SELECT 1
					FROM INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = 'AggrptMCASItemStudentResults'
					)
			BEGIN
				SET @Tbl2 = 
					' CREATE TABLE [dbo].[AggrptMCASItemStudentResults] ( [LEAIdentifier] [varchar](200) NULL,[SchoolIdentifier] [varchar](200) NULL,[SchoolYear] [varchar](20) NULL,[AssessmentCode] [varchar](200) NULL,[ItemId] [varchar](200) NULL,[ItemMaxScore] [varchar](200) NULL,[Itemtext] [varchar](2000) NULL,[StudentScore] [varchar](200) NULL,[DistrictStudentId] [varchar](200) NULL,[ItemTypeCode] [varchar](200) NULL,[SubjectAreaCode] [varchar](200) NULL,[Reporting_Category] [varchar](200) NULL,[Reporting_Category_Number] [varchar](200) NULL,[MA_Curriculum_Framework] [varchar](2000) NULL,[Correct_Answer] [varchar](200) NULL,[State_Percent_Possible] [varchar](200) NULL,[District_Percent_Possible] [varchar](200) NULL,[School_Percent_Possible] [varchar](200) NULL,[School_State_Diff] [varchar](200) NULL,[School_Average_Points] [varchar](200) NULL,[District_Average_Points] [varchar](200) NULL,[State_Average_Points] [varchar](200) NULL,[grade] [varchar](200) NULL,[TenantId] [int] NULL,[gender] [varchar](200) NULL,[race] [Nvarchar] (200) NULL,[StudentName] [varchar](200) NULL,[FRL] [varchar](200) NULL,[DisabilityStatus] [varchar](200) NULL,[ELL] [varchar](200) NULL,[GradeDescription] [varchar](200) NULL,[LeaName] [varchar](200) NULL,[SchoolName] [varchar](200) NULL,[SubjectAreaDescription] [varchar](200) NULL,[IsCorrect] [varchar](200) NULL,[Avg_Correct] [varchar](200) NULL,[SortOrder] [int] NULL,[HighNeeds] [varchar](200) NULL,[ItemTypeDescription] [varchar](200) NULL,[Avg_School_Correct] [int] NULL,[HR_Teacher] [varchar](500) NULL,[DistrictStaffId] [varchar](500) NULL,[AggrptMCASItemStudentResultsId] [bigint] IDENTITY(1,1) NOT NULL, 	) ON [PRIMARY]  ; '

				EXEC (@Tbl2)
			END

			IF NOT EXISTS (
					SELECT 1
					FROM INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = @TenantCode + '_MCAS_ItemAnalysis_Math_ELA_Science'
					)
			BEGIN
				SET @Tbl3 = ' CREATE TABLE [dbo].[' + @TenantCode + '_MCAS_ItemAnalysis_Math_ELA_Science] (   [Item_Number] [varchar](50) NULL,[Reporting_Category] [varchar](50) NULL,[MA_Curriculum_Framework] [varchar](2000) NULL,[Practice_Category] [varchar](50) NULL,[Item_Type] [varchar](50) NULL,[Item_Description] [varchar](2000) NULL,[Correct_Answer] [varchar](50) NULL,[Release_Status] [varchar](50) NULL,[Max_Points] [varchar](50) NULL,[School_Average_Points] [varchar](50) NULL,[District_Average_Points] [varchar](50) NULL,[State_Average_Points] [varchar](50) NULL,[School_Percent_Possible] [varchar](50) NULL,[District_Percent_Possible] [varchar](50) NULL,[State_Percent_Possible] [varchar](50) NULL,[School_State_Diff] [varchar](50) NULL,[Grade] [varchar](50) NULL,[Reporting_Category_Number] [varchar](50) NULL,[Subject] [varchar](50) NULL,[SchoolYear] [varchar](10) NULL,[' + @TenantCode + 
					'_MCAS_ItemAnalysis_Math_ELA_ScienceMainId] INT IDENTITY(1,1) NOT NULL,[TenantId] INT NOT NULL,    PRIMARY KEY CLUSTERED  ( [' + @TenantCode + '_MCAS_ItemAnalysis_Math_ELA_ScienceMainId] ASC ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)   ) ON [PRIMARY] ; '

				EXEC (@Tbl3)
			END

			IF NOT EXISTS (
					SELECT 1
					FROM INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = @TenantCode + '_MCAS_Item_Links'
					)
			BEGIN
				SET @Tbl4 = 'CREATE TABLE [dbo].[' + @TenantCode + '_MCAS_Item_Links] (  [ItemIdentifier] NVARCHAR(255)  NULL,  [Year] FLOAT NULL,[ItemType] NVARCHAR(255)  NULL,[ItemDescription] NVARCHAR(255)  NULL,[ReportingCategory] NVARCHAR(255)  NULL,[Subject] NVARCHAR(255)  NULL,[Grade] NVARCHAR(255)  NULL,[ItemNumber]  FLOAT NULL,[URL] NVARCHAR(255)  NULL,[Itemlink] FLOAT NULL,[ItemIdentifier1]  NVARCHAR(255)  NULL,[Year1]   FLOAT NULL,[ItemType1]  NVARCHAR(255)  NULL,[ItemDescription1]  NVARCHAR(255)  NULL,[ReportingCategory1]  NVARCHAR(255)  NULL,[Subject1]  NVARCHAR(255)  NULL,[Grade1]  NVARCHAR(255)  NULL,[TenantId]  INT  NULL,[ItemLink1]  VARCHAR(1000)  NULL ) ON [PRIMARY];';

				EXEC (@Tbl4)
			END

			IF EXISTS (
					SELECT 1
					FROM INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = 'AggrptMCASItemStudentResults'
					)
			BEGIN
				IF NOT EXISTS (
						SELECT 1
						FROM sys.indexes
						WHERE name = 'NCIDX_AggrptMCASItemStudentResults_SubjectAreaCode_Reporting_Category'
							AND object_id = OBJECT_ID('dbo.AggrptMCASItemStudentResults')
						)
				BEGIN
					CREATE NONCLUSTERED INDEX [NCIDX_AggrptMCASItemStudentResults_SubjectAreaCode_Reporting_Category] ON [dbo].[AggrptMCASItemStudentResults] (
						[SubjectAreaCode]
						,[TenantId]
						,[DistrictStudentId]
						,[Reporting_Category]
						) INCLUDE (
						[IsCorrect]
						,[ItemTypeDescription]
						);
				END

				IF NOT EXISTS (
						SELECT 1
						FROM sys.indexes
						WHERE name = 'NCIDX_AggrptMCASItemStudentResults_Reporting_Category'
							AND object_id = OBJECT_ID('dbo.AggrptMCASItemStudentResults')
						)
				BEGIN
					CREATE NONCLUSTERED INDEX [NCIDX_AggrptMCASItemStudentResults_Reporting_Category] ON [dbo].[AggrptMCASItemStudentResults] (
						[SubjectAreaCode]
						,[TenantId]
						,[DistrictStudentId]
						) INCLUDE (
						[Reporting_Category]
						,[IsCorrect]
						,[ItemTypeDescription]
						);
				END
			END
		END
	END TRY

	BEGIN CATCH
		-- Test whether the transaction is uncommittable.                         
		IF XACT_STATE() = - 1
		BEGIN
			ROLLBACK TRAN;
		END;

		--Comment it if SP contains only SELECT statement                                             
		DECLARE @ErrorFromProc VARCHAR(500);
		DECLARE @ProcErrorMessage VARCHAR(1000);
		DECLARE @SeverityLevel INT;
		DECLARE @ErrorNumber INT = ERROR_NUMBER();

		SELECT @ErrorFromProc = '[dbo].[USP_CreateMCASItemAnalysis_Tables]'
			,@ProcErrorMessage = ERROR_MESSAGE()
			,@SeverityLevel = ERROR_SEVERITY();

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
			,GETDATE()
			,@Tenantid
			);

		RAISERROR (
				'Error Number-%d : Error Message-%s'
				,16
				,1
				,@ErrorNumber
				,@ProcErrorMessage
				)
	END CATCH;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[USP_CreateMCASItemAnalysis_Views] (@TenantId INT)
AS
BEGIN
	SET XACT_ABORT ON;
	SET NOCOUNT ON

	BEGIN TRY
		DECLARE @TenantCode VARCHAR(MAX);

		SET @TenantCode = (
				SELECT TenantCode
				FROM idm.Tenant
				WHERE TenantId = @TenantId
				);

		DECLARE @Tbl1 NVARCHAR(MAX)
			,@Tbl2 NVARCHAR(MAX)
			,@Tbl3 NVARCHAR(MAX)
			,@Tbl4 NVARCHAR(MAX)

		IF NOT EXISTS (
				SELECT 1
				FROM INFORMATION_SCHEMA.VIEWS
				WHERE TABLE_NAME = @TenantCode + '_MCASItemStudentTeacherResults_Maths_View'
				)
		BEGIN
			SET @Tbl1 = '
    CREATE OR ALTER VIEW [dbo].[' + @TenantCode + 
				'_MCASItemStudentTeacherResults_Maths_View] AS
    SELECT a.LEAIdentifier,a.SchoolIdentifier,a.SchoolYear,a.AssessmentCode,a.ItemId,a.ItemMaxScore,a.Itemtext,a.StudentScore,a.DistrictStudentId,a.ItemTypeCode,a.SubjectAreaCode,a.Reporting_Category,a.Reporting_Category_Number,a.MA_Curriculum_Framework,a.Correct_Answer,CAST(a.State_Percent_Possible AS INT) AS State_Percent_Possible,a.District_Percent_Possible,a.School_Percent_Possible,a.School_State_Diff,a.School_Average_Points,a.District_Average_Points,a.State_Average_Points,a.GradeDescription AS Grade,a.GradeDescription,a.TenantId,a.gender,a.race,a.StudentName,a.FRL,a.DisabilityStatus,a.ELL,a.LeaName,a.SchoolName,a.SubjectAreaDescription,CASE WHEN a.IsCorrect = 1 THEN ''Correct'' ELSE ''Incorrect'' END AS IsCorrect,CAST(a.Avg_Correct AS INT) AS Avg_Correct,a.SortOrder,a.HighNeeds,a.ItemTypeDescription,a.Avg_School_Correct,ISNULL(a.HR_Teacher, ''NA'') AS TeacherName,ISNULL(a.DistrictStaffId, ''NA'') AS DistrictStaffId  FROM AggrptMCASItemStudentResults a WITH (NOLOCK)  WHERE a.TenantId = ' 
				+ cast(@TenantId AS VARCHAR) + ' AND a.SubjectAreaCode = ''MATH''   '

			EXEC (@Tbl1)
		END

		IF NOT EXISTS (
				SELECT 1
				FROM INFORMATION_SCHEMA.VIEWS
				WHERE TABLE_NAME = @TenantCode + '_MCASItemStudentTeacherResults_Science_View'
				)
		BEGIN
			SET @Tbl2 = '
        CREATE OR ALTER VIEW [dbo].[' + @TenantCode + 
				'_MCASItemStudentTeacherResults_Science_View] AS
        SELECT a.LEAIdentifier,a.SchoolIdentifier,a.SchoolYear,a.AssessmentCode,a.ItemId,a.ItemMaxScore,a.Itemtext,a.StudentScore,a.DistrictStudentId, a.ItemTypeCode,a.SubjectAreaCode,a.Reporting_Category,a.Reporting_Category_Number,a.MA_Curriculum_Framework,a.Correct_Answer, CAST(a.State_Percent_Possible AS INT) AS State_Percent_Possible, a.District_Percent_Possible,a.School_Percent_Possible,a.School_State_Diff,a.School_Average_Points,a.District_Average_Points,a.State_Average_Points, a.GradeDescription AS Grade,a.TenantId,a.Gender,a.Race,a.StudentName,a.FRL,a.DisabilityStatus,a.ELL,a.GradeDescription,a.LeaName,a.SchoolName,a.SubjectAreaDescription, CASE WHEN a.IsCorrect = 1 THEN ''Correct'' ELSE ''Incorrect'' END AS IsCorrect, CAST(a.Avg_Correct AS INT) AS Avg_Correct, a.SortOrder,a.HighNeeds,a.ItemTypeDescription,a.Avg_School_Correct, ISNULL(a.HR_Teacher, ''NA'') AS TeacherName,ISNULL(a.DistrictStaffId, ''NA'') AS DistrictStaffId  FROM AggrptMCASItemStudentResults a WITH (NOLOCK)  WHERE a.TenantId = ' 
				+ CAST(@TenantId AS VARCHAR) + ' AND a.SubjectAreaCode = ''Science''    '

			EXEC (@Tbl2)
		END

		IF NOT EXISTS (
				SELECT 1
				FROM INFORMATION_SCHEMA.VIEWS
				WHERE TABLE_NAME = @TenantCode + '_MCASItemStudentTeacherResults_ELA_View'
				)
		BEGIN
			SET @Tbl3 = '
    CREATE OR ALTER VIEW [dbo].[' + @TenantCode + 
				'_MCASItemStudentTeacherResults_ELA_View] AS  
    SELECT  a.LEAIdentifier,a.SchoolIdentifier,a.SchoolYear,AssessmentCode,ItemId,ItemMaxScore,Itemtext,StudentScore,a.DistrictStudentId,  ItemTypeCode,SubjectAreaCode,Reporting_Category,Reporting_Category_Number,MA_Curriculum_Framework,Correct_Answer,  CAST([State_Percent_Possible] AS INT) AS State_Percent_Possible,  District_Percent_Possible,School_Percent_Possible,School_State_Diff,School_Average_Points,District_Average_Points,State_Average_Points,  GradeDescription AS grade,a.TenantId,gender,race,StudentName,FRL,DisabilityStatus,ELL,GradeDescription,LeaName,SchoolName,SubjectAreaDescription,  CASE WHEN [IsCorrect] = 1 THEN ''Correct'' ELSE ''Incorrect'' END AS IsCorrect,  CAST(Avg_Correct AS INT) AS Avg_Correct,  SortOrder,HighNeeds,ItemTypeDescription,Avg_School_Correct, ISNULL(a.HR_Teacher, ''NA'') AS TeacherName,ISNULL(DistrictStaffId, ''NA'') AS DistrictStaffId  FROM AggrptMCASItemStudentResults a WITH (NOLOCK) WHERE a.TenantId = ' 
				+ CAST(@TenantId AS VARCHAR) + '   AND a.SubjectAreaCode = ''ELA''  AND a.Reporting_Category <> ''Language, Writing''   '

			EXEC (@Tbl3)
		END

		IF NOT EXISTS (
				SELECT 1
				FROM INFORMATION_SCHEMA.VIEWS
				WHERE TABLE_NAME = @TenantCode + '_AggrptMCASItemAnalysis_School_View'
				)
		BEGIN
			SET @Tbl4 = '
CREATE OR ALTER VIEW [dbo].[' + @TenantCode + 
				'_AggrptMCASItemAnalysis_School_View] AS 
SELECT DISTINCT  a.SchoolYear, a.AssessmentCode,a.ItemId,a.ItemMaxScore,a.ItemText,a.ItemMinScore,a.SubjectAreaCode,a.SubjectAreaDescription,a.ItemTypeCode,a.Grade AS GradeDescription,a.AssessmentItemCode,a.Reporting_Category,a.Reporting_Category_Number,a.MA_Curriculum_Framework,a.Correct_Answer,CAST(a.State_Percent_Possible AS VARCHAR) AS State_Percent_Possible,a.District_Percent_Possible,a.School_Percent_Possible,a.School_State_Diff,a.School_Average_Points,a.District_Average_Points,a.State_Average_Points,a.TenantId,a.GradeDescription AS Grade,CAST(a.Avg_Correct AS INT) AS Avg_Correct,a.Avg_School_Correct,CAST(a.Diff_From_State AS INT) AS Diff_From_State,a.Avg_School_Correct - CAST(a.Avg_Correct AS INT) AS Diff_From_District,a.Avg_School_Correct - CAST(REPLACE(a.State_Percent_Possible, ''%'', '''') AS INT) AS Diff_From_School_State,a.SortOrder,a.ItemTypeDescription,a.LEAIdentifier,a.LeaName,a.SchoolIdentifier,a.SchoolName,b.ItemLink  FROM [dbo].[AggrptMCASItemAnalysis] a WITH (NOLOCK)LEFT JOIN [dbo].[' 
				+ @TenantCode + '_MCAS_Item_Links] b WITH (NOLOCK)   ON a.SchoolYear = b.[Year]  AND a.ItemId = CASE  WHEN b.Subject = ''ELA'' THEN ''eitem'' + CAST(b.[ItemNumber] AS VARCHAR(100))  WHEN b.Subject = ''Math'' THEN ''mitem'' + CAST(b.[ItemNumber] AS VARCHAR(100)) WHEN b.Subject = ''Science'' THEN ''sitem'' + CAST(b.[ItemNumber] AS VARCHAR(100))  END  AND a.SubjectAreaCode = b.[Subject]  AND REPLACE(a.GradeDescription, '' '', ''_'') = b.Grade ; ';

			EXEC (@Tbl4)
		END
	END TRY

	BEGIN CATCH
		-- Test whether the transaction is uncommittable.                         
		IF XACT_STATE() = - 1
		BEGIN
			ROLLBACK TRAN;
		END;

		--Comment it if SP contains only SELECT statement                                             
		DECLARE @ErrorFromProc VARCHAR(500);
		DECLARE @ProcErrorMessage VARCHAR(1000);
		DECLARE @SeverityLevel INT;
		DECLARE @ErrorNumber INT = ERROR_NUMBER();

		SELECT @ErrorFromProc = '[dbo].[USP_CreateMCASItemAnalysis_Views]'
			,@ProcErrorMessage = ERROR_MESSAGE()
			,@SeverityLevel = ERROR_SEVERITY();

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
			,GETDATE()
			,@Tenantid
			);

		RAISERROR (
				'Error Number-%d : Error Message-%s'
				,16
				,1
				,@ErrorNumber
				,@ProcErrorMessage
				)
	END CATCH;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[USP_CreateMCASItemAnalysis_Dataset] (@TenantId INT)
AS
BEGIN
	SET XACT_ABORT ON;
	SET NOCOUNT ON

	BEGIN TRY
		DECLARE @TenantCode VARCHAR(MAX);

		SET @TenantCode = (
				SELECT TenantCode
				FROM idm.Tenant
				WHERE TenantId = @TenantId
				);

		DECLARE @Tbl1 NVARCHAR(MAX)
			,@Tbl2 NVARCHAR(MAX)
			,@Tbl3 NVARCHAR(MAX)
			,@Tbl4 NVARCHAR(MAX)
			,@Tbl5 NVARCHAR(MAX)
			,@Tbl6 NVARCHAR(MAX)

		IF NOT EXISTS (
				SELECT 1
				FROM INFORMATION_SCHEMA.VIEWS
				WHERE TABLE_NAME = @TenantCode + 'MCASItemStudentTeacherResultsMathsDS'
				)
		BEGIN
			SET @Tbl1 = '
CREATE Or alter VIEW [dbo].[' + @TenantCode + 
				'MCASItemStudentTeacherResultsMathsDS] AS
Select [IsCorrect] AS [IsCorrect],[TeacherName] AS [TeacherName],[DistrictStaffId] AS [DistrictStaffId],[Avg_Correct] AS [Avg_Correct],[SortOrder] AS [SortOrder],[HighNeeds] AS [HighNeeds],[ItemTypeDescription] AS [ItemTypeDescription],[Avg_School_Correct] AS [Avg_School_Correct],[LEAIdentifier] AS [LEAIdentifier],[SchoolIdentifier] AS [SchoolIdentifier],[SchoolYear] AS [SchoolYear],[AssessmentCode] AS [AssessmentCode],[ItemId] AS [ItemId],[ItemMaxScore] AS [ItemMaxScore],[Itemtext] AS [Itemtext],[StudentScore] AS [StudentScore],[DistrictStudentId] AS [DistrictStudentId],[ItemTypeCode] AS [ItemTypeCode],[SubjectAreaCode] AS [SubjectAreaCode],[Reporting_Category] AS [Reporting_Category],[Reporting_Category_Number] AS [Reporting_Category_Number],[MA_Curriculum_Framework] AS [MA_Curriculum_Framework],[Correct_Answer] AS [Correct_Answer],[State_Percent_Possible] AS [State_Percent_Possible],[District_Percent_Possible] AS [District_Percent_Possible],[School_Percent_Possible] AS [School_Percent_Possible],[School_State_Diff] AS [School_State_Diff],[School_Average_Points] AS [School_Average_Points],[District_Average_Points] AS [District_Average_Points],[State_Average_Points] AS [State_Average_Points],[grade] AS [grade],[gender] AS [gender],[race] AS [race],[StudentName] AS [StudentName],[FRL] AS [FRL],[DisabilityStatus] AS [DisabilityStatus],[ELL] AS [ELL],[GradeDescription] AS [GradeDescription],[LeaName] AS [LeaName],[SchoolName] AS [SchoolName],[SubjectAreaDescription] AS [SubjectAreaDescription] ,TenantId FROM  dbo.' 
				+ @TenantCode + '_MCASItemStudentTeacherResults_Maths_View where TenantId=' + CAST(@TenantId AS VARCHAR) + '     '

			EXEC (@Tbl1)
		END

		IF NOT EXISTS (
				SELECT 1
				FROM INFORMATION_SCHEMA.VIEWS
				WHERE TABLE_NAME = @TenantCode + 'MCASItemStudentTeacherResultsScienceDS'
				)
		BEGIN
			SET @Tbl2 = '
CREATE OR ALTER VIEW [dbo].[' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS] AS
SELECT  [IsCorrect],[TeacherName],[DistrictStaffId],[Avg_Correct],[SortOrder],[HighNeeds],[ItemTypeDescription],[Avg_School_Correct],[LEAIdentifier],[SchoolIdentifier],[SchoolYear],[AssessmentCode],[ItemId],[ItemMaxScore],[Itemtext],[StudentScore],[DistrictStudentId],[ItemTypeCode],[SubjectAreaCode],[Reporting_Category],[Reporting_Category_Number],[MA_Curriculum_Framework],[Correct_Answer],[State_Percent_Possible],[District_Percent_Possible],[School_Percent_Possible],[School_State_Diff],[School_Average_Points],[District_Average_Points],[State_Average_Points],[Grade],[Gender],[Race],[StudentName],[FRL],[DisabilityStatus],[ELL],[GradeDescription],[LeaName],[SchoolName],[SubjectAreaDescription],[TenantId] FROM dbo.' + @TenantCode + '_MCASItemStudentTeacherResults_Science_View WHERE TenantId = ' + CAST(@TenantId AS VARCHAR) + ' '

			EXEC (@Tbl2)
		END

		IF NOT EXISTS (
				SELECT 1
				FROM INFORMATION_SCHEMA.VIEWS
				WHERE TABLE_NAME = @TenantCode + 'MCASItemStudentTeacherResultsELADS'
				)
		BEGIN
			SET @Tbl3 = ' CREATE OR ALTER VIEW [dbo].[' + @TenantCode + 'MCASItemStudentTeacherResultsELADS] AS
SELECT IsCorrect,TeacherName,DistrictStaffId,Avg_Correct,SortOrder,HighNeeds,ItemTypeDescription,Avg_School_Correct,LEAIdentifier,SchoolIdentifier,SchoolYear,AssessmentCode,ItemId,ItemMaxScore,Itemtext,StudentScore,DistrictStudentId,ItemTypeCode,SubjectAreaCode,Reporting_Category,Reporting_Category_Number,MA_Curriculum_Framework,Correct_Answer,State_Percent_Possible,District_Percent_Possible,School_Percent_Possible,School_State_Diff,School_Average_Points,District_Average_Points,State_Average_Points,grade,gender,race,StudentName,FRL,DisabilityStatus,ELL,GradeDescription,LeaName,SchoolName,SubjectAreaDescription,TenantId FROM dbo.' + @TenantCode + '_MCASItemStudentTeacherResults_ELA_View WHERE TenantId = ' + CAST(@TenantId AS NVARCHAR) + ' '

			EXEC sp_executesql @Tbl3
		END

		IF NOT EXISTS (
				SELECT 1
				FROM INFORMATION_SCHEMA.VIEWS
				WHERE TABLE_NAME = @TenantCode + 'AggrptMCASItemAnalysisDS'
				)
		BEGIN
			SET @Tbl4 = ' CREATE OR ALTER VIEW [dbo].[' + @TenantCode + 'AggrptMCASItemAnalysisDS] AS
SELECT  [SchoolYear],[AssessmentCode],[ItemId],[ItemMaxScore],[Itemtext],[ItemMinScore],[SubjectAreaCode],[SubjectAreaDescription],[ItemTypeCode],[GradeDescription],[AssessmentItemCode],[Reporting_Category],[Reporting_Category_Number],[MA_Curriculum_Framework],[Correct_Answer],[State_Percent_Possible],[District_Percent_Possible],[School_Percent_Possible],[School_State_Diff],[School_Average_Points],[District_Average_Points],[State_Average_Points],[Grade],[Avg_Correct],[Avg_School_Correct],[Diff_From_State],[Diff_From_District],[Diff_From_School_State],[SortOrder],[ItemTypeDescription],[LEAIdentifier],[LeaName],[SchoolIdentifier],[SchoolName],[itemlink],TenantId FROM dbo.' + @TenantCode + '_AggrptMCASItemAnalysis_School_View WHERE TenantId = ' + CAST(@TenantId AS NVARCHAR) + ' '

			EXEC (@Tbl4)
		END

		IF NOT EXISTS (
				SELECT 1
				FROM INFORMATION_SCHEMA.VIEWS
				WHERE TABLE_NAME = @TenantCode + 'MCASItemAnalysisMathematicsDS'
				)
		BEGIN
			SET @Tbl5 = ' CREATE OR ALTER VIEW [dbo].[' + @TenantCode + 'MCASItemAnalysisMathematicsDS] AS 
SELECT  [SchoolYear],[AssessmentCode],[ItemId],[ItemMaxScore],[Itemtext],[ItemMinScore],[SubjectAreaCode],[SubjectAreaDescription],[ItemTypeCode],[GradeDescription],[AssessmentItemCode],[Reporting_Category],[Reporting_Category_Number],[MA_Curriculum_Framework],[Correct_Answer],[State_Percent_Possible],[District_Percent_Possible],[School_Percent_Possible],[School_State_Diff],[School_Average_Points],[District_Average_Points],[State_Average_Points],[Grade],[Avg_Correct],[Avg_School_Correct],[Diff_From_State],[Diff_From_District],[Diff_From_School_State],[SortOrder],[ItemTypeDescription],[LEAIdentifier],[LeaName],[SchoolIdentifier],[SchoolName],TenantId FROM dbo.' + @TenantCode + '_AggrptMCASItemAnalysis_School_View WHERE SubjectAreaCode = ''MATH'' AND TenantId = ' + CAST(@TenantId AS NVARCHAR) + ' '

			EXEC (@Tbl5);
		END

		IF NOT EXISTS (
				SELECT 1
				FROM INFORMATION_SCHEMA.VIEWS
				WHERE TABLE_NAME = @TenantCode + '_MCAS_Item_SortOrder_Vw'
				)
		BEGIN
			SET @Tbl6 = ' CREATE Or Alter View ' + @TenantCode + '_MCAS_Item_SortOrder_Vw  
as 
SELECT Distinct itemid,CASE WHEN itemid LIKE ''eitem%'' THEN CAST(SUBSTRING(itemid, 6, LEN(itemid)-5) AS INT)  WHEN itemid LIKE ''mitem%'' THEN 32 + CAST(SUBSTRING(itemid, 6, LEN(itemid)-5) AS INT)  WHEN itemid LIKE ''sitem%'' THEN 74 + CAST(SUBSTRING(itemid, 6, LEN(itemid)-5) AS INT)  ELSE NULL  END AS SortOrder,TenantId  FROM  [dbo].[' + @TenantCode + '_AggrptMCASItemAnalysis_School_View] '

			EXEC (@Tbl6)
		END
	END TRY

	BEGIN CATCH
		-- Test whether the transaction is uncommittable.                         
		IF XACT_STATE() = - 1
		BEGIN
			ROLLBACK TRAN;
		END;

		--Comment it if SP contains only SELECT statement                                             
		DECLARE @ErrorFromProc VARCHAR(500);
		DECLARE @ProcErrorMessage VARCHAR(1000);
		DECLARE @SeverityLevel INT;
		DECLARE @ErrorNumber INT = ERROR_NUMBER();

		SELECT @ErrorFromProc = '[dbo].[USP_CreateMCASItemAnalysis_Dataset]'
			,@ProcErrorMessage = ERROR_MESSAGE()
			,@SeverityLevel = ERROR_SEVERITY();

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
			,GETDATE()
			,@Tenantid
			);

		RAISERROR (
				'Error Number-%d : Error Message-%s'
				,16
				,1
				,@ErrorNumber
				,@ProcErrorMessage
				)
	END CATCH;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[USP_MCAS_ItemAnalysis_Links_Math_ELA_Science_Loading] (@TenantId INT)
AS
BEGIN
	SET XACT_ABORT ON;
	SET NOCOUNT ON

	BEGIN TRY
		DECLARE @TenantCode VARCHAR(MAX);

		SET @TenantCode = (
				SELECT TenantCode
				FROM idm.Tenant
				WHERE TenantId = @TenantId
				);

		DECLARE @SQL NVARCHAR(MAX)
			,@SQL1 NVARCHAR(MAX);

		IF EXISTS (
				SELECT 1
				FROM INFORMATION_SCHEMA.TABLES
				WHERE TABLE_NAME = @TenantCode + '_MCAS_Item_Links'
				)
		BEGIN
			SET @SQL = N'  INSERT INTO [dbo].' + QUOTENAME(@TenantCode + '_MCAS_Item_Links') + N'
Select * from (SELECT [ItemIdentifier],[Year],[ItemType],[ItemDescription],[ReportingCategory],[Subject],[Grade],[ItemNumber],[URL],[Itemlink],[ItemIdentifier1],[Year1],[ItemType1],[ItemDescription1],[ReportingCategory1],[Subject1],[Grade1],' + Cast(@TenantID AS VARCHAR(100)) + ' as TenantId,[ItemLink1]
FROM AnalyticVue.dbo.MCASItemLinks a ) a  WHERE NOT EXISTS (  SELECT 1 FROM [dbo].' + QUOTENAME(@TenantCode + '_MCAS_Item_Links') + N' b where a.[Year]=b.[Year] and a.[ItemIdentifier]=b.[ItemIdentifier] and  a.[Tenantid]=b.[Tenantid] )  ;'

			EXEC sp_executesql @SQL;
		END

		IF EXISTS (
				SELECT 1
				FROM INFORMATION_SCHEMA.TABLES
				WHERE TABLE_NAME = @TenantCode + '_MCAS_ItemAnalysis_Math_ELA_Science'
				)
		BEGIN
			SET @SQL = N' INSERT INTO [dbo].' + QUOTENAME(@TenantCode + '_MCAS_ItemAnalysis_Math_ELA_Science') + N'
SELECT * FROM (SELECT Item_Number,Reporting_Category,MA_Curriculum_Framework,Practice_Category,Item_Type,Item_Description,Correct_Answer,Release_Status,Max_Points,School_Average_Points,District_Average_Points,State_Average_Points,School_Percent_Possible,District_Percent_Possible,State_Percent_Possible,School_State_Diff,Grade,Reporting_Category_Number,Subject,SchoolYear,' + cast(@TenantId AS VARCHAR) + '[TenantId] 
FROM AnalyticVue.dbo.MCASItemAnalysisReportingCategory a ) a WHERE NOT EXISTS ( SELECT 1 FROM [dbo].' + QUOTENAME(@TenantCode + '_MCAS_ItemAnalysis_Math_ELA_Science') + N' b  WHERE Isnull(a.Item_Number,'''') = isnull(b.Item_Number,'''')  AND Isnull(a.[Subject],'''') = Isnull(b.[Subject],'''') AND Isnull(a.Item_Type,'''') = isnull(b.Item_Type,'''') AND isnull(a.SchoolYear,'''') = isnull(b.SchoolYear,'''') AND a.TenantId = b.TenantId ) ; ';

			EXEC sp_executesql @SQL;

			SET @SQL1 = N' Update ms set Grade=GradeCode from [dbo].' + QUOTENAME(@TenantCode + '_MCAS_ItemAnalysis_Math_ELA_Science') + N'  ms 
		Join RefGrade rg On ms.Tenantid=rg.TenantId and ((case when ms.Grade in (''1'',''2'',''3'',''4'',''5'',''6'',''7'',''8'',''9'') Then ''0''+ms.Grade	Else ms.Grade end) =rg.GradeCode or (case when ms.Grade in (''01'',''02'',''03'',''04'',''05'',''06'',''07'',''08'',''09'') Then replace(ms.Grade,''0'','''') Else ms.Grade end ) = rg.GradeCode  ) ;'

			EXEC sp_executesql @SQL1;
		END
	END TRY

	BEGIN CATCH
		-- Test whether the transaction is uncommittable.                         
		IF XACT_STATE() = - 1
		BEGIN
			ROLLBACK TRAN;
		END;

		--Comment it if SP contains only SELECT statement                                             
		DECLARE @ErrorFromProc VARCHAR(500);
		DECLARE @ProcErrorMessage VARCHAR(1000);
		DECLARE @SeverityLevel INT;
		DECLARE @ErrorNumber INT = ERROR_NUMBER();

		SELECT @ErrorFromProc = '[dbo].[USP_MCAS_ItemAnalysis_Links_Math_ELA_Science_Loading]'
			,@ProcErrorMessage = ERROR_MESSAGE()
			,@SeverityLevel = ERROR_SEVERITY();

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
			,GETDATE()
			,@Tenantid
			);

		RAISERROR (
				'Error Number-%d : Error Message-%s'
				,16
				,1
				,@ErrorNumber
				,@ProcErrorMessage
				)
	END CATCH;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[USP_MCASItemAnalysis_Reporting_CategoryUpdation] (@TenantId INT)
AS
BEGIN
	SET XACT_ABORT ON;
	SET NOCOUNT ON

	BEGIN TRY
		DECLARE @TenantCode VARCHAR(MAX);

		SET @TenantCode = (
				SELECT TenantCode
				FROM idm.Tenant
				WHERE TenantId = @TenantId
				);

		BEGIN
			IF EXISTS (
					SELECT 1
					FROM INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = @TenantCode + '_MCAS_ItemAnalysis_Math_ELA_Science'
					)
			BEGIN
				DECLARE @SQL NVARCHAR(MAX);
				DECLARE @Grade3To10 VARCHAR(MAX)
					,@Grade3To5 VARCHAR(MAX)
					,@Grade5To8 VARCHAR(MAX);
				DECLARE @DynamicSQL NVARCHAR(MAX);

				SET @DynamicSQL = '
            SELECT @Grade3To5_OUT = STRING_AGG(QUOTENAME(Grade, ''''''''), '','')
            FROM (SELECT DISTINCT Grade FROM dbo.' + QUOTENAME(@TenantCode + '_MCAS_ItemAnalysis_Math_ELA_Science') + ' WHERE Grade IN (''3'',''4'',''5'',''03'',''04'',''05'')  ) a;

            SELECT @Grade5To8_OUT = STRING_AGG(QUOTENAME(Grade, ''''''''), '','')  FROM (SELECT DISTINCT Grade FROM dbo.' + QUOTENAME(@TenantCode + '_MCAS_ItemAnalysis_Math_ELA_Science') + ' WHERE Grade IN (''5'',''6'',''7'',''8'',''05'',''06'',''07'',''08'')   ) a;

            SELECT @Grade3To10_OUT = STRING_AGG(QUOTENAME(Grade, ''''''''), '','') FROM (SELECT DISTINCT Grade FROM dbo.' + QUOTENAME(@TenantCode + '_MCAS_ItemAnalysis_Math_ELA_Science') + '  WHERE Grade IN (''3'',''4'',''5'',''6'',''7'',''8'',''9'',''10'',''03'',''04'',''05'',''06'',''07'',''08'',''09'',''10'') ) a;
            ';

				EXEC sp_executesql @DynamicSQL
					,N'@Grade3To5_OUT VARCHAR(MAX) OUTPUT, @Grade5To8_OUT VARCHAR(MAX) OUTPUT, @Grade3To10_OUT VARCHAR(MAX) OUTPUT'
					,@Grade3To5_OUT = @Grade3To5 OUTPUT
					,@Grade5To8_OUT = @Grade5To8 OUTPUT
					,@Grade3To10_OUT = @Grade3To10 OUTPUT;

				SET @SQL = 'UPDATE a SET Reporting_Category_Number = NULL  FROM dbo.' + QUOTENAME(@TenantCode + '_MCAS_ItemAnalysis_Math_ELA_Science') + ' a;';

				EXEC sp_executesql @SQL;

				SET @SQL = 'UPDATE a SET Reporting_Category_Number = ''Reporting Category 1'' FROM dbo.' + QUOTENAME(@TenantCode + '_MCAS_ItemAnalysis_Math_ELA_Science') + ' a  WHERE a.Subject = ''ELA'' AND a.Grade IN (' + @Grade3To10 + ') AND a.Reporting_Category = ''Reading'';';

				EXEC sp_executesql @SQL;

				SET @SQL = 'UPDATE a SET Reporting_Category_Number = ''Reporting Category 2'' FROM dbo.' + QUOTENAME(@TenantCode + '_MCAS_ItemAnalysis_Math_ELA_Science') + ' a WHERE a.Subject = ''ELA'' AND a.Grade IN (' + @Grade3To10 + ') AND a.Reporting_Category = ''Language'';';

				EXEC sp_executesql @SQL;

				SET @SQL = 'UPDATE a SET Reporting_Category_Number = ''Reporting Category 3''  FROM dbo.' + QUOTENAME(@TenantCode + '_MCAS_ItemAnalysis_Math_ELA_Science') + ' a WHERE a.Subject = ''ELA'' AND a.Grade IN (' + @Grade3To10 + ') AND a.Reporting_Category = ''Language, Writing'';';

				EXEC sp_executesql @SQL;

				-- Math updates
				SET @SQL = 'UPDATE a SET Reporting_Category_Number = ''Reporting Category 1'' FROM dbo.' + QUOTENAME(@TenantCode + '_MCAS_ItemAnalysis_Math_ELA_Science') + ' a WHERE a.Subject = ''MATH'' AND a.Grade IN ( ' + @Grade3To5 + ' ) AND a.Reporting_Category = ''Operations and Algebraic Thinking'';';

				EXEC sp_executesql @SQL;

				SET @SQL = 'UPDATE a SET Reporting_Category_Number = ''Reporting Category 2'' FROM dbo.' + QUOTENAME(@TenantCode + '_MCAS_ItemAnalysis_Math_ELA_Science') + ' a WHERE a.Subject = ''MATH'' AND a.Grade IN ( ' + @Grade3To5 + ' ) AND a.Reporting_Category = ''Number and Operations in Base Ten'';';

				EXEC sp_executesql @SQL;

				SET @SQL = 'UPDATE a SET Reporting_Category_Number = ''Reporting Category 3'' FROM dbo.' + QUOTENAME(@TenantCode + '_MCAS_ItemAnalysis_Math_ELA_Science') + ' a WHERE a.Subject = ''MATH'' AND a.Grade IN ( ' + @Grade3To5 + ' ) AND a.Reporting_Category = ''Number and Operations-Fractions'';';

				EXEC sp_executesql @SQL;

				SET @SQL = 'UPDATE a SET Reporting_Category_Number = ''Reporting Category 4'' FROM dbo.' + QUOTENAME(@TenantCode + '_MCAS_ItemAnalysis_Math_ELA_Science') + ' a WHERE a.Subject = ''MATH'' AND a.Grade IN ( ' + @Grade3To5 + ' ) AND a.Reporting_Category = ''Measurement and Data'';';

				EXEC sp_executesql @SQL;

				SET @SQL = 'UPDATE a SET Reporting_Category_Number = ''Reporting Category 5'' FROM dbo.' + QUOTENAME(@TenantCode + '_MCAS_ItemAnalysis_Math_ELA_Science') + ' a WHERE a.Subject = ''MATH'' AND a.Grade IN ( ' + @Grade3To5 + ' ) AND a.Reporting_Category = ''Geometry'';';

				EXEC sp_executesql @SQL;

				-- Science updates
				SET @SQL = 'UPDATE a SET Reporting_Category_Number = ''Reporting Category 1'' FROM dbo.' + QUOTENAME(@TenantCode + '_MCAS_ItemAnalysis_Math_ELA_Science') + ' a WHERE a.Subject = ''Science'' AND a.Grade IN ( ' + @Grade5To8 + ' ) AND a.Reporting_Category = ''Earth and Space Science'';';

				EXEC sp_executesql @SQL;

				SET @SQL = 'UPDATE a SET Reporting_Category_Number = ''Reporting Category 2'' FROM dbo.' + QUOTENAME(@TenantCode + '_MCAS_ItemAnalysis_Math_ELA_Science') + ' a WHERE a.Subject = ''Science'' AND a.Grade IN ( ' + @Grade5To8 + ')  AND a.Reporting_Category = ''Life Science'';';

				EXEC sp_executesql @SQL;

				SET @SQL = 'UPDATE a SET Reporting_Category = ''Physical Sciences'' FROM dbo.' + QUOTENAME(@TenantCode + '_MCAS_ItemAnalysis_Math_ELA_Science') + ' a WHERE a.Subject = ''Science'' AND a.Grade IN ( ' + @Grade5To8 + ') AND a.Reporting_Category = ''Physical Science'';';

				EXEC sp_executesql @SQL;

				SET @SQL = 'UPDATE a SET Reporting_Category_Number = ''Reporting Category 3'' FROM dbo.' + QUOTENAME(@TenantCode + '_MCAS_ItemAnalysis_Math_ELA_Science') + ' a  WHERE a.Subject = ''Science'' AND a.Grade IN ( ' + @Grade5To8 + ')  AND a.Reporting_Category = ''Physical Sciences'';';

				EXEC sp_executesql @SQL;

				SET @SQL = 'UPDATE a SET Reporting_Category_Number = ''Reporting Category 4''  FROM dbo.' + QUOTENAME(@TenantCode + '_MCAS_ItemAnalysis_Math_ELA_Science') + ' a  WHERE a.Subject = ''Science'' AND a.Grade IN ( ' + @Grade5To8 + ')  AND a.Reporting_Category = ''Technology/Engineering'';';

				EXEC sp_executesql @SQL;
			END
		END
	END TRY

	BEGIN CATCH
		-- Test whether the transaction is uncommittable.                         
		IF XACT_STATE() = - 1
		BEGIN
			ROLLBACK TRAN;
		END;

		--Comment it if SP contains only SELECT statement                                             
		DECLARE @ErrorFromProc VARCHAR(500);
		DECLARE @ProcErrorMessage VARCHAR(1000);
		DECLARE @SeverityLevel INT;
		DECLARE @ErrorNumber INT = ERROR_NUMBER();

		SELECT @ErrorFromProc = '[dbo].[USP_MCASItemAnalysis_Reporting_CategoryUpdation]'
			,@ProcErrorMessage = ERROR_MESSAGE()
			,@SeverityLevel = ERROR_SEVERITY();

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
			,GETDATE()
			,@Tenantid
			);

		RAISERROR (
				'Error Number-%d : Error Message-%s'
				,16
				,1
				,@ErrorNumber
				,@ProcErrorMessage
				)
	END CATCH;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[USP_AggrptMCASItemAnalysis_DataLoading] (@TenantId INT,@SchoolYear VARCHAR(200))
AS
BEGIN
	SET XACT_ABORT ON;
	SET NOCOUNT ON

	BEGIN TRY
		DECLARE @TenantCode VARCHAR(MAX)
			,@LEAIdentifier VARCHAR(500);

		SET @TenantCode = (
				SELECT TenantCode
				FROM idm.Tenant
				WHERE TenantId = @TenantId
				);

		SELECT @LEAIdentifier = LEAIdentifier
		FROM main.K12LEA
		WHERE TenantId = @TenantId;

		DECLARE @SQL NVARCHAR(MAX)
			,@SQL1 NVARCHAR(MAX)
			,@SQL2 NVARCHAR(MAX)
			,@SQL3 NVARCHAR(MAX)
			,@SQL4 NVARCHAR(MAX)
			,@SQL5 NVARCHAR(MAX)
			,@SQL6 NVARCHAR(MAX)
		DECLARE @SchoolYearTable TABLE (SchoolYear VARCHAR(10));

		-- Split the input years
		INSERT INTO @SchoolYearTable (SchoolYear)
		SELECT LTRIM(RTRIM(value))
		FROM STRING_SPLIT(@SchoolYear, ',');

		DECLARE @CurrentYear VARCHAR(10);

		---------------------------------------------------------
		-- Loop through each school year
		---------------------------------------------------------
		DECLARE YearCursor CURSOR
		FOR
		SELECT SchoolYear
		FROM @SchoolYearTable;

		OPEN YearCursor;

		FETCH NEXT
		FROM YearCursor
		INTO @CurrentYear;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @SQL5 = N'   
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = ''' + @TenantCode + '_MCAS_' + @CurrentYear + ''')
BEGIN
Update m set m.DistrictStudentId=st.DistrictStudentId from Main.' + @TenantCode + '_MCAS_' + @CurrentYear + ' m  Join AggRptK12StudentDetails st On m.sasid=st.StateStudentId  and m.Tenantid=st.Tenantid where m.SchoolYear= ' + @CurrentYear + ' and m.DistrictStudentId is null 
End 
'

			EXEC sp_executesql @SQL5

			SET @SQL = N'
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = ''' + @TenantCode + '_MCAS_' + @CurrentYear + ''')
BEGIN
insert into AggrptMCASItemAnalysis (SchoolYear,LEAIdentifier,SchoolIdentifier,AssessmentCode,ItemId,ItemMaxScore,Itemtext,ItemMinScore,SubjectAreaCode,ItemTypeCode,IsPublished,IsAdaptive,Grade,AssessmentItemCode,Reporting_Category,Reporting_Category_Number,MA_Curriculum_Framework,Correct_Answer,State_Percent_Possible,District_Percent_Possible,School_Percent_Possible,School_State_Diff,School_Average_Points,District_Average_Points,State_Average_Points,TenantId,SortOrder,SubjectAreaDescription)
select DISTINCT SchoolYear,''' + @LEAIdentifier + 
				''' as LEAIdentifier,SchoolIdentifier,AssessmentCode,ItemId,ItemMaxScore,Itemtext,ItemMinScore,SubjectAreaCode,ItemTypeCode,[IsPublished],[IsAdaptive],Grade,AssessmentItemCode ,Reporting_Category,Reporting_Category_Number,[Standard],Correct_Answer,State_Percent_Possible,District_Percent_Possible,School_Percent_Possible,School_State_Diff,School_Average_Points,District_Average_Points,State_Average_Points,TenantId,SortOrder	,SubjectAreaDescription
from ( 	SELECT DISTINCT T.SchoolYear,LEAIdentifier,SchoolIdentifier,AssessmentCode	,ItemId1 ItemId,ss.max_points ItemMaxScore,ss.item_Description Itemtext,ItemMinScore,SubjectAreaCode,ss.item_Type ItemTypeCode,1 [IsPublished],0 [IsAdaptive],T.Grade,AssessmentItemCode ,ss.Reporting_Category,ss.Reporting_Category_Number,ss.MA_Curriculum_Framework [Standard],ss.Correct_Answer	,Replace(ss.State_Percent_Possible,''%'','''')as State_Percent_Possible  ,ss.District_Percent_Possible,ss.School_Percent_Possible,ss.School_State_Diff	,ss.School_Average_Points,ss.District_Average_Points,ss.State_Average_Points,T.TenantId,[ItemId] SortOrder	,case when SubjectAreaCode=''MATH'' then ''Mathematics'' else SubjectAreaCode end as SubjectAreaDescription
		from (	select	DISTINCT adminyear SchoolYear,[LEAIdentifier],[SchoolIdentifier],''MCAS'' AssessmentCode,Item [ItemId1],Item AssessmentItemCode	,CASE WHEN substring(Item,1,5)=''mitem'' THEN substring(Item,6,10) ELSE Item END [ItemId],CASE WHEN substring(Item,1,5)=''mitem'' THEN substring(Item,6,10) ELSE Item END [Itemtext]	,grade,TenantId,NULL [ItemMinScore],''MATH'' [SubjectAreaCode]
			from	( '
			SET @SQL1 = 
				N'  select	distinct 	st.adminyear,st.grade,st.TenantId,sc.LEAIdentifier,	sc.SchoolIdentifier	,isnull([mitem1],-1) [mitem1],isnull([mitem2],-1) [mitem2],isnull([mitem3],-1) [mitem3],isnull([mitem4],-1) [mitem4],isnull([mitem5],-1) [mitem5],isnull([mitem6],-1) [mitem6],isnull([mitem7],-1) [mitem7]	,isnull([mitem8],-1) [mitem8],isnull([mitem9],-1) [mitem9],isnull([mitem10],-1) [mitem10],isnull([mitem11],-1) [mitem11],isnull([mitem12],-1) [mitem12],isnull([mitem13],-1) [mitem13],isnull([mitem14],-1) [mitem14],isnull([mitem15],-1) [mitem15],isnull([mitem16],-1) [mitem16],isnull([mitem17],-1) [mitem17],isnull([mitem18],-1) [mitem18],isnull([mitem19],-1) [mitem19],isnull([mitem20],-1) [mitem20],isnull([mitem21],-1) [mitem21],isnull([mitem22],-1) [mitem22],isnull([mitem23],-1) [mitem23],isnull([mitem24],-1) [mitem24],isnull([mitem25],-1) [mitem25],isnull([mitem26],-1) [mitem26],isnull([mitem27],-1) [mitem27],isnull([mitem28],-1) [mitem28],isnull([mitem29],-1) [mitem29],isnull([mitem30],-1) [mitem30],isnull([mitem31],0) [mitem31],isnull([mitem32],-1) [mitem32],isnull([mitem33],-1) [mitem33],isnull([mitem34],-1) [mitem34],isnull([mitem35],-1) [mitem35],isnull([mitem36],-1) [mitem36],isnull([mitem37],-1) [mitem37],isnull([mitem38],-1) [mitem38],isnull([mitem39],-1) [mitem39],isnull([mitem40],-1) [mitem40],isnull([mitem41],-1) [mitem41],isnull([mitem42],-1) [mitem42]
						from Main.' 
				+ @TenantCode + '_MCAS_' + @CurrentYear + ' st
				left join main.k12school sc on (st.testschoolname=sc.NameofInstitution or st.testschoolcode=sc.SchoolIdentifier) and st.TenantId=sc.TenantId	) T   
			 UNPIVOT	(orders FOR Item IN	([mitem1],[mitem2],[mitem3],[mitem4],[mitem5],[mitem6],[mitem7],[mitem8],[mitem9],[mitem10],[mitem11],[mitem12],[mitem13],[mitem14],[mitem15],[mitem16],[mitem17],[mitem18],[mitem19],[mitem20],[mitem21],[mitem22],[mitem23],[mitem24],[mitem25],[mitem26],[mitem27],[mitem28],[mitem29],[mitem30],[mitem31],	[mitem32],[mitem33],[mitem34],[mitem35],[mitem36],[mitem37],[mitem38],[mitem39],[mitem40],[mitem41],[mitem42])
			) AS unpvt where orders<>''''	) T
		join	dbo.' + @TenantCode + 
				'_MCAS_ItemAnalysis_Math_ELA_Science	ss on ss.item_Number=T.ItemId and ss.Subject=T.Subjectareacode	and (Case when ss.Grade not in (''10'',''11'',''12'',''PK'',''KF'') Then Replace(ss.Grade,''0'','''') Else ss.Grade end) =(Case when t.Grade not in (''10'',''11'',''12'',''PK'',''KF'') Then Replace(t.Grade,''0'','''') Else t.Grade end)  and ss.TenantId=T.TenantId
		where ss.Subject=''MATH''
		UNION  '
			SET @SQL2 = 
				N' SELECT DISTINCT T.SchoolYear,LEAIdentifier,SchoolIdentifier,AssessmentCode,ItemId1 ItemId,ss.max_points ItemMaxScore,ss.item_Description Itemtext,ItemMinScore,SubjectAreaCode,ss.item_Type ItemTypeCode,1 [IsPublished],0 [IsAdaptive],T.Grade,AssessmentItemCode ,ss.Reporting_Category,ss.Reporting_Category_Number,ss.MA_Curriculum_Framework [Standard],ss.Correct_Answer	,Replace(ss.State_Percent_Possible,''%'','''')as State_Percent_Possible ,ss.District_Percent_Possible,ss.School_Percent_Possible,ss.School_State_Diff,ss.School_Average_Points,ss.District_Average_Points,ss.State_Average_Points,T.TenantId,[ItemId] SortOrder	,SubjectAreaCode as SubjectAreaDescription
			from (	select	distinct adminyear SchoolYear,[LEAIdentifier],[SchoolIdentifier],''MCAS'' AssessmentCode,Item [ItemId1],Item AssessmentItemCode,CASE WHEN substring(Item,1,5)=''eitem'' THEN substring(Item,6,10) ELSE Item END [ItemId],CASE WHEN substring(Item,1,5)=''eitem'' THEN substring(Item,6,10) ELSE Item END [Itemtext]	,grade,TenantId,''0'' [ItemMinScore], ''ELA'' [SubjectAreaCode]
			from	(	select	st.adminyear,st.grade,st.TenantId,sc.LEAIdentifier,	sc.SchoolIdentifier	,isnull([eitem1],-1) [eitem1],isnull([eitem2],-1) [eitem2],isnull([eitem3],-1) [eitem3],isnull([eitem4],-1) [eitem4],isnull([eitem5],-1) [eitem5],isnull([eitem6],-1) [eitem6],isnull([eitem7],-1) [eitem7]	,isnull([eitem8],-1) [eitem8],isnull([eitem9],-1) [eitem9],isnull([eitem10],-1) [eitem10],isnull([eitem11],-1) [eitem11],isnull([eitem12],-1) [eitem12],isnull([eitem13],-1) [eitem13],isnull([eitem14],-1) [eitem14],isnull([eitem15],-1) [eitem15],isnull([eitem16],-1) [eitem16],isnull([eitem17],-1) [eitem17],isnull([eitem18],-1) [eitem18],isnull([eitem19],-1) [eitem19],isnull([eitem20],-1) [eitem20],isnull([eitem21],-1) [eitem21],isnull([eitem22],-1) [eitem22],isnull([eitem23],-1) [eitem23],isnull([eitem24],-1) [eitem24],isnull([eitem25],-1) [eitem25],isnull([eitem26],-1) [eitem26],isnull([eitem27],-1) [eitem27],isnull([eitem28],-1) [eitem28],isnull([eitem29],-1) [eitem29],isnull([eitem30],-1) [eitem30],isnull([eitem31],-1) [eitem31],isnull([eitem32],-1) [eitem32]
				from Main.' 
				+ @TenantCode + '_MCAS_' + @CurrentYear + ' st
				left join main.k12school sc on (st.testschoolname=sc.NameofInstitution or st.testschoolcode=sc.SchoolIdentifier) and st.TenantId=sc.TenantId	) T
			UNPIVOT	(orders FOR Item IN	([eitem1],[eitem2],[eitem3],[eitem4],[eitem5],[eitem6],[eitem7],[eitem8],[eitem9],[eitem10],[eitem11],[eitem12],[eitem13],[eitem14],[eitem15],[eitem16],[eitem17],[eitem18],[eitem19],[eitem20],[eitem21],[eitem22],[eitem23],[eitem24],[eitem25],[eitem26],[eitem27],[eitem28],[eitem29],[eitem30],[eitem31],	[eitem32] 
				)	) AS unpvt where orders<>''''	) T
		join	dbo.' + @TenantCode + 
				'_MCAS_ItemAnalysis_Math_ELA_Science	ss	on ss.item_Number=T.ItemId and ss.Subject=T.Subjectareacode	and (Case when ss.Grade not in (''10'',''11'',''12'',''PK'',''KF'') Then Replace(ss.Grade,''0'','''') Else ss.Grade end) =(Case when t.Grade not in (''10'',''11'',''12'',''PK'',''KF'') Then Replace(t.Grade,''0'','''') Else t.Grade end)  and ss.TenantId=T.TenantId
		where Subject=''ELA'' 
		union  '
			SET @SQL3 = 
				N'  SELECT DISTINCT T.SchoolYear,LEAIdentifier,SchoolIdentifier,AssessmentCode,ItemId1 ItemId,ss.max_points ItemMaxScore,ss.item_Description Itemtext,ItemMinScore,SubjectAreaCode,ss.item_Type ItemTypeCode,1 [IsPublished],0 [IsAdaptive],T.Grade,AssessmentItemCode ,ss.Reporting_Category,ss.Reporting_Category_Number,ss.MA_Curriculum_Framework [Standard],ss.Correct_Answer	,ss.State_Percent_Possible,ss.District_Percent_Possible,ss.School_Percent_Possible,ss.School_State_Diff	,ss.School_Average_Points,ss.District_Average_Points,ss.State_Average_Points,T.TenantId,[ItemId] SortOrder,SubjectAreaCode as SubjectAreaDescription
		from (	select	distinct adminyear SchoolYear,[LEAIdentifier],[SchoolIdentifier],''MCAS'' AssessmentCode,Item [ItemId1],Item AssessmentItemCode,CASE WHEN substring(Item,1,5)=''sitem'' THEN substring(Item,6,10) ELSE Item END [ItemId],CASE WHEN substring(Item,1,5)=''sitem'' THEN substring(Item,6,10) ELSE Item END [Itemtext]	,grade,TenantId,'''' [ItemMinScore], ''Science'' SubjectAreaCode
			from ( select 	distinct 	st.adminyear,st.grade,st.TenantId,sc.LEAIdentifier,	sc.SchoolIdentifier	,isnull([sitem1],-1) [sitem1],isnull([sitem2],-1) [sitem2],isnull([sitem3],-1) [sitem3],isnull([sitem4],-1) [sitem4],isnull([sitem5],-1) [sitem5],isnull([sitem6],-1) [sitem6],isnull([sitem7],-1) [sitem7],isnull([sitem8],-1) [sitem8],isnull([sitem9],-1) [sitem9],isnull([sitem10],-1) [sitem10],isnull([sitem11],-1) [sitem11],isnull([sitem12],-1) [sitem12],isnull([sitem13],-1) [sitem13],isnull([sitem14],-1) [sitem14],isnull([sitem15],-1) [sitem15],isnull([sitem16],-1) [sitem16],isnull([sitem17],-1) [sitem17],isnull([sitem18],-1) [sitem18],isnull([sitem19],-1) [sitem19],isnull([sitem20],-1) [sitem20],isnull([sitem21],-1) [sitem21],isnull([sitem22],-1) [sitem22],isnull([sitem23],-1) [sitem23],isnull([sitem24],-1) [sitem24],isnull([sitem25],-1) [sitem25],isnull([sitem26],-1) [sitem26],isnull([sitem27],-1) [sitem27],isnull([sitem28],-1) [sitem28],isnull([sitem29],-1) [sitem29],isnull([sitem30],-1) [sitem30],isnull([sitem31],-1) [sitem31],isnull([sitem32],-1) [sitem32],isnull([sitem33],-1) [sitem33],isnull([sitem34],-1) [sitem34],isnull([sitem35],-1) [sitem35],isnull([sitem36],-1) [sitem36],isnull([sitem37],-1) [sitem37],isnull([sitem38],-1) [sitem38],isnull([sitem39],-1) [sitem39],isnull([sitem40],-1) [sitem40],isnull([sitem41],-1) [sitem41],isnull([sitem42],-1) [sitem42],isnull([sitem43],-1) [sitem43],isnull([sitem44],-1) [sitem44],isnull([sitem45],-1) [sitem45]
					from Main.' 
				+ @TenantCode + '_MCAS_' + @CurrentYear + ' st
				left join main.k12school sc on (st.testschoolname=sc.NameofInstitution or st.testschoolcode=sc.SchoolIdentifier) and st.TenantId=sc.TenantId
			) T
			UNPIVOT
			(orders FOR Item IN	(	[sitem1],[sitem2],[sitem3],[sitem4],[sitem5],[sitem6],[sitem7],[sitem8],[sitem9],[sitem10],[sitem11],[sitem12],[sitem13],[sitem14],[sitem15],[sitem16],	[sitem17],[sitem18],[sitem19],[sitem20],[sitem21],[sitem22],[sitem23],[sitem24],[sitem25],[sitem26],[sitem27],[sitem28],[sitem29],[sitem30],[sitem31],	[sitem32],[sitem33],[sitem34],[sitem35],[sitem36],[sitem37],[sitem38],[sitem39],[sitem40],[sitem41],[sitem42],[sitem43],[sitem44],[sitem45])
			) AS unpvt where orders<>''''	) T
		join dbo.' + @TenantCode + 
				'_MCAS_ItemAnalysis_Math_ELA_Science	ss	on ss.item_Number=T.ItemId and ss.Subject=T.Subjectareacode and (Case when ss.Grade not in (''10'',''11'',''12'',''PK'',''KF'') Then Replace(ss.Grade,''0'','''') Else ss.Grade end) =(Case when t.Grade not in (''10'',''11'',''12'',''PK'',''KF'') Then Replace(t.Grade,''0'','''') Else t.Grade end)  and ss.TenantId=T.TenantId
		where ss.Subject=''Science'' ) a '
			SET @SQL6 = '
where not exists (select 1 from AggrptMCASItemAnalysis b where a.TenantId=b.TenantId and a.SchoolYear=b.SchoolYear	and a.SubjectAreaCode=b.SubjectAreaCode and a.grade=b.Grade and a.ItemId=b.ItemId and a.LEAIdentifier=b.LEAIdentifier and a.SchoolIdentifier=b.SchoolIdentifier and a.AssessmentCode=b.AssessmentCode and a.Reporting_Category=b.Reporting_Category and a.Standard=b.MA_Curriculum_Framework and a.ItemTypeCode=b.ItemTypeCode
)  END ;
'
			SET @SQL4 = @SQL + @SQL1 + @SQL2 + @SQL3 + @SQL6

			EXEC sp_executesql @SQL4;

			FETCH NEXT
			FROM YearCursor
			INTO @CurrentYear;
		END;

		CLOSE YearCursor;

		DEALLOCATE YearCursor;
	END TRY

	BEGIN CATCH
		-- Test whether the transaction is uncommittable.                         
		IF XACT_STATE() = - 1
		BEGIN
			ROLLBACK TRAN;
		END;

		--Comment it if SP contains only SELECT statement                                             
		DECLARE @ErrorFromProc VARCHAR(500);
		DECLARE @ProcErrorMessage VARCHAR(1000);
		DECLARE @SeverityLevel INT;
		DECLARE @ErrorNumber INT = ERROR_NUMBER();

		SELECT @ErrorFromProc = '[dbo].[USP_AggrptMCASItemAnalysis_DataLoading]'
			,@ProcErrorMessage = ERROR_MESSAGE()
			,@SeverityLevel = ERROR_SEVERITY();

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
			,GETDATE()
			,@Tenantid
			);

		RAISERROR (
				'Error Number-%d : Error Message-%s'
				,16
				,1
				,@ErrorNumber
				,@ProcErrorMessage
				)
	END CATCH;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[USP_AggrptMCASItemStudentResults_DataLoading] (@TenantId INT, @SchoolYear VARCHAR(200))
AS
BEGIN
	SET XACT_ABORT ON;
	SET NOCOUNT ON

	BEGIN TRY
		DECLARE @TenantCode VARCHAR(MAX)
			,@LEAIdentifier VARCHAR(500);

		SET @TenantCode = (
				SELECT TenantCode
				FROM idm.Tenant
				WHERE TenantId = @TenantId
				);

		SELECT @LEAIdentifier = LEAIdentifier
		FROM main.K12LEA
		WHERE TenantId = @TenantId;

		DECLARE @SQL NVARCHAR(MAX)
			,@SQL1 NVARCHAR(MAX)
			,@SQL2 NVARCHAR(MAX)
			,@SQL3 NVARCHAR(MAX)
			,@SQL4 NVARCHAR(MAX)
			,@SQL5 NVARCHAR(MAX);
		DECLARE @SchoolYearTable TABLE (SchoolYear VARCHAR(10));

		-- Split the input years
		INSERT INTO @SchoolYearTable (SchoolYear)
		SELECT LTRIM(RTRIM(value))
		FROM STRING_SPLIT(@SchoolYear, ',');

		DECLARE @CurrentYear VARCHAR(10);

		---------------------------------------------------------
		-- Loop through each school year
		---------------------------------------------------------
		DECLARE YearCursor CURSOR
		FOR
		SELECT SchoolYear
		FROM @SchoolYearTable;

		OPEN YearCursor;

		FETCH NEXT
		FROM YearCursor
		INTO @CurrentYear;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @SQL5 = N'   
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = ''' + @TenantCode + '_MCAS_' + @CurrentYear + ''')
BEGIN
Update m set m.DistrictStudentId=st.DistrictStudentId from Main.' + @TenantCode + '_MCAS_' + @CurrentYear + ' m  
Join AggRptK12StudentDetails st On m.sasid=st.StateStudentId  and m.Tenantid=st.Tenantid where m.SchoolYear= ' + @CurrentYear + ' and m.DistrictStudentId is null 
End 
'

			EXEC sp_executesql @SQL5

			SET @SQL = N'
IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = ''' + @TenantCode + '_MCAS_' + @CurrentYear + 
				''')
BEGIN
 INSERT INTO  AggrptMCASItemStudentResults (LEAIdentifier,SchoolIdentifier,SchoolYear,AssessmentCode, ItemId, ItemMaxScore,	 Itemtext,StudentScore,DistrictStudentId, ItemTypeCode,SubjectAreaCode	,Reporting_Category,Reporting_Category_Number,MA_Curriculum_Framework ,Correct_Answer	,State_Percent_Possible,District_Percent_Possible,School_Percent_Possible,School_State_Diff	,School_Average_Points,District_Average_Points,State_Average_Points,grade,TenantId	,gender,race,StudentName,FRL,DisabilityStatus,ELL,SubjectAreaDescription,SortOrder)

select LEAIdentifier,SchoolIdentifier,SchoolYear,AssessmentCode, ItemId, ItemMaxScore, Itemtext,StudentScore,DistrictStudentId, ItemTypeCode,SubjectAreaCode,Reporting_Category,Reporting_Category_Number,Standard ,Correct_Answer,State_Percent_Possible,District_Percent_Possible,School_Percent_Possible,School_State_Diff,School_Average_Points,District_Average_Points,State_Average_Points,grade,TenantId,gender,race,StudentName,FRL,DisabilityStatus,ELL,SubjectAreaDescription,SortOrder
from (	select distinct LEAIdentifier,SchoolIdentifier,t.SchoolYear,AssessmentCode,ItemId1 ItemId,ss.Max_Points ItemMaxScore,ss.Item_Description Itemtext,StudentScore,	DistrictStudentId,ss.Item_Type ItemTypeCode,SubjectAreaCode	,ss.Reporting_Category,ss.Reporting_Category_Number,ss.MA_Curriculum_Framework Standard,ss.Correct_Answer,ss.State_Percent_Possible,ss.District_Percent_Possible,ss.School_Percent_Possible,ss.School_State_Diff	,ss.School_Average_Points,ss.District_Average_Points,ss.State_Average_Points,T.grade,T.TenantId	,T.gender,T.race,T.StudentName,T.FRL,T.DisabilityStatus,T.ELL,case when SubjectAreaCode=''MATH'' then ''Mathematics'' else SubjectAreaCode end as SubjectAreaDescription,[ItemId] SortOrder
		from (
			select [LEAIdentifier],[SchoolIdentifier],adminyear SchoolYear,''MCAS'' AssessmentCode,Item [ItemId1],CASE WHEN substring(Item,1,5)=''mitem'' THEN substring(Item,6,10) ELSE Item END [ItemId],grade,TenantId,CASE WHEN substring(Item,1,5)=''mitem'' THEN substring(Item,6,10) ELSE Item END [Itemtext],orders [StudentScore], DistrictStudentId	, ''MATH'' SubjectAreaCode,gender,race,StudentName,FRL,DisabilityStatus,ELL
			from (	select st.adminyear,st.grade,st.TenantId,isnull([mitem1],-1) [mitem1],isnull([mitem2],-1) [mitem2],isnull([mitem3],-1) [mitem3],isnull([mitem4],-1) [mitem4],isnull([mitem5],-1) [mitem5],isnull([mitem6],-1) [mitem6],isnull([mitem7],-1) [mitem7],isnull([mitem8],-1) [mitem8],isnull([mitem9],-1) [mitem9],isnull([mitem10],-1) [mitem10],isnull([mitem11],-1) [mitem11],isnull([mitem12],-1) [mitem12],isnull([mitem13],-1) [mitem13],isnull([mitem14],-1) [mitem14],isnull([mitem15],-1) [mitem15],isnull([mitem16],-1) [mitem16],isnull([mitem17],-1) [mitem17],isnull([mitem18],-1) [mitem18],isnull([mitem19],-1) [mitem19],isnull([mitem20],-1) [mitem20],isnull([mitem21],-1) [mitem21],isnull([mitem22],-1) [mitem22],isnull([mitem23],-1) [mitem23],isnull([mitem24],-1) [mitem24],isnull([mitem25],-1) [mitem25],isnull([mitem26],-1) [mitem26],isnull([mitem27],-1) [mitem27],isnull([mitem28],-1) [mitem28],isnull([mitem29],-1) [mitem29],isnull([mitem30],-1) [mitem30],isnull([mitem31],-1) [mitem31],isnull([mitem32],-1) [mitem32],isnull([mitem33],-1) [mitem33],isnull([mitem34],-1) [mitem34],isnull([mitem35],-1) [mitem35],isnull([mitem36],-1) [mitem36],isnull([mitem37],-1) [mitem37],isnull([mitem38],-1) [mitem38],isnull([mitem39],-1) [mitem39],isnull([mitem40],-1) [mitem40],isnull([mitem41],-1) [mitem41],isnull([mitem42],-1) [mitem42],''' 
				+ @LEAIdentifier + ''' as LEAIdentifier,Isnull(sc.SchoolIdentifier,st.sprp_sch) as SchoolIdentifier,st.[DistrictStudentId]	,gender,race,lastname+'' ''+firstname+'' ''+ISNULL(mi,'''') StudentName,FRL,DisabilityStatus,ELL
				from Main.' + @TenantCode + '_MCAS_' + @CurrentYear + ' st
				Left Join main.K12School sc On (st.sprp_sch_name = sc.NameofInstitution or st.sprp_sch=sc.SchoolIdentifier) and st.Tenantid=sc.tenantid
			) T  '
			SET @SQL1 = N'  UNPIVOT ( orders FOR Item IN
			(	[mitem1],[mitem2],[mitem3],[mitem4],[mitem5],[mitem6],[mitem7],[mitem8],[mitem9],[mitem10],[mitem11],[mitem12],[mitem13],[mitem14],[mitem15],[mitem16],	[mitem17],[mitem18],[mitem19],[mitem20],[mitem21],[mitem22],[mitem23],[mitem24],[mitem25],[mitem26],[mitem27],[mitem28],[mitem29],[mitem30],[mitem31],	[mitem32],[mitem33],[mitem34],[mitem35],[mitem36],[mitem37],[mitem38],[mitem39],[mitem40],[mitem41],[mitem42]
			)) AS unpvt where Isnumeric(orders)= 1  	) T
		join	dbo.' + @TenantCode + 
				'_MCAS_ItemAnalysis_Math_ELA_Science	ss	
			on ss.Item_Number=T.ItemId 	and (Case when ss.Grade not in (''10'',''11'',''12'',''PK'',''KF'') Then Replace(ss.Grade,''0'','''') Else ss.Grade end) =(Case when t.Grade not in (''10'',''11'',''12'',''PK'',''KF'') Then Replace(t.Grade,''0'','''') Else t.Grade end)  and	ss.Subject=T.SubjectAreaCode and ss.TenantId=T.TenantId
		where Subject=''MATH''
		UNION 
		select distinct LEAIdentifier,SchoolIdentifier,t.SchoolYear,AssessmentCode,ItemId1 ItemId,ss.Max_Points ItemMaxScore,ss.Item_Description Itemtext,StudentScore,DistrictStudentId,ss.Item_Type ItemTypeCode,SubjectAreaCode	,ss.Reporting_Category,ss.Reporting_Category_Number,ss.MA_Curriculum_Framework Standard,ss.Correct_Answer,ss.State_Percent_Possible,ss.District_Percent_Possible,ss.School_Percent_Possible,ss.School_State_Diff,ss.School_Average_Points,ss.District_Average_Points,ss.State_Average_Points,T.grade,T.TenantId,T.gender,T.race,T.StudentName,T.FRL,T.DisabilityStatus,T.ELL,SubjectAreaCode as SubjectAreaDescription,[ItemId] SortOrder
		from (	select distinct [LEAIdentifier],[SchoolIdentifier],adminyear SchoolYear,''MCAS'' AssessmentCode,Item [ItemId1],	CASE WHEN substring(Item,1,5)=''eitem'' THEN substring(Item,6,10) ELSE Item END [ItemId],grade,TenantId,CASE WHEN substring(Item,1,5)=''eitem'' THEN substring(Item,6,10) ELSE Item END [Itemtext],orders [StudentScore], DistrictStudentId	, ''ELA'' SubjectAreaCode,gender,race,StudentName,FRL,DisabilityStatus,ELL
			from (
				 '
			SET @SQL2 = 
				N'  select st.adminyear,st.grade,st.TenantId	,isnull([eitem1],-1) [eitem1],isnull([eitem2],-1) [eitem2],isnull([eitem3],-1) [eitem3],isnull([eitem4],-1) [eitem4],isnull([eitem5],-1) [eitem5],isnull([eitem6],-1) [eitem6],isnull([eitem7],-1) [eitem7],isnull([eitem8],-1) [eitem8],isnull([eitem9],-1) [eitem9],isnull([eitem10],-1) [eitem10],isnull([eitem11],-1) [eitem11],isnull([eitem12],-1) [eitem12],isnull([eitem13],-1) [eitem13],isnull([eitem14],-1) [eitem14],isnull([eitem15],-1) [eitem15],isnull([eitem16],-1) [eitem16],isnull([eitem17],-1) [eitem17],isnull([eitem18],-1) [eitem18],isnull([eitem19],-1) [eitem19],isnull([eitem20],-1) [eitem20],isnull([eitem21],-1) [eitem21],isnull([eitem22],-1) [eitem22],isnull([eitem23],-1) [eitem23],isnull([eitem24],-1) [eitem24],isnull([eitem25],-1) [eitem25],isnull([eitem26],-1) [eitem26],isnull([eitem27],-1) [eitem27],isnull([eitem28],-1) [eitem28],isnull([eitem29],-1) [eitem29],isnull([eitem30],-1) [eitem30],isnull([eitem31],-1) [eitem31],isnull([eitem32],-1) [eitem32],''' 
				+ @LEAIdentifier + ''' as LEAIdentifier,Isnull(sc.SchoolIdentifier,st.sprp_sch) as SchoolIdentifier,st.[DistrictStudentId],gender,race,lastname+'' ''+firstname+'' ''+ISNULL(mi,'''') StudentName,FRL,DisabilityStatus,ELL
				from Main.' + @TenantCode + '_MCAS_' + @CurrentYear + ' st
				Left Join main.K12School sc On (st.sprp_sch_name = sc.NameofInstitution or st.sprp_sch=sc.SchoolIdentifier) and st.Tenantid=sc.tenantid
				) T
				UNPIVOT (orders FOR Item IN
				([eitem1],[eitem2],[eitem3],[eitem4],[eitem5],[eitem6],[eitem7],[eitem8],[eitem9],[eitem10],[eitem11],[eitem12],[eitem13],[eitem14],[eitem15],[eitem16],[eitem17],[eitem18],[eitem19],[eitem20],[eitem21],[eitem22],[eitem23],[eitem24],[eitem25],[eitem26],[eitem27],[eitem28],[eitem29],[eitem30],[eitem31],[eitem32]
				)) AS unpvt where Isnumeric(orders)= 1  ) T
		join	dbo.' + @TenantCode + 
				'_MCAS_ItemAnalysis_Math_ELA_Science	ss	
			on ss.Item_Number=T.ItemId	and (Case when ss.Grade not in (''10'',''11'',''12'',''PK'',''KF'') Then Replace(ss.Grade,''0'','''') Else ss.Grade end) =(Case when t.Grade not in (''10'',''11'',''12'',''PK'',''KF'') Then Replace(t.Grade,''0'','''') Else t.Grade end)  and	ss.Subject=T.SubjectAreaCode and ss.TenantId=T.TenantId
		where ss.Subject=''ELA''	
		union
		select distinct LEAIdentifier,SchoolIdentifier,t.SchoolYear,AssessmentCode,ItemId1 ItemId,ss.Max_Points ItemMaxScore,ss.Item_Description Itemtext,StudentScore,DistrictStudentId,ss.Item_Type ItemTypeCode,SubjectAreaCode,ss.Reporting_Category,ss.Reporting_Category_Number,ss.MA_Curriculum_Framework Standard,ss.Correct_Answer,ss.State_Percent_Possible,ss.District_Percent_Possible,ss.School_Percent_Possible,ss.School_State_Diff,ss.School_Average_Points,ss.District_Average_Points,ss.State_Average_Points,T.grade,T.TenantId	,T.gender,T.race,T.StudentName,T.FRL,T.DisabilityStatus,T.ELL,SubjectAreaCode as SubjectAreaDescription,[ItemId] SortOrder
		from (
			  '
			SET @SQL3 = 
				N'  select distinct [LEAIdentifier],[SchoolIdentifier],adminyear SchoolYear,''MCAS'' AssessmentCode,Item [ItemId1],CASE WHEN substring(Item,1,5)=''sitem'' THEN substring(Item,6,10) ELSE Item END [ItemId],grade,TenantId,CASE WHEN substring(Item,1,5)=''sitem'' THEN substring(Item,6,10) ELSE Item END [Itemtext],orders [StudentScore], DistrictStudentId, ''Science'' SubjectAreaCode,gender,race,StudentName,FRL,DisabilityStatus,ELL
			from
			( select st.adminyear,st.grade,st.TenantId,isnull([sitem1],-1) [sitem1],isnull([sitem2],-1) [sitem2],isnull([sitem3],-1) [sitem3],isnull([sitem4],-1) [sitem4],isnull([sitem5],-1) [sitem5],isnull([sitem6],-1) [sitem6],isnull([sitem7],-1) [sitem7]	,isnull([sitem8],-1) [sitem8],isnull([sitem9],-1) [sitem9],isnull([sitem10],-1) [sitem10],isnull([sitem11],-1) [sitem11],isnull([sitem12],-1) [sitem12],isnull([sitem13],-1) [sitem13],isnull([sitem14],-1) [sitem14],isnull([sitem15],-1) [sitem15],isnull([sitem16],-1) [sitem16],isnull([sitem17],-1) [sitem17],isnull([sitem18],-1) [sitem18],isnull([sitem19],-1) [sitem19],isnull([sitem20],-1) [sitem20],isnull([sitem21],-1) [sitem21],isnull([sitem22],-1) [sitem22],isnull([sitem23],-1) [sitem23],isnull([sitem24],-1) [sitem24],isnull([sitem25],-1) [sitem25],isnull([sitem26],-1) [sitem26],isnull([sitem27],-1) [sitem27],isnull([sitem28],-1) [sitem28]	,isnull([sitem29],-1) [sitem29],isnull([sitem30],-1) [sitem30],isnull([sitem31],-1) [sitem31],isnull([sitem32],-1) [sitem32],isnull([sitem33],-1) [sitem33],isnull([sitem34],-1) [sitem34],isnull([sitem35],-1) [sitem35],isnull([sitem36],-1) [sitem36],isnull([sitem37],-1) [sitem37],isnull([sitem38],-1) [sitem38],isnull([sitem39],-1) [sitem39],isnull([sitem40],-1) [sitem40],isnull([sitem41],-1) [sitem41],isnull([sitem42],-1) [sitem42],isnull([sitem43],-1) [sitem43],isnull([sitem44],-1) [sitem44],isnull([sitem45],-1) [sitem45]	,''' 
				+ @LEAIdentifier + ''' as LEAIdentifier,Isnull(sc.SchoolIdentifier,st.sprp_sch) as SchoolIdentifier,st.[DistrictStudentId],gender,race,lastname+'' ''+firstname+'' ''+ISNULL(mi,'''') StudentName,	FRL,DisabilityStatus,ELL
				from Main.' + @TenantCode + '_MCAS_' + @CurrentYear + ' st
				Left Join main.K12School sc On (st.sprp_sch_name = sc.NameofInstitution or st.sprp_sch=sc.SchoolIdentifier) and st.Tenantid=sc.tenantid
			) T
			UNPIVOT (orders FOR Item IN
			( [sitem1],[sitem2],[sitem3],[sitem4],[sitem5],[sitem6],[sitem7],[sitem8],[sitem9],[sitem10],[sitem11],[sitem12],[sitem13],[sitem14],[sitem15],[sitem16],	[sitem17],[sitem18],[sitem19],[sitem20],[sitem21],[sitem22],[sitem23],[sitem24],[sitem25],[sitem26],[sitem27],[sitem28],[sitem29],[sitem30],[sitem31],[sitem32],[sitem33],[sitem34],[sitem35],[sitem36],[sitem37],[sitem38],[sitem39],[sitem40],[sitem41],[sitem42],[sitem43],[sitem44],[sitem45]
			)) AS unpvt where Isnumeric(orders)= 1  ) T
		inner	join dbo.' + @TenantCode + 
				'_MCAS_ItemAnalysis_Math_ELA_Science	ss	
			on ss.Item_Number=T.ItemId 	and (Case when ss.Grade not in (''10'',''11'',''12'',''PK'',''KF'') Then Replace(ss.Grade,''0'','''') Else ss.Grade end) =(Case when t.Grade not in (''10'',''11'',''12'',''PK'',''KF'') Then Replace(t.Grade,''0'','''') Else t.Grade end)  and	ss.Subject=T.SubjectAreaCode and ss.TenantId=T.TenantId
		where ss.Subject=''Science'' ) a
where not exists (select 1 from AggrptMCASItemStudentResults b where a.TenantId=b.TenantId and a.SchoolYear=b.SchoolYear and a.SubjectAreaCode=b.SubjectAreaCode and a.grade=b.Grade and a.ItemId=b.ItemId and a.LEAIdentifier=b.LEAIdentifier 	and a.SchoolIdentifier=b.SchoolIdentifier and a.AssessmentCode=b.AssessmentCode and a.Reporting_Category=b.Reporting_Category	and a.Standard=b.MA_Curriculum_Framework and a.ItemTypeCode=b.ItemTypeCode and a.DistrictStudentId=b.DistrictStudentId
)   
END ;
'
			SET @SQL4 = @SQL + @SQL1 + @SQL2 + @SQL3

			EXEC sp_executesql @SQL4;

			FETCH NEXT
			FROM YearCursor
			INTO @CurrentYear;
		END;

		CLOSE YearCursor;

		DEALLOCATE YearCursor;
	END TRY

	BEGIN CATCH
		-- Test whether the transaction is uncommittable.                         
		IF XACT_STATE() = - 1
		BEGIN
			ROLLBACK TRAN;
		END;

		--Comment it if SP contains only SELECT statement                                             
		DECLARE @ErrorFromProc VARCHAR(500);
		DECLARE @ProcErrorMessage VARCHAR(1000);
		DECLARE @SeverityLevel INT;
		DECLARE @ErrorNumber INT = ERROR_NUMBER();

		SELECT @ErrorFromProc = '[dbo].[USP_AggrptMCASItemStudentResults_DataLoading]'
			,@ProcErrorMessage = ERROR_MESSAGE()
			,@SeverityLevel = ERROR_SEVERITY();

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
			,GETDATE()
			,@Tenantid
			);

		RAISERROR (
				'Error Number-%d : Error Message-%s'
				,16
				,1
				,@ErrorNumber
				,@ProcErrorMessage
				)
	END CATCH;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[USP_MCASItemAnalysis_ItemTypeDescriptionUpdation] (@TenantId INT,@SchoolYear VARCHAR(200))
AS
BEGIN
	SET XACT_ABORT ON;
	SET NOCOUNT ON

	BEGIN TRY
		DECLARE @TenantCode VARCHAR(MAX)
			,@LEAIdentifier VARCHAR(500);

		SET @TenantCode = (
				SELECT TenantCode
				FROM idm.Tenant
				WHERE TenantId = @TenantId
				);

		SELECT @LEAIdentifier = LEAIdentifier
		FROM main.K12LEA
		WHERE TenantId = @TenantId;

		IF EXISTS (
				SELECT DISTINCT 1
				FROM INFORMATION_SCHEMA.TABLES
				WHERE TABLE_NAME IN ('AggrptMCASItemAnalysis')
				)
		BEGIN
			-- Table variable to store individual school years
			DECLARE @SchoolYearTable TABLE (SchoolYear VARCHAR(10));

			-- Split the input years
			INSERT INTO @SchoolYearTable (SchoolYear)
			SELECT LTRIM(RTRIM(value))
			FROM STRING_SPLIT(@SchoolYear, ',');

			DECLARE @CurrentYear VARCHAR(10);

			---------------------------------------------------------
			-- Loop through each school year
			---------------------------------------------------------
			DECLARE YearCursor CURSOR
			FOR
			SELECT SchoolYear
			FROM @SchoolYearTable;

			OPEN YearCursor;

			FETCH NEXT
			FROM YearCursor
			INTO @CurrentYear;

			WHILE @@FETCH_STATUS = 0
			BEGIN
				UPDATE a
				SET ItemTypeDescription = CASE 
						WHEN ItemTypeCode = 'SR'
							THEN 'Selected Response'
						WHEN ItemTypeCode = 'SA'
							THEN 'Short Answer'
						WHEN ItemTypeCode = 'CR'
							THEN 'Constructed Response'
						WHEN ItemTypeCode = 'ES'
							THEN 'Essay'
						END
				FROM AggrptMCASItemAnalysis a
				WHERE TenantId = @Tenantid
					AND SchoolYear = @CurrentYear

				UPDATE a
				SET ItemTypeDescription = CASE 
						WHEN ItemTypeCode = 'SR'
							THEN 'Selected Response'
						WHEN ItemTypeCode = 'SA'
							THEN 'Short Answer'
						WHEN ItemTypeCode = 'CR'
							THEN 'Constructed Response'
						WHEN ItemTypeCode = 'ES'
							THEN 'Essay'
						END
				FROM AggrptMCASItemStudentResults a
				WHERE TenantId = @Tenantid
					AND SchoolYear = @CurrentYear

				UPDATE AggrptMCASItemAnalysis
				SET State_Percent_Possible = REPLACE(State_Percent_Possible, '%', '')
					,District_Percent_Possible = REPLACE(District_Percent_Possible, '%', '')
					,School_Percent_Possible = REPLACE(School_Percent_Possible, '%', '')
				WHERE TenantId = @Tenantid
					AND SchoolYear = @CurrentYear

				UPDATE AggrptMCASItemStudentResults
				SET State_Percent_Possible = REPLACE(State_Percent_Possible, '%', '')
					,District_Percent_Possible = REPLACE(District_Percent_Possible, '%', '')
					,School_Percent_Possible = REPLACE(School_Percent_Possible, '%', '')
				WHERE TenantId = @Tenantid
					AND SchoolYear = @CurrentYear

				UPDATE AggrptMCASItemStudentResults
				SET IsCorrect = CASE 
						WHEN cast(Replace(Replace(Replace(StudentScore, '\', ''), '+', ''), '-', '') AS INT) > 0
							THEN 1
						ELSE 0
						END
				WHERE TenantId = @Tenantid
					AND SchoolYear = @CurrentYear

				UPDATE a
				SET highneeds = CASE 
						WHEN (
								b.ELL = 'Yes'
								OR b.SpecialEdStatus = 'Yes'
								OR b.FRL = 'Free Lunch'
								OR b.FEL = 'Yes'
								)
							THEN 'Yes'
						ELSE 'No'
						END
				FROM AggrptMCASItemStudentResults a
				INNER JOIN AggRptK12StudentDetails b ON a.SchoolYear = b.SchoolYear
					AND a.DistrictStudentId = b.DistrictStudentId
					AND a.TenantId = b.TenantId
				WHERE a.TenantId = @Tenantid
					AND a.SchoolYear = @CurrentYear

				UPDATE a
				SET a.Avg_Correct = b.Avg_Correct
				FROM AggrptMCASItemStudentResults a
				INNER JOIN (
					SELECT ds.[ItemId]
						,ds.grade
						,ds.LEAIdentifier
						,ds.SubjectAreaCode
						,ds.TenantId
						,ds.SchoolYear
						,Cast(sum(cast(replace(Replace(replace(Replace(ds.StudentScore, '\', ''), '-1', '0'), '+', ''), '-', '') AS INT)) * 100.00 / (
								SELECT studentscoreCount
								FROM (
									SELECT ds1.Grade
										,ds1.ItemId
										,ds1.LEAIdentifier
										,ds1.SubjectAreaCode
										,ds1.TenantId
										,ds1.SchoolYear
										,studentscoreCount * ds3.ItemMaxScore AS studentscoreCount
									FROM (
										SELECT Grade
											,ItemId
											,LEAIdentifier
											,SubjectAreaCode
											,TenantId
											,SchoolYear
											,count(cast(replace(Replace(replace(studentscore, '\', ''), '+', ''), '-', '') AS INT)) AS studentscoreCount
										FROM AggrptMCASItemStudentResults
										GROUP BY Grade
											,ItemId
											,LEAIdentifier
											,SubjectAreaCode
											,TenantId
											,SchoolYear
										) ds1
									INNER JOIN (
										SELECT Grade
											,ItemId
											,LEAIdentifier
											,SubjectAreaCode
											,TenantId
											,SchoolYear
											,cast(max(CASE 
														WHEN ItemMaxScore = '(3 in v2)'
															THEN 3
														WHEN ItemMaxScore = '(2 in v2)'
															THEN 2
														ELSE ItemMaxScore
														END) AS INT) AS ItemMaxScore
										FROM AggrptMCASItemAnalysis
										GROUP BY Grade
											,ItemId
											,LEAIdentifier
											,SubjectAreaCode
											,TenantId
											,SchoolYear
										) ds3 ON ds3.Grade = ds1.grade
										AND ds3.ItemId = ds1.ItemId
										AND ds3.LEAIdentifier = ds1.LEAIdentifier
										AND ds3.SubjectAreaCode = ds1.SubjectAreaCode
										AND ds3.TenantId = ds1.TenantId
										AND ds3.SchoolYear = ds1.SchoolYear
									) ds1
								WHERE ds.ItemId = ds1.ItemId
									AND ds.grade = ds1.grade
									AND ds.LEAIdentifier = ds1.LEAIdentifier
									AND ds.SubjectAreaCode = ds1.SubjectAreaCode
									AND ds.TenantId = ds1.TenantId
									AND ds.SchoolYear = ds1.SchoolYear
								) AS DECIMAL(10, 2)) AS Avg_Correct
					FROM dbo.AggrptMCASItemStudentResults AS ds WITH (NOLOCK)
					WHERE (
							(ISNULL(ds.[LEAIdentifier], ' ') IN ('' + @LEAIdentifier + ''))
							AND (ds.TenantId = @Tenantid)
							)
						AND cast(replace(Replace(Replace(StudentScore, '\', ''), '+', ''), '-', '') AS INT) > 0
					GROUP BY ds.[ItemId]
						,ds.[grade]
						,ds.LEAIdentifier
						,ds.SubjectAreaCode
						,ds.TenantId
						,ds.SchoolYear
					) b ON a.LEAIdentifier = b.LEAIdentifier
					AND a.SubjectAreaCode = b.SubjectAreaCode
					AND a.[grade] = b.[grade]
					AND a.[ItemId] = b.[ItemId]
					AND a.TenantId = b.TenantId
					AND a.SchoolYear = b.SchoolYear
				WHERE a.TenantId = @Tenantid
					AND a.SchoolYear = @CurrentYear

				UPDATE a
				SET a.Avg_Correct = b.Avg_Correct
				FROM AggrptMCASItemAnalysis a
				INNER JOIN (
					SELECT ds.[ItemId]
						,ds.grade
						,ds.LEAIdentifier
						,ds.SubjectAreaCode
						,ds.TenantId
						,ds.SchoolYear
						,Cast(sum(cast(replace(replace(replace(Replace(ds.StudentScore, '\', ''), '-1', '0'), '-', ''), '+', '') AS INT)) * 100.00 / (
								SELECT studentscoreCount
								FROM (
									SELECT ds1.Grade
										,ds1.ItemId
										,ds1.LEAIdentifier
										,ds1.SubjectAreaCode
										,ds1.TenantId
										,ds1.SchoolYear
										,studentscoreCount * ds3.ItemMaxScore AS studentscoreCount
									FROM (
										SELECT Grade
											,ItemId
											,LEAIdentifier
											,SubjectAreaCode
											,TenantId
											,SchoolYear
											,count(cast(replace(replace(replace(studentscore, '\', ''), '-', ''), '+', '') AS INT)) AS studentscoreCount
										FROM AggrptMCASItemStudentResults
										GROUP BY Grade
											,ItemId
											,LEAIdentifier
											,SubjectAreaCode
											,TenantId
											,SchoolYear
										) ds1
									INNER JOIN (
										SELECT Grade
											,ItemId
											,LEAIdentifier
											,SubjectAreaCode
											,TenantId
											,SchoolYear
											,cast(max(CASE 
														WHEN ItemMaxScore = '(3 in v2)'
															THEN 3
														WHEN ItemMaxScore = '(2 in v2)'
															THEN 2
														ELSE ItemMaxScore
														END) AS INT) AS ItemMaxScore
										FROM AggrptMCASItemAnalysis
										GROUP BY Grade
											,ItemId
											,LEAIdentifier
											,SubjectAreaCode
											,TenantId
											,SchoolYear
										) ds3 ON ds3.Grade = ds1.grade
										AND ds3.ItemId = ds1.ItemId
										AND ds3.LEAIdentifier = ds1.LEAIdentifier
										AND ds3.SubjectAreaCode = ds1.SubjectAreaCode
										AND ds3.TenantId = ds1.TenantId
										AND ds3.SchoolYear = ds1.SchoolYear
									) ds1
								WHERE ds.ItemId = ds1.ItemId
									AND ds.grade = ds1.grade
									AND ds.LEAIdentifier = ds1.LEAIdentifier
									AND ds.SubjectAreaCode = ds1.SubjectAreaCode
									AND ds.TenantId = ds1.TenantId
									AND ds.SchoolYear = ds1.SchoolYear
								) AS DECIMAL(10, 2)) AS Avg_Correct
					FROM dbo.AggrptMCASItemStudentResults AS ds WITH (NOLOCK)
					WHERE (
							(ISNULL(ds.[LEAIdentifier], ' ') IN ('' + @LEAIdentifier + ''))
							AND (ds.TenantId = @Tenantid)
							)
						AND cast(replace(replace(Replace(StudentScore, '\', ''), '-', ''), '+', '') AS INT) > 0
					GROUP BY ds.[ItemId]
						,ds.[grade]
						,ds.LEAIdentifier
						,ds.SubjectAreaCode
						,ds.TenantId
						,ds.SchoolYear
					) b ON a.LEAIdentifier = b.LEAIdentifier
					AND a.SubjectAreaCode = b.SubjectAreaCode
					AND a.[grade] = b.[grade]
					AND a.[ItemId] = b.[ItemId]
					AND a.TenantId = b.TenantId
					AND a.SchoolYear = b.SchoolYear
				WHERE a.TenantId = @Tenantid
					AND a.SchoolYear = @CurrentYear

				UPDATE a
				SET a.Avg_School_Correct = cast(ROUND(b.Avg_Correct, 0, 0) AS INT)
				FROM AggrptMCASItemStudentResults a
				INNER JOIN (
					SELECT ds.[ItemId]
						,ds.grade
						,ds.LEAIdentifier
						,ds.SchoolIdentifier
						,ds.SubjectAreaCode
						,ds.TenantId
						,ds.SchoolYear
						,Cast(sum(cast(Replace(Replace(replace(Replace(ds.StudentScore, '\', ''), '-1', '0'), '-', ''), '+', '') AS INT)) * 100.00 / (
								SELECT studentscoreCount
								FROM (
									SELECT ds1.Grade
										,ds1.ItemId
										,ds1.LEAIdentifier
										,ds1.SchoolIdentifier
										,ds1.SubjectAreaCode
										,ds1.TenantId
										,ds1.SchoolYear
										,studentscoreCount * ds3.ItemMaxScore AS studentscoreCount
									FROM (
										SELECT Grade
											,ItemId
											,LEAIdentifier
											,SchoolIdentifier
											,SubjectAreaCode
											,TenantId
											,SchoolYear
											,count(cast(replace(replace(replace(studentscore, '\', ''), '-', ''), '+', '') AS INT)) AS studentscoreCount
										FROM AggrptMCASItemStudentResults
										GROUP BY Grade
											,ItemId
											,LEAIdentifier
											,SchoolIdentifier
											,SubjectAreaCode
											,TenantId
											,SchoolYear
										) ds1
									INNER JOIN (
										SELECT Grade
											,ItemId
											,LEAIdentifier
											,SchoolIdentifier
											,SubjectAreaCode
											,TenantId
											,SchoolYear
											,cast(max(CASE 
														WHEN ItemMaxScore = '(3 in v2)'
															THEN 3
														WHEN ItemMaxScore = '(2 in v2)'
															THEN 2
														ELSE ItemMaxScore
														END) AS INT) AS ItemMaxScore
										FROM AggrptMCASItemAnalysis
										GROUP BY Grade
											,ItemId
											,LEAIdentifier
											,SchoolIdentifier
											,SubjectAreaCode
											,TenantId
											,SchoolYear
										) ds3 ON ds3.Grade = ds1.grade
										AND ds3.ItemId = ds1.ItemId
										AND ds3.LEAIdentifier = ds1.LEAIdentifier
										AND ds3.SubjectAreaCode = ds1.SubjectAreaCode
										AND ds3.SchoolIdentifier = ds1.SchoolIdentifier
										AND ds3.TenantId = ds1.TenantId
										AND ds3.SchoolYear = ds1.SchoolYear
									) ds1
								WHERE ds.ItemId = ds1.ItemId
									AND ds.grade = ds1.grade
									AND ds.LEAIdentifier = ds1.LEAIdentifier
									AND ds.SchoolIdentifier = ds1.SchoolIdentifier
									AND ds.SubjectAreaCode = ds1.SubjectAreaCode
									AND ds.TenantId = ds1.TenantId
									AND ds.SchoolYear = ds1.SchoolYear
								) AS DECIMAL(10, 2)) AS Avg_Correct
					FROM dbo.AggrptMCASItemStudentResults AS ds WITH (NOLOCK)
					WHERE cast(Replace(Replace(Replace(StudentScore, '\', ''), '+', ''), '-', '') AS INT) > 0
					GROUP BY ds.[ItemId]
						,ds.[grade]
						,ds.LEAIdentifier
						,ds.SchoolIdentifier
						,ds.SubjectAreaCode
						,ds.TenantId
						,ds.SchoolYear
					) b ON a.LEAIdentifier = b.LEAIdentifier
					AND a.SubjectAreaCode = b.SubjectAreaCode
					AND a.[grade] = b.[grade]
					AND a.[ItemId] = b.[ItemId]
					AND a.SchoolIdentifier = b.SchoolIdentifier
					AND a.TenantId = b.TenantId
					AND a.SchoolYear = b.SchoolYear
				WHERE a.TenantId = @Tenantid
					AND a.SchoolYear = @CurrentYear

				UPDATE a
				SET a.Avg_School_Correct = cast(ROUND(b.Avg_Correct, 0, 0) AS INT)
				FROM AggrptMCASItemAnalysis a
				INNER JOIN (
					SELECT ds.[ItemId]
						,ds.grade
						,ds.LEAIdentifier
						,ds.SchoolIdentifier
						,ds.SubjectAreaCode
						,ds.TenantId
						,ds.SchoolYear
						,Cast(sum(cast(Replace(Replace(replace(Replace(ds.StudentScore, '\', ''), '-1', '0'), '-', ''), '+', '') AS INT)) * 100.00 / (
								SELECT studentscoreCount
								FROM (
									SELECT ds1.Grade
										,ds1.ItemId
										,ds1.LEAIdentifier
										,ds1.SchoolIdentifier
										,ds1.SubjectAreaCode
										,ds1.TenantId
										,ds1.SchoolYear
										,studentscoreCount * cast(replace(ds3.ItemMaxScore, '\', '') AS INT) AS studentscoreCount
									FROM (
										SELECT Grade
											,ItemId
											,LEAIdentifier
											,SchoolIdentifier
											,SubjectAreaCode
											,TenantId
											,SchoolYear
											,count(cast(replace(replace(replace(studentscore, '\', ''), '-', ''), '+', '') AS INT)) AS studentscoreCount
										FROM AggrptMCASItemStudentResults
										GROUP BY Grade
											,ItemId
											,LEAIdentifier
											,SchoolIdentifier
											,SubjectAreaCode
											,TenantId
											,SchoolYear
										) ds1
									INNER JOIN (
										SELECT Grade
											,ItemId
											,LEAIdentifier
											,SchoolIdentifier
											,SubjectAreaCode
											,TenantId
											,SchoolYear
											,cast(max(CASE 
														WHEN ItemMaxScore = '(3 in v2)'
															THEN 3
														WHEN ItemMaxScore = '(2 in v2)'
															THEN 2
														ELSE ItemMaxScore
														END) AS INT) AS ItemMaxScore
										FROM AggrptMCASItemAnalysis
										GROUP BY Grade
											,ItemId
											,LEAIdentifier
											,SchoolIdentifier
											,SubjectAreaCode
											,TenantId
											,SchoolYear
										) ds3 ON ds3.Grade = ds1.grade
										AND ds3.ItemId = ds1.ItemId
										AND ds3.LEAIdentifier = ds1.LEAIdentifier
										AND ds3.SubjectAreaCode = ds1.SubjectAreaCode
										AND ds3.SchoolIdentifier = ds1.SchoolIdentifier
										AND ds3.TenantId = ds1.TenantId
										AND ds3.SchoolYear = ds1.SchoolYear
									) ds1
								WHERE ds.ItemId = ds1.ItemId
									AND ds.grade = ds1.grade
									AND ds.LEAIdentifier = ds1.LEAIdentifier
									AND ds.SchoolIdentifier = ds1.SchoolIdentifier
									AND ds.SubjectAreaCode = ds1.SubjectAreaCode
									AND ds1.TenantId = ds.TenantId
									AND ds.SchoolYear = ds1.SchoolYear
								) AS DECIMAL(10, 2)) AS Avg_Correct
					FROM dbo.AggrptMCASItemStudentResults AS ds WITH (NOLOCK)
					WHERE (
							(ISNULL(ds.[LEAIdentifier], ' ') IN ('' + @LEAIdentifier + ''))
							AND (ds.TenantId = @Tenantid)
							)
						AND cast(replace(replace(Replace(StudentScore, '\', ''), '-', ''), '+', '') AS INT) > 0
					GROUP BY ds.[ItemId]
						,ds.[grade]
						,ds.LEAIdentifier
						,ds.SchoolIdentifier
						,ds.SubjectAreaCode
						,ds.TenantId
						,ds.SchoolYear
					) b ON a.LEAIdentifier = b.LEAIdentifier
					AND a.SubjectAreaCode = b.SubjectAreaCode
					AND a.[grade] = b.[grade]
					AND a.[ItemId] = b.[ItemId]
					AND a.SchoolIdentifier = b.SchoolIdentifier
					AND a.TenantId = b.TenantId
					AND a.SchoolYear = b.SchoolYear
				WHERE a.TenantId = @Tenantid
					AND a.SchoolYear = @CurrentYear

				UPDATE AggrptMCASItemAnalysis
				SET Avg_Correct = ROUND(Avg_Correct, 0, 0)
				WHERE TenantId = @Tenantid
					AND SchoolYear = @CurrentYear

				UPDATE AggrptMCASItemStudentResults
				SET Avg_Correct = ROUND(Avg_Correct, 0, 0)
				WHERE TenantId = @Tenantid
					AND SchoolYear = @CurrentYear

				UPDATE AggrptMCASItemAnalysis
				SET Avg_Correct = 0
				WHERE Avg_Correct IS NULL
					AND TenantId = @Tenantid
					AND SchoolYear = @CurrentYear

				UPDATE AggrptMCASItemStudentResults
				SET Avg_Correct = 0
				WHERE Avg_Correct IS NULL
					AND TenantId = @Tenantid
					AND SchoolYear = @CurrentYear

				UPDATE AggrptMCASItemAnalysis
				SET Avg_school_Correct = 0
				WHERE Avg_school_Correct IS NULL
					AND TenantId = @Tenantid
					AND SchoolYear = @CurrentYear

				UPDATE AggrptMCASItemStudentResults
				SET Avg_school_Correct = 0
				WHERE Avg_school_Correct IS NULL
					AND TenantId = @Tenantid
					AND SchoolYear = @CurrentYear

				UPDATE AggrptMCASItemAnalysis
				SET Diff_From_State = cast(Avg_Correct AS INT) - cast(State_Percent_Possible AS INT)
				WHERE TenantId = @Tenantid
					AND SchoolYear = @CurrentYear

				UPDATE a
				SET a.GradeDescription = b.GradeDescription
				FROM AggrptMCASItemStudentResults a
				INNER JOIN RefGrade b ON a.grade = b.GradeCode
					AND a.TenantId = b.TenantId
				WHERE a.TenantId = @Tenantid
					AND a.SchoolYear = @CurrentYear

				UPDATE a
				SET a.LeaName = b.OrganizationName
				FROM AggrptMCASItemStudentResults a
				INNER JOIN Main.K12LEA b ON a.LEAIdentifier = b.LEAIdentifier
					AND a.TenantId = b.TenantId
					AND a.SchoolYear = b.SchoolYear
				WHERE a.TenantId = @Tenantid
					AND a.SchoolYear = @CurrentYear

				UPDATE a
				SET a.SchoolName = b.NameofInstitution
				FROM AggrptMCASItemStudentResults a
				INNER JOIN Main.K12School b ON a.SchoolIdentifier = b.SchoolIdentifier
					AND a.TenantId = b.TenantId
					AND a.SchoolYear = b.SchoolYear
				WHERE a.TenantId = @Tenantid
					AND a.SchoolYear = @CurrentYear

				UPDATE a
				SET a.GradeDescription = b.GradeDescription
				FROM AggrptMCASItemAnalysis a
				INNER JOIN RefGrade b ON a.grade = b.GradeCode
					AND a.TenantId = b.TenantId
				WHERE a.TenantId = @Tenantid
					AND a.SchoolYear = @CurrentYear

				UPDATE a
				SET a.LeaName = b.OrganizationName
				FROM AggrptMCASItemAnalysis a
				INNER JOIN Main.K12LEA b ON a.LEAIdentifier = b.LEAIdentifier
					AND a.TenantId = b.TenantId
					AND a.SchoolYear = b.SchoolYear
				WHERE a.TenantId = @Tenantid
					AND a.SchoolYear = @CurrentYear

				UPDATE a
				SET a.SchoolName = b.NameofInstitution
				FROM AggrptMCASItemAnalysis a
				INNER JOIN Main.K12School b ON a.SchoolIdentifier = b.SchoolIdentifier
					AND a.TenantId = b.TenantId
					AND a.SchoolYear = b.SchoolYear
				WHERE a.TenantId = @Tenantid
					AND a.SchoolYear = @CurrentYear

				UPDATE a
				SET race = 'NA'
				FROM AggrptMCASItemStudentResults a
				WHERE race IS NULL
					AND a.TenantId = @Tenantid
					AND a.SchoolYear = @CurrentYear

				UPDATE AggrptMCASItemStudentResults
				SET StudentScore = NULL
				WHERE StudentScore = '-1'
					AND TenantId = @Tenantid
					AND SchoolYear = @CurrentYear

				FETCH NEXT
				FROM YearCursor
				INTO @CurrentYear;
			END;

			CLOSE YearCursor;

			DEALLOCATE YearCursor;
		END
	END TRY

	BEGIN CATCH
		-- Test whether the transaction is uncommittable.                         
		IF XACT_STATE() = - 1
		BEGIN
			ROLLBACK TRAN;
		END;

		--Comment it if SP contains only SELECT statement                                             
		DECLARE @ErrorFromProc VARCHAR(500);
		DECLARE @ProcErrorMessage VARCHAR(1000);
		DECLARE @SeverityLevel INT;
		DECLARE @ErrorNumber INT = ERROR_NUMBER();

		SELECT @ErrorFromProc = '[dbo].[USP_MCASItemAnalysis_ItemTypeDescriptionUpdation]'
			,@ProcErrorMessage = ERROR_MESSAGE()
			,@SeverityLevel = ERROR_SEVERITY();

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
			,GETDATE()
			,@Tenantid
			);

		RAISERROR (
				'Error Number-%d : Error Message-%s'
				,16
				,1
				,@ErrorNumber
				,@ProcErrorMessage
				)
	END CATCH;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[USP_MCASItemAnalysis_ReportsMasterData] (@Tenantid INT)
AS
BEGIN
	SET XACT_ABORT ON;
	SET NOCOUNT ON

	BEGIN TRY
		DECLARE @TenantCode VARCHAR(Max)

		SET @TenantCode = (
				SELECT TenantCode
				FROM idm.Tenant
				WHERE TenantId = @Tenantid
				)

		DROP TABLE

		IF EXISTS #ReportDetails
			SET @TenantId = cast(@TenantId AS VARCHAR)

		IF EXISTS (
				SELECT 1
				FROM INFORMATION_SCHEMA.TABLES
				WHERE TABLE_NAME = 'RptDomainRelatedViews'
				)
		BEGIN
			INSERT INTO RptDomainRelatedViews (
				EntityId
				,ViewName
				,DisplayName
				,ViewType
				,IsDynamic
				,DataSetQuery
				,NumberOfRecords
				,StoredProcedureName
				,IsCreatedFromRapidReport
				,StatusId
				,TenantId
				,CreatedBy
				,CreatedDate
				,ModifiedBy
				,ModifiedDate
				)
			SELECT *
			FROM (
				SELECT *
				FROM (
					SELECT DISTINCT NULL AS EntityId
						,REPLACE(ViewName, 'TenantCode', @TenantCode) AS ViewName
						,REPLACE(DomainRelatedViewsDisplayName, 'TenantCode', @TenantCode) AS DomainRelatedViewsDisplayName
						,ViewType
						,IsDynamic
						,REPLACE(REPLACE(DataSetQuery, 'TenantCode', @TenantCode), 'MCASTenantID', @TenantId) AS DataSetQuery
						,NumberOfRecords
						,StoredProcedureName
						,IsCreatedFromRapidReport
						,StatusId
						,@TenantId AS TenantId
						,CreatedBy
						,getdate() CreatedDate
						,NULL ModifiedBy
						,NULL ModifiedDate
					FROM AnalyticVue.dbo.MCASRptDomainRelatedViews
					) a
				) AS A
			WHERE NOT EXISTS (
					SELECT 1
					FROM RptDomainRelatedViews b
					WHERE a.ViewName = b.ViewName
						AND a.TenantId = b.TenantId
					)

			IF EXISTS (
					SELECT 1
					FROM INFORMATION_SCHEMA.TABLES
					WHERE TABLE_NAME = 'RptViewFields'
					)
			BEGIN
				INSERT INTO RptViewFields (
					DomainRelatedViewId
					,ColumnName
					,DisplayName
					,DataType
					,LookupTable
					,LookupColumn
					,ColumnTableName
					,SortOrder
					,TenantId
					,StatusId
					,CreatedBy
					,CreatedDate
					,ModifiedBy
					,ModifiedDate
					,SortbyColumnName
					)
				SELECT DISTINCT *
				FROM (
					SELECT drv1.DomainRelatedViewId
						,ColumnName
						,vf.DisplayName
						,DataType
						,LookupTable
						,LookupColumn
						,ColumnTableName
						,SortOrder
						,vf.TenantID
						,vf.StatusId
						,vf.CreatedBy
						,vf.CreatedDate
						,NULL ModifiedBy
						,NULL ModifiedDate
						,SortbyColumnName
					FROM (
						SELECT DISTINCT Replace(vf.ViewName, 'TenantCode', @TenantCode) AS ViewName
							,ColumnName
							,vf.DisplayName
							,DataType
							,Replace(vf.LookupTable, 'TenantCode', @TenantCode) AS LookupTable
							,LookupColumn
							,ColumnTableName
							,Cast(vf.ViewFieldsSortOrder AS INT) AS SortOrder
							,@TenantId AS TenantID
							,vf.StatusId
							,vf.CreatedBy
							,vf.CreatedDate
							,NULL ModifiedBy
							,NULL ModifiedDate
							,SortbyColumnName
						FROM AnalyticVue.dbo.MCASRptViewFields vf
						) vf
					INNER JOIN (
						SELECT DISTINCT REPLACE(DomainRelatedViewsDisplayName, 'TenantCode', @TenantCode) AS DomainRelatedViewsDisplayName
							,REPLACE(REPLACE(DataSetQuery, 'TenantCode', @TenantCode), 'MCASTenantID', @TenantId) AS DataSetQuery
							,Replace(ViewName, 'TenantCode', @TenantCode) AS ViewName
							,@Tenantid AS TenantID
						FROM AnalyticVue.dbo.MCASRptDomainRelatedViews
						) drv ON vf.ViewName = drv.ViewName
						AND vf.TenantId = drv.TenantId
					INNER JOIN RptDomainRelatedViews drv1 ON drv1.ViewName = drv.ViewName
						AND drv1.TenantId = drv.TenantId
						AND drv1.DisplayName = drv.DomainRelatedViewsDisplayName
						AND drv1.DataSetQuery = drv.DataSetQuery
					) AS a
				WHERE NOT EXISTS (
						SELECT 1
						FROM RptViewFields b
						WHERE a.DomainRelatedViewId = b.DomainRelatedViewId
							AND a.ColumnName = b.ColumnName
							AND a.TenantId = B.TenantId
						)
				ORDER BY SortOrder
			END
		END

		--ELA
		DECLARE @ELADistrictStudentId VARCHAR(150)
			,@ELAELL VARCHAR(max)
			,@ELAGender VARCHAR(100)
			,@ELAGrade VARCHAR(100)
			,@ELAHighNeeds VARCHAR(max)
			,@ELARace VARCHAR(Max)
			,@ELAReporting_Category VARCHAR(max)
			,@ELAItemTypeDescription VARCHAR(max)
			,@ELASchoolName VARCHAR(max)
			,@ELASchoolYear VARCHAR(10)
			,@ELAIsCorrect VARCHAR(max)
			,@ELADisabilityStatus VARCHAR(max)
			,@ELAItemId VARCHAR(250)
			,@ELAMA_Curriculum_Framework VARCHAR(max)
			,@ELALeaName VARCHAR(Max)
			,@ELAStudentScore VARCHAR(Max)
			,@ELATeacherName VARCHAR(max)
			,@ELACorrect_Answer VARCHAR(max)
			,@ELAItemtext VARCHAR(Max)
			,@ELAStudentName VARCHAR(Max)
			,@ELAItemMaxScore VARCHAR(Max)
		--Math
		DECLARE @MathDistrictStudentId VARCHAR(150)
			,@MathELL VARCHAR(max)
			,@MathGender VARCHAR(100)
			,@MathGradeDescription VARCHAR(100)
			,@MathHighNeeds VARCHAR(max)
			,@MathRace VARCHAR(Max)
			,@MathReporting_Category VARCHAR(max)
			,@MathItemTypeDescription VARCHAR(max)
			,@MathSchoolName VARCHAR(max)
			,@MathSchoolYear VARCHAR(10)
			,@MathIsCorrect VARCHAR(max)
			,@MathDisabilityStatus VARCHAR(max)
			,@MathAvg_School_Correct VARCHAR(max)
			,@MathItemId VARCHAR(Max)
			,@MathMA_Curriculum_Framework VARCHAR(max)
			,@MathItemMaxScore VARCHAR(max)
			,@MathCorrect_Answer VARCHAR(max)
			,@MathTeacherName VARCHAR(Max)
			,@MathStudentName VARCHAR(Max)
			,@MathItemtext VARCHAR(Max)
			,@MathItemTypeCode VARCHAR(Max)
			,@MathStudentScore VARCHAR(Max)
		--Science
		DECLARE @DistrictStudentId VARCHAR(150)
			,@ELL VARCHAR(max)
			,@Gender VARCHAR(100)
			,@Grade VARCHAR(100)
			,@HighNeeds VARCHAR(max)
			,@Race VARCHAR(Max)
			,@Reporting_Category VARCHAR(max)
			,@ItemTypeDescription VARCHAR(max)
			,@SchoolName VARCHAR(max)
			,@SchoolYear VARCHAR(10)
			,@IsCorrect VARCHAR(max)
			,@DisabilityStatus VARCHAR(max)
			,@ItemId VARCHAR(Max)
			,@MA_Curriculum_Framework VARCHAR(Max)
			,@StudentScore VARCHAR(Max)
			,@ItemMaxScore VARCHAR(Max)
			,@Correct_Answer VARCHAR(Max)
		--Agg
		DECLARE @AggLeaName VARCHAR(max)
			,@AggAvg_School_Correct VARCHAR(150)
			,@AggDistrictStudentId VARCHAR(150)
			,@AggGrade VARCHAR(100)
			,@AggReporting_Category VARCHAR(max)
			,@AggItemTypeDescription VARCHAR(max)
			,@AggSchoolName VARCHAR(max)
			,@AggSchoolYear VARCHAR(10)
			,@AggIsCorrect VARCHAR(max)
			,@AggDisabilityStatus VARCHAR(max)
			,@AggItemId VARCHAR(250)
			,@AggSubjectAreaCode VARCHAR(max)
			,@AggState_Percent_Possible VARCHAR(max)
			,@AggMA_Curriculum_Framework VARCHAR(max)

		/******* AggrptMCASItemAnalysis *******/
		SET @AggAvg_School_Correct = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_AggrptMCASItemAnalysis_DS'
						)
					AND DisplayName = 'Avg_School_Correct'
				)
		SET @AggGrade = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_AggrptMCASItemAnalysis_DS'
						)
					AND DisplayName = 'Grade'
				)
		SET @AggReporting_Category = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_AggrptMCASItemAnalysis_DS'
						)
					AND DisplayName = 'Reporting_Category'
				)
		SET @AggItemTypeDescription = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_AggrptMCASItemAnalysis_DS'
						)
					AND DisplayName = 'ItemTypeDescription'
				)
		SET @AggSchoolName = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_AggrptMCASItemAnalysis_DS'
						)
					AND DisplayName = 'SchoolName'
				)
		SET @AggSchoolYear = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_AggrptMCASItemAnalysis_DS'
						)
					AND DisplayName = 'SchoolYear'
				)
		SET @AggState_Percent_Possible = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_AggrptMCASItemAnalysis_DS'
						)
					AND DisplayName = 'State_Percent_Possible'
				)
		SET @AggItemId = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_AggrptMCASItemAnalysis_DS'
						)
					AND DisplayName = 'ItemId'
				)
		SET @AggSubjectAreaCode = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_AggrptMCASItemAnalysis_DS'
						)
					AND DisplayName = 'SubjectAreaCode'
				)
		SET @AggMA_Curriculum_Framework = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_AggrptMCASItemAnalysis_DS'
						)
					AND DisplayName = 'MA_Curriculum_Framework'
				)
		SET @AggLeaName = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_AggrptMCASItemAnalysis_DS'
						)
					AND DisplayName = 'LeaName'
				)
		/********* Math *********/
		SET @MathDistrictStudentId = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Maths_DS'
						)
					AND DisplayName = 'DistrictStudentId'
				)
		SET @MathELL = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Maths_DS'
						)
					AND DisplayName = 'ELL'
				)
		SET @MathGender = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Maths_DS'
						)
					AND DisplayName = 'Gender'
				)
		SET @MathGradeDescription = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Maths_DS'
						)
					AND DisplayName = 'GradeDescription'
				)
		SET @MathHighNeeds = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Maths_DS'
						)
					AND DisplayName = 'HighNeeds'
				)
		SET @MathRace = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Maths_DS'
						)
					AND DisplayName = 'Race'
				)
		SET @MathReporting_Category = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Maths_DS'
						)
					AND DisplayName = 'Reporting_Category'
				)
		SET @MathItemTypeDescription = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Maths_DS'
						)
					AND DisplayName = 'ItemTypeDescription'
				)
		SET @MathSchoolName = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Maths_DS'
						)
					AND DisplayName = 'SchoolName'
				)
		SET @MathSchoolYear = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Maths_DS'
						)
					AND DisplayName = 'SchoolYear'
				)
		SET @MathDisabilityStatus = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Maths_DS'
						)
					AND DisplayName = 'DisabilityStatus'
				)
		SET @MathIsCorrect = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Maths_DS'
						)
					AND DisplayName = 'IsCorrect'
				)
		SET @MathAvg_School_Correct = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Maths_DS'
						)
					AND DisplayName = 'Avg_School_Correct'
				)
		SET @MathItemId = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Maths_DS'
						)
					AND DisplayName = 'ItemId'
				)
		SET @MathMA_Curriculum_Framework = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Maths_DS'
						)
					AND DisplayName = 'MA_Curriculum_Framework'
				)
		SET @MathCorrect_Answer = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Maths_DS'
						)
					AND DisplayName = 'Correct_Answer'
				)
		SET @MathItemMaxScore = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Maths_DS'
						)
					AND DisplayName = 'ItemMaxScore'
				)
		SET @MathTeacherName = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Maths_DS'
						)
					AND DisplayName = 'TeacherName'
				)
		SET @MathStudentName = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Maths_DS'
						)
					AND DisplayName = 'StudentName'
				)
		SET @MathItemtext = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Maths_DS'
						)
					AND DisplayName = 'Itemtext'
				)
		SET @MathItemTypeCode = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Maths_DS'
						)
					AND DisplayName = 'ItemTypeCode'
				)
		SET @MathStudentScore = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Maths_DS'
						)
					AND DisplayName = 'StudentScore'
				)
		/********* ELA *********/
		SET @ELADistrictStudentId = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_ELA_DS'
						)
					AND DisplayName = 'DistrictStudentId'
				)
		SET @ELAELL = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_ELA_DS'
						)
					AND DisplayName = 'ELL'
				)
		SET @ELAGender = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_ELA_DS'
						)
					AND DisplayName = 'Gender'
				)
		SET @ELAGrade = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_ELA_DS'
						)
					AND DisplayName = 'Grade'
				)
		SET @ELAHighNeeds = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_ELA_DS'
						)
					AND DisplayName = 'HighNeeds'
				)
		SET @ELARace = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_ELA_DS'
						)
					AND DisplayName = 'Race'
				)
		SET @ELAReporting_Category = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_ELA_DS'
						)
					AND DisplayName = 'Reporting_Category'
				)
		SET @ELAItemTypeDescription = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_ELA_DS'
						)
					AND DisplayName = 'ItemTypeDescription'
				)
		SET @ELASchoolName = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_ELA_DS'
						)
					AND DisplayName = 'SchoolName'
				)
		SET @ELASchoolYear = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_ELA_DS'
						)
					AND DisplayName = 'SchoolYear'
				)
		SET @ELADisabilityStatus = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_ELA_DS'
						)
					AND DisplayName = 'DisabilityStatus'
				)
		SET @ELAIsCorrect = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_ELA_DS'
						)
					AND DisplayName = 'IsCorrect'
				)
		SET @ELAItemId = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_ELA_DS'
						)
					AND DisplayName = 'ItemId'
				)
		SET @ELAMA_Curriculum_Framework = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_ELA_DS'
						)
					AND DisplayName = 'MA_Curriculum_Framework'
				)
		SET @ELALeaName = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_ELA_DS'
						)
					AND DisplayName = 'LeaName'
				)
		SET @ELAStudentScore = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_ELA_DS'
						)
					AND DisplayName = 'StudentScore'
				)
		SET @ELATeacherName = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_ELA_DS'
						)
					AND DisplayName = 'TeacherName'
				)
		SET @ELACorrect_Answer = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_ELA_DS'
						)
					AND DisplayName = 'Correct_Answer'
				)
		SET @ELAItemtext = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_ELA_DS'
						)
					AND DisplayName = 'Itemtext'
				)
		SET @ELAStudentName = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_ELA_DS'
						)
					AND DisplayName = 'StudentName'
				)
		SET @ELAItemMaxScore = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_ELA_DS'
						)
					AND DisplayName = 'ItemMaxScore'
				)
		/********* Science *********/
		SET @DistrictStudentId = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Science_DS'
						)
					AND DisplayName = 'DistrictStudentId'
				)
		SET @ELL = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Science_DS'
						)
					AND DisplayName = 'ELL'
				)
		SET @Gender = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Science_DS'
						)
					AND DisplayName = 'Gender'
				)
		SET @Grade = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Science_DS'
						)
					AND DisplayName = 'Grade'
				)
		SET @HighNeeds = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Science_DS'
						)
					AND DisplayName = 'HighNeeds'
				)
		SET @Race = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Science_DS'
						)
					AND DisplayName = 'Race'
				)
		SET @Reporting_Category = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Science_DS'
						)
					AND DisplayName = 'Reporting_Category'
				)
		SET @ItemTypeDescription = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Science_DS'
						)
					AND DisplayName = 'ItemTypeDescription'
				)
		SET @SchoolName = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Science_DS'
						)
					AND DisplayName = 'SchoolName'
				)
		SET @SchoolYear = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Science_DS'
						)
					AND DisplayName = 'SchoolYear'
				)
		SET @DisabilityStatus = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Science_DS'
						)
					AND DisplayName = 'DisabilityStatus'
				)
		SET @IsCorrect = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Science_DS'
						)
					AND DisplayName = 'IsCorrect'
				)
		SET @ItemId = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Science_DS'
						)
					AND DisplayName = 'ItemId'
				)
		SET @MA_Curriculum_Framework = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Science_DS'
						)
					AND DisplayName = 'MA_Curriculum_Framework'
				)
		SET @StudentScore = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Science_DS'
						)
					AND DisplayName = 'StudentScore'
				)
		SET @ItemMaxScore = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Science_DS'
						)
					AND DisplayName = 'ItemMaxScore'
				)
		SET @Correct_Answer = (
				SELECT TOP 1 RptViewFieldsId
				FROM RptViewFields
				WHERE DomainRelatedViewId IN (
						SELECT DomainRelatedViewId
						FROM RptDomainRelatedViews
						WHERE DisplayName = '' + @TenantCode + '_MCASItemStudentTeacherResults_Science_DS'
						)
					AND DisplayName = 'Correct_Answer'
				)

		SELECT *
		INTO #ReportDetails
		FROM (
			--ELA
			SELECT 'MCAS - ELA Avg % by Item Category' AS ReportDetailsName
				,'What is the Average % by Item category in MCAS ELA?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[Reporting_Category] as [Reporting_Category], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[Reporting_Category] = ds1.[Reporting_Category]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[Reporting_Category],ds.[IsCorrect]  ORDER BY ds.[Reporting_Category] ASC,ds.[IsCorrect] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @ELADistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["IsCorrect"],"CategoryColumns":["Reporting_Category"],"AliasNameList":[{"Name":"Reporting_Category","AliasName":"Item Category"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"DistrictStudentId","AliasName":"Avg %"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' 
				+ @ELAELL + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @ELAGender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @ELAGrade + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"High Needs","SortOrder":0,"FiledId":"' + @ELAHighNeeds + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @ELARace + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @ELAReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ELAItemTypeDescription + 
				'","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School","SortOrder":0,"FiledId":"' + @ELASchoolName + '","DefaultValue":null},{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @ELASchoolYear + '","DefaultValue":null},{"DisplayName":"DisabilityStatus","ColumnName":"DisabilityStatus","AliasName":"Disability Status","SortOrder":0,"FiledId":"' + @ELADisabilityStatus + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @ELASchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @ELASchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @ELAGender + 
				'","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @ELAGrade + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @ELARace + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @ELAReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ELAItemTypeDescription + '","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_12' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6132' AS ReportDetailsCode
				,NULL AS ChildReportDetailsName
				,NULL AS LinkedReportDataSourceName
				,'0' AS [Min]
				,'100' AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"Reporting_Category","SortType":"Ascending","SortByFieldId":' + @ELAReporting_Category + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @ELAIsCorrect + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @ELADistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - ELA Avg % by Item type' AS ReportDetailsName
				,'What is the Average % by Item type in MCAS ELA?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[ItemTypeDescription] as [ItemTypeDescription], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[ItemTypeDescription] = ds1.[ItemTypeDescription]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[ItemTypeDescription],ds.[IsCorrect]  ORDER BY ds.[ItemTypeDescription] ASC,ds.[IsCorrect] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @ELADistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["IsCorrect"],"CategoryColumns":["ItemTypeDescription"],"AliasNameList":[{"Name":"ItemTypeDescription","AliasName":"Item Type"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"DistrictStudentId","AliasName":"Avg %"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' 
				+ @ELAELL + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @ELAGender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @ELAGrade + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"HighNeeds","SortOrder":0,"FiledId":"' + @ELAHighNeeds + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @ELARace + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @ELAReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ELAItemTypeDescription + 
				'","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @ELASchoolName + '","DefaultValue":null},{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @ELASchoolYear + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @ELASchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @ELASchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @ELAGender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @ELAGrade + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + 
				@ELARace + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ELAItemTypeDescription + '","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_15' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6141' AS ReportDetailsCode
				,NULL AS ChildReportDetailsName
				,NULL AS LinkedReportDataSourceName
				,'0' AS [Min]
				,'100' AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"ItemTypeDescription","SortType":"Ascending","SortByFieldId":' + @ELAItemTypeDescription + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @ELAIsCorrect + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @ELADistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - ELA Avg % correct by Item Category' AS ReportDetailsName
				,'What is the Average correct % by Item category in MCAS ELA?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[Reporting_Category] as [Reporting_Category], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[Reporting_Category] = ds1.[Reporting_Category]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ISNULL(ds.[IsCorrect],'' '') = ''Correct'') AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[Reporting_Category],ds.[IsCorrect]  ORDER BY ds.[Reporting_Category] ASC,ds.[IsCorrect] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @ELADistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["IsCorrect"],"CategoryColumns":["Reporting_Category"],"AliasNameList":[{"Name":"Reporting_Category","AliasName":"Item Category"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"DistrictStudentId","AliasName":"Avg % Correct"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' 
				+ @ELAELL + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @ELAGender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @ELAGrade + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"HighNeeds","SortOrder":0,"FiledId":"' + @ELAHighNeeds + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @ELARace + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @ELAReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ELAItemTypeDescription + 
				'","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @ELASchoolName + '","DefaultValue":null},{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @ELASchoolYear + '","DefaultValue":null},{"DisplayName":"LeaName","ColumnName":"LeaName","AliasName":"District","SortOrder":0,"FiledId":"' + @ELALeaName + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @ELASchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @ELASchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @ELAGender + 
				'","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @ELAGrade + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @ELARace + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @ELAReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ELAItemTypeDescription + '","DefaultValue":null},{"DisplayName":"DisabilityStatus","ColumnName":"DisabilityStatus","AliasName":"DisabilityStatus","SortOrder":0,"FiledId":"' + @ELADisabilityStatus + '","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_13' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6136' AS ReportDetailsCode
				,'MCAS - ELA-Avg % correct by Item ' AS ChildReportDetailsName
				,'' + @TenantCode + '_MCASItemStudentTeacherResults_ELA_DS' AS LinkedReportDataSourceName
				,'0' AS [Min]
				,'100' AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"Reporting_Category","SortType":"Ascending","SortByFieldId":' + @ELAReporting_Category + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @ELAIsCorrect + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @ELADistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null},{"Filter":"IsCorrect","ComaprisonType":"Equals","ComaprisonValue":"Correct","FilterByField":null,"FilterByFieldId":' + @ELAIsCorrect + 
				',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":false,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - ELA Avg % correct by Item type and Category' AS ReportDetailsName
				,'What is the Average % correct by Item type and Category in MCAS ELA?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[ItemTypeDescription] as [ItemTypeDescription], ds.[Reporting_Category] as [Reporting_Category], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[ItemTypeDescription] = ds1.[ItemTypeDescription]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ISNULL(ds.[IsCorrect],'' '') = ''Correct'') AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[ItemTypeDescription],ds.[Reporting_Category],ds.[IsCorrect]  ORDER BY ds.[ItemTypeDescription] ASC,ds.[Reporting_Category] ASC,ds.[IsCorrect] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @ELADistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["Reporting_Category","IsCorrect"],"CategoryColumns":["ItemTypeDescription"],"AliasNameList":[{"Name":"ItemTypeDescription","AliasName":"Item Type"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"Reporting_Category","AliasName":"Item Category"},{"Name":"DistrictStudentId","AliasName":"Avg % Correct"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' 
				+ @ELASchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @ELASchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @ELAGender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @ELAGrade + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @ELARace + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ELAItemTypeDescription + '","DefaultValue":null},{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' + @ELAELL + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"HighNeeds","SortOrder":0,"FiledId":"' + @ELAHighNeeds + 
				'","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @ELAReporting_Category + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @ELASchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @ELASchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @ELAGender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @ELAGrade + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @ELARace + 
				'","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ELAItemTypeDescription + '","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_19' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6148' AS ReportDetailsCode
				,'MCAS - ELA-Avg % correct by Item ' AS ChildReportDetailsName
				,'' + @TenantCode + '_MCASItemStudentTeacherResults_ELA_DS' AS LinkedReportDataSourceName
				,'0' AS [Min]
				,'100' AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"ItemTypeDescription","SortType":"Ascending","SortByFieldId":' + @ELAItemTypeDescription + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"Reporting_Category","SortType":"Ascending","SortByFieldId":' + @ELAReporting_Category + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @ELAIsCorrect + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @ELADistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null},{"Filter":"IsCorrect","ComaprisonType":"Equals","ComaprisonValue":"Correct","FilterByField":null,"FilterByFieldId":' + @ELAIsCorrect + 
				',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":false,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - ELA Avg % correct by Item type' AS ReportDetailsName
				,'What is the Average % correct by Item type in MCAS ELA?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[ItemTypeDescription] as [ItemTypeDescription], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[ItemTypeDescription] = ds1.[ItemTypeDescription]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ISNULL(ds.[IsCorrect],'' '') = ''Correct'') AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[ItemTypeDescription],ds.[IsCorrect]  ORDER BY ds.[ItemTypeDescription] ASC,ds.[IsCorrect] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @ELADistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["IsCorrect"],"CategoryColumns":["ItemTypeDescription"],"AliasNameList":[{"Name":"ItemTypeDescription","AliasName":"Item Type"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"DistrictStudentId","AliasName":"Avg % Correct"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' 
				+ @ELAELL + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @ELAGender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @ELAGrade + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"HighNeeds","SortOrder":0,"FiledId":"' + @ELAHighNeeds + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @ELARace + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @ELAReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ELAItemTypeDescription + 
				'","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @ELASchoolName + '","DefaultValue":null},{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @ELASchoolYear + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @ELASchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @ELASchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @ELAGender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @ELAGrade + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + 
				@ELARace + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ELAItemTypeDescription + '","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_16' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6142' AS ReportDetailsCode
				,'MCAS - ELA-Avg % correct by Item ' AS ChildReportDetailsName
				,'' + @TenantCode + '_MCASItemStudentTeacherResults_ELA_DS' AS LinkedReportDataSourceName
				,'0' AS [Min]
				,'100' AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"ItemTypeDescription","SortType":"Ascending","SortByFieldId":' + @ELAItemTypeDescription + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @ELAIsCorrect + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @ELADistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null},{"Filter":"IsCorrect","ComaprisonType":"Equals","ComaprisonValue":"Correct","FilterByField":null,"FilterByFieldId":' + @ELAIsCorrect + 
				',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":false,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - ELA Avg % Incorrect by Item type and Category' AS ReportDetailsName
				,'What is the Average % Incorrect by Item type and Category in MCAS ELA?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[ItemTypeDescription] as [ItemTypeDescription], ds.[Reporting_Category] as [Reporting_Category], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[ItemTypeDescription] = ds1.[ItemTypeDescription]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ISNULL(ds.[IsCorrect],'' '') = ''Incorrect'') AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[ItemTypeDescription],ds.[Reporting_Category],ds.[IsCorrect]  ORDER BY ds.[ItemTypeDescription] ASC,ds.[Reporting_Category] ASC,ds.[IsCorrect] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @ELADistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["Reporting_Category","IsCorrect"],"CategoryColumns":["ItemTypeDescription"],"AliasNameList":[{"Name":"ItemTypeDescription","AliasName":"Item Type"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"Reporting_Category","AliasName":"Item Category"},{"Name":"DistrictStudentId","AliasName":"Avg % Incorrect"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' 
				+ @ELASchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @ELASchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @ELAGender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @ELAGrade + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @ELARace + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ELAItemTypeDescription + '","DefaultValue":null},{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' + @ELAELL + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"HighNeeds","SortOrder":0,"FiledId":"' + @ELAHighNeeds + 
				'","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @ELAReporting_Category + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @ELASchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @ELASchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @ELAGender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @ELAGrade + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @ELARace + 
				'","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ELAItemTypeDescription + '","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_20' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6144' AS ReportDetailsCode
				,'MCAS - ELA-Avg % Incorrect by Item ' AS ChildReportDetailsName
				,'' + @TenantCode + '_MCASItemStudentTeacherResults_ELA_DS' AS LinkedReportDataSourceName
				,'0' AS [Min]
				,'100' AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"ItemTypeDescription","SortType":"Ascending","SortByFieldId":' + @ELAItemTypeDescription + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"Reporting_Category","SortType":"Ascending","SortByFieldId":' + @ELAReporting_Category + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @ELAIsCorrect + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @ELADistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null},{"Filter":"IsCorrect","ComaprisonType":"Equals","ComaprisonValue":"Incorrect","FilterByField":null,"FilterByFieldId":' + @ELAIsCorrect + 
				',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":false,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - ELA Avg % Incorrect by Item type' AS ReportDetailsName
				,'What is the Average % Incorrect by Item type in MCAS ELA?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[ItemTypeDescription] as [ItemTypeDescription], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[ItemTypeDescription] = ds1.[ItemTypeDescription]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ISNULL(ds.[IsCorrect],'' '') = ''Incorrect'') AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[ItemTypeDescription],ds.[IsCorrect]  ORDER BY ds.[IsCorrect] ASC,ds.[ItemTypeDescription] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @ELADistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["IsCorrect"],"CategoryColumns":["ItemTypeDescription"],"AliasNameList":[{"Name":"ItemTypeDescription","AliasName":"Item Type"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"DistrictStudentId","AliasName":"AVG % Incorrect"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' 
				+ @ELAELL + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @ELAGender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Grade","SortOrder":0,"FiledId":"' + @ELAGrade + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"High Needs","SortOrder":0,"FiledId":"' + @ELAHighNeeds + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @ELARace + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @ELAReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ELAItemTypeDescription + 
				'","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @ELASchoolName + '","DefaultValue":null},{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @ELASchoolYear + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @ELASchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @ELASchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @ELAGender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Grade","SortOrder":0,"FiledId":"' + @ELAGrade + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @ELARace + 
				'","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item type","SortOrder":0,"FiledId":"' + @ELAItemTypeDescription + '","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,NULL AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6138' AS ReportDetailsCode
				,'MCAS - ELA-Avg % Incorrect by Item type' AS ChildReportDetailsName
				,'' + @TenantCode + '_MCASItemStudentTeacherResults_ELA_DS' AS LinkedReportDataSourceName
				,'0' AS [Min]
				,'100' AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @ELAIsCorrect + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"ItemTypeDescription","SortType":"Ascending","SortByFieldId":' + @ELAItemTypeDescription + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @ELADistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null},{"Filter":"IsCorrect","ComaprisonType":"Equals","ComaprisonValue":"Incorrect","FilterByField":null,"FilterByFieldId":' + @ELAIsCorrect + 
				',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":false,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - ELA Item Analysis School Avg % correct VS State Avg % correct' AS ReportDetailsName
				,'What is  School Avg % correct VS State Avg % correct  by Item in MCAS ELA?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[SchoolName] as [SchoolName], ds.[ItemId] as [ItemId],cast(Avg(cast(ISNULL(ds.[Avg_School_Correct], 0) as decimal(15,1)))  as decimal(15,1)) as [Avg_School_Correct],cast(Avg(cast(ISNULL(ds.[State_Percent_Possible], 0) as decimal(15,1)))  as decimal(15,1)) as [State_Percent_Possible]  FROM dbo.' + @TenantCode + 'AggrptMCASItemAnalysisDS as ds with (nolock)  LEFT JOIN dbo.' + @TenantCode + '_MCAS_Item_SortOrder_Vw ON ds.[ItemId] = dbo.' + @TenantCode + '_MCAS_Item_SortOrder_Vw.itemid AND  ds.tenantid =dbo.' + @TenantCode + '_MCAS_Item_SortOrder_Vw.tenantid    WHERE  ((ISNUMERIC(ISNULL(ds.[Avg_School_Correct], 0)) = 1) AND (ISNUMERIC(ISNULL(ds.[State_Percent_Possible], 0)) = 1) AND (ISNULL(ds.[SubjectAreaCode],'' '') = ''ELA'') AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[SchoolName],ds.[ItemId],dbo.' + @TenantCode + '_MCAS_Item_SortOrder_Vw.SortOrder  ORDER BY ds.[SchoolName] ASC,dbo.' + @TenantCode + '_MCAS_Item_SortOrder_Vw.SortOrder ASC,ds.[ItemId] ASC ' AS 
				ReportQuery
				,'dbo.' + @TenantCode + 'AggrptMCASItemAnalysisDS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @AggAvg_School_Correct + 
				'","Value":"Avg_School_Correct","Code":"Avg","ChartType":"Line","IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false},{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @AggState_Percent_Possible + 
				'","Value":"State_Percent_Possible","Code":"Avg","ChartType":"Line","IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":null,"CategoryColumns":["SchoolName","ItemId"],"AliasNameList":[{"Name":"SchoolName","AliasName":"School"},{"Name":"ItemId","AliasName":"Item"},{"Name":"State_Percent_Possible","AliasName":"State Avg % correct"},{"Name":"Avg_School_Correct","AliasName":"School Avg % correct"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' 
				+ @AggSchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @AggSchoolName + '","DefaultValue":null},{"DisplayName":"Grade","ColumnName":"Grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @AggGrade + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @AggReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @AggItemTypeDescription + '","DefaultValue":null},{"DisplayName":"MA_Curriculum_Framework","ColumnName":"MA_Curriculum_Framework","AliasName":"Curriculum Framework","SortOrder":0,"FiledId":"' + @AggMA_Curriculum_Framework + '","DefaultValue":null},{"DisplayName":"ItemId","ColumnName":"ItemId","AliasName":"Item","SortOrder":0,"FiledId":"' + @AggItemId + 
				'","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @AggSchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @AggSchoolName + '","DefaultValue":null},{"DisplayName":"Grade","ColumnName":"Grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @AggGrade + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @AggReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @AggItemTypeDescription + '","DefaultValue":null},{"DisplayName":"ItemId","ColumnName":"ItemId","AliasName":"Item","SortOrder":0,"FiledId":"' + @AggItemId + 
				'","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_22' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6158' AS ReportDetailsCode
				,NULL AS ChildReportDetailsName
				,NULL AS LinkedReportDataSourceName
				,NULL AS [Min]
				,NULL AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"SchoolName","SortType":"Ascending","SortByFieldId":' + @AggSchoolName + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"ItemId","SortType":"Ascending","SortByFieldId":' + @AggItemId + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"SubjectAreaCode","ComaprisonType":"Equals","ComaprisonValue":"ELA","FilterByField":null,"FilterByFieldId":' + @AggSubjectAreaCode + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - ELA Item Analysis Students List' AS ReportDetailsName
				,'MCAS - ELA Item Analysis Students List' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[DistrictStudentId] as [DistrictStudentId], ds.[StudentName] as [StudentName], ds.[gender] as [gender], ds.[grade] as [grade], ds.[ItemId] as [ItemId], ds.[Itemtext] as [Itemtext], ds.[ItemTypeDescription] as [ItemTypeDescription], ds.[Reporting_Category] as [Reporting_Category], ds.[ItemMaxScore] as [ItemMaxScore], ds.[Correct_Answer] as [Correct_Answer], ds.[StudentScore] as [StudentScore], ds.[SchoolName] as [SchoolName]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS as ds with (nolock)  LEFT JOIN dbo.' + @TenantCode + '_MCAS_Item_SortOrder_Vw ON ds.[ItemId] = dbo.' + @TenantCode + '_MCAS_Item_SortOrder_Vw.itemid AND  ds.tenantid =dbo.' + @TenantCode + '_MCAS_Item_SortOrder_Vw.tenantid    WHERE  (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + ')   ORDER BY ds.[DistrictStudentId] ASC,dbo.' + @TenantCode + '_MCAS_Item_SortOrder_Vw.SortOrder ASC,ds.[ItemId] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS' AS ViewName
				,'Table' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,
				'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":null,"SeriesColumn":null,"CategoryColumns":["DistrictStudentId","StudentName","gender","grade","ItemId","Itemtext","ItemTypeDescription","Reporting_Category","ItemMaxScore","Correct_Answer","StudentScore","SchoolName"],"AliasNameList":[{"Name":"DistrictStudentId","AliasName":"DistrictStudentId"},{"Name":"StudentName","AliasName":"Student Name"},{"Name":"gender","AliasName":"Gender"},{"Name":"ItemId","AliasName":"Item"},{"Name":"Itemtext","AliasName":"Item Description"},{"Name":"ItemTypeDescription","AliasName":"Item Type"},{"Name":"ItemMaxScore","AliasName":"Max Score"},{"Name":"SchoolName","AliasName":"School Name"},{"Name":"StudentScore","AliasName":"Student Score"},{"Name":"Correct_Answer","AliasName":"Correct Answer"},{"Name":"Reporting_Category","AliasName":"Item Category"},{"Name":"grade","AliasName":"Tested Grade"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' 
				+ @ELAELL + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @ELAGender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @ELAGrade + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"HighNeeds","SortOrder":0,"FiledId":"' + @ELAHighNeeds + '","DefaultValue":null},{"DisplayName":"ItemId","ColumnName":"ItemId","AliasName":"Item","SortOrder":0,"FiledId":"' + @ELAItemId + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ELAItemTypeDescription + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @ELARace + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + 
				@ELAReporting_Category + '","DefaultValue":null},{"DisplayName":"MA_Curriculum_Framework","ColumnName":"MA_Curriculum_Framework","AliasName":"Curriculum Framework","SortOrder":0,"FiledId":"' + @ELAMA_Curriculum_Framework + '","DefaultValue":null},{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @ELASchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @ELASchoolName + '","DefaultValue":null},{"DisplayName":"StudentScore","ColumnName":"StudentScore","AliasName":"Student Score","SortOrder":0,"FiledId":"' + @ELAStudentScore + '","DefaultValue":null}],"SubGroupColumns":null,"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,NULL AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6164' AS ReportDetailsCode
				,NULL AS ChildReportDetailsName
				,NULL AS LinkedReportDataSourceName
				,NULL AS [Min]
				,NULL AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"DistrictStudentId","SortType":"Ascending","SortByFieldId":' + @ELADistrictStudentId + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"ItemId","SortType":"Ascending","SortByFieldId":' + @ELAItemId + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - ELA Item Analysis' AS ReportDetailsName
				,'MCAS - ELA Item Analysis' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[itemlink] as [itemlink], ds.[LeaName] as [LeaName], ds.[SchoolName] as [SchoolName], ds.[Grade] as [Grade], ds.[Reporting_Category] as [Reporting_Category], ds.[ItemTypeDescription] as [ItemTypeDescription], ds.[ItemId] as [ItemId], ds.[Itemtext] as [Itemtext], ds.[Avg_School_Correct] as [Avg_School_Correct], ds.[Avg_Correct] as [Avg_Correct], ds.[State_Percent_Possible] as [State_Percent_Possible], ds.[Diff_From_School_State] as [Diff_From_School_State], ds.[Diff_From_State] as [Diff_From_State]  FROM dbo.' + @TenantCode + 'AggrptMCASItemAnalysisDS as ds with (nolock)  LEFT JOIN dbo.' + @TenantCode + '_MCAS_Item_SortOrder_Vw ON ds.[ItemId] = dbo.' + @TenantCode + '_MCAS_Item_SortOrder_Vw.itemid AND  ds.tenantid =dbo.' + @TenantCode + '_MCAS_Item_SortOrder_Vw.tenantid    WHERE  ((ISNULL(ds.[SubjectAreaCode],'' '') = ''ELA'') AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   ORDER BY ds.[LeaName] ASC,ds.[SchoolName] ASC,ds.[Grade] ASC,dbo.' + @TenantCode + 
				'_MCAS_Item_SortOrder_Vw.SortOrder ASC,ds.[ItemId] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'AggrptMCASItemAnalysisDS' AS ViewName
				,'Table' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,
				'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":null,"SeriesColumn":null,"CategoryColumns":["itemlink","LeaName","SchoolName","Grade","Reporting_Category","ItemTypeDescription","ItemId","Itemtext","Avg_School_Correct","Avg_Correct","State_Percent_Possible","Diff_From_School_State","Diff_From_State"],"AliasNameList":[{"Name":"LeaName","AliasName":"District"},{"Name":"SchoolName","AliasName":"School"},{"Name":"Grade","AliasName":"Tested Grade"},{"Name":"Reporting_Category","AliasName":"Item Category"},{"Name":"ItemTypeDescription","AliasName":"Item Type"},{"Name":"ItemId","AliasName":"Item"},{"Name":"Itemtext","AliasName":"Item Description"},{"Name":"Avg_School_Correct","AliasName":"Avg School % Correct"},{"Name":"Avg_Correct","AliasName":"Avg District % Correct"},{"Name":"State_Percent_Possible","AliasName":"Avg State % Correct"},{"Name":"Diff_From_School_State","AliasName":"Diff From School to State"},{"Name":"Diff_From_State","AliasName":"Diff From District to State"},{"Name":"itemlink","AliasName":"Item Link"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"LeaName","ColumnName":"LeaName","AliasName":"District","SortOrder":0,"FiledId":"' 
				+ @AggLeaName + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School","SortOrder":0,"FiledId":"' + @AggSchoolName + '","DefaultValue":null},{"DisplayName":"Grade","ColumnName":"Grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @AggGrade + '","DefaultValue":null},{"DisplayName":"ItemId","ColumnName":"ItemId","AliasName":"Item","SortOrder":0,"FiledId":"' + @AggItemId + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @AggItemTypeDescription + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @AggReporting_Category + '","DefaultValue":null},{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @AggSchoolYear + 
				'","DefaultValue":null}],"SubGroupColumns":null,"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_21' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6155' AS ReportDetailsCode
				,NULL AS ChildReportDetailsName
				,NULL AS LinkedReportDataSourceName
				,NULL AS [Min]
				,NULL AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"LeaName","SortType":"Ascending","SortByFieldId":' + @AggLeaName + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"SchoolName","SortType":"Ascending","SortByFieldId":' + @AggSchoolName + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"Grade","SortType":"Ascending","SortByFieldId":' + @AggGrade + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"ItemId","SortType":"Ascending","SortByFieldId":' + @AggItemId + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"SubjectAreaCode","ComaprisonType":"Equals","ComaprisonValue":"ELA","FilterByField":null,"FilterByFieldId":' + @AggSubjectAreaCode + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - ELA-Avg % by Item type and Category' AS ReportDetailsName
				,'What is the Average % by Item type and Category in MCAS ELA?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[ItemTypeDescription] as [ItemTypeDescription], ds.[Reporting_Category] as [Reporting_Category], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[ItemTypeDescription] = ds1.[ItemTypeDescription]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[ItemTypeDescription],ds.[Reporting_Category],ds.[IsCorrect]  ORDER BY ds.[ItemTypeDescription] ASC,ds.[Reporting_Category] ASC,ds.[IsCorrect] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @ELADistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["Reporting_Category","IsCorrect"],"CategoryColumns":["ItemTypeDescription"],"AliasNameList":[{"Name":"ItemTypeDescription","AliasName":"Item Type"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"Reporting_Category","AliasName":"Item Category"},{"Name":"DistrictStudentId","AliasName":"Avg %"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' 
				+ @ELASchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @ELASchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @ELAGender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @ELAGrade + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @ELARace + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ELAItemTypeDescription + '","DefaultValue":null},{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' + @ELAELL + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"HighNeeds","SortOrder":0,"FiledId":"' + @ELAHighNeeds + 
				'","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @ELAReporting_Category + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @ELASchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @ELASchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @ELAGender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @ELAGrade + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @ELARace + 
				'","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ELAItemTypeDescription + '","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_18' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6146' AS ReportDetailsCode
				,NULL AS ChildReportDetailsName
				,NULL AS LinkedReportDataSourceName
				,'0' AS [Min]
				,'100' AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"ItemTypeDescription","SortType":"Ascending","SortByFieldId":' + @ELAItemTypeDescription + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"Reporting_Category","SortType":"Ascending","SortByFieldId":' + @ELAReporting_Category + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @ELAIsCorrect + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @ELADistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - ELA-Avg % correct by Item ' AS ReportDetailsName
				,'What is the Average % correct by Item  in MCAS ELA?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[ItemId] as [ItemId], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[ItemId] = ds1.[ItemId]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ISNULL(ds.[IsCorrect],'' '') = ''Correct'') AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[ItemId],ds.[IsCorrect]  ORDER BY ds.[ItemId] ASC,ds.[IsCorrect] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @ELADistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["IsCorrect"],"CategoryColumns":["ItemId"],"AliasNameList":[{"Name":"ItemId","AliasName":"Item"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"DistrictStudentId","AliasName":"Avg % Correct"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' 
				+ @ELAELL + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @ELAGender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @ELAGrade + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"HighNeeds","SortOrder":0,"FiledId":"' + @ELAHighNeeds + '","DefaultValue":null},{"DisplayName":"ItemId","ColumnName":"ItemId","AliasName":"Item","SortOrder":0,"FiledId":"' + @ELAItemId + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ELAItemTypeDescription + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @ELARace + 
				'","DefaultValue":null},{"DisplayName":"MA_Curriculum_Framework","ColumnName":"MA_Curriculum_Framework","AliasName":"Curriculum Framework","SortOrder":0,"FiledId":"' + @ELAMA_Curriculum_Framework + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @ELAReporting_Category + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @ELASchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @ELASchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @ELAGender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @ELAGrade + 
				'","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @ELARace + '","DefaultValue":null},{"DisplayName":"ItemId","ColumnName":"ItemId","AliasName":"Item","SortOrder":0,"FiledId":"' + @ELAItemId + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ELAItemTypeDescription + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @ELAReporting_Category + '","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":[{"Value":' + @ELADistrictStudentId + ',"Text":"DistrictStudentId","Key":0},{"Value":' + @ELAStudentName + ',"Text":"StudentName","Key":0},{"Value":' + @ELAGender + ',"Text":"gender","Key":0},{"Value":' + @ELAGrade + ',"Text":"grade","Key":0},{"Value":' + @ELAItemId + 
				',"Text":"ItemId","Key":0},{"Value":' + @ELAItemtext + ',"Text":"Itemtext","Key":0},{"Value":' + @ELAItemTypeDescription + ',"Text":"ItemTypeDescription","Key":0},{"Value":' + @ELAReporting_Category + ',"Text":"Reporting_Category","Key":0},{"Value":' + @ELAItemMaxScore + ',"Text":"ItemMaxScore","Key":0},{"Value":' + @ELACorrect_Answer + ',"Text":"Correct_Answer","Key":0},{"Value":' + @ELAStudentScore + ',"Text":"StudentScore","Key":0},{"Value":' + @ELASchoolName + ',"Text":"SchoolName","Key":0}]}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,NULL AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6169' AS ReportDetailsCode
				,'MCAS - ELA Item Analysis Students List' AS ChildReportDetailsName
				,'' + @TenantCode + '_MCASItemStudentTeacherResults_ELA_DS' AS LinkedReportDataSourceName
				,NULL AS [Min]
				,NULL AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"ItemId","SortType":"Ascending","SortByFieldId":' + @ELAItemId + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @ELAIsCorrect + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @ELADistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null},{"Filter":"IsCorrect","ComaprisonType":"Equals","ComaprisonValue":"Correct","FilterByField":null,"FilterByFieldId":' + @ELAIsCorrect + 
				',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":false,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - ELA-Avg % Incorrect by Item ' AS ReportDetailsName
				,'What is the Average % Incorrect by Item  in MCAS ELA?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[ItemId] as [ItemId], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[ItemId] = ds1.[ItemId]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ISNULL(ds.[IsCorrect],'' '') = ''Incorrect'') AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[ItemId],ds.[IsCorrect]  ORDER BY ds.[IsCorrect] ASC,ds.[ItemId] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @ELADistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["IsCorrect"],"CategoryColumns":["ItemId"],"AliasNameList":[{"Name":"ItemId","AliasName":"Item"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"DistrictStudentId","AliasName":"Avg % Incorrect"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' 
				+ @ELAELL + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @ELAGender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @ELAGrade + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"HighNeeds","SortOrder":0,"FiledId":"' + @ELAHighNeeds + '","DefaultValue":null},{"DisplayName":"ItemId","ColumnName":"ItemId","AliasName":"Item","SortOrder":0,"FiledId":"' + @ELAItemId + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ELAItemTypeDescription + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @ELARace + 
				'","DefaultValue":null},{"DisplayName":"MA_Curriculum_Framework","ColumnName":"MA_Curriculum_Framework","AliasName":"Curriculum Framework","SortOrder":0,"FiledId":"' + @ELAMA_Curriculum_Framework + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @ELAReporting_Category + '","DefaultValue":null},{"DisplayName":"TeacherName","ColumnName":"TeacherName","AliasName":"Teacher Name","SortOrder":0,"FiledId":"52346","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @ELASchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @ELASchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @ELAGender + 
				'","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @ELAGrade + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @ELARace + '","DefaultValue":null},{"DisplayName":"TeacherName","ColumnName":"TeacherName","AliasName":"Teacher Name","SortOrder":0,"FiledId":"52346","DefaultValue":null},{"DisplayName":"ItemId","ColumnName":"ItemId","AliasName":"Item","SortOrder":0,"FiledId":"' + @ELAItemId + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ELAItemTypeDescription + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Itme Category","SortOrder":0,"FiledId":"' + @ELAReporting_Category + 
				'","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":[{"Value":' + @ELADistrictStudentId + ',"Text":"DistrictStudentId","Key":0},{"Value":' + @ELAStudentName + ',"Text":"StudentName","Key":0},{"Value":' + @ELAGender + ',"Text":"gender","Key":0},{"Value":' + @ELAGrade + ',"Text":"grade","Key":0},{"Value":' + @ELAItemId + ',"Text":"ItemId","Key":0},{"Value":' + @ELAItemtext + ',"Text":"Itemtext","Key":0},{"Value":' + @ELAItemTypeDescription + ',"Text":"ItemTypeDescription","Key":0},{"Value":' + @ELAReporting_Category + ',"Text":"Reporting_Category","Key":0},{"Value":' + @ELAItemMaxScore + ',"Text":"ItemMaxScore","Key":0},{"Value":' + @ELACorrect_Answer + ',"Text":"Correct_Answer","Key":0},{"Value":' + @ELAStudentScore + ',"Text":"StudentScore","Key":0},{"Value":' + @ELASchoolName + ',"Text":"SchoolName","Key":0}]}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,NULL AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6167' AS ReportDetailsCode
				,'MCAS - ELA Item Analysis Students List' AS ChildReportDetailsName
				,'' + @TenantCode + '_MCASItemStudentTeacherResults_ELA_DS' AS LinkedReportDataSourceName
				,NULL AS [Min]
				,NULL AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @ELAIsCorrect + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"ItemId","SortType":"Ascending","SortByFieldId":' + @ELAItemId + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @ELADistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null},{"Filter":"IsCorrect","ComaprisonType":"Equals","ComaprisonValue":"Incorrect","FilterByField":null,"FilterByFieldId":' + @ELAIsCorrect + 
				',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":false,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - ELA-Avg % Incorrect by Item type' AS ReportDetailsName
				,'What is the Average % Incorrect by Item type  in MCAS ELA?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[ItemTypeDescription] as [ItemTypeDescription], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[ItemTypeDescription] = ds1.[ItemTypeDescription]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ISNULL(ds.[IsCorrect],'' '') = ''Incorrect'') AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[ItemTypeDescription],ds.[IsCorrect]  ORDER BY ds.[ItemTypeDescription] ASC,ds.[IsCorrect] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @ELADistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["IsCorrect"],"CategoryColumns":["ItemTypeDescription"],"AliasNameList":[{"Name":"ItemTypeDescription","AliasName":"Item Type"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"DistrictStudentId","AliasName":"Avg % Incorrect"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' 
				+ @ELAELL + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @ELAGender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @ELAGrade + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"HighNeeds","SortOrder":0,"FiledId":"' + @ELAHighNeeds + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @ELARace + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @ELAReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ELAItemTypeDescription + 
				'","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @ELASchoolName + '","DefaultValue":null},{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @ELASchoolYear + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @ELASchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @ELASchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @ELAGender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @ELAGrade + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + 
				@ELARace + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ELAItemTypeDescription + '","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":[{"Value":' + @ELADistrictStudentId + ',"Text":"DistrictStudentId","Key":0},{"Value":' + @ELAStudentName + ',"Text":"StudentName","Key":0},{"Value":' + @ELAGender + ',"Text":"gender","Key":0},{"Value":' + @ELAGrade + ',"Text":"grade","Key":0},{"Value":' + @ELAItemId + ',"Text":"ItemId","Key":0},{"Value":' + @ELAItemtext + ',"Text":"Itemtext","Key":0},{"Value":' + @ELAItemTypeDescription + ',"Text":"ItemTypeDescription","Key":0},{"Value":' + @ELAReporting_Category + ',"Text":"Reporting_Category","Key":0},{"Value":' + @ELAItemMaxScore + ',"Text":"ItemMaxScore","Key":0},{"Value":' + @ELACorrect_Answer + ',"Text":"Correct_Answer","Key":0},{"Value":' + @ELAStudentScore + 
				',"Text":"StudentScore","Key":0},{"Value":' + @ELASchoolName + ',"Text":"SchoolName","Key":0}]}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_17' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6173' AS ReportDetailsCode
				,'MCAS - ELA Item Analysis Students List' AS ChildReportDetailsName
				,'' + @TenantCode + '_MCASItemStudentTeacherResults_ELA_DS' AS LinkedReportDataSourceName
				,'0' AS [Min]
				,'100' AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"ItemTypeDescription","SortType":"Ascending","SortByFieldId":' + @ELAItemTypeDescription + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @ELAIsCorrect + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @ELADistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null},{"Filter":"IsCorrect","ComaprisonType":"Equals","ComaprisonValue":"Incorrect","FilterByField":null,"FilterByFieldId":' + @ELAIsCorrect + 
				',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":false,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS-ELA- Avg % Incorrect by Item Category' AS ReportDetailsName
				,'What is the Average % Incorrect by Item category in MCAS ELA?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[Reporting_Category] as [Reporting_Category], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[Reporting_Category] = ds1.[Reporting_Category]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ISNULL(ds.[IsCorrect],'' '') = ''Incorrect'') AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[Reporting_Category],ds.[IsCorrect]  ORDER BY ds.[Reporting_Category] ASC,ds.[IsCorrect] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsELADS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @ELADistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["IsCorrect"],"CategoryColumns":["Reporting_Category"],"AliasNameList":[{"Name":"Reporting_Category","AliasName":"Item Category"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"DistrictStudentId","AliasName":"Avg % Incorrect"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' 
				+ @ELAELL + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @ELAGender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @ELAGrade + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"High Needs","SortOrder":0,"FiledId":"' + @ELAHighNeeds + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @ELARace + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @ELAReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ELAItemTypeDescription + 
				'","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School","SortOrder":0,"FiledId":"' + @ELASchoolName + '","DefaultValue":null},{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @ELASchoolYear + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @ELASchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @ELASchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @ELAGender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @ELAGrade + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @ELARace + 
				'","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @ELAReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ELAItemTypeDescription + '","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_14' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6127' AS ReportDetailsCode
				,'MCAS - ELA-Avg % Incorrect by Item ' AS ChildReportDetailsName
				,'' + @TenantCode + '_MCASItemStudentTeacherResults_ELA_DS' AS LinkedReportDataSourceName
				,'0' AS [Min]
				,'100' AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"Reporting_Category","SortType":"Ascending","SortByFieldId":' + @ELAReporting_Category + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @ELAIsCorrect + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @ELADistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null},{"Filter":"IsCorrect","ComaprisonType":"Equals","ComaprisonValue":"Incorrect","FilterByField":null,"FilterByFieldId":' + @ELAIsCorrect + 
				',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":false,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			--Math 
			
			UNION ALL
			
			SELECT 'MCAS - Mathematics Avg % by Item Category' AS ReportDetailsName
				,'What is the Average % by Item category in MCAS Mathematics?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[Reporting_Category] as [Reporting_Category], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[Reporting_Category] = ds1.[Reporting_Category]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[Reporting_Category],ds.[IsCorrect]  ORDER BY ds.[Reporting_Category] ASC,ds.[IsCorrect] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @MathDistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["IsCorrect"],"CategoryColumns":["Reporting_Category"],"AliasNameList":[{"Name":"Reporting_Category","AliasName":"Item Category"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"DistrictStudentId","AliasName":"Avg %"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' 
				+ @MathELL + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @MathGender + '","DefaultValue":null},{"DisplayName":"GradeDescription","ColumnName":"GradeDescription","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @MathGradeDescription + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"HighNeeds","SortOrder":0,"FiledId":"' + @MathHighNeeds + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @MathRace + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @MathReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @MathItemTypeDescription + 
				'","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @MathSchoolName + '","DefaultValue":null},{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @MathSchoolYear + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @MathSchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @MathSchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @MathGender + '","DefaultValue":null},{"DisplayName":"GradeDescription","ColumnName":"GradeDescription","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @MathGradeDescription + 
				'","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @MathRace + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @MathReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @MathItemTypeDescription + '","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_1' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6123' AS ReportDetailsCode
				,NULL AS ChildReportDetailsName
				,NULL AS LinkedReportDataSourceName
				,'0' AS [Min]
				,'100' AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"Reporting_Category","SortType":"Ascending","SortByFieldId":' + @MathReporting_Category + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @MathIsCorrect + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @MathDistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - Mathematics Avg % by Item type and Category' AS ReportDetailsName
				,'What is the Average % by Item type and Category in MCAS Mathematics?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[ItemTypeDescription] as [ItemTypeDescription], ds.[Reporting_Category] as [Reporting_Category], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[ItemTypeDescription] = ds1.[ItemTypeDescription]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[ItemTypeDescription],ds.[Reporting_Category],ds.[IsCorrect]  ORDER BY ds.[Reporting_Category] ASC,ds.[IsCorrect] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @MathDistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["Reporting_Category","IsCorrect"],"CategoryColumns":["ItemTypeDescription"],"AliasNameList":[{"Name":"ItemTypeDescription","AliasName":"Item Type"},{"Name":"Reporting_Category","AliasName":"Item Category"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"DistrictStudentId","AliasName":"Avg %"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' 
				+ @MathELL + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @MathGender + '","DefaultValue":null},{"DisplayName":"GradeDescription","ColumnName":"GradeDescription","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @MathGradeDescription + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"HighNeeds","SortOrder":0,"FiledId":"' + @MathHighNeeds + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @MathRace + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @MathReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @MathItemTypeDescription + 
				'","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @MathSchoolName + '","DefaultValue":null},{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @MathSchoolYear + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @MathSchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @MathSchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @MathGender + '","DefaultValue":null},{"DisplayName":"GradeDescription","ColumnName":"GradeDescription","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @MathGradeDescription + 
				'","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @MathRace + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @MathItemTypeDescription + '","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_7' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6133' AS ReportDetailsCode
				,NULL AS ChildReportDetailsName
				,NULL AS LinkedReportDataSourceName
				,'0' AS [Min]
				,'100' AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"Reporting_Category","SortType":"Ascending","SortByFieldId":' + @MathReporting_Category + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @MathIsCorrect + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @MathDistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - Mathematics Avg % by Item type' AS ReportDetailsName
				,'What is the Average % by Item type in MCAS Mathematics?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[ItemTypeDescription] as [ItemTypeDescription], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[ItemTypeDescription] = ds1.[ItemTypeDescription]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[ItemTypeDescription],ds.[IsCorrect]  ORDER BY ds.[IsCorrect] ASC,ds.[ItemTypeDescription] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @MathDistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["IsCorrect"],"CategoryColumns":["ItemTypeDescription"],"AliasNameList":[{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"DistrictStudentId","AliasName":"Avg %"},{"Name":"ItemTypeDescription","AliasName":"Item Type"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' 
				+ @MathELL + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @MathGender + '","DefaultValue":null},{"DisplayName":"GradeDescription","ColumnName":"GradeDescription","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @MathGradeDescription + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @MathRace + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @MathReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @MathItemTypeDescription + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @MathSchoolName + 
				'","DefaultValue":null},{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @MathSchoolYear + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"HighNeeds","SortOrder":0,"FiledId":"' + @MathHighNeeds + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @MathSchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @MathSchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @MathGender + '","DefaultValue":null},{"DisplayName":"GradeDescription","ColumnName":"GradeDescription","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @MathGradeDescription + 
				'","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @MathRace + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @MathReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @MathItemTypeDescription + '","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_4' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6128' AS ReportDetailsCode
				,NULL AS ChildReportDetailsName
				,NULL AS LinkedReportDataSourceName
				,'0' AS [Min]
				,'100' AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @MathIsCorrect + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"ItemTypeDescription","SortType":"Ascending","SortByFieldId":' + @MathItemTypeDescription + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @MathDistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - Mathematics Avg % correct by Item Category' AS ReportDetailsName
				,'What is the Average % Correct by Item category in MCAS Mathematics?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[Reporting_Category] as [Reporting_Category], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[Reporting_Category] = ds1.[Reporting_Category]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ISNULL(ds.[IsCorrect],'' '') = ''Correct'') AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[Reporting_Category],ds.[IsCorrect]  ORDER BY ds.[Reporting_Category] ASC,ds.[IsCorrect] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @MathDistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["IsCorrect"],"CategoryColumns":["Reporting_Category"],"AliasNameList":[{"Name":"Reporting_Category","AliasName":"Item Category"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"DistrictStudentId","AliasName":"Avg % Correct"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' 
				+ @MathELL + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @MathGender + '","DefaultValue":null},{"DisplayName":"GradeDescription","ColumnName":"GradeDescription","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @MathGradeDescription + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"HighNeeds","SortOrder":0,"FiledId":"' + @MathHighNeeds + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @MathRace + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @MathReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @MathItemTypeDescription + 
				'","DefaultValue":null},{"DisplayName":"TeacherName","ColumnName":"TeacherName","AliasName":"Teacher Name","SortOrder":0,"FiledId":"' + @MathTeacherName + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @MathSchoolName + '","DefaultValue":null},{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @MathSchoolYear + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @MathSchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @MathSchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @MathGender + 
				'","DefaultValue":null},{"DisplayName":"GradeDescription","ColumnName":"GradeDescription","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @MathGradeDescription + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @MathRace + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @MathReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @MathItemTypeDescription + '","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_2' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6124' AS ReportDetailsCode
				,'MCAS - Mathematics Avg % correct by Item' AS ChildReportDetailsName
				,'' + @TenantCode + '_MCASItemStudentTeacherResults_Maths_DS' AS LinkedReportDataSourceName
				,'0' AS [Min]
				,'100' AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"Reporting_Category","SortType":"Ascending","SortByFieldId":' + @MathReporting_Category + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @MathIsCorrect + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @MathDistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null},{"Filter":"IsCorrect","ComaprisonType":"Equals","ComaprisonValue":"Correct","FilterByField":null,"FilterByFieldId":' + @MathIsCorrect + 
				',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":false,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - Mathematics Avg % correct by Item type and Category' AS ReportDetailsName
				,'What is the Average % correct by Item type and Category in MCAS Mathematics?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[ItemTypeDescription] as [ItemTypeDescription], ds.[Reporting_Category] as [Reporting_Category], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[ItemTypeDescription] = ds1.[ItemTypeDescription]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ISNULL(ds.[IsCorrect],'' '') = ''Correct'') AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[ItemTypeDescription],ds.[Reporting_Category],ds.[IsCorrect]  ORDER BY ds.[Reporting_Category] ASC,ds.[IsCorrect] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @MathDistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["Reporting_Category","IsCorrect"],"CategoryColumns":["ItemTypeDescription"],"AliasNameList":[{"Name":"ItemTypeDescription","AliasName":"Item Type"},{"Name":"Reporting_Category","AliasName":"Item Category"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"DistrictStudentId","AliasName":"Avg % Correct"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' 
				+ @MathELL + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @MathGender + '","DefaultValue":null},{"DisplayName":"GradeDescription","ColumnName":"GradeDescription","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @MathGradeDescription + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"HighNeeds","SortOrder":0,"FiledId":"' + @MathHighNeeds + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @MathRace + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @MathReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @MathItemTypeDescription + 
				'","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @MathSchoolName + '","DefaultValue":null},{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @MathSchoolYear + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @MathSchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @MathSchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @MathGender + '","DefaultValue":null},{"DisplayName":"GradeDescription","ColumnName":"GradeDescription","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @MathGradeDescription + 
				'","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @MathRace + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @MathItemTypeDescription + '","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_8' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6135' AS ReportDetailsCode
				,'MCAS - Mathematics Avg % correct by Item' AS ChildReportDetailsName
				,'' + @TenantCode + '_MCASItemStudentTeacherResults_Maths_DS' AS LinkedReportDataSourceName
				,'0' AS [Min]
				,'100' AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"Reporting_Category","SortType":"Ascending","SortByFieldId":' + @MathReporting_Category + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @MathIsCorrect + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @MathDistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null},{"Filter":"IsCorrect","ComaprisonType":"Equals","ComaprisonValue":"Correct","FilterByField":null,"FilterByFieldId":' + @MathIsCorrect + 
				',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":false,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - Mathematics Avg % correct by Item type' AS ReportDetailsName
				,'What is the Average % correct by Item type in MCAS Mathematics?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[ItemTypeDescription] as [ItemTypeDescription], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[ItemTypeDescription] = ds1.[ItemTypeDescription]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ISNULL(ds.[IsCorrect],'' '') = ''Correct'') AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[ItemTypeDescription],ds.[IsCorrect]  ORDER BY ds.[IsCorrect] ASC,ds.[ItemTypeDescription] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @MathDistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["IsCorrect"],"CategoryColumns":["ItemTypeDescription"],"AliasNameList":[{"Name":"ItemTypeDescription","AliasName":"Item Type"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"DistrictStudentId","AliasName":"Avg % Correct"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' 
				+ @MathELL + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @MathGender + '","DefaultValue":null},{"DisplayName":"GradeDescription","ColumnName":"GradeDescription","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @MathGradeDescription + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"HighNeeds","SortOrder":0,"FiledId":"' + @MathHighNeeds + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @MathRace + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @MathReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @MathItemTypeDescription + 
				'","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @MathSchoolName + '","DefaultValue":null},{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @MathSchoolYear + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @MathSchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @MathSchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @MathGender + '","DefaultValue":null},{"DisplayName":"GradeDescription","ColumnName":"GradeDescription","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @MathGradeDescription + 
				'","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @MathRace + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @MathReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @MathItemTypeDescription + '","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_5' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6129' AS ReportDetailsCode
				,'MCAS - Mathematics Avg % correct by Item' AS ChildReportDetailsName
				,'' + @TenantCode + '_MCASItemStudentTeacherResults_Maths_DS' AS LinkedReportDataSourceName
				,'0' AS [Min]
				,'100' AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @MathIsCorrect + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"ItemTypeDescription","SortType":"Ascending","SortByFieldId":' + @MathItemTypeDescription + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @MathDistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null},{"Filter":"IsCorrect","ComaprisonType":"Equals","ComaprisonValue":"Correct","FilterByField":null,"FilterByFieldId":' + @MathIsCorrect + 
				',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":false,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - Mathematics Avg % correct by Item' AS ReportDetailsName
				,'What is the Average % correct by Item in MCAS Mathematics?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[ItemId] as [ItemId], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[ItemId] = ds1.[ItemId]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ISNULL(ds.[IsCorrect],'' '') = ''Correct'') AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[ItemId],ds.[IsCorrect]  ORDER BY ds.[ItemId] ASC,ds.[IsCorrect] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @MathDistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["IsCorrect"],"CategoryColumns":["ItemId"],"AliasNameList":[{"Name":"ItemId","AliasName":"Item"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"DistrictStudentId","AliasName":"Avg % Correct"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' 
				+ @MathELL + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @MathGender + '","DefaultValue":null},{"DisplayName":"GradeDescription","ColumnName":"GradeDescription","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @MathGradeDescription + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"HighNeeds","SortOrder":0,"FiledId":"' + @MathHighNeeds + '","DefaultValue":null},{"DisplayName":"ItemId","ColumnName":"ItemId","AliasName":"Item","SortOrder":0,"FiledId":"' + @MathItemId + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @MathRace + '","DefaultValue":null},{"DisplayName":"MA_Curriculum_Framework","ColumnName":"MA_Curriculum_Framework","AliasName":"Curriculum Framework","SortOrder":0,"FiledId":"' + @MathMA_Curriculum_Framework + 
				'","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @MathReporting_Category + '","DefaultValue":null},{"DisplayName":"TeacherName","ColumnName":"TeacherName","AliasName":"Teacher Name","SortOrder":0,"FiledId":"' + @MathTeacherName + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @MathItemTypeDescription + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @MathSchoolName + '","DefaultValue":null},{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @MathSchoolYear + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @MathGender + 
				'","DefaultValue":null},{"DisplayName":"GradeDescription","ColumnName":"GradeDescription","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @MathGradeDescription + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @MathRace + '","DefaultValue":null},{"DisplayName":"ItemId","ColumnName":"ItemId","AliasName":"Item","SortOrder":0,"FiledId":"' + @MathItemId + '","DefaultValue":null},{"DisplayName":"TeacherName","ColumnName":"TeacherName","AliasName":"Teacher Name","SortOrder":0,"FiledId":"' + @MathTeacherName + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @MathItemTypeDescription + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @MathReporting_Category + 
				'","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":[{"Value":' + @MathDistrictStudentId + ',"Text":"DistrictStudentId","Key":0},{"Value":' + @MathStudentName + ',"Text":"StudentName","Key":0},{"Value":' + @MathGender + ',"Text":"gender","Key":0},{"Value":' + @MathGradeDescription + ',"Text":"GradeDescription","Key":0},{"Value":' + @MathItemId + ',"Text":"ItemId","Key":0},{"Value":' + @MathItemtext + ',"Text":"Itemtext","Key":0},{"Value":' + @MathItemTypeCode + ',"Text":"ItemTypeCode","Key":0},{"Value":' + @MathReporting_Category + ',"Text":"Reporting_Category","Key":0},{"Value":' + @MathItemTypeDescription + ',"Text":"ItemTypeDescription","Key":0},{"Value":' + @MathItemMaxScore + ',"Text":"ItemMaxScore","Key":0},{"Value":' + @MathCorrect_Answer + ',"Text":"Correct_Answer","Key":0},{"Value":' + @MathStudentScore + ',"Text":"StudentScore","Key":0},{"Value":' + @MathSchoolName + ',"Text":"SchoolName","Key":0}]}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,NULL AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6161' AS ReportDetailsCode
				,'MCAS - Mathematics Item Analysis Students List' AS ChildReportDetailsName
				,'' + @TenantCode + '_MCASItemStudentTeacherResults_Maths_DS' AS LinkedReportDataSourceName
				,'0' AS [Min]
				,'100' AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"ItemId","SortType":"Ascending","SortByFieldId":' + @MathItemId + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @MathIsCorrect + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @MathDistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null},{"Filter":"IsCorrect","ComaprisonType":"Equals","ComaprisonValue":"Correct","FilterByField":null,"FilterByFieldId":' + @MathIsCorrect + 
				',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":false,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - Mathematics Avg % Incorrect by Item Category' AS ReportDetailsName
				,'What is the Average % Incorrect by Item category in MCAS Mathematics?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[Reporting_Category] as [Reporting_Category], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[Reporting_Category] = ds1.[Reporting_Category]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ISNULL(ds.[IsCorrect],'' '') = ''Incorrect'') AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[Reporting_Category],ds.[IsCorrect]  ORDER BY ds.[Reporting_Category] ASC,ds.[IsCorrect] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @MathDistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["IsCorrect"],"CategoryColumns":["Reporting_Category"],"AliasNameList":[{"Name":"Reporting_Category","AliasName":"Item Category"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"DistrictStudentId","AliasName":"Avg % Incorrect"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' 
				+ @MathELL + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @MathGender + '","DefaultValue":null},{"DisplayName":"GradeDescription","ColumnName":"GradeDescription","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @MathGradeDescription + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"HighNeeds","SortOrder":0,"FiledId":"' + @MathHighNeeds + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"race","SortOrder":0,"FiledId":"' + @MathRace + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @MathReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @MathItemTypeDescription + 
				'","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @MathSchoolName + '","DefaultValue":null},{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @MathSchoolYear + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @MathSchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @MathSchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @MathGender + '","DefaultValue":null},{"DisplayName":"GradeDescription","ColumnName":"GradeDescription","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @MathGradeDescription + 
				'","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @MathRace + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @MathReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @MathItemTypeDescription + '","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_3' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6121' AS ReportDetailsCode
				,'MCAS - Mathematics Avg % Incorrect by Item' AS ChildReportDetailsName
				,'' + @TenantCode + '_MCASItemStudentTeacherResults_Maths_DS' AS LinkedReportDataSourceName
				,'0' AS [Min]
				,'100' AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"Reporting_Category","SortType":"Ascending","SortByFieldId":' + @MathReporting_Category + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @MathIsCorrect + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @MathDistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null},{"Filter":"IsCorrect","ComaprisonType":"Equals","ComaprisonValue":"Incorrect","FilterByField":null,"FilterByFieldId":' + @MathIsCorrect + 
				',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":false,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - Mathematics Avg % Incorrect by Item type and Category' AS ReportDetailsName
				,'What is the Average % Incorrect by Item type and Category in MCAS Mathematics?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[ItemTypeDescription] as [ItemTypeDescription], ds.[Reporting_Category] as [Reporting_Category], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[ItemTypeDescription] = ds1.[ItemTypeDescription]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ISNULL(ds.[IsCorrect],'' '') = ''Incorrect'') AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[ItemTypeDescription],ds.[Reporting_Category],ds.[IsCorrect]  ORDER BY ds.[Reporting_Category] ASC,ds.[IsCorrect] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @MathDistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["Reporting_Category","IsCorrect"],"CategoryColumns":["ItemTypeDescription"],"AliasNameList":[{"Name":"ItemTypeDescription","AliasName":"Item Type"},{"Name":"Reporting_Category","AliasName":"Item Category"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"DistrictStudentId","AliasName":"Avg % Incorrect"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' 
				+ @MathELL + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @MathGender + '","DefaultValue":null},{"DisplayName":"GradeDescription","ColumnName":"GradeDescription","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @MathGradeDescription + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"HighNeeds","SortOrder":0,"FiledId":"' + @MathHighNeeds + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @MathRace + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @MathReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @MathItemTypeDescription + 
				'","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @MathSchoolName + '","DefaultValue":null},{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @MathSchoolYear + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @MathSchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @MathSchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @MathGender + '","DefaultValue":null},{"DisplayName":"GradeDescription","ColumnName":"GradeDescription","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @MathGradeDescription + 
				'","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @MathRace + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @MathItemTypeDescription + '","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_9' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6131' AS ReportDetailsCode
				,'MCAS - Mathematics Avg % Incorrect by Item' AS ChildReportDetailsName
				,'' + @TenantCode + '_MCASItemStudentTeacherResults_Maths_DS' AS LinkedReportDataSourceName
				,'0' AS [Min]
				,'100' AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"Reporting_Category","SortType":"Ascending","SortByFieldId":' + @MathReporting_Category + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @MathIsCorrect + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @MathDistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null},{"Filter":"IsCorrect","ComaprisonType":"Equals","ComaprisonValue":"Incorrect","FilterByField":null,"FilterByFieldId":' + @MathIsCorrect + 
				',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":false,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - Mathematics Avg % Incorrect by Item type' AS ReportDetailsName
				,'What is the Average % Incorrect by Item type in MCAS Mathematics?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[ItemTypeDescription] as [ItemTypeDescription], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[ItemTypeDescription] = ds1.[ItemTypeDescription]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ISNULL(ds.[IsCorrect],'' '') = ''Incorrect'') AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[ItemTypeDescription],ds.[IsCorrect]  ORDER BY ds.[IsCorrect] ASC,ds.[ItemTypeDescription] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @MathDistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["IsCorrect"],"CategoryColumns":["ItemTypeDescription"],"AliasNameList":[{"Name":"ItemTypeDescription","AliasName":"Item Type"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"DistrictStudentId","AliasName":"Avg % Incorrect"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' 
				+ @MathELL + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @MathGender + '","DefaultValue":null},{"DisplayName":"GradeDescription","ColumnName":"GradeDescription","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @MathGradeDescription + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"HighNeeds","SortOrder":0,"FiledId":"' + @MathHighNeeds + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @MathRace + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @MathReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @MathItemTypeDescription + 
				'","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @MathSchoolName + '","DefaultValue":null},{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @MathSchoolYear + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @MathSchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @MathSchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @MathGender + '","DefaultValue":null},{"DisplayName":"GradeDescription","ColumnName":"GradeDescription","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @MathGradeDescription + 
				'","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @MathRace + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @MathReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @MathItemTypeDescription + '","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_6' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6126' AS ReportDetailsCode
				,'MCAS - Mathematics Avg % Incorrect by Item' AS ChildReportDetailsName
				,'' + @TenantCode + '_MCASItemStudentTeacherResults_Maths_DS' AS LinkedReportDataSourceName
				,'0' AS [Min]
				,'100' AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @MathIsCorrect + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"ItemTypeDescription","SortType":"Ascending","SortByFieldId":' + @MathItemTypeDescription + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @MathDistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null},{"Filter":"IsCorrect","ComaprisonType":"Equals","ComaprisonValue":"Incorrect","FilterByField":null,"FilterByFieldId":' + @MathIsCorrect + 
				',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":false,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - Mathematics Avg % Incorrect by Item' AS ReportDetailsName
				,'What is the Average % Incorrect by Item in MCAS Mathematics?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[ItemId] as [ItemId], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[ItemId] = ds1.[ItemId]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ISNULL(ds.[IsCorrect],'' '') = ''Incorrect'') AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[ItemId],ds.[IsCorrect]  ORDER BY ds.[ItemId] ASC,ds.[IsCorrect] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @MathDistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["IsCorrect"],"CategoryColumns":["ItemId"],"AliasNameList":[{"Name":"ItemId","AliasName":"Item"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"DistrictStudentId","AliasName":"Avg % Incorrect"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' 
				+ @MathELL + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @MathGender + '","DefaultValue":null},{"DisplayName":"GradeDescription","ColumnName":"GradeDescription","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @MathGradeDescription + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"HighNeeds","SortOrder":0,"FiledId":"' + @MathHighNeeds + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @MathRace + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @MathReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @MathItemTypeDescription + 
				'","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @MathSchoolName + '","DefaultValue":null},{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @MathSchoolYear + '","DefaultValue":null}],"SubGroupColumns":null,"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":[{"Value":' + @MathDistrictStudentId + ',"Text":"DistrictStudentId","Key":0},{"Value":' + @MathStudentName + ',"Text":"StudentName","Key":0},{"Value":' + @MathGender + ',"Text":"gender","Key":0},{"Value":' + @MathGradeDescription + ',"Text":"GradeDescription","Key":0},{"Value":' + @MathItemId + ',"Text":"ItemId","Key":0},{"Value":' + @MathItemtext + ',"Text":"Itemtext","Key":0},{"Value":' + @MathItemTypeCode + ',"Text":"ItemTypeCode","Key":0},{"Value":' + @MathReporting_Category + ',"Text":"Reporting_Category","Key":0},{"Value":' + @MathItemTypeDescription + 
				',"Text":"ItemTypeDescription","Key":0},{"Value":' + @MathItemMaxScore + ',"Text":"ItemMaxScore","Key":0},{"Value":' + @MathCorrect_Answer + ',"Text":"Correct_Answer","Key":0},{"Value":' + @MathStudentScore + ',"Text":"StudentScore","Key":0},{"Value":' + @MathSchoolName + ',"Text":"SchoolName","Key":0}]}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,NULL AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6163' AS ReportDetailsCode
				,'MCAS - Mathematics Item Analysis Students List' AS ChildReportDetailsName
				,'' + @TenantCode + '_MCASItemStudentTeacherResults_Maths_DS' AS LinkedReportDataSourceName
				,'0' AS [Min]
				,'100' AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"ItemId","SortType":"Ascending","SortByFieldId":' + @MathItemId + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @MathIsCorrect + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @MathDistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null},{"Filter":"IsCorrect","ComaprisonType":"Equals","ComaprisonValue":"Incorrect","FilterByField":null,"FilterByFieldId":' + @MathIsCorrect + 
				',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":false,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - Mathematics Item Analysis School Avg % correct VS State Avg % correct' AS ReportDetailsName
				,'What is  School Avg % correct VS State Avg % correct  by Item in MCAS Mathematics?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[SchoolName] as [SchoolName], ds.[ItemId] as [ItemId],cast(Avg(cast(ISNULL(ds.[Avg_School_Correct], 0) as decimal(15,1)))  as decimal(15,1)) as [Avg_School_Correct],cast(Avg(cast(ISNULL(ds.[State_Percent_Possible], 0) as decimal(15,1)))  as decimal(15,1)) as [State_Percent_Possible]  FROM dbo.' + @TenantCode + 'AggrptMCASItemAnalysisDS as ds with (nolock)  LEFT JOIN dbo.' + @TenantCode + '_MCAS_Item_SortOrder_Vw ON ds.[ItemId] = dbo.' + @TenantCode + '_MCAS_Item_SortOrder_Vw.itemid AND  ds.tenantid =dbo.' + @TenantCode + '_MCAS_Item_SortOrder_Vw.tenantid    WHERE  ((ISNUMERIC(ISNULL(ds.[Avg_School_Correct], 0)) = 1) AND (ISNUMERIC(ISNULL(ds.[State_Percent_Possible], 0)) = 1) AND (ISNULL(ds.[SubjectAreaCode],'' '') = ''MATH'') AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[SchoolName],ds.[ItemId],dbo.' + @TenantCode + '_MCAS_Item_SortOrder_Vw.SortOrder  ORDER BY ds.[SchoolName] ASC,dbo.' + @TenantCode + '_MCAS_Item_SortOrder_Vw.SortOrder ASC,ds.[ItemId] ASC ' AS 
				ReportQuery
				,'dbo.' + @TenantCode + 'AggrptMCASItemAnalysisDS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @MathAvg_School_Correct + 
				'","Value":"Avg_School_Correct","Code":"Avg","ChartType":"Line","IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false},{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @AggState_Percent_Possible + 
				'","Value":"State_Percent_Possible","Code":"Avg","ChartType":"Line","IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":null,"CategoryColumns":["SchoolName","ItemId"],"AliasNameList":[{"Name":"SchoolName","AliasName":"SchoolName"},{"Name":"ItemId","AliasName":"ItemId"},{"Name":"State_Percent_Possible","AliasName":"State Avg % correct"},{"Name":"Avg_School_Correct","AliasName":"School Avg % correct"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' 
				+ @AggSchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @AggSchoolName + '","DefaultValue":null},{"DisplayName":"Grade","ColumnName":"Grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @AggGrade + '","DefaultValue":null},{"DisplayName":"ItemId","ColumnName":"ItemId","AliasName":"Item","SortOrder":0,"FiledId":"' + @AggItemId + '","DefaultValue":null},{"DisplayName":"MA_Curriculum_Framework","ColumnName":"MA_Curriculum_Framework","AliasName":"Curriculum Framework","SortOrder":0,"FiledId":"' + @AggMA_Curriculum_Framework + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @AggItemTypeDescription + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @AggReporting_Category + 
				'","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @AggSchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @AggSchoolName + '","DefaultValue":null},{"DisplayName":"Grade","ColumnName":"Grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @AggGrade + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @AggReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemId","ColumnName":"ItemId","AliasName":"Item","SortOrder":0,"FiledId":"' + @AggItemId + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @AggItemTypeDescription + 
				'","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_11' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6157' AS ReportDetailsCode
				,NULL AS ChildReportDetailsName
				,NULL AS LinkedReportDataSourceName
				,NULL AS [Min]
				,NULL AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"SchoolName","SortType":"Ascending","SortByFieldId":' + @AggSchoolName + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"ItemId","SortType":"Ascending","SortByFieldId":' + @AggItemId + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"SubjectAreaCode","ComaprisonType":"Equals","ComaprisonValue":"MATH","FilterByField":null,"FilterByFieldId":' + @AggSubjectAreaCode + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - Mathematics Item Analysis Students List' AS ReportDetailsName
				,' MCAS - Mathematics Item Analysis Students list' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[DistrictStudentId] as [DistrictStudentId], ds.[StudentName] as [StudentName], ds.[gender] as [gender], ds.[GradeDescription] as [GradeDescription], ds.[ItemId] as [ItemId], ds.[Itemtext] as [Itemtext], ds.[ItemTypeCode] as [ItemTypeCode], ds.[Reporting_Category] as [Reporting_Category], ds.[ItemTypeDescription] as [ItemTypeDescription], ds.[ItemMaxScore] as [ItemMaxScore], ds.[Correct_Answer] as [Correct_Answer], ds.[StudentScore] as [StudentScore], ds.[SchoolName] as [SchoolName]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS as ds with (nolock)   WHERE  (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + ')   ORDER BY ds.[DistrictStudentId] ASC,ds.[ItemId] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsMathsDS' AS ViewName
				,'Table' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,
				'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":null,"SeriesColumn":null,"CategoryColumns":["DistrictStudentId","StudentName","gender","GradeDescription","ItemId","Itemtext","ItemTypeCode","Reporting_Category","ItemTypeDescription","ItemMaxScore","Correct_Answer","StudentScore","SchoolName"],"AliasNameList":[{"Name":"DistrictStudentId","AliasName":"DistrictStudentId"},{"Name":"StudentName","AliasName":"Student Name"},{"Name":"gender","AliasName":"Gender"},{"Name":"GradeDescription","AliasName":"Tested Grade"},{"Name":"ItemId","AliasName":"Item"},{"Name":"ItemTypeDescription","AliasName":"Item Type"},{"Name":"ItemTypeCode","AliasName":"Type Code"},{"Name":"Itemtext","AliasName":"Item Description"},{"Name":"Reporting_Category","AliasName":"Item Category"},{"Name":"ItemMaxScore","AliasName":"Max Score"},{"Name":"Correct_Answer","AliasName":"Correct Answer"},{"Name":"StudentScore","AliasName":"Student Score"},{"Name":"SchoolName","AliasName":"School Name"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' 
				+ @MathELL + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @MathGender + '","DefaultValue":null},{"DisplayName":"GradeDescription","ColumnName":"GradeDescription","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @MathGradeDescription + '","DefaultValue":null},{"DisplayName":"ItemId","ColumnName":"ItemId","AliasName":"Item","SortOrder":0,"FiledId":"' + @MathItemId + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"HighNeeds","SortOrder":0,"FiledId":"' + @MathHighNeeds + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @MathRace + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @MathReporting_Category + 
				'","DefaultValue":null},{"DisplayName":"MA_Curriculum_Framework","ColumnName":"MA_Curriculum_Framework","AliasName":"Curriculum Framework","SortOrder":0,"FiledId":"' + @MathMA_Curriculum_Framework + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @MathItemTypeDescription + '","DefaultValue":null},{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @MathSchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @MathSchoolName + '","DefaultValue":null}],"SubGroupColumns":null,"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,NULL AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6162' AS ReportDetailsCode
				,NULL AS ChildReportDetailsName
				,NULL AS LinkedReportDataSourceName
				,NULL AS [Min]
				,NULL AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"DistrictStudentId","SortType":"Ascending","SortByFieldId":' + @MathDistrictStudentId + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"ItemId","SortType":"Ascending","SortByFieldId":' + @MathItemId + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - Mathematics Item Analysis' AS ReportDetailsName
				,'MCAS - Mathematics Item Analysis' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[LeaName] as [LeaName], ds.[SchoolName] as [SchoolName], ds.[Grade] as [Grade], ds.[Reporting_Category] as [Reporting_Category], ds.[ItemTypeDescription] as [ItemTypeDescription], ds.[ItemId] as [ItemId], ds.[Itemtext] as [Itemtext], ds.[Avg_School_Correct] as [Avg_School_Correct], ds.[Avg_Correct] as [Avg_Correct], ds.[State_Percent_Possible] as [State_Percent_Possible], ds.[Diff_From_School_State] as [Diff_From_School_State], ds.[Diff_From_State] as [Diff_From_State]  FROM dbo.' + @TenantCode + 'AggrptMCASItemAnalysisDS as ds with (nolock)  LEFT JOIN dbo.' + @TenantCode + '_MCAS_Item_SortOrder_Vw ON ds.[ItemId] = dbo.' + @TenantCode + '_MCAS_Item_SortOrder_Vw.itemid AND  ds.tenantid =dbo.' + @TenantCode + '_MCAS_Item_SortOrder_Vw.tenantid    WHERE  ((ISNULL(ds.[SubjectAreaCode],'' '') = ''MATH'') AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   ORDER BY ds.[LeaName] ASC,ds.[SchoolName] ASC,ds.[Grade] ASC,dbo.' + @TenantCode + 
				'_MCAS_Item_SortOrder_Vw.SortOrder ASC,ds.[ItemId] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'AggrptMCASItemAnalysisDS' AS ViewName
				,'Table' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,
				'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":null,"SeriesColumn":null,"CategoryColumns":["LeaName","SchoolName","Grade","Reporting_Category","ItemTypeDescription","ItemId","Itemtext","Avg_School_Correct","Avg_Correct","State_Percent_Possible","Diff_From_School_State","Diff_From_State"],"AliasNameList":[{"Name":"LeaName","AliasName":"District"},{"Name":"SchoolName","AliasName":"School"},{"Name":"Grade","AliasName":"Tested Grade"},{"Name":"Reporting_Category","AliasName":"Item Category"},{"Name":"ItemTypeDescription","AliasName":"Item Type"},{"Name":"ItemId","AliasName":"Item"},{"Name":"Itemtext","AliasName":"Item Description"},{"Name":"Avg_School_Correct","AliasName":"Avg School % Correct"},{"Name":"Avg_Correct","AliasName":"Avg District % Correct"},{"Name":"State_Percent_Possible","AliasName":"Avg State % Correct"},{"Name":"Diff_From_School_State","AliasName":"Diff From District to State"},{"Name":"Diff_From_State","AliasName":"Diff From School to State"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"LeaName","ColumnName":"LeaName","AliasName":"District","SortOrder":0,"FiledId":"' 
				+ @AggLeaName + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School","SortOrder":0,"FiledId":"' + @AggSchoolName + '","DefaultValue":null},{"DisplayName":"Grade","ColumnName":"Grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @AggGrade + '","DefaultValue":null},{"DisplayName":"ItemId","ColumnName":"ItemId","AliasName":"Item #","SortOrder":0,"FiledId":"' + @AggItemId + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @AggReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @AggItemTypeDescription + '","DefaultValue":null},{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @AggSchoolYear + 
				'","DefaultValue":null}],"SubGroupColumns":null,"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_10' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6154' AS ReportDetailsCode
				,NULL AS ChildReportDetailsName
				,NULL AS LinkedReportDataSourceName
				,NULL AS [Min]
				,NULL AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"LeaName","SortType":"Ascending","SortByFieldId":' + @AggLeaName + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"SchoolName","SortType":"Ascending","SortByFieldId":' + @AggSchoolName + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"Grade","SortType":"Ascending","SortByFieldId":' + @AggGrade + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"ItemId","SortType":"Ascending","SortByFieldId":' + @AggItemId + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"SubjectAreaCode","ComaprisonType":"Equals","ComaprisonValue":"MATH","FilterByField":null,"FilterByFieldId":' + @AggSubjectAreaCode + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			--Science
			
			UNION ALL
			
			SELECT 'MCAS - Science Avg % by Item type and Category' AS ReportDetailsName
				,'What is the Average % by Item type and Category in MCAS Science?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[ItemTypeDescription] as [ItemTypeDescription], ds.[Reporting_Category] as [Reporting_Category], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[ItemTypeDescription] = ds1.[ItemTypeDescription]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[ItemTypeDescription],ds.[Reporting_Category],ds.[IsCorrect]  ORDER BY ds.[Reporting_Category] ASC,ds.[IsCorrect] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @DistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["Reporting_Category","IsCorrect"],"CategoryColumns":["ItemTypeDescription"],"AliasNameList":[{"Name":"ItemTypeDescription","AliasName":"Item type"},{"Name":"Reporting_Category","AliasName":"Item Category"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"DistrictStudentId","AliasName":"AVG % Correct"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' 
				+ @SchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @SchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @Gender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @Grade + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @Race + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ItemTypeDescription + '","DefaultValue":null},{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' + @ELL + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"HighNeeds","SortOrder":0,"FiledId":"' + @HighNeeds + 
				'","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @Reporting_Category + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @SchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @SchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @Gender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @Grade + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @Race + 
				'","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ItemTypeDescription + '","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_29' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6149' AS ReportDetailsCode
				,NULL AS ChildReportDetailsName
				,NULL AS LinkedReportDataSourceName
				,'0' AS [Min]
				,'100' AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"Reporting_Category","SortType":"Ascending","SortByFieldId":' + @Reporting_Category + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @IsCorrect + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @DistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - Science Avg % by Item type' AS ReportDetailsName
				,'What is the Average % by Item type in MCAS Science?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[ItemTypeDescription] as [ItemTypeDescription], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[ItemTypeDescription] = ds1.[ItemTypeDescription]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[ItemTypeDescription],ds.[IsCorrect]  ORDER BY ds.[ItemTypeDescription] ASC,ds.[IsCorrect] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @DistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["IsCorrect"],"CategoryColumns":["ItemTypeDescription"],"AliasNameList":[{"Name":"ItemTypeDescription","AliasName":"Item Type"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"DistrictStudentId","AliasName":"AVG %"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' 
				+ @ELL + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @Gender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @Grade + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"High Needs","SortOrder":0,"FiledId":"' + @HighNeeds + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @Race + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @Reporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ItemTypeDescription + 
				'","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @SchoolName + '","DefaultValue":null},{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @SchoolYear + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @SchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @SchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @Gender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @Grade + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @Race + 
				'","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ItemTypeDescription + '","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_26' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6143' AS ReportDetailsCode
				,NULL AS ChildReportDetailsName
				,NULL AS LinkedReportDataSourceName
				,'0' AS [Min]
				,'100' AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"ItemTypeDescription","SortType":"Ascending","SortByFieldId":' + @ItemTypeDescription + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @IsCorrect + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @DistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - Science Avg % correct by Item type' AS ReportDetailsName
				,'What is the Average % correct by Item type in MCAS Science?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[ItemTypeDescription] as [ItemTypeDescription], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[ItemTypeDescription] = ds1.[ItemTypeDescription]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ISNULL(ds.[IsCorrect],'' '') = ''Correct'') AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[ItemTypeDescription],ds.[IsCorrect]  ORDER BY ds.[ItemTypeDescription] ASC,ds.[IsCorrect] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @DistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["IsCorrect"],"CategoryColumns":["ItemTypeDescription"],"AliasNameList":[{"Name":"ItemTypeDescription","AliasName":"Item Type"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"DistrictStudentId","AliasName":"AVG % Correct"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' 
				+ @ELL + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @Gender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @Grade + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"High Needs","SortOrder":0,"FiledId":"' + @HighNeeds + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @Race + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @Reporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ItemTypeDescription + 
				'","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @SchoolName + '","DefaultValue":null},{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @SchoolYear + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @SchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @SchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @Gender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @Grade + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @Race + 
				'","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ItemTypeDescription + '","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_27' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6145' AS ReportDetailsCode
				,'MCAS - Science Avg % correct by Item' AS ChildReportDetailsName
				,'' + @TenantCode + '_MCASItemStudentTeacherResults_Science_DS' AS LinkedReportDataSourceName
				,NULL AS [Min]
				,NULL AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"ItemTypeDescription","SortType":"Ascending","SortByFieldId":' + @ItemTypeDescription + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @IsCorrect + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @DistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null},{"Filter":"IsCorrect","ComaprisonType":"Equals","ComaprisonValue":"Correct","FilterByField":null,"FilterByFieldId":' + @IsCorrect + 
				',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":false,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - Science Avg % correct by Item' AS ReportDetailsName
				,'What is the Average % correct by Item in MCAS Science?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[ItemId] as [ItemId], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS as ds1 with (nolock)   WHERE  ((ds1.[ItemId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[ItemId] = ds1.[ItemId]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS as ds with (nolock)   WHERE  ((ds.[ItemId] IS NOT NULL ) AND (ISNULL(ds.[IsCorrect],'' '') = ''Correct'') AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[ItemId],ds.[IsCorrect]  ORDER BY ds.[IsCorrect] ASC,ds.[ItemId] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @DistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["IsCorrect"],"CategoryColumns":["ItemId"],"AliasNameList":[{"Name":"ItemId","AliasName":"ItemId"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"DistrictStudentId","AliasName":"AVG %  Correct"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' 
				+ @ELL + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @Gender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @Grade + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"HighNeeds","SortOrder":0,"FiledId":"' + @HighNeeds + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @Race + '","DefaultValue":null},{"DisplayName":"ItemId","ColumnName":"ItemId","AliasName":"Item","SortOrder":0,"FiledId":"' + @ItemId + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ItemTypeDescription + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @Reporting_Category + 
				'","DefaultValue":null},{"DisplayName":"MA_Curriculum_Framework","ColumnName":"MA_Curriculum_Framework","AliasName":"Curriculum Framework","SortOrder":0,"FiledId":"' + @MA_Curriculum_Framework + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @SchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @SchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @Gender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @Grade + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @Race + 
				'","DefaultValue":null},{"DisplayName":"ItemId","ColumnName":"ItemId","AliasName":"Item","SortOrder":0,"FiledId":"' + @ItemId + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ItemTypeDescription + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @Reporting_Category + '","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":[{"Value":' + @DistrictStudentId + ',"Text":"DistrictStudentId","Key":0},{"Value":52462,"Text":"StudentName","Key":0},{"Value":' + @Gender + ',"Text":"gender","Key":0},{"Value":' + @Grade + ',"Text":"grade","Key":0},{"Value":' + @ItemId + ',"Text":"ItemId","Key":0},{"Value":52443,"Text":"Itemtext","Key":0},{"Value":' + @ItemTypeDescription + ',"Text":"ItemTypeDescription","Key":0},{"Value":' + 
				@Reporting_Category + ',"Text":"Reporting_Category","Key":0},{"Value":' + @ItemMaxScore + ',"Text":"ItemMaxScore","Key":0},{"Value":' + @Correct_Answer + ',"Text":"Correct_Answer","Key":0},{"Value":' + @StudentScore + ',"Text":"StudentScore","Key":0},{"Value":' + @SchoolName + ',"Text":"SchoolName","Key":0}]}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,NULL AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6171' AS ReportDetailsCode
				,'MCAS - Science Item Analysis Students List' AS ChildReportDetailsName
				,'' + @TenantCode + '_MCASItemStudentTeacherResults_Science_DS' AS LinkedReportDataSourceName
				,'0' AS [Min]
				,'100' AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @IsCorrect + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"ItemId","SortType":"Ascending","SortByFieldId":' + @ItemId + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"ItemId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @ItemId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null},{"Filter":"IsCorrect","ComaprisonType":"Equals","ComaprisonValue":"Correct","FilterByField":null,"FilterByFieldId":' + @IsCorrect + 
				',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":false,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - Science Avg % Incorrect by Item ' AS ReportDetailsName
				,'What is the Average % Incorrect by Item in MCAS Science?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[ItemId] as [ItemId], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[ItemId] = ds1.[ItemId]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ISNULL(ds.[IsCorrect],'' '') = ''Incorrect'') AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[ItemId],ds.[IsCorrect]  ORDER BY ds.[ItemId] ASC,ds.[IsCorrect] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @DistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["IsCorrect"],"CategoryColumns":["ItemId"],"AliasNameList":[{"Name":"ItemId","AliasName":"Item"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"DistrictStudentId","AliasName":"AVG % Incorrect"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' 
				+ @ELL + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @Gender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @Grade + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"High Needs","SortOrder":0,"FiledId":"' + @HighNeeds + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @Race + '","DefaultValue":null},{"DisplayName":"ItemId","ColumnName":"ItemId","AliasName":"Item","SortOrder":0,"FiledId":"' + @ItemId + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ItemTypeDescription + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @Reporting_Category + 
				'","DefaultValue":null},{"DisplayName":"MA_Curriculum_Framework","ColumnName":"MA_Curriculum_Framework","AliasName":"Curriculum Framework","SortOrder":0,"FiledId":"' + @MA_Curriculum_Framework + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @SchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @SchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @Gender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @Grade + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @Race + 
				'","DefaultValue":null},{"DisplayName":"ItemId","ColumnName":"ItemId","AliasName":"Item","SortOrder":0,"FiledId":"' + @ItemId + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ItemTypeDescription + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @Reporting_Category + '","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,NULL AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6168' AS ReportDetailsCode
				,'MCAS - Science Item Analysis Students List' AS ChildReportDetailsName
				,'' + @TenantCode + '_MCASItemStudentTeacherResults_Science_DS' AS LinkedReportDataSourceName
				,NULL AS [Min]
				,NULL AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"ItemId","SortType":"Ascending","SortByFieldId":' + @ItemId + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @IsCorrect + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @DistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null},{"Filter":"IsCorrect","ComaprisonType":"Equals","ComaprisonValue":"Incorrect","FilterByField":null,"FilterByFieldId":' + @IsCorrect + 
				',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":false,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - Science Avg % Incorrect by Item type and Category' AS ReportDetailsName
				,'What is the Average % Incorrect by Item type and Category in MCAS Science?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[ItemTypeDescription] as [ItemTypeDescription], ds.[Reporting_Category] as [Reporting_Category], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[ItemTypeDescription] = ds1.[ItemTypeDescription]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ISNULL(ds.[IsCorrect],'' '') = ''Incorrect'') AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[ItemTypeDescription],ds.[Reporting_Category],ds.[IsCorrect]  ORDER BY ds.[ItemTypeDescription] ASC,ds.[Reporting_Category] ASC,ds.[IsCorrect] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @DistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["Reporting_Category","IsCorrect"],"CategoryColumns":["ItemTypeDescription"],"AliasNameList":[{"Name":"ItemTypeDescription","AliasName":"Item Type"},{"Name":"Reporting_Category","AliasName":"Item Category"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"DistrictStudentId","AliasName":"AVG % Incorrect"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' 
				+ @SchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @SchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @Gender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @Grade + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @Race + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ItemTypeDescription + '","DefaultValue":null},{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' + @ELL + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"HighNeeds","SortOrder":0,"FiledId":"' + @HighNeeds + 
				'","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @Reporting_Category + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @SchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @SchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @Gender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @Grade + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @Race + 
				'","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ItemTypeDescription + '","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_31' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6147' AS ReportDetailsCode
				,'MCAS - Science Avg % Incorrect by Item ' AS ChildReportDetailsName
				,'' + @TenantCode + '_MCASItemStudentTeacherResults_Science_DS' AS LinkedReportDataSourceName
				,NULL AS [Min]
				,NULL AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"ItemTypeDescription","SortType":"Ascending","SortByFieldId":' + @ItemTypeDescription + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"Reporting_Category","SortType":"Ascending","SortByFieldId":' + @Reporting_Category + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @IsCorrect + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @DistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null},{"Filter":"IsCorrect","ComaprisonType":"Equals","ComaprisonValue":"Incorrect","FilterByField":null,"FilterByFieldId":' + @IsCorrect + 
				',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":false,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - Science Avg % Incorrect by Item type' AS ReportDetailsName
				,'What is the Average % Incorrect by Item type in MCAS Science?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[ItemTypeDescription] as [ItemTypeDescription], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[ItemTypeDescription] = ds1.[ItemTypeDescription]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ISNULL(ds.[IsCorrect],'' '') = ''Incorrect'') AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[ItemTypeDescription],ds.[IsCorrect]  ORDER BY ds.[ItemTypeDescription] ASC,ds.[IsCorrect] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @DistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["IsCorrect"],"CategoryColumns":["ItemTypeDescription"],"AliasNameList":[{"Name":"ItemTypeDescription","AliasName":"Item Type"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"DistrictStudentId","AliasName":"Avg % Incorrect"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' 
				+ @ELL + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @Gender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @Grade + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"High Needs","SortOrder":0,"FiledId":"' + @HighNeeds + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @Race + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @Reporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ItemTypeDescription + 
				'","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @SchoolName + '","DefaultValue":null},{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @SchoolYear + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @SchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @SchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @Gender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @Grade + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @Race + 
				'","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ItemTypeDescription + '","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_28' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6139' AS ReportDetailsCode
				,'MCAS - Science Avg % Incorrect by Item ' AS ChildReportDetailsName
				,'' + @TenantCode + '_MCASItemStudentTeacherResults_Science_DS' AS LinkedReportDataSourceName
				,NULL AS [Min]
				,NULL AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"ItemTypeDescription","SortType":"Ascending","SortByFieldId":' + @ItemTypeDescription + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @IsCorrect + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @DistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null},{"Filter":"IsCorrect","ComaprisonType":"Equals","ComaprisonValue":"Incorrect","FilterByField":null,"FilterByFieldId":' + @IsCorrect + 
				',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":false,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - Science Item Analysis Students List' AS ReportDetailsName
				,'MCAS - Science Item Analysis Students List' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[DistrictStudentId] as [DistrictStudentId], ds.[StudentName] as [StudentName], ds.[gender] as [gender], ds.[grade] as [grade], ds.[ItemId] as [ItemId], ds.[Itemtext] as [Itemtext], ds.[ItemTypeDescription] as [ItemTypeDescription], ds.[Reporting_Category] as [Reporting_Category], ds.[ItemMaxScore] as [ItemMaxScore], ds.[Correct_Answer] as [Correct_Answer], ds.[StudentScore] as [StudentScore], ds.[SchoolName] as [SchoolName]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS as ds with (nolock)   WHERE  (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + ')   ORDER BY ds.[DistrictStudentId] ASC,ds.[ItemId] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS' AS ViewName
				,'Table' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,
				'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":null,"SeriesColumn":null,"CategoryColumns":["DistrictStudentId","StudentName","gender","grade","ItemId","Itemtext","ItemTypeDescription","Reporting_Category","ItemMaxScore","Correct_Answer","StudentScore","SchoolName"],"AliasNameList":[{"Name":"DistrictStudentId","AliasName":"DistrictStudentId"},{"Name":"StudentName","AliasName":"Student Name"},{"Name":"gender","AliasName":"Gender"},{"Name":"grade","AliasName":"Tested Grade"},{"Name":"ItemId","AliasName":"Item"},{"Name":"ItemMaxScore","AliasName":"Max Score"},{"Name":"Itemtext","AliasName":"Item Description"},{"Name":"ItemTypeDescription","AliasName":"Item Type"},{"Name":"Reporting_Category","AliasName":"Item Category"},{"Name":"StudentScore","AliasName":"Student Score"},{"Name":"Correct_Answer","AliasName":"Correct Answer"},{"Name":"SchoolName","AliasName":"School Name"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' 
				+ @ELL + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @Gender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @Grade + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"HighNeeds","SortOrder":0,"FiledId":"' + @HighNeeds + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ItemTypeDescription + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @Reporting_Category + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @Race + 
				'","DefaultValue":null},{"DisplayName":"MA_Curriculum_Framework","ColumnName":"MA_Curriculum_Framework","AliasName":"Curriculum Framework","SortOrder":0,"FiledId":"' + @MA_Curriculum_Framework + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @SchoolName + '","DefaultValue":null},{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @SchoolYear + '","DefaultValue":null},{"DisplayName":"StudentScore","ColumnName":"StudentScore","AliasName":"Student Score","SortOrder":0,"FiledId":"' + @StudentScore + '","DefaultValue":null}],"SubGroupColumns":null,"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,NULL AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6165' AS ReportDetailsCode
				,NULL AS ChildReportDetailsName
				,NULL AS LinkedReportDataSourceName
				,NULL AS [Min]
				,NULL AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"DistrictStudentId","SortType":"Ascending","SortByFieldId":' + @DistrictStudentId + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"ItemId","SortType":"Ascending","SortByFieldId":' + @ItemId + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - Science Item Analysis' AS ReportDetailsName
				,'MCAS - Science Item Analysis' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[LeaName] as [LeaName], ds.[SchoolName] as [SchoolName], ds.[Grade] as [Grade], ds.[Reporting_Category] as [Reporting_Category], ds.[ItemTypeDescription] as [ItemTypeDescription], ds.[ItemId] as [ItemId], ds.[Itemtext] as [Itemtext], ds.[Avg_School_Correct] as [Avg_School_Correct], ds.[Avg_Correct] as [Avg_Correct], ds.[School_Percent_Possible] as [School_Percent_Possible], ds.[Diff_From_School_State] as [Diff_From_School_State], ds.[Diff_From_State] as [Diff_From_State]  FROM dbo.' + @TenantCode + 'AggrptMCASItemAnalysisDS as ds with (nolock)  LEFT JOIN dbo.' + @TenantCode + '_MCAS_Item_SortOrder_Vw ON ds.[ItemId] = dbo.' + @TenantCode + '_MCAS_Item_SortOrder_Vw.itemid AND  ds.tenantid =dbo.' + @TenantCode + '_MCAS_Item_SortOrder_Vw.tenantid    WHERE  ((ISNULL(ds.[SubjectAreaCode],'' '') = ''Science'') AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   ORDER BY ds.[LeaName] ASC,ds.[SchoolName] ASC,ds.[Grade] ASC,dbo.' + @TenantCode + 
				'_MCAS_Item_SortOrder_Vw.SortOrder ASC,ds.[ItemId] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'AggrptMCASItemAnalysisDS' AS ViewName
				,'Table' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,
				'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":null,"SeriesColumn":null,"CategoryColumns":["LeaName","SchoolName","Grade","Reporting_Category","ItemTypeDescription","ItemId","Itemtext","Avg_School_Correct","Avg_Correct","School_Percent_Possible","Diff_From_School_State","Diff_From_State"],"AliasNameList":[{"Name":"LeaName","AliasName":"District"},{"Name":"SchoolName","AliasName":"School"},{"Name":"Grade","AliasName":"Tested Grade"},{"Name":"Reporting_Category","AliasName":"Item Category"},{"Name":"ItemTypeDescription","AliasName":"Item Type"},{"Name":"ItemId","AliasName":"Item"},{"Name":"Itemtext","AliasName":"Item Description"},{"Name":"Avg_School_Correct","AliasName":"Avg School % Correct"},{"Name":"Avg_Correct","AliasName":"Avg Correct"},{"Name":"School_Percent_Possible","AliasName":"School % Possible"},{"Name":"Diff_From_School_State","AliasName":"Diff From School to State"},{"Name":"Diff_From_State","AliasName":"Diff From District to State"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"LeaName","ColumnName":"LeaName","AliasName":"District","SortOrder":0,"FiledId":"' 
				+ @AggLeaname + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School","SortOrder":0,"FiledId":"' + @AggSchoolName + '","DefaultValue":null},{"DisplayName":"Grade","ColumnName":"Grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @AggGrade + '","DefaultValue":null},{"DisplayName":"ItemId","ColumnName":"ItemId","AliasName":"Item","SortOrder":0,"FiledId":"' + @AggItemId + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @AggItemTypeDescription + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @AggReporting_Category + '","DefaultValue":null},{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @AggSchoolYear + 
				'","DefaultValue":null}],"SubGroupColumns":null,"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_32' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6174' AS ReportDetailsCode
				,NULL AS ChildReportDetailsName
				,NULL AS LinkedReportDataSourceName
				,NULL AS [Min]
				,NULL AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"LeaName","SortType":"Ascending","SortByFieldId":' + @AggLeaname + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"SchoolName","SortType":"Ascending","SortByFieldId":' + @AggSchoolName + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"Grade","SortType":"Ascending","SortByFieldId":' + @AggGrade + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"ItemId","SortType":"Ascending","SortByFieldId":' + @AggItemId + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"SubjectAreaCode","ComaprisonType":"Equals","ComaprisonValue":"Science","FilterByField":null,"FilterByFieldId":' + @AggSubjectAreaCode + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS-Science  Avg % Correct by Item type and Category' AS ReportDetailsName
				,'What is the Average % correct by Item type and Category in MCAS Science?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[ItemTypeDescription] as [ItemTypeDescription], ds.[Reporting_Category] as [Reporting_Category], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[ItemTypeDescription] = ds1.[ItemTypeDescription]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ISNULL(ds.[IsCorrect],'' '') = ''Correct'') AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[ItemTypeDescription],ds.[Reporting_Category],ds.[IsCorrect]  ORDER BY ds.[ItemTypeDescription] ASC,ds.[Reporting_Category] ASC,ds.[IsCorrect] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @DistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["Reporting_Category","IsCorrect"],"CategoryColumns":["ItemTypeDescription"],"AliasNameList":[{"Name":"ItemTypeDescription","AliasName":"Item Type"},{"Name":"Reporting_Category","AliasName":"Item Category"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"DistrictStudentId","AliasName":"AVG % Correct"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' 
				+ @SchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @SchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @Gender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @Grade + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @Race + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ItemTypeDescription + '","DefaultValue":null},{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' + @ELL + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"HighNeeds","SortOrder":0,"FiledId":"' + @HighNeeds + 
				'","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @Reporting_Category + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @SchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @SchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @Gender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @Grade + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @Race + 
				'","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ItemTypeDescription + '","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_30' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6151' AS ReportDetailsCode
				,'MCAS - Science Avg % correct by Item' AS ChildReportDetailsName
				,'' + @TenantCode + '_MCASItemStudentTeacherResults_Science_DS' AS LinkedReportDataSourceName
				,NULL AS [Min]
				,NULL AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"ItemTypeDescription","SortType":"Ascending","SortByFieldId":' + @ItemTypeDescription + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"Reporting_Category","SortType":"Ascending","SortByFieldId":' + @Reporting_Category + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @IsCorrect + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @DistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null},{"Filter":"IsCorrect","ComaprisonType":"Equals","ComaprisonValue":"Correct","FilterByField":null,"FilterByFieldId":' + @IsCorrect + 
				',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":false,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS-Science Avg % Incorrect by Item Category' AS ReportDetailsName
				,'What is the Average % Incorrect by Item Category in MCAS Science?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[Reporting_Category] as [Reporting_Category], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[Reporting_Category] = ds1.[Reporting_Category]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ISNULL(ds.[IsCorrect],'' '') = ''Incorrect'') AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[Reporting_Category],ds.[IsCorrect]  ORDER BY ds.[IsCorrect] ASC,ds.[Reporting_Category] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @DistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["IsCorrect"],"CategoryColumns":["Reporting_Category"],"AliasNameList":[{"Name":"Reporting_Category","AliasName":"Reporting Category"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"DistrictStudentId","AliasName":"AVG % Incorrect"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' 
				+ @ELL + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @Gender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @Grade + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"HighNeeds","SortOrder":0,"FiledId":"' + @HighNeeds + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"race","SortOrder":0,"FiledId":"' + @Race + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @Reporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ItemTypeDescription + 
				'","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @SchoolName + '","DefaultValue":null},{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @SchoolYear + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @SchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @SchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @Gender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @Grade + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @Race + 
				'","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @Reporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ItemTypeDescription + '","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_25' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6125' AS ReportDetailsCode
				,'MCAS - Science Avg % Incorrect by Item ' AS ChildReportDetailsName
				,'' + @TenantCode + '_MCASItemStudentTeacherResults_Science_DS' AS LinkedReportDataSourceName
				,NULL AS [Min]
				,NULL AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @IsCorrect + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"Reporting_Category","SortType":"Ascending","SortByFieldId":' + @Reporting_Category + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @DistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null},{"Filter":"IsCorrect","ComaprisonType":"Equals","ComaprisonValue":"Incorrect","FilterByField":null,"FilterByFieldId":' + @IsCorrect + 
				',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":false,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS-Science- Avg % by Item Category' AS ReportDetailsName
				,'What is the Average % by Item category in MCAS Science?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[Reporting_Category] as [Reporting_Category], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[Reporting_Category] = ds1.[Reporting_Category]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[Reporting_Category],ds.[IsCorrect]  ORDER BY ds.[IsCorrect] ASC,ds.[Reporting_Category] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @DistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["IsCorrect"],"CategoryColumns":["Reporting_Category"],"AliasNameList":[{"Name":"Reporting_Category","AliasName":"Reporting Category"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"DistrictStudentId","AliasName":"AVG %"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' 
				+ @ELL + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @Gender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @Grade + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"High Needs","SortOrder":0,"FiledId":"' + @HighNeeds + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @Race + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @Reporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ItemTypeDescription + 
				'","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @SchoolName + '","DefaultValue":null},{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @SchoolYear + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @SchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @SchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @Gender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @Grade + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @Race + 
				'","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @Reporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ItemTypeDescription + '","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_23' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6130' AS ReportDetailsCode
				,'MCAS - Science Avg % correct by Item' AS ChildReportDetailsName
				,'' + @TenantCode + '_MCASItemStudentTeacherResults_Science_DS' AS LinkedReportDataSourceName
				,'0' AS [Min]
				,'100' AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @IsCorrect + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"Reporting_Category","SortType":"Ascending","SortByFieldId":' + @Reporting_Category + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @DistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS-Science- Avg % Correct by Item Category' AS ReportDetailsName
				,'What is the Average correct % by Item category in MCAS Science?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[Reporting_Category] as [Reporting_Category], ds.[IsCorrect] as [IsCorrect],Cast(Count(ISNULL(ds.[DistrictStudentId], 0)) *100.00 / (SELECT Count(ISNULL(ds1.[DistrictStudentId], 0)) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS as ds1 with (nolock)   WHERE  ((ds1.[DistrictStudentId] IS NOT NULL ) AND (ds1.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))    AND ds.[Reporting_Category] = ds1.[Reporting_Category]) as decimal(10,1) ) as [DistrictStudentId]  FROM dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS as ds with (nolock)   WHERE  ((ds.[DistrictStudentId] IS NOT NULL ) AND (ISNULL(ds.[IsCorrect],'' '') = ''Correct'') AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[Reporting_Category],ds.[IsCorrect]  ORDER BY ds.[Reporting_Category] ASC,ds.[IsCorrect] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'MCASItemStudentTeacherResultsScienceDS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @DistrictStudentId + 
				'","Value":"DistrictStudentId","Code":"Percentage","ChartType":null,"IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":["IsCorrect"],"CategoryColumns":["Reporting_Category"],"AliasNameList":[{"Name":"Reporting_Category","AliasName":"Item Category"},{"Name":"IsCorrect","AliasName":"IsCorrect"},{"Name":"DistrictStudentId","AliasName":"AVG % Correct"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"ELL","ColumnName":"ELL","AliasName":"ELL","SortOrder":0,"FiledId":"' 
				+ @ELL + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @Gender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @Grade + '","DefaultValue":null},{"DisplayName":"HighNeeds","ColumnName":"HighNeeds","AliasName":"High Needs","SortOrder":0,"FiledId":"' + @HighNeeds + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @Race + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @Reporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ItemTypeDescription + 
				'","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @SchoolName + '","DefaultValue":null},{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @SchoolYear + '","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @SchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @SchoolName + '","DefaultValue":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"' + @Gender + '","DefaultValue":null},{"DisplayName":"grade","ColumnName":"grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @Grade + '","DefaultValue":null},{"DisplayName":"race","ColumnName":"race","AliasName":"Race","SortOrder":0,"FiledId":"' + @Race + 
				'","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @Reporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @ItemTypeDescription + '","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_24' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'6134' AS ReportDetailsCode
				,'MCAS - Science Avg % correct by Item' AS ChildReportDetailsName
				,'' + @TenantCode + '_MCASItemStudentTeacherResults_Science_DS' AS LinkedReportDataSourceName
				,NULL AS [Min]
				,NULL AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"Reporting_Category","SortType":"Ascending","SortByFieldId":' + @Reporting_Category + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"IsCorrect","SortType":"Ascending","SortByFieldId":' + @IsCorrect + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"DistrictStudentId","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @DistrictStudentId + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null},{"Filter":"IsCorrect","ComaprisonType":"Equals","ComaprisonValue":"Correct","FilterByField":null,"FilterByFieldId":' + @IsCorrect + 
				',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":false,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			
			UNION ALL
			
			SELECT 'MCAS - Science Item Analysis School Avg % correct VS State Avg % correct' AS ReportDetailsName
				,'What is  School Avg % correct VS State Avg % correct  by Item in MCAS Science?' AS ReportDetailsDescription
				,'K12Student' AS EntityName
				,'SELECT  ds.[SchoolName] as [SchoolName], ds.[ItemId] as [ItemId],cast(Avg(cast(ISNULL(ds.[State_Percent_Possible], 0) as decimal(15,1)))  as decimal(15,1)) as [State_Percent_Possible],cast(Avg(cast(ISNULL(ds.[Avg_School_Correct], 0) as decimal(15,1)))  as decimal(15,1)) as [Avg_School_Correct]  FROM dbo.' + @TenantCode + 'AggrptMCASItemAnalysisDS as ds with (nolock)  LEFT JOIN dbo.' + @TenantCode + '_MCAS_Item_SortOrder_Vw ON ds.[ItemId] = dbo.' + @TenantCode + '_MCAS_Item_SortOrder_Vw.itemid AND  ds.tenantid =dbo.' + @TenantCode + '_MCAS_Item_SortOrder_Vw.tenantid    WHERE  ((ISNUMERIC(ISNULL(ds.[State_Percent_Possible], 0)) = 1) AND (ISNUMERIC(ISNULL(ds.[Avg_School_Correct], 0)) = 1) AND (ds.[SubjectAreaCode] = ''Science'') AND (ds.[SchoolName] IS NOT NULL ) AND (ds.TenantId = ' + Cast(@TenantId AS VARCHAR) + '))   GROUP BY ds.[SchoolName],ds.[ItemId],dbo.' + @TenantCode + '_MCAS_Item_SortOrder_Vw.SortOrder  ORDER BY ds.[SchoolName] ASC,dbo.' + @TenantCode + 
				'_MCAS_Item_SortOrder_Vw.SortOrder ASC,ds.[ItemId] ASC ' AS ReportQuery
				,'dbo.' + @TenantCode + 'AggrptMCASItemAnalysisDS' AS ViewName
				,'Chart' AS ReportTypeCode
				,'1' AS IsSharePublic
				,'0' AS IsCustom
				,'0' AS IsDraft
				,NULL AS FileTemplateId
				,NULL AS IsReportFromFile
				,NULL AS IsReportFromService
				,'{"FileName":null,"IsDefault":null,"DisplayLatestYearData":false,"DisplayGoalLine":false,"MetricReportTypeCode":null,"ValueColumn":[{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @AggState_Percent_Possible + 
				'","Value":"State_Percent_Possible","Code":"Avg","ChartType":"Line","IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false},{"StudentsSubgroupListId":null,"Key":0,"KeyInt32":0,"Identifier":"' + @AggAvg_School_Correct + 
				'","Value":"Avg_School_Correct","Code":"Avg","ChartType":"Line","IdentifierCode":null,"ProfileEntityCode":null,"TabCode":null,"Color":null,"DisplayName":null,"LookupColumn":null,"LookupTable":null,"IsDefault":false,"DisplayFilters":false,"SortOrder":0,"ColorCodesList":null,"OrgCategoryId":null,"ChildReportDetailsId":null,"CategoryColumns":null,"CategoryColumnIds":null,"LinkedReportMappedFiledsModel":null,"ValueColumn":null,"MetricIndicatercolorarry":null,"SchoolCategoryId":null,"SchoolCategoryCode":null,"OrgId":null,"OrgName":null,"OrgCode":null,"GradeId":null,"Gradecode":null,"SchoolIdentifier":null,"CourseValue":null,"StudentCohortId":null,"CohortTitle":null,"CourseTitle":null,"SectionTitle":null,"IsHavingDashoardGroups":false}],"SeriesColumn":null,"CategoryColumns":["SchoolName","ItemId"],"AliasNameList":[{"Name":"SchoolName","AliasName":"School"},{"Name":"ItemId","AliasName":"Item"},{"Name":"State_Percent_Possible","AliasName":"State Avg % correct"},{"Name":"Avg_School_Correct","AliasName":"School Avg % correct"}],"MetricIcon":null,"AdvanceFilter":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' 
				+ @AggSchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @AggSchoolName + '","DefaultValue":null},{"DisplayName":"Grade","ColumnName":"Grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @AggGrade + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @AggReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @AggItemTypeDescription + '","DefaultValue":null},{"DisplayName":"MA_Curriculum_Framework","ColumnName":"MA_Curriculum_Framework","AliasName":"Curriculum Framework","SortOrder":0,"FiledId":"' + @AggMA_Curriculum_Framework + '","DefaultValue":null},{"DisplayName":"ItemId","ColumnName":"ItemId","AliasName":"Item","SortOrder":0,"FiledId":"' + @AggItemId + 
				'","DefaultValue":null}],"SubGroupColumns":[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"' + @AggSchoolYear + '","DefaultValue":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"' + @AggSchoolName + '","DefaultValue":null},{"DisplayName":"Grade","ColumnName":"Grade","AliasName":"Tested Grade","SortOrder":0,"FiledId":"' + @AggGrade + '","DefaultValue":null},{"DisplayName":"Reporting_Category","ColumnName":"Reporting_Category","AliasName":"Item Category","SortOrder":0,"FiledId":"' + @AggReporting_Category + '","DefaultValue":null},{"DisplayName":"ItemTypeDescription","ColumnName":"ItemTypeDescription","AliasName":"Item Type","SortOrder":0,"FiledId":"' + @AggItemTypeDescription + '","DefaultValue":null},{"DisplayName":"ItemId","ColumnName":"ItemId","AliasName":"Item","SortOrder":0,"FiledId":"' + @AggItemId + 
				'","DefaultValue":null}],"SubGroupFilterColumns":null,"FavoritesFilters":null,"HeatMapRanges":null,"ChildReportdisplaycolumnList":null}' AS ReportFileDetails
				,'1' AS IsDynamicReport
				,'MI_33' AS ReportParams
				,'Assessment' AS DataDomainName
				,NULL AS MetricId
				,'8289' AS ReportDetailsCode
				,NULL AS ChildReportDetailsName
				,NULL AS LinkedReportDataSourceName
				,NULL AS [Min]
				,NULL AS [Max]
				,NULL AS ReportDetailsSortOrder
				,NULL AS DashboardId
				,NULL AS IsSubReport
				,'0' AS IsFromJson
				,'0' AS IsRapidReport
				,NULL AS GoalMetricId
				,'[{"SortBy":"SchoolName","SortType":"Ascending","SortByFieldId":' + @AggSchoolName + ',"SortyByOrder":null,"SortFieldName":null},{"SortBy":"ItemId","SortType":"Ascending","SortByFieldId":' + @AggItemId + ',"SortyByOrder":null,"SortFieldName":null}]' AS SortBy
				,'[{"Filter":"SubjectAreaCode","ComaprisonType":"Equals","ComaprisonValue":"Science","FilterByField":null,"FilterByFieldId":' + @AggSubjectAreaCode + ',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null},{"Filter":"SchoolName","ComaprisonType":"IsNotNull","ComaprisonValue":null,"FilterByField":null,"FilterByFieldId":' + @AggSchoolName + 
				',"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]' AS FilterBy
				,@TenantId AS [TenantId]
				,1 AS [StatusId]
				,'DDAUser@DDA' AS [CreatedBy]
				,getdate() AS [CreatedDate]
			) AS A

		INSERT INTO ReportDetails (
			ReportDetailsName
			,ReportDetailsDescription
			,EntityId
			,ReportQuery
			,DomainRelatedViewId
			,ReportTypeId
			,IsSharePublic
			,IsCustom
			,IsDraft
			,SortBy
			,FilterBy
			,FileTemplateId
			,IsReportFromFile
			,IsReportFromService
			,ReportFileDetails
			,IsDynamicReport
			,ReportParams
			,DataDomainId
			,MetricId
			,ReportDetailsCode
			,ChildReportId
			,LinkedReportDataSourceName
			,Min
			,Max
			,SortOrder
			,DashboardId
			,IsSubReport
			,IsFromJson
			,IsRapidReport
			,TenantId
			,StatusId
			,GoalMetricId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			)
		SELECT ReportDetailsName
			,ReportDetailsDescription
			,EntityId
			,ReportQuery
			,DomainRelatedViewId
			,ReportTypeId
			,IsSharePublic
			,IsCustom
			,IsDraft
			,SortBy
			,FilterBy
			,FileTemplateId
			,IsReportFromFile
			,IsReportFromService
			,ReportFileDetails
			,IsDynamicReport
			,ReportParams
			,DataDomainId
			,MetricId
			,ReportDetailsCode
			,ChildReportId
			,LinkedReportDataSourceName
			,Min
			,Max
			,SortOrder
			,DashboardId
			,IsSubReport
			,IsFromJson
			,IsRapidReport
			,TenantId
			,StatusId
			,GoalMetricId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
		FROM (
			SELECT *
				,Row_number() OVER (
					PARTITION BY ReportDetailsName ORDER BY ReportDetailsName
					) Rno
			FROM (
				SELECT DISTINCT ReportDetailsName
					,ReportDetailsDescription
					,e.EntityId
					,ReportQuery
					,drv.DomainRelatedViewId
					,rt.ReportTypeId
					,IsSharePublic
					,IsCustom
					,IsDraft
					,SortBy
					,FilterBy
					,FileTemplateId
					,IsReportFromFile
					,IsReportFromService
					,ReportFileDetails
					,IsDynamicReport
					,ReportParams
					,dd.DataDomainId
					,MetricId
					,NULL ReportDetailsCode
					,NULL ChildReportId
					,NULL LinkedReportDataSourceName
					,[Min]
					,[Max]
					,tmp.ReportDetailsSortOrder AS SortOrder
					,DashboardId
					,IsSubReport
					,IsFromJson
					,IsRapidReport
					,tmp.TenantId
					,tmp.StatusId AS StatusId
					,GoalMetricId
					,'Adam.admin' CreatedBy
					,Getdate() CreatedDate
					,NULL ModifiedBy
					,NULL ModifiedDate
				FROM #ReportDetails tmp
				INNER JOIN RefEntity e ON tmp.EntityName = e.EntityName
				INNER JOIN RptDomainRelatedViews drv ON drv.ViewName = tmp.ViewName
					AND drv.TenantId = tmp.TenantId
				INNER JOIN RefDataDomain dd ON dd.DataDomainName = tmp.DataDomainName
					AND dd.TenantId = tmp.TenantId
				INNER JOIN RefReportType rt ON rt.ReportTypeCode = tmp.ReportTypeCode
					AND rt.TenantId = tmp.TenantId
				) AS A
			WHERE NOT EXISTS (
					SELECT 1
					FROM ReportDetails b
					WHERE a.ReportDetailsName = b.ReportDetailsName
						AND a.DataDomainId = b.DataDomainId
						AND a.TenantId = b.TenantId
					)
			) a
		WHERE Rno = 1

		IF EXISTS (
				SELECT 1
				FROM INFORMATION_SCHEMA.TABLES
				WHERE TABLE_NAME = 'ReportChartDetails'
				)
		BEGIN
			INSERT INTO ReportChartDetails (
				ReportDetailsId
				,Section
				,KeyName
				,Value
				,TenantId
				,StatusId
				,CreatedBy
				,CreatedDate
				,ModifiedBy
				,ModifiedDate
				)
			SELECT *
			FROM (
				SELECT DISTINCT rd1.ReportDetailsId
					,Section
					,KeyName
					,Value
					,cd.TenantId
					,cd.StatusId
					,cd.CreatedBy
					,cd.CreatedDate
					,NULL AS ModifiedBy
					,NULL AS ModifiedDate
				FROM (
					SELECT ReportDetailsName
						,REPLACE(ViewName, 'TenantCode', @TenantCode) AS ViewName
						,Section
						,KeyName
						,[Value]
						,ChartDetailsStatusId
						,StatusId
						,CreatedBy
						,CreatedDate
						,@TenantId AS TenantId
					FROM AnalyticVue.dbo.MCASReportChartDetails
					) cd
				INNER JOIN #ReportDetails rd ON cd.ReportDetailsName = rd.ReportDetailsName
					AND cd.TenantId = rd.TenantId
				INNER JOIN ReportDetails rd1 ON rd1.ReportDetailsName = rd.ReportDetailsName
					AND rd1.TenantId = rd.TenantId
				) AS a
			WHERE NOT EXISTS (
					SELECT 1
					FROM ReportChartDetails b
					WHERE a.ReportDetailsId = b.ReportDetailsId
						AND a.TenantId = b.TenantId
						AND a.Section = b.Section
						AND a.KeyName = b.KeyName
					)
		END

		IF EXISTS (
				SELECT 1
				FROM INFORMATION_SCHEMA.TABLES
				WHERE TABLE_NAME = 'ReportColumns'
				)
		BEGIN
			INSERT INTO dbo.ReportColumns (
				ReportDetailsId
				,IsAggregate
				,AggregateId
				,IsCategory
				,IsSeries
				,RptViewFieldsId
				,FileTemplateFieldId
				,IsCustom
				,SortOrder
				,TenantId
				,StatusId
				,CreatedBy
				,CreatedDate
				,ModifiedBy
				,ModifiedDate
				,ComboChartType
				)
			SELECT *
			FROM (
				SELECT DISTINCT ReportDetailsId
					,IsAggregate
					,AggregateId
					,IsCategory
					,IsSeries
					,RptViewFieldsId
					,FileTemplateFieldId
					,ReportColumnsIsCustom AS IsCustom
					,rc.ReportColumnSortOrder AS SortOrder
					,rc.TenantId
					,rc.StatusId
					,rc.CreatedBy
					,GETDATE() CreatedDate
					,NULL ModifiedBy
					,NULL ModifiedDate
					,ComboChartType
				FROM (
					SELECT DISTINCT ReportDetailsName
						,REPLACE(ViewName, 'TenantCode', @TenantCode) AS ViewName
						,IsAggregate
						,AggregateCode
						,IsCategory
						,IsSeries
						,ReportColumnName
						,FileTemplateFieldId
						,ReportColumnsIsCustom
						,ReportColumnSortOrder
						,ComboChartType
						,StatusId
						,CreatedBy
						,CreatedDate
						,@Tenantid AS TenantId
					FROM AnalyticVue.dbo.MCASReportColumns
					) rc
				INNER JOIN dbo.ReportDetails rd ON rc.ReportDetailsName = rd.ReportDetailsName
					AND rc.TenantId = rd.TenantId
				INNER JOIN dbo.RptViewFields rf ON rc.ReportColumnName = rf.ColumnName
					AND rc.TenantId = rf.TenantId
					AND rf.DomainRelatedViewId = rd.DomainRelatedViewId
				LEFT JOIN dbo.RefAggregate rg ON rc.Aggregatecode = rg.Aggregatecode
					AND rc.TenantId = rg.TenantId
				WHERE rc.ReportDetailsName IN (
						SELECT ReportDetailsName
						FROM ReportDetails
						)
				) AS a
			WHERE NOT EXISTS (
					SELECT 1
					FROM dbo.ReportColumns b
					WHERE a.ReportDetailsId = b.ReportDetailsId
						AND a.RptViewFieldsId = b.RptViewFieldsId
						AND a.TenantId = b.TenantId
					)
		END

		UPDATE rc
		SET rc.ReportDetailsCode = rc.ReportDetailsid
		FROM ReportDetails rc
		INNER JOIN #ReportDetails rd ON rc.ReportDetailsName = rd.ReportDetailsName
			AND rc.TenantId = rd.TenantId
		WHERE NOT EXISTS (
				SELECT 1
				FROM ReportDetails b
				WHERE rc.ReportDetailsCode = b.ReportDetailsCode
					AND rc.TenantId = b.TenantId
				)

		UPDATE rd
		SET rd.ChildReportId = crd.ReportDetailsId
			,rd.LinkedReportDataSourceName = drv.DisplayName
		FROM ReportDetails rd
		INNER JOIN #ReportDetails rd1 ON rd.ReportDetailsName = rd1.ReportDetailsName
			AND rd.TenantId = rd1.TenantId
		INNER JOIN ReportDetails crd ON crd.ReportDetailsName = rd1.ChildReportDetailsName
			AND crd.TenantId = rd1.TenantId
		INNER JOIN RptDomainRelatedViews drv ON crd.DomainRelatedViewId = drv.DomainRelatedViewId
			AND crd.TenantId = drv.TenantId

		DROP TABLE

		IF EXISTS #Parent
			DROP TABLE

		IF EXISTS #Child
			/***** Parent ******/
			SELECT DISTINCT *
			INTO #Parent
			FROM (
				SELECT pt.ReportDetailsId
					,ct.ReportDetailsId AS ChildReportId
					,JSON_VALUE(oj.value, '$.ColumnName') AS ParentCode
					,JSON_VALUE(oj.value, '$.ColumnName') AS ParentColumnName
					,'0' IsValueField
					,JSON_VALUE(oj.value, '$.DisplayName') AS DisplayName
					,pt.TenantId
					,1 AS StatusId
					,'Adam.admin' AS CreatedBy
					,Getdate() AS CreatedDate
					,NULL ModifiedBy
					,NULL ModifiedDate
				FROM ReportDetails pt
				JOIN ReportDetails ct ON Pt.ChildReportId = ct.ReportDetailsId
				CROSS APPLY OpenJson(pt.ReportfileDetails, '$.AdvanceFilter') AS Oj
				WHERE pt.tenantid = @Tenantid
					AND pt.ReportDetailsId IN (
						SELECT DISTINCT rd.ReportDetailsId
						FROM ReportDetails rd
						INNER JOIN #ReportDetails rd1 ON rd.ReportDetailsName = rd1.ReportDetailsName
							AND rd.TenantId = rd1.TenantId
						INNER JOIN ReportDetails crd ON crd.ReportDetailsName = rd1.ChildReportDetailsName
							AND crd.TenantId = rd1.TenantId
						INNER JOIN RptDomainRelatedViews drv ON crd.DomainRelatedViewId = drv.DomainRelatedViewId
							AND crd.TenantId = drv.TenantId
						WHERE rd.ChildReportId IS NOT NULL
						)
				
				UNION ALL
				
				SELECT pt.ReportDetailsId
					,ct.ReportDetailsId AS ChildReportId
					,JSON_VALUE(oj.value, '$.ColumnName') AS ParentCode
					,JSON_VALUE(oj.value, '$.ColumnName') AS ParentColumnName
					,'0' IsValueField
					,JSON_VALUE(oj.value, '$.DisplayName') AS DisplayName
					,pt.TenantId
					,1 AS StatusId
					,'Adam.admin' AS CreatedBy
					,Getdate() AS CreatedDate
					,NULL ModifiedBy
					,NULL ModifiedDate
				FROM ReportDetails pt
				JOIN ReportDetails ct ON Pt.ChildReportId = ct.ReportDetailsId
				CROSS APPLY OpenJson(pt.ReportfileDetails, '$.SubGroupColumns') AS Oj
				WHERE pt.tenantid = @Tenantid
					AND pt.ReportDetailsId IN (
						SELECT DISTINCT rd.ReportDetailsId
						FROM ReportDetails rd
						INNER JOIN #ReportDetails rd1 ON rd.ReportDetailsName = rd1.ReportDetailsName
							AND rd.TenantId = rd1.TenantId
						INNER JOIN ReportDetails crd ON crd.ReportDetailsName = rd1.ChildReportDetailsName
							AND crd.TenantId = rd1.TenantId
						INNER JOIN RptDomainRelatedViews drv ON crd.DomainRelatedViewId = drv.DomainRelatedViewId
							AND crd.TenantId = drv.TenantId
						WHERE rd.ChildReportId IS NOT NULL
						)
				
				UNION ALL
				
				SELECT pt.ReportDetailsId
					,ct.ReportDetailsId AS ChildReportId
					,JSON_VALUE(oj.value, '$.Value') AS ParentCode
					,JSON_VALUE(oj.value, '$.Value') AS ParentColumnName
					,'1' IsValueField
					,JSON_VALUE(oj.value, '$.Code') + '(' + JSON_VALUE(oj.value, '$.Value') + ')' AS DisplayName
					,pt.TenantId
					,1 AS StatusId
					,'Adam.admin' AS CreatedBy
					,Getdate() AS CreatedDate
					,NULL ModifiedBy
					,NULL ModifiedDate
				FROM ReportDetails pt
				JOIN ReportDetails ct ON Pt.ChildReportId = ct.ReportDetailsId
				CROSS APPLY OpenJson(pt.ReportfileDetails, '$.ValueColumn') AS Oj
				WHERE pt.tenantid = @Tenantid
					AND pt.ReportDetailsId IN (
						SELECT DISTINCT rd.ReportDetailsId
						FROM ReportDetails rd
						INNER JOIN #ReportDetails rd1 ON rd.ReportDetailsName = rd1.ReportDetailsName
							AND rd.TenantId = rd1.TenantId
						INNER JOIN ReportDetails crd ON crd.ReportDetailsName = rd1.ChildReportDetailsName
							AND crd.TenantId = rd1.TenantId
						INNER JOIN RptDomainRelatedViews drv ON crd.DomainRelatedViewId = drv.DomainRelatedViewId
							AND crd.TenantId = drv.TenantId
						WHERE rd.ChildReportId IS NOT NULL
						)
				
				UNION ALL
				
				SELECT pt.ReportDetailsId
					,ct.ReportDetailsId AS ChildReportId
					,oj.value AS ParentCode
					,oj.value AS ParentColumnName
					,'0' IsValueField
					,oj.value AS DisplayName
					,pt.TenantId
					,1 AS StatusId
					,'Adam.admin' AS CreatedBy
					,Getdate() AS CreatedDate
					,NULL ModifiedBy
					,NULL ModifiedDate
				FROM ReportDetails pt
				JOIN ReportDetails ct ON Pt.ChildReportId = ct.ReportDetailsId
				CROSS APPLY OpenJson(pt.ReportfileDetails, '$.SeriesColumn') AS Oj
				WHERE pt.tenantid = @Tenantid
					AND pt.ReportDetailsId IN (
						SELECT DISTINCT rd.ReportDetailsId
						FROM ReportDetails rd
						INNER JOIN #ReportDetails rd1 ON rd.ReportDetailsName = rd1.ReportDetailsName
							AND rd.TenantId = rd1.TenantId
						INNER JOIN ReportDetails crd ON crd.ReportDetailsName = rd1.ChildReportDetailsName
							AND crd.TenantId = rd1.TenantId
						INNER JOIN RptDomainRelatedViews drv ON crd.DomainRelatedViewId = drv.DomainRelatedViewId
							AND crd.TenantId = drv.TenantId
						WHERE rd.ChildReportId IS NOT NULL
						)
				
				UNION ALL
				
				SELECT pt.ReportDetailsId
					,ct.ReportDetailsId AS ChildReportId
					,oj.value AS ParentCode
					,oj.value AS ParentColumnName
					,'0' IsValueField
					,oj.value AS DisplayName
					,pt.TenantId
					,1 AS StatusId
					,'Adam.admin' AS CreatedBy
					,Getdate() AS CreatedDate
					,NULL ModifiedBy
					,NULL ModifiedDate
				FROM ReportDetails pt
				JOIN ReportDetails ct ON Pt.ChildReportId = ct.ReportDetailsId
				CROSS APPLY OpenJson(pt.ReportfileDetails, '$.CategoryColumns') AS Oj
				WHERE pt.tenantid = @Tenantid
					AND pt.ReportDetailsId IN (
						SELECT DISTINCT rd.ReportDetailsId
						FROM ReportDetails rd
						INNER JOIN #ReportDetails rd1 ON rd.ReportDetailsName = rd1.ReportDetailsName
							AND rd.TenantId = rd1.TenantId
						INNER JOIN ReportDetails crd ON crd.ReportDetailsName = rd1.ChildReportDetailsName
							AND crd.TenantId = rd1.TenantId
						INNER JOIN RptDomainRelatedViews drv ON crd.DomainRelatedViewId = drv.DomainRelatedViewId
							AND crd.TenantId = drv.TenantId
						WHERE rd.ChildReportId IS NOT NULL
						)
				) AS a

		/************ Child ***************/
		SELECT DISTINCT *
		INTO #Child
		FROM (
			SELECT pt.ReportDetailsId
				,ct.ReportDetailsId AS ChildReportId --,JSON_VALUE(oj.value,'$.ColumnName') as ParentCode,JSON_VALUE(oj.value,'$.ColumnName') as ParentColumnName 
				,JSON_VALUE(ctOj.value, '$.FiledId') AS ChildCode
				,JSON_VALUE(ctOj.value, '$.ColumnName') AS ChildColumnName
				,ct.TenantId
			FROM ReportDetails pt
			JOIN ReportDetails ct ON Pt.ChildReportId = ct.ReportDetailsId
			OUTER APPLY OpenJson(ct.ReportfileDetails, '$.AdvanceFilter') AS ctOj
			WHERE pt.tenantid = @Tenantid
				AND pt.ReportDetailsId IN (
					SELECT DISTINCT rd.ReportDetailsId
					FROM ReportDetails rd
					INNER JOIN #ReportDetails rd1 ON rd.ReportDetailsName = rd1.ReportDetailsName
						AND rd.TenantId = rd1.TenantId
					INNER JOIN ReportDetails crd ON crd.ReportDetailsName = rd1.ChildReportDetailsName
						AND crd.TenantId = rd1.TenantId
					INNER JOIN RptDomainRelatedViews drv ON crd.DomainRelatedViewId = drv.DomainRelatedViewId
						AND crd.TenantId = drv.TenantId
					WHERE rd.ChildReportId IS NOT NULL
					)
			
			UNION ALL
			
			SELECT pt.ReportDetailsId
				,ct.ReportDetailsId AS ChildReportId --,JSON_VALUE(oj.value,'$.ColumnName') as ParentCode,JSON_VALUE(oj.value,'$.ColumnName') as ParentColumnName 
				,JSON_VALUE(ctOj.value, '$.FiledId') AS ChildCode
				,JSON_VALUE(ctOj.value, '$.ColumnName') AS ChildColumnName
				,ct.TenantId
			FROM ReportDetails pt
			JOIN ReportDetails ct ON Pt.ChildReportId = ct.ReportDetailsId
			OUTER APPLY OpenJson(ct.ReportfileDetails, '$.SubGroupColumns') AS ctOj
			WHERE pt.tenantid = @Tenantid
				AND pt.ReportDetailsId IN (
					SELECT DISTINCT rd.ReportDetailsId
					FROM ReportDetails rd
					INNER JOIN #ReportDetails rd1 ON rd.ReportDetailsName = rd1.ReportDetailsName
						AND rd.TenantId = rd1.TenantId
					INNER JOIN ReportDetails crd ON crd.ReportDetailsName = rd1.ChildReportDetailsName
						AND crd.TenantId = rd1.TenantId
					INNER JOIN RptDomainRelatedViews drv ON crd.DomainRelatedViewId = drv.DomainRelatedViewId
						AND crd.TenantId = drv.TenantId
					WHERE rd.ChildReportId IS NOT NULL
					)
			
			UNION ALL
			
			SELECT pt.ReportDetailsId
				,ct.ReportDetailsId AS ChildReportId --,JSON_VALUE(oj.value,'$.ColumnName') as ParentCode,JSON_VALUE(oj.value,'$.ColumnName') as ParentColumnName 
				,NULL AS ChildCode
				,JSON_VALUE(ctOj.value, '$.Value') AS ChildColumnName
				,ct.TenantId
			FROM ReportDetails pt
			JOIN ReportDetails ct ON Pt.ChildReportId = ct.ReportDetailsId
			OUTER APPLY OpenJson(ct.ReportfileDetails, '$.ValueColumn') AS ctOj
			WHERE pt.tenantid = @Tenantid
				AND pt.ReportDetailsId IN (
					SELECT DISTINCT rd.ReportDetailsId
					FROM ReportDetails rd
					INNER JOIN #ReportDetails rd1 ON rd.ReportDetailsName = rd1.ReportDetailsName
						AND rd.TenantId = rd1.TenantId
					INNER JOIN ReportDetails crd ON crd.ReportDetailsName = rd1.ChildReportDetailsName
						AND crd.TenantId = rd1.TenantId
					INNER JOIN RptDomainRelatedViews drv ON crd.DomainRelatedViewId = drv.DomainRelatedViewId
						AND crd.TenantId = drv.TenantId
					WHERE rd.ChildReportId IS NOT NULL
					)
			
			UNION ALL
			
			SELECT pt.ReportDetailsId
				,ct.ReportDetailsId AS ChildReportId --,JSON_VALUE(oj.value,'$.ColumnName') as ParentCode,JSON_VALUE(oj.value,'$.ColumnName') as ParentColumnName 
				,JSON_VALUE(ctOj.value, '$.Identifier') AS ChildCode
				,JSON_VALUE(ctOj.value, '$.Value') AS ChildColumnName
				,ct.TenantId
			FROM ReportDetails pt
			JOIN ReportDetails ct ON Pt.ChildReportId = ct.ReportDetailsId
			OUTER APPLY OpenJson(ct.ReportfileDetails, '$.ValueColumn') AS ctOj
			WHERE pt.tenantid = @Tenantid
				AND pt.ReportDetailsId IN (
					SELECT DISTINCT rd.ReportDetailsId
					FROM ReportDetails rd
					INNER JOIN #ReportDetails rd1 ON rd.ReportDetailsName = rd1.ReportDetailsName
						AND rd.TenantId = rd1.TenantId
					INNER JOIN ReportDetails crd ON crd.ReportDetailsName = rd1.ChildReportDetailsName
						AND crd.TenantId = rd1.TenantId
					INNER JOIN RptDomainRelatedViews drv ON crd.DomainRelatedViewId = drv.DomainRelatedViewId
						AND crd.TenantId = drv.TenantId
					WHERE rd.ChildReportId IS NOT NULL
					)
			
			UNION ALL
			
			SELECT pt.ReportDetailsId
				,ct.ReportDetailsId AS ChildReportId --,JSON_VALUE(oj.value,'$.ColumnName') as ParentCode,JSON_VALUE(oj.value,'$.ColumnName') as ParentColumnName 
				,NULL AS ChildCode
				,ctOj.value AS ChildColumnName
				,ct.TenantId
			FROM ReportDetails pt
			JOIN ReportDetails ct ON Pt.ChildReportId = ct.ReportDetailsId
			OUTER APPLY OpenJson(ct.ReportfileDetails, '$.SeriesColumn') AS ctOj
			WHERE pt.tenantid = @Tenantid
				AND pt.ReportDetailsId IN (
					SELECT DISTINCT rd.ReportDetailsId
					FROM ReportDetails rd
					INNER JOIN #ReportDetails rd1 ON rd.ReportDetailsName = rd1.ReportDetailsName
						AND rd.TenantId = rd1.TenantId
					INNER JOIN ReportDetails crd ON crd.ReportDetailsName = rd1.ChildReportDetailsName
						AND crd.TenantId = rd1.TenantId
					INNER JOIN RptDomainRelatedViews drv ON crd.DomainRelatedViewId = drv.DomainRelatedViewId
						AND crd.TenantId = drv.TenantId
					WHERE rd.ChildReportId IS NOT NULL
					)
			
			UNION ALL
			
			SELECT pt.ReportDetailsId
				,ct.ReportDetailsId AS ChildReportId --,JSON_VALUE(oj.value,'$.ColumnName') as ParentCode,JSON_VALUE(oj.value,'$.ColumnName') as ParentColumnName 
				,NULL AS ChildCode
				,ctOj.value AS ChildColumnName
				,ct.TenantId
			FROM ReportDetails pt
			JOIN ReportDetails ct ON Pt.ChildReportId = ct.ReportDetailsId
			OUTER APPLY OpenJson(ct.ReportfileDetails, '$.CategoryColumns') AS ctOj
			WHERE pt.tenantid = @Tenantid
				AND pt.ReportDetailsId IN (
					SELECT DISTINCT rd.ReportDetailsId
					FROM ReportDetails rd
					INNER JOIN #ReportDetails rd1 ON rd.ReportDetailsName = rd1.ReportDetailsName
						AND rd.TenantId = rd1.TenantId
					INNER JOIN ReportDetails crd ON crd.ReportDetailsName = rd1.ChildReportDetailsName
						AND crd.TenantId = rd1.TenantId
					INNER JOIN RptDomainRelatedViews drv ON crd.DomainRelatedViewId = drv.DomainRelatedViewId
						AND crd.TenantId = drv.TenantId
					WHERE rd.ChildReportId IS NOT NULL
					)
			) AS a

		INSERT INTO dbo.LinkedReportMappedFileds
		SELECT DISTINCT *
		FROM (
			SELECT DISTINCT p.ReportDetailsId
				,p.ChildReportId
				,p.ParentCode
				,p.ParentColumnName
				,c.ChildCode
				,c.ChildColumnName AS ChildColumnName
				,p.IsValueField
				,p.DisplayName
				,p.TenantId
				,p.StatusId
				,p.CreatedBy
				,p.CreatedDate
				,p.ModifiedBy
				,p.ModifiedDate
			FROM #parent AS p
			LEFT JOIN #child AS c ON p.ParentCode = c.ChildColumnName
				AND p.ReportDetailsId = c.ReportDetailsId
				AND p.ChildReportId = c.ChildReportId
				AND p.tenantid = c.TenantId
				AND p.DisplayName = c.ChildColumnName
			) AS a
		WHERE NOT EXISTS (
				SELECT 1
				FROM dbo.LinkedReportMappedFileds b
				WHERE a.ReportDetailsId = b.ReportDetailsId
					AND a.ChildReportId = b.ChildReportId
					AND a.ParentCode = b.ParentCode
					AND a.ParentColumnName = b.ParentColumnName
					AND a.ChildCode = b.ChildCode
					AND a.ChildColumnName = b.ChildColumnName
					AND a.IsValueField = b.IsValueField
					AND a.DisplayName = b.DisplayName
					AND a.TenantId = b.TenantId
				)

		IF EXISTS (
				SELECT 1
				FROM INFORMATION_SCHEMA.COLUMNS
				WHERE TABLE_NAME = 'ReportDetails'
					AND COLUMN_NAME = 'IsDisplayinAnalytics'
				)
		BEGIN
			UPDATE a
			SET a.IsDisplayinAnalytics = 1
			FROM ReportDetails a
			JOIN #ReportDetails b ON a.ReportDetailsName = b.ReportDetailsName
				AND a.TenantId = b.TenantId
			WHERE a.IsDisplayinAnalytics <> 1
		END
	END TRY

	BEGIN CATCH
		-- Test whether the transaction is uncommittable.                         
		IF XACT_STATE() = - 1
		BEGIN
			ROLLBACK TRAN;
		END;

		--Comment it if SP contains only SELECT statement                                             
		DECLARE @ErrorFromProc VARCHAR(500);
		DECLARE @ProcErrorMessage VARCHAR(1000);
		DECLARE @SeverityLevel INT;
		DECLARE @ErrorNumber INT = ERROR_NUMBER();

		SELECT @ErrorFromProc = '[dbo].[USP_MCASItemAnalysis_ReportsMasterData]'
			,@ProcErrorMessage = ERROR_MESSAGE()
			,@SeverityLevel = ERROR_SEVERITY();

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
			,GETDATE()
			,@Tenantid
			);

		RAISERROR (
				'Error Number-%d : Error Message-%s'
				,16
				,1
				,@ErrorNumber
				,@ProcErrorMessage
				)
	END CATCH;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[USP_MCASItemAnalysis_DashboardsCreation] (@Tenantid INT)
AS
BEGIN
	SET XACT_ABORT ON;
	SET NOCOUNT ON

	BEGIN TRY
		/*****************Math Dashboard Script *****************/
		DECLARE @MIcontent1 NVARCHAR(max)
			,@MIcontent2 NVARCHAR(max)
			,@Micontent3 NVARCHAR(max)
			,@MIcontent4 NVARCHAR(max)
			,@MIcontent5 NVARCHAR(max)
			,@Micontent6 NVARCHAR(max)
			,@MIcontent7 NVARCHAR(max)
			,@MIcontent8 NVARCHAR(max)
			,@Micontent9 NVARCHAR(max)
			,@MIcontent10 NVARCHAR(max)
			,@MIcontent11 NVARCHAR(max)
			,@Micontent12 NVARCHAR(max)
		DECLARE @MIRpt1 INT
			,@MIRpt2 INT
			,@MIRpt3 INT
			,@MIRpt4 INT
			,@MIRpt5 INT
			,@MIRpt6 INT
			,@MIRpt7 INT
			,@MIRpt8 INT
			,@MIRpt9 INT
			,@MIRpt10 INT
			,@MIRpt11 INT
			,@MIDashboardId INT

		SELECT @MIRpt1 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_1'
			AND TenantId = @TenantId
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SELECT @MIRpt2 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_2'
			AND TenantId = @TenantId
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SELECT @MIRpt3 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_3'
			AND TenantId = @TenantId
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SELECT @MIRpt4 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_4'
			AND TenantId = @TenantId
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SELECT @MIRpt5 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_5'
			AND TenantId = @TenantId
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SELECT @MIRpt6 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_6'
			AND TenantId = @TenantId
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SELECT @MIRpt7 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_7'
			AND TenantId = @TenantId
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SELECT @MIRpt8 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_8'
			AND TenantId = @TenantId
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SELECT @MIRpt9 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_9'
			AND TenantId = @TenantId
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SELECT @MIRpt10 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_10'
			AND TenantId = @TenantId
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SELECT @MIRpt11 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_11'
			AND TenantId = @TenantId
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SET @MIcontent1 = N'<div class="row-flex"><div class="col-md-12-flex"><div class="drop_main"><div class="drop_child grid-container"><div class="grid-stack grid-stack-4 grid-stack-instance-4195 grid-stack-instance-3501 grid-stack-instance-4071 grid-stack-instance-1056" data-gs-current-height="76" style="height: 2270px;"><div class="grid-stack-item ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="0" data-gs-y="59" data-gs-width="12" data-gs-height="17" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MIRpt11 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1702985492084_' + cast(@MIRpt11 AS VARCHAR(100)) + '" value="Chart"><input type="hidden" id="hdndashlatecharttype1702985492084_' + cast(@MIRpt11 AS VARCHAR(100)) + '" value="combination"><input type="hidden" id="hdndashlatechartlegned1702985492084_' + cast(@MIRpt11 AS VARCHAR(100)) + 
			'" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1702985492084_' + cast(@MIRpt11 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1702985492084_' + cast(@MIRpt11 AS VARCHAR(100)) + '" value="medium"><input type="hidden" id="hdnredirecturl1702985492084_' + cast(@MIRpt11 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1702985492084_' + cast(@MIRpt11 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1702985492084_' + cast(@MIRpt11 AS VARCHAR(100)) + '" value="' + cast(@MIRpt11 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1702985492084_' + cast(@MIRpt11 AS VARCHAR(100)) + '" value="true"><input type="hidden" id="hdnsubject1702985492084_' + cast(@MIRpt11 AS VARCHAR(100)) + '"><div class="chart_a_v_main" tabindex="132">'
		SET @MIcontent2 = N'<input type="hidden" id="hdnReporttypeCode1702985492084_' + cast(@MIRpt11 AS VARCHAR(100)) + '" value="Chart"><div id="dvexport1702985492084_' + cast(@MIRpt11 AS VARCHAR(100)) + '" class="export_dashboard edit_d_m" tabindex="133"><div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div></div><h4 id="dvcharttilte1702985492084_' + cast(@MIRpt11 AS VARCHAR(100)) + 
			'"><span class="dashlet_title" title="Mathematics - School Avg % correct VS State Avg % correct  by Item">Mathematics - School Avg % correct VS State Avg % correct  by Item</span></h4><div class="dashboard_action"><span><a href="javascript:void(0);" id="dvredirect1702985492084_' + cast(@MIRpt11 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MIRpt11 AS VARCHAR(100)) + ''',''1702985492084'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="134"><i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1702985492084_' + cast(@MIRpt11 AS VARCHAR(100)) + 
			'" class="chart_thumb h-235 chart_grid" style="overflow: visible; text-align: left; height: 465px;"></div></div></div><div class="grid-stack-item table-small ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="0" data-gs-y="40" data-gs-width="12" data-gs-height="19" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MIRpt10 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1702986700493_' + cast(@MIRpt10 AS VARCHAR(100)) + '" value="Table"><input type="hidden" id="hdndashlatecharttype1702986700493_' + cast(@MIRpt10 AS VARCHAR(100)) + '" value="Table"><input type="hidden" id="hdndashlatechartlegned1702986700493_' + cast(@MIRpt10 AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1702986700493_' + cast(@MIRpt10 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1702986700493_' + cast(@MIRpt10 AS VARCHAR(100)) + 
			'" value="medium"><input type="hidden" id="hdnredirecturl1702986700493_' + cast(@MIRpt10 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1702986700493_' + cast(@MIRpt10 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1702986700493_' + cast(@MIRpt10 AS VARCHAR(100)) + '" value="' + cast(@MIRpt10 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1702986700493_' + cast(@MIRpt10 AS VARCHAR(100)) + '" value="true"><div class="chart_a_v_main" tabindex="135"><input type="hidden" id="hdnReporttypeCode1702986700493_' + cast(@MIRpt10 AS VARCHAR(100)) + '" value="Table"><div id="dvexport1702986700493_' + cast(@MIRpt10 AS VARCHAR(100)) + '" class="export_dashboard edit_d_m" tabindex="136">'
		SET @Micontent3 = N'</div><h4 id="dvcharttilte1702986700493_' + cast(@MIRpt10 AS VARCHAR(100)) + '"><span class="dashlet_title" title="Mathematics - Item Analysis">Mathematics - Item Analysis</span></h4><div class="dashboard_action"><span><span id="tbl_download1702986700493_' + cast(@MIRpt10 AS VARCHAR(100)) + '"><a href="javascript:void(0);" dynamicdashboard="true" onclick="DashletCSVGeneration(''1702986700493_' + cast(@MIRpt10 AS VARCHAR(100)) + ''');" data-toggle="tooltip" title="Download"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="11px" height="14px"><path d="M3,0 L8,0 L8,5 L11,5 L5.5,10 L0,5 L3,5 L03,0" fill="#888"></path><rect x="0" y="12" fill="#888" width="11" height="2"></rect></svg></a></span><a href="javascript:void(0);" id="dvredirect1702986700493_' + cast(@MIRpt10 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MIRpt10 AS VARCHAR(100)) + 
			''',''1702986700493'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="137"><i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1702986700493_' + cast(@MIRpt10 AS VARCHAR(100)) + '" class="chart_thumb h-235 chart_grid show k-grid k-widget k-grid-display-block k-reorderable" data-role="grid" style="height: 525px;"></div></div></div><div class="grid-stack-item ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="0" data-gs-y="0" data-gs-width="4" data-gs-height="15" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MIRpt1 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1703245260791_' + cast(@MIRpt1 AS VARCHAR(100)) + '" value="Chart"><input type="hidden" id="hdndashlatecharttype1703245260791_' + 
			cast(@MIRpt1 AS VARCHAR(100)) + '" value="2dstack"><input type="hidden" id="hdndashlatechartlegned1703245260791_' + cast(@MIRpt1 AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1703245260791_' + cast(@MIRpt1 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1703245260791_' + cast(@MIRpt1 AS VARCHAR(100)) + '" value="bright"><input type="hidden" id="hdnredirecturl1703245260791_' + cast(@MIRpt1 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1703245260791_' + cast(@MIRpt1 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1703245260791_' + cast(@MIRpt1 AS VARCHAR(100)) + '" value="' + cast(@MIRpt1 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1703245260791_' + cast(@MIRpt1 AS VARCHAR(100)) + '" value="true"><input type="hidden" id="hdnsubject1703245260791_' + cast(@MIRpt1 AS VARCHAR(100)) + '"><div class="chart_a_v_main" tabindex="138"><input type="hidden" id="hdnReporttypeCode1703245260791_' + cast(@MIRpt1 AS VARCHAR(100)) + 
			'" value="Chart"><div id="dvexport1703245260791_' + cast(@MIRpt1 AS VARCHAR(100)) + '" class="export_dashboard edit_d_m" tabindex="139">'
		SET @MIcontent4 = N'<div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div></div><h4 id="dvcharttilte1703245260791_' + cast(@MIRpt1 AS VARCHAR(100)) + 
			'"><span class="dashlet_title" title="Mathematics - Average % by Item category ">Mathematics - Average % by Item category </span></h4><div class="dashboard_action"><span><a href="javascript:void(0);" id="dvredirect1703245260791_' + cast(@MIRpt1 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MIRpt1 AS VARCHAR(100)) + ''',''1703245260791'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="140"><i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1703245260791_' + cast(@MIRpt1 AS VARCHAR(100)) + 
			'" class="chart_thumb h-235 chart_grid" style="overflow: visible; text-align: left; height: 404.778px;"></div></div></div><div class="grid-stack-item ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="4" data-gs-y="0" data-gs-width="4" data-gs-height="15" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MIRpt2 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1703246028135_' + cast(@MIRpt2 AS VARCHAR(100)) + '" value="Chart"><input type="hidden" id="hdndashlatecharttype1703246028135_' + cast(@MIRpt2 AS VARCHAR(100)) + '" value="2dcolumn"><input type="hidden" id="hdndashlatechartlegned1703246028135_' + cast(@MIRpt2 AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1703246028135_' + cast(@MIRpt2 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1703246028135_' + cast(@MIRpt2 AS VARCHAR(100)) + 
			'" value="bright"><input type="hidden" id="hdnredirecturl1703246028135_' + cast(@MIRpt2 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1703246028135_' + cast(@MIRpt2 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1703246028135_' + cast(@MIRpt2 AS VARCHAR(100)) + '" value="' + cast(@MIRpt2 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1703246028135_' + cast(@MIRpt2 AS VARCHAR(100)) + '" value="true"><input type="hidden" id="hdnsubject1703246028135_' + cast(@MIRpt2 AS VARCHAR(100)) + '"><div class="chart_a_v_main" tabindex="141"><input type="hidden" id="hdnReporttypeCode1703246028135_' + cast(@MIRpt2 AS VARCHAR(100)) + '" value="Chart"><div id="dvexport1703246028135_' + cast(@MIRpt2 AS VARCHAR(100)) + '" class="export_dashboard edit_d_m" tabindex="142">'
		SET @MIcontent5 = N'<div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div></div><h4 id="dvcharttilte1703246028135_' + cast(@MIRpt2 AS VARCHAR(100)) + 
			'"><span class="dashlet_title" title="Mathematics - Average % Correct by Item category">Mathematics - Average % Correct by Item category</span></h4><div class="dashboard_action"><span><a href="javascript:void(0);" id="dvredirect1703246028135_' + cast(@MIRpt2 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MIRpt2 AS VARCHAR(100)) + ''',''1703246028135'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="143"><i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1703246028135_' + cast(@MIRpt2 AS VARCHAR(100)) + 
			'" class="chart_thumb h-235 chart_grid" style="overflow: visible; text-align: left; height: 404.778px;"></div></div></div><div class="grid-stack-item ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="8" data-gs-y="0" data-gs-width="4" data-gs-height="15" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MIRpt3 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1703246235659_' + cast(@MIRpt3 AS VARCHAR(100)) + '" value="Chart"><input type="hidden" id="hdndashlatecharttype1703246235659_' + cast(@MIRpt3 AS VARCHAR(100)) + '" value="2dcolumn"><input type="hidden" id="hdndashlatechartlegned1703246235659_' + cast(@MIRpt3 AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1703246235659_' + cast(@MIRpt3 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1703246235659_' + cast(@MIRpt3 AS VARCHAR(100)) + 
			'" value="bright"><input type="hidden" id="hdnredirecturl1703246235659_' + cast(@MIRpt3 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1703246235659_' + cast(@MIRpt3 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1703246235659_' + cast(@MIRpt3 AS VARCHAR(100)) + '" value="' + cast(@MIRpt3 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1703246235659_' + cast(@MIRpt3 AS VARCHAR(100)) + '" value="true"><input type="hidden" id="hdnsubject1703246235659_' + cast(@MIRpt3 AS VARCHAR(100)) + '"><div class="chart_a_v_main" tabindex="144"><input type="hidden" id="hdnReporttypeCode1703246235659_' + cast(@MIRpt3 AS VARCHAR(100)) + '" value="Chart"><div id="dvexport1703246235659_' + cast(@MIRpt3 AS VARCHAR(100)) + '" class="export_dashboard edit_d_m" tabindex="145">'
		SET @Micontent6 = N'<div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div></div><h4 id="dvcharttilte1703246235659_' + cast(@MIRpt3 AS VARCHAR(100)) + 
			'"><span class="dashlet_title" title="Mathematics - Average % Incorrect by Item category ">Mathematics - Average % Incorrect by Item category </span></h4><div class="dashboard_action"><span><a href="javascript:void(0);" id="dvredirect1703246235659_' + cast(@MIRpt3 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MIRpt3 AS VARCHAR(100)) + ''',''1703246235659'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="146"><i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1703246235659_' + cast(@MIRpt3 AS VARCHAR(100)) + 
			'" class="chart_thumb h-235 chart_grid" style="overflow: visible; text-align: left; height: 404.778px;"></div></div></div><div class="grid-stack-item ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="0" data-gs-y="15" data-gs-width="4" data-gs-height="12" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MIRpt4 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1703248358128_' + cast(@MIRpt4 AS VARCHAR(100)) + '" value="Chart"><input type="hidden" id="hdndashlatecharttype1703248358128_' + cast(@MIRpt4 AS VARCHAR(100)) + '" value="2dstack"><input type="hidden" id="hdndashlatechartlegned1703248358128_' + cast(@MIRpt4 AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1703248358128_' + cast(@MIRpt4 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1703248358128_' + cast(@MIRpt4 AS VARCHAR(100)) + 
			'" value="bright"><input type="hidden" id="hdnredirecturl1703248358128_' + cast(@MIRpt4 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1703248358128_' + cast(@MIRpt4 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1703248358128_' + cast(@MIRpt4 AS VARCHAR(100)) + '" value="' + cast(@MIRpt4 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1703248358128_' + cast(@MIRpt4 AS VARCHAR(100)) + '" value="true"><input type="hidden" id="hdnsubject1703248358128_' + cast(@MIRpt4 AS VARCHAR(100)) + '"><div class="chart_a_v_main" tabindex="147"><input type="hidden" id="hdnReporttypeCode1703248358128_' + cast(@MIRpt4 AS VARCHAR(100)) + '" value="Chart"><div id="dvexport1703248358128_' + cast(@MIRpt4 AS VARCHAR(100)) + '" class="export_dashboard edit_d_m" tabindex="148">'
		SET @Micontent7 = N'<div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div></div><h4 id="dvcharttilte1703248358128_' + cast(@MIRpt4 AS VARCHAR(100)) + '"><span class="dashlet_title" title="Mathematics - Average % by Item type">Mathematics - Average % by Item type</span></h4><div class="dashboard_action"><span><a href="javascript:void(0);" id="dvredirect1703248358128_' + 
			cast(@MIRpt4 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MIRpt4 AS VARCHAR(100)) + ''',''1703248358128'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="149"><i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1703248358128_' + cast(@MIRpt4 AS VARCHAR(100)) + '" class="chart_thumb h-235 chart_grid" style="overflow: visible; text-align: left; height: 314.778px;"></div></div></div><div class="grid-stack-item ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="4" data-gs-y="15" data-gs-width="4" data-gs-height="12" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MIRpt5 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1703248487470_' + cast(@MIRpt5 AS VARCHAR(100)) + 
			'" value="Chart"><input type="hidden" id="hdndashlatecharttype1703248487470_' + cast(@MIRpt5 AS VARCHAR(100)) + '" value="2dstack"><input type="hidden" id="hdndashlatechartlegned1703248487470_' + cast(@MIRpt5 AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1703248487470_' + cast(@MIRpt5 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1703248487470_' + cast(@MIRpt5 AS VARCHAR(100)) + '" value="bright"><input type="hidden" id="hdnredirecturl1703248487470_' + cast(@MIRpt5 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1703248487470_' + cast(@MIRpt5 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1703248487470_' + cast(@MIRpt5 AS VARCHAR(100)) + '" value="' + cast(@MIRpt5 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1703248487470_' + cast(@MIRpt5 AS VARCHAR(100)) + '" value="true"><input type="hidden" id="hdnsubject1703248487470_' + cast(@MIRpt5 AS VARCHAR(100)) + 
			'"><div class="chart_a_v_main" tabindex="150"><input type="hidden" id="hdnReporttypeCode1703248487470_' + cast(@MIRpt5 AS VARCHAR(100)) + '" value="Chart"><div id="dvexport1703248487470_' + cast(@MIRpt5 AS VARCHAR(100)) + '" class="export_dashboard edit_d_m" tabindex="151">'
		SET @Micontent8 = N'<div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div></div><h4 id="dvcharttilte1703248487470_' + cast(@MIRpt5 AS VARCHAR(100)) + 
			'"><span class="dashlet_title" title="Mathematics - Average % correct by Item type">Mathematics - Average % correct by Item type</span></h4><div class="dashboard_action"><span><a href="javascript:void(0);" id="dvredirect1703248487470_' + cast(@MIRpt5 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MIRpt5 AS VARCHAR(100)) + ''',''1703248487470'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="152"><i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1703248487470_' + cast(@MIRpt5 AS VARCHAR(100)) + 
			'" class="chart_thumb h-235 chart_grid" style="overflow: visible; text-align: left; height: 314.778px;"></div></div></div><div class="grid-stack-item ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="8" data-gs-y="15" data-gs-width="4" data-gs-height="12" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MIRpt6 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1703248576901_' + cast(@MIRpt6 AS VARCHAR(100)) + '" value="Chart"><input type="hidden" id="hdndashlatecharttype1703248576901_' + cast(@MIRpt6 AS VARCHAR(100)) + '" value="2dstack"><input type="hidden" id="hdndashlatechartlegned1703248576901_' + cast(@MIRpt6 AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1703248576901_' + cast(@MIRpt6 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1703248576901_' + cast(@MIRpt6 AS VARCHAR(100)) + 
			'" value="bright"><input type="hidden" id="hdnredirecturl1703248576901_' + cast(@MIRpt6 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1703248576901_' + cast(@MIRpt6 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1703248576901_' + cast(@MIRpt6 AS VARCHAR(100)) + '" value="' + cast(@MIRpt6 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1703248576901_' + cast(@MIRpt6 AS VARCHAR(100)) + '" value="true"><input type="hidden" id="hdnsubject1703248576901_' + cast(@MIRpt6 AS VARCHAR(100)) + '"><div class="chart_a_v_main" tabindex="153"><input type="hidden" id="hdnReporttypeCode1703248576901_' + cast(@MIRpt6 AS VARCHAR(100)) + '" value="Chart"><div id="dvexport1703248576901_' + cast(@MIRpt6 AS VARCHAR(100)) + '" class="export_dashboard edit_d_m" tabindex="154">'
		SET @Micontent9 = N'<div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div></div><h4 id="dvcharttilte1703248576901_' + cast(@MIRpt6 AS VARCHAR(100)) + 
			'"><span class="dashlet_title" title="Mathematics - Average % Incorrect by Item type">Mathematics - Average % Incorrect by Item type</span></h4><div class="dashboard_action"><span><a href="javascript:void(0);" id="dvredirect1703248576901_' + cast(@MIRpt6 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MIRpt6 AS VARCHAR(100)) + ''',''1703248576901'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="155"><i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1703248576901_' + cast(@MIRpt6 AS VARCHAR(100)) + 
			'" class="chart_thumb h-235 chart_grid" style="overflow: visible; text-align: left; height: 314.778px;"></div></div></div><div class="grid-stack-item ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="0" data-gs-y="27" data-gs-width="4" data-gs-height="13" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MIRpt7 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1703248700954_' + cast(@MIRpt7 AS VARCHAR(100)) + '" value="Chart"><input type="hidden" id="hdndashlatecharttype1703248700954_' + cast(@MIRpt7 AS VARCHAR(100)) + '" value="2dstack"><input type="hidden" id="hdndashlatechartlegned1703248700954_' + cast(@MIRpt7 AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1703248700954_' + cast(@MIRpt7 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1703248700954_' + cast(@MIRpt7 AS VARCHAR(100)) + 
			'" value="bright"><input type="hidden" id="hdnredirecturl1703248700954_' + cast(@MIRpt7 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1703248700954_' + cast(@MIRpt7 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1703248700954_' + cast(@MIRpt7 AS VARCHAR(100)) + '" value="' + cast(@MIRpt7 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1703248700954_' + cast(@MIRpt7 AS VARCHAR(100)) + '" value="true"><input type="hidden" id="hdnsubject1703248700954_' + cast(@MIRpt7 AS VARCHAR(100)) + '"><div class="chart_a_v_main" tabindex="156"><input type="hidden" id="hdnReporttypeCode1703248700954_' + cast(@MIRpt7 AS VARCHAR(100)) + '" value="Chart"><div id="dvexport1703248700954_' + cast(@MIRpt7 AS VARCHAR(100)) + '" class="export_dashboard edit_d_m" tabindex="157">'
		SET @Micontent10 = N'<div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div></div><h4 id="dvcharttilte1703248700954_' + cast(@MIRpt7 AS VARCHAR(100)) + 
			'"><span class="dashlet_title" title="Mathematics - Average % by Item type and Category">Mathematics - Average % by Item type and Category</span></h4><div class="dashboard_action"><span><a href="javascript:void(0);" id="dvredirect1703248700954_' + cast(@MIRpt7 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MIRpt7 AS VARCHAR(100)) + ''',''1703248700954'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="158"><i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1703248700954_' + cast(@MIRpt7 AS VARCHAR(100)) + 
			'" class="chart_thumb h-235 chart_grid" style="overflow: visible; text-align: left; height: 344.778px;"></div></div></div><div class="grid-stack-item ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="4" data-gs-y="27" data-gs-width="4" data-gs-height="13" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MIRpt8 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1703248861924_' + cast(@MIRpt8 AS VARCHAR(100)) + '" value="Chart"><input type="hidden" id="hdndashlatecharttype1703248861924_' + cast(@MIRpt8 AS VARCHAR(100)) + '" value="2dstack"><input type="hidden" id="hdndashlatechartlegned1703248861924_' + cast(@MIRpt8 AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1703248861924_' + cast(@MIRpt8 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1703248861924_' + cast(@MIRpt8 AS VARCHAR(100)) + 
			'" value="bright"><input type="hidden" id="hdnredirecturl1703248861924_' + cast(@MIRpt8 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1703248861924_' + cast(@MIRpt8 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1703248861924_' + cast(@MIRpt8 AS VARCHAR(100)) + '" value="' + cast(@MIRpt8 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1703248861924_' + cast(@MIRpt8 AS VARCHAR(100)) + '" value="true"><input type="hidden" id="hdnsubject1703248861924_' + cast(@MIRpt8 AS VARCHAR(100)) + '"><div class="chart_a_v_main" tabindex="159"><input type="hidden" id="hdnReporttypeCode1703248861924_' + cast(@MIRpt8 AS VARCHAR(100)) + '" value="Chart"><div id="dvexport1703248861924_' + cast(@MIRpt8 AS VARCHAR(100)) + '" class="export_dashboard edit_d_m" tabindex="160">'
		SET @Micontent11 = N'<div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div></div><h4 id="dvcharttilte1703248861924_' + cast(@MIRpt8 AS VARCHAR(100)) + 
			'"><span class="dashlet_title" title="Mathematics -  Average % correct by Item type and Category">Mathematics -  Average % correct by Item type and Category</span></h4><div class="dashboard_action"><span><a href="javascript:void(0);" id="dvredirect1703248861924_' + cast(@MIRpt8 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MIRpt8 AS VARCHAR(100)) + ''',''1703248861924'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="161"><i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1703248861924_' + cast(@MIRpt8 AS VARCHAR(100)) + 
			'" class="chart_thumb h-235 chart_grid" style="overflow: visible; text-align: left; height: 344.778px;"></div></div></div><div class="grid-stack-item ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="8" data-gs-y="27" data-gs-width="4" data-gs-height="13" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MIRpt9 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1703248935010_' + cast(@MIRpt9 AS VARCHAR(100)) + '" value="Chart"><input type="hidden" id="hdndashlatecharttype1703248935010_' + cast(@MIRpt9 AS VARCHAR(100)) + '" value="2dstack"><input type="hidden" id="hdndashlatechartlegned1703248935010_' + cast(@MIRpt9 AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1703248935010_' + cast(@MIRpt9 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1703248935010_' + cast(@MIRpt9 AS VARCHAR(100)) + 
			'" value="bright"><input type="hidden" id="hdnredirecturl1703248935010_' + cast(@MIRpt9 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1703248935010_' + cast(@MIRpt9 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1703248935010_' + cast(@MIRpt9 AS VARCHAR(100)) + '" value="' + cast(@MIRpt9 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1703248935010_' + cast(@MIRpt9 AS VARCHAR(100)) + '" value="true"><input type="hidden" id="hdnsubject1703248935010_' + cast(@MIRpt9 AS VARCHAR(100)) + '"><div class="chart_a_v_main" tabindex="162"><input type="hidden" id="hdnReporttypeCode1703248935010_' + cast(@MIRpt9 AS VARCHAR(100)) + '" value="Chart"><div id="dvexport1703248935010_' + cast(@MIRpt9 AS VARCHAR(100)) + '" class="export_dashboard edit_d_m" tabindex="163">'
		SET @Micontent12 = N'<div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div></div><h4 id="dvcharttilte1703248935010_' + cast(@MIRpt9 AS VARCHAR(100)) + 
			'"><span class="dashlet_title" title="Mathematics - Average % Incorrect by Item type and Category">Mathematics - Average % Incorrect by Item type and Category</span></h4><div class="dashboard_action"><span><a href="javascript:void(0);" id="dvredirect1703248935010_' + cast(@MIRpt9 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MIRpt9 AS VARCHAR(100)) + ''',''1703248935010'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="164"><i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1703248935010_' + cast(@MIRpt9 AS VARCHAR(100)) + '" class="chart_thumb h-235 chart_grid" style="overflow: visible; text-align: left; height: 344.778px;"></div></div></div></div></div></div></div></div>'

		IF NOT EXISTS (
				SELECT 1
				FROM Dashboard
				WHERE DashboardCode = 'MCAS Item Analysis - Math'
					AND TenantId = @TenantId
					AND DashboardName = 'MCAS Item Analysis - Math'
				)
		BEGIN
			INSERT INTO Dashboard (
				DashboardName
				,DashboardContent
				,IsDraft
				,DefaultDashboardContent
				,IsDynamic
				,DashboardCode
				,IsAnalyticQuestion
				,TenantId
				,StatusId
				,CreatedBy
				,CreatedDate
				,ModifiedBy
				,ModifiedDate
				,DisplayFilters
				,IsHavingDashboardGroups
				,IsDisplayInDashboardGroup
				)
			VALUES (
				'MCAS Item Analysis - Math'
				,@MIcontent1 + @MIcontent2 + @Micontent3 + @MIcontent4 + @MIcontent5 + @Micontent6 + @Micontent7 + @Micontent8 + @Micontent9 + @Micontent10 + @Micontent11 + @Micontent12
				,0
				,NULL
				,NULL
				,'MCAS Item Analysis - Math'
				,NULL
				,@TenantId
				,1
				,'DDAUser@DDA'
				,GETDATE()
				,'DDAUser@DDA'
				,Getdate()
				,0
				,1
				,1
				)

			INSERT INTO RoleDashboard (
				DashboardId
				,RoleId
				,TenantId
				,StatusId
				,CreatedBy
				,CreatedDate
				)
			SELECT DashboardId
				,RoleId
				,a.TenantId
				,a.StatusId
				,a.CreatedBy
				,a.CreatedDate
			FROM (
				SELECT 'MCAS Item Analysis - Math' AS DashboardCode
					,'TNTADMIN' AS Code
					,@Tenantid AS Tenantid
					,1 AS StatusId
					,'DDAUser@DDA' AS CreatedBy
					,getdate() AS CreatedDate
				) a
			LEFT JOIN DashBoard db ON db.tenantid = a.tenantid
				AND db.DashboardCode = a.DashboardCode
			LEFT JOIN IDM.DDARole dr ON dr.tenantid = a.tenantid
				AND dr.Code = a.Code
			WHERE NOT EXISTS (
					SELECT 1
					FROM Roledashboard Ro
					WHERE ro.roleid = dr.roleid
						AND ro.DashboardId = db.DashboardId
						AND ro.tenantid = a.tenantid
					)
		END

		/*****************ELA Dashboard Script *****************/
		DECLARE @MIEcontent1 NVARCHAR(max)
			,@MIEcontent2 NVARCHAR(max)
			,@MIEcontent3 NVARCHAR(max)
			,@MIEcontent4 NVARCHAR(max)
			,@MIEcontent5 NVARCHAR(max)
			,@MIEcontent6 NVARCHAR(max)
			,@MIEcontent7 NVARCHAR(max)
			,@MIEcontent8 NVARCHAR(max)
		DECLARE @MIERpt1 INT
			,@MIERpt2 INT
			,@MIERpt3 INT
			,@MIERpt4 INT
			,@MIERpt5 INT
			,@MIERpt6 INT
			,@MIERpt7 INT
			,@MIERpt8 INT
			,@MIERpt9 INT
			,@MIERpt10 INT
			,@MIERpt11 INT
			,@MIEDashboardId INT

		SELECT @MIERpt1 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_12'
			AND TenantId = @TenantId
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SELECT @MIERpt2 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_13'
			AND TenantId = @TenantId
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SELECT @MIERpt3 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_14'
			AND TenantId = @TenantId
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SELECT @MIERpt4 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_15'
			AND TenantId = @TenantId
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SELECT @MIERpt5 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_16'
			AND TenantId = @TenantId
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SELECT @MIERpt6 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_17'
			AND TenantId = @TenantId
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SELECT @MIERpt7 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_18'
			AND TenantId = @TenantId
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SELECT @MIERpt8 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_19'
			AND TenantId = @TenantId
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SELECT @MIERpt9 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_20'
			AND TenantId = @TenantId
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SELECT @MIERpt10 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_21'
			AND TenantId = @TenantId
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SELECT @MIERpt11 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_22'
			AND TenantId = @TenantId
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SET @MIEcontent1 = '<div class="row-flex"><div class="col-md-12-flex"><div class="drop_main"><div class="drop_child grid-container"><div class="grid-stack grid-stack-4 grid-stack-instance-4905 grid-stack-instance-3654 grid-stack-instance-6128 grid-stack-instance-2229 grid-stack-instance-5773 grid-stack-instance-1138 grid-stack-instance-9180 grid-stack-instance-4368" data-gs-current-height="69" style="height: 2060px;"><div class="grid-stack-item ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="8" data-gs-y="12" data-gs-width="4" data-gs-height="12" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MIERpt6 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1703000976893_' + cast(@MIERpt6 AS VARCHAR(100)) + '" value="Chart"><input type="hidden" id="hdndashlatecharttype1703000976893_' + cast(@MIERpt6 AS VARCHAR(100)) + '" value="2dstack"><input type="hidden" id="hdndashlatechartlegned1703000976893_' + cast(
				@MIERpt6 AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1703000976893_' + cast(@MIERpt6 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1703000976893_' + cast(@MIERpt6 AS VARCHAR(100)) + '" value="medium"><input type="hidden" id="hdnredirecturl1703000976893_' + cast(@MIERpt6 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1703000976893_' + cast(@MIERpt6 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1703000976893_' + cast(@MIERpt6 AS VARCHAR(100)) + '" value="' + cast(@MIERpt6 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1703000976893_' + cast(@MIERpt6 AS VARCHAR(100)) + '" value="true"><input type="hidden" id="hdnsubject1703000976893_' + cast(@MIERpt6 AS VARCHAR(100)) + '"><div class="chart_a_v_main" tabindex="33"><input type="hidden" id="hdnReporttypeCode1703000976893_' + cast(@MIERpt6 AS VARCHAR(100)) + '" value="Chart"><div id="dvexport1703000976893_' + cast(@MIERpt6 AS VARCHAR(100)) + 
			'" class="export_dashboard edit_d_m" tabindex="34"><div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div><div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div></div><h4 id="dvcharttilte1703000976893_' 
			+ cast(@MIERpt6 AS VARCHAR(100)) + '"><span class="dashlet_title" title="" data-bs-original-title="ELA -  Average % Incorrect by Item type ">ELA -  Average % Incorrect by Item type </span></h4><div class="dashboard_action"><span><a href="javascript:void(0);" id="dvredirect1703000976893_' + cast(@MIERpt6 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MIERpt6 AS VARCHAR(100)) + ''',''1703000976893'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="35"><i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1703000976893_' + cast(@MIERpt6 AS VARCHAR(100)) + 
			'" class="chart_thumb h-235 chart_grid" style="overflow: visible; text-align: left; height: 314.778px;"></div></div></div><div class="grid-stack-item ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="0" data-gs-y="12" data-gs-width="4" data-gs-height="12" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MIERpt4 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1703001071660_' + cast(@MIERpt4 AS VARCHAR(100)) + '" value="Chart"><input type="hidden" id="hdndashlatecharttype1703001071660_' + cast(@MIERpt4 AS VARCHAR(100)) + '" value="2dstack"><input type="hidden" id="hdndashlatechartlegned1703001071660_' + cast(@MIERpt4 AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1703001071660_' + cast(@MIERpt4 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1703001071660_' + cast(@MIERpt4 AS VARCHAR(100)) + 
			'" value="medium"><input type="hidden" id="hdnredirecturl1703001071660_' + cast(@MIERpt4 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1703001071660_' + cast(@MIERpt4 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1703001071660_' + cast(@MIERpt4 AS VARCHAR(100)) + '" value="' + cast(@MIERpt4 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1703001071660_' + cast(@MIERpt4 AS VARCHAR(100)) + '" value="true"><input type="hidden" id="hdnsubject1703001071660_' + cast(@MIERpt4 AS VARCHAR(100)) + '"><div class="chart_a_v_main" tabindex="36">'
		SET @MIEcontent2 = '<input type="hidden" id="hdnReporttypeCode1703001071660_' + cast(@MIERpt4 AS VARCHAR(100)) + '" value="Chart"><div id="dvexport1703001071660_' + cast(@MIERpt4 AS VARCHAR(100)) + 
			'" class="export_dashboard edit_d_m" tabindex="37"><div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div><div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div></div><h4 id="dvcharttilte1703001071660_' 
			+ cast(@MIERpt4 AS VARCHAR(100)) + '"><span class="dashlet_title" title="" data-bs-original-title="ELA - Average % by Item type">ELA - Average % by Item type</span></h4><div class="dashboard_action"><span><a href="javascript:void(0);" id="dvredirect1703001071660_' + cast(@MIERpt4 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MIERpt4 AS VARCHAR(100)) + ''',''1703001071660'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="38"><i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1703001071660_' + cast(@MIERpt4 AS VARCHAR(100)) + 
			'" class="chart_thumb h-235 chart_grid" style="overflow: visible; text-align: left; height: 314.778px;"></div></div></div><div class="grid-stack-item ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="4" data-gs-y="12" data-gs-width="4" data-gs-height="12" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MIERpt5 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1703001122261_' + cast(@MIERpt5 AS VARCHAR(100)) + '" value="Chart"><input type="hidden" id="hdndashlatecharttype1703001122261_' + cast(@MIERpt5 AS VARCHAR(100)) + '" value="2dstack"><input type="hidden" id="hdndashlatechartlegned1703001122261_' + cast(@MIERpt5 AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1703001122261_' + cast(@MIERpt5 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1703001122261_' + cast(@MIERpt5 AS VARCHAR(100)) + 
			'" value="medium"><input type="hidden" id="hdnredirecturl1703001122261_' + cast(@MIERpt5 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1703001122261_' + cast(@MIERpt5 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1703001122261_' + cast(@MIERpt5 AS VARCHAR(100)) + '" value="' + cast(@MIERpt5 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1703001122261_' + cast(@MIERpt5 AS VARCHAR(100)) + '" value="true"><input type="hidden" id="hdnsubject1703001122261_' + cast(@MIERpt5 AS VARCHAR(100)) + '"><div class="chart_a_v_main" tabindex="39"><input type="hidden" id="hdnReporttypeCode1703001122261_' + cast(@MIERpt5 AS VARCHAR(100)) + '" value="Chart"><div id="dvexport1703001122261_' + cast(@MIERpt5 AS VARCHAR(100)) + 
			'" class="export_dashboard edit_d_m" tabindex="40"><div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div><div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div></div><h4 id="dvcharttilte1703001122261_' 
			+ cast(@MIERpt5 AS VARCHAR(100)) + '"><span class="dashlet_title" title="" data-bs-original-title="ELA - Average % correct by Item type ">ELA - Average % correct by Item type </span></h4><div class="dashboard_action"><span><a href="javascript:void(0);" id="dvredirect1703001122261_' + cast(@MIERpt5 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MIERpt5 AS VARCHAR(100)) + ''',''1703001122261'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="41">'
		SET @MIEcontent3 = '<i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1703001122261_' + cast(@MIERpt5 AS VARCHAR(100)) + '" class="chart_thumb h-235 chart_grid" style="overflow: visible; text-align: left; height: 314.778px;"></div></div></div><div class="grid-stack-item table-small ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="0" data-gs-y="36" data-gs-width="12" data-gs-height="18" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MIERpt10 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1703001474680_' + cast(@MIERpt10 AS VARCHAR(100)) + '" value="Table"><input type="hidden" id="hdndashlatecharttype1703001474680_' + cast(@MIERpt10 AS VARCHAR(100)) + 
			'" value="Table"><input type="hidden" id="hdndashlatechartlegned1703001474680_' + cast(@MIERpt10 AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1703001474680_' + cast(@MIERpt10 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1703001474680_' + cast(@MIERpt10 AS VARCHAR(100)) + '" value="medium"><input type="hidden" id="hdnredirecturl1703001474680_' + cast(@MIERpt10 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1703001474680_' + cast(@MIERpt10 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1703001474680_' + cast(@MIERpt10 AS VARCHAR(100)) + '" value="' + cast(@MIERpt10 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1703001474680_' + cast(@MIERpt10 AS VARCHAR(100)) + '" value="true"><div class="chart_a_v_main" tabindex="51"><input type="hidden" id="hdnReporttypeCode1703001474680_' + cast(@MIERpt10 AS VARCHAR(100)) + '" value="Table"><div id="dvexport1703001474680_' + cast(@MIERpt10 AS VARCHAR(100)) + 
			'" class="export_dashboard edit_d_m" tabindex="52"></div><h4 id="dvcharttilte1703001474680_' + cast(@MIERpt10 AS VARCHAR(100)) + '"><span class="dashlet_title" title="" data-bs-original-title="ELA -  Item Analysis">ELA -  Item Analysis</span></h4><div class="dashboard_action"><span><span id="tbl_download1703001474680_' + cast(@MIERpt10 AS VARCHAR(100)) + '"><a href="javascript:void(0);" dynamicdashboard="true" onclick="DashletCSVGeneration(''1703001474680_' + cast(@MIERpt10 AS VARCHAR(100)) + ''');" data-toggle="tooltip" title="Download"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="11px" height="14px"><path d="M3,0 L8,0 L8,5 L11,5 L5.5,10 L0,5 L3,5 L03,0" fill="#888"></path><rect x="0" y="12" fill="#888" width="11" height="2"></rect></svg></a></span><a href="javascript:void(0);" id="dvredirect1703001474680_' + cast(@MIERpt10 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MIERpt10 AS VARCHAR(100)) + 
			''',''1703001474680'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="53"><i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1703001474680_' + cast(@MIERpt10 AS VARCHAR(100)) + '" class="chart_thumb h-235 chart_grid show k-grid k-widget k-grid-display-block k-reorderable" data-role="grid" style="height: 495px;"></div></div></div><div class="grid-stack-item ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="0" data-gs-y="54" data-gs-width="12" data-gs-height="15" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MIERpt11 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1703001769210_' + cast(@MIERpt11 AS VARCHAR(100)) + 
			'" value="Chart"><input type="hidden" id="hdndashlatecharttype1703001769210_' + cast(@MIERpt11 AS VARCHAR(100)) + '" value="combination"><input type="hidden" id="hdndashlatechartlegned1703001769210_' + cast(@MIERpt11 AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1703001769210_' + cast(@MIERpt11 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1703001769210_' + cast(@MIERpt11 AS VARCHAR(100)) + '" value="medium"><input type="hidden" id="hdnredirecturl1703001769210_' + cast(@MIERpt11 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1703001769210_' + cast(@MIERpt11 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1703001769210_' + cast(@MIERpt11 AS VARCHAR(100)) + '" value="' + cast(@MIERpt11 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1703001769210_' + cast(@MIERpt11 AS VARCHAR(100)) + '" value="true"><input type="hidden" id="hdnsubject1703001769210_' + cast(@MIERpt11 AS VARCHAR(100)) + 
			'"><div class="chart_a_v_main" tabindex="54"><input type="hidden" id="hdnReporttypeCode1703001769210_' + cast(@MIERpt11 AS VARCHAR(100)) + '" value="Chart"><div id="dvexport1703001769210_' + cast(@MIERpt11 AS VARCHAR(100)) + '" class="export_dashboard edit_d_m" tabindex="55">'
		SET @MIEcontent4 = 
			'<div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div><div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div></div><h4 id="dvcharttilte1703001769210_' 
			+ cast(@MIERpt11 AS VARCHAR(100)) + '"><span class="dashlet_title" title="" data-bs-original-title="ELA - School Avg % correct VS State Avg % correct ">ELA - School Avg % correct VS State Avg % correct </span></h4><div class="dashboard_action"><span><a href="javascript:void(0);" id="dvredirect1703001769210_' + cast(@MIERpt11 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MIERpt11 AS VARCHAR(100)) + ''',''1703001769210'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="56"><i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1703001769210_' + cast(@MIERpt11 AS VARCHAR(100)) + 
			'" class="chart_thumb h-235 chart_grid" style="overflow: visible; text-align: left; height: 404.778px;"></div></div></div><div class="grid-stack-item ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="0" data-gs-y="24" data-gs-width="4" data-gs-height="12" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MIERpt7 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1703230183061_' + cast(@MIERpt7 AS VARCHAR(100)) + '" value="Chart"><input type="hidden" id="hdndashlatecharttype1703230183061_' + cast(@MIERpt7 AS VARCHAR(100)) + '" value="2dstack"><input type="hidden" id="hdndashlatechartlegned1703230183061_' + cast(@MIERpt7 AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1703230183061_' + cast(@MIERpt7 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1703230183061_' + cast(@MIERpt7 AS VARCHAR(100)) + 
			'" value="medium"><input type="hidden" id="hdnredirecturl1703230183061_' + cast(@MIERpt7 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1703230183061_' + cast(@MIERpt7 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1703230183061_' + cast(@MIERpt7 AS VARCHAR(100)) + '" value="' + cast(@MIERpt7 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1703230183061_' + cast(@MIERpt7 AS VARCHAR(100)) + '" value="true"><input type="hidden" id="hdnsubject1703230183061_' + cast(@MIERpt7 AS VARCHAR(100)) + '"><div class="chart_a_v_main" tabindex="69"><input type="hidden" id="hdnReporttypeCode1703230183061_' + cast(@MIERpt7 AS VARCHAR(100)) + '" value="Chart"><div id="dvexport1703230183061_' + cast(@MIERpt7 AS VARCHAR(100)) + 
			'" class="export_dashboard edit_d_m" tabindex="70"><div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div></div><h4 id="dvcharttilte1703230183061_' + cast(@MIERpt7 AS VARCHAR(100)) + 
			'"><span class="dashlet_title" title="ELA - Average % by Item type and Category">ELA - Average % by Item type and Category</span></h4><div class="dashboard_action"><span><a href="javascript:void(0);" id="dvredirect1703230183061_' + cast(@MIERpt7 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MIERpt7 AS VARCHAR(100)) + ''',''1703230183061'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="71">'
		SET @MIEcontent5 = '<i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1703230183061_' + cast(@MIERpt7 AS VARCHAR(100)) + '" class="chart_thumb h-235 chart_grid" style="overflow: visible; text-align: left; height: 314.778px;"></div></div></div><div class="grid-stack-item ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="4" data-gs-y="24" data-gs-width="4" data-gs-height="12" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MIERpt8 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1703230286504_' + cast(@MIERpt8 AS VARCHAR(100)) + '" value="Chart"><input type="hidden" id="hdndashlatecharttype1703230286504_' + cast(@MIERpt8 AS VARCHAR(100)) + '" value="2dstack"><input type="hidden" id="hdndashlatechartlegned1703230286504_' + cast(
				@MIERpt8 AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1703230286504_' + cast(@MIERpt8 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1703230286504_' + cast(@MIERpt8 AS VARCHAR(100)) + '" value="medium"><input type="hidden" id="hdnredirecturl1703230286504_' + cast(@MIERpt8 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1703230286504_' + cast(@MIERpt8 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1703230286504_' + cast(@MIERpt8 AS VARCHAR(100)) + '" value="' + cast(@MIERpt8 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1703230286504_' + cast(@MIERpt8 AS VARCHAR(100)) + '" value="true"><input type="hidden" id="hdnsubject1703230286504_' + cast(@MIERpt8 AS VARCHAR(100)) + '"><div class="chart_a_v_main" tabindex="75"><input type="hidden" id="hdnReporttypeCode1703230286504_' + cast(@MIERpt8 AS VARCHAR(100)) + '" value="Chart"><div id="dvexport1703230286504_' + cast(@MIERpt8 AS VARCHAR(100)) + 
			'" class="export_dashboard edit_d_m" tabindex="76"><div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div></div><h4 id="dvcharttilte1703230286504_' + cast(@MIERpt8 AS VARCHAR(100)) + 
			'"><span class="dashlet_title" title="ELA - Average % correct by Item type and Category">ELA - Average % correct by Item type and Category</span></h4><div class="dashboard_action"><span><a href="javascript:void(0);" id="dvredirect1703230286504_' + cast(@MIERpt8 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MIERpt8 AS VARCHAR(100)) + ''',''1703230286504'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="77"><i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1703230286504_' + cast(@MIERpt8 AS VARCHAR(100)) + 
			'" class="chart_thumb h-235 chart_grid" style="overflow: visible; text-align: left; height: 314.778px;"></div></div></div><div class="grid-stack-item ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="8" data-gs-y="24" data-gs-width="4" data-gs-height="12" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MIERpt9 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1703230411171_' + cast(@MIERpt9 AS VARCHAR(100)) + '" value="Chart"><input type="hidden" id="hdndashlatecharttype1703230411171_' + cast(@MIERpt9 AS VARCHAR(100)) + '" value="2dstack"><input type="hidden" id="hdndashlatechartlegned1703230411171_' + cast(@MIERpt9 AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1703230411171_' + cast(@MIERpt9 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1703230411171_' + cast(@MIERpt9 AS VARCHAR(100)) + 
			'" value="medium"><input type="hidden" id="hdnredirecturl1703230411171_' + cast(@MIERpt9 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1703230411171_' + cast(@MIERpt9 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1703230411171_' + cast(@MIERpt9 AS VARCHAR(100)) + '" value="' + cast(@MIERpt9 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1703230411171_' + cast(@MIERpt9 AS VARCHAR(100)) + '" value="true"><input type="hidden" id="hdnsubject1703230411171_' + cast(@MIERpt9 AS VARCHAR(100)) + '"><div class="chart_a_v_main" tabindex="81">'
		SET @MIEcontent6 = '<input type="hidden" id="hdnReporttypeCode1703230411171_' + cast(@MIERpt9 AS VARCHAR(100)) + '" value="Chart"><div id="dvexport1703230411171_' + cast(@MIERpt9 AS VARCHAR(100)) + '" class="export_dashboard edit_d_m" tabindex="82"><div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div></div><h4 id="dvcharttilte1703230411171_' + cast(@MIERpt9 AS VARCHAR(100)) + 
			'"><span class="dashlet_title" title="ELA - Average % Incorrect by Item type and Category ">ELA - Average % Incorrect by Item type and Category </span></h4><div class="dashboard_action"><span><a href="javascript:void(0);" id="dvredirect1703230411171_' + cast(@MIERpt9 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MIERpt9 AS VARCHAR(100)) + ''',''1703230411171'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="83"><i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1703230411171_' + cast(@MIERpt9 AS VARCHAR(100)) + 
			'" class="chart_thumb h-235 chart_grid" style="overflow: visible; text-align: left; height: 314.778px;"></div></div></div><div class="grid-stack-item ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="0" data-gs-y="0" data-gs-width="4" data-gs-height="12" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MIERpt1 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1703231048001_' + cast(@MIERpt1 AS VARCHAR(100)) + '" value="Chart"><input type="hidden" id="hdndashlatecharttype1703231048001_' + cast(@MIERpt1 AS VARCHAR(100)) + '" value="2dstack"><input type="hidden" id="hdndashlatechartlegned1703231048001_' + cast(@MIERpt1 AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1703231048001_' + cast(@MIERpt1 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1703231048001_' + cast(@MIERpt1 AS VARCHAR(100)) + 
			'" value="medium"><input type="hidden" id="hdnredirecturl1703231048001_' + cast(@MIERpt1 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1703231048001_' + cast(@MIERpt1 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1703231048001_' + cast(@MIERpt1 AS VARCHAR(100)) + '" value="' + cast(@MIERpt1 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1703231048001_' + cast(@MIERpt1 AS VARCHAR(100)) + '" value="true"><input type="hidden" id="hdnsubject1703231048001_' + cast(@MIERpt1 AS VARCHAR(100)) + '"><div class="chart_a_v_main" tabindex="87"><input type="hidden" id="hdnReporttypeCode1703231048001_' + cast(@MIERpt1 AS VARCHAR(100)) + '" value="Chart"><div id="dvexport1703231048001_' + cast(@MIERpt1 AS VARCHAR(100)) + 
			'" class="export_dashboard edit_d_m" tabindex="88"><div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div></div><h4 id="dvcharttilte1703231048001_' + cast(@MIERpt1 AS VARCHAR(100)) + 
			'"><span class="dashlet_title" title="ELA - Average % by Item Category ">ELA - Average % by Item Category </span></h4><div class="dashboard_action"><span><a href="javascript:void(0);" id="dvredirect1703231048001_' + cast(@MIERpt1 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MIERpt1 AS VARCHAR(100)) + ''',''1703231048001'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="89"><i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1703231048001_' + cast(@MIERpt1 AS VARCHAR(100)) + '" class="chart_thumb h-235 chart_grid" style="overflow: visible; text-align: left; height: 314.778px;"></div></div></div>'
		SET @MIEcontent7 = '<div class="grid-stack-item ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="4" data-gs-y="0" data-gs-width="4" data-gs-height="12" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MIERpt2 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1703231574808_' + cast(@MIERpt2 AS VARCHAR(100)) + '" value="Chart"><input type="hidden" id="hdndashlatecharttype1703231574808_' + cast(@MIERpt2 AS VARCHAR(100)) + '" value="2dstack"><input type="hidden" id="hdndashlatechartlegned1703231574808_' + cast(@MIERpt2 AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1703231574808_' + cast(@MIERpt2 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1703231574808_' + cast(@MIERpt2 AS VARCHAR(100)) + '" value="medium"><input type="hidden" id="hdnredirecturl1703231574808_' + cast(@MIERpt2 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1703231574808_' + 
			cast(@MIERpt2 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1703231574808_' + cast(@MIERpt2 AS VARCHAR(100)) + '" value="' + cast(@MIERpt2 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1703231574808_' + cast(@MIERpt2 AS VARCHAR(100)) + '" value="true"><input type="hidden" id="hdnsubject1703231574808_' + cast(@MIERpt2 AS VARCHAR(100)) + '"><div class="chart_a_v_main" tabindex="99"><input type="hidden" id="hdnReporttypeCode1703231574808_' + cast(@MIERpt2 AS VARCHAR(100)) + '" value="Chart"><div id="dvexport1703231574808_' + cast(@MIERpt2 AS VARCHAR(100)) + 
			'" class="export_dashboard edit_d_m" tabindex="100"><div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div></div><h4 id="dvcharttilte1703231574808_' + cast(@MIERpt2 AS VARCHAR(100)) + 
			'"><span class="dashlet_title" title="ELA - Average % correct  by Item category">ELA - Average % correct  by Item category</span></h4><div class="dashboard_action"><span><a href="javascript:void(0);" id="dvredirect1703231574808_' + cast(@MIERpt2 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MIERpt2 AS VARCHAR(100)) + ''',''1703231574808'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="101"><i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1703231574808_' + cast(@MIERpt2 AS VARCHAR(100)) + 
			'" class="chart_thumb h-235 chart_grid" style="overflow: visible; text-align: left; height: 314.778px;"></div></div></div><div class="grid-stack-item ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="8" data-gs-y="0" data-gs-width="4" data-gs-height="12" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MIERpt3 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1703231691722_' + cast(@MIERpt3 AS VARCHAR(100)) + '" value="Chart"><input type="hidden" id="hdndashlatecharttype1703231691722_' + cast(@MIERpt3 AS VARCHAR(100)) + '" value="2dstack"><input type="hidden" id="hdndashlatechartlegned1703231691722_' + cast(@MIERpt3 AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1703231691722_' + cast(@MIERpt3 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1703231691722_' + cast(@MIERpt3 AS VARCHAR(100)) + 
			'" value="medium"><input type="hidden" id="hdnredirecturl1703231691722_' + cast(@MIERpt3 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1703231691722_' + cast(@MIERpt3 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1703231691722_' + cast(@MIERpt3 AS VARCHAR(100)) + '" value="' + cast(@MIERpt3 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1703231691722_' + cast(@MIERpt3 AS VARCHAR(100)) + '" value="true"><input type="hidden" id="hdnsubject1703231691722_' + cast(@MIERpt3 AS VARCHAR(100)) + '"><div class="chart_a_v_main" tabindex="105"><input type="hidden" id="hdnReporttypeCode1703231691722_' + cast(@MIERpt3 AS VARCHAR(100)) + '" value="Chart"><div id="dvexport1703231691722_' + cast(@MIERpt3 AS VARCHAR(100)) + 
			'" class="export_dashboard edit_d_m" tabindex="106"><div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#">'
		SET @MIEcontent8 = '<span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div></div><h4 id="dvcharttilte1703231691722_' + cast(@MIERpt3 AS VARCHAR(100)) + '"><span class="dashlet_title" title="ELA - Average % Incorrect by Item category">ELA - Average % Incorrect by Item category</span></h4><div class="dashboard_action"><span><a href="javascript:void(0);" id="dvredirect1703231691722_' + cast(@MIERpt3 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MIERpt3 AS VARCHAR(100)) + 
			''',''1703231691722'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="107"><i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1703231691722_' + cast(@MIERpt3 AS VARCHAR(100)) + '" class="chart_thumb h-235 chart_grid" style="overflow: visible; text-align: left; height: 314.778px;"></div></div></div></div></div></div></div></div>'

		IF NOT EXISTS (
				SELECT 1
				FROM Dashboard
				WHERE DashboardCode = 'MCAS Item Analysis - ELA'
					AND TenantId = @Tenantid
					AND DashboardName = 'MCAS Item Analysis - ELA'
				)
		BEGIN
			INSERT INTO Dashboard (
				DashboardName
				,DashboardContent
				,IsDraft
				,DefaultDashboardContent
				,IsDynamic
				,DashboardCode
				,IsAnalyticQuestion
				,TenantId
				,StatusId
				,CreatedBy
				,CreatedDate
				,ModifiedBy
				,ModifiedDate
				,DisplayFilters
				,IsHavingDashboardGroups
				,IsDisplayInDashboardGroup
				)
			VALUES (
				'MCAS Item Analysis - ELA'
				,@MIEcontent1 + @MIEcontent2 + @MIEcontent3 + @MIEcontent4 + @MIEcontent5 + @MIEcontent6 + @MIEcontent7 + @MIEcontent8
				,0
				,NULL
				,NULL
				,'MCAS Item Analysis - ELA'
				,NULL
				,@TenantId
				,1
				,'DDAUser@DDA'
				,GETDATE()
				,'DDAUser@DDA'
				,Getdate()
				,0
				,1
				,1
				)

			INSERT INTO RoleDashboard (
				DashboardId
				,RoleId
				,TenantId
				,StatusId
				,CreatedBy
				,CreatedDate
				)
			SELECT DashboardId
				,RoleId
				,a.TenantId
				,a.StatusId
				,a.CreatedBy
				,a.CreatedDate
			FROM (
				SELECT 'MCAS Item Analysis - ELA' AS DashboardCode
					,'TNTADMIN' AS Code
					,@Tenantid AS Tenantid
					,1 AS StatusId
					,'DDAUser@DDA' AS CreatedBy
					,getdate() AS CreatedDate
				) a
			LEFT JOIN DashBoard db ON db.tenantid = a.tenantid
				AND db.DashboardCode = a.DashboardCode
			LEFT JOIN IDM.DDARole dr ON dr.tenantid = a.tenantid
				AND dr.Code = a.Code
			WHERE NOT EXISTS (
					SELECT 1
					FROM Roledashboard Ro
					WHERE ro.roleid = dr.roleid
						AND ro.DashboardId = db.DashboardId
						AND ro.tenantid = a.tenantid
					)
		END

		/*****************Science Dashboard Script *****************/
		DECLARE @MIScontent1 NVARCHAR(max)
			,@MIScontent2 NVARCHAR(max)
			,@MIScontent3 NVARCHAR(max)
			,@MIScontent4 NVARCHAR(max)
			,@MIScontent5 NVARCHAR(max)
			,@MIScontent6 NVARCHAR(max)
			,@MIScontent7 NVARCHAR(max)
		DECLARE @MISRpt1 INT
			,@MISRpt2 INT
			,@MISRpt3 INT
			,@MISRpt4 INT
			,@MISRpt5 INT
			,@MISRpt6 INT
			,@MISRpt7 INT
			,@MISRpt8 INT
			,@MISRpt9 INT
			,@MISRpt10 INT
			,@MISRpt11 INT
			,@MISDashboardId INT

		SELECT @MISRpt1 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_23'
			AND TenantId = @Tenantid
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SELECT @MISRpt2 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_24'
			AND TenantId = @Tenantid
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SELECT @MISRpt3 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_25'
			AND TenantId = @Tenantid
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SELECT @MISRpt4 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_26'
			AND TenantId = @Tenantid
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SELECT @MISRpt5 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_27'
			AND TenantId = @Tenantid
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SELECT @MISRpt6 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_28'
			AND TenantId = @Tenantid
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SELECT @MISRpt7 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_29'
			AND TenantId = @Tenantid
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SELECT @MISRpt8 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_30'
			AND TenantId = @Tenantid
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SELECT @MISRpt9 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_31'
			AND TenantId = @Tenantid
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SELECT @MISRpt10 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_32'
			AND TenantId = @Tenantid
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SELECT @MISRpt11 = ReportDetailsId
		FROM ReportDetails
		WHERE ReportParams = 'MI_33'
			AND TenantId = @Tenantid
			AND StatusId = 1
		ORDER BY ReportDetailsId ASC

		SET @MIScontent1 = '<div class="row-flex"><div class="col-md-12-flex"><div class="drop_main"><div class="drop_child grid-container"><div class="grid-stack grid-stack-4 grid-stack-instance-2691 grid-stack-instance-222 grid-stack-instance-6860 grid-stack-instance-6128 grid-stack-instance-6560 grid-stack-instance-241 grid-stack-instance-2822 grid-stack-instance-7506 grid-stack-instance-1056" data-gs-current-height="69" style="height: 2060px;"><div class="grid-stack-item ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="8" data-gs-y="12" data-gs-width="4" data-gs-height="12" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MISRpt6 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1703011249943_' + cast(@MISRpt6 AS VARCHAR(100)) + '" value="Chart"><input type="hidden" id="hdndashlatecharttype1703011249943_' + cast(@MISRpt6 AS VARCHAR(100)) + 
			'" value="2dstack"><input type="hidden" id="hdndashlatechartlegned1703011249943_' + cast(@MISRpt6 AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1703011249943_' + cast(@MISRpt6 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1703011249943_' + cast(@MISRpt6 AS VARCHAR(100)) + '" value="medium"><input type="hidden" id="hdnredirecturl1703011249943_' + cast(@MISRpt6 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1703011249943_' + cast(@MISRpt6 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1703011249943_' + cast(@MISRpt6 AS VARCHAR(100)) + '" value="' + cast(@MISRpt6 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1703011249943_' + cast(@MISRpt6 AS VARCHAR(100)) + '" value="true"><input type="hidden" id="hdnsubject1703011249943_' + cast(@MISRpt6 AS VARCHAR(100)) + '"><div class="chart_a_v_main" tabindex="198"><input type="hidden" id="hdnReporttypeCode1703011249943_' + cast(@MISRpt6 AS VARCHAR(100)) + 
			'" value="Chart"><div id="dvexport1703011249943_' + cast(@MISRpt6 AS VARCHAR(100)) + '" class="export_dashboard edit_d_m" tabindex="199"><div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div></div><h4 id="dvcharttilte1703011249943_' + cast(@MISRpt6 AS VARCHAR(100)) + 
			'"><span class="dashlet_title" title="Science- Average % Incorrect by Item type ">Science- Average % Incorrect by Item type </span></h4><div class="dashboard_action"><span><a href="javascript:void(0);" id="dvredirect1703011249943_' + cast(@MISRpt6 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MISRpt6 AS VARCHAR(100)) + ''',''1703011249943'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="200"><i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1703011249943_' + cast(@MISRpt6 AS VARCHAR(100)) + 
			'" class="chart_thumb h-235 chart_grid" style="overflow: visible; text-align: left; height: 315.667px;"></div></div></div><div class="grid-stack-item ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="0" data-gs-y="12" data-gs-width="4" data-gs-height="12" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MISRpt4 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1703011366229_' + cast(@MISRpt4 AS VARCHAR(100)) + '" value="Chart"><input type="hidden" id="hdndashlatecharttype1703011366229_' + cast(@MISRpt4 AS VARCHAR(100)) + '" value="2dstack"><input type="hidden" id="hdndashlatechartlegned1703011366229_' + cast(@MISRpt4 AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1703011366229_' + cast(@MISRpt4 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1703011366229_' + cast(@MISRpt4 AS VARCHAR(100)) + 
			'" value="medium"><input type="hidden" id="hdnredirecturl1703011366229_' + cast(@MISRpt4 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1703011366229_' + cast(@MISRpt4 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1703011366229_' + cast(@MISRpt4 AS VARCHAR(100)) + '" value="' + cast(@MISRpt4 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1703011366229_' + cast(@MISRpt4 AS VARCHAR(100)) + '" value="true"><input type="hidden" id="hdnsubject1703011366229_' + cast(@MISRpt4 AS VARCHAR(100)) + '"><div class="chart_a_v_main" tabindex="201">'
		SET @MIScontent2 = '<input type="hidden" id="hdnReporttypeCode1703011366229_' + cast(@MISRpt4 AS VARCHAR(100)) + '" value="Chart"><div id="dvexport1703011366229_' + cast(@MISRpt4 AS VARCHAR(100)) + '" class="export_dashboard edit_d_m" tabindex="202"><div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div></div><h4 id="dvcharttilte1703011366229_' + cast(@MISRpt4 AS VARCHAR(100)) + 
			'"><span class="dashlet_title" title="Science- Average % by Item type ">Science- Average % by Item type </span></h4><div class="dashboard_action"><span><a href="javascript:void(0);" id="dvredirect1703011366229_' + cast(@MISRpt4 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MISRpt4 AS VARCHAR(100)) + ''',''1703011366229'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="203"><i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1703011366229_' + cast(@MISRpt4 AS VARCHAR(100)) + 
			'" class="chart_thumb h-235 chart_grid" style="overflow: visible; text-align: left; height: 315.667px;"></div></div></div><div class="grid-stack-item ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="4" data-gs-y="12" data-gs-width="4" data-gs-height="12" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MISRpt5 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1703011453093_' + cast(@MISRpt5 AS VARCHAR(100)) + '" value="Chart"><input type="hidden" id="hdndashlatecharttype1703011453093_' + cast(@MISRpt5 AS VARCHAR(100)) + '" value="2dstack"><input type="hidden" id="hdndashlatechartlegned1703011453093_' + cast(@MISRpt5 AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1703011453093_' + cast(@MISRpt5 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1703011453093_' + cast(@MISRpt5 AS VARCHAR(100)) + 
			'" value="medium"><input type="hidden" id="hdnredirecturl1703011453093_' + cast(@MISRpt5 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1703011453093_' + cast(@MISRpt5 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1703011453093_' + cast(@MISRpt5 AS VARCHAR(100)) + '" value="' + cast(@MISRpt5 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1703011453093_' + cast(@MISRpt5 AS VARCHAR(100)) + '" value="true"><input type="hidden" id="hdnsubject1703011453093_' + cast(@MISRpt5 AS VARCHAR(100)) + '"><div class="chart_a_v_main" tabindex="204"><input type="hidden" id="hdnReporttypeCode1703011453093_' + cast(@MISRpt5 AS VARCHAR(100)) + '" value="Chart"><div id="dvexport1703011453093_' + cast(@MISRpt5 AS VARCHAR(100)) + 
			'" class="export_dashboard edit_d_m" tabindex="205"><div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div></div><h4 id="dvcharttilte1703011453093_' + cast(@MISRpt5 AS VARCHAR(100)) + 
			'"><span class="dashlet_title" title="Scence- Average % correct by Item type ">Scence- Average % correct by Item type </span></h4><div class="dashboard_action"><span><a href="javascript:void(0);" id="dvredirect1703011453093_' + cast(@MISRpt5 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MISRpt5 AS VARCHAR(100)) + ''',''1703011453093'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="206"><i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1703011453093_' + cast(@MISRpt5 AS VARCHAR(100)) + 
			'" class="chart_thumb h-235 chart_grid" style="overflow: visible; text-align: left; height: 315.667px;"></div></div></div><div class="grid-stack-item ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="0" data-gs-y="54" data-gs-width="12" data-gs-height="15" data-gs-auto-position="yes" style="">'
		SET @MIScontent3 = '<div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MISRpt11 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1703011951782_' + cast(@MISRpt11 AS VARCHAR(100)) + '" value="Chart"><input type="hidden" id="hdndashlatecharttype1703011951782_' + cast(@MISRpt11 AS VARCHAR(100)) + '" value="combination"><input type="hidden" id="hdndashlatechartlegned1703011951782_' + cast(@MISRpt11 AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1703011951782_' + cast(@MISRpt11 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1703011951782_' + cast(@MISRpt11 AS VARCHAR(100)) + '" value="medium"><input type="hidden" id="hdnredirecturl1703011951782_' + cast(@MISRpt11 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1703011951782_' + cast(@MISRpt11 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1703011951782_' + cast(@MISRpt11 AS VARCHAR(100)) + '" value="' + cast(@MISRpt11 AS VARCHAR(100)) + 
			'"><input type="hidden" id="hdnisdynamic1703011951782_' + cast(@MISRpt11 AS VARCHAR(100)) + '" value="true"><input type="hidden" id="hdnsubject1703011951782_' + cast(@MISRpt11 AS VARCHAR(100)) + '"><div class="chart_a_v_main" tabindex="207"><input type="hidden" id="hdnReporttypeCode1703011951782_' + cast(@MISRpt11 AS VARCHAR(100)) + '" value="Chart"><div id="dvexport1703011951782_' + cast(@MISRpt11 AS VARCHAR(100)) + 
			'" class="export_dashboard edit_d_m" tabindex="208"><div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div></div><h4 id="dvcharttilte1703011951782_' + cast(@MISRpt11 AS VARCHAR(100)) + 
			'"><span class="dashlet_title" title="Science- School Avg % correct VS State Avg % correct  by Item">Science- School Avg % correct VS State Avg % correct  by Item</span></h4><div class="dashboard_action"><span><a href="javascript:void(0);" id="dvredirect1703011951782_' + cast(@MISRpt11 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MISRpt11 AS VARCHAR(100)) + ''',''1703011951782'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="209"><i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1703011951782_' + cast(@MISRpt11 AS VARCHAR(100)) + 
			'" class="chart_thumb h-235 chart_grid" style="overflow: visible; text-align: left; height: 405px;"></div></div></div><div class="grid-stack-item table-small ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="0" data-gs-y="36" data-gs-width="12" data-gs-height="18" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MISRpt10 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1703050459635_' + cast(@MISRpt10 AS VARCHAR(100)) + '" value="Table"><input type="hidden" id="hdndashlatecharttype1703050459635_' + cast(@MISRpt10 AS VARCHAR(100)) + '" value="Table"><input type="hidden" id="hdndashlatechartlegned1703050459635_' + cast(@MISRpt10 AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1703050459635_' + cast(@MISRpt10 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1703050459635_' + cast(@MISRpt10 AS VARCHAR(100)) + 
			'" value="medium"><input type="hidden" id="hdnredirecturl1703050459635_' + cast(@MISRpt10 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1703050459635_' + cast(@MISRpt10 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1703050459635_' + cast(@MISRpt10 AS VARCHAR(100)) + '" value="' + cast(@MISRpt10 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1703050459635_' + cast(@MISRpt10 AS VARCHAR(100)) + '" value="true"><div class="chart_a_v_main" tabindex="210"><input type="hidden" id="hdnReporttypeCode1703050459635_' + cast(@MISRpt10 AS VARCHAR(100)) + '" value="Table"><div id="dvexport1703050459635_' + cast(@MISRpt10 AS VARCHAR(100)) + '" class="export_dashboard edit_d_m" tabindex="211"></div><h4 id="dvcharttilte1703050459635_' + cast(@MISRpt10 AS VARCHAR(100)) + '"><span class="dashlet_title" title="Science - Item Analysis">Science - Item Analysis</span></h4><div class="dashboard_action"><span><span id="tbl_download1703050459635_' + cast(@MISRpt10 AS VARCHAR(100)) + 
			'"><a href="javascript:void(0);" dynamicdashboard="true" onclick="DashletCSVGeneration(''1703050459635_' + cast(@MISRpt10 AS VARCHAR(100)) + ''');" data-toggle="tooltip" title="Download"><svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="11px" height="14px"><path d="M3,0 L8,0 L8,5 L11,5 L5.5,10 L0,5 L3,5 L03,0" fill="#888">'
		SET @MIScontent4 = '</path><rect x="0" y="12" fill="#888" width="11" height="2"></rect></svg></a></span><a href="javascript:void(0);" id="dvredirect1703050459635_' + cast(@MISRpt10 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MISRpt10 AS VARCHAR(100)) + ''',''1703050459635'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="212"><i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1703050459635_' + cast(@MISRpt10 AS VARCHAR(100)) + 
			'" class="chart_thumb h-235 chart_grid show k-grid k-widget k-grid-display-block k-reorderable" data-role="grid" style="height: 495px;"></div></div></div><div class="grid-stack-item ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="8" data-gs-y="0" data-gs-width="4" data-gs-height="12" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MISRpt3 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1703226919306_' + cast(@MISRpt3 AS VARCHAR(100)) + '" value="Chart"><input type="hidden" id="hdndashlatecharttype1703226919306_' + cast(@MISRpt3 AS VARCHAR(100)) + '" value="2dcolumn"><input type="hidden" id="hdndashlatechartlegned1703226919306_' + cast(@MISRpt3 AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1703226919306_' + cast(@MISRpt3 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1703226919306_' + cast(@MISRpt3 AS VARCHAR(100)) + 
			'" value="medium"><input type="hidden" id="hdnredirecturl1703226919306_' + cast(@MISRpt3 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1703226919306_' + cast(@MISRpt3 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1703226919306_' + cast(@MISRpt3 AS VARCHAR(100)) + '" value="' + cast(@MISRpt3 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1703226919306_' + cast(@MISRpt3 AS VARCHAR(100)) + '" value="true"><input type="hidden" id="hdnsubject1703226919306_' + cast(@MISRpt3 AS VARCHAR(100)) + '"><div class="chart_a_v_main" tabindex="213"><input type="hidden" id="hdnReporttypeCode1703226919306_' + cast(@MISRpt3 AS VARCHAR(100)) + '" value="Chart"><div id="dvexport1703226919306_' + cast(@MISRpt3 AS VARCHAR(100)) + 
			'" class="export_dashboard edit_d_m" tabindex="214"><div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div></div><h4 id="dvcharttilte1703226919306_' + cast(@MISRpt3 AS VARCHAR(100)) + 
			'"><span class="dashlet_title" title="Science- Average % Incorrect by Item Category ">Science- Average % Incorrect by Item Category </span></h4><div class="dashboard_action"><span><a href="javascript:void(0);" id="dvredirect1703226919306_' + cast(@MISRpt3 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MISRpt3 AS VARCHAR(100)) + ''',''1703226919306'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="215"><i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1703226919306_' + cast(@MISRpt3 AS VARCHAR(100)) + 
			'" class="chart_thumb h-235 chart_grid" style="overflow: visible; text-align: left; height: 315px;"></div></div></div><div class="grid-stack-item ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="4" data-gs-y="0" data-gs-width="4" data-gs-height="12" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MISRpt2 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1703228971258_' + cast(@MISRpt2 AS VARCHAR(100)) + '" value="Chart"><input type="hidden" id="hdndashlatecharttype1703228971258_' + cast(@MISRpt2 AS VARCHAR(100)) + '" value="2dcolumn"><input type="hidden" id="hdndashlatechartlegned1703228971258_' + cast(@MISRpt2 AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1703228971258_' + cast(@MISRpt2 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1703228971258_' + cast(@MISRpt2 AS VARCHAR(100)) + 
			'" value="medium"><input type="hidden" id="hdnredirecturl1703228971258_' + cast(@MISRpt2 AS VARCHAR(100)) + '">'
		SET @MIScontent5 = '<input type="hidden" id="hdnoptionflag1703228971258_' + cast(@MISRpt2 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1703228971258_' + cast(@MISRpt2 AS VARCHAR(100)) + '" value="' + cast(@MISRpt2 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1703228971258_' + cast(@MISRpt2 AS VARCHAR(100)) + '" value="true"><input type="hidden" id="hdnsubject1703228971258_' + cast(@MISRpt2 AS VARCHAR(100)) + '"><div class="chart_a_v_main" tabindex="216"><input type="hidden" id="hdnReporttypeCode1703228971258_' + cast(@MISRpt2 AS VARCHAR(100)) + '" value="Chart"><div id="dvexport1703228971258_' + cast(@MISRpt2 AS VARCHAR(100)) + 
			'" class="export_dashboard edit_d_m" tabindex="217"><div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div></div><h4 id="dvcharttilte1703228971258_' + cast(@MISRpt2 AS VARCHAR(100)) + 
			'"><span class="dashlet_title" title="Science- Average % Correct by Item category">Science- Average % Correct by Item category</span></h4><div class="dashboard_action"><span><a href="javascript:void(0);" id="dvredirect1703228971258_' + cast(@MISRpt2 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MISRpt2 AS VARCHAR(100)) + ''',''1703228971258'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="218"><i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1703228971258_' + cast(@MISRpt2 AS VARCHAR(100)) + 
			'" class="chart_thumb h-235 chart_grid" style="overflow: visible; text-align: left; height: 315px;"></div></div></div><div class="grid-stack-item ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="0" data-gs-y="24" data-gs-width="4" data-gs-height="12" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MISRpt7 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1703230245285_' + cast(@MISRpt7 AS VARCHAR(100)) + '" value="Chart"><input type="hidden" id="hdndashlatecharttype1703230245285_' + cast(@MISRpt7 AS VARCHAR(100)) + '" value="2dstack"><input type="hidden" id="hdndashlatechartlegned1703230245285_' + cast(@MISRpt7 AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1703230245285_' + cast(@MISRpt7 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1703230245285_' + cast(@MISRpt7 AS VARCHAR(100)) + 
			'" value="medium"><input type="hidden" id="hdnredirecturl1703230245285_' + cast(@MISRpt7 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1703230245285_' + cast(@MISRpt7 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1703230245285_' + cast(@MISRpt7 AS VARCHAR(100)) + '" value="' + cast(@MISRpt7 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1703230245285_' + cast(@MISRpt7 AS VARCHAR(100)) + '" value="true"><input type="hidden" id="hdnsubject1703230245285_' + cast(@MISRpt7 AS VARCHAR(100)) + '"><div class="chart_a_v_main" tabindex="219"><input type="hidden" id="hdnReporttypeCode1703230245285_' + cast(@MISRpt7 AS VARCHAR(100)) + '" value="Chart"><div id="dvexport1703230245285_' + cast(@MISRpt7 AS VARCHAR(100)) + 
			'" class="export_dashboard edit_d_m" tabindex="220"><div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div></div><h4 id="dvcharttilte1703230245285_' + cast(@MISRpt7 AS VARCHAR(100)) + 
			'"><span class="dashlet_title" title="Science- Average % by Item type and Category">Science- Average % by Item type and Category</span></h4><div class="dashboard_action"><span><a href="javascript:void(0);" id="dvredirect1703230245285_' + cast(@MISRpt7 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MISRpt7 AS VARCHAR(100)) + ''',''1703230245285'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="221">'
		SET @MIScontent6 = '<i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1703230245285_' + cast(@MISRpt7 AS VARCHAR(100)) + '" class="chart_thumb h-235 chart_grid" style="overflow: visible; text-align: left; height: 315px;"></div></div></div><div class="grid-stack-item ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="0" data-gs-y="0" data-gs-width="4" data-gs-height="12" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MISRpt1 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1703230801480_' + cast(@MISRpt1 AS VARCHAR(100)) + '" value="Chart"><input type="hidden" id="hdndashlatecharttype1703230801480_' + cast(@MISRpt1 AS VARCHAR(100)) + '" value="2dstack"><input type="hidden" id="hdndashlatechartlegned1703230801480_' + cast(@MISRpt1 
				AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1703230801480_' + cast(@MISRpt1 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1703230801480_' + cast(@MISRpt1 AS VARCHAR(100)) + '" value="medium"><input type="hidden" id="hdnredirecturl1703230801480_' + cast(@MISRpt1 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1703230801480_' + cast(@MISRpt1 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1703230801480_' + cast(@MISRpt1 AS VARCHAR(100)) + '" value="' + cast(@MISRpt1 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1703230801480_' + cast(@MISRpt1 AS VARCHAR(100)) + '" value="true"><input type="hidden" id="hdnsubject1703230801480_' + cast(@MISRpt1 AS VARCHAR(100)) + '"><div class="chart_a_v_main" tabindex="222"><input type="hidden" id="hdnReporttypeCode1703230801480_' + cast(@MISRpt1 AS VARCHAR(100)) + '" value="Chart"><div id="dvexport1703230801480_' + cast(@MISRpt1 AS VARCHAR(100)) + 
			'" class="export_dashboard edit_d_m" tabindex="223"><div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div></div><h4 id="dvcharttilte1703230801480_' + cast(@MISRpt1 AS VARCHAR(100)) + 
			'"><span class="dashlet_title" title="Science-Average % by Item category">Science-Average % by Item category</span></h4><div class="dashboard_action"><span><a href="javascript:void(0);" id="dvredirect1703230801480_' + cast(@MISRpt1 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MISRpt1 AS VARCHAR(100)) + ''',''1703230801480'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="224"><i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1703230801480_' + cast(@MISRpt1 AS VARCHAR(100)) + 
			'" class="chart_thumb h-235 chart_grid" style="overflow: visible; text-align: left; height: 315px;"></div></div></div><div class="grid-stack-item ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="4" data-gs-y="24" data-gs-width="4" data-gs-height="12" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MISRpt8 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1703248985059_' + cast(@MISRpt8 AS VARCHAR(100)) + '" value="Chart"><input type="hidden" id="hdndashlatecharttype1703248985059_' + cast(@MISRpt8 AS VARCHAR(100)) + '" value="2dstack"><input type="hidden" id="hdndashlatechartlegned1703248985059_' + cast(@MISRpt8 AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1703248985059_' + cast(@MISRpt8 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1703248985059_' + cast(@MISRpt8 AS VARCHAR(100)) + 
			'" value="bright"><input type="hidden" id="hdnredirecturl1703248985059_' + cast(@MISRpt8 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1703248985059_' + cast(@MISRpt8 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1703248985059_' + cast(@MISRpt8 AS VARCHAR(100)) + '" value="' + cast(@MISRpt8 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1703248985059_' + cast(@MISRpt8 AS VARCHAR(100)) + '" value="true"><input type="hidden" id="hdnsubject1703248985059_' + cast(@MISRpt8 AS VARCHAR(100)) + '"><div class="chart_a_v_main" tabindex="225"><input type="hidden" id="hdnReporttypeCode1703248985059_' + cast(@MISRpt8 AS VARCHAR(100)) + '" value="Chart"><div id="dvexport1703248985059_' + cast(@MISRpt8 AS VARCHAR(100)) + '" class="export_dashboard edit_d_m" tabindex="226">'
		SET @MIScontent7 = '<div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div></div><h4 id="dvcharttilte1703248985059_' + cast(@MISRpt8 AS VARCHAR(100)) + 
			'"><span class="dashlet_title" title="Science- Average % correct by Item type and Category ">Science- Average % correct by Item type and Category </span></h4><div class="dashboard_action"><span><a href="javascript:void(0);" id="dvredirect1703248985059_' + cast(@MISRpt8 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MISRpt8 AS VARCHAR(100)) + ''',''1703248985059'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="227"><i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1703248985059_' + cast(@MISRpt8 AS VARCHAR(100)) + 
			'" class="chart_thumb h-235 chart_grid" style="overflow: visible; text-align: left; height: 315px;"></div></div></div><div class="grid-stack-item ui-draggable ui-resizable ui-resizable-autohide" data-gs-x="8" data-gs-y="24" data-gs-width="4" data-gs-height="12" data-gs-auto-position="yes" style=""><div class="grid-stack-item-content ui-draggable-handle" data-id="' + cast(@MISRpt9 AS VARCHAR(100)) + '"></div><input type="hidden" id="hdndashlatetype1703249077026_' + cast(@MISRpt9 AS VARCHAR(100)) + '" value="Chart"><input type="hidden" id="hdndashlatecharttype1703249077026_' + cast(@MISRpt9 AS VARCHAR(100)) + '" value="2dstack"><input type="hidden" id="hdndashlatechartlegned1703249077026_' + cast(@MISRpt9 AS VARCHAR(100)) + '" value="false"><input type="hidden" id="hdndashlatechartlegnedpostion1703249077026_' + cast(@MISRpt9 AS VARCHAR(100)) + '" value="bottom"><input type="hidden" id="hdndashlatechartcolor1703249077026_' + cast(@MISRpt9 AS VARCHAR(100)) + 
			'" value="bright"><input type="hidden" id="hdnredirecturl1703249077026_' + cast(@MISRpt9 AS VARCHAR(100)) + '"><input type="hidden" id="hdnoptionflag1703249077026_' + cast(@MISRpt9 AS VARCHAR(100)) + '"><input type="hidden" id="hdnQustionCode1703249077026_' + cast(@MISRpt9 AS VARCHAR(100)) + '" value="' + cast(@MISRpt9 AS VARCHAR(100)) + '"><input type="hidden" id="hdnisdynamic1703249077026_' + cast(@MISRpt9 AS VARCHAR(100)) + '" value="true"><input type="hidden" id="hdnsubject1703249077026_' + cast(@MISRpt9 AS VARCHAR(100)) + '"><div class="chart_a_v_main" tabindex="228"><input type="hidden" id="hdnReporttypeCode1703249077026_' + cast(@MISRpt9 AS VARCHAR(100)) + '" value="Chart"><div id="dvexport1703249077026_' + cast(@MISRpt9 AS VARCHAR(100)) + 
			'" class="export_dashboard edit_d_m" tabindex="229"><div class="amcharts-export-menu amcharts-export-menu-top-right amExportButton"><ul><li class="export-main"><a href="#"><span>menu.label.undefined</span></a><ul><li><a href="#"><span>Download as ...</span></a><ul><li><a href="#"><span>PNG</span></a></li><li><a href="#"><span>JPG</span></a></li><li><a href="#"><span>SVG</span></a></li><li><a href="#"><span>PDF</span></a></li></ul></li><li><a href="#"><span>Save as ...</span></a><ul><li><a href="#"><span>CSV</span></a></li><li><a href="#"><span>XLSX</span></a></li><li><a href="#"><span>JSON</span></a></li></ul></li><li><a href="#"><span>Annotate ...</span></a></li><li><a href="#"><span>Print</span></a></li></ul></li></ul></div></div><h4 id="dvcharttilte1703249077026_' + cast(@MISRpt9 AS VARCHAR(100)) + 
			'"><span class="dashlet_title" title="Science- Average % Incorrect by Item type and Category ">Science- Average % Incorrect by Item type and Category </span></h4><div class="dashboard_action"><span><a href="javascript:void(0);" id="dvredirect1703249077026_' + cast(@MISRpt9 AS VARCHAR(100)) + '" onclick="Redirectfullviewpage(''' + cast(@MISRpt9 AS VARCHAR(100)) + ''',''1703249077026'')" title="Full View" data-toggle="tooltip" aria-label="Full View" tabindex="230"><i class="fa fa-external-link" aria-hidden="true"></i></a></span><a href="javascript:void(0)" class="remove-widget" title="Delete" data-toggle="tooltip" data-placement="bottom"><i class="fa fa-close"></i></a></div><div id="dashboardchart1703249077026_' + cast(@MISRpt9 AS VARCHAR(100)) + '" class="chart_thumb h-235 chart_grid" style="overflow: visible; text-align: left; height: 315px;"></div></div></div></div></div></div></div></div>'

		IF NOT EXISTS (
				SELECT 1
				FROM Dashboard
				WHERE DashboardCode = 'MCAS Item Analysis - Science'
					AND TenantId = @Tenantid
					AND DashboardName = 'MCAS Item Analysis - Science'
				)
		BEGIN
			INSERT INTO Dashboard (
				DashboardName
				,DashboardContent
				,IsDraft
				,DefaultDashboardContent
				,IsDynamic
				,DashboardCode
				,IsAnalyticQuestion
				,TenantId
				,StatusId
				,CreatedBy
				,CreatedDate
				,ModifiedBy
				,ModifiedDate
				,DisplayFilters
				,IsHavingDashboardGroups
				,IsDisplayInDashboardGroup
				)
			VALUES (
				'MCAS Item Analysis - Science'
				,@MIScontent1 + @MIScontent2 + @MIScontent3 + @MIScontent4 + @MIScontent5 + @MIScontent6 + @MIScontent7
				,0
				,NULL
				,NULL
				,'MCAS Item Analysis - Science'
				,NULL
				,@TenantId
				,1
				,'DDAUser@DDA'
				,GETDATE()
				,'DDAUser@DDA'
				,Getdate()
				,0
				,1
				,1
				)

			INSERT INTO RoleDashboard (
				DashboardId
				,RoleId
				,TenantId
				,StatusId
				,CreatedBy
				,CreatedDate
				)
			SELECT DashboardId
				,RoleId
				,a.TenantId
				,a.StatusId
				,a.CreatedBy
				,a.CreatedDate
			FROM (
				SELECT 'MCAS Item Analysis - Science' AS DashboardCode
					,'TNTADMIN' AS Code
					,@Tenantid AS Tenantid
					,1 AS StatusId
					,'DDAUser@DDA' AS CreatedBy
					,getdate() AS CreatedDate
				) a
			LEFT JOIN DashBoard db ON db.tenantid = a.tenantid
				AND db.DashboardCode = a.DashboardCode
			LEFT JOIN IDM.DDARole dr ON dr.tenantid = a.tenantid
				AND dr.Code = a.Code
			WHERE NOT EXISTS (
					SELECT 1
					FROM Roledashboard Ro
					WHERE ro.roleid = dr.roleid
						AND ro.DashboardId = db.DashboardId
						AND ro.tenantid = a.tenantid
					)
		END

		/***********************MCAS Item Analysis Dashboard Group Script******************/
		IF NOT EXISTS (
				SELECT 1
				FROM DashboardGroupDef
				WHERE GroupName = 'MCAS Item Analysis'
					AND TenantId = @Tenantid
				)
		BEGIN
			DECLARE @DashboardIDMath INT
				,@DashboardIDELA INT
				,@DashboardIDScience INT
				,@DashboardGroupID INT

			INSERT INTO DashboardGroupDef
			SELECT *
			FROM (
				SELECT 'MCAS Item Analysis' AS GroupName
					,NULL AS GroupDesc
					,'MCASItemAnalysis' AS GroupCode
					,3 AS SortOrder
					,@Tenantid AS TenantId
					,1 AS StatusId
					,'DDAUser@DDA' AS CreatedBy
					,Getdate() AS CreatedDate
					,NULL AS ModifiedBy
					,NULL AS ModifiedDate
				) a
			WHERE NOT EXISTS (
					SELECT *
					FROM DashboardGroupDef b
					WHERE a.GroupName = b.GroupName
						AND a.GroupCode = b.GroupCode
						AND a.TenantId = b.TenantId
					)

			SET @DashboardGroupID = (
					SELECT DashboardGroupDefID
					FROM DashboardGroupDef
					WHERE Tenantid = @Tenantid
						AND GroupName IN ('MCAS Item Analysis')
					)
			SET @DashboardIDMath = (
					SELECT DashboardId
					FROM Dashboard
					WHERE tenantid = @Tenantid
						AND DashboardName IN ('MCAS Item Analysis - Math')
					)
			SET @DashboardIDELA = (
					SELECT DashboardId
					FROM Dashboard
					WHERE tenantid = @Tenantid
						AND DashboardName IN ('MCAS Item Analysis - ELA')
					)
			SET @DashboardIDScience = (
					SELECT DashboardId
					FROM Dashboard
					WHERE tenantid = @Tenantid
						AND DashboardName IN ('MCAS Item Analysis - Science')
					)

			INSERT INTO DashboardGroups
			SELECT *
			FROM (
				SELECT @DashboardIDMath AS DashboardId
					,@DashboardGroupID AS DashboardGroupDefID
					,1 AS SortOrder
					,@Tenantid AS TenantId
					,1 AS StatusId
					,'DDAUser@DDA' AS CreatedBy
					,Getdate() AS CreatedDate
					,NULL AS ModifiedBy
					,NULL AS ModifiedDate
				
				UNION
				
				SELECT @DashboardIDELA AS DashboardId
					,@DashboardGroupID AS DashboardGroupDefID
					,2 AS SortOrder
					,@Tenantid AS TenantId
					,1 AS StatusId
					,'DDAUser@DDA' AS CreatedBy
					,Getdate() AS CreatedDate
					,NULL AS ModifiedBy
					,NULL AS ModifiedDate
				
				UNION
				
				SELECT @DashboardIDScience AS DashboardId
					,@DashboardGroupID AS DashboardGroupDefID
					,3 AS SortOrder
					,@Tenantid AS TenantId
					,1 AS StatusId
					,'DDAUser@DDA' AS CreatedBy
					,Getdate() AS CreatedDate
					,NULL AS ModifiedBy
					,NULL AS ModifiedDate
				) a
			WHERE NOT EXISTS (
					SELECT 1
					FROM DashboardGroups b
					WHERE a.DashboardId = b.DashboardId
						AND a.DashboardGroupDefID = b.DashboardGroupDefID
						AND a.TenantId = b.TenantId
					)
		END
	END TRY

	BEGIN CATCH
		-- Test whether the transaction is uncommittable.         
		IF XACT_STATE() = - 1
		BEGIN
			ROLLBACK TRAN;
		END;

		--Comment it if SP contains only SELECT statement               
		DECLARE @ErrorFromProc VARCHAR(500);
		DECLARE @ProcErrorMessage VARCHAR(1000);
		DECLARE @SeverityLevel INT;
		DECLARE @ErrorNumber INT = ERROR_NUMBER();

		SELECT @ErrorFromProc = '[dbo].[USP_MCASItemAnalysis_DashboardsCreation]'
			,@ProcErrorMessage = ERROR_MESSAGE()
			,@SeverityLevel = ERROR_SEVERITY();

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
			,GETDATE()
			,@Tenantid
			);

		RAISERROR (
				'Error Number-%d : Error Message-%s'
				,16
				,1
				,@ErrorNumber
				,@ProcErrorMessage
				)
	END CATCH;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[USP_MCASItemAnalysis_CompleteLoading] (@TenantId INT,@SchoolYear VARCHAR(200))
AS
BEGIN
	SET XACT_ABORT ON;
	SET NOCOUNT ON;

	BEGIN TRY
		------------------------------------------------------------
		-- Step 1: Create foundational tables needed for item analysis
		-- Tables:
		-- [dbo].[AggrptMCASItemAnalysis]
		-- [dbo].[AggrptMCASItemStudentResults]
		-- [dbo].[TenantCode_MCAS_ItemAnalysis_Math_ELA_Science]
		-- [dbo].[TenantCode_MCAS_Item_Links]
		------------------------------------------------------------
		EXEC dbo.USP_CreateMCASItemAnalysis_Tables @TenantId;

		------------------------------------------------------------
		-- Step 2. Create subject-specific and school-level MCAS analysis views :
		--[dbo].[ TenantCode_MCASItemStudentTeacherResults_Science_View]
		--[dbo].[ TenantCode_MCASItemStudentTeacherResults_Maths_View]
		--[dbo].[ TenantCode_MCASItemStudentTeacherResults_ELA_View]
		--[dbo].[ TenantCode_AggrptMCASItemAnalysis_School_View]
		------------------------------------------------------------
		EXEC dbo.USP_CreateMCASItemAnalysis_Views @TenantId;

		------------------------------------------------------------
		--Step 3. Create dataset views for dashboards and reporting :
		--[dbo].[TenantCodeMCASItemStudentTeacherResultsMathsDS]
		--[dbo].[TenantCodeMCASItemStudentTeacherResultsScienceDS]
		--[dbo].[TenantCodeMCASItemStudentTeacherResultsELADS]
		--[dbo].[TenantCodeAggrptMCASItemAnalysisDS]
		--[dbo].[TenantCode MCASItemAnalysisMathematicsDS]
		--[dbo].[TenantCode_MCAS_Item_SortOrder_Vw]
		------------------------------------------------------------
		EXEC dbo.USP_CreateMCASItemAnalysis_Dataset @TenantId;

		------------------------------------------------------------
		--Step 4. Load item-level metadata and links into the item link table
		-- (Populates tenant-specific table with MCAS item metadata and URLs)
		-- Load item metadata and values from MCAS template into main item table
		------------------------------------------------------------
		EXEC dbo.USP_MCAS_ItemAnalysis_Links_Math_ELA_Science_Loading @TenantId;

		------------------------------------------------------------
		--Step 5. Update the Reporting_Category_Number values based on subject and grade
		------------------------------------------------------------
		EXEC dbo.USP_MCASItemAnalysis_Reporting_CategoryUpdation @TenantId;

		------------------------------------------------------------
		--Step 6. Load cleaned and matched data into AggrptMCASItemAnalysis
		-- (Loop through SchoolYears and extract data for each year)
		------------------------------------------------------------
		EXEC dbo.USP_AggrptMCASItemAnalysis_DataLoading @TenantId
			,@SchoolYear;

		------------------------------------------------------------
		--Step 7. Load detailed student item results into AggrptMCASItemStudentResults
		--    (Loop through SchoolYears, unpivot items, and join to item metadata)
		------------------------------------------------------------
		EXEC dbo.USP_AggrptMCASItemStudentResults_DataLoading @TenantId
			,@SchoolYear;

		------------------------------------------------------------
		--Step 8. Update item type descriptions, percentages, and calculated fields
		--    (Adds readable item type labels, cleans percent fields, computes averages, etc.)
		------------------------------------------------------------
		EXEC dbo.USP_MCASItemAnalysis_ItemTypeDescriptionUpdation @TenantId
			,@SchoolYear;

		------------------------------------------------------------
		--Step 9. Create reports master data
		------------------------------------------------------------
		EXEC dbo.USP_MCASItemAnalysis_ReportsMasterData @TenantId;

		------------------------------------------------------------
		--Step 10. Create dashboards and dashboards Group (MCAS Item dashboards)
		------------------------------------------------------------
		EXEC dbo.USP_MCASItemAnalysis_DashboardsCreation @TenantId;
	END TRY

	BEGIN CATCH
		-- Test whether the transaction is uncommittable
		IF XACT_STATE() = - 1
		BEGIN
			ROLLBACK TRAN;
		END;

		-- Declare error handling variables
		DECLARE @ErrorFromProc VARCHAR(500);
		DECLARE @ProcErrorMessage VARCHAR(1000);
		DECLARE @SeverityLevel INT;
		DECLARE @ErrorNumber INT = ERROR_NUMBER();

		SELECT @ErrorFromProc = '[dbo].[USP_MCASItemAnalysis_CompleteLoading]'
			,@ProcErrorMessage = ERROR_MESSAGE()
			,@SeverityLevel = ERROR_SEVERITY();

		-- Insert error details into log table
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
			,GETDATE()
			,@TenantId
			);

		RAISERROR (
				'Error Number-%d : Error Message-%s'
				,16
				,1
				,@ErrorNumber
				,@ProcErrorMessage
				);
	END CATCH;
END;
GO

--2021 2022 2023 2024
select * from main.fps_mcas_2025
select * from idm.apperrorlog order by 1 desc
select * from errorlogforusp order by 1 desc

--EXEC dbo.USP_MCASItemAnalysis_CompleteLoading 28, '2024';
 