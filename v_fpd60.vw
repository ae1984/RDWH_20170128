create or replace force view u1.v_fpd60 as
select b."REP_DATE",b."DEBT",b."COUNT_CLIENT",a.debt_fpd,a.count_client_fpd60,a.count_deal_number_fpd60,round(a.debt_fpd/b.debt*100,2) as proz_debt,round(a.count_client_fpd60/b.count_client*100,2) as proz_count_client from (
select t.rep_date,sum(t.debt)as debt,sum(t.count_client)as count_client from V_DWH_PORT_FPD_SPD_FPD7 t where t.sales_num<>0
group by t.rep_date
  ) b
  join (
select t.start_date,sum(t.debt)as debt_fpd,sum(t.count_client)as count_client_fpd60,sum(t.count_deal_number)as count_deal_number_fpd60 from V_DWH_PORT_FPD_SPD_FPD7 t where t.fpd60_num<>0
group by t.start_date) a on b.REP_DATE = a.start_date;
grant select on U1.V_FPD60 to LOADDB;
grant select on U1.V_FPD60 to LOADER;


