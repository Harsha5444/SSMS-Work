delete from MAIN.assessmentdetails
where TENANTID = 50
      and AssessmentCode in ( 'PSAT', 'PSAT89', 'PSATNMSQT' )
      and schoolyear = 2025

delete from STAGE.assessmentdetails_AUDIT
where TENANTID = 50
      and AssessmentCode in ( 'PSAT', 'PSAT89', 'PSATNMSQT' )
      and schoolyear = 2025


delete from main.k12studentgenericassessment
where assessmentcodeid in (
                              select distinct
                                  assessmentdetailsid
                              from main.assessmentdetails ad
                                  inner join main.k12studentgenericassessment ga
                                      on ad.assessmentdetailsid = ga.assessmentcodeid
                                         and ad.tenantid = ga.tenantid
                                         and ad.schoolyear = ga.schoolyear
                              where ad.assessmentcode in ( 'PSAT', 'PSAT89', 'PSATNMSQT' )
                                    and ad.schoolyear = 2025
                          )

delete from STAGE.k12studentgenericassessment_AUDIT
where TENANTID = 50
      and AssessmentCode in ( 'PSAT', 'PSAT89', 'PSATNMSQT' )
      and SchoolYear = 2025


	  select 23*5