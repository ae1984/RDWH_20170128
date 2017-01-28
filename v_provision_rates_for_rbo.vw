create or replace force view u1.v_provision_rates_for_rbo as
select
t.a_date,
t.days_del_from,
t.days_del_to,
case when t.days_del_from = 0 then 'НЕ НА ПРОСРОЧКЕ'
       when t.days_del_to = 30 then 'ДО 30 ДНЕЙ'
       when t.days_del_from<100 and t.days_del_to <100 then '0'||t.days_del_from||'-0'||t.days_del_to
       when t.days_del_from<100 and t.days_del_to >=100 then '0'||t.days_del_from||'-'||t.days_del_to
       when t.days_del_from>750 then '>750'
       when t.days_del_from>=100 and t.days_del_to >=100 then t.days_del_from||'-'||t.days_del_to
       end as days_del_range_name,
t.provision as provision_rate,
t.provision as provision_rate_auto,
0 as usage_coefficient
 from REF_PROVISIONS t;
grant select on U1.V_PROVISION_RATES_FOR_RBO to LOADDB;
grant select on U1.V_PROVISION_RATES_FOR_RBO to LOADER;
grant select on U1.V_PROVISION_RATES_FOR_RBO to RBO_USER;


