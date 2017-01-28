create or replace force view u1.v_sas_out_client_history as
select --+ parallel(5)
       c.client_id,
       c.client_iin_last as iin,
       clnt_gid_max as clnt_gid,
       t.yyyy_mm_num,
       t.text_yyyy_mm,
       t.report_month,
       t.total_debt_in_month,
       t.delinq_days_in_month,
       t.max_total_debt,
       t.max_delinq_days,
       t.total_contract_amount_in_month
from V_CLIENT_HISTORY t
join V_CLIENT_CAL c on c.client_id = t.client_id
join (select dd.clnt_inn,
             max(dd.clnt_gid) as clnt_gid_max
      from V_DWH_CLIENT_PHYS_CURRENT dd
      group by dd.clnt_inn
) d on d.clnt_inn = c.client_iin_last
where c.client_iin_last is not null
;
grant select on U1.V_SAS_OUT_CLIENT_HISTORY to IT6_USER;
grant select on U1.V_SAS_OUT_CLIENT_HISTORY to LOADDB;
grant select on U1.V_SAS_OUT_CLIENT_HISTORY to LOADER;


