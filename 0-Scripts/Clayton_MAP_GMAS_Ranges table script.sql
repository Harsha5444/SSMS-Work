
CREATE TABLE [dbo].[Clayton_MAP_GMAS_Lexile_Ranges](
	[Clayton_MAP_GMAS_Lexile_Ranges_ID] int identity(1,1),
	--[yearStart] [numeric](18, 0) NULL,
	--[yearEnd] [numeric](18, 0) NULL,
	[GradeLevel] [varchar](5) NULL,
	[LowRangeNumeric] [varchar](50) NULL,
	[HighRangeNumeric] [varchar](50) NULL,
	[LowRangeActual] [varchar](50) NULL,
	[HighRangeActual] [varchar](50) NULL,
	[ProfLevel] [varchar](100) NULL,
	[SortOrder] [int] NULL,
	[TenantId] [int] NOT NULL,
	[StatusId] [smallint] NULL,
	[CreatedBy] [varchar](150) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedBy] [varchar](150) NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_Clayton_MAP_GMAS_Lexile_Ranges] PRIMARY KEY CLUSTERED ([Clayton_MAP_GMAS_Lexile_Ranges_ID] ASC),
CONSTRAINT [FK_Clayton_MAP_GMAS_Lexile_Ranges_RefStatus] FOREIGN KEY([StatusId]) REFERENCES [dbo].[RefStatus] ([StatusId]),
CONSTRAINT [FK_Clayton_MAP_GMAS_Lexile_Ranges_Tenant] FOREIGN KEY([TenantId])REFERENCES [IDM].[Tenant] ([TenantId]))




INSERT INTO [dbo].[Clayton_MAP_GMAS_Lexile_Ranges] (
    GradeLevel, LowRangeNumeric, HighRangeNumeric,
    LowRangeActual, HighRangeActual, ProfLevel,
    SortOrder, TenantId, StatusId,
    CreatedBy, CreatedDate, ModifiedBy, ModifiedDate
)
SELECT '03', '0', '519', '0L', '519L', 'Below Grade Level', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL
UNION ALL
SELECT '03', '520', '9999', '520L', '9999L', 'At or Above Grade Level', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL
UNION ALL
SELECT '04', '0', '739', '0L', '739L', 'Below Grade Level', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL
UNION ALL
SELECT '04', '740', '9999', '740L', '9999L', 'At or Above Grade Level', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL
UNION ALL
SELECT '05', '0', '829', '0L', '829L', 'Below Grade Level', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL
UNION ALL
SELECT '05', '830', '9999', '830L', '9999L', 'At or Above Grade Level', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL
UNION ALL
SELECT '06', '0', '924', '0L', '924L', 'Below Grade Level', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL
UNION ALL
SELECT '06', '925', '9999', '925L', '9999L', 'At or Above Grade Level', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL
UNION ALL
SELECT '07', '0', '969', '0L', '969L', 'Below Grade Level', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL
UNION ALL
SELECT '07', '970', '9999', '970L', '9999L', 'At or Above Grade Level', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL
UNION ALL
SELECT '08', '0', '1009', '0L', '1009L', 'Below Grade Level', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL
UNION ALL
SELECT '08', '1010', '9999', '1010L', '9999L', 'At or Above Grade Level', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL
UNION ALL
SELECT 'Ninth Grade Literature', '0', '1049', '0L', '1049L', 'Below Grade Level', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL
UNION ALL
SELECT 'Ninth Grade Literature', '1050', '9999', '1050L', '9999L', 'At or Above Grade Level', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL
UNION ALL
SELECT 'American Literature', '0', '1184', '0L', '1184L', 'Below Grade Level', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL
UNION ALL
SELECT 'American Literature', '1185', '9999', '1185L', '9999L', 'At or Above Grade Level', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL;
