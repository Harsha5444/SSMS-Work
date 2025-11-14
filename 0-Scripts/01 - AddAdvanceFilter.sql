-- Declare your new JSON content
DECLARE @NewAdvanceFilter NVARCHAR(MAX) 
= N'[{"DisplayName":"SchoolYear","ColumnName":"SchoolYear","AliasName":"School Year","SortOrder":0,"FiledId":"78671","DefaultValue":null,"RoleNames":null},{"DisplayName":"SchoolName","ColumnName":"SchoolName","AliasName":"School Name","SortOrder":0,"FiledId":"78673","DefaultValue":null,"RoleNames":null},{"DisplayName":"Grade","ColumnName":"Grade","AliasName":"Grade","SortOrder":0,"FiledId":"78657","DefaultValue":null,"RoleNames":null},{"DisplayName":"gender","ColumnName":"gender","AliasName":"Gender","SortOrder":0,"FiledId":"78661","DefaultValue":null,"RoleNames":null},{"DisplayName":"504Status","ColumnName":"504Status","AliasName":"504 Status","SortOrder":0,"FiledId":"78658","DefaultValue":null,"RoleNames":null},{"DisplayName":"SpecialEdStatus","ColumnName":"SpecialEdStatus","AliasName":"Special Education Status","SortOrder":0,"FiledId":"78659","DefaultValue":null,"RoleNames":null},{"DisplayName":"ell","ColumnName":"ell","AliasName":"ELL","SortOrder":0,"FiledId":"78660","DefaultValue":null,"RoleNames":null},{"DisplayName":"highneeds","ColumnName":"highneeds","AliasName":"High Needs","SortOrder":0,"FiledId":"78653","DefaultValue":null,"RoleNames":null},{"DisplayName":"Race","ColumnName":"Race","AliasName":"Race/Ethnicity","SortOrder":0,"FiledId":"78654","DefaultValue":null,"RoleNames":null},{"DisplayName":"Teacher","ColumnName":"Teacher","AliasName":"Teacher","SortOrder":0,"FiledId":"78675","DefaultValue":null,"RoleNames":null},{"DisplayName":"counselor","ColumnName":"counselor","AliasName":"Counselor","SortOrder":0,"FiledId":"78655","DefaultValue":null,"RoleNames":null},{"DisplayName":"dept","ColumnName":"dept","AliasName":"Dept","SortOrder":0,"FiledId":"78656","DefaultValue":null,"RoleNames":null},{"DisplayName":"termname","ColumnName":"termname","AliasName":"Term Name","SortOrder":0,"FiledId":"78651","DefaultValue":null,"RoleNames":null},{"DisplayName":"OpenChoice","ColumnName":"OpenChoice","AliasName":"Open Choice","SortOrder":0,"FiledId":"78684","DefaultValue":null,"RoleNames":null},{"DisplayName":"AssessmentYear","ColumnName":"AssessmentYear","AliasName":"Assessment Year","SortOrder":0,"FiledId":"78733","DefaultValue":"2026","RoleNames":null}]';

--select rd.ReportDetailsId,JSON_MODIFY(rd.ReportFileDetails, '$.AdvanceFilter', JSON_QUERY(@NewAdvanceFilter))
--FROM reportdetails rd
--WHERE rd.tenantid = 38
--  AND rd.ReportDetailsId IN (
--      9003,9004,9005,9006,9007,9008,9009,9010,
--      8868,8870,8878,8879,8880,8881,8882,
--      8890,8891,8892,8893,8894,8895,8907,8908,8909,8910,
--      8911,8912,8913,8914,8920,8921,8922,8923,8924,8925,8926,8927
--  );

------ Perform the update
--UPDATE rd
--SET rd.ReportFileDetails = JSON_MODIFY(rd.ReportFileDetails, '$.AdvanceFilter', JSON_QUERY(@NewAdvanceFilter))
--FROM reportdetails rd
--WHERE rd.tenantid = 38
--  AND rd.ReportDetailsId IN (
--      9003,9004,9005,9006,9007,9008,9009,9010,
--      8868,8870,8878,8879,8880,8881,8882,
--      8890,8891,8892,8893,8894,8895,8907,8908,8909,8910,
--      8911,8912,8913,8914,8920,8921,8922,8923,8924,8925,8926,8927
--  );

--exec USP_GetReportDetailsALL @ReportDetailsId='9003',@tenantId=38,@ChildReportDetailsID=NULL,@Statusid=1,@IsDynamicReport=NULL,@ReportTypeCode=NULL,@ReportCode=NULL


--select * from ReportRolesAdvanceFilter where ReportDetailsId='9007'



--INSERT INTO ReportRolesAdvanceFilter (ReportDetailsId,DisplayName,ColumnName,AliasName,SortOrder,FiledId,DefaultValue,RoleID,TenantId,StatusId,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate) SELECT value,'AssessmentYear','AssessmentYear','Assessment Year',0,78733,'2026',NULL,38,1,'Analyticvue.Admin@WHPS',GETDATE(),NULL,NULL FROM STRING_SPLIT('9003,9004,9005,9006,9007,9008,9009,9010,8868,8870,8878,8879,8880,8881,8882,8890,8891,8892,8893,8894,8895,8907,8908,8909,8910,8911,8912,8913,8914,8920,8921,8922,8923,8924,8925,8926,8927',',') s WHERE NOT EXISTS (SELECT 1 FROM ReportRolesAdvanceFilter r WHERE r.ReportDetailsId = s.value AND r.FiledId = 78733);


--update ReportRolesAdvanceFilter set DefaultValue=2025
--where ReportDetailsId in (8879,8892,8907,8920)
--and FiledId=78733 and tenantid = 38


--8879,8892,8907,8920