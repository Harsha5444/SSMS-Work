select * from HCS_ProcessLogStatistics order by logstatid desc

SELECT distinct
    o.type_desc AS ObjectType,
    SCHEMA_NAME(o.schema_id) AS SchemaName,
    o.name AS ObjectName,
    o.create_date,
    o.modify_date
FROM 
    sys.sql_expression_dependencies d
INNER JOIN 
    sys.objects o ON d.referencing_id = o.object_id
INNER JOIN 
    sys.objects ro ON d.referenced_id = ro.object_id
WHERE 
    ro.name = 'HCS_Assessment_AMIRAUsage'
    AND ro.type = 'U' -- User tables only
    AND o.type IN ('V', 'P', 'FN', 'IF', 'TF') -- Views, Stored Procedures, Functions
ORDER BY 
    o.type_desc, 
    SchemaName, 
    ObjectName;

select* from RptDomainRelatedViews where viewname = 'dbo.HCSAMIRAUsageDS'
--update a set DataType = 'int' from rptviewfields a where domainrelatedviewid = 415 and RptViewFieldsId=37709
--update a set DataType = 'int' from idm.datasetcolumn a where domainrelatedviewid = 415 and DataSetColumnId=64945

select * from reffiletemplates where filetemplatename like '%amira%'
select COUNT(*) from main.HenryInsights_AMIRA_Usage -- 121826

select top 100 * from main.HenryInsights_AMIRA_Usage -- 121826

select * from TenantFileTemplateMapper where filetemplateid = 162

select * from TenantTemplateFieldMapper where TenantFileTemplateMapperId=443

select * from ErrorLogForUSP order by 1 desc



--delete from dbo.HCS_Assessment_AMIRAUsage where weeknumber = 12 
--delete from dbo.HCS_Assessment_AMIRAUsage_audit where weeknumber = 12 



--delete from main.HenryInsights_AMIRA_Usage where [Week] = '12'
--delete from Stage.HenryInsights_AMIRA_Usage_Audit  where [Week] = '12'
--delete from Stage.HenryInsights_AMIRA_Usage_NoAction  where [Week] = '12'
--delete from Stage.HenryInsights_AMIRA_Usage_FailedRecords  where [Week] = '12'


select distinct subject from dbo.HCS_Assessment_iReady