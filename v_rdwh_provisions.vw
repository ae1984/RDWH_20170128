create or replace force view u1.v_rdwh_provisions as
select "REP_DATE","NAME","PROVISIONS_MASS","PROVISIONS_AUTO"
from (
select rep_date,
       prod ,
       name,
       case
           when p.prod = 'A' and
                p.rep_date between to_date('20-09-2015','dd-mm-yyyy') and to_date('13-12-2015','dd-mm-yyyy') or
                p.rep_date >= to_date('01-01-2016','dd-mm-yyyy') then
           round(value_calc*100,2)
           else
           round(value_nb*100,2) end as value
from t_dwh_provisions P
where long_delinq  ='IFRS'
and rep_type in ('itog3')
)
pivot (max(value) for prod in ('M' as Provisions_mass,'A' as Provisions_auto))
order by rep_date desc;
grant select on U1.V_RDWH_PROVISIONS to LOADDB;
grant select on U1.V_RDWH_PROVISIONS to LOADER;


