select * from [Export_EOC Fall Mid Months 2023] where len(SchCode_RPT)= 3
select * from [Export_EOC_Fall_2023] where len(SchCode_RPT)= 3
select * from [Export_EOC Winter Mid Months 2023] where len(SchCode_RPT)= 3
select * from [Export_Updated_EOC_Winter_2023] where len(SchCode_RPT)= 3
select * from [Export_EOC_Spring_2023] where len(SchCode_RPT)= 3

select 
    distinct gtid_rpt
from [Export_EOC_Fall_2023] WITH (NOLOCK)
group by gtid_rpt,testadmin,contentarea
having count(*) > 1

select distinct TestAdmin from [dbo].[Export_EOC Fall Mid Months 2023]
select distinct TestAdmin from [dbo].[Export_EOC_Fall_2023]

select distinct TestAdmin from [dbo].[Export_EOC Winter Mid Months 2023]  
select distinct TestAdmin from [dbo].[Export_Updated_EOC_Winter_2023]

select distinct TestAdmin from [dbo].[Export_EOC_Spring_2023]

select * from [Export_EOC Fall Mid Months 2023] where gtid_rpt = '2503207758'
select * from [Export_EOC_Fall_2023] where gtid_rpt = '2503207758'

select * from Export_EOC_Fall_Combined_2023

