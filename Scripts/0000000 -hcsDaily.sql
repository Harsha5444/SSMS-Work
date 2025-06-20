EXEC SP_DEPENDS GSHS_ES_675_Response_Vw;   --dbo.HCS_PSO_Student_Connectivity_ES_Vw
EXEC sp_helptext fn_DashboardReportDetails;
SELECT * FROM dbo.fn_DashboardReportDetails(4)

--==============================================================================================================================
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SELECT er.session_Id AS [Spid]
	,sp.ecid
	,er.start_time
	,DATEDIFF(SS, er.start_time, GETDATE()) AS [Age Seconds]
	,sp.nt_username
	,er.STATUS
	,er.wait_type
	,SUBSTRING(qt.TEXT, (er.statement_start_offset / 2) + 1, (
			(
				CASE 
					WHEN er.statement_end_offset = - 1
						THEN LEN(CONVERT(NVARCHAR(MAX), qt.TEXT)) * 2
					ELSE er.statement_end_offset
					END - er.statement_start_offset
				) / 2
			) + 1) AS [Individual Query]
	,qt.TEXT AS [Parent Query]
	,sp.program_name
	,sp.Hostname
	,sp.nt_domain
FROM sys.dm_exec_requests er
INNER JOIN sys.sysprocesses sp ON er.session_id = sp.spid
CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) AS qt
WHERE session_Id > 50
	AND session_Id NOT IN (@@SPID)
ORDER BY session_Id
	,ecid
	
--==============================================================================================================================
SELECT OBJECT_SCHEMA_NAME(o.object_id) AS schema_name
	,o.name AS object_name
	,o.type_desc AS object_type
	,OBJECT_DEFINITION(o.object_id) AS DEFINITION
FROM sys.objects o
WHERE o.type IN (
		'V'
		,'P'
		) -- V = View, P = Stored Procedure
	AND OBJECT_DEFINITION(o.object_id) LIKE '%HCS_IlluminateRoster_Elem%'
--AND o.name like '%AMIRAAVueDS%'

--==============================================================================================================================
SELECT v.name AS ViewName
	,s.name AS SchemaName
	,OBJECT_DEFINITION(v.object_id) AS ViewDefinition
	,STRING_AGG(OBJECT_NAME(sed.referenced_id), ', ') AS ReferencedTables
FROM sys.VIEWS v
JOIN sys.schemas s ON v.schema_id = s.schema_id
OUTER APPLY (
	SELECT DISTINCT referenced_id
	FROM sys.sql_expression_dependencies
	WHERE referencing_id = v.object_id
		AND referenced_id IS NOT NULL
		AND referenced_class = 1
	) sed -- Class = 1 for Tables
WHERE 1 = 1
	AND v.name LIKE '%HCSIlluminateResponseElemAVueDS%'
GROUP BY v.name
	,s.name
	,OBJECT_DEFINITION(v.object_id)
ORDER BY s.name
	,v.name;

--==============================================================================================================================
SELECT p.name AS ProcedureName
	,s.name AS SchemaName
	,OBJECT_DEFINITION(p.object_id) AS ProcedureDefinition
	,STRING_AGG(OBJECT_NAME(sed.referenced_id), ', ') AS ReferencedTables
FROM sys.procedures p
JOIN sys.schemas s ON p.schema_id = s.schema_id
OUTER APPLY (
	SELECT DISTINCT referenced_id
	FROM sys.sql_expression_dependencies
	WHERE referencing_id = p.object_id
		AND referenced_id IS NOT NULL
		AND referenced_class = 1
	) sed -- Class = 1 for Tables
WHERE 1 = 1
	AND p.name LIKE '%USP_HCSIlluminateAgg%'
GROUP BY p.name
	,s.name
	,OBJECT_DEFINITION(p.object_id)
ORDER BY s.name
	,p.name;

--==============================================================================================================================
SELECT dgd.DashboardGroupDefID
	,dgd.GroupName
	,d.DashboardId
	,COALESCE(d.DashboardName, 'No Dashboard Assigned') AS DashboardName
FROM Dashboardgroupdef dgd
LEFT JOIN Dashboardgroups dg ON dgd.DashboardGroupDefID = dg.DashboardGroupDefID
RIGHT JOIN Dashboard d ON dg.DashboardId = d.DashboardId
WHERE d.DashboardName <> ''
ORDER BY dgd.DashboardGroupDefID DESC
	,d.DashboardName;

--====================================================================================================
SELECT rd.*
FROM ReportDetails rd
WHERE 1 = 1
	AND EXISTS (
		SELECT 1
		FROM OPENJSON(rd.ReportFileDetails, '$.AdvanceFilter') WITH (AliasName NVARCHAR(100) '$.AliasName') AS j
		WHERE j.AliasName = 'Subject'
		);

SELECT DISTINCT rd.reportdetailsname
	,j.AliasName
