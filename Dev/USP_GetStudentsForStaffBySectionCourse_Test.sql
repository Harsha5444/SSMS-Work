--set statistics time on 
--exec USP_GetStudentsForStaffBySectionCourse @UserId=1,@TenantId=4,@SchoolYear='2025',@SchoolId='12',@sectionId=NULL,@courseId=NULL,@Grade='01',@StaffIds=NULL,@STARTRECORD='0',@RECORDS='50',@SORTBY='StudentName',@SORTTYPE='asc',@IsALLRecords=0,@IsFilterFirstTime=0,@ValueFilters=NULL,@ColorFilters=NULL,@SubGroupFilters=NULL,@CohortFilters=NULL,@isCohortGradeColumn=0,@CohortTitle=NULL,@FilterField=NULL,@IsExport=0,@MetrcGroupId=10


--exec USP_GetStudentsForStaffBySectionCourse_test @UserId=1,@TenantId=4,@SchoolYear='2025',@SchoolId='12',@sectionId=NULL,@courseId=NULL,@Grade='01',@StaffIds=NULL,@STARTRECORD='0',@RECORDS='50',@SORTBY='StudentName',@SORTTYPE='asc',@IsALLRecords=0,@IsFilterFirstTime=0,@ValueFilters=NULL,@ColorFilters=NULL,@SubGroupFilters=NULL,@CohortFilters=NULL,@isCohortGradeColumn=0,@CohortTitle=NULL,@FilterField=NULL,@IsExport=0,@MetrcGroupId=10
 

-- SQL Server Execution Times:
--   CPU time = 94 ms,  elapsed time = 103 ms.


-- SQL Server Execution Times:
--   CPU time = 438 ms,  elapsed time = 701 ms.


CREATE OR ALTER PROC [dbo].[USP_GetStudentsForStaffBySectionCourse_TEST] (
	@UserId BIGINT
	,@TenantId INT
	,@SchoolYear VARCHAR(100)
	,@SchoolId VARCHAR(max)
	,@sectionId VARCHAR(MAX) = NULL
	,@courseId VARCHAR(MAX) = NULL
	,@Grade VARCHAR(1000) = NULL
	,@StaffIds VARCHAR(MAX) = NULL
	,@STARTRECORD VARCHAR(MAX)
	,@RECORDS VARCHAR(MAX)
	,@SORTBY VARCHAR(150) = NULL
	,@SORTTYPE VARCHAR(150) = NULL
	,@IsALLRecords BIT
	,@IsFilterFirstTime BIT
	,@ValueFilters VARCHAR(MAX) = NULL
	,@ColorFilters VARCHAR(MAX) = NULL
	,@CohortFilters VARCHAR(MAX) = NULL
	,@isCohortGradeColumn BIT = 0
	,@CohortTitle VARCHAR(MAX) = NULL
	,@SubGroupFilters VARCHAR(MAX) = NULL
	,@FilterField VARCHAR(2000) = NULL
	,@UserGroups VARCHAR(max) = NULL
	,@IsExport BIT = 0
	,@MetrcGroupId INT = NULL
	)
