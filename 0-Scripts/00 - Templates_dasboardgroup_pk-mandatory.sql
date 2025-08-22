--dashboard list with groups
SELECT 
    dgd.DashboardGroupDefID, 
    dgd.GroupName,
	d.DashboardId,
    COALESCE(d.DashboardName, 'No Dashboard Assigned') AS DashboardName
FROM Dashboardgroupdef dgd
LEFT JOIN Dashboardgroups dg ON dgd.DashboardGroupDefID = dg.DashboardGroupDefID
right JOIN Dashboard d ON dg.DashboardId = d.DashboardId
where d.DashboardName <>''
ORDER BY dgd.DashboardGroupDefID desc,d.DashboardName 



--dynamic template list with pk mandatory 
SELECT 
    ftf.FileTemplateId, 
	ref.FileTemplateName,  
    COALESCE(
        STRING_AGG(CASE WHEN ftf.IsPrimaryKey = 1 THEN ftf.FieldName END, ', '), 
        ''
    ) AS PKColumns, 
    COALESCE(
        STRING_AGG(CASE WHEN ftf.IsMandatory = 1 THEN ftf.FieldName END, ', '), 
        ''
    ) AS MandatoryColumns 
FROM dbo.FileTemplateField ftf
join reffiletemplates ref on ref.filetemplateid = ftf.filetemplateid
WHERE ftf.FileTemplateId IN (
    SELECT FileTemplateId FROM reffiletemplates WHERE IsDynamic = 1
)
GROUP BY ftf.FileTemplateId,ref.FileTemplateName