FROM ReportDetails rd
CROSS APPLY OPENJSON(rd.ReportFileDetails, '$.AdvanceFilter') WITH (AliasName NVARCHAR(100) '$.AliasName') AS j
WHERE rd.ReportDetailsName = 'EOC Algebra by School and Achievement Level '
ORDER BY j.AliasName;


--===================================================================================================
select rd.*
from ReportDetails rd
cross apply openjson(rd.Reportfiledetails, '$.ValueColumn') 
     with (Code nvarchar(100)) as vc
where vc.Code = 'PercentageDistinctCount'   -- change this to filter other codes
or vc.Code = 'PercentageCount' 
or vc.Code = 'Percentage'

select distinct vc.Code
from ReportDetails rd
cross apply openjson(rd.Reportfiledetails, '$.ValueColumn') 
     with (Code nvarchar(100)) as vc
where vc.Code is not null

set statistics time on 
SELECT distinct ds.[Present Percentage] as [Present Percentage]  FROM dbo.AttendanceSummary7yrsAV as ds with (nolock)   WHERE  ((ds.[SchoolYear] IN ('2025')) AND (ds.[StudentNumber] IN ('229842')) AND (ds.TenantId = 4))  

SELECT Count(ds.[courseName]) as [courseName]  FROM dbo.HCSDSCOREgradingDetailSC as ds with (nolock)   WHERE  ((ds.[failingGrade] = 'True') AND (ds.[gradeLevel] IN ('01', '02', '03', '04', '05', 'KK')) AND (ds.[termName] = 'T4') AND (ds.[gradingTask] = 'Year End Average') AND (ds.[schoolYear] IN ('2025')) AND (ds.[studentNumber] IN ('229842')) AND (ds.TenantId = 4))  

SELECT cast(Sum(cast(ds.[resolutionLengthSchoolDays] as decimal(15,1)))  as decimal(15,1)) as [resolutionLengthSchoolDays]  FROM dbo.HCSDSCOREBehavior7yrv2STbehRecordsOnly as ds with (nolock)   WHERE  ((ISNUMERIC(ds.[resolutionLengthSchoolDays]) = 1) AND (ds.[resolutionCodeDesc] = 'OSS') AND (ds.[schoolYear] IN ('2025')) AND (ds.[studentNumber] IN ('229842')) AND (ds.TenantId = 4))  

SELECT [TestType],[TestAdministration],[ARM] From (SELECT DISTINCT  ds.[TestType] as [TestType], ds.[TestAdministration] as [TestAdministration],ds.[ARM] as [ARM],dbo.Ref_Amira_TestAdministration.SortOrder as [Ref_Amira_TestAdministration.SortOrder],ds.[TermDescription]  FROM dbo.AMIRAAVueDS as ds with (nolock)  LEFT JOIN dbo.Ref_Amira_TestAdministration ON ds.[TermDescription] = dbo.Ref_Amira_TestAdministration.TermDescription AND  ds.tenantid =dbo.Ref_Amira_TestAdministration.tenantid    WHERE  ((ds.[Language] NOT IN ('Spanish')) AND (ds.[SchoolYear] IN ('2025')) AND (ds.[StudentNumber] IN ('229842')) AND (ds.TenantId = 4))   ) as T ORDER BY T.[TestType] ASC,T.[Ref_Amira_TestAdministration.SortOrder] ASC,T.[TermDescription] ASC,T.[TestAdministration] ASC 

--=============================================================================================================

SELECT [courseName],[teacherName],[termName],[scoreNumeric] From (SELECT DISTINCT  ds.[courseName] as [courseName], ds.[teacherName] as [teacherName], ds.[termName] as [termName],ds.[scoreNumeric] as [scoreNumeric]  FROM dbo.HCSDSCOREgradingDetailST as ds with (nolock)   WHERE  ((ds.[gradingTask] IN ('Term Average')) AND (ds.[schoolYear] IN ('2025')) AND (ds.[studentNumber] IN ('229842')) AND (ds.TenantId = 4))   ) as T ORDER BY T.[courseName] ASC,T.[termName] ASC 

SELECT [courseName],[teacherName],[termName],[scoreNumeric] From (SELECT DISTINCT  ds.[courseName] as [courseName], ds.[teacherName] as [teacherName], ds.[termName] as [termName],ds.[scoreNumeric] as [scoreNumeric]  FROM dbo.HCSDSCOREgradingDetailST as ds with (nolock)   WHERE  ((ds.[gradingTask] = 'Year End Average') AND (ds.[schoolYear] IN ('2025')) AND (ds.[studentNumber] IN ('229842')) AND (ds.TenantId = 4))   ) as T ORDER BY T.[courseName] ASC,T.[termName] ASC 

Exec sp_depends AttendanceSummary7yrsAV
Exec sp_depends HCSDSCOREgradingDetailSC
Exec sp_depends HCSDSCOREBehavior7yrv2STbehRecordsOnly
Exec sp_depends AMIRAAVueDS  
Exec sp_depends HCSDSCOREgradingDetailST 


--HCSDSCOREBehavior7yrv2STbehRecordsOnly

