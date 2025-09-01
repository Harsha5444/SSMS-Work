ALTER VIEW [dbo].[Import_K12StaffSectionAssignment_CoTeachers_Vw_26]
AS
--- Susan Green & Julie Connor		112036579	112031301
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'112031301' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('112036579') and TenantId=26 and SchoolYear=2026

--- Natalie Priscella & Julie Connor		114038175	112031301
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'112031301' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('114038175') and TenantId=26 and SchoolYear=2026

--- Chris Burke & Sara Gaynor		111030656	112038415
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'112038415' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('111030656') and TenantId=26 and SchoolYear=2026

--- Amanda Todd & Merissa Walsh		112038832	112033986
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'112033986' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('112038832') and TenantId=26 and SchoolYear=2026


--- Mia Sullivan & MaKayla Silva		114038632	114038726
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'114038726' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('114038632') and TenantId=26 and SchoolYear=2026

--- Julia Smith & MaKayla Silva		114038843	114038726
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'114038726' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('114038843') and TenantId=26 and SchoolYear=2026

--- Bridget Henderson & Molly Strauss		112032348  122045727
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'122045727' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('112032348') and TenantId=26 and SchoolYear=2026

--- Jesse Keith & Molly Strauss			114038650	122045727
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'122045727' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('114038650') and TenantId=26 and SchoolYear=2026

--- Cassandra Sweeney & Caitlin Fawcett		114038173	112035083
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'112035083' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('114038173') and TenantId=26 and SchoolYear=2026

--- Kristina Josselyn & Merissa Walsh		114038818	112033986
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'112033986' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('114038818') and TenantId=26 and SchoolYear=2026

--- Nicki Hart & Sara Gaynor		112038495	112038415
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'112038415' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('112038495') and TenantId=26 and SchoolYear=2026

--- Katherine Katapodis & Amy Lugas		112035815	112027177
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'112027177' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('112035815') and TenantId=26 and SchoolYear=2026

--- Melissa Faherty & Amy Lugas		114038875	112027177
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'112027177' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('114038875') and TenantId=26 and SchoolYear=2026

--- Jess Siegel & Caitlin Fawcett		112026830	112035083
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'112035083' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('112026830') and TenantId=26 and SchoolYear=2026

--- Maura Doyle & Haley Reardon		112030224	114038847
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'114038847' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('112030224') and TenantId=26 and SchoolYear=2026

--- Kendall Hoover & Haley Reardon		114038814	114038847
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'114038847' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('114038814') and TenantId=26 and SchoolYear=2026

--- Katie daGraca & Merissa Walsh		112035384	112033986
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'112033986' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('112035384') and TenantId=26 and SchoolYear=2026

--- Kate Dunn & Sara Gaynor		112034585	112038415
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'112038415' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('112034585') and TenantId=26 and SchoolYear=2026

--McDonough		Lincoln		111037892	111037803
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'111037803' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('111037892') and TenantId=26 and SchoolYear=2026

--Santos	Lincoln	-		111037536	111037803
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'111037803' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('111037536') and TenantId=26 and SchoolYear=2026

--Martin	- 	McKay		125126579	- 	121043203
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'121043203' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('125126579') and TenantId=26 and SchoolYear=2026

--Murray	- 	McKay		113031374	- 	121043203
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'121043203' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('113031374') and TenantId=26 and SchoolYear=2026

--Nissi		Aldrich				111038395	111031477
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'111031477' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('111038395') and TenantId=26 and SchoolYear=2026	

--Nissi		DiBona				111038395	114035471
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'114035471' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('111038395') and TenantId=26 and SchoolYear=2026

--Hastings-Ely	Aldrich		111035862	111031477
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'111031477' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('111035862') and TenantId=26 and SchoolYear=2026

--Hastings-Ely	DiBona		111035862	114035471
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'114035471' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('111035862') and TenantId=26 and SchoolYear=2026

--Ball	Rossetti	 111030784	111028778
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'111028778' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('111030784') and TenantId=26 and SchoolYear=2026

