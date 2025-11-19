CREATE VIEW [dbo].[WHPS_PATLevelMovementStudent_Vw] --29976
AS
with StudentDetails as (
select 
DistrictStudentId,FirstName,MiddleName,LastorSurname,StudentFullName,BirthDate,SchoolYear,LEAIdentifier,SchoolIdentifier,LeaName
,SchoolName,Gender,Grade,MilitaryAffiliated,Truant,SchoolCategory,Race,Migrant,GiftedandTalented,Tribal,EnrollmentBeginDate
,EnrollmentEndDate,GenderCode,GradeCode,MilitaryAffiliatedCode,SchoolCategoryCode,TribalCode,DropOut,ELL,Graduate,
MembershipDaysCount,PresentDaysCount,AbsentDaysCount,UA_AbsentDaysCount,IsChronic,AbsentPercentage,AgeGroup,DropOutReason,
TardyDaysCount,Presentrate,AbsentRate,TardyRate,ExitType,ExitStatus,CohortGraduationYear,CurrentMonthAttendance,
PreviousMonthAttendance,StateStudentId,FRL,DisabilityStatus,DisabilityReason,
SpecialEdStatus,[504Status],TenantId,Ethnicity,IepStatus,HispanicLatino,FosterChild,Homeless,HomeLanguage,
EllProgram,CountryOfOrigon,Team,FEL,SchoolType,HighNeeds,IEP
from AggRptK12StudentDetails where tenantid = 38
),
WHPS_PAT_StudentStandards as (  --before used this view [WHPSPAT_StudentStandards] replaced with cte
SELECT distinct WHPS_StudentStandards.[SchoolId] AS [SchoolId]
	,WHPS_StudentStandards.[identifier] AS [identifier]
	,WHPS_StudentStandards.[name] AS [name]
	,WHPS_StudentStandards.[parentstandardid] AS [parentstandardid]
	,WHPS_StudentStandards.[parentstandardid_nvl] AS [parentstandardid_nvl]
	,'Level - ' + convert(VARCHAR, WHPS_StudentStandards.[standardgrade]) AS [standardgrade]
	,WHPS_StudentStandards.[standardid] AS [standardid]
	,CASE 
		WHEN [storecode] = 'Q2'
			THEN 'Q3'
		ELSE [storecode]
		END AS [storecode]
	,WHPS_StudentStandards.[student_number] AS [student_number]
	,WHPS_StudentStandards.[studentid] AS [studentid]
	,WHPS_StudentStandards.[studentsdcid] AS [studentsdcid]
	,WHPS_StudentStandards.[SchoolYear] AS [SchoolYear]
	,WHPS_StudentStandards.TenantId
FROM Main.WHPS_StudentStandards AS WHPS_StudentStandards
WHERE (WHPS_StudentStandards.identifier LIKE '%PAT.%')
	AND WHPS_StudentStandards.standardgrade IS NOT NULL
	AND WHPS_StudentStandards.TenantId = 38
),
StandardsFallToWinter as (
SELECT a.SchoolYear
	,[Name]
	,'Q1 - Q3' as StoreCode
	,'Fall - Winter' AS Term
	,isnull(a.[Q1], 'No Score') as  FromLevel
	,isnull(a.[Q3], 'No Score') as ToLevel
	,CASE 
            WHEN CAST(REPLACE(a.[Q3], 'Level - ', '') AS INT) - CAST(REPLACE(a.[Q1], 'Level - ', '') AS INT) > 0 THEN 'Level Up'
            WHEN CAST(REPLACE(a.[Q3], 'Level - ', '') AS INT) - CAST(REPLACE(a.[Q1], 'Level - ', '') AS INT) < 0 THEN 'Level Down'
            WHEN CAST(REPLACE(a.[Q3], 'Level - ', '') AS INT) - CAST(REPLACE(a.[Q1], 'Level - ', '') AS INT) = 0 THEN 'Equal'
            ELSE 'No Movement'
        END AS [Status]
	,a.student_number as  DistrictStudentId
	,a.Tenantid
FROM ( SELECT SchoolYear ,student_number ,[name] ,storecode ,STANDARDGRADE ,TenantId
FROM WHPS_PAT_StudentStandards ) T
PIVOT(MAX(STANDARDGRADE) FOR storecode IN ([Q1],[Q3])) A
),
StandardsWinterToSpring as (
SELECT a.SchoolYear
	,a.[Name]
	,'Q3 - Q4' as StoreCode
	,'Winter - Spring' AS Term
	,isnull(a.[Q3], 'No Score') as FromLevel
	,isnull(a.[Q4], 'No Score') as  ToLevel
	,CASE 
            WHEN CAST(REPLACE(a.[Q4], 'Level - ', '') AS INT) - CAST(REPLACE(a.[Q3], 'Level - ', '') AS INT) > 0 THEN 'Level Up'
            WHEN CAST(REPLACE(a.[Q4], 'Level - ', '') AS INT) - CAST(REPLACE(a.[Q3], 'Level - ', '') AS INT) < 0 THEN 'Level Down'
            WHEN CAST(REPLACE(a.[Q4], 'Level - ', '') AS INT) - CAST(REPLACE(a.[Q3], 'Level - ', '') AS INT) = 0 THEN 'Equal'
            ELSE 'No Movement'
        END AS [Status]
	,a.student_number as  DistrictStudentId
	,a.Tenantid
FROM ( SELECT SchoolYear ,student_number ,[name] ,storecode ,STANDARDGRADE ,TenantId
FROM WHPS_PAT_StudentStandards ) T
PIVOT(MAX(STANDARDGRADE) FOR storecode IN ([Q3],[Q4])) A
),
StudentStandards as (
select SchoolYear,[Name],StoreCode,Term,FromLevel,ToLevel,[Status],DistrictStudentId,Tenantid
from StandardsFallToWinter
union all 
select SchoolYear,[Name],StoreCode,Term,FromLevel,ToLevel,[Status],DistrictStudentId,Tenantid
from StandardsWinterToSpring
)
SELECT agg.[SchoolYear]
	,ss.[Name]
	,ss.[StoreCode]
	,ss.[Term]
	,ss.[FromLevel]
	,ss.[ToLevel]
	,ss.[Status]
	,agg.[DistrictStudentId]
	,agg.[StudentFullName]
	,agg.[SchoolIdentifier]
	,agg.[SchoolCategory]
	,agg.[SchoolName]
	,agg.[Gender]
	,agg.[Grade]
	,agg.[Truant]
	,agg.[Race]
	,agg.[Migrant]
	,agg.[GiftedandTalented]
	,agg.[Tribal]
	,agg.[EnrollmentBeginDate]
	,agg.[EnrollmentEndDate]
	,agg.[GenderCode]
	,agg.[TribalCode]
	,agg.[ELL]
	,agg.[StateStudentId]
	,agg.[FRL]
	,agg.[SpecialEdStatus]
	,agg.[504Status]
	,agg.[IepStatus]
	,agg.[EllProgram]
	,agg.[FEL]
	,agg.[HighNeeds]
	,isnull(agg.[IEP],'No') as [IEP]
	,agg.[Tenantid]
	,IsNull(CASE 
            WHEN agg.IsChronic = 1 THEN 'Yes'
            WHEN agg.IsChronic = 0 THEN 'No'
        END, 'No') AS IsChronic,
	agg.MembershipDaysCount,
    agg.PresentDaysCount,
    agg.AbsentDaysCount,
    agg.AbsentPercentage,
    agg.Presentrate,
    agg.AbsentRate,
    agg.CurrentMonthAttendance
FROM StudentDetails agg
JOIN StudentStandards ss ON agg.SchoolYear = ss.SchoolYear
	AND agg.TenantId = ss.TenantId
	AND agg.DistrictStudentId = ss.DistrictStudentId
GO


