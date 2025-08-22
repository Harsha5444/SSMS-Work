    

select * from [BR].[BusinessRule] where FileTemplateFieldId=4947

--=====================================================================================================
select count(1) from main.clayton_analyticvue_ICstudents as p 

	left join main.K12School K12School
        on p.SchoolNumber = K12School.SchoolIdentifier
           and p.SchoolYear = K12School.SchoolYear
Where (isnull(p.SchoolNumber, 0) != isnull(K12School.SchoolIdentifier, 0))
      and (isnull(p.SchoolYear, 0) != isnull(K12School.SchoolYear, 0))

--=====================================================================================================
select count(1) from main.clayton_analyticvue_ICstudents as p 

    left join main.K12School K12School
        --on p.SchoolNumber = K12School.SchoolIdentifier
        on (Case
                when p.SchoolNumber = '6008'
                     And p.SchoolName Like '%High%' Then
                    '0036008'
                when p.SchoolNumber = '6008'
                     And p.SchoolName Like '%Middle%' Then
                    '0026008'
                when p.SchoolNumber = '6008'
                     And p.SchoolName Like '%Elem%' Then
                    '0016008'
                when p.SchoolNumber = '6422'
                     And p.SchoolName Like '%High%' Then
                    '0096422'
                when p.SchoolNumber = '6422'
                     And p.SchoolName Like '%Middle%' Then
                    '0236422'
                when p.SchoolNumber = '6422'
                     And p.SchoolName Like '%Elem%' Then
                    '1286422'
                when p.SchoolNumber = '6004'
                     And p.SchoolName Like '%High%' Then
                    '0086004'
                when p.SchoolNumber = '6004'
                     And p.SchoolName Like '%Middle%' Then
                    '0226004'
                when p.SchoolNumber = '0114'
                     And p.SchoolName = '24-25 Elite Scholars Middle' Then
                    '0990114'
                Else
                    p.SchoolNumber
            End
           ) = K12School.SchoolIdentifier
           and p.SchoolYear = K12School.SchoolYear
Where (isnull(   Case
                     when p.SchoolNumber = '6008'
                          And p.SchoolName Like '%High%' Then
                         '0036008'
                     when p.SchoolNumber = '6008'
                          And p.SchoolName Like '%Middle%' Then
                         '0026008'
                     when p.SchoolNumber = '6008'
                          And p.SchoolName Like '%Elem%' Then
                         '0016008'
                     when p.SchoolNumber = '6422'
                          And p.SchoolName Like '%High%' Then
                         '0096422'
                     when p.SchoolNumber = '6422'
                          And p.SchoolName Like '%Middle%' Then
                         '0236422'
                     when p.SchoolNumber = '6422'
                          And p.SchoolName Like '%Elem%' Then
                         '1286422'
                     when p.SchoolNumber = '6004'
                          And p.SchoolName Like '%High%' Then
                         '0086004'
                     when p.SchoolNumber = '6004'
                          And p.SchoolName Like '%Middle%' Then
                         '0226004'
                     when p.SchoolNumber = '0114'
                          And p.SchoolName = '24-25 Elite Scholars Middle' Then
                         '0990114'
                     Else
                         p.SchoolNumber
                 End,
                 0
             ) != isnull(K12School.SchoolIdentifier, 0)
      )
      and (isnull(p.SchoolYear, 0) != isnull(K12School.SchoolYear, 0))