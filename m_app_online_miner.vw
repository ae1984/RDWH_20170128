﻿create or replace force view u1.m_app_online_miner as
select
  am.app_id                                                         as app_id,
--  t1.rfo_client_id,
--  to_char(folder_date_create_mi,'yyyy-mm') as text_yyyy_mm,
--  folder_date_create_mi,
  t1.cnt_cl_claim                                                   as onl_app_30d_cnt,
  t1.cnt_cl_issued                                                  as onl_app_iss_30d_cnt,
  t1.cnt_cl_cancel                                                  as onl_app_cancel_cli_30d_cnt,
  t1.cnt_cl_model                                                   as onl_model_30d_cnt,
  t1.cnt_cl_categ                                                   as onl_categ_30d_cnt,
--  t1.cnt_cl_categ_cancel, ??? это дубль t1.cnt_cl_cancel
  t1.cnt_cl_eq_models                                               as onl_app_same_model_30d_cnt,
  t1.cnt_cl_eq_categ                                                as onl_app_same_categ_30d_cnt,
  t1.cnt_cl_eq_model_app                                            as onl_app_iss_same_model_30d_cnt,
  t1.cnt_cl_eq_categ_app                                            as onl_app_iss_same_categ_30d_cnt,
  t1.cnt_cl_delivered                                               as onl_app_delivery_30d_cnt,
  t1.sum_cl                                                         as onl_app_amount_30d_sum,--2
  t1.sum_cl_app                                                     as onl_app_iss_amount_30d_sum,--2
  t1.cnt_cl_dif_shops                                               as onl_shop_30d_cnt,
  t1.cnt_cl_dif_shops_cancel                                        as onl_shop_cancel_cli_30d_cnt,
  t1.cnt_cl_mobile_phone                                            as onl_mobile_30d_cnt,
