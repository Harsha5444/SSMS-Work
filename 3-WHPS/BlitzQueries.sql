select * from idm.tenant --38

select * from ReportDetails 
where tenantid = 38 and DomainRelatedViewId=3670 and reporttypeid = 102 --and ReportDetailsName like '%sbac%'
order by 1 desc



with cte as 
(select *,row_number() over (partition by ReportDetailsId,DDAUserId,TenantId,StatusId,OrgId,OrganizationTypeCode order by ReportUsersId asc) as rn 
from ReportUsers 
where  reportdetailsid in (8927,8926,8925,8924,8923,8922,8921,8920,8919,8918,8917,8916,8915,8914,8913,8912,8911,8910,8909,8908,8907,8906
,8905,8904,8903,8902))
select * from cte where rn>1


select distinct grade_level from WHPSBlitzReportDS


exec sp_depends WHPSBlitzReportDS

select distinct grade_level from WHPS_StudentSummaryWithAllAss
select distinct schoolyear from WHPS_StudentSummaryWithAllAss


--6,7,8
--9,10,11,12


SELECT  distinct GRADE_LEVEL FROM dbo.WHPSBlitzReportDS as ds with (nolock)   WHERE  ((ISNUMERIC(ISNULL([SAT_ReadingScore], 0)) = 1) AND ([SAT_ReadingScore] IS NOT NULL ) AND ([SchoolYear] IN ('2025')) AND (TenantId = 38))   GROUP BY [Teacher]  ORDER BY [Teacher] ASC 

select filterby from ReportDetails where  reportdetailsid = 8897

select * from RptViewFields where rptviewfieldsid = 78657

select * from ReportDetails where TenantId = 38


--UPDATE ReportDetails 
--SET filterby = CASE 
    WHEN filterby IS NULL OR filterby = '' THEN 
        '[{"Filter":"GRADE_LEVEL","ComaprisonType":"In","ComaprisonValue":"6, 7, 8","FilterByField":null,"FilterByFieldId":78657,"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null}]'
    WHEN LEFT(LTRIM(filterby), 1) = '[' THEN 
        -- If it's already an array, insert the new filter at the beginning
        STUFF(filterby, 2, 0, '{"Filter":"GRADE_LEVEL","ComaprisonType":"In","ComaprisonValue":"6, 7, 8","FilterByField":null,"FilterByFieldId":78657,"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null},')
    ELSE 
        -- If it's a single object, convert to array and add new filter
        '[{"Filter":"GRADE_LEVEL","ComaprisonType":"In","ComaprisonValue":"6, 7, 8","FilterByField":null,"FilterByFieldId":78657,"ReportDetailsId":0,"ChildReportId":null,"Isdrilldown":false,"IsFromGraph":false,"IsExisting":false,"IsPreviousExisting":false,"DrillLevelCount":0,"IsValueField":false,"DisplayName":null,"IsEntitylevelScopeField":false,"AliasName":null,"IsDrillDownBack":false,"IsDefaultDynamicReport":false,"IsAdvanceFilter":false,"FilterColumnName":null,"Isfilterapplyed":false,"ComaprisonTitle":null,"Numerator":true,"Denominator":true,"ValueColumn":null,"tableAliasName":null,"DefaultValuesFilter":null},' + filterby + ']'
END
WHERE reportdetailsid in (8901,8900,8899,8898,8895,8894,8893,8892,8891,8890,8889,8888,8887,8886,8885,8884,8883,8882,8881,8880
,8879,8878,8870,8869,8868,8859) and TenantId = 38;

--begin transaction
--UPDATE ReportDetails 
SET ReportDetailsName = ReportDetailsName + ' - High'
WHERE reportdetailsid in (8895,8894,8893,8892,8891,8890,8889,8888,8887,8886,8885,8884
,8883,8882,8881,8880,8879,8878,8870,8869,8868,8859,8858,8857) and TenantId = 38

--commit transaction

