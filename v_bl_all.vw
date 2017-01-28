create or replace force view u1.v_bl_all as
select max(name_last) as name_last,
       max(name_first) as name_first,
       max(birth_date) as birth_date_txt_1,
       substr(max(birth_date),9,2)||'.'||substr(max(birth_date),6,2)||'.'||
           substr(max(birth_date),1,4) as birth_date_txt_2,
       case when min(bl) = 1 then 1 else 0 end as is_bl1,
       case when max(bl) = 2 then 1 else 0 end as is_bl2,
       name_last||' '||name_first||' '||birth_date as name_and_birth_date_txt_1,
       max(name_last)||' '||max(name_first)||' '||substr(max(birth_date),9,2)||'.'||substr(max(birth_date),6,2)||'.'||
           substr(max(birth_date),1,4) as name_and_birth_date_txt_2
from (
select 1 as bl, b1.surname as name_last,
       b1.first_name as name_first, b1.birth_date
from V_BL1_LM b1
union all
select 2 as bl,
       substr(b2.person_name,1,instr(b2.person_name,' ')-1) as name_last,
       substr(b2.person_name,instr(b2.person_name,' ')+1,
             length(b2.person_name)) as name_first,
       b2.birth_year||'-'||substr(b2.birth_mm_dd,1,2)||'-'||
             substr(b2.birth_mm_dd,3,2) as birth_date
from V_BL2 b2
) x group by name_last||' '||name_first||' '||birth_date;
grant select on U1.V_BL_ALL to LOADDB;
grant select on U1.V_BL_ALL to LOADER;


