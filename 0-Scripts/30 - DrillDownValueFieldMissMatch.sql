select 
    a.LinkedReportMappedFiledsId,
    b.ReportDetailsId as ParentReportDetailsId,
    c.ReportDetailsId as ChildReportDetailsId,
    b.ReportDetailsName as ParentReportDetailsName,
    d.ReportTypeDescription,
    c.ReportDetailsName as ChildReportDetailsName,
    a.ParentCode,
    a.ParentColumnName, 
    a.ChildCode, 
    a.ChildColumnName,
    a.IsValueField,
    a.DisplayName,
    a.TenantId,
    a.StatusId
from LinkedReportMappedFileds a with (nolock) 
join Reportdetails b with (nolock)  
    on a.TenantId = b.tenantid 
   and a.reportdetailsid = b.reportdetailsid
left join Reportdetails c with (nolock)  
    on a.TenantId = c.TenantId 
   and a.ChildReportId = c.ReportDetailsId
join RefReportType d with (nolock)
    on b.ReportTypeId = d.ReportTypeId 
   and b.tenantid = d.TenantId
where 1=1
and a.TenantId = 38 --and d.ReportTypeDescription = 'Chart'
and a.IsValueField = 1
and a.childcode is not null


--update a
--set ChildCode=null , ChildColumnName =null
--from LinkedReportMappedFileds a where LinkedReportMappedFiledsId in (107150, 107163, 106809, 107184, 107197, 107231, 107329, 107381, 107629, 107401, 107286, 107361, 106788, 111707, 106831, 106973)

--update a
--set ChildCode=null , ChildColumnName =null
--from LinkedReportMappedFileds a where LinkedReportMappedFiledsId in (113449)