--  cnt_cl_googleid, -- не используем ничего, связанного с Google_id
  t1.cnt_cl_kn                                                      as kn_app_30d_cnt,
  t1.cnt_cl_kn_cancel                                               as kn_app_cancel_30d_cnt,
  t1.cnt_cl_offline                                                 as offl_app_30d_cnt,
  t1.cnt_cl_offline_cancel                                          as offl_app_cancel_30d_cnt,

  ----------------------------------------------
  gr.salary                                                         as gcvp_salary,
  gr.pmts_count_all                                                 as gcvp_pmts_cnt,
  gr.org_count                                                      as gcvp_org_cnt,
  ----------------------------------------------
  gr.rep_pmt_max_date_diff                                          as gcvp_last_pmt_days_ago,
  gr.rep_pmt_min_date_diff                                          as gcvp_first_pmt_days_ago,
  gr.pmts_count_30d                                                 as gcvp_pmt_count_30d,
  gr.pmts_count_60d                                                 as gcvp_pmt_count_60d,
  case when gr.pmts_count_all = gr.pmts_count_30d then 1 else 0 end as gcvp_is_all_pmts_in_30d,
  case when gr.pmts_count_all = gr.pmts_count_60d then 1 else 0 end as gcvp_is_all_pmts_in_60d,

  ----------------------------------------------
  am.prev_con_del_days_max                                          as con_del_days_max, /**/
  am.fact_pmt_mon_before                                            as pmt_cnt,
  am.fact_pmt_mon_before_12_mon                                     as pmt_12m_cnt,
  am.amount_max_before                                              as amount_max,
  am.prior_optim_count                                              as optim_cnt,
  am.prev_con_closed_cnt                                            as con_closed_cnt,
  am.prev_con_cnt                                                   as con_cnt,
  ----------------------------------------------
  pr.cred_hist_age_months                                           as pkb_cred_hist_age_mons,
  pr.con_active_cnt                                                 as pkb_con_active_cnt,
  pr.con_closed_cnt                                                 as pkb_con_closed_cnt,
  pr.con_closed_12m_cnt                                             as pkb_con_closed_12m_cnt,
  pr.total_debt                                                     as pkb_total_debt,
  pr.total_debt_close                                               as pkb_total_debt_closed,

  ----------------------------------------------
  frm.inc_sal                                                    as form_inc_salary,
  frm.inc_all                                                as form_inc_all,

  t2.age                                                            as age,
  t2.reg_kaspikz_length                                             as kspkz_reg_folder_date_length,
  t2.avg_sum_pay_kspkz_30_d                                         as kspkz_pay_30d_sum_avg,
  t2.count_month_kaspikz_6_m                                        as kspkz_6m_month_cnt,
  t2.count_pay_kspkz_30_d                                           as kspkz_pay_30d_cnt,
  t2.count_serv_kspkz_6_m                                           as kspkz_serv_6m_cnt,
  t2.kommunalka_kaspikz_6_m                                         as kspkz_kommunalka_6m_avg,
 -- t2.count_mob_kspkz                                                as kspkz_mob_cnt,
  t2.sum_pay_kspkz_30_d                                             as kspkz_pay_30d_sum,
  --share_month_kaspikz_6_m,
  t2.session_ksp_last_6_mnth                                        as kspkz_last_session_6m,
  t2.count_day_app_onl                                              as onl_app_day_cnt,
  t2.max_sum_online_ekt_3_m_v2                                      as onl_ekt_amount_3m_max_t_1,
  t2.max_sum_online_ekt_3_m_x_v2                                    as onl_ekt_amount_3m_max,
 -- t2.count_appl_kn_30_d_v2                                          as kn_app_30d_cnt,
  t2.count_fail_kn_30_d_v2                                          as kn_fail_30d_cnt,
  t2.max_sum_appl_kn_30_d_v2                                        as kn_app_30d_amount_max,
  --count_fail_30_d,
  --t2.count_applications_30_d_v2                                     as onl_app_30d_cnt,
  --t2.count_applications_30_d_x_v2                                   as onl_app_30d_cnt,
  t2.max_count_fail_onl_day                                         as onl_fail_day_cnt_max,
  t2.last_year_max_delay                                            as onl_del_last_year_max,
  t2.pkb_debt_kzt                                                   as pkb_debt_kzt,
  --t2.income_gcvp                                                    as x,
  t2.days_last_gcvp                                                 as gcvp_days_last,
  t2.diff_zp_form_gcvp                                              as gcvp_salary_form_diff,
  t2.diff_zp_form_all_gcvp                                          as gcvp_salary_form_diff_all,
  t2.avg_sum_pay_cred_3_m                                           as onl_amount_pay_cred_3m,
  --count_visit_guest,
  t2.count_salary_6_m                                               as onl_salary_6m_cnt,
  t2.kaspi_gold_active                                              as kaspi_gold_active,
  t2.max_tov_categ_code                                             as onl_tov_categ_code_max,
  t2.max_count_category_day                                         as onl_claim_tov_categ_cnt_max,
  --count_category_3_m_v2,
  --count_category_3_m_x_v2,
  t2.max_prod_models_day                                            as onl_prod_models_max,
  t2.max_count_models_day                                           as onl_prod_models_cnt_share_max,
  t2.ex_terminal_share_count                                        as terminal_external_oper_cnt,
  t2.fail_share_30_d_count                                          as onl_app_fail_30d_cnt_share,
  --terminal_share_count,
  t2.share_30_d_count                                               as onl_app_30d_cnt_share,
  t2.ex_terminal_share                                              as terminal_external_share,
  t2.fail_share_30_d                                                as fail_share_30_d,
  t2.ii                                                             as internet_index_max,
  --avg_zp_h,
  t2.balance_all_dep_beg_m_v2                                       as dep_balance_all_beg_m_sum,
  t2.balance_all_dep_beg_v2                                         as dep_balance_all_claim_date_sum,
  t2.deposit_life_length_v2                                         as deposit_life_length,
  t2.sum_pritok_dep_3_m_v2                                          as deposit_amount_pritok,
  t2.share_usd_dep_sum_v2                                           as deposit_amount_usd_share,
  t2.avg_count_app_onl_day_v2                                       as onl_app_day_cnt_avg_t_1,
  t2.avg_count_app_onl_day_x_v2                                     as onl_app_day_cnt_avg,
  t2.avg_sum_online_ekt_3_m_v2                                      as onl_ekt_amount_3m_avg_t_1,
  t2.avg_sum_online_ekt_3_m_x_v2                                    as onl_ekt_amount_3m_avg,
  t2.avg_term_cred_plan_v2                                          as onl_app_term_cred_plan_avg,
  t2.count_category_3_m_v2                                          as onl_app_category_3m_cnt_t_1,
  t2.count_category_3_m_x_v2                                        as onl_app_category_3m_cnt,
  t2.count_fail_30_d_v2                                             as app_fail_30d_cnt,
  t2.count_fail_online_30_d_v2                                      as onl_app_fail_30d_cnt_t_1,
  t2.count_fail_online_30_d_x_v2                                    as onl_app_fail_30d_cnt,
  t2.count_mob_kspkz_v2                                             as kspkz_mob_cnt,
  t2.count_visit_guest_v2                                           as onl_guest_visit_cnt_t_1,
  t2.count_visit_guest_x_v2                                         as onl_guest_visit_cnt,
  t2.count_visit_client_v2                                          as onl_client_cnt_t_1,
  t2.count_visit_client_x_v2                                        as onl_client_cnt,
  t2.installment_incom_avg_v2                                       as installment_incom_avg,
  t2.installment_incom_avg_30d_v2                                   as installment_incom_30d_avg,
  t2.installment_incom_avg_30d_x_v2                                 as installment_incom_30d_avg_yday,
  t2.life_length_v2                                                 as life_length,
  t2.avg_zp_h_v2                                                    as rfo_salary_avg_t_1,
  t2.avg_zp_h_x_v2                                                  as rfo_salary_avg,
  t2.max_zp_h_v2                                                    as rfo_salary_max_t_1,
  t2.max_zp_h_x_v2                                                  as rfo_salary_max,
  t2.min_sum_appl_kn_30_d_v2                                        as kn_app_amount_30d_min_t_1,
  t2.min_sum_appl_kn_30_d_x_v2                                      as kn_app_amount_30d_min,
  t2.min_sum_online_ekt_3_m_v2                                      as onl_ekt_amount_3m_min_t_1,
  t2.min_sum_online_ekt_3_m_x_v2                                    as onl_ekt_amount_3m_min,
