create or replace force view u1.info_on_managers as
select p.create_empl_name, p.create_empl_number, c.iin, c.hiring_date, c.firing_date, c.birth_date,
       case when p.create_empl_name not like '%БЛОК%' and c.firing_date is null then 'A'
            when p.create_empl_name like '%БЛОК%' and c.firing_date is null then 'B'
            when c.firing_date is not null then 'F' end as blocked,
       c.position_name,
       case when months_between(nvl(c.firing_date,sysdate),c.hiring_date) > 3 then 1 else 0 end as months_3
from
(
select p.create_empl_number,p.create_empl_name from v_dwh_portfolio_current p
group by p.create_empl_number,p.create_empl_name
) p
join M_ZUP_1C_STAFF_OUT2 c on c.tab_num = p.create_empl_number;
grant select on U1.INFO_ON_MANAGERS to LOADDB;
grant select on U1.INFO_ON_MANAGERS to LOADER;


