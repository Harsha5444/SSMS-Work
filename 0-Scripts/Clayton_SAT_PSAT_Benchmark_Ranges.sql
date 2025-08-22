CREATE TABLE [dbo].[Clayton_SAT_PSAT_Benchmark_Ranges]
(
    [Clayton_SAT_PSAT_Benchmark_Ranges_ID] int identity(1, 1),
    [AssessmentCode] [varchar](50) NULL,
    [SubjectAreaCode] [varchar](50) NULL,
    [SubjectAreaName] [varchar](50) NULL,
    [GradeLevel] [varchar](5) NULL,
    [LowRangeNumeric] [varchar](50) NULL,
    [HighRangeNumeric] [varchar](50) NULL,
    [ProfLevel] [varchar](100) NULL,
    [SortOrder] [int] NULL,
    [TenantId] [int] NOT NULL,
    [StatusId] [smallint] NULL,
    [CreatedBy] [varchar](150) NOT NULL,
    [CreatedDate] [datetime] NOT NULL,
    [ModifiedBy] [varchar](150) NULL,
    [ModifiedDate] [datetime] NULL,
    CONSTRAINT [PK_Clayton_SAT_PSAT_Benchmark_Ranges]
        PRIMARY KEY CLUSTERED ([Clayton_SAT_PSAT_Benchmark_Ranges_ID] ASC),
    CONSTRAINT [FK_Clayton_SAT_PSAT_Benchmark_Ranges_RefStatus]
        FOREIGN KEY ([StatusId])
        REFERENCES [dbo].[RefStatus] ([StatusId]),
    CONSTRAINT [FK_Clayton_SAT_PSAT_Benchmark_Ranges_Tenant]
        FOREIGN KEY ([TenantId])
        REFERENCES [IDM].[Tenant] ([TenantId])
)

INSERT INTO [dbo].[Clayton_SAT_PSAT_Benchmark_Ranges]
(
    AssessmentCode,
    SubjectAreaCode,
    SubjectAreaName,
    GradeLevel,
    LowRangeNumeric,
    HighRangeNumeric,
    ProfLevel,
    SortOrder,
    TenantId,
    StatusId,
    CreatedBy,
    CreatedDate,
    ModifiedBy,
    ModifiedDate
)

SELECT 'PSAT89','EBRW','Evidence Based Reading and Writing','08', '120', '360', 'Not Yet Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'PSAT89','EBRW','Evidence Based Reading and Writing','08', '370', '380', 'Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'PSAT89','EBRW','Evidence Based Reading and Writing','08', '390', '720', 'Meets/Exceeds', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'PSAT89','Mathematics','Mathematics','08', '120', '400', 'Not Yet Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'PSAT89','Mathematics','Mathematics','08', '410', '420', 'Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'PSAT89','Mathematics','Mathematics','08', '430', '720', 'Meets/Exceeds', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'PSAT89','EBRW','Evidence Based Reading and Writing','09', '120', '380', 'Not Yet Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'PSAT89','EBRW','Evidence Based Reading and Writing','09', '390', '400', 'Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'PSAT89','EBRW','Evidence Based Reading and Writing','09', '410', '720', 'Meets/Exceeds', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'PSAT89','Mathematics','Mathematics','09', '120', '420', 'Not Yet Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'PSAT89','Mathematics','Mathematics','09', '430', '440', 'Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'PSAT89','Mathematics','Mathematics','09', '450', '720', 'Meets/Exceeds', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'PSATNMSQT','EBRW','Evidence Based Reading and Writing','10', '160', '400', 'Not Yet Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'PSATNMSQT','EBRW','Evidence Based Reading and Writing','10', '410', '420', 'Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'PSATNMSQT','EBRW','Evidence Based Reading and Writing','10', '430', '760', 'Meets/Exceeds', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'PSATNMSQT','Mathematics','Mathematics','10', '160', '440', 'Not Yet Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'PSATNMSQT','Mathematics','Mathematics','10', '450', '470', 'Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'PSATNMSQT','Mathematics','Mathematics','10', '480', '760', 'Meets/Exceeds', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'PSATNMSQT','EBRW','Evidence Based Reading and Writing','11', '160', '420', 'Not Yet Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'PSATNMSQT','EBRW','Evidence Based Reading and Writing','11', '430', '450', 'Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'PSATNMSQT','EBRW','Evidence Based Reading and Writing','11', '460', '760', 'Meets/Exceeds', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'PSATNMSQT','Mathematics','Mathematics','11', '160', '470', 'Not Yet Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'PSATNMSQT','Mathematics','Mathematics','11', '480', '500', 'Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'PSATNMSQT','Mathematics','Mathematics','11', '510', '760', 'Meets/Exceeds', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'SAT','EBRW','Evidence Based Reading and Writing','08', '200', '450', 'Not Yet Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'SAT','EBRW','Evidence Based Reading and Writing','08', '460', '470', 'Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'SAT','EBRW','Evidence Based Reading and Writing','08', '480', '800', 'Meets/Exceeds', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'SAT','Mathematics','Mathematics','08', '200', '500', 'Not Yet Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'SAT','Mathematics','Mathematics','08', '510', '520', 'Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'SAT','Mathematics','Mathematics','08', '530', '800', 'Meets/Exceeds', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'SAT','EBRW','Evidence Based Reading and Writing','09', '200', '450', 'Not Yet Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'SAT','EBRW','Evidence Based Reading and Writing','09', '460', '470', 'Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'SAT','EBRW','Evidence Based Reading and Writing','09', '480', '800', 'Meets/Exceeds', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'SAT','Mathematics','Mathematics','09', '200', '500', 'Not Yet Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'SAT','Mathematics','Mathematics','09', '510', '520', 'Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'SAT','Mathematics','Mathematics','09', '530', '800', 'Meets/Exceeds', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'SAT','EBRW','Evidence Based Reading and Writing','10', '200', '450', 'Not Yet Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'SAT','EBRW','Evidence Based Reading and Writing','10', '460', '470', 'Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'SAT','EBRW','Evidence Based Reading and Writing','10', '480', '800', 'Meets/Exceeds', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'SAT','Mathematics','Mathematics','10', '200', '500', 'Not Yet Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'SAT','Mathematics','Mathematics','10', '510', '520', 'Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'SAT','Mathematics','Mathematics','10', '530', '800', 'Meets/Exceeds', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'SAT','EBRW','Evidence Based Reading and Writing','11', '200', '450', 'Not Yet Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'SAT','EBRW','Evidence Based Reading and Writing','11', '460', '470', 'Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'SAT','EBRW','Evidence Based Reading and Writing','11', '480', '800', 'Meets/Exceeds', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'SAT','Mathematics','Mathematics','11', '200', '500', 'Not Yet Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'SAT','Mathematics','Mathematics','11', '510', '520', 'Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'SAT','Mathematics','Mathematics','11', '530', '800', 'Meets/Exceeds', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'SAT','EBRW','Evidence Based Reading and Writing','12', '200', '450', 'Not Yet Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'SAT','EBRW','Evidence Based Reading and Writing','12', '460', '470', 'Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'SAT','EBRW','Evidence Based Reading and Writing','12', '480', '800', 'Meets/Exceeds', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'SAT','Mathematics','Mathematics','12', '200', '500', 'Not Yet Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'SAT','Mathematics','Mathematics','12', '510', '520', 'Approaching', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL UNION ALL
SELECT 'SAT','Mathematics','Mathematics','12', '530', '800', 'Meets/Exceeds', NULL, 50, 1, 'DDAUser@DDA', GETDATE(), NULL, NULL

