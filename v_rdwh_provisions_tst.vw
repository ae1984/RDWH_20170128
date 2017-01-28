create or replace force view u1.v_rdwh_provisions_tst as
select "REP_DATE","NAME","PROVISIONS_MASS","PROVISIONS_AUTO","PROVISIONS_AUTO_NEW"
from (
select rep_date,
       prod ,
       name,
       case when rep_type = 'itog2' then round(value_nb)
           else  round(value_nb*100,2) end as value
from t_dwh_provisions P
where long_delinq  ='IFRS'
and rep_type in ('itog3')
union all
select rep_date,
       prod||'_NEW' ,
       name,
       case when rep_type = 'itog2' then round(value_calc)
           else  round(value_calc*100,2) end as value
from t_dwh_provisions P
where long_delinq  ='IFRS'
and rep_type in ('itog3')
and prod = 'A'
and rep_date >= to_date('24-09-2015','dd-mm-yyyy')
)
pivot (max(value) for prod in ('M' as Provisions_mass,'A' as Provisions_auto, 'A_NEW' as Provisions_auto_new))
order by rep_date;
grant select on U1.V_RDWH_PROVISIONS_TST to LOADDB;
grant select on U1.V_RDWH_PROVISIONS_TST to LOADER;


