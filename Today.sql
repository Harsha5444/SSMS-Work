			select distinct SECONDARY_ID FROM Main.EH_PSAT where schoolyear = 2024
			except
			select distinct districtstudentid from [Main].[K12StudentEnrollment] where  schoolyear= 2024

			select distinct SECONDARY_ID FROM Main.EH_PSAT where schoolyear = 2023
			except
			select distinct districtstudentid from [Main].[K12StudentEnrollment] where  schoolyear= 2023

			select distinct SECONDARY_ID FROM Main.EH_PSAT where schoolyear = 2025
			except
			select distinct districtstudentid from [Main].[K12StudentEnrollment] where  schoolyear= 2025

			--=====================================================

			select distinct SECONDARY_ID FROM Main.EH_PSAT where schoolyear = 2024
			except
			select distinct STUDENT_NUMBER from [Main].EH_Students where  schoolyear= 2024

			select distinct SECONDARY_ID FROM Main.EH_PSAT where schoolyear = 2023
			except
			select distinct STUDENT_NUMBER from [Main].EH_Students where  schoolyear= 2023

			select distinct SECONDARY_ID FROM Main.EH_PSAT where schoolyear = 2025
			except
			select distinct STUDENT_NUMBER from [Main].EH_Students where  schoolyear= 2025


select * from [Main].[K12StudentEnrollment] where tenantid = 35 and schoolyear = 2024 and DistrictStudentID = '9990108569'


select schoolyear,* from Main.EH_PSAT where secondary_id = '9990108569' and schoolyear = 2024

select * from main.EH_Students where schoolyear = 2024 and STUDENT_NUMBER='9990108569'


select distinct SECONDARY_ID from [Main].EH_SAT where  schoolyear= 2025
except
select distinct districtstudentid from #ehps_temp_psat_sat where assessmentcode = 'sat' and schoolyear = 2025

select distinct SECONDARY_ID from [Main].EH_SAT where  schoolyear= 2024
except
select distinct districtstudentid from #ehps_temp_psat_sat where assessmentcode = 'sat' and schoolyear = 2024

select distinct SECONDARY_ID from [Main].EH_SAT where  schoolyear= 2023
except
select distinct districtstudentid from #ehps_temp_psat_sat where assessmentcode = 'sat' and schoolyear = 2023