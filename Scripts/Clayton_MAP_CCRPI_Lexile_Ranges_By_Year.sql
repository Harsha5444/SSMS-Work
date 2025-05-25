CREATE TABLE dbo.Clayton_MAP_CCRPI_Lexile_Ranges_By_Year (
	Clayton_MAP_CCRPI_Lexile_Ranges_By_Year int identity(1,1),
    GradeLevel NVARCHAR(50),
    LowRangeNumeric INT,
    HighRangeNumeric INT,
    LowRangeActual NVARCHAR(10),
    HighRangeActual NVARCHAR(10),
    ProfLevel NVARCHAR(50),
    SortOrder INT,
    TenantId INT,
    StatusId INT,
    StartYear INT,
    EndYear INT,
    CreatedBy NVARCHAR(100),
    CreatedDate DATETIME,
    ModifiedBy NVARCHAR(100),
    ModifiedDate DATETIME
	 CONSTRAINT [PK_Clayton_MAP_CCRPI_Lexile_Ranges_By_Year] PRIMARY KEY CLUSTERED ([Clayton_MAP_CCRPI_Lexile_Ranges_By_Year_ID] ASC),CONSTRAINT [FK_Clayton_MAP_CCRPI_Lexile_Ranges_By_Year_RefStatus] FOREIGN KEY([StatusId]) REFERENCES [dbo].[RefStatus] ([StatusId]),CONSTRAINT [FK_Clayton_MAP_CCRPI_Lexile_Ranges_By_Year_Tenant] FOREIGN KEY([TenantId])REFERENCES [IDM].[Tenant] ([TenantId]))

INSERT INTO dbo.Clayton_MAP_CCRPI_Lexile_Ranges_By_Year (
    GradeLevel, LowRangeNumeric, HighRangeNumeric, LowRangeActual, HighRangeActual, ProfLevel,
    SortOrder, TenantId, StatusId, StartYear, EndYear, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate
)
SELECT '03', 0, 649, '0L', '649L', 'Below Grade Level', NULL, 50, 1, 2012, 2017, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL SELECT '03', 650, 9999, '650L', '9999L', 'At or Above Grade Level', NULL, 50, 1, 2012, 2017, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT '03', 0, 669, '0L', '669L', 'Below Grade Level', NULL, 50, 1, 2018, 2022, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL SELECT '03', 670, 9999, '670L', '9999L', 'At or Above Grade Level', NULL, 50, 1, 2018, 2022, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT '03', 0, 519, '0L', '519L', 'Below Grade Level', NULL, 50, 1, 2023, NULL, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL SELECT '03', 520, 9999, '520L', '9999L', 'At or Above Grade Level', NULL, 50, 1, 2023, NULL, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL

SELECT '04', 0, 839, '0L', '839L', 'Below Grade Level', NULL, 50, 1, 2018, 2022, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL SELECT '04', 840, 9999, '840L', '9999L', 'At or Above Grade Level', NULL, 50, 1, 2018, 2022, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT '04', 0, 739, '0L', '739L', 'Below Grade Level', NULL, 50, 1, 2023, NULL, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL SELECT '04', 740, 9999, '740L', '9999L', 'At or Above Grade Level', NULL, 50, 1, 2023, NULL, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL

SELECT '05', 0, 849, '0L', '849L', 'Below Grade Level', NULL, 50, 1, 2012, 2017, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL SELECT '05', 850, 9999, '850L', '9999L', 'At or Above Grade Level', NULL, 50, 1, 2012, 2017, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT '05', 0, 919, '0L', '919L', 'Below Grade Level', NULL, 50, 1, 2018, 2022, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL SELECT '05', 920, 9999, '920L', '9999L', 'At or Above Grade Level', NULL, 50, 1, 2018, 2022, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT '05', 0, 829, '0L', '829L', 'Below Grade Level', NULL, 50, 1, 2023, NULL, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL SELECT '05', 830, 9999, '830L', '9999L', 'At or Above Grade Level', NULL, 50, 1, 2023, NULL, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL

SELECT '06', 0, 996, '0L', '996L', 'Below Grade Level', NULL, 50, 1, 2018, 2022, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL SELECT '06', 997, 9999, '997L', '9999L', 'At or Above Grade Level', NULL, 50, 1, 2018, 2022, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT '06', 0, 924, '0L', '924L', 'Below Grade Level', NULL, 50, 1, 2023, NULL, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL SELECT '06', 925, 9999, '925L', '9999L', 'At or Above Grade Level', NULL, 50, 1, 2023, NULL, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL

SELECT '07', 0, 1044, '0L', '1044L', 'Below Grade Level', NULL, 50, 1, 2018, 2022, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL SELECT '07', 1045, 9999, '1045L', '9999L', 'At or Above Grade Level', NULL, 50, 1, 2018, 2022, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT '07', 0, 969, '0L', '969L', 'Below Grade Level', NULL, 50, 1, 2023, NULL, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL SELECT '07', 970, 9999, '970L', '9999L', 'At or Above Grade Level', NULL, 50, 1, 2023, NULL, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL

SELECT '08', 0, 1049, '0L', '1049L', 'Below Grade Level', NULL, 50, 1, 2012, 2017, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL SELECT '08', 1050, 9999, '1050L', '9999L', 'At or Above Grade Level', NULL, 50, 1, 2012, 2017, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT '08', 0, 1096, '0L', '1096L', 'Below Grade Level', NULL, 50, 1, 2018, 2022, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL SELECT '08', 1097, 9999, '1097L', '9999L', 'At or Above Grade Level', NULL, 50, 1, 2018, 2022, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT '08', 0, 1009, '0L', '1009L', 'Below Grade Level', NULL, 50, 1, 2023, NULL, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL SELECT '08', 1010, 9999, '1010L', '9999L', 'At or Above Grade Level', NULL, 50, 1, 2023, NULL, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL

SELECT 'Ninth Grade Literature', 0, 1154, '0L', '1154L', 'Below Grade Level', NULL, 50, 1, 2018, 2022, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL SELECT 'Ninth Grade Literature', 1155, 9999, '1155L', '9999L', 'At or Above Grade Level', NULL, 50, 1, 2018, 2022, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL

SELECT 'American Literature', 0, 1274, '0L', '1274L', 'Below Grade Level', NULL, 50, 1, 2012, 2017, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL SELECT 'American Literature', 1275, 9999, '1275L', '9999L', 'At or Above Grade Level', NULL, 50, 1, 2012, 2017, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'American Literature', 0, 1154, '0L', '1184L', 'Below Grade Level', NULL, 50, 1, 2018, 2022, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL SELECT 'American Literature', 1285, 9999, '1155L', '9999L', 'At or Above Grade Level', NULL, 50, 1, 2018, 2022, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'American Literature', 0, 1184, '0L', '1184L', 'Below Grade Level', NULL, 50, 1, 2023, NULL, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL SELECT 'American Literature', 1185, 9999, '1185L', '9999L', 'At or Above Grade Level', NULL, 50, 1, 2023, NULL, 'DDAUser@DDA', GETDATE(), NULL, NULL;