--  t2.pkb_count_kzt_v2                                               as pkb_kzt_cnt,
  t2.share_month_kaspikz_6_m_v2                                     as kspkz_month_6m_share,
  t2.sum_pay_kspkz_30_d_v2                                          as kspkz_pay_amount_30d,
  --t2.total_max_delay_v2                                             as x,
  t2.count_shops_on_client_v2                                       as onl_shop_client_cnt_t_1,
  t2.count_shops_on_client_x_v2                                     as onl_shop_client_cnt,
  t2.max_count_app_onl_day_v2                                       as onl_app_day_cnt_max_t_1,
  t2.max_count_app_onl_day_x_v2                                     as onl_app_day_cnt_max,
  t2.terminal_share_count_v2                                        as terminal_cnt_share,
  t2.count_kn_ever                                                  as kn_ever_cnt,
  t2.sum_pay_cred_3_m_v2                                            as cred_pay_amount_3m,
  t2.total_max_delay_2years_v2                                      as cred_delay_total_2y_max,


  ----------------------------------------------
  frg30d.dif_children_30d_cnt_x                                       as dif_children_val_30d_cnt,
  frg30d.dif_marital_30d_cnt_x                                   as dif_marital_stat_val_30d_cnt,
  frg30d.dif_inc_sal_30d_cnt_x                                        as dif_inc_sal_val_30d_cnt,
  frg30d.dif_inc_sal_add_30d_cnt_x                                    as dif_inc_sal_add_val_30d_cnt,
  frg30d.dif_inc_sal_sp_30d_cnt_x                                 as dif_inc_sal_spouse_val30d_cnt,
  frg30d.dif_inc_pens_30d_cnt_x                                  as dif_inc_pensionben_val30d_cnt,

  frg.inc_sal_to_avg_30d_rat_x                                       as inc_sal_to_avg_30d_ratio,
  frg.inc_all_to_avg_30d_rat_x                                       as inc_all_to_avg_30d_ratio,
  frg.inc_sal_to_min_30d_rat_x                                       as inc_sal_to_min_30d_ratio,
  frg.inc_all_to_min_30d_rat_x                                       as inc_all_to_min_30d_ratio,

  frg30d.dif_phone_mob_30d_cnt_x                                   as dif_phone_mobile_val_30d_cnt,
  frg30d.dif_phone_home_30d_cnt_x                                     as dif_phone_home_val_30d_cnt,
  frg30d.dif_city_reg_30d_cnt_x                                       as dif_city_reg_val_30d_cnt,
  frg30d.dif_city_fact_30d_cnt_x                                      as dif_city_fact_val_30d_cnt,
  ----------------------------------------------
  frg90d.dif_children_90d_cnt_x                                       as dif_children_val_90d_cnt,
  frg90d.dif_marital_90d_cnt_x                                   as dif_marital_stat_val_90d_cnt,
  frg90d.dif_inc_sal_90d_cnt_x                                        as dif_inc_sal_val_90d_cnt,
  frg90d.dif_inc_sal_add_90d_cnt_x                                    as dif_inc_sal_add_val_90d_cnt,
  frg90d.dif_inc_sal_sp_90d_cnt_x                                  as dif_inc_sal_spouse_val90d_cnt,
  frg90d.dif_inc_pens_90d_cnt_x                                  as dif_inc_pensionben_val90d_cnt,

  frg.inc_sal_to_avg_90d_rat_x                                       as inc_sal_to_avg_90d_ratio,
  frg.inc_all_to_avg_90d_rat_x                                       as inc_all_to_avg_90d_ratio,
  frg.inc_sal_to_min_90d_rat_x                                       as inc_sal_to_min_90d_ratio,
  frg.inc_all_to_min_90d_rat_x                                       as inc_all_to_min_90d_ratio,

  frg90d.dif_phone_mob_90d_cnt_x                                   as dif_phone_mobile_val_90d_cnt,
  frg90d.dif_phone_home_90d_cnt_x                                     as dif_phone_home_val_90d_cnt,
  frg90d.dif_city_reg_90d_cnt_x                                       as dif_city_reg_val_90d_cnt,
  frg90d.dif_city_fact_90d_cnt_x                                      as dif_city_fact_val_90d_cnt,

  ----------------------------------------------
  frg_pr30d.dif_children_30d_pr_cnt_x                                     as onl_dif_children_val_30d_cnt,
  frg_pr30d.dif_marital_30d_pr_cnt_x                                   as onl_dif_martl_stat_val_30d_cnt,
  frg_pr30d.dif_inc_sal_30d_pr_cnt_x                                      as onl_dif_sal_val_30d_cnt,
  frg_pr30d.dif_inc_sal_add_30d_pr_cnt_x                                   as onl_dif_sal_add_val30d_cnt,
  frg_pr30d.dif_inc_sal_sp_30d_pr_cnt_x                                   as onl_dif_sal_sps_val30d_cnt,
  frg_pr30d.dif_inc_pens_30d_pr_cnt_x                                  as onl_dif_pensnben_val30d_cnt,
  frg_pr30d.inc_sal_avg_30d_pr_x                                     as onl_inc_sal_to_avg_30d_ratio,
  frg_pr30d.inc_all_avg_30d_pr_x                                     as onl_inc_all_to_avg_30d_ratio,
  frg_pr30d.inc_sal_min_30d_pr_x                                     as onl_inc_sal_to_min_30d_ratio,
  frg_pr30d.inc_all_min_30d_pr_x                                     as onl_inc_all_to_min_30d_ratio,
  frg_pr30d.dif_phone_mob_30d_pr_cnt_x                                 as onl_dif_phone_mob_val_30d_cnt,
  frg_pr30d.dif_phone_home_30d_pr_cnt_x                                   as onl_dif_phone_home_val_30d_cnt,
  frg_pr30d.dif_city_reg_30d_pr_cnt_x                                     as onl_dif_city_reg_val_30d_cnt,
  frg_pr30d.dif_city_fact_30d_pr_cnt_x                                    as onl_dif_city_fact_val_30d_cnt,

  ----------------------------------------------
  frg_pr90d.dif_children_90d_pr_cnt_x                                     as onl_dif_children_val_90d_cnt,
  frg_pr90d.dif_marital_90d_pr_cnt_x                                   as onl_dif_martl_stat_val_90d_cnt,
  frg_pr90d.dif_inc_sal_90d_pr_cnt_x                                      as onl_dif_sal_val_90d_cnt,
  frg_pr90d.dif_inc_sal_add_90d_pr_cnt_x                                   as onl_dif_sal_add_val90d_cnt,
  frg_pr90d.dif_inc_sal_sp_90d_pr_cnt_x                                   as onl_dif_sal_sps_val90d_cnt,
  frg_pr90d.dif_inc_pens_90d_pr_cnt_x                                  as onl_dif_pensnben_val90d_cnt,
  frg_pr90d.inc_sal_avg_90d_pr_x                                     as onl_inc_sal_to_avg_90d_ratio,
  frg_pr90d.inc_all_avg_90d_pr_x                                     as onl_inc_all_to_avg_90d_ratio,
  frg_pr90d.inc_sal_min_90d_pr_x                                     as onl_inc_sal_to_min_90d_ratio,
  frg_pr90d.inc_all_min_90d_pr_x                                     as onl_inc_all_to_min_90d_ratio,
  frg_pr90d.dif_phone_mob_90d_pr_cnt_x                                 as onl_dif_phone_mob_val_90d_cnt,
  frg_pr90d.dif_phone_home_90d_pr_cnt_x                                   as onl_dif_phone_home_val_90d_cnt,
  frg_pr90d.dif_city_reg_90d_pr_cnt_x                                     as onl_dif_city_reg_val_90d_cnt,
  frg_pr90d.dif_city_fact_90d_pr_cnt_x                                    as onl_dif_city_fact_val_90d_cnt,
  ----------------------------------------------
  frg.is_from_diff_city_reg                                          as is_from_diff_city_reg,
  frg.is_from_diff_city_fact                                         as is_from_diff_city_fact,
  frg.is_from_diff_city_born                                         as is_from_diff_city_born,

  am.client_categ                                                   as client_categ,
  rbo_p.active_total_debt                                              as active_total_debt,
  rbo_p.active_con_cnt                                                 as active_con_cnt,
  rbo_p.is_active_debt_exists                                          as is_active_debt_exists,
  rbo_p.is_active_debt_50k_exists                                      as is_active_debt_50k_exists,
  rbo_p.is_active_debt_100k_exists                                     as is_active_debt_100k_exists,
  rbo_p.is_active_debt_500k_exists                                     as is_active_debt_500k_exists,

  ----------------------------------------------
  --t10.inc_sal,
  frm.inc_sal_spouse                                                as form_salary_supose,
  frm.inc_pension_benefits                                          as form_pension_benefits,
  frm.inc_sal_add                                                   as form_salary_add,
  frm.exp_utilities                                                 as form_exp_utilities,
  frm.marital_status                                                as form_marital_status,
  frm.children                                                      as form_children,
  frm.education                                                     as form_education,
  frm.real_estate_relation                                          as real_estate_relation,
  ----------------------------------------------
  frg.last_frm_is_child_dif_x                                       as last_form_is_children_dif,
  frg.last_frm_is_marital_dif_x                                     as last_form_is_marital_stat_dif,
  frg.last_frm_is_phone_mob_dif_x                                   as last_form_is_phone_mob_dif,
  frg.last_frm_is_phone_hom_dif_x                                   as last_form_is_phone_hom_dif,
  frg.last_frm_is_marital_van_x                                   as last_form_is_married_vanish,
  frg.last_frm_is_child_van_x                                  as last_form_is_children_vanish,
  frg.inc_all_to_last_frm_rat_x                                   as inc_all_to_last_form_ratio,
  frg.patronymic_type,
  ----------------------------------------------
  frg.l180d_frm_is_child_dif                                      as form_180d_is_children_dif,
  frg.l180d_frm_is_marital_dif                                  as form_180d_is_marital_stat_dif,
  frg.l180d_frm_is_phone_mob_dif                                     as form_180d_is_phone_mob_dif,
  frg.l180d_frm_is_phone_hom_dif                                    as form_180d_is_phone_hom_dif,
  frg.l180d_frm_is_marital_van                                    as form_180d_is_married_vanish,
  frg.l180d_frm_is_child_van                                   as form_180d_is_children_vanish,
  frg.inc_all_to_l180d_frm_rat                                     as inc_all_to_form_180d_ratio,
  ----------------------------------------------
  case when nvl(d.device_subcat_by_phone_30d, 'UserDevice') = 'SuperAgent' then 1 else 0 end as trgt

