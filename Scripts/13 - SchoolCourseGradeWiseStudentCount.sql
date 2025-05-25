declare @tenantid int,
        @courseidentifier varchar(50),
        @schoolidentifier varchar(50),
        @grade varchar(10),
        @districtstudentid varchar(50)

set @tenantid = 51
set @courseidentifier = null 
set @schoolidentifier = null 
set @grade = null
set @districtstudentid = null

IF @Tenantid IN (17,18,29,33,39,34,40,41,42,43,45)
BEGIN
    USE AnalyticVue_District;
END
ELSE IF @Tenantid in (28,35,36,37)
BEGIN
    USE AnalyticVue_FPS;
END
ELSE IF @Tenantid = 50
BEGIN
    USE AnalyticVue_Clayton;
END
ELSE IF @Tenantid IN (20,26,27,30,38,31,44)
BEGIN
    USE AnalyticVue_OBS;
END
ELSE IF @Tenantid = 47
BEGIN
    USE AnalyticVue_Hallco;
END
ELSE IF @Tenantid in (46,48,49,51,52)
BEGIN
    USE AnalyticVue_Norwood;
END


declare @whereclause nvarchar(max) = ' where a.tenantid = @tenantid '

if @courseidentifier is not null
    set @whereclause = @whereclause + ' and b.courseidentifier = @courseidentifier '
if @schoolidentifier is not null
    set @whereclause = @whereclause + ' and a.schoolidentifier = @schoolidentifier '
if @grade is not null
    set @whereclause = @whereclause + ' and a.grade = @grade '
if @districtstudentid is not null
    set @whereclause = @whereclause + ' and a.districtstudentid = @districtstudentid '

declare @school_course_wise nvarchar(max) = '
select 
    a.schoolname,
    b.coursetitle,
    count(distinct a.districtstudentid) as studentcount
from aggrptk12studentdetails a
inner join aggplpstudentcoursesections b on
    a.districtstudentid = b.districtstudentid
    and a.schoolyear = b.schoolyear
    and a.leaidentifier = b.leaidentifier
    and a.schoolidentifier = b.schoolidentifier
    and a.tenantid = b.tenantid 
    --' + @whereclause + '
group by a.schoolname, b.coursetitle
order by a.schoolname, b.coursetitle'

declare @grade_course_wise nvarchar(max) = '
select 
    a.grade,
    b.coursetitle,
    count(distinct a.districtstudentid) as studentcount
from aggrptk12studentdetails a
inner join aggplpstudentcoursesections b on
    a.districtstudentid = b.districtstudentid
    and a.schoolyear = b.schoolyear
    and a.leaidentifier = b.leaidentifier
    and a.schoolidentifier = b.schoolidentifier
    and a.tenantid = b.tenantid 
    --' + @whereclause + '
group by a.grade, b.coursetitle
order by a.grade, b.coursetitle'

declare @overall nvarchar(max) = '
select distinct
    a.districtstudentid,
    a.studentfullname,
    a.schoolname,
    a.schoolyear,
    a.leaname,
    a.grade,
    a.gender,
    b.coursetitle
from aggrptk12studentdetails a
inner join aggplpstudentcoursesections b on
    a.districtstudentid = b.districtstudentid
    and a.schoolyear = b.schoolyear
    and a.leaidentifier = b.leaidentifier
    and a.schoolidentifier = b.schoolidentifier
    and a.tenantid = b.tenantid ' +
    @whereclause + '
order by a.schoolname, a.grade, a.studentfullname'

exec sp_executesql @school_course_wise, 
    N'@tenantid int, @courseidentifier varchar(50), @schoolidentifier varchar(50), @grade varchar(10), @districtstudentid varchar(50)',
    @tenantid, @courseidentifier, @schoolidentifier, @grade, @districtstudentid

exec sp_executesql @grade_course_wise,
    N'@tenantid int, @courseidentifier varchar(50), @schoolidentifier varchar(50), @grade varchar(10), @districtstudentid varchar(50)',
    @tenantid, @courseidentifier, @schoolidentifier, @grade, @districtstudentid

exec sp_executesql @overall,
    N'@tenantid int, @courseidentifier varchar(50), @schoolidentifier varchar(50), @grade varchar(10), @districtstudentid varchar(50)',
    @tenantid, @courseidentifier, @schoolidentifier, @grade, @districtstudentid
