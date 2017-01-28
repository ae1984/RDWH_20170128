create or replace force view u1.v_folder_con_cancel_for_dnp as
select /*+parallel(5)*/
  folder_date_create_mi, rfo_contract_id, folder_id, folder_number, rfo_client_id, iin, x_dnp_region
  , x_dnp_name, pos_code, pos_name, pos_type, shop_code, shop_name, a.c_num_tab as expert_num_tab, expert_name
  , expert_position, is_card, cr_program_name, product_type, is_point_active, is_credit_issued
  , is_credit_issued_new, is_credit_issued_mix, contract_status_code, contract_status_name
  , contract_number, contract_amount, cancel_prescoring, cancel_middle_office, cancel_controller
  , cancel_client, cancel_manager, cancel_cpr_aa, cancel_verificator, cancel_undefined, is_aa_reject
  , process_name, route_name, route_point_code, folder_state, is_daytime_decision_folder, source_system, delivery_type
  , is_refin, contract_date_begin, contract_set_revolving_date, cr_scheme_name, tariff_plan_name, form_client_id, prev_con_cnt
  , prev_con_closed_cnt, amount_max_before, prior_optim_count, is_client_new_by_con, is_sign_require, prev_con_del_days_max
  , fact_pmt_mon_before, fact_pmt_mon_before_12_mon, is_categ_a, is_credit_rejected, claim_id, pos_credit_type, is_categ_b
  , expert_id, rnn
from M_FOLDER_CON_CANCEL t
left join V_RFO_Z#USER a on a.id = t.expert_id
where t.folder_date_create_mi >= to_date('2014-01-01','yyyy-mm-dd');
grant select on U1.V_FOLDER_CON_CANCEL_FOR_DNP to DNP;
grant select on U1.V_FOLDER_CON_CANCEL_FOR_DNP to LOADDB;
grant select on U1.V_FOLDER_CON_CANCEL_FOR_DNP to LOADER;


