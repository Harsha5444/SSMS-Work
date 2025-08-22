SELECT     CONCAT(SchemaName,'.',ViewName) as viewname,    STRING_AGG(quotename(TableName), '   |||   ') WITHIN GROUP (ORDER BY TableName) AS TableNamesFROM     (    SELECT DISTINCT        s.name AS SchemaName,        v.name AS ViewName,        ts.name + '.' + OBJECT_NAME(b.depid) AS TableName    FROM         sys.views v    INNER JOIN         sys.schemas s ON v.schema_id = s.schema_id    LEFT OUTER JOIN         sys.sysdepends b ON v.object_id = b.id    LEFT OUTER JOIN         sys.tables t ON OBJECT_NAME(b.depid) = t.name    LEFT OUTER JOIN         sys.schemas ts ON t.schema_id = ts.schema_id    WHERE         v.object_id in (OBJECT_ID('MSAD75_EnrollmentEndStudents_VW'))    ) AS SubqueryGROUP BY    SchemaName,    ViewName;SELECT     CONCAT(SchemaName, '.', ViewName) AS viewname,    STRING_AGG(TableName, '  |||  ') WITHIN GROUP (ORDER BY TableName) AS TableNamesFROM     (    SELECT DISTINCT        s.name AS SchemaName,        v.name AS ViewName,        ts.name + '.' + OBJECT_NAME(b.depid) AS TableName    FROM         sys.views v    INNER JOIN         sys.schemas s ON v.schema_id = s.schema_id    LEFT OUTER JOIN         sys.sysdepends b ON v.object_id = b.id    LEFT OUTER JOIN         sys.tables t ON OBJECT_NAME(b.depid) = t.name    LEFT OUTER JOIN         sys.schemas ts ON t.schema_id = ts.schema_id    WHERE         v.name IN ('MSAD75_StaffPV_AgeGroup',
'MSAD75_StaffPV_ratio_vw')


    ) AS SubqueryGROUP BY    SchemaName,    ViewName;(
'dbo.MSAD75_ICStudents'
,'dbo.MSAD75_EnrollmentEndStudents_VW'
,'dbo.AggRptK12StudentDetails'
,'dbo.MSAD75_RacePR_VW'
,'dbo.RaceNonWhite_VW'
,'dbo.MSAD75_PV_ELL_YearWiseCnt'
)