--update a 
--set a.filterby = b.filterby , a.ReportDetailsName = b.ReportDetailsName , a.ReportFileDetails=b.ReportFileDetails
--from reportdetails a
--join whps_reportdetails_bkp17072025 b
--on a.tenantid = b.tenantid and a.ReportDetailsId = b.ReportDetailsId
--where a.reportdetailsid in (8895,8894,8893,8892,8891,8890,8889,8888,8887,8886,8885,8884
--,8883,8882,8881,8880,8879,8878,8870,8869,8868,8859,8858,8857) and a.TenantId = 38

--drop table whps_reportdetails_bkp17072025


--UPDATE ReportDetails 
--SET ReportDetailsName = replace(ReportDetailsName,'EnglishLanguageArts','ELA') from ReportDetails 
--where tenantid = 38 and DomainRelatedViewId=3670 and reporttypeid = 102 and ReportDetailsName like '%sbac%'






SAT
PSAT
AIMSWebPlus
i-Ready
NGSS
SBAC
STAR

select * from roledashboard where tenantid = 38 and DashboardId=345

select * from dashboard where  tenantid = 38

select * from refstatus where  tenantid = 38


SELECT *
FROM WHPS_StudentSummaryWithAllAss AS ds WITH (NOLOCK)
WHERE (([GRADE_LEVEL] IN (9,10,11,12))
		AND ([i-Ready_Reading_ScaleScore] IS NOT NULL)
		AND ([SchoolYear] IN ('2025'))
		AND (TenantId = 38)
		)

select * from idm.apperrorlog order by 1 desc



Message: The source contains no DataRows., InnerException: The source contains no DataRows.     at System.Data.DataTableExtensions.LoadTableFromEnumerable[T](IEnumerable`1 source, DataTable table, Nullable`1 options, FillErrorEventHandler errorHandler)     at System.Data.DataTableExtensions.CopyToDataTable[T](IEnumerable`1 source)     at DA.Services.Implementations.DataVisualizerService.GetDatasetResult(DataVisualizerCreateModel previewData, Int32 tenantId, Int64 userId)     at DA.Services.Implementations.DataVisualizerService.GetShowPreview(DataVisualizerCreateModel previewData, Int32 tenantId, Int64 userId, String tenantCode)  


SELECT  ds.[Teacher] as [Teacher], ds.[PSAT_MathBenchmark] as [PSAT_MathBenchmark],Count(Distinct ds.[Student_Number]) as [Student_Number],( SELECT COUNT(Distinct [Student_Number]) FROM dbo.WHPSBlitzReportDS AS subds with (nolock) LEFT JOIN dbo.RefBlitzPSATLevels ON subds.[PSAT_MathBenchmark] = dbo.RefBlitzPSATLevels.ProficiencyCode AND  subds.tenantid =dbo.RefBlitzPSATLevels.tenantid  Where subds.[Teacher] = ds.[Teacher] AND ISNULL(subds.[GRADE_LEVEL], ' ') IN ('6', '7', '8') AND (subds.[PSAT_MathBenchmark] IS NOT NULL ) AND ISNULL(subds.[SchoolYear], ' ') IN ('2025') AND (subds.TenantId =38)) AS [SeriesTotalCount]  FROM dbo.WHPSBlitzReportDS as ds with (nolock)  LEFT JOIN dbo.RefBlitzPSATLevels ON ds.[PSAT_MathBenchmark] = dbo.RefBlitzPSATLevels.ProficiencyCode AND  ds.tenantid =dbo.RefBlitzPSATLevels.tenantid    WHERE  ((ds.[GRADE_LEVEL] IN ('6', '7', '8')) AND (ds.[PSAT_MathBenchmark] IS NOT NULL ) AND (ds.[SchoolYear] IN ('2025')) AND (ds.TenantId = 38))   GROUP BY ds.[Teacher],ds.[PSAT_MathBenchmark],dbo.RefBlitzPSATLevels.SortOrder  ORDER BY ds.[Teacher] ASC,dbo.RefBlitzPSATLevels.SortOrder ASC,ds.[PSAT_MathBenchmark] ASC 



select * from WHPSAssessmentAllDS_Vw


