create or replace force view u1.m_app_online_miner_learn_v3 as
select
  am.app_id,
  amb.claim_id,
  t22.process_id,
  am.folder_date_create,

  ----------------------------------------------
  am.prev_con_del_days_max,
  am.fact_pmt_mon_before,
  am.fact_pmt_mon_before_12_mon,
  am.amount_max_before,
  am.prior_optim_count,
  am.prev_con_closed_cnt,
  am.prev_con_cnt,
  am.client_categ,

  ----------------------------------------------
  gr.salary as gcvp_salary,
  gr.pmts_count_all as gcvp_pmts_cnt,
  gr.org_count as gcvp_org_cnt,
  ----------------------------------------------
  gr.rep_pmt_max_date_diff as gcvp_last_pmt_days_ago,
  gr.rep_pmt_min_date_diff as gcvp_first_pmt_days_ago,
  gr.pmts_count_30d as gcvp_pmt_count_30d,
  gr.pmts_count_60d as gcvp_pmt_count_60d,
  case when gr.pmts_count_all = gr.pmts_count_30d then 1 else 0 end as gcvp_is_all_pmts_in_30d,
  case when gr.pmts_count_all = gr.pmts_count_60d then 1 else 0 end as gcvp_is_all_pmts_in_60d,

  ----------------------------------------------
  pr.cred_hist_age_months as pkb_cred_hist_age_mons,
  pr.con_active_cnt as pkb_con_active_cnt,
  pr.con_closed_cnt as pkb_con_closed_cnt,
  pr.con_closed_12m_cnt as pkb_con_closed_12m_cnt,
  pr.total_debt as pkb_total_debt,
  pr.total_debt_close as pkb_total_debt_closed,

  ----------------------------------------------
  frm.inc_sal,
  frm.inc_sal_spouse,
  frm.inc_pension_benefits,
  frm.inc_sal_add,
  frm.exp_utilities,
  frm.marital_status,
  frm.children,
  frm.education,
  frm.real_estate_relation,
  frm.inc_all,

  --
  rbo_p.active_total_debt,
  rbo_p.active_con_cnt,
  rbo_p.is_active_debt_exists,
  rbo_p.is_active_debt_50k_exists,
  rbo_p.is_active_debt_100k_exists,
  rbo_p.is_active_debt_500k_exists,

  --
  frg.is_from_diff_city_reg,
  frg.is_from_diff_city_fact,
  frg.is_from_diff_city_born,

  frg.last_frm_is_child_dif as last_form_is_children_dif_t1,
  frg.last_frm_is_marital_dif as last_form_is_marit_stat_dif_t1,
  frg.last_frm_is_phone_mob_dif as last_form_is_phone_mob_dif_t1,
  frg.last_frm_is_phone_hom_dif as last_form_is_phone_hom_dif_t1,
  frg.last_frm_is_marital_van as last_form_is_married_vanish_t1,
  frg.last_frm_is_child_van as last_form_is_childr_vanish_t1,
  frg.inc_all_to_last_frm_rat as inc_all_to_last_form_ratio_t1,

  frg.patronymic_type,
  ----------------------------------------------
  frg.l180d_frm_is_child_dif as form_180d_is_children_dif,
  frg.l180d_frm_is_marital_dif as form_180d_is_marital_stat_dif,
  frg.l180d_frm_is_phone_mob_dif as form_180d_is_phone_mob_dif,
  frg.l180d_frm_is_phone_hom_dif as form_180d_is_phone_hom_dif,
  frg.l180d_frm_is_marital_van as form_180d_is_married_vanish,
  frg.l180d_frm_is_child_van as form_180d_is_children_vanish,
  frg.inc_all_to_l180d_frm_rat as inc_all_to_form_180d_ratio,

  ----------------------------------------------
  frg30d.dif_children_30d_cnt as dif_children_val_30d_cnt_t1,
  frg30d.dif_marital_30d_cnt as dif_mar_stat_val_30d_cnt_t1,
  frg30d.dif_inc_sal_30d_cnt as dif_inc_sal_val_30d_cnt_t1,
  frg30d.dif_inc_sal_add_30d_cnt as dif_inc_sal_add_val_30d_cnt_t1,
  frg30d.dif_inc_sal_sp_30d_cnt as dif_inc_sal_sps_val30d_cnt_t1,
  frg30d.dif_inc_pens_30d_cnt as dif_inc_pensben_val30d_cnt_t1,

  frg.inc_sal_to_avg_30d_rat as inc_sal_to_avg_30d_ratio_t1,
  frg.inc_all_to_avg_30d_rat as inc_all_to_avg_30d_ratio_t1,
  frg.inc_sal_to_min_30d_rat as inc_sal_to_min_30d_ratio_t1,
  frg.inc_all_to_min_30d_rat as inc_all_to_min_30d_ratio_t1,

  frg30d.dif_phone_mob_30d_cnt as dif_phone_mob_val_30d_cnt_t1,
  frg30d.dif_phone_home_30d_cnt as dif_phone_home_val_30d_cnt_t1,
  frg30d.dif_city_reg_30d_cnt as dif_city_reg_val_30d_cnt_t1,
  frg30d.dif_city_fact_30d_cnt as dif_city_fact_val_30d_cnt_t1,

  ----------------------------------------------
  frg90d.dif_children_90d_cnt as dif_children_val_90d_cnt_t1,
  frg90d.dif_marital_90d_cnt as dif_mar_stat_val_90d_cnt_t1,
  frg90d.dif_inc_sal_90d_cnt as dif_inc_sal_val_90d_cnt_t1,
  frg90d.dif_inc_sal_add_90d_cnt as dif_inc_sal_add_val90dcnt_t1,
  frg90d.dif_inc_sal_sp_90d_cnt as dif_inc_sal_sps_val90d_cnt_t1,
  frg90d.dif_inc_pens_90d_cnt as dif_inc_pensben_val90d_cnt_t1,

  frg.inc_sal_to_avg_90d_rat as inc_sal_to_avg_90d_ratio_t1,
  frg.inc_all_to_avg_90d_rat as inc_all_to_avg_90d_ratio_t1,
  frg.inc_sal_to_min_90d_rat as inc_sal_to_min_90d_ratio_t1,
  frg.inc_all_to_min_90d_rat as inc_all_to_min_90d_ratio_t1,

  frg90d.dif_phone_mob_90d_cnt as dif_phone_mob_val_90d_cnt_t1,
  frg90d.dif_phone_home_90d_cnt as dif_phone_home_val_90d_cnt_t1,
  frg90d.dif_city_reg_90d_cnt as dif_city_reg_val_90d_cnt_t1,
  frg90d.dif_city_fact_90d_cnt as dif_city_fact_val_90d_cnt_t1,

  ----------------------------------------------
  frg_pr30d.dif_children_30d_pr_cnt as dif_children_val_30d_cnt_o_t1,
  frg_pr30d.dif_marital_30d_pr_cnt as dif_martl_val_30d_cnt_o_t1,
  frg_pr30d.dif_inc_sal_30d_pr_cnt as dif_inc_sal_val_30d_cnt_o_t1,
  frg_pr30d.dif_inc_sal_add_30d_pr_cnt as dif_incsal_add_val30d_cnt_o_t1,
  frg_pr30d.dif_inc_sal_sp_30d_pr_cnt as dif_incsal_sps_val30d_cnt_o_t1,
  frg_pr30d.dif_inc_pens_30d_pr_cnt as dif_inc_pensn_val30d_cnt_o_t1,

  frg_pr30d.inc_sal_to_avg_30d_pr_rat as inc_sal_to_avg_30d_ratio_o_t1,
  frg_pr30d.inc_all_to_avg_30d_pr_rat as inc_all_to_avg_30d_ratio_o_t1,
  frg_pr30d.inc_sal_to_min_30d_pr_rat as inc_sal_to_min_30d_ratio_o_t1,
  frg_pr30d.inc_all_to_min_30d_pr_rat as inc_all_to_min_30d_ratio_o_t1,

  frg_pr30d.dif_phone_mob_30d_pr_cnt as dif_phon_mobl_val_30d_cnt_o_t1,
  frg_pr30d.dif_phone_home_30d_pr_cnt as dif_phon_home_val_30d_cnt_o_t1,
  frg_pr30d.dif_city_reg_30d_pr_cnt as dif_city_reg_val_30d_cnt_o_t1,
  frg_pr30d.dif_city_fact_30d_pr_cnt as dif_city_fact_val_30d_cnt_o_t1,

  ----------------------------------------------
  frg_pr90d.dif_children_90d_pr_cnt as dif_children_val_90d_cnt_o_t1,
  frg_pr90d.dif_marital_90d_pr_cnt as dif_martl_st_val_90d_cnt_o_t1,
  frg_pr90d.dif_inc_sal_90d_pr_cnt as dif_inc_sal_val_90d_cnt_o_t1,
  frg_pr90d.dif_inc_sal_add_90d_pr_cnt as dif_inc_saladd_val90d_cnt_o_t1,
  frg_pr90d.dif_inc_sal_sp_90d_pr_cnt as dif_inc_salsps_val90d_cnt_o_t1,
  frg_pr90d.dif_inc_pens_90d_pr_cnt as dif_inc_pensn_val90d_cnt_o_t1,

  frg_pr90d.inc_sal_to_avg_90d_pr_rat as inc_sal_to_avg_90d_ratio_o_t1,
  frg_pr90d.inc_all_to_avg_90d_pr_rat as inc_all_to_avg_90d_ratio_o_t1,
  frg_pr90d.inc_sal_to_min_90d_pr_rat as inc_sal_to_min_90d_ratio_o_t1,
  frg_pr90d.inc_all_to_min_90d_pr_rat as inc_all_to_min_90d_ratio_o_t1,

  frg_pr90d.dif_phone_mob_90d_pr_cnt as dif_phon_mobl_val_90d_cnt_o_t1,
  frg_pr90d.dif_phone_home_90d_pr_cnt as dif_phon_home_val_90d_cnt_o_t1,
  frg_pr90d.dif_city_reg_90d_pr_cnt as dif_city_reg_val_90d_cnt_o_t1,
  frg_pr90d.dif_city_fact_90d_pr_cnt as dif_city_fact_val_90d_cnt_o_t1,
  ----------------------------------------------

  --------------------------------------
  t1.cnt_cl_claim_t1 as onl_app_30d_cnt_t1,
  t1.cnt_cl_issued_t1 as onl_app_iss_30d_cnt_t1,
  t1.cnt_cl_cancel_t1 as onl_app_cancel_cli_30d_cnt_t1,
  t1.cnt_cl_model_t1 as onl_model_30d_cnt_t1,
  t1.cnt_cl_categ_t1 as onl_categ_30d_cnt_t1,
