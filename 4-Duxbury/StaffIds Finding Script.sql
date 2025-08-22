select * from reffiletemplates where tenantid = 26

select * from Main.WHPS_Teachers where tenantid = 26 and (first_name like '%McDonough%' or LAST_NAME like '%McDonough%')

select * from main.K12StaffEmployment where tenantid = 26
select FirstName,LastOrSurname,DistrictStaffId from main.K12Staffdemographics where tenantid = 26 and DistrictStaffId = '111037892'

select distinct FirstName,LastName,LocalID,type from main.Duxbury_StaffDemographics
where tenantid = 26
and (firstname like 'Walsh' or lastname like 'Walsh') 

WITH TeacherList AS (
    SELECT *
FROM (VALUES
    (1, 'Hanlon', 'Grade 3'),
    (2, 'Miele', 'Grade 3'),
    (3, 'McDonough', 'Grade 3'),
    (4, 'Santos', 'Grade 3'),
    (5, 'Martin', 'Grade 3'),
    (6, 'Murray', 'Grade 3'),
    (7, 'Nissi', 'Grade 3'),
    (8, 'Hastings-Ely', 'Grade 3'),
    (9, 'Doel', 'Grade 3'),
    (10, 'Barach', 'Grade 3'),
    (11, 'Ball', 'Grade 4'),
    (12, 'Fryar', 'Grade 4'),
    (13, 'Aufiero', 'Grade 4'),
    (14, 'Morgan', 'Grade 4'),
    (15, 'Stadelmann', 'Grade 4'),
    (16, 'Sulkala', 'Grade 4'),
    (17, 'Rinkus', 'Grade 4'),
    (18, 'Sheptyck', 'Grade 4'),
    (19, 'Wigmore', 'Grade 4'),
    (20, 'Armstrong', 'Grade 5'),
    (21, 'McNeil', 'Grade 5'),
    (22, 'Scully', 'Grade 5'),
    (23, 'Crago', 'Grade 5'),
    (24, 'Murphy', 'Grade 5'),
    (25, 'Thompson', 'Grade 5'),
    (26, 'Riser', 'Grade 5'),
    (27, 'Kelly', 'Grade 5'),
    (28, 'Holt', 'Grade 5'),
    (29, 'Tam', 'Grade 5')
) AS t(RowNum, Name, Grade)
)
SELECT distinct
    tl.RowNum,
    tl.Grade,
    tl.Name AS ExcelName,
    sd.FirstName,
    sd.LastName,
    sd.LocalID
    --sd.Type
FROM TeacherList tl
JOIN main.Duxbury_StaffDemographics sd
    ON sd.TenantId = 26
   AND sd.LastName = tl.Name
Where sd.LocalID is not null --and sd.Type = 'Teacher'
ORDER BY tl.RowNum;



WITH TeacherList AS (
    SELECT *
FROM (VALUES
    -- Grade K
    (1, 'Susan', 'Green', 'Grade K'),
    (2, 'Julie', 'Connor', 'Grade K'),
    (3, 'Natalie', 'Priscella', 'Grade K'),
    (4, 'Chris', 'Burke', 'Grade K'),
    (5, 'Sara', 'Gaynor', 'Grade K'),
    (6, 'Amanda', 'Todd', 'Grade K'),
    (7, 'Merissa', 'Walsh', 'Grade K'),
    (8, 'Mia', 'Sullivan', 'Grade K'),
    (9, 'MaKayla', 'Silva', 'Grade K'),
    (10, 'Julia', 'Smith', 'Grade K'),

    -- Grade 1
    (11, 'Bridget', 'Henderson', 'Grade 1'),
    (12, 'Molly', 'Strauss', 'Grade 1'),
    (13, 'Jesse', 'Keith', 'Grade 1'),
    (14, 'Cassandra', 'Sweeney', 'Grade 1'),
    (15, 'Caitlin', 'Fawcett', 'Grade 1'),
    (16, 'Kristina', 'Josselyn', 'Grade 1'),
    (17, 'Merissa', 'Walsh', 'Grade 1'),
    (18, 'Nicki', 'Hart', 'Grade 1'),
    (19, 'Sara', 'Gaynor', 'Grade 1'),
    (20, 'Katherine', 'Katapodis', 'Grade 1'),
    (21, 'Amy', 'Lugas', 'Grade 1'),

    -- Grade 2
    (22, 'Melissa', 'Faherty', 'Grade 2'),
    (23, 'Amy', 'Lugas', 'Grade 2'),
    (24, 'Jess', 'Siegel', 'Grade 2'),
    (25, 'Caitlin', 'Fawcett', 'Grade 2'),
    (26, 'Maura', 'Doyle', 'Grade 2'),
    (27, 'Haley', 'Reardon', 'Grade 2'),
    (28, 'Kendall', 'Hoover', 'Grade 2'),
    (29, 'Katie', 'daGraca', 'Grade 2'),
    (30, 'Merissa', 'Walsh', 'Grade 2'),
    (31, 'Kate', 'Dunn', 'Grade 2'),
    (32, 'Sara', 'Gaynor', 'Grade 2')
) AS t(OrderNum, First, Last, Grade)
)
SELECT distinct
    tl.OrderNum,
    tl.First + ' ' + tl.Last AS ExcelName,
    sd.FirstName,
    sd.LastName,
    sd.LocalID
    --sd.Type
FROM TeacherList tl
LEFT JOIN main.Duxbury_StaffDemographics sd
    ON sd.TenantId = 26
   AND (
        sd.FirstName = tl.First 
        or
        sd.LastName = tl.Last
    )
Where sd.LocalID is not null and tl.OrderNum in (12)
ORDER BY OrderNum;



WITH TeacherList AS (
    SELECT *
    FROM (VALUES
        (1, 'Theophilos', 'Other Teacher'),
        (2, 'Newcomb', 'Other Teacher'),
        (3, 'Goode', 'Other Teacher'),
        (4, 'Lincoln', 'Other Teacher'),
        (5, 'Aldrich', 'Other Teacher'),
        (6, 'McKay', 'Other Teacher'),
        (7, 'DiBona', 'Other Teacher'),
        (8, 'Rossetti', 'Other Teacher'),
        (9, 'Files Goulding', 'Other Teacher'),
        (10, 'Keniley', 'Other Teacher')
    ) AS t(RowNum, Name, Grade)
)
SELECT DISTINCT
    tl.RowNum,
    tl.Grade,
    tl.Name AS ExcelName,
    sd.FirstName,
    sd.LastName,
    sd.LocalID
    --,sd.Type
FROM TeacherList tl
JOIN main.Duxbury_StaffDemographics sd
    ON sd.TenantId = 26
   AND sd.LastName = tl.Name
WHERE sd.LocalID IS NOT NULL --AND sd.Type = 'Teacher'
ORDER BY tl.RowNum;
