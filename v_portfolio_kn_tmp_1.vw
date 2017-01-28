create or replace force view u1.v_portfolio_kn_tmp_1 as
select
       r1.id,
       r2.report_year,
       r1.yy_mm_report,
       r1.contract_number,
       r1.client_id,
       r2.folder_id_first,
       r2.total_debt,
       r1.delinq_days,
       r1.delinq_days_old,
       r1.report_month,
--       r1.delinq_days,
--       r1.contract_number,
       r1.num_months,
       r1.is_card,
       r1.status,
       r1.start_year,
       r1.delinq,
--       r1.del_short,
--       r1.del_middle,
       r1.del_long,
       r1.del_long_old,
       r1.contract_amount_categ,
       r1.planned_pmt_month,
       r1.delinq_mm,
       r1.delinq_type,
       r1.fact_pmts,
       r2.report_month_all_contracts,
       r2.report_month_all_contracts_n,
       r2.new_total_debt,
       r2.max_debt_used,
       r2.delinq_amount
from
  v_report_cal_1 r1
  join v_report_cal_2 r2 on r2.id = r1.id
  join V_CONTRACT_CAL cc on cc.contract_number = r1.contract_number and
            cc.start_date_first >= to_date('2012-07-01','yyyy-mm-dd') and
            cc.product_first in ('КН','КНП')
;
grant select on U1.V_PORTFOLIO_KN_TMP_1 to LOADDB;
grant select on U1.V_PORTFOLIO_KN_TMP_1 to LOADER;


