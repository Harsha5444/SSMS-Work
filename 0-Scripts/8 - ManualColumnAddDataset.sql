INSERT INTO [IDM].[DataSetColumn] 
([TableName], [ColumnName], [AliasName], [Function], [SortOrder], [SortType], [IsConditionalColumn], 
 [Value], [Maincondition], [ColumnCondition], [IsJoinColumn], [DomainRelatedViewId], [ColumnSchema], 
 [DataType], [IsMainTable], [Formula], [IsFormulaColumn], [TenantId], [StatusId], [CreatedBy], 
 [CreatedDate], [ModifiedBy], [ModifiedDate])  
SELECT 'HCS_CORE_students_7yr_v2', 'schoolID', 'schoolID', NULL, 46, NULL, 0, NULL, NULL, NULL, 0, 
       355, 'dbo', 'varchar', 0, '[HCS_CORE_students_7yr_v2].[schoolID]', 0, 4, 1, 
       '33631@HenryInsights', GETDATE(), NULL, NULL;  

INSERT INTO [dbo].[RptViewFields] 
([DomainRelatedViewId], [ColumnName], [DisplayName], [DataType], [LookupTable], [LookupColumn], 
 [ColumnTableName], [SortOrder], [TenantId], [StatusId], [CreatedBy], [CreatedDate], [ModifiedBy], 
 [ModifiedDate], [SortbyColumnName])  
SELECT 355, '[schoolID]', 'schoolID', 'varchar', NULL, NULL, NULL, 47, 4, 1, '33631@HenryInsights', 
       GETDATE(), NULL, NULL, NULL;  


select * from dbo.RptViewFields where DomainRelatedViewId='355'
select * from IDM.DataSetColumn where DomainRelatedViewId='355'
select * from dbo.RptDomainRelatedViews where DomainRelatedViewId='355'