AS
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		-- Session-based table name variables
		DECLARE @SessionID VARCHAR(50);
		DECLARE @DropSQL NVARCHAR(MAX);
		DECLARE @CreateSQL NVARCHAR(MAX);
		DECLARE @InsertSQL NVARCHAR(MAX);
		DECLARE @SelectSQL NVARCHAR(MAX);
		DECLARE @UpdateSQL NVARCHAR(MAX);
		DECLARE @FieldsSQL NVARCHAR(MAX);
		DECLARE @CleanupSQL NVARCHAR(MAX);

		SET @SessionID = CAST(@@SPID AS VARCHAR(10));

		-- Dynamic table names
		DECLARE @sumRef_Table VARCHAR(200);
		DECLARE @SummaryViewFieldsData_Table VARCHAR(200);
		DECLARE @tbl_Table VARCHAR(200);
		DECLARE @DynamicMetricsTbl_Table VARCHAR(200);
		DECLARE @SummaryViewFieldsDataTable_Table VARCHAR(200);
		DECLARE @StudentstblForsummaryView_Table VARCHAR(200);
		DECLARE @TUserGroups_Table VARCHAR(200);

		SET @sumRef_Table = 'sumRef_' + @SessionID;
		SET @SummaryViewFieldsData_Table = 'SummaryViewFieldsData_' + @SessionID;
		SET @tbl_Table = 'tbl_' + @SessionID;
		SET @DynamicMetricsTbl_Table = 'DynamicMetricsTbl_' + @SessionID;
		SET @SummaryViewFieldsDataTable_Table = 'SummaryViewFieldsDataTable_' + @SessionID;
		SET @StudentstblForsummaryView_Table = 'StudentstblForsummaryView_' + @SessionID;
		SET @TUserGroups_Table = 'TUserGroups_' + @SessionID;

		-- Drop dynamic tables if they exist
		SET @DropSQL = 'IF OBJECT_ID(''' + @sumRef_Table + ''', ''U'') IS NOT NULL DROP TABLE ' + @sumRef_Table;
		EXEC sp_executesql @DropSQL;

		SET @DropSQL = 'IF OBJECT_ID(''' + @SummaryViewFieldsData_Table + ''', ''U'') IS NOT NULL DROP TABLE ' + @SummaryViewFieldsData_Table;
		EXEC sp_executesql @DropSQL;

		SET @DropSQL = 'IF OBJECT_ID(''' + @tbl_Table + ''', ''U'') IS NOT NULL DROP TABLE ' + @tbl_Table;
		EXEC sp_executesql @DropSQL;

		SET @DropSQL = 'IF OBJECT_ID(''' + @DynamicMetricsTbl_Table + ''', ''U'') IS NOT NULL DROP TABLE ' + @DynamicMetricsTbl_Table;
		EXEC sp_executesql @DropSQL;

		SET @DropSQL = 'IF OBJECT_ID(''' + @SummaryViewFieldsDataTable_Table + ''', ''U'') IS NOT NULL DROP TABLE ' + @SummaryViewFieldsDataTable_Table;
		EXEC sp_executesql @DropSQL;

		SET @DropSQL = 'IF OBJECT_ID(''' + @StudentstblForsummaryView_Table + ''', ''U'') IS NOT NULL DROP TABLE ' + @StudentstblForsummaryView_Table;
		EXEC sp_executesql @DropSQL;

		SET @DropSQL = 'IF OBJECT_ID(''' + @TUserGroups_Table + ''', ''U'') IS NOT NULL DROP TABLE ' + @TUserGroups_Table;
		EXEC sp_executesql @DropSQL;

		DECLARE @RoleCode VARCHAR(50)
			,@LeaId VARCHAR(100)
			,@DistrictStaffId VARCHAR(100)
			,@FieldsCount INT = 0
			,@CreateTempSQL NVARCHAR(MAX)
			,@DynamicFields VARCHAR(max)
			,@InsertTempSQL NVARCHAR(MAX)
			,@SelectTempSQL NVARCHAR(MAX)
			,@pos INT
			,@len INT
			,@value VARCHAR(8000)
			,@FieldName VARCHAR(1000)
			,@FieldSourceTable VARCHAR(250)
			,@FieldSourceColumn VARCHAR(250)
			,@IsAttendanceRateColumnIncluded BIT = 0
			,@FromPreviousYear BIT = 0
			,@FromSchoolYear VARCHAR(10)
			,@CourseCondStr VARCHAR(MAX)
			,@SectionCondStr VARCHAR(MAX)
			,@CourseIdentifier VARCHAR(250)
			,@SectionIdentifier VARCHAR(250)
			,@CourseSectionGrades VARCHAR(MAX)
			,@IndicatorSourceFields VARCHAR(MAX)
			,@FinalInsertSQL NVARCHAR(MAX)
			,@FieldLatestYear VARCHAR(10)
			,@CountSql NVARCHAR(MAX)
			,@IsRefTableSorting BIT = 0
			,@LookUpTable VARCHAR(100) = NULL
			,@LookUpColumn VARCHAR(100) = NULL
			,@AssessmentCode VARCHAR(150) = NULL
			,@SubjectAreaCode VARCHAR(150) = NULL
			,@SortingDir VARCHAR(100) = NULL
			,@FieldDataType VARCHAR(100) = NULL
			,@TempSQL NVARCHAR(MAX)
			,@IsTeachingStaff BIT
			,@ColorDynamicFields VARCHAR(2000);

		-- Create dynamic tbl table
		SET @CreateSQL = 'CREATE TABLE ' + @tbl_Table + 
			'
            (DisplayName                VARCHAR(1000), 
             FieldName                  VARCHAR(1000), 
             GroupHeader                VARCHAR(1000), 
             IndicatorSourceColumn      VARCHAR(1000), 
             ShowImproveIndicatorStatus BIT, 
             InfoIcon                   VARCHAR(1000), 
             InfoText                   VARCHAR(1000), 
             FieldDataSource            VARCHAR(1000), 
             FieldSourceColumn          VARCHAR(1000), 
             FromPreviousYear           BIT, 
             GradeId                    INT, 
             statusid                   INT, 
             Tenantid                   INT, 
             sortorder                  INT, 
             FieldDataType              VARCHAR(1000), 
             Navigation                 VARCHAR(1000), 
             FieldLatestYear            VARCHAR(10),
			 CourseidField varchar(2000),
			 SectionidField varchar(2000),
			 HasDashboardView bit,
			 AssessmentCode varchar(100),
			 SubjectAreaCode varchar(20)
            )'
			;

		EXEC sp_executesql @CreateSQL;

		-- Create dynamic sumRef table
		SET @CreateSQL = 'CREATE TABLE ' + @sumRef_Table + '
            (RefColumn VARCHAR(150), 
             SortOrder INT, 
             YearVal   VARCHAR(100)
            )';

		EXEC sp_executesql @CreateSQL;

		-- Create dynamic StudentstblForsummaryView table
		SET @CreateSQL = 'CREATE TABLE ' + @StudentstblForsummaryView_Table + '
			(DistrictStudentID varchar(100),
			StudentName varchar(1000) 
			,GradeCode varchar(20)
			,GradeDescription varchar(500)
		    ,TenantId int
			)';

		EXEC sp_executesql @CreateSQL;

		-- Create dynamic DynamicMetricsTbl table
		SET @CreateSQL = 'CREATE TABLE ' + @DynamicMetricsTbl_Table + '(
			DistrictStudentId VARCHAR(100),StateStudentId varchar(25),StudentName varchar(250),GradeCode varchar(10),GradeDescription varchar(500),TenantId int 
			)';

		EXEC sp_executesql @CreateSQL;

		DECLARE @sseschoolidCondition VARCHAR(Max) = '';
		DECLARE @CourseCondition VARCHAR(max) = '';
		DECLARE @SectionCondition VARCHAR(max) = '';
		DECLARE @GradeCondition VARCHAR(1000) = '';
		DECLARE @schoolidCondition VARCHAR(Max) = '';
		DECLARE @StaffIdsCondition VARCHAR(max) = '';
		DECLARE @ExitTypeJoinCondition VARCHAR(max) = '';
		DECLARE @ExitTypeCondition VARCHAR(max) = '';
		DECLARE @SingleCourseSection INT;
		DECLARE @Year VARCHAR(150);
		DECLARE @RefQuery NVARCHAR(MAX);

		SELECT @LookUpTable = LookupTable
			,@LookUpColumn = LookupColumn
			,@SubjectAreaCode = SubjectAreaCode
			,@AssessmentCode = AssessmentCode
			,@FieldDataType = FieldDataType
		FROM StaffSummaryViewFields
		WHERE FieldName = @SORTBY
			AND TenantId = @TenantId
			AND IsRosterViewMetric = 1

		SELECT @Year = YearValue
		FROM RefYear
		WHERE TenantId = @TenantId
			AND StatusId = 1;

		SET @SortingDir = @SORTTYPE;

		IF (@isCohortGradeColumn = 1)
		BEGIN
			SET @LookUpTable = 'RefGrade'
			SET @LookUpColumn = 'GradeDescription'
			SET @FieldDataType = 'string'
		END

		--Declare @Metrics varchar(max)
		--IF @IsExport=1 or @MetrcGroupId is null
		--Begin		
		--Set @Metrics=null
		--End
		--Begin	
		--set @Metrics=STUFF((SELECT DISTINCT ',' +cast(MetricId as varchar) from (SELECT m.MetricId FROM 
		-- MetricGroups m 
		-- WHERE m.TenantId=@TenantId AND (@MetrcGroupId IS NULL OR m.MetricGroupDefID =@MetrcGroupId ))t
		-- FOR XML PATH('')), 1, 1, '');
		-- End
		DECLARE @IsDefaultMetric VARCHAR(5)

		SELECT @IsDefaultMetric = IsDefault
		FROM MetricGroupDef
		WHERE MetricGroupDefID = @MetrcGroupId
			AND TenantId = @TenantId

		DECLARE @DynamicMetricsTblSQL NVARCHAR(max)
			,@DynamicMetricsDataTblSQL NVARCHAR(max)
			,@GroupDomains NVARCHAR(max);

		SELECT @IsTeachingStaff = IsTeachingStaff
		FROM idm.DDAUser
		WHERE TenantId = @TenantId
			AND DDAUserId = @UserId
			AND statusid = 1

		IF (@LookUpTable IS NOT NULL)
		BEGIN
			SET @IsRefTableSorting = 1;

			IF (
					@AssessmentCode IS NOT NULL
					AND @SubjectAreaCode IS NOT NULL
					)
			BEGIN
				SET @RefQuery = 'Insert into ' + @sumRef_Table + '( RefColumn,SortOrder,YearVal )	select distinct ' + @LookUpColumn + ', SortOrder,sy  from ( select distinct ' + @LookUpColumn + ' , SortOrder,sy  from ' + @LookupTable + ' where replace(upper(AssessmentCode),''-'','''')=''' + UPPER(@AssessmentCode) + ''' AND SubjectAreaCode=''' + @SubjectAreaCode + ''') a  order by SortOrder ' + @SORTTYPE;
			END;
			ELSE
			BEGIN
				SET @RefQuery = 'Insert into ' + @sumRef_Table + '( RefColumn,SortOrder )	select distinct ' + @LookUpColumn + ', SortOrder  from ( select distinct ' + @LookUpColumn + ' , SortOrder  from ' + @LookupTable + ' ) a  order by SortOrder ' + @SORTTYPE;
			END;

			EXEC sp_executesql @RefQuery;

			IF (UPPER(@SORTTYPE) = 'DESC')
			BEGIN
				SET @InsertSQL = 'INSERT INTO ' + @sumRef_Table + ' VALUES (''NULL'', ((SELECT COUNT(*) FROM ' + @sumRef_Table + ') - (SELECT COUNT(*) FROM ' + @sumRef_Table + ')), ''' + @Year + ''')';

				EXEC sp_executesql @InsertSQL;

				SET @InsertSQL = 'INSERT INTO ' + @sumRef_Table + ' VALUES ('''', ((SELECT COUNT(*) FROM ' + @sumRef_Table + ') - (SELECT COUNT(*) FROM ' + @sumRef_Table + ')), ''' + @Year + ''')';

				EXEC sp_executesql @InsertSQL;
			END;
			ELSE
			BEGIN
				SET @InsertSQL = 'INSERT INTO ' + @sumRef_Table + ' VALUES (''NULL'', (SELECT COUNT(*) FROM ' + @sumRef_Table + '), ''' + @Year + ''')';

				EXEC sp_executesql @InsertSQL;

				SET @InsertSQL = 'INSERT INTO ' + @sumRef_Table + ' VALUES ('''', (SELECT COUNT(*) FROM ' + @sumRef_Table + '), ''' + @Year + ''')';

				EXEC sp_executesql @InsertSQL;
			END;
		END;

		SET @InsertSQL = 'INSERT INTO ' + @StudentstblForsummaryView_Table + '(DistrictStudentId,StudentName,GradeCode,TenantId) EXEC GetStudents @UserId,@TenantId,@SchoolYear,@SchoolId,@sectionId,@courseId,@Grade,@StaffIds,@STARTRECORD,@RECORDS,@SORTBY,@SORTTYPE,@CohortFilters,@CohortTitle,@SubGroupFilters';

		EXEC sp_executesql @InsertSQL
			,N'@UserId BIGINT, @TenantId INT, @SchoolYear VARCHAR(100), @SchoolId VARCHAR(MAX), @sectionId VARCHAR(MAX), @courseId VARCHAR(MAX), @Grade VARCHAR(1000), @StaffIds VARCHAR(MAX), @STARTRECORD VARCHAR(MAX), @RECORDS VARCHAR(MAX), @SORTBY VARCHAR(150), @SORTTYPE VARCHAR(150), @CohortFilters VARCHAR(MAX), @CohortTitle VARCHAR(MAX), @SubGroupFilters VARCHAR(MAX)'
			,@UserId = @UserId
			,@TenantId = @TenantId
			,@SchoolYear = @SchoolYear
			,@SchoolId = @SchoolId
			,@sectionId = @sectionId
			,@courseId = @courseId
			,@Grade = @Grade
			,@StaffIds = @StaffIds
			,@STARTRECORD = @STARTRECORD
			,@RECORDS = @RECORDS
			,@SORTBY = @SORTBY
			,@SORTTYPE = @SORTTYPE
			,@CohortFilters = @CohortFilters
			,@CohortTitle = @CohortTitle
			,@SubGroupFilters = @SubGroupFilters;

		SET @pos = 0;
		SET @len = 0;
		SET @SelectSQL = 'SELECT @CourseSectionGradesOUT = STUFF((SELECT DISTINCT '','' + CAST(rg.GradeId AS VARCHAR(10)) FROM ' + @StudentstblForsummaryView_Table + ' tblstu JOIN refgrade rg ON rg.TenantId=tblstu.TenantId AND rg.GradeCode=tblstu.GradeCode FOR XML PATH('''')), 1, 1, '''')';

		EXEC sp_executesql @SelectSQL
			,N'@CourseSectionGradesOUT VARCHAR(MAX) OUTPUT'
			,@CourseSectionGradesOUT = @CourseSectionGrades OUTPUT;

		SET @SingleCourseSection = CHARINDEX(',', @sectionId);

		SELECT @FieldsCount = COUNT(1)
		FROM staffsummaryviewFields(NOLOCK)
		WHERE TenantId = @TenantId
			AND StatusId = 1;

		-- Create dynamic TUserGroups table
		SET @CreateSQL = 'CREATE TABLE ' + @TUserGroups_Table + ' (GroupsId Int ,GroupsCode Nvarchar(250))';

		EXEC sp_executesql @CreateSQL;

		SET @InsertSQL = 'INSERT INTO ' + @TUserGroups_Table + ' (GroupsId,GroupsCode) SELECT GroupsId,GroupsCode FROM [fn_GetUserGroups] (@UserId,@TenantId)';

		EXEC sp_executesql @InsertSQL
			,N'@UserId BIGINT, @TenantId INT'
			,@UserId = @UserId
			,@TenantId = @TenantId;

		SET @SelectSQL = 'SELECT @GroupDomainsOUT = STUFF((SELECT DISTINCT '','' + CAST(gd.DataDomainId AS VARCHAR(25)) FROM IDM.GroupDomains gd INNER JOIN ' + @TUserGroups_Table + ' g ON g.GroupsId = gd.GroupsId WHERE gd.TenantId = @TenantIdIN AND gd.DDAUserId=@UserIdIN AND gd.StatusId=1 FOR XML PATH('''')), 1, 1, '''')';

		EXEC sp_executesql @SelectSQL
			,N'@TenantIdIN INT, @UserIdIN BIGINT, @GroupDomainsOUT NVARCHAR(MAX) OUTPUT'
			,@TenantIdIN = @TenantId
			,@UserIdIN = @UserId
			,@GroupDomainsOUT = @GroupDomains OUTPUT;

		SET @InsertSQL = 'INSERT INTO ' + @tbl_Table + 
			'
            (DisplayName, 
             FieldName, 
             GroupHeader, 
             IndicatorSourceColumn, 
             ShowImproveIndicatorStatus, 
             InfoIcon, 
             InfoText, 
             FieldDataSource, 
             FieldSourceColumn, 
             FromPreviousYear, 
             GradeId, 
             statusid, 
             Tenantid, 
             sortorder, 
             FieldDataType, 
             Navigation, 
             FieldLatestYear,
			 CourseidField,
			 SectionidField,
			 HasDashboardView,
			 AssessmentCode,
			 SubjectAreaCode
			 
            )
                   SELECT DISTINCT 
                          DisplayName, 
                          FieldName, 
                          GroupHeader, 
                          IndicatorSourceColumn, 
                          ShowImproveIndicatorStatus, 
                          InfoIcon, 
                          InfoText, 
                          FieldDataSource, 
                          FieldSourceColumn, 
                          FromPreviousYear, 
                          GradeId, 
                          sf.statusid AS StatusId, 
                          sf.Tenantid, 
						   (SELECT CASE WHEN @IsDefaultMetricIN = 1 THEN sf.sortorder
                                        ELSE mg.sortorder
                                        END) AS SortOrder,
                          sf.FieldDataType, 
                          sf.Navigation, 
                          sf.LatestYear,
						  sf.CourseIdField,
						  sf.SectionIdField,
						  sf.HasDashboardView,
						  sf.AssessmentCode,
						  sf.SubjectAreaCode	
						 
                   FROM staffsummaryviewFields sf(NOLOCK)

				           INNER JOIN StaffSummaryViewFieldsByDomain sfd(NOLOCK) ON sfd.StaffSummaryViewFieldsId = sf.StaffSummaryViewFieldsId
                                                                               AND sfd.TenantId = sf.TenantId
                        INNER JOIN StaffSummaryViewFieldByGrade sfg(NOLOCK) ON sfg.StaffSummaryViewFieldsId = sf.StaffSummaryViewFieldsId
                                                                               AND sfg.TenantId = sf.TenantId
						left join MetricGroups mg(nolock) on mg.MetricId=sfg.StaffSummaryViewFieldsId and mg.TenantId=sfg.TenantId 
                 
                   WHERE sf.TenantId = @TenantIdIN
				   and (mg.MetricGroupDefID=@MetrcGroupIdIN or (@IsDefaultMetricIN=1 and  sfg.StaffSummaryViewFieldsId not IN(select distinct MetricId from MetricGroups where TenantId=@TenantIdIN)))
						 AND sf.IsRosterViewMetric = 1
                         AND (sfg.GradeId IS NULL
                              OR sfg.GradeId IN
                   (
                       SELECT VALUE
                       FROM STRING_SPLIT(@CourseSectionGradesIN, '','')
                   ))

				    AND (sfd.DatadomainId IS NULL
                              OR sfd.DatadomainId IN
                   (
                       SELECT VALUE
                       FROM STRING_SPLIT(@GroupDomainsIN, '','')
                   ))
                         AND (fieldname NOT IN
                   (CASE
                        WHEN(@sectionidIN IS NULL
                             AND @GradeIN IS NOT NULL)
                        THEN ''LetterGrade''
						when (@sectionIdIN is not null and @SingleCourseSectionIN>0)
						then ''LetterGrade''
                        ELSE ''1''
                    END
                   ))
                         AND sf.statusid = 1
						 AND sfd.StatusId=1
                   ORDER BY SortOrder'
			;

		EXEC sp_executesql @InsertSQL
			,N'@TenantIdIN INT,
            @MetrcGroupIdIN INT,
            @IsDefaultMetricIN VARCHAR(5),
            @CourseSectionGradesIN VARCHAR(MAX),
            @GroupDomainsIN NVARCHAR(MAX),
            @sectionidIN VARCHAR(MAX),
            @GradeIN VARCHAR(1000),
            @SingleCourseSectionIN INT'
			,@TenantIdIN = @tenantid
			,@MetrcGroupIdIN = @MetrcGroupId
			,@IsDefaultMetricIN = @IsDefaultMetric
			,@CourseSectionGradesIN = @CourseSectionGrades
			,@GroupDomainsIN = @GroupDomains
			,@sectionidIN = @sectionid
			,@GradeIN = @Grade
			,@SingleCourseSectionIN = @SingleCourseSection;

		SET @FieldsSQL = 'SELECT @DynamicFieldsOUT = STUFF((
					    SELECT '',['' + fieldName + ''] varchar(max) ''
					    FROM ' + @tbl_Table + '
					    GROUP BY fieldname
						    ,sortorder
					    ORDER BY sortorder
					    FOR XML PATH('''')
					    ), 1, 1, '''')';

		EXEC sp_executesql @FieldsSQL
			,N'@DynamicFieldsOUT NVARCHAR(MAX) OUTPUT'
			,@DynamicFieldsOUT = @DynamicFields OUTPUT;

		SET @FieldsSQL = 'SELECT @ColorDynamicFieldsOUT = STUFF((
					    SELECT '',['' + fieldName + ''Color'' + ''] varchar(max) ''
					    FROM ' + @tbl_Table + '
					    GROUP BY fieldname
						    ,sortorder
					    ORDER BY sortorder
					    FOR XML PATH('''')
					    ), 1, 1, '''');'

		EXEC sp_executesql @FieldsSQL
			,N'@ColorDynamicFieldsOUT NVARCHAR(MAX) OUTPUT'
			,@ColorDynamicFieldsOUT = @ColorDynamicFields OUTPUT;

		SET @FieldsSQL = 'SELECT @IndicatorSourceFieldsOUT = STUFF((
						SELECT '',['' + IndicatorSourceColumn + ''] varchar(250) ''
						FROM ' + @tbl_Table + '
						WHERE ShowImproveIndicatorStatus = 1
						GROUP BY IndicatorSourceColumn
							,sortorder
						ORDER BY sortorder
						FOR XML PATH('''')
						), 1, 1, '''')';

		EXEC sp_executesql @FieldsSQL
			,N'@IndicatorSourceFieldsOUT NVARCHAR(MAX) OUTPUT'
			,@IndicatorSourceFieldsOUT = @IndicatorSourceFields OUTPUT;

		SET @DynamicMetricsTblSQL = 'ALTER TABLE ' + @DynamicMetricsTbl_Table + ' ADD  ';
		SET @DynamicMetricsTblSQL += ISNULL(' ' + @DynamicFields, '') + ' ,'
		SET @DynamicMetricsTblSQL += ISNULL(' ' + @ColorDynamicFields, '') + ' ,'
		SET @DynamicMetricsTblSQL += ISNULL(' ' + @IndicatorSourceFields, '') + ' '
		SET @DynamicMetricsTblSQL = (
				SELECT CASE WHEN Right(trim(@DynamicMetricsTblSQL), 1) = ',' THEN SUBSTRING(Trim(@DynamicMetricsTblSQL), 1, LEN(Trim(@DynamicMetricsTblSQL)) - 1) ELSE @DynamicMetricsTblSQL END
				)

		IF (@DynamicMetricsTblSQL <> 'ALTER TABLE ' + @DynamicMetricsTbl_Table + ' ADD   ,')
		BEGIN
			EXEC sys.sp_executesql @DynamicMetricsTblSQL;
		END

		SET @InsertSQL = 'insert into ' + @DynamicMetricsTbl_Table + '(DistrictStudentId,StudentName,GradeCode,GradeDescription,TenantId)
			(select DISTINCT sv.DistrictStudentID,StudentName,sv.GradeCode,rg.GradeDescription,sv.TenantId
			from ' + @StudentstblForsummaryView_Table + ' sv
			join RefGrade rg on rg.TenantId=sv.TenantId and rg.GradeCode=sv.GradeCode)';

		EXEC sp_Executesql @InsertSQL;

		SET @UpdateSQL = 'UPDATE a
		SET a.StateStudentId = B.StateStudentId
		FROM ' + @DynamicMetricsTbl_Table + ' a
		JOIN (
			SELECT DISTINCT districtstudentid
				,StateStudentId
				,tenantid
			FROM [AggStudentCourseSections]
			) b
			ON a.districtstudentid = b.districtstudentid
				AND a.tenantid = b.tenantid'

		EXEC sp_executesql @UpdateSQL

		DECLARE @StudentsFetchQuery NVARCHAR(max);

		IF @IsExport = 0
		BEGIN
			SET @StudentsFetchQuery = ' select * into ' + @SummaryViewFieldsDataTable_Table + ' from ' + @DynamicMetricsTbl_Table + ' order by StudentName 
			' + @SortType + ' OFFSET  cast(' + CAST(@STARTRECORD AS VARCHAR(100)) + ' AS INT) ROWS 
				FETCH NEXT CAST(' + CAST(@Records AS VARCHAR(100)) + ' AS INT) ROWS ONLY';
		END
		ELSE
		BEGIN
			SET @StudentsFetchQuery = ' select * into ' + @SummaryViewFieldsDataTable_Table + ' from ' + @DynamicMetricsTbl_Table + ' order by StudentName 
			' + @SortType + '';
		END

		EXEC sp_executesql @StudentsFetchQuery;

		SET @SelectSQL = 'SELECT *
		INTO ' + @SummaryViewFieldsData_Table + '
		FROM ' + @SummaryViewFieldsDataTable_Table + '';

		EXEC sp_executesql @SelectSQL

		SET @FieldsSQL = 'SELECT @DynamicFieldsOUT = STUFF((
					SELECT DISTINCT '''' + fieldName + '',''
					FROM ' + @tbl_Table + '
					FOR XML PATH('''')
					), 1, 0, '''');'

		EXEC sp_executesql @FieldsSQL
			,N'@DynamicFieldsOUT NVARCHAR(MAX) OUTPUT'
			,@DynamicFieldsOUT = @DynamicFields OUTPUT

		SET @FieldsSQL = 'SELECT @IndicatorSourceFieldsOUT = STUFF((
						SELECT DISTINCT '''' + IndicatorSourceColumn + '',''
						FROM ' + @tbl_Table + '
						WHERE ShowImproveIndicatorStatus = 1
						FOR XML PATH('''')
						), 1, 0, '''')';

		EXEC sp_executesql @FieldsSQL
			,N'@IndicatorSourceFieldsOUT NVARCHAR(MAX) OUTPUT'
			,@IndicatorSourceFieldsOUT = @IndicatorSourceFields OUTPUT;

		WHILE CHARINDEX(',', @DynamicFields, @pos + 1) > 0
		BEGIN
			SET @len = CHARINDEX(',', @DynamicFields, @pos + 1) - @pos;
			SET @value = SUBSTRING(@DynamicFields, @pos, @len);
			SET @pos = CHARINDEX(',', @DynamicFields, @pos + @len) + 1;

			IF (@value = 'AttendanceRate')
			BEGIN
				SET @IsAttendanceRateColumnIncluded = 1;
			END;

			SET @FieldsSQL = 'SELECT 
				@FieldNameOUT = FieldName,
				@FieldSourceColumnOUT = FieldSourceColumn,
				@FieldSourceTableOUT = FieldDataSource,
				@FromPreviousYearOUT = FromPreviousYear,
				@FieldLatestYearOUT = FieldLatestYear,
				@CourseIdentifierOUT = CourseidField,
				@SectionIdentifierOUT = SectionidField
			FROM ' + @tbl_Table + '
			WHERE TenantId = @TenantIdIN
			  AND FieldName = @valueIN
			  AND StatusId = 1';

			EXEC sp_executesql @FieldsSQL
				,N'@TenantIdIN INT,
				  @valueIN VARCHAR(8000),
				  @FieldNameOUT VARCHAR(1000) OUTPUT,
				  @FieldSourceColumnOUT VARCHAR(250) OUTPUT,
				  @FieldSourceTableOUT VARCHAR(250) OUTPUT,
				  @FromPreviousYearOUT BIT OUTPUT,
				  @FieldLatestYearOUT VARCHAR(10) OUTPUT,
				  @CourseIdentifierOUT VARCHAR(250) OUTPUT,
				  @SectionIdentifierOUT VARCHAR(250) OUTPUT'
				,@TenantIdIN = @TenantId
				,@valueIN = @value
				,@FieldNameOUT = @FieldName OUTPUT
				,@FieldSourceColumnOUT = @FieldSourceColumn OUTPUT
				,@FieldSourceTableOUT = @FieldSourceTable OUTPUT
				,@FromPreviousYearOUT = @FromPreviousYear OUTPUT
				,@FieldLatestYearOUT = @FieldLatestYear OUTPUT
				,@CourseIdentifierOUT = @CourseIdentifier OUTPUT
				,@SectionIdentifierOUT = @SectionIdentifier OUTPUT;

			SET @FromSchoolYear = CASE WHEN @FromPreviousYear = 1 THEN CAST(@FieldLatestYear AS INT) - 1 WHEN @FieldLatestYear IS NULL THEN @SchoolYear ELSE @FieldLatestYear END;
			SET @CourseCondStr = CASE WHEN @CourseIdentifier IS NOT NULL THEN ' and Table_B.' + @CourseIdentifier + ' =' + '''' + @courseId + '''' ELSE NULL END;
			SET @SectionCondStr = CASE WHEN @SectionIdentifier IS NOT NULL THEN ' and Table_B.' + @SectionIdentifier + ' =' + '''' + @sectionId + '''' ELSE NULL END;
			SET @InsertTempSQL = CAST('' AS NVARCHAR(MAX)) + N' UPDATE Table_A  SET  Table_A.[' + @FieldName + ']= Table_B.[' + @FieldSourceColumn + '],Table_A.[' + @FieldName + 'Color]= Table_B.[' + @FieldName + 'Color] FROM ' + @SummaryViewFieldsData_Table + ' AS Table_A  INNER JOIN ' + @FieldSourceTable + ' AS Table_B ON Table_A.DistrictStudentId = Table_B.DistrictStudentId   WHERE Table_B.TenantId=' + CAST(@TenantId AS VARCHAR(10));

			IF @CourseCondStr IS NOT NULL
			BEGIN
				SET @InsertTempSQL = @InsertTempSQL + @CourseCondStr;
				SET @InsertTempSQL = @InsertTempSQL + @SectionCondStr;
			END;

			-- print @InsertTempSQL
			SET @FinalInsertSQL = ISNULL(@FinalInsertSQL, '') + @InsertTempSQL;
				--print @FinalInsertSQL
		END;

		--print 1
		SET @pos = 0;
		SET @len = 0;

		WHILE CHARINDEX(',', @IndicatorSourceFields, @pos + 1) > 0
		BEGIN
			SET @len = CHARINDEX(',', @IndicatorSourceFields, @pos + 1) - @pos;
			SET @value = SUBSTRING(@IndicatorSourceFields, @pos, @len);
			SET @pos = CHARINDEX(',', @IndicatorSourceFields, @pos + @len) + 1;

			IF (@value = 'AttendanceRate')
			BEGIN
				SET @IsAttendanceRateColumnIncluded = 1;
			END;

			SET @FieldsSQL = 'SELECT @FieldNameOUT = IndicatorSourceColumn
				,@FieldSourceColumnOUT = IndicatorSourceColumn
				,@FieldSourceTableOUT = FieldDataSource
				,@FromPreviousYearOUT = FromPreviousYear
				,@FieldLatestYearOUT = FieldLatestYear
				,@CourseIdentifierOUT = CourseidField
				,@SectionIdentifierOUT = SectionidField
			FROM ' + @tbl_Table + '(NOLOCK)
			WHERE TenantId = @TenantIdIN
				AND IndicatorSourceColumn = @valueIN
				AND StatusId = 1
				AND ShowImproveIndicatorStatus = 1';

			EXEC sp_executesql @FieldsSQl
				,N'@TenantIdIN INT,
			  @valueIN VARCHAR(8000),
			  @FieldNameOUT VARCHAR(1000) OUTPUT,
			  @FieldSourceColumnOUT VARCHAR(250) OUTPUT,
			  @FieldSourceTableOUT VARCHAR(250) OUTPUT,
			  @FromPreviousYearOUT BIT OUTPUT,
			  @FieldLatestYearOUT VARCHAR(10) OUTPUT,
			  @CourseIdentifierOUT VARCHAR(250) OUTPUT,
			  @SectionIdentifierOUT VARCHAR(250) OUTPUT'
				,@TenantIdIN = @TenantId
				,@valueIN = @value
				,@FieldNameOUT = @FieldName OUTPUT
				,@FieldSourceColumnOUT = @FieldSourceColumn OUTPUT
				,@FieldSourceTableOUT = @FieldSourceTable OUTPUT
				,@FromPreviousYearOUT = @FromPreviousYear OUTPUT
				,@FieldLatestYearOUT = @FieldLatestYear OUTPUT
				,@CourseIdentifierOUT = @CourseIdentifier OUTPUT
				,@SectionIdentifierOUT = @SectionIdentifier OUTPUT;

			SET @FromSchoolYear = CASE WHEN @FromPreviousYear = 1 THEN CAST(@FieldLatestYear AS INT) - 1 WHEN @FieldLatestYear IS NULL THEN @SchoolYear ELSE @FieldLatestYear END;
			SET @CourseCondStr = CASE WHEN @CourseIdentifier IS NOT NULL THEN ' and Table_B.' + @CourseIdentifier + ' =' + '''' + @courseId + '''' ELSE NULL END;
			SET @SectionCondStr = CASE WHEN @SectionIdentifier IS NOT NULL THEN ' and Table_B.' + @SectionIdentifier + ' =' + '''' + @sectionId + '''' ELSE NULL END;
			SET @InsertTempSQL = CAST('' AS NVARCHAR(MAX)) + N' UPDATE Table_A  SET  Table_A.[' + @FieldName + ']= Table_B.[' + @FieldSourceColumn + '] FROM ' + @SummaryViewFieldsData_Table + ' AS Table_A  INNER JOIN ' + @FieldSourceTable + ' AS Table_B ON Table_A.DistrictStudentId = Table_B.DistrictStudentId  WHERE Table_B.TenantId=' + CAST(@TenantId AS VARCHAR(10)) + ' ';

			IF @CourseCondStr IS NOT NULL
			BEGIN
				SET @InsertTempSQL = @InsertTempSQL + @CourseCondStr;
				SET @InsertTempSQL = @InsertTempSQL + @SectionCondStr;
			END;

			SET @FinalInsertSQL = ISNULL(@FinalInsertSQL, '') + @InsertTempSQL;
		END;

		EXEC sp_executesql @FinalInsertSQL;

		SET @FieldsSQL = 'SELECT @DynamicFieldsOUT = STUFF((  
                SELECT '', '' + ''isnull('' + fieldName + '','''''''''' + '')'' + '' as'' + QUOTENAME(fieldName)  
                FROM (
				SELECT DISTINCT fieldName, sortorder
				FROM ' + @tbl_Table + '
			) a
			ORDER BY sortorder
			FOR XML PATH('''')
		), 1, 1, '''')';

		--print @FieldsSQL
		EXEC sp_executesql @FieldsSQL
			,N'@DynamicFieldsOUT NVARCHAR(MAX) OUTPUT'
			,@DynamicFieldsOUT = @DynamicFields;

		SET @FieldsSQL = 'Select @IndicatorSourceFieldsOUT = STUFF((
						SELECT DISTINCT '',['' + IndicatorSourceColumn + ''] ''
						FROM ' + @tbl_Table + '
						WHERE ShowImproveIndicatorStatus = 1
						FOR XML PATH('''')
						), 1, 0, '''')';

		EXEC sp_executesql @FieldsSQL
			,N'@IndicatorSourceFieldsOUT NVARCHAR(MAX) OUTPUT'
			,@IndicatorSourceFieldsOUT = @IndicatorSourceFields;

		IF @IsExport = 1
		BEGIN
			SET @SelectSQL = 'SELECT DISTINCT *
			FROM ' + @SummaryViewFieldsData_Table + '
			ORDER BY studentname'

			EXEC sp_executesql @selectsql

			SET @selectSQL = 'SELECT DISTINCT Displayname AS [Value]
				,FieldName AS Identifier
				,GroupHeader AS IdentifierCode
			FROM ' + @tbl_Table + '; '

			EXEC sp_executesql @selectsql
		END
		ELSE
		BEGIN
			SET @SelectSQL = 'SELECT DISTINCT *
			FROM ' + @SummaryViewFieldsData_Table + '
			ORDER BY studentname'

			EXEC sp_executesql @selectsql

			SET @SelectSQL = 'SELECT DISTINCT DisplayName
				,FieldName
				,GroupHeader
				,IndicatorSourceColumn
				,ShowImproveIndicatorStatus
				,InfoIcon
				,InfoText
				,FieldDataType
				,HasDashboardView
				,Assessmentcode
				,SubjectAreaCode
			FROM ' + @tbl_Table + '
			WHERE GroupHeader IS NOT NULL';

			--print @selectsql
			EXEC sp_executesql @selectsql

			SET @SelectSQL = 'SELECT DisplayName
				,FieldName
				,GroupHeader
				,IndicatorSourceColumn
				,ShowImproveIndicatorStatus
				,InfoIcon
				,InfoText
				,FieldDataType
				,Navigation
				,HasDashboardView
				,Assessmentcode
				,SubjectAreaCode
			FROM ' + @tbl_Table + '
			GROUP BY DisplayName
				,FieldName
				,GroupHeader
				,IndicatorSourceColumn
				,ShowImproveIndicatorStatus
				,InfoIcon
				,InfoText
				,FieldDataType
				,Navigation
				,sortorder
				,HasDashboardView
				,Assessmentcode
				,SubjectAreaCode
			ORDER BY sortorder ASC';

			EXEC sp_executesql @selectsql

			SET @SelectSQL = 'SELECT count(DISTINCT DistrictStudentId) AS TotalCount
			FROM ' + @DynamicMetricsTbl_Table + '';

			EXEC sp_executesql @selectsql

			SET @SelectSQL = 'SELECT s.FieldName
				,sc.MinValue
				,sc.MaxValue
				,sc.ColorCode
				,sc.OperatorCode
				,sc.SortOrder
				,s.AssessmentCode
				,s.DisplayName
				,s.IsGradeColorData
				,s.IsTermColorData
				,sc.GradeCode
				,sc.Term
			FROM StaffSummaryViewFieldColors sc
			JOIN StaffSummaryViewFields s ON sc.StaffSummaryViewFieldsId = s.StaffSummaryViewFieldsId
				AND sc.TenantId = s.TenantId
				AND s.StatusId = 1
				AND s.IsRosterViewMetric = 1
			JOIN ' + @tbl_Table + ' sf ON sf.FieldName = s.FieldName
			WHERE sc.TenantId = @TenantIdIN
				AND SC.StatusId = 1
			ORDER BY sc.SortOrder';

			EXEC sp_executesql @selectsql
				,N'@TenantIdIN INT'
				,@TenantIdIN = @TenantId;

			SET @SelectSQL = 'SELECT DISTINCT ProficiencyDescription
				,ProficiencyCode
				,ColorCode
			--,s.FieldName 
			FROM RefProficiencylevel p
			JOIN StaffSummaryViewFields s ON replace(p.AssessmentCode, ''-'', ''sumref'') = s.AssessmentCode
				AND s.TenantId = p.TenantId
				AND s.StatusId = 1
				AND s.IsRosterViewMetric = 1
			JOIN ' + @tbl_Table + ' sf ON sf.FieldName = s.FieldName
			JOIN AssessmentInfo ai ON p.AssessmentCode = ai.Assessment
				AND ai.TenantId = p.TenantId
				AND p.sy = ai.LatestSchoolYear
			WHERE p.TenantId = @TenantIdIN
				AND p.StatusId = 1';

			EXEC sp_executesql @selectsql
				,N'@TenantIdIN INT'
				,@TenantIdIN = @TenantId;

			--	select se.DistrictStudentId,   count( distinct se.SurveyEmailsId) AS TotalSentSurveys
			--	   ,isnull(count(DISTINCT CASE 
			--					WHEN se.responsestatus = 'submitted'
			--						THEN se.SurveyId
			--					END), 0) AS TotalSubmittedSurveys
			--	    from SurveyEmails se
			--join #SummaryViewFieldsData sf on se.TenantId=sf.TenantId and se.DistrictStudentId=sf.DistrictStudentId
			--where se.TenantId=@TenantId and se.StatusId=1 and  SentUserType='Student'
			--Group by se.DistrictStudentId
			--select null
			SET @SelectSQL = 'SELECT DISTINCT GradeCode
			FROM ' + @DynamicMetricsTbl_Table + '';

			EXEC sp_executesql @selectsql

			--Select AssessmentCode,TermDescription from(  
			--         Select Distinct aasd.AssessmentCode, aasd.TermDescription, term.sortOrder,  
			--         ROW_NUMBER() OVER (PARTITION BY aasd.AssessmentCode ORDER BY Count(aasd.TermDescription) Desc) rn  
			--From AggrptAssessmentSubgroupData aasd   
			--JOIN RefTerm term(NOLOCK) ON term.termcode = aasd.TermDescription AND term.schoolyear = aasd.schoolyear AND term.tenantid = aasd.tenantid  
			--where aasd.IsLatest = 1 And aasd.SchoolYear = @SchoolYear And aasd.TenantId = @TenantId  
			--Group By aasd.AssessmentCode, aasd.TermDescription,term.termcode,term.sortOrder) a  
			--where rn=1  
			SELECT DISTINCT Assessment AS AssessmentCode
				,NULL TermDescription
			FROM Assessmentinfo
			WHERE TenantID = @Tenantid

			SELECT TOP (1) TermDescription
			FROM RefTerm
			WHERE TenantId = @TenantId
				AND SchoolYear = @SchoolYear
			ORDER BY SortOrder DESC

			SET @selectSQl = 'SELECT CASE WHEN EXISTS (
							SELECT 1
							FROM IDM.GroupDomains gd
							INNER JOIN ' + @TUserGroups_Table + ' g
								ON g.GroupsId = gd.GroupsId
							INNER JOIN RefDataDomain rd
								ON rd.DataDomainId = gd.DataDomainId
									AND rd.TenantId = gd.TenantId
							WHERE gd.TenantId = @TenantidIN
								AND gd.DDAUserId = @UserIdIN
								AND (
									rd.DataDomainCode = ''ASS''
									OR rd.DataDomainCode = ''LASS''
									)
							) THEN 1 ELSE 0 END AS IsUserHavingAssessmentDomain';

			EXEC sp_executesql @selectSQl
				,N'@TenantIdIN INT, @UserIdIN INT'
				,@TenantIdIN = @TenantId
				,@UserIdIN = @UserId;
		END
	END TRY

	BEGIN CATCH
		DECLARE @ErrorFromProc VARCHAR(500);
		DECLARE @ErrorMessage VARCHAR(1000);
		DECLARE @SeverityLevel INT;

		SELECT @ErrorFromProc = '[USP_GetStudentsForStaffBySectionCourse_Test]'
			,@ErrorMessage = ERROR_MESSAGE()
			,@SeverityLevel = ERROR_SEVERITY();

		INSERT INTO [dbo].[ErrorLogForUSP] (
			ErrorFromProc
			,ErrorMessage
			,SeverityLevel
			,DateTimeStamp
			,TenantId
			)
		VALUES (
			@ErrorFromProc
			,@ErrorMessage
			,@SeverityLevel
			,GETDATE()
			,@TenantId
			);
	END CATCH;

	SET @CleanupSQL = 'IF OBJECT_ID(''' + @sumRef_Table + ''', ''U'') IS NOT NULL DROP TABLE ' + @sumRef_Table;
	EXEC sp_executesql @CleanupSQL;
	SET @CleanupSQL = 'IF OBJECT_ID(''' + @tbl_Table + ''', ''U'') IS NOT NULL DROP TABLE ' + @tbl_Table;
	EXEC sp_executesql @CleanupSQL;
	SET @CleanupSQL = 'IF OBJECT_ID(''' + @SummaryViewFieldsData_Table + ''', ''U'') IS NOT NULL DROP TABLE ' + @SummaryViewFieldsData_Table;
	EXEC sp_executesql @CleanupSQL;
	SET @CleanupSQL = 'IF OBJECT_ID(''' + @DynamicMetricsTbl_Table + ''', ''U'') IS NOT NULL DROP TABLE ' + @DynamicMetricsTbl_Table;
	EXEC sp_executesql @CleanupSQL;
	SET @CleanupSQL = 'IF OBJECT_ID(''' + @SummaryViewFieldsDataTable_Table + ''', ''U'') IS NOT NULL DROP TABLE ' + @SummaryViewFieldsDataTable_Table;
	EXEC sp_executesql @CleanupSQL;
	SET @CleanupSQL = 'IF OBJECT_ID(''' + @StudentstblForsummaryView_Table + ''', ''U'') IS NOT NULL DROP TABLE ' + @StudentstblForsummaryView_Table;
	EXEC sp_executesql @CleanupSQL;
	SET @CleanupSQL = 'IF OBJECT_ID(''' + @TUserGroups_Table + ''', ''U'') IS NOT NULL DROP TABLE ' + @TUserGroups_Table;
	EXEC sp_executesql @CleanupSQL;
END
GO