from U1.M_APP_MINER_BAS am
left join U1.V_APP_MINER_ONLINE_OLD t1 on t1.app_id = am.app_id
left join U1.M_FOLDER_CON_CANCEL_ONLINE_1 f on f.claim_id = am.claim_id

left join U1.M_APP_MINER_GCVP gr on gr.app_id = am.app_id
left join U1.M_APP_MINER_PKB pr on pr.app_id = am.app_id
left join U1.M_APP_MINER_FORM_CLIENT frm on frm.app_id = am.app_id

left join U1.M_APP_MINER_RBO_PORT rbo_p on rbo_p.app_id = am.app_id

left join U1.M_APP_MINER_FORM_GUESS frg on frg.app_id = am.app_id
left join U1.M_APP_MINER_FORM_GUESS_PRE1 frg1 on frg1.app_id = am.app_id

left join U1.M_APP_MINER_FORM_GUESS_30DX frg30d on frg30d.app_id = am.app_id
left join U1.M_APP_MINER_FORM_GUESS_90DX frg90d on frg90d.app_id = am.app_id

left join U1.M_APP_MINER_FORM_GUESS_PR_30DX frg_pr30d on frg_pr30d.app_id = am.app_id
left join U1.M_APP_MINER_FORM_GUESS_PR_90DX frg_pr90d on frg_pr90d.app_id = am.app_id

