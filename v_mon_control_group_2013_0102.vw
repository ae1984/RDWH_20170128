create or replace force view u1.v_mon_control_group_2013_0102 as
with c as (
  select c2.yy_mm_start_first, c2.contract_number, /*c2.folder_id_first,*/ c2.max_debt_used,
        c2.client_iin_first, c2.start_date_first, c2.client_rnn_first
--         c2.start_num_of_con_by_cli, c2.start_date_first, c2.prev_con_tot_debt_first_by_std,
--         c2.prev_con_prod_first_by_std
  from V_CONTRACT_CAL c2 where
  c2.yy_mm_start_first in ('2013 - 01','2013 - 02')
), p as (
  select p.max_debt_used, p.report_month_all_contracts, p.delinq_days,
         p.contract_number, p.delinq, p.new_total_debt
  from v_portfolio p where p.report_month_all_contracts = (select max(d7.YY_MM_REPORT) from v_data_all d7)
), r as (select trunc(min(mr.RES_DATE)) as res_date, --mr.RFO_CLIENT_ID,
                /*mr.FOLDER_ID,*/ max(mr.REJ_CAUSE_CODE) keep (
                          dense_rank first order by mr.RES_DATE) as REJ_CAUSE_CODE, c1.iin/*, c1.rnn*/
      from V_MON_REJ mr join V_CLIENT_RFO_BY_ID c1 on c1.rfo_client_id = mr.RFO_CLIENT_ID
      where /*mr.rej_cause_code = 2 and*/ mr.folder_id is not null and mr.RFO_CLIENT_ID is not null
      group by c1.iin
)
select "CONTRACT_NUMBER","RES_DATE","REJ_CAUSE_CODE" from (
select
--    c.yy_mm_start_first,
    c.contract_number, r.res_date, r.REJ_CAUSE_CODE
--    count(distinct case when c.max_debt_used > 0 then c.contract_number end) as contracts_active,
--    count(distinct case when c.max_debt_used > 0 then c.client_rnn_first end) as clients_active,
--    round(sum(case when p.delinq_days > 5 then p.new_total_debt else 0 end) /
--               sum(p.max_debt_used) * 100, 2) as deling_rate,
--    sum(case when p.delinq_days > 5 then p.new_total_debt else 0 end) as del_amount,
--    sum(p.max_debt_used) as sales
from p
join c on c.contract_number = p.contract_number
join r on r.iin = c.client_iin_first and r.RES_DATE = c.start_date_first
--group by c.yy_mm_start_first
) x
;
grant select on U1.V_MON_CONTROL_GROUP_2013_0102 to LOADDB;
grant select on U1.V_MON_CONTROL_GROUP_2013_0102 to LOADER;


