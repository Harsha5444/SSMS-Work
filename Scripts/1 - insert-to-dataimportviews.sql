INSERT INTO DataImportViews
(
    viewname,
    displayname,
    tenantid,
    StatusId,
    sortorder,
    CreatedBy,
    CreatedDate
)
VALUES
('Import_k12StudentSectionResults_Vw_52', 'Import_k12StudentSectionResults_Vw_52', 52, 1, 26, 'DDAUser@DDA', GETDATE())


select * from DataImportViews where tenantid = 52