--left join RISK_JAN.M_TMP_J_ONLINE_FORM_GUESS_1 t5 on t5.claim_id = am.claim_id
--left join RISK_JAN.M_TMP_J_ONLINE_FORM_GUESS_2 t6 on t6.claim_id = am.claim_id
--left join RISK_JAN.M_TMP_J_ONLINE_FORM_GUESS_3 t7 on t7.claim_id = am.claim_id
--left join RISK_JAN.M_TMP_J_ONLINE_FORM_GUESS_4 t8 on t8.claim_id = am.claim_id
--left join RISK_JAN.M_TMP_J_ONLINE_FORM_GUESS_5 t9 on t9.claim_id = am.claim_id

--left join RISK_JAN.M_TMP_J_MINER_GCVP_1 g2 on g2.gcvp_rep_id = gr.gcvp_report_id

--left join RISK_JAN.M_TMP_J_ONLINE_FORM_GUESS_6 g6 on g6.claim_id = am.claim_id
--left join RISK_JAN.M_TMP_J_ONLINE_FORM_GUESS_7 g7 on g7.claim_id = am.claim_id

--remove
left join U1.V_RFO_FRAUD_SEARCH t2 on t2.claim_id = am.claim_id

--
left join U1.M_KASPISH_ORDERS ko on ko.code = f.process_id
left join U1.M_ONLINE_DEVICE d on d.ga_client_id = ko.p_gaclientid
                                  and d.yyyy_mm_dd = trunc(am.folder_date_create_mi)



where am.product_type = 'ОНЛАЙН-КРЕДИТ'
      and to_char(am.folder_date_create_mi,'yyyy-mm') in ('2016-05','2016-06')
;
grant select on U1.M_APP_ONLINE_MINER to LOADDB;


