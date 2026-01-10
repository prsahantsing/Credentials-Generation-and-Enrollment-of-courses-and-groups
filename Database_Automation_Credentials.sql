
-- This is the stored procedure to make the username , password , email , password, course , group , and role and 
--  send save it to the table and share the csv .

CREATE PROCEDURE CREDENTIALS_EXECUTION AS
BEGIN


WITH cte_count AS (
    SELECT 
        m.[First Name] AS firstname,
        m.[Last Name] AS lastname,
        CASE
            WHEN m.username IS NOT NULL AND LEN(LTRIM(RTRIM(m.username))) > 0 THEN m.username
            WHEN TRIM(LOWER(sup.branch)) = TRIM(LOWER(m.branch)) THEN
                sup.username_initial +
                LOWER(REPLACE(replace(ISNULL(m.[First Name], m.[Last Name]), ' ', ''), '.', '')) + '_' +
                ISNULL(m.[Admission Number / Unique Identification Number], '')

               when lower(m.BRANCH) = TRIM(REPLACE('AWS-HYD', '.', '')) THEN lower(replace(replace(isnull(m.[first name] , m.[last name]) , ' ' , '') , '.' , ''))+ '_' +  
               TRIM(RIGHT(M.[Admission Number / Unique Identification Number] ,4  )  )  

               when lower(m.BRANCH) = TRIM(REPLACE('AKW-HYD', '.', '')) THEN lower(replace(replace(isnull(m.[first name] , m.[last name]) , ' ' , '') , '.' , ''))+ '_' +  
               TRIM(RIGHT(M.[Admission Number / Unique Identification Number] ,4  )  )  

              when lower(m.BRANCH) = TRIM(REPLACE('AWS VJA', '.', '')) THEN lower(replace(replace(isnull(m.[first name] , m.[last name]) , ' ' , '') , '.' , ''))+ '_' +  
               TRIM(RIGHT(M.[Admission Number / Unique Identification Number] ,4  )  )  

                when lower(m.BRANCH)  = 'Bhavan Vidyalaya' then lower(replace(isnull(m.[first name] , m.[last name]) , '.' , ''))+  '_' + 
                replace(trim(m.[Admission Number / Unique Identification Number]) ,'.','')  ---BHAVAN VIDYALAYA

              when lower(m.BRANCH) = TRIM(REPLACE('BASMAT', '.', '')) THEN lower(replace(replace(isnull(m.[first name] , m.[last name]) , ' ' , '') , '.' , ''))+ '_' +  
               TRIM(RIGHT(M.[Admission Number / Unique Identification Number] , 3 )  )  --

              when lower(m.BRANCH) = TRIM(REPLACE('DEHRADUN', '.' ,''))  THEN lower(replace(replace(isnull(m.[first name] , m.[last name]) , ' ' , '') , '.' , ''))+   +
               '@dooninternational.com' --DIS DEHRADUN

              when lower(m.BRANCH) = TRIM(REPLACE('Mohali', '.' ,''))  THEN trim(lower(replace(m.[Admission Number / Unique Identification Number] ,' ' ,'')))  +
               '@dismohali.com'  --DISMOHALI

              when lower(m.BRANCH) = TRIM(REPLACE('chandigarh', '.' ,''))  THEN trim(lower(replace(m.[Admission Number / Unique Identification Number] ,' ' ,'')))  +
               '@dischandigarh.com'  --DIS-CHANDIGARH

              when lower(m.BRANCH) = TRIM(REPLACE('Toodler', '.', '')) THEN lower(replace(replace(isnull(m.[first name] , m.[last name]) , ' ' , '') , '.' , ''))+ '_' +  
                TRIm (RIGHT(
            M.[Admission Number / Unique Identification Number],
            CHARINDEX('/', REVERSE(M.[Admission Number / Unique Identification Number])) - 1  --DOON TOODLER 
        )
    )
              when lower(m.BRANCH) = TRIM(REPLACE('Love Dale Central School (LDCS)', '.', '')) then lower(replace(replace(isnull(m.[first name] , m.[last name]) , ' ' , '') , '.' , ''))+  '_' + 
                replace(replace(trim(m.[Admission Number / Unique Identification Number]) ,  ' ', ''),'.','')  ---love dale 

               when lower(m.BRANCH) = TRIM(REPLACE('Mahara Foundational Years', '.', '')) then 'mfy.' + lower(replace(replace(isnull(m.[first name] , m.[last name]) , ' ' , ''),'.','')) + '_' +
               right(replace(replace(TRIM(M.[Admission Number / Unique Identification Number]),' ', '') , '.', '') , 3 ) --Note ( this is no ttrimed this is the reason 
               -- of the error .... Trim brnach name  (mahara ... ) 
              
        ---     NOTE:::::  LKS Username condisions are yet to verify if mosification needed then i will add a new when codition of that as well.
            
                when lower(m.BRANCH) = TRIM(REPLACE('MPSPN', '.', '')) then lower(replace(replace(isnull(m.[first name] , m.[last name]) , ' ' , '') , '.' , ''))+  '_' + 
                 right(replace(replace(TRIM(M.[Admission Number / Unique Identification Number]),' ', '') , '.', '') , 4)

                 when lower(m.BRANCH) = TRIM(REPLACE('tilak Nagar', '.', '')) then lower(replace(replace(isnull(m.[first name] , m.[last name]) , ' ' , '') , '.' , ''))+  '_' + 
                 left(replace(replace(TRIM(M.[Admission Number / Unique Identification Number]),' ', '') , '.', '') , 5)

                when lower(m.BRANCH) = TRIM(REPLACE('Jawahar Nagar', '.', '')) then lower(replace(replace(isnull(m.[first name] , m.[last name]) , ' ' , '') , '.' , ''))+  '_' + 
                 right(replace(replace(TRIM(M.[Admission Number / Unique Identification Number]),' ', '') , '.', '') , 5)

               when lower(m.BRANCH)= TRIM(REPLACE('MGPs sanskriti', '.', '')) then lower(replace(replace(isnull(m.[first name] , m.[last name]) , ' ' , '') , '.' , ''))+  '_' + 
                 right(replace(replace(TRIM(M.[Admission Number / Unique Identification Number]),' ', '') , '.', '') , 5)

               when lower(m.BRANCH) = TRIM(REPLACE('Kalwar Road', '.', '')) then lower(replace(replace(isnull(m.[first name] , m.[last name]) , ' ' , '') , '.' , ''))+  '_' + 
                 left(replace(replace(TRIM(M.[Admission Number / Unique Identification Number]),' ', '') , '.', '') , 4)


                 ---NOTE :::: Mps Jagatpura is pending for username case statement and bagru as well 

                 when lower(m.BRANCH) = TRIM(REPLACE('Banipark', '.', '')) then lower(replace(replace(isnull(m.[first name] , m.[last name]) , ' ' , '') , '.' , ''))+  '_' + 
                 left(replace(replace(TRIM(M.[Admission Number / Unique Identification Number]),' ', '') , '.', '') , 3)


                when lower(m.BRANCH) = TRIM(REPLACE('bagru', '.', '')) then lower(replace(replace(isnull(m.[first name] , m.[last name]) , ' ' , '') , '.' , ''))+  '_' + 
                 TRIM(
            SUBSTRING(
                LEFT(m.[Admission Number / Unique Identification Number],
                     CHARINDEX('/', m.[Admission Number / Unique Identification Number] + '/') - 1),
                PATINDEX('%[0-9]%', LEFT(m.[Admission Number / Unique Identification Number],
                     CHARINDEX('/', m.[Admission Number / Unique Identification Number] + '/') - 1)),
                LEN(m.[Admission Number / Unique Identification Number])
            )
        )

                when lower(m.BRANCH) = TRIM(REPLACE('meridian uppal', '.', '')) then lower(replace(replace(isnull(m.[first name] , m.[last name]) , ' ' , '') , '.' , ''))+  '_' + 
                 right(replace(replace(TRIM(M.[Admission Number / Unique Identification Number]),' ', '') , '.', '') , 4)

               when lower(m.BRANCH) = TRIM(REPLACE('warangal', '.', '')) then lower(replace(replace(isnull(m.[first name] , m.[last name]) , ' ' , '') , '.' , ''))+  '_' + 
                 right(replace(replace(TRIM(M.[Admission Number / Unique Identification Number]),' ', '') , '.', '') , 3)

                 ----msu cambriddge is skiiped for now coz not confirm that the credentials generation status 

                 
                when lower(m.BRANCH)= TRIM(REPLACE('nis', '.', '')) then lower(replace(replace(isnull(m.[first name] , m.[last name]) , ' ' , '') , '.' , ''))+  '_' + 
                 replace(replace(TRIM(M.[Admission Number / Unique Identification Number]),' ', '') , '.', '') 

               when lower(m.BRANCH) = TRIM(REPLACE('nkps', '.', '')) then lower(replace(replace(isnull(m.[first name] , m.[last name]) , ' ' , '') , '.' , ''))+  '_' + 
                 replace(replace(TRIM(M.[Admission Number / Unique Identification Number]),' ', '') , '.', '') 

                when lower(m.BRANCH) = TRIM(REPLACE('nps', '.', '')) then lower(replace(replace(isnull(m.[first name] , m.[last name]) , ' ' , '') , '.' , ''))+  '_' + 
                 right(replace(replace(TRIM(M.[Admission Number / Unique Identification Number]),' ', '') , '.', '') , 3)
                   
                 when lower(m.BRANCH) = TRIM(REPLACE('balaghat', '.', '')) 
                        THEN 
                            LOWER(REPLACE(REPLACE(ISNULL(m.[first name], m.[last name]), ' ', ''), '.', '')) 
                            + '_' + 
                            SUBSTRING(
                                M.[Admission Number / Unique Identification Number],
                                CHARINDEX('/', M.[Admission Number / Unique Identification Number]) + 1,
                                CHARINDEX('/', M.[Admission Number / Unique Identification Number],
                                           CHARINDEX('/', M.[Admission Number / Unique Identification Number]) + 1)
                                - CHARINDEX('/', M.[Admission Number / Unique Identification Number]) - 1)
     
                when lower(m.BRANCH) = TRIM(REPLACE('kotla', '.', '')) then lower(replace(replace(isnull(m.[first name] , m.[last name]) , ' ' , '') , '.' , ''))+  '_' + 
                 right(replace(replace(TRIM(M.[Admission Number / Unique Identification Number]),' ', '') , '.', '') , 3)

               when lower(m.BRANCH) = TRIM(REPLACE('Janakpuri', '.', '')) then lower(replace(replace(isnull(m.[first name] , m.[last name]) , ' ' , '') , '.' , ''))+  '_' + 
                 replace(replace(TRIM(M.[Admission Number / Unique Identification Number]),' ', '') , '.', '') 

                when lower(m.BRANCH) = TRIM(REPLACE('QGS', '.', '')) 
                    THEN 
                        LOWER(REPLACE(REPLACE(ISNULL(m.[first name], m.[last name]), ' ', ''), '.', '')) 
                        + '_' + 
                        LEFT(M.[Admission Number / Unique Identification Number],
                             CHARINDEX('/', M.[Admission Number / Unique Identification Number]) - 1)       


               when lower(m.BRANCH)= TRIM(REPLACE('SWS', '.', '')) 
                    THEN 
                        LOWER(REPLACE(REPLACE(ISNULL(m.[first name], m.[last name]), ' ', ''), '.', '')) 
                        + '_' + 
                        LEFT(M.[Admission Number / Unique Identification Number],
                             CHARINDEX('/', M.[Admission Number / Unique Identification Number]) - 1)      
                             

                                when lower(m.BRANCH) = TRIM(REPLACE('sis', '.', '')) 
                THEN 
                    LOWER(REPLACE(REPLACE(ISNULL(m.[first name], m.[last name]), ' ', ''), '.', '')) 
                    + '_' +
                    SUBSTRING(
                        M.[Admission Number / Unique Identification Number],
                        CHARINDEX('/', M.[Admission Number / Unique Identification Number], 
                            CHARINDEX('/', M.[Admission Number / Unique Identification Number]) + 1
                        ) + 1,
                        CHARINDEX('/', M.[Admission Number / Unique Identification Number] + '/', 
                            CHARINDEX('/', M.[Admission Number / Unique Identification Number], 
                                CHARINDEX('/', M.[Admission Number / Unique Identification Number]) + 1
                            ) + 1
                        ) 
                        - CHARINDEX('/', M.[Admission Number / Unique Identification Number], 
                            CHARINDEX('/', M.[Admission Number / Unique Identification Number]) + 1
                        ) - 1
                    )

                                                   when lower(m.BRANCH) = TRIM(REPLACE('Whitefield', '.', '')) 
                THEN 
                    LOWER(REPLACE(REPLACE(ISNULL(m.[first name], m.[last name]), ' ', ''), '.', '')) 
                    + '_' +
                    SUBSTRING(
                        M.[Admission Number / Unique Identification Number],
                        CHARINDEX('/', M.[Admission Number / Unique Identification Number], 
                            CHARINDEX('/', M.[Admission Number / Unique Identification Number]) + 1
                        ) + 1,
                        CHARINDEX('/', M.[Admission Number / Unique Identification Number] + '/', 
                            CHARINDEX('/', M.[Admission Number / Unique Identification Number], 
                                CHARINDEX('/', M.[Admission Number / Unique Identification Number]) + 1
                            ) + 1
                        ) 
                        - CHARINDEX('/', M.[Admission Number / Unique Identification Number], 
                            CHARINDEX('/', M.[Admission Number / Unique Identification Number]) + 1
                        ) - 1
                    )

                   when lower(m.BRANCH) = TRIM(REPLACE('Tcs', '.', '')) then lower(replace(replace(isnull(m.[first name] , m.[last name]) , ' ' , '') , '.' , ''))+  '_' + 
                 right(replace(replace(TRIM(M.[Admission Number / Unique Identification Number]),' ', '') , '.', '') , 3)

                  when lower(m.BRANCH) = TRIM(REPLACE('Ths', '.', '')) then lower(replace(replace(isnull(m.[first name] , m.[last name]) , ' ' , '') , '.' , ''))+  '_' + 
                 right(replace(replace(TRIM(M.[Admission Number / Unique Identification Number]),' ', '') , '.', '') , 3)

                 when lower(m.BRANCH) = TRIM(REPLACE('Tvs', '.', '')) then lower(replace(replace(isnull(m.[first name] , m.[last name]) , ' ' , '') , '.' , ''))+  '_' + 
                 right(replace(replace(TRIM(M.[Admission Number / Unique Identification Number]),' ', '') , '.', '') , 3)

                 when lower(m.BRANCH) = 'TWS' then lower(replace(isnull(m.[first name] , m.[last name]) , '.' , ''))+  '_' + 
                replace(trim(m.[Admission Number / Unique Identification Number]) ,'.','')  
                         
                 when lower(m.BRANCH) = 'Diaspark' then lower(replace(isnull(m.[first name] , m.[last name]) , '.' , ''))+  '_' + 
                replace(trim(m.[Admission Number / Unique Identification Number]) ,'.','')  

                when lower(m.BRANCH) = TRIM(REPLACE('Muktsar', '.', '')) then lower(replace(replace(isnull(m.[first name] , m.[last name]) , ' ' , '') , '.' , ''))+  '_' + 
                 right(replace(replace(TRIM(M.[Admission Number / Unique Identification Number]),' ', '') , '.', '') , 3)
                 --RPS AND GBGS IS pending except it al l the schools and branches have been done and username case have been added ot the code 


 ---SKIPPING THE SSVM FOR NOW AND WORK ON THIS LATER
 --i left ssvm and ims to do it later with the relative information after ddiscuss with the school handler

            ELSE
                LOWER(replace(REPLACE(ISNULL(m.[First Name], m.[Last Name]), ' ', ''), ',' , '')) + '_' +
                RIGHT('0000' + ISNULL(m.[Admission Number / Unique Identification Number], ''), 4)
        END AS username,
        CASE 
            WHEN NOT EXISTS (
                SELECT 1 FROM school_branches sb WHERE sb.branch = m.branch
            ) THEN 
           -- old function for the password   --  UPPER(LEFT(REPLACE(ISNULL(m.[First Name], m.[Last Name]), ' ', ''), 1)) + 
                --LOWER(SUBSTRING(REPLACE(ISNULL(m.[First Name], m.[Last Name]), ' ', ''), 2, LEN(REPLACE(ISNULL(m.[First Name], m.[Last Name]), ' ', '')))) + 
                --'@123'

                -- new function was added 
                                UPPER(LEFT(REPLACE(REPLACE(ISNULL(m.[First Name], m.[Last Name]), ' ', ''), '.', ''), 1))
                + LOWER(SUBSTRING(REPLACE(REPLACE(ISNULL(m.[First Name], m.[Last Name]), ' ', ''), '.', ''), 2, LEN(REPLACE(REPLACE(ISNULL(m.[First Name], m.[Last Name]), ' ', ''), '.', ''))))
                + '@123'

            ELSE 
                m.password
        END AS password,
  /*      CASE T
            WHEN NOT EXISTS (
                SELECT 1 FROM school_branches sb WHERE sb.branch = m.branch
            ) THEN 
                LOWER(REPLACE(ISNULL(m.[First Name], m.[Last Name]), ' ', '')) + '_' +
                RIGHT('0000' + ISNULL(m.[Admission Number / Unique Identification Number], ''), 4) + '@gmail.com'
            ELSE 
                m.username
        END AS email,*/
        c.courses AS course1,
        g.groups AS group1,
        'student' AS role1,
        CASE 
            WHEN NOT EXISTS (
                SELECT 1 FROM school_branches sb WHERE sb.branch = m.branch
            ) THEN ''
            ELSE 'oauth2'
        END AS auth,
        m.[Class/Grade],
        m.Section,
        m.Branch,
        m.[Admission Number / Unique Identification Number],
        m.remarks , 
        m.branch as branchname
    FROM master_credentials_file_l2 AS m
    LEFT JOIN school_branches AS sb ON m.branch = sb.branch
    LEFT JOIN superhouse AS sup ON TRIM(LOWER(sup.branch)) = TRIM(LOWER(m.branch))
    LEFT JOIN groups AS g 
        ON g.branch = m.branch 
        AND g.section = m.section
        AND g.grade = (
            SELECT GRADENAME 
            FROM grade_names 
            WHERE gradeid = (
                SELECT gradeid 
                FROM gradeidentify_copy AS gi 
                WHERE replace(gi.gradeallnames, ' ' , '')  = replace(LTRIM(RTRIM(m.[Class/Grade])) , ' ', '') 
            )
        )
    LEFT JOIN course AS c 
        ON c.branch = m.branch
        AND c.section = (
            SELECT GRADENAME 
            FROM grade_names 
            WHERE gradeid = (
                SELECT gradeid 
                FROM gradeidentify_copy AS gi 
                WHERE replace(gi.gradeallnames , ' ' , '') = replace(LTRIM(RTRIM(m.[Class/Grade])) , ' ', '') 
            )
        ) 
),
cte_final as
(
select *  , 
case
when branch = 'DEHRADUN' then username 
when branch = 'cmis' then username 
when branch in ('Faridabad Sec 89',
'Gaur City',
'Gaur City2',
'Gurugram Sec 15',
'Gurugram Sec 48',
'Gurugram Sec 54',
'Sec 70 Gurugram',
'Kalka Ji',
'Kismatpur Hyderabad',
'Madhavnagar Gwalior',
'Malviyanagar Delhi',
'Nehru Nagar Ghaziabad',
'Nirala Estate',
'Sector 95 A Gurugram',
'Noida Sec 116',
'Noida Sec 61',
'Rajnagar Extension',
'Rajnagar Ghaziabad',
'Vasundhra Sec 11',
'Sector 89 B Gurugram') then username 
else 
username + '@gmail.com' 
end as email --add case statemant for email of dis dehradon 
from cte_count 
)
INSERT INTO newenrolls (
    firstname, lastname, username, password, email,
    course1, group1, role1, auth, 
    [Class/Grade], Section, Branch, 
    [Admission Number / Unique Identification Number], remarks , branchname
)
SELECT 
    firstname, lastname, username, password, email, 
    course1, group1, role1, auth, 
    [Class/Grade], Section, Branch, 
    [Admission Number / Unique Identification Number], remarks , branchname
FROM cte_final as cf
WHERE username IS NOT NULL 
  AND course1 IS NOT NULL 
  AND group1 IS NOT NULL 
  AND role1 IS NOT NULL 
  AND NOT EXISTS (
      SELECT 1 
      FROM testingtable AS tt 
      WHERE tt.username = cf.username 
        AND tt.firstname = cf.firstname
  );


-- 2️⃣ Insert from newenrolls into testingtable (excluding createdat)
INSERT INTO testingtable (
    firstname, lastname, username, password, email, 
    course1, group1, role1, auth, 
    [Class/Grade], Section, Branch, 
    [Admission Number / Unique Identification Number], remarks
)
SELECT 
    firstname, lastname, username, password, email, 
    course1, group1, role1, auth, 
    [Class/Grade], Section, Branch, 
    [Admission Number / Unique Identification Number], remarks
FROM newenrolls AS n 
WHERE NOT EXISTS (
    SELECT 1 
    FROM testingtable AS test 
    WHERE test.firstname = n.firstname 
      AND test.lastname = n.lastname 
      AND test.username = n.username 
      AND test.password = n.password 
      AND test.email = n.email 
      AND test.course1 = n.course1
      AND test.group1 = n.group1 
      AND test.role1 = n.role1
      AND test.auth = n.auth
) insert into csv_handle 
select 
        firstname , lastname , username , password , 
        email , course1 , group1 , role1 , auth 
     from newenrolls 

  INSERT INTO NOT_ENROLLED (
    [First Name],
    [Last Name],
    Username,
    Password,
    [Class/Grade],
    Section,
    Branch,
    [Admission Number / Unique Identification Number]
)
SELECT
    m.[First Name],
    m.[Last Name],
    m.Username,
    m.Password,
    m.[Class/Grade],
    m.Section,
    m.Branch,
    m.[Admission Number / Unique Identification Number]
FROM master_credentials_file_l m
WHERE 
    -- Only users who do NOT exist in testingtable
    NOT EXISTS (
        SELECT 1 
        FROM testingtable t 
        WHERE t.username = m.username
    )
    
    -- ❗ Only insert if username is NULL or empty
    AND (m.Username IS NULL OR m.Username = '')

    -- Exclude completely empty rows
 
    -- Exclude completely empty rows AND rows with less than 2 non-empty fields
    AND (
        (
            CASE WHEN m.[First Name] IS NULL OR m.[First Name] = '' THEN 0 ELSE 1 END +
            CASE WHEN m.[Last Name] IS NULL OR m.[Last Name] = '' THEN 0 ELSE 1 END +
            CASE WHEN m.Username IS NULL OR m.Username = '' THEN 0 ELSE 1 END +
            CASE WHEN m.Password IS NULL OR m.Password = '' THEN 0 ELSE 1 END +
            CASE WHEN m.[Class/Grade] IS NULL OR m.[Class/Grade] = '' THEN 0 ELSE 1 END +
            CASE WHEN m.Section IS NULL OR m.Section = '' THEN 0 ELSE 1 END +
            CASE WHEN m.Branch IS NULL OR m.Branch = '' THEN 0 ELSE 1 END +
            CASE WHEN m.[Admission Number / Unique Identification Number] IS NULL 
                      OR m.[Admission Number / Unique Identification Number] = '' 
                 THEN 0 ELSE 1 END +
            CASE WHEN m.Remarks IS NULL OR m.Remarks = '' THEN 0 ELSE 1 END
        ) >= 2  -- ✅ Require at least TWO non-empty fields
    );


END;




--- 2 nd Stored procedures.

CREATE PROCEDURE Initialize_Setup 
as begin

insert into master_credentials_file_l2
select * 
from master_credentials_file_l
where (Section is not null and LTRIM(RTRIM(Section)) <> '')
   and ([Class/Grade] is not null and LTRIM(RTRIM([Class/Grade])) <> '')
   and  (Branch is not null and LTRIM(RTRIM(Branch)) <> '')
      and  ([Admission Number / Unique Identification Number ] is not null and LTRIM(RTRIM([Admission Number / Unique Identification Number ])) <> '');
update master_credentials_file_l2 
set [Class/Grade] = 'NNLP 3'
where [class/grade] IN (
replace(replace(trim(lower('Nursery')) , ' ' , ''),'.','') ,
replace(replace(trim(lower( 'nur')),' ',''),'.','')
) 
and branch IN 
( 
'AH Agra',
'AH Ghaziabad',
'AH Khalasi Lines',
'AK Panki',
'AK Bareilly',
'AK Jhansi',
'AK Kakadeo',
'AK Mukherjee',
'AK Rooma',
'AK Swaroop Nagar',
'AK Vrindavan',
'AH Ghaziabad',
'DPS Amrapali',
'DPS Bareilly',
'DPS Eldeco',
'DPS Gomti Nagar',
'DPS Indira Nagar',
'DPS Jankipuram',
'DPS Kalyanpur',
'DPS Saharanpur',
'DPS Unnao')



update master_credentials_file_l2 
set [Class/Grade] = 'NNLP 2'
where [class/grade] IN (SELECT GRADEALLNAMES FROM GRADE_IDENTIFY  WHERE GRADEID = '2' ) 
and branch IN 
( 
'AH Agra',
'AH Ghaziabad',
'AH Khalasi Lines',
'AK Panki',
'AK Bareilly',
'AK Jhansi',
'AK Kakadeo',
'AK Mukherjee',
'AK Rooma',
'AK Swaroop Nagar',
'AK Vrindavan',
'AH Ghaziabad',
'DPS Amrapali',
'DPS Bareilly',
'DPS Eldeco',
'DPS Gomti Nagar',
'DPS Indira Nagar',
'DPS Jankipuram',
'DPS Kalyanpur',
'DPS Saharanpur',
'DPS Unnao')

update master_credentials_file_l2 
set [Class/Grade] = 'NNLP 1'
where [class/grade] IN (SELECT gradEALLNAMES FROM grade_identify 
WHERE GRADEID = '1' ) 
and branch IN 
( 
'AH Agra',
'AH Ghaziabad',
'AH Khalasi Lines',
'AK Panki',
'AK Bareilly',
'AK Jhansi',
'AK Kakadeo',
'AK Mukherjee',
'AK Rooma',
'AK Swaroop Nagar',
'AK Vrindavan',
'AH Ghaziabad',
'DPS Amrapali',
'DPS Bareilly',
'DPS Eldeco',
'DPS Gomti Nagar',
'DPS Indira Nagar',
'DPS Jankipuram',
'DPS Kalyanpur',
'DPS Saharanpur',
'DPS Unnao')

end 
