create or replace force view u1.v_all as
select /*+first_rows*/
  p.yy_mm_report as po_yy_mm_report,
  p.total_debt as po_total_debt,
  p.delinq_days as po_delinq_days,
  p.start_year as po_start_year,
  p.delinq as po_delinq,
--  p.del_middle as po_del_middle,
  p.del_long as po_del_long,
  p.contract_amount_categ as po_contract_amount_categ,
  p.planned_pmt_month as po_planned_pmt_month,
  p.delinq_mm as po_delinq_mm,
  p.fact_pmts as po_fact_pmts,
  p.report_month_all_contracts as po_report_month_all_contracts,
  p.new_total_debt as po_new_total_debt,
  p.max_debt_used as po_max_debt_used,
  f.folder_id as fo_folder_id,
  f.amount as fo_amount,
  f.pos_code as fo_pos_code,
  f.org_name as fo_org_name,
  f.inc_sal as fo_inc_sal,
  f.inc_sal_spouse as fo_inc_sal_spouse,
  f.inc_rent as fo_inc_rent,
  f.prescoring_result as fo_prescoring_result,
  f.scoring_test as fo_scoring_test,
  f.gcvp_sal as fo_gcvp_sal,
  f.sal_gcvp_to_sal_form_categ as fo_sal_gcvp_to_sal_form_categ,
  co.product_first as co_product_first,
  co.product_program_first as co_product_program_first,
  co.start_date_first as co_start_date_first,
  co.contract_amount_first as co_contract_amount_first,
  co.expert_name_first as co_expert_name_first,
  co.branch_name_first as co_branch_name_first,
  co.is_card as co_is_card,
  co.yy_mm_start_first as co_yy_mm_start_first,
  co.pmt as co_pmt,
--  co.start_year_first as co_start_year_first,
  co.start_con_amount_max_by_cli as co_start_amount_max_by_cli,
  co.start_con_del_days_max_by_cli as co_start_del_days_max_by_cli,
  co.start_tot_debt_all_con_by_cli as co_start_totdebt_allcon_by_cli,
  co.start_num_of_con_by_cli_pr_rep as co_start_numofcon_by_cli_prrep,
  co.start_num_of_con_by_cli as co_start_num_of_con_by_cli,
  co.start_total_fact_pmts_by_cli as co_start_tot_fact_pmts_by_cli,
  co.start_pmt_max_by_cli as co_start_pmt_max_by_cli,
  co.start_num_of_fol_all as co_start_num_of_fol_all,
  co.start_num_of_fol_1_month as co_start_num_of_fol_1_month,
  co.client_rnn_first as co_client_rnn_first,
  co.client_rnn_last as co_client_rnn_last,
  cl.client_id as cl_client_id,
  cl.product_first as cl_product_first,
  cl.yy_mm_start_first as cl_yy_mm_start_first,
  cl.birth_date as cl_birth_date,
  cl.birth_place as cl_birth_place
from
  V_PORTFOLIO p,
  V_CLIENT_CAL cl,
  V_CONTRACT_CAL co,
  V_FOLDER_ALL f
where
  p.client_id = cl.client_id(+) and
  p.contract_number = co.contract_number(+) and
  p.folder_id_first = f.folder_id(+)
;
grant select on U1.V_ALL to LOADDB;
grant select on U1.V_ALL to LOADER;