--  t1.cnt_cl_categ_cancel, ??? это дубль t1.cnt_cl_cancel
  t1.cnt_cl_eq_models_t1 as onl_app_same_model_30d_cnt_t1,
  t1.cnt_cl_eq_categ_t1 as onl_app_same_categ_30d_cnt_t1,
  t1.cnt_cl_eq_model_app_t1 as onl_app_iss_sm_mdl_30d_cnt_t1,
  t1.cnt_cl_eq_categ_app_t1 as onl_app_iss_sm_ctg_30d_cnt_t1,
  t1.cnt_cl_delivered_t1 as onl_app_delivery_30d_cnt_t1,
  t1.sum_cl_t1 as onl_app_amount_30d_sum_t1,--2
  t1.sum_cl_app_t1 as onl_app_iss_amount_30d_sum_t1,--2
  t1.cnt_cl_dif_shops_t1 as onl_shop_30d_cnt_t1,
  t1.cnt_cl_dif_shops_cancel_t1 as onl_shop_cancel_cli_30d_cnt_t1,
  t1.cnt_cl_mobile_phone_t1 as onl_mobile_30d_cnt_t1,
--  cnt_cl_googleid, -- не используем ничего, связанного с Google_id
  t1.cnt_cl_kn_t1 as kn_app_30d_cnt_t1,
  t1.cnt_cl_kn_cancel_t1 as kn_app_cancel_30d_cnt_t1,
  t1.cnt_cl_offline_t1 as goods_offl_app_30d_cnt_t1,
  t1.cnt_cl_offline_cancel_t1 as goods_offl_app_cnl_30d_cnt_t1,

  ----------------------------------------------
  --t21.income_form,
  --t21.income_form_all,
  t21.age,
  t21.reg_kaspikz_length_v3,
  t21.avg_sum_pay_kspkz_30_d,
  t21.count_month_kaspikz_6_m,
  t21.count_pay_kspkz_30_d,
  t21.count_serv_kspkz_6_m,
  t21.kommunalka_kaspikz_6_m,
  --t21.count_mob_kspkz,
  --t21.sum_pay_kspkz_30_d,
  t21.session_ksp_last_6_mnth_t1,
  t21.count_day_app_onl,
  t21.max_count_fail_onl_day,
  t21.last_year_max_delay_t1,
  --t21.pkb_debt_kzt,
  --t21.income_gcvp,
  t21.days_last_gcvp,
  t21.diff_zp_form_gcvp,
  t21.diff_zp_form_all_gcvp,
  t21.avg_sum_pay_cred_3_m_t1,
  t21.count_salary_6_m_t1,
  t21.kaspi_gold_active_t1,
  t21.max_tov_categ_code_t1,
  t21.max_count_category_day_t1,
  --t21.max_prod_models_day_t1,
  t21.max_count_models_day_t1,
  t21.ex_terminal_share_count_t1,
  t21.fail_share_30_d_count,
  t21.share_30_d_count,
  t21.ex_terminal_share_t1,
  t21.fail_share_30_d,
  t21.ii,

  t22.max_sum_online_ekt_3_m as max_sum_online_ekt_3_m_v2,
  --t22.max_sum_online_ekt_3_m_x_v2,
  t22.count_appl_kn_30_d as count_appl_kn_30_d_v2,
  t22.count_fail_kn_30_d as count_fail_kn_30_d_v2,
  t22.max_sum_appl_kn_30_d as max_sum_appl_kn_30_d_v2,
  t22.count_applications_30_d as count_applications_30_d_v2,
  t22.count_applications_30_d_x_v3,

  t22.balance_all_dep_beg_m as balance_all_dep_beg_m_v2,
  t22.balance_all_dep_beg as balance_all_dep_beg_v2,
  t22.deposit_life_length as deposit_life_length_v2,
  t22.sum_pritok_dep_3_m as sum_pritok_dep_3_m_v2,
  t22.share_usd_dep_sum as share_usd_dep_sum_v2,
  t22.avg_count_app_onl_day as avg_count_app_onl_day_v2,
  --t22.avg_count_app_onl_day_x_v2,
  t22.avg_sum_online_ekt_3_m as avg_sum_online_ekt_3_m_v2,
  --t22.avg_sum_online_ekt_3_m_x_v2,
  t22.avg_term_cred_plan as avg_term_cred_plan_v2,
  t22.count_category_3_m as count_category_3_m_v2,
  --t22.count_category_3_m_x_v2,
  t22.count_fail_30_d as count_fail_30_d_v2,
  t22.count_fail_online_30_d as count_fail_online_30_d_v2,
  --t22.count_fail_online_30_d_x_v2,
  t22.count_mob_kspkz as count_mob_kspkz_v2,
  t22.count_visit_guest as count_visit_guest_v2,
  --t22.count_visit_guest_x_v2,
  t22.count_visit_client as count_visit_client_v2,
  --t22.count_visit_client_x_v2,
  t22.installment_incom_avg as installment_incom_avg_v2,
  t22.installment_incom_avg_30d as installment_incom_avg_30d_v2,
  --t22.installment_incom_avg_30d_x_v2,
  t22.life_length as life_length_v2,
  t22.avg_zp_h as avg_zp_h_v2,
  --t22.avg_zp_h_x_v2,
  t22.max_zp_h as max_zp_h_v2,
  --t22.max_zp_h_x_v2,
  t22.min_sum_appl_kn_30_d as min_sum_appl_kn_30_d_v2,
  --t22.min_sum_appl_kn_30_d_x_v2,
  t22.min_sum_online_ekt_3_m as min_sum_online_ekt_3_m_v2,
  --t22.min_sum_online_ekt_3_m_x_v2,
  --t22.pkb_count_kzt as pkb_count_kzt_v2,
  t22.share_month_kaspikz_6_m as share_month_kaspikz_6_m_v2,
  t22.sum_pay_kspkz_30_d as sum_pay_kspkz_30_d_v2,
  t22.total_max_delay as total_max_delay_v2,
  t22.count_shops_on_client as count_shops_on_client_v2,
  --t22.count_shops_on_client_x_v2,
  t22.max_count_app_onl_day as max_count_app_onl_day_v2,
  --t22.max_count_app_onl_day_x_v2,
  t22.terminal_share_count as terminal_share_count_v2,
  t22.count_kn_ever,
  t22.sum_pay_cred_3_m as sum_pay_cred_3_m_v2,
  t22.total_max_delay_2years as total_max_delay_2years_v2