--Ball  DiBona		 111030784	114035471
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'114035471' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('111030784') and TenantId=26 and SchoolYear=2026

--Fryar		Rossetti	113036449	111028778
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'111028778' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('113036449') and TenantId=26 and SchoolYear=2026

--Fryar		DiBona		113036449	114035471
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'114035471' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('113036449') and TenantId=26 and SchoolYear=2026

--Aufiero	-	McKay		112034880	-	121043203
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'121043203' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('112034880') and TenantId=26 and SchoolYear=2026

--Morgan	-	McKay		111031886	-	121043203
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'121043203' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('111031886') and TenantId=26 and SchoolYear=2026

--Stadelmann	-	McKay		111031805	-	121043203
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'121043203' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('111031805') and TenantId=26 and SchoolYear=2026

--Stadelmann	-	Keniley		111031805	-	114038307
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'114038307' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('111031805') and TenantId=26 and SchoolYear=2026

--Sulkala	-	McKay		111034800	-	121043203
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'121043203' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('111034800') and TenantId=26 and SchoolYear=2026

--Sulkala	-	Keniley		111034800	-	114038307
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'114038307' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('111034800') and TenantId=26 and SchoolYear=2026

--Sheptyck	Files-Goulding	-		111029310	113035447
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'113035447' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('111029310') and TenantId=26 and SchoolYear=2026

--Wigmore	Files-Goulding	-		111033655	113035447
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'113035447' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('111033655') and TenantId=26 and SchoolYear=2026

--Armstrong		Theophilos		111021501	111036916	
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'111036916' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('111021501') and TenantId=26 and SchoolYear=2026

--Armstrong		DiBona			111021501	114035471	
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'114035471' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('111021501') and TenantId=26 and SchoolYear=2026

--McNeil	Theophilos		125121185	111036916
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'111036916' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('125121185') and TenantId=26 and SchoolYear=2026

--McNeil	DiBona			125121185	114035471
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'114035471' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('125121185') and TenantId=26 and SchoolYear=2026

--Scully	Newcomb		111020745	111028282
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'111028282' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('111020745') and TenantId=26 and SchoolYear=2026

--Scully	Keniley		111020745	114038307
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'114038307' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('111020745') and TenantId=26 and SchoolYear=2026

--Crago		Newcomb		114038211	111028282
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'111028282' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('114038211') and TenantId=26 and SchoolYear=2026

--Crago		Keniley		114038211	114038307
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'114038307' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('114038211') and TenantId=26 and SchoolYear=2026

--Murphy	Goode		112035667	114038423
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'114038423' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('112035667') and TenantId=26 and SchoolYear=2026

--Murphy	DiBona		112035667	114035471
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'114035471' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('112035667') and TenantId=26 and SchoolYear=2026

--Murphy	Keniley		112035667	114038307
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'114038307' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('112035667') and TenantId=26 and SchoolYear=2026

--Thompson	Goode		114038648	114038423
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'114038423' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('114038648') and TenantId=26 and SchoolYear=2026

--Thompson	DiBona		114038648	114035471
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'114035471' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('114038648') and TenantId=26 and SchoolYear=2026

--Thompson	Keniley		114038648	114038307
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'114038307' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('114038648') and TenantId=26 and SchoolYear=2026

--Holt	-	McKay		114038855	-	121043203
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'121043203' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('114038855') and TenantId=26 and SchoolYear=2026

--Tam	-	McKay		111032779	-	121043203
UNION
SELECT DISTINCT SchoolYear,LEAIdentifier,SchoolIdentifier,'121043203' DistrictStaffId,CourseIdentifier
,SectionIdentifier,'Teacher' TeachingAssignmentRole,NULL AssignmentStartDate,NULL AssignmentEndDate
,NULL TeacherOfRecord,NULL TeachingAssignmentContributionPercentage,NULL ClassroomPositionType
,NULL HighlyQualifiedTeacherIndicator
FROM Main.K12StaffSectionAssignment where DistrictStaffId in('111032779') and TenantId=26 and SchoolYear=2026