select * from (
-- Matching rows from [Export_EOC_Winter 2022]
select ew.GTID_RPT, ew.RESAName_RPT, ew.SysCode_RPT, ew.SchCode_RPT, ew.SysName_RPT, ew.SchName_RPT, ew.CLSName_RPT, ew.StuLastName_RPT, ew.StuFirstName_RPT, ew.StuMidInitial_RPT, ew.StuGrade_RPT, ew.StuDOBMonth_RPT, ew.StuDOBDay_RPT, ew.StuDOBYear_RPT, ew.StuGender_RPT, ew.EthnicityRace_RPT, ew.SRC01_RPT, ew.SRC02_RPT, ew.SRC03_RPT, ew.SRC04_RPT, ew.SRC05_RPT, ew.SRC06_RPT, ew.SRC07_RPT, ew.SRC08_RPT, ew.SRC09_RPT, ew.SRC10_RPT, ew.SRC11_RPT, ew.SRC12_RPT, ew.EL_RPT, ew.Section504_RPT, ew.Migrant_RPT, ew.ELF_RPT, ew.SDUA_GAVS_RPT, ew.EOCPurpose_RPT, ew.RetestFlag, ew.TestOutFlag, ew.IR_RPT, ew.IV_RPT, ew.PIV_RPT, ew.PTNA_RPT, ew.ME_RPT, ew.DNA_RPT, ew.SWDFlag, ew.Braille, ew.VideoSignLang, ew.SummaryRPTFlag, ew.Scribe, ew.TestFormScoring, ew.TestMode, ew.SDUBCode_RPT, ew.DupInvalid, ew.LocalOptCoding1, ew.LocalOptCoding2, ew.LocalOptCoding3, ew.LocalOptCoding4, ew.IR_COLLECTED, ew.IV_COLLECTED, ew.PIV_COLLECTED, ew.PTNAFlag_COLLECTED, ew.ME_COLLECTED, ew.SDUBCode_COLLECTED, ew.CondAdmin_COLLECTED, ew.AccomIEP_COLLECTED, ew.AccomELTPC_COLLECTED, ew.AccomIAP_COLLECTED, ew.AccomST_COLLECTED, ew.AccomPRS_COLLECTED, ew.AccomRSP_COLLECTED, ew.AccomSCH_COLLECTED, ew.Audio, ew.ColorChooser, ew.ContrastingColor, ew.AudioPassages, ew.HumanReader, ew.HumanReaderPassage, ew.ContentArea, ew.ContentAreaCode, ew.SS, ew.ACHLevel, ew.CondSEM, ew.CondSEMHigh, ew.CondSEMLow, ew.GCS, ew.Lexile, ew.LexileL, ew.LexileLow, ew.LexileHigh, ew.EXTWRTGenre, ew.EXTWRT1Score, ew.EXTWRT2Score, ew.EXTWRT1CondCode, ew.EXTWRT2CondCode, ew.NARRWRTScore, ew.NARRWRTCondCode, ew.StretchBand, ew.ReadingStatus, ew.MasteryCategoryDom1, ew.MasteryCategoryDom2, ew.MasteryCategoryDom3, ew.MasteryCategoryDom4, ew.MasteryCategoryDom5, ew.MasteryCategoryDom6, ew.MasteryCategoryDom7, ew.MasteryCategoryDom8, ew.MasteryCategoryDom9, ew.MasteryCategoryDom10, ew.MasteryCategoryDom11, ew.NRT_NPRange, ew.SGP_FINAL, ew.SGP_LEVEL, ew.SCHOOL_YEAR_PRIOR_1, ew.SUBJECT_CODE_PRIOR_1, ew.SCALE_SCORE_PRIOR_1, ew.ACH_LEVEL_PRIOR_1, ew.GRADE_PRIOR_1, ew.ADMINISTRATION_PERIOD_PRIOR_1, ew.ASSESSMENT_TYPE_PRIOR_1, ew.SCHOOL_YEAR_PRIOR_2, ew.SUBJECT_CODE_PRIOR_2, ew.SCALE_SCORE_PRIOR_2, ew.ACH_LEVEL_PRIOR_2, ew.GRADE_PRIOR_2, ew.ADMINISTRATION_PERIOD_PRIOR_2, ew.ASSESSMENT_TYPE_PRIOR_2, ew.TestAdmin, ew.TestDate, ew.AdminInd, ew.FileRunType, ew.EOR, ew.StudentID_DRCUse, ew.DocumentID_DRCUse, ew.TestEventID_DRCUse, ew.ClassID_DRCUse, ew.CharterSchoolID_DRCUse, ew.ResaCode_DRCUse, ew.ContentAreaSort_DRCUse, ew.Other_Fields_DRCUse
from [Export_Updated_EOC_Winter_2023] ew
inner join [Export_EOC Winter Mid Months 2023] mm
    on ew.GTID_RPT = mm.GTID_RPT
    and ew.ContentArea = mm.ContentArea
    and ew.TestAdmin = mm.TestAdmin

union all

-- Remaining unmatched rows from [Export_EOC Winter mid months 2022]
select mm.GTID_RPT, mm.RESAName_RPT, mm.SysCode_RPT, mm.SchCode_RPT, mm.SysName_RPT, mm.SchName_RPT, mm.CLSName_RPT, mm.StuLastName_RPT, mm.StuFirstName_RPT, mm.StuMidInitial_RPT, mm.StuGrade_RPT, mm.StuDOBMonth_RPT, mm.StuDOBDay_RPT, mm.StuDOBYear_RPT, mm.StuGender_RPT, mm.EthnicityRace_RPT, mm.SRC01_RPT, mm.SRC02_RPT, mm.SRC03_RPT, mm.SRC04_RPT, mm.SRC05_RPT, mm.SRC06_RPT, mm.SRC07_RPT, mm.SRC08_RPT, mm.SRC09_RPT, mm.SRC10_RPT, mm.SRC11_RPT, mm.SRC12_RPT, mm.EL_RPT, mm.Section504_RPT, mm.Migrant_RPT, mm.ELF_RPT, mm.SDUA_GAVS_RPT, mm.EOCPurpose_RPT, mm.RetestFlag, mm.TestOutFlag, mm.IR_RPT, mm.IV_RPT, mm.PIV_RPT, mm.PTNA_RPT, mm.ME_RPT, mm.DNA_RPT, mm.SWDFlag, mm.Braille, mm.VideoSignLang, mm.SummaryRPTFlag, mm.Scribe, mm.TestFormScoring, mm.TestMode, mm.SDUBCode_RPT, mm.DupInvalid, mm.LocalOptCoding1, mm.LocalOptCoding2, mm.LocalOptCoding3, mm.LocalOptCoding4, mm.IR_COLLECTED, mm.IV_COLLECTED, mm.PIV_COLLECTED, mm.PTNAFlag_COLLECTED, mm.ME_COLLECTED, mm.SDUBCode_COLLECTED, mm.CondAdmin_COLLECTED, mm.AccomIEP_COLLECTED, mm.AccomELTPC_COLLECTED, mm.AccomIAP_COLLECTED, mm.AccomST_COLLECTED, mm.AccomPRS_COLLECTED, mm.AccomRSP_COLLECTED, mm.AccomSCH_COLLECTED, mm.Audio, mm.ColorChooser, mm.ContrastingColor, mm.AudioPassages, mm.HumanReader, mm.HumanReaderPassage, mm.ContentArea, mm.ContentAreaCode, mm.SS, mm.ACHLevel, mm.CondSEM, mm.CondSEMHigh, mm.CondSEMLow, mm.GCS, mm.Lexile, mm.LexileL, mm.LexileLow, mm.LexileHigh, mm.EXTWRTGenre, mm.EXTWRT1Score, mm.EXTWRT2Score, mm.EXTWRT1CondCode, mm.EXTWRT2CondCode, mm.NARRWRTScore, mm.NARRWRTCondCode, mm.StretchBand, mm.ReadingStatus, mm.MasteryCategoryDom1, mm.MasteryCategoryDom2, mm.MasteryCategoryDom3, mm.MasteryCategoryDom4, mm.MasteryCategoryDom5, mm.MasteryCategoryDom6, mm.MasteryCategoryDom7, mm.MasteryCategoryDom8, mm.MasteryCategoryDom9, mm.MasteryCategoryDom10, mm.MasteryCategoryDom11, mm.NRT_NPRange, mm.SGP_FINAL, mm.SGP_LEVEL, mm.SCHOOL_YEAR_PRIOR_1, mm.SUBJECT_CODE_PRIOR_1, mm.SCALE_SCORE_PRIOR_1, mm.ACH_LEVEL_PRIOR_1, mm.GRADE_PRIOR_1, mm.ADMINISTRATION_PERIOD_PRIOR_1, mm.ASSESSMENT_TYPE_PRIOR_1, mm.SCHOOL_YEAR_PRIOR_2, mm.SUBJECT_CODE_PRIOR_2, mm.SCALE_SCORE_PRIOR_2, mm.ACH_LEVEL_PRIOR_2, mm.GRADE_PRIOR_2, mm.ADMINISTRATION_PERIOD_PRIOR_2, mm.ASSESSMENT_TYPE_PRIOR_2, mm.TestAdmin, mm.TestDate, mm.AdminInd, mm.FileRunType, mm.EOR, mm.StudentID_DRCUse, mm.DocumentID_DRCUse, mm.TestEventID_DRCUse, mm.ClassID_DRCUse, mm.CharterSchoolID_DRCUse, mm.ResaCode_DRCUse, mm.ContentAreaSort_DRCUse, mm.Other_Fields_DRCUse
from [Export_EOC Winter Mid Months 2023] mm
where not exists (
    select 1
    from [Export_Updated_EOC_Winter_2023] ew
    where ew.GTID_RPT = mm.GTID_RPT
      and ew.ContentArea = mm.ContentArea
      and ew.TestAdmin = mm.TestAdmin
)) a


