--Teacher's
--Aaron Read         || 409038 || aaron_read@whps.org         || Aaron.Read@whps         || Edward Morley Elementary School(Teacher)
--Abigail Esposito	 || 399990 || Abigail_Esposito@whps.org   || Abigail.Esposito@whps   || Conard High School(Teacher)
--Adi Weiss-Hochberg || 452089 || adi_weiss-hochberg@whps.org || Adi.Weiss-Hochberg@whps || Sedgwick Middle School(Teacher)

--Principal's
--Amy Schmelder	|| 302077 || Amy_Schmelder@whps.org || Amy.Schmelder@WHPS || Mary Louise Aiken Elementary School(Principal ES)
--Steven Brouse	|| 302006 || Steven_Brouse@whps.org || Steven.Brouse@WHPS || Sedgwick Middle School(Principal MS)
--Sarah Isaacs	|| 359107 || Sarah_Isaacs@whps.org	|| Sarah.Isaacs@WHPS  || William H. Hall High School(Principal HS)


exec [dbo].[USP_ProfileElementInfoView] @TenantId=38,@ProfileId=180,@FilterValue='187931',@FieldList='Gender,Grade,AgeGroup,SpecialEdStatus,GradeCode,StateStudentId,DistrictStudentId,Presentrate,LastorSurName,FirstName,MiddleName'



exec [dbo].[USP_GetStudentProfileIReadyAssInfoData] @TenantId=38,@DistrictStudentId='187931',@SchoolYear='2026',@IsAllRecord=0,@SubjectName=NULL

exec [dbo].[USP_GetStudentProfileEnrollment] @TenantId='38',@SchoolYear='2026',@DistrictStudentId='187931'

SELECT distinct ds.Presentrate as [Present Rate]  FROM dbo.AggRptK12StudentDetails as ds with (nolock)   WHERE  ((ISNULL(ds.SchoolYear,' ') IN (2026)) AND (ISNULL(ds.DistrictStudentId,' ') IN ('187931')) AND (ds.TenantId = 38))  


select Staff.SchoolYear,Staff.SchoolIdentifier,Staff.SchoolName,Staff.DistrictStaffId,
Staff.TeacherFullName,student.DistrictStudentId,student.StudentName,student.Grade,Staff.Grade,Staff.CourseIdentifier,
Staff.CourseTitle,Staff.SectionIdentifier,Staff.TeachingAssignmentRole,Staff.TenantId 
from AggStaffFilters staff
join  aggplpstudentcoursesections student on staff.TenantId = student.TenantId
and staff.schoolyear = student.schoolyear
and staff.CourseIdentifier = student.CourseIdentifier
and staff.SectionIdentifier = student.SectionIdentifier
and staff.SchoolIdentifier = student.SchoolIdentifier
and staff.GradeCode = student.Grade
where staff.DistrictStaffId = '409038' and staff.SchoolYear = '2026'



select * from main.k12studentsectionenrollment
select * from main.k12staffsectionassignment



 
