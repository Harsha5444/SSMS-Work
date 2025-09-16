/*==================================================================================
VIEW NAME: analyticVue_HenryInsights.dbo.HCS_teacherStaffStudentMapping

PURPOSE: 
    This view provides a secure, standardized mapping between teachers, staff, 
    students, and the courses/sections they are linked to. It is intended to 
    support analytics for HCS (Henry County Schools) and control access for 
    analyticVue teachers.

VERSION:  20250820  
CREATOR:  Amy Tursich (ART)  
CHANGE LOG:  
    - 20250820: Initial script creation

TABLES USED:
    - henry.dbo.activeTrial                (Academic calendars/trials)
    - henry.dbo.schoolyear                 (School year meta-data)
    - henry.dbo.course                     (List of courses)
    - henry.dbo.section                    (Class section info)
    - henry.dbo.roster                     (Student enrollments in sections)
    - henry.dbo.person (p, ps)             (Person data for teacher and student)
    - henry.dbo.identity (i, ist)          (Current identity with names)
    - henry.dbo.SectionStaffHistory        (Mapping of teachers/staff to sections)
    - henry.dbo.sectionplacement           (Period & term placement of section)
    - henry.dbo.term                       (Academic terms, e.g., Fall 2025)
    - henry.dbo.period                     (Daily/period schedule reference)
    - henry.dbo.enrollment                 (Student enrollment validation)

UPDATE PERIOD: N/A
UPDATE JOB NAME: N/A
==================================================================================*/

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- Create the secure mapping view
CREATE VIEW analyticVue_HenryInsights.dbo.HCS_teacherStaffStudentMapping
AS
SELECT DISTINCT
       87 AS LEAIdentifier,                         -- District/LEA identifier (static)
       4 AS tenantID,                               -- Tenant identifier (static)
       at.calendarID,                               -- Academic calendar reference
       at.calendarName,                             -- Calendar name (e.g., MHS 24-25)
       at.endYear,                                  -- Academic year end
       tm.termID,                                   -- Term key (fall/spring/summer)
       tm.[name] AS TermName,                       -- Term name (readable text)
       at.schoolID,                                 -- School identifier
       ssh.personID AS teacherPersonID,             -- Teacher�s unique person ID
       p.staffNumber,                               -- Teacher�s staff number
       i.lastName + ', ' + i.firstName AS teacherName, -- Teacher full name
       r.startDate AS rosterStartdate,              -- Student�s start date in class
       r.endDate AS rosterEnddate,                  -- Student�s end date in class
       c.number AS courseNumber,                    -- Local course ID/number
       c.stateCode AS stateCourseNumber,            -- State-level course ID
       s.number AS sectionNumber,                   -- Section number within course
       s.sectionID,                                 -- Section key
       c.courseID,                                  -- Course key
       c.[name] AS courseName,                      -- Course title
       r.personID AS studentPersonID,               -- Student�s person ID
       ps.studentNumber,                            -- Student�s unique student number
       ist.lastName + ', ' + ist.firstName AS studentName -- Student full name
FROM henry.dbo.activeTrial at
JOIN henry.dbo.schoolyear sy
    ON sy.endyear = at.endyear AND sy.active = 1  -- only choosing active year
JOIN henry.dbo.course c
    ON at.calendarid = c.calendarid
JOIN henry.dbo.section s
    ON s.courseid = c.courseid AND s.trialid = at.trialid
JOIN henry.dbo.roster r
    ON r.sectionid = s.sectionid AND r.trialID = s.trialID
JOIN henry.dbo.person ps
    ON ps.personid = r.personid
JOIN henry.dbo.[Identity] ist
    ON ist.identityID = ps.currentIdentityID
JOIN henry.dbo.SectionStaffHistory ssh
    ON s.sectionid = ssh.sectionid
       AND s.trialID = ssh.trialID
       AND ssh.staffType IN ('P','T')      -- Primary (�P�) or Teacher (�T�)
       AND (ssh.enddate IS NULL OR ssh.enddate >= GETDATE())
JOIN henry.dbo.person p
    ON p.personID = ssh.personID
JOIN henry.dbo.[identity] i
    ON i.identityID = p.currentIdentityID
JOIN henry.dbo.sectionplacement sp
    ON sp.sectionID = s.sectionID AND sp.trialID = at.trialID
JOIN henry.dbo.term tm
    ON sp.termid=tm.termid
JOIN henry.dbo.[period] pd
    ON pd.periodid = sp.periodID
JOIN henry.dbo.enrollment e
    ON e.personid = ps.personid
       AND ISNULL(e.noshow,0) = 0       -- Ensures student actually attended
       AND e.calendarid = at.calendarid
       AND e.endyear = at.endyear;
GO