select distinct GTID_RPT from [dbo].[Export_EOC Fall Mid Months 2023]
intersect
select distinct GTID_RPT from [dbo].[Export_EOC_Fall_2023]

select distinct GTID_RPT from [dbo].[Export_EOC Winter Mid Months 2023]  
select distinct GTID_RPT from [dbo].[Export_Updated_EOC_Winter_2023]

select distinct GTID_RPT from [dbo].[Export_EOC_Spring_2023]


declare @columns nvarchar(max);

select @columns = string_agg(name, ', ew.')
from sys.columns
where object_id = object_id('[Export_EOC Winter Mid Months 2023]')

   and name not like '%filler%'  -- Uncomment and edit if needed

select @columns as ColumnList;


select * from #temp_EOC_2023_FALL where len(SchCode_RPT) = 3 
select * from [Export_EOC Fall Mid Months 2023] where gtid_rpt in (select distinct GTID_RPT from #temp_EOC_2023_Winter where len(SchCode_RPT) = 3 
)
select * from [Export_EOC_Fall_2023] where gtid_rpt in (select distinct GTID_RPT from #temp_EOC_2023_Winter where len(SchCode_RPT) = 3 
)

select * from #temp_EOC_2022_Winter where len(SchCode_RPT) = 3 
select * from #temp_EOC_2023_Winter where len(StuGrade_RPT) = 1
select * from #temp_EOC_2023_Winter where len(StuDOBMonth_RPT) = 1
select * from #temp_EOC_2023_Winter where len(SchCode_RPT) = 3 

select distinct  from [Export_EOC Winter Mid Months 2023] where gtid_rpt = '1001419928'
intersect
select distinct  from [Export_Updated_EOC_Winter_2023] where gtid_rpt = '1001419928'