from U1.M_APP_MINER am
left join U1.M_APP_MINER_BAS amb on amb.app_id = am.app_id --на удаление привязаться к U1.M_APP_MINER

left join U1.M_APP_MINER_GCVP gr on gr.app_id = am.app_id
left join U1.M_APP_MINER_PKB pr on pr.app_id = am.app_id
left join U1.M_APP_MINER_FORM_CLIENT frm on frm.app_id = am.app_id
left join U1.M_APP_MINER_RBO_PORT rbo_p on rbo_p.app_id = am.app_id

left join U1.M_APP_MINER_FORM_GUESS frg on frg.app_id = am.app_id
left join U1.M_APP_MINER_FORM_GUESS_PRE1 frg1 on frg1.app_id = am.app_id

left join U1.M_APP_MINER_FORM_GUESS_30D frg30d on frg30d.app_id = am.app_id
left join U1.M_APP_MINER_FORM_GUESS_90D frg90d on frg90d.app_id = am.app_id

left join U1.M_APP_MINER_FORM_GUESS_PR_30D frg_pr30d on frg_pr30d.app_id = am.app_id
left join U1.M_APP_MINER_FORM_GUESS_PR_90D frg_pr90d on frg_pr90d.app_id = am.app_id

--
--left join RISK_JAN.M_TMP_J_ONLINE_FORM_GUESS_1_V2 t5 on t5.claim_id = amb.claim_id
--left join RISK_JAN.M_TMP_J_ONLINE_FORM_GUESS_2_V2 t6 on t6.claim_id = amb.claim_id
--left join RISK_JAN.M_TMP_J_ONLINE_FORM_GUESS_3_V2 t7 on t7.claim_id = amb.claim_id
--left join RISK_JAN.M_TMP_J_ONLINE_FORM_GUESS_4_V2 t8 on t8.claim_id = amb.claim_id
--left join RISK_JAN.M_TMP_J_ONLINE_FORM_GUESS_5 t9 on t9.claim_id = amb.claim_id
--left join RISK_JAN.M_TMP_J_ONLINE_FORM_GUESS_6_V2 g6 on g6.claim_id = amb.claim_id
--left join RISK_JAN.M_TMP_J_ONLINE_FORM_GUESS_7 g7 on g7.claim_id = amb.claim_id

left join U1.V_APP_MINER_ONLINE_OLD t1 on t1.app_id = am.app_id

--
left join U1.M_RFO_FRAUD_SEARCH_V2 t22 on t22.claim_id = amb.claim_id
left join U1.M_RFO_FRAUD_SEARCH t21 on t21.claim_id = amb.claim_id
where am.product_type = 'ОНЛАЙН-КРЕДИТ'
;
grant select on U1.M_APP_ONLINE_MINER_LEARN_V3 to LOADDB;


