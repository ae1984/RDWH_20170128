﻿create or replace force view u1.v_rfo_fraud_search_all as
select v1.rfo_client_id,
v1.date_create,
v1.app_id,
v2.product_type,
v1.shop_code,
v1.shop_name,
--v1.status_code,
--v1.status_name,
--v1.process_id,
v1.income_form,
v1.income_form_all,
v1.age,
v1.reg_kaspikz_length,
v1.avg_sum_pay_kspkz_30_d,
v1.count_month_kaspikz_6_m,
v1.count_pay_kspkz_30_d,
v1.count_serv_kspkz_6_m,
v1.kommunalka_kaspikz_6_m,
v1.count_mob_kspkz,
v1.sum_pay_kspkz_30_d,
--v1.share_month_kaspikz_6_m,
v1.session_ksp_last_6_mnth,
v1.count_day_app_onl,
--v1.max_sum_online_ekt_3_m,
/*v1.count_appl_kn_30_d,
v1.count_fail_kn_30_d,
v1.max_sum_appl_kn_30_d,*/
/*v1.count_appl_kn_30_d2,
v1.count_fail_kn_30_d2,
v1.max_sum_appl_kn_30_d2,*/
/*v1.count_fail_30_d,
v1.count_applications_30_d,
v1.count_applications_30_d_x,*/
/*v1.count_fail_30_d2,
v1.count_applications_30_d2,
v1.count_applications_30_d_x2,*/
v1.max_count_fail_day as max_count_fail_onl_day,
v1.last_year_max_delay,
v1.pkb_debt_kzt,
v1.income_gcvp,
v1.days_last_gcvp,
v1.diff_zp_form_gcvp,
v1.diff_zp_form_all_gcvp,
v1.avg_sum_pay_cred_3_m,
--v1.count_visit_guest,
v1.count_salary_6_m,
v1.kaspi_gold_active,
v1.max_tov_categ_code,
v1.max_count_category_day,
--v1.count_category_3_m,
--v1.count_category_3_m_x,
v1.max_prod_models_day,
v1.max_count_models_day,
v1.ex_terminal_share_count,
v1.fail_share_30_d_count,
--v1.terminal_share_count,
v1.share_30_d_count,
v1.ex_terminal_share,
v1.fail_share_30_d,
/*v1.avg_zp_h,*/
v1.ii,
--------
v2.balance_all_dep_beg_m as balance_all_dep_beg_m_v2,
v2.balance_all_dep_beg as balance_all_dep_beg_v2,
v2.deposit_life_length as deposit_life_length_v2,
v2.sum_pritok_dep_3_m as sum_pritok_dep_3_m_v2,
v2.share_usd_dep_sum as share_usd_dep_sum_v2,
v2.avg_count_app_onl_day as avg_count_app_onl_day_v2,
v2.avg_count_app_onl_day_x as avg_count_app_onl_day_x_v2,
v2.avg_sum_online_ekt_3_m as avg_sum_online_ekt_3_m_v2,
v2.avg_sum_online_ekt_3_m_x as avg_sum_online_ekt_3_m_x_v2,
v2.avg_term_cred_plan as avg_term_cred_plan_v2,
v2.count_category_3_m as count_category_3_m_v2,
v2.count_category_3_m_x as count_category_3_m_x_v2,
v2.count_fail_30_d as count_fail_30_d_v2,
v2.count_fail_online_30_d as count_fail_online_30_d_v2,
v2.count_fail_online_30_d_x as count_fail_online_30_d_x_v2,
v2.count_mob_kspkz as count_mob_kspkz_v2,
v2.count_visit_guest as count_visit_guest_v2,
v2.count_visit_guest_x as count_visit_guest_x_v2,
v2.count_visit_client as count_visit_client_v2,
v2.count_visit_client_x as count_visit_client_x_v2,
v2.installment_incom_avg as installment_incom_avg_v2,
v2.installment_incom_avg_30d as installment_incom_avg_30d_v2,
v2.installment_incom_avg_30d_x as installment_incom_avg_30d_x_v2,
v2.life_length as life_length_v2,
v2.avg_zp_h as avg_zp_h_v2,
v2.avg_zp_h_x as avg_zp_h_x_v2,
v2.max_zp_h as max_zp_h_v2,
v2.max_zp_h_x as max_zp_h_x_v2,
v2.min_sum_appl_kn_30_d as min_sum_appl_kn_30_d_v2,
v2.min_sum_appl_kn_30_d_x as min_sum_appl_kn_30_d_x_v2,
v2.min_sum_online_ekt_3_m as min_sum_online_ekt_3_m_v2,
v2.min_sum_online_ekt_3_m_x as min_sum_online_ekt_3_m_x_v2,

v2.max_sum_online_ekt_3_m as max_sum_online_ekt_3_m_v2,
v2.max_sum_online_ekt_3_m_x as max_sum_online_ekt_3_m_x_v2,

v2.pkb_count_kzt as pkb_count_kzt_v2,
v2.share_month_kaspikz_6_m as share_month_kaspikz_6_m_v2,
v2.sum_pay_kspkz_30_d as sum_pay_kspkz_30_d_v2,
v2.total_max_delay as total_max_delay_v2,
v2.count_shops_on_client as count_shops_on_client_v2,
v2.count_shops_on_client_x as count_shops_on_client_x_v2,
v2.max_count_app_onl_day as max_count_app_onl_day_v2,
v2.max_count_app_onl_day_x as max_count_app_onl_day_x_v2,
v2.terminal_share_count as terminal_share_count_v2,
v2.count_kn_ever as count_kn_ever,
v2.sum_pay_cred_3_m as sum_pay_cred_3_m_v2,
v2.total_max_delay_2years as total_max_delay_2years_v2

,v2.count_appl_kn_30_d as count_appl_kn_30_d_v2
,v2.count_fail_kn_30_d as count_fail_kn_30_d_v2
,v2.max_sum_appl_kn_30_d as max_sum_appl_kn_30_d_v2

--,v2.count_fail_30_d as count_fail_30_d_v2
,v2.count_applications_30_d as count_applications_30_d_v2
,v2.count_applications_30_d_x as count_applications_30_d_x_v2

  from RISK_RKATE.M_RFO_FRAUD_SEARCH v1
  join RISK_AKNAZAR.M_RFO_FRAUD_SEARCH_ALL_V2 v2 on v2.rfo_con_or_claim_id = v1.app_id
;
grant select on U1.V_RFO_FRAUD_SEARCH_ALL to LOADDB;


