create or replace force view u1.v_rdwh_provisions_sw as
select p.rep_date as a_date,
       case
         when d.day_min<0 then
           0
         else
           d.day_min
       end as days_from,
       d.day_max as day_to,
           p.long_delinq,
       /*case
         when p.rep_date between to_date('20-09-2015','dd-mm-yyyy') and to_date('13-12-2015','dd-mm-yyyy') or
              p.rep_date >= to_date('01-01-2016','dd-mm-yyyy') then
              value_calc*100
         else*/
              nvl(value_nb,value_calc)*100
         /*end*/ as value_rate,
       case when p.prod = 'A' then
             'АВТО'
            when p.prod = 'M' then
              'МАСС'
       end  as product_type
from  u1.T_DWH_PROVISIONS p
join u1.T_RDWH_DELINQ_DAYS d on d.prod = p.prod and d.name = p.long_delinq
where rep_type = 'recalc5'
order by p.rep_date,p.prod,p.long_delinq;
comment on table U1.V_RDWH_PROVISIONS_SW is 'Данные по пересчитанным провизиям на конец месяца';
comment on column U1.V_RDWH_PROVISIONS_SW.A_DATE is 'Дата';
comment on column U1.V_RDWH_PROVISIONS_SW.DAYS_FROM is 'Дни с';
comment on column U1.V_RDWH_PROVISIONS_SW.DAY_TO is 'Дни по';
comment on column U1.V_RDWH_PROVISIONS_SW.LONG_DELINQ is 'Период';
comment on column U1.V_RDWH_PROVISIONS_SW.VALUE_RATE is 'Значение провизий';
comment on column U1.V_RDWH_PROVISIONS_SW.PRODUCT_TYPE is 'Тип продукта (авто, масс)';
grant select on U1.V_RDWH_PROVISIONS_SW to LOADDB;
grant select on U1.V_RDWH_PROVISIONS_SW to LOADER;


