create or replace force view u1.v_app_all_miner as
select /*+ parallel(10) */
  am.app_id,
  am.folder_date_create,
  am.product_type,
  am.product,

  ---------------------------------------
  --am.cli_cat,
  am.cli_cat as client_categ,
  am.cat_union,
  am.prev_con_del_days_max,
  am.fact_pmt_mon_before,
  am.fact_pmt_mon_before_12_mon,
  am.amount_max_before,
  am.prior_optim_count,
  am.prev_con_closed_cnt,
  am.prev_con_cnt,
  am.wife_cat,
  am.contract_amount,
  am.contract_term_mon,
  am.cnt_auto,
  am.br_r_cnt,
  am.br_r_closed_cnt,
  am.is_client_new_by_con,

  --U1.M_APP_MINER_GCVP
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

  --U1.M_APP_MINER_PKB
  pr.cred_hist_age_months as pkb_cred_hist_age_mons,
  pr.con_active_cnt as pkb_con_active_cnt,
  pr.con_closed_cnt as pkb_con_closed_cnt,
  pr.con_closed_12m_cnt as pkb_con_closed_12m_cnt,
  pr.total_debt as pkb_total_debt,
  pr.total_debt_close as pkb_total_debt_closed,

  --U1.M_APP_MINER_FORM_CLIENT
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

  --U1.M_APP_MINER_FORM_GUESS
  frg.is_from_diff_city_reg,
  frg.is_from_diff_city_fact,
  frg.is_from_diff_city_born,
  frg.patronymic_type,

  frg.inc_sal_to_avg_30d_rat,
  frg.inc_sal_to_avg_90d_rat,
  frg.inc_sal_to_avg_30d_rat_x,
  frg.inc_sal_to_avg_90d_rat_x,
  frg.inc_sal_to_min_30d_rat,
  frg.inc_sal_to_min_90d_rat,
  frg.inc_sal_to_min_30d_rat_x,
  frg.inc_sal_to_min_90d_rat_x,
  frg.inc_sal_to_max_30d_rat,
  frg.inc_sal_to_max_90d_rat,
  frg.inc_sal_to_max_30d_rat_x,
  frg.inc_sal_to_max_90d_rat_x,
  frg.inc_all_to_avg_30d_rat,
  frg.inc_all_to_avg_90d_rat,
  frg.inc_all_to_avg_30d_rat_x,
  frg.inc_all_to_avg_90d_rat_x,
  frg.inc_all_to_min_30d_rat,
  frg.inc_all_to_min_90d_rat,
  frg.inc_all_to_min_30d_rat_x,
  frg.inc_all_to_min_90d_rat_x,
  frg.inc_all_to_max_30d_rat,
  frg.inc_all_to_max_90d_rat,
  frg.inc_all_to_max_30d_rat_x,
  frg.inc_all_to_max_90d_rat_x,

  frg.last_frm_is_child_dif,
  frg.last_frm_is_marital_dif,
  frg.last_frm_is_phone_mob_dif,
  frg.last_frm_is_phone_hom_dif,
  frg.last_frm_is_child_van,
  frg.last_frm_is_marital_van,
  frg.inc_sal_to_last_frm_rat,
  frg.inc_all_to_last_frm_rat,
  frg.last_frm_is_child_dif_x,
  frg.last_frm_is_marital_dif_x,
  frg.last_frm_is_phone_mob_dif_x,
  frg.last_frm_is_phone_hom_dif_x,
  frg.last_frm_is_child_van_x,
  frg.last_frm_is_marital_van_x,
  frg.inc_sal_to_last_frm_rat_x,
  frg.inc_all_to_last_frm_rat_x,

  frg.l180d_frm_is_child_dif,
  frg.l180d_frm_is_marital_dif,
  frg.l180d_frm_is_phone_mob_dif,
  frg.l180d_frm_is_phone_hom_dif,
  frg.l180d_frm_is_child_van,
  frg.l180d_frm_is_marital_van,
  frg.inc_sal_to_l180d_frm_rat,
  frg.inc_all_to_l180d_frm_rat,

  --
  frg1.inc_sal_sum_30d,
  frg1.inc_sal_sum_30d_x,
  frg1.inc_sal_sum_90d,
  frg1.inc_sal_sum_90d_x,
  frg1.inc_all_sum_30d,
  frg1.inc_all_sum_30d_x,
  frg1.inc_all_sum_90d,
  frg1.inc_all_sum_90d_x,
  frg1.inc_sal_min_30d,
  frg1.inc_sal_avg_30d,
  frg1.inc_sal_max_30d,
  frg1.inc_sal_min_90d,
  frg1.inc_sal_avg_90d,
  frg1.inc_sal_max_90d,
  frg1.inc_all_min_30d,
  frg1.inc_all_avg_30d,
  frg1.inc_all_max_30d,
  frg1.inc_all_min_90d,
  frg1.inc_all_avg_90d,
  frg1.inc_all_max_90d,
  frg1.inc_sal_min_30d_x,
  frg1.inc_sal_avg_30d_x,
  frg1.inc_sal_max_30d_x,
  frg1.inc_sal_min_90d_x,
  frg1.inc_sal_avg_90d_x,
  frg1.inc_sal_max_90d_x,
  frg1.inc_all_min_30d_x,
  frg1.inc_all_avg_30d_x,
  frg1.inc_all_max_30d_x,
  frg1.inc_all_min_90d_x,
  frg1.inc_all_avg_90d_x,
  frg1.inc_all_max_90d_x,

  --M_APP_MINER_FORM_GUESS_30D
  frg30d.dif_children_30d_cnt,
  frg30d.dif_marital_30d_cnt,
  frg30d.dif_inc_sal_30d_cnt,
  frg30d.dif_inc_sal_add_30d_cnt,
  frg30d.dif_inc_sal_sp_30d_cnt,
  frg30d.dif_inc_pens_30d_cnt,
  frg30d.dif_phone_mob_30d_cnt,
  frg30d.dif_phone_home_30d_cnt,
  frg30d.dif_city_reg_30d_cnt,
  frg30d.dif_city_fact_30d_cnt,

  --M_APP_MINER_FORM_GUESS_30DX
  frg30dx.dif_children_30d_cnt_x,
  frg30dx.dif_marital_30d_cnt_x,
  frg30dx.dif_inc_sal_30d_cnt_x,
  frg30dx.dif_inc_sal_add_30d_cnt_x,
  frg30dx.dif_inc_sal_sp_30d_cnt_x,
  frg30dx.dif_inc_pens_30d_cnt_x,
  frg30dx.dif_phone_mob_30d_cnt_x,
  frg30dx.dif_phone_home_30d_cnt_x,
  frg30dx.dif_city_reg_30d_cnt_x,
  frg30dx.dif_city_fact_30d_cnt_x,

  --M_APP_MINER_FORM_GUESS_90D
  frg90d.dif_children_90d_cnt,
  frg90d.dif_marital_90d_cnt,
  frg90d.dif_inc_sal_90d_cnt,
  frg90d.dif_inc_sal_add_90d_cnt,
  frg90d.dif_inc_sal_sp_90d_cnt,
  frg90d.dif_inc_pens_90d_cnt,
  frg90d.dif_phone_mob_90d_cnt,
  frg90d.dif_phone_home_90d_cnt,
  frg90d.dif_city_reg_90d_cnt,
  frg90d.dif_city_fact_90d_cnt,

  --M_APP_MINER_FORM_GUESS_90DX
  frg90dx.dif_children_90d_cnt_x,
  frg90dx.dif_marital_90d_cnt_x,
  frg90dx.dif_inc_sal_90d_cnt_x,
  frg90dx.dif_inc_sal_add_90d_cnt_x,
  frg90dx.dif_inc_sal_sp_90d_cnt_x,
  frg90dx.dif_inc_pens_90d_cnt_x,
  frg90dx.dif_phone_mob_90d_cnt_x,
  frg90dx.dif_phone_home_90d_cnt_x,
  frg90dx.dif_city_reg_90d_cnt_x,
  frg90dx.dif_city_fact_90d_cnt_x,


  --M_APP_MINER_FORM_GUESS_PR_30D
  frg_pr30d.dif_children_30d_pr_cnt,
  frg_pr30d.dif_marital_30d_pr_cnt,
  frg_pr30d.dif_inc_sal_30d_pr_cnt,
  frg_pr30d.dif_inc_sal_add_30d_pr_cnt,
  frg_pr30d.dif_inc_sal_sp_30d_pr_cnt,
  frg_pr30d.dif_inc_pens_30d_pr_cnt,
  frg_pr30d.dif_phone_mob_30d_pr_cnt,
  frg_pr30d.dif_phone_home_30d_pr_cnt,
  frg_pr30d.dif_city_reg_30d_pr_cnt,
  frg_pr30d.dif_city_fact_30d_pr_cnt,
  frg_pr30d.inc_sal_avg_30d_pr,
  frg_pr30d.inc_all_avg_30d_pr,
  frg_pr30d.inc_sal_min_30d_pr,
  frg_pr30d.inc_all_min_30d_pr,
  frg_pr30d.inc_sal_max_30d_pr,
  frg_pr30d.inc_all_max_30d_pr,
  frg_pr30d.inc_sal_to_avg_30d_pr_rat,
  frg_pr30d.inc_all_to_avg_30d_pr_rat,
  frg_pr30d.inc_sal_to_min_30d_pr_rat,
  frg_pr30d.inc_all_to_min_30d_pr_rat,
  frg_pr30d.inc_sal_to_max_30d_pr_rat,
  frg_pr30d.inc_all_to_max_30d_pr_rat,


  --M_APP_MINER_FORM_GUESS_PR_30DX
  frg_pr30dx.dif_children_30d_pr_cnt_x,
  frg_pr30dx.dif_marital_30d_pr_cnt_x,
  frg_pr30dx.dif_inc_sal_30d_pr_cnt_x,
  frg_pr30dx.dif_inc_sal_add_30d_pr_cnt_x,
  frg_pr30dx.dif_inc_sal_sp_30d_pr_cnt_x,
  frg_pr30dx.dif_inc_pens_30d_pr_cnt_x,
  frg_pr30dx.dif_phone_mob_30d_pr_cnt_x,
  frg_pr30dx.dif_phone_home_30d_pr_cnt_x,
  frg_pr30dx.dif_city_reg_30d_pr_cnt_x,
  frg_pr30dx.dif_city_fact_30d_pr_cnt_x,
  frg_pr30dx.inc_sal_avg_30d_pr_x,
  frg_pr30dx.inc_all_avg_30d_pr_x,
  frg_pr30dx.inc_sal_min_30d_pr_x,
  frg_pr30dx.inc_all_min_30d_pr_x,
  frg_pr30dx.inc_sal_max_30d_pr_x,
  frg_pr30dx.inc_all_max_30d_pr_x,
  frg_pr30dx.inc_sal_to_avg_30d_pr_rat_x,
  frg_pr30dx.inc_all_to_avg_30d_pr_rat_x,
  frg_pr30dx.inc_sal_to_min_30d_pr_rat_x,
  frg_pr30dx.inc_all_to_min_30d_pr_rat_x,
  frg_pr30dx.inc_sal_to_max_30d_pr_rat_x,
  frg_pr30dx.inc_all_to_max_30d_pr_rat_x,


  --M_APP_MINER_FORM_GUESS_PR_90D
  frg_pr90d.dif_children_90d_pr_cnt,
  frg_pr90d.dif_marital_90d_pr_cnt,
  frg_pr90d.dif_inc_sal_90d_pr_cnt,
  frg_pr90d.dif_inc_sal_add_90d_pr_cnt,
  frg_pr90d.dif_inc_sal_sp_90d_pr_cnt,
  frg_pr90d.dif_inc_pens_90d_pr_cnt,
  frg_pr90d.dif_phone_mob_90d_pr_cnt,
  frg_pr90d.dif_phone_home_90d_pr_cnt,
  frg_pr90d.dif_city_reg_90d_pr_cnt,
  frg_pr90d.dif_city_fact_90d_pr_cnt,
  frg_pr90d.inc_sal_avg_90d_pr,
  frg_pr90d.inc_all_avg_90d_pr,
  frg_pr90d.inc_sal_min_90d_pr,
  frg_pr90d.inc_all_min_90d_pr,
  frg_pr90d.inc_sal_max_90d_pr,
  frg_pr90d.inc_all_max_90d_pr,
  frg_pr90d.inc_sal_to_avg_90d_pr_rat,
  frg_pr90d.inc_all_to_avg_90d_pr_rat,
  frg_pr90d.inc_sal_to_min_90d_pr_rat,
  frg_pr90d.inc_all_to_min_90d_pr_rat,
  frg_pr90d.inc_sal_to_max_90d_pr_rat,
  frg_pr90d.inc_all_to_max_90d_pr_rat,


  --M_APP_MINER_FORM_GUESS_PR_90DX
  frg_pr90dx.dif_children_90d_pr_cnt_x,
  frg_pr90dx.dif_marital_90d_pr_cnt_x,
  frg_pr90dx.dif_inc_sal_90d_pr_cnt_x,
  frg_pr90dx.dif_inc_sal_add_90d_pr_cnt_x,
  frg_pr90dx.dif_inc_sal_sp_90d_pr_cnt_x,
  frg_pr90dx.dif_inc_pens_90d_pr_cnt_x,
  frg_pr90dx.dif_phone_mob_90d_pr_cnt_x,
  frg_pr90dx.dif_phone_home_90d_pr_cnt_x,
  frg_pr90dx.dif_city_reg_90d_pr_cnt_x,
  frg_pr90dx.dif_city_fact_90d_pr_cnt_x,
  frg_pr90dx.inc_sal_avg_90d_pr_x,
  frg_pr90dx.inc_all_avg_90d_pr_x,
  frg_pr90dx.inc_sal_min_90d_pr_x,
  frg_pr90dx.inc_all_min_90d_pr_x,
  frg_pr90dx.inc_sal_max_90d_pr_x,
  frg_pr90dx.inc_all_max_90d_pr_x,
  frg_pr90dx.inc_sal_to_avg_90d_pr_rat_x,
  frg_pr90dx.inc_all_to_avg_90d_pr_rat_x,
  frg_pr90dx.inc_sal_to_min_90d_pr_rat_x,
  frg_pr90dx.inc_all_to_min_90d_pr_rat_x,
  frg_pr90dx.inc_sal_to_max_90d_pr_rat_x,
  frg_pr90dx.inc_all_to_max_90d_pr_rat_x,


  --U1.M_APP_MINER_RBO_PORT
  rbo_p.active_total_debt,
  rbo_p.active_con_cnt,
  rbo_p.is_active_debt_exists,
  rbo_p.is_active_debt_50k_exists,
  rbo_p.is_active_debt_100k_exists,
  rbo_p.is_active_debt_500k_exists,
  rbo_p.max_del_days,

  ------------------------------------------------------
  onl1.onl_app_30d_cnt_x,
  onl1.onl_iss_30d_cnt_x,
  onl1.onl_cnl_30d_cnt_x,
  onl1.onl_model_30d_cnt_x,
  onl1.onl_categ_30d_cnt_x,
  onl1.onl_categ_cnl_30d_cnt_x,
  onl1.onl_model_eq_30d_cnt_x,
  onl1.onl_categ_eq_30d_cnt_x,
  onl1.onl_model_eq_iss_30d_cnt_x,
  onl1.onl_categ_eq_iss_30d_cnt_x,
  onl1.onl_deliv_30d_cnt_x,
  onl1.onl_app_30d_sum_x,
  onl1.onl_iss_30d_sum_x,
  onl1.onl_shop_30d_cnt_x,
  onl1.onl_shop_cnl_30d_cnt_x,
  onl1.onl_mobile_30d_cnt_x,
  onl1.onl_app_30d_cnt,
  onl1.onl_iss_30d_cnt,
  onl1.onl_cnl_30d_cnt,
  onl1.onl_model_30d_cnt,
  onl1.onl_categ_30d_cnt,
  onl1.onl_categ_cnl_30d_cnt,
  onl1.onl_model_eq_30d_cnt,
  onl1.onl_categ_eq_30d_cnt,
  onl1.onl_model_eq_iss_30d_cnt,
  onl1.onl_categ_eq_iss_30d_cnt,
  onl1.onl_deliv_30d_cnt,
  onl1.onl_app_30d_sum,
  onl1.onl_iss_30d_sum,
  onl1.onl_shop_30d_cnt,
  onl1.onl_shop_cnl_30d_cnt,
  onl1.onl_mobile_30d_cnt,
  ---------------------------------------------
  onl2.onl_ph_app_30d_cnt_x,
  onl2.onl_ph_cnl_30d_cnt_x,
  onl2.onl_ph_iss_30d_cnt_x,
  onl2.onl_ph_deliv_30d_cnt_x,
  onl2.onl_ph_app_30d_sum_x,
  onl2.onl_ph_iss_30d_sum_x,
  onl2.onl_ph_cl_30d_cnt_x,
  onl2.onl_ph_app_30d_cnt,
  onl2.onl_ph_cnl_30d_cnt,
  onl2.onl_ph_iss_30d_cnt,
  onl2.onl_ph_deliv_30d_cnt,
  onl2.onl_ph_app_30d_sum,
  onl2.onl_ph_iss_30d_sum,
  onl2.onl_ph_cl_30d_cnt,
  ----------------------------------------------
  onl3.onl_cl_ga_eq_30d_cnt_x,
  onl3.onl_cl_ga_eq_30d_cnt,
  ----------------------------------------------
  fld1.app_tk_30d_cnt_x,
  fld1.app_tk_cnl_30d_cnt_x,
  fld1.app_tk_30d_cnt,
  fld1.app_tk_cnl_30d_cnt,
  fld1.app_fail_tk_30d_cnt_x,
  fld1.app_fail_tk_30d_cnt,
  ----------------------------------------------
  /*onl5.kn_app_30d_cnt_x,
  onl5.kn_app_cnl_30d_cnt_x,
  onl5.kn_app_30d_cnt,
  onl5.kn_app_cnl_30d_cnt,*/

  fld1.app_kn_cnl_30d_cnt_x,
  fld1.app_kn_cnl_30d_cnt,

  --M_APP_MINER_FORM_PMT
  frp.days_last_gcvp,
  frp.diff_zp_form_gcvp,
  frp.diff_zp_form_all_gcvp,

  frp.install_incom_avg,
  frp.install_incom_avg_30d_pr,
  frp.install_incom_avg_30d_pr_x,
  frp.install_incom_avg_30d,
  frp.install_incom_avg_30d_x,

  --M_APP_MINER_FOLDER_PRE1
  fld1.app_30d_cnt,
  fld1.app_30d_cnt_x,
  fld1.app_90d_cnt,
  fld1.app_90d_cnt_x,
  fld1.app_30d_pr_cnt,
  fld1.app_30d_pr_cnt_x,
  fld1.app_90d_pr_cnt,
  fld1.app_90d_pr_cnt_x,
  fld1.app_kn_30d_cnt,
  fld1.app_kn_30d_cnt_x,
  fld1.app_kn_90d_cnt,
  fld1.app_kn_90d_cnt_x,
  fld1.app_fail_30d_cnt,
  fld1.app_fail_30d_cnt_x,
  fld1.app_fail_30d_pr_cnt,
  fld1.app_fail_30d_pr_cnt_x,
  fld1.app_fail_kn_30d_cnt,
  fld1.app_fail_kn_30d_cnt_x,
  fld1.app_fail_30d_rat,
  fld1.app_fail_30d_rat_x,
  fld1.app_fail_30d_pr_rat,
  fld1.app_fail_30d_pr_rat_x,

  fld2.shop_30d_cnt,
  fld2.shop_30d_cnt_x,
  fld2.shop_30d_pr_cnt,
  fld2.shop_30d_pr_cnt_x,
  fld2.max_app_amount_3m,
  fld2.max_app_amount_3m_pr,
  fld2.max_app_amount_30d,
  fld2.min_app_amount_30d,
  fld2.avg_app_amount_30d,
  fld2.max_app_amount_30d_x,
  fld2.min_app_amount_30d_x,
  fld2.avg_app_amount_30d_x,
  fld2.max_app_amount_90d,
  fld2.min_app_amount_90d,
  fld2.avg_app_amount_90d,
  fld2.max_app_amount_90d_x,
  fld2.min_app_amount_90d_x,
  fld2.avg_app_amount_90d_x,
  fld2.max_app_amount_30d_pr,
  fld2.min_app_amount_30d_pr,
  fld2.avg_app_amount_30d_pr,
  fld2.max_app_amount_30d_pr_x,
  fld2.min_app_amount_30d_pr_x,
  fld2.avg_app_amount_30d_pr_x,
  fld2.max_app_amount_90d_pr,
  fld2.min_app_amount_90d_pr,
  fld2.avg_app_amount_90d_pr,
  fld2.max_app_amount_90d_pr_x,
  fld2.min_app_amount_90d_pr_x,
  fld2.avg_app_amount_90d_pr_x,
  fld2.max_app_amount_kn_30d,
  fld2.max_app_amount_kn_30d_x,
  fld2.max_app_amount_kn_90d,
  fld2.max_app_amount_kn_90d_x,

  fld3.app_days_90d_cnt,
  fld3.app_days_90d_pr_cnt,
  fld3.app_days_30d_cnt,
  fld3.app_days_30d_pr_cnt,
  fld3.app_fail_days_30d_cnt,
  fld3.app_fail_days_30d_pr_cnt,
  fld3.max_app_days_cnt_90d,
  fld3.avg_app_days_cnt_90d,
  fld3.max_app_days_cnt_90d_pr,
  fld3.avg_app_days_cnt_90d_pr,
  fld3.max_app_days_cnt_30d,
  fld3.avg_app_days_cnt_30d,
  fld3.max_app_days_cnt_30d_pr,
  fld3.avg_app_days_cnt_30d_pr,

  fld4.max_tov_categ_cnt_90d,
  fld4.max_tov_categ_cnt_90d_pr,
  fld4.max_tov_categ_cnt_30d,
  fld4.max_tov_categ_cnt_30d_pr,

  --
  rbo_p2.del_days_1y_max,

  --
  rbo.avg_term_cred_plan,
  rbo.rbo_kn_cnt,

  rbo1.life_length,
  rbo1.deposit_life_length,
  rbo1.deposit_life_usd,
  rbo1.deposit_active,
  rbo1.deposit_usd_active,

  rbo2.card_pay_cred_90d_sum,

  rbo3.cl_incom_90d_sum,
  rbo3.cl_incom_90d_avg,
  rbo3.cl_incom_30d_sum,
  rbo3.cl_incom_30d_avg,

  rbo4.kspgl_pay_month_6m_cnt,

  rbo5.kspgl_contract_cnt,
  rbo5.kspgl_is_active,

  rbo5.dep_card_cont_cnt,
  rbo5.dep_card_is_active,

  --
  cl.age,
  cl.reg_kaspikz_length,

  --
  ext.innet_index,
  ext.is_online,
  ext.is_offline,

  --
  kspsh.is_loan_guest,
  kspsh.visit_guest_30d_cnt,
  kspsh.visit_client_30d_cnt,
  kspsh.visit_guest_30d_cnt_x,
  kspsh.visit_client_30d_cnt_x,
  kspsh.visit_guest_30d_pr_cnt,
  kspsh.visit_client_30d_pr_cnt,
  kspsh.visit_guest_30d_pr_cnt_x,
  kspsh.visit_client_30d_pr_cnt_x,

  --
  ksp1.kspkz_pay_30d_sum,
  ksp1.kspkz_pay_30d_sum_x,
  ksp1.kspkz_pay_30d_avg,
  ksp1.kspkz_pay_30d_avg_x,
  ksp1.kspkz_pay_30d_cnt,
  ksp1.kspkz_pay_30d_cnt_x,
  ksp1.kspkz_month_6m_cnt,
  ksp1.kspkz_month_6m_cnt_x,
  ksp1.kspkz_month_180d_avg,
  ksp1.kspkz_month_180d_avg_x,
  ksp1.kspkz_mobile_24m_cnt,
  ksp1.kspkz_mobile_24m_cnt_x,
  ksp1.kspkz_komm_month_6m_cnt,
  ksp1.kspkz_komm_month_6m_cnt_x,
  ksp1.kspkz_serv_6m_cnt,
  ksp1.kspkz_serv_6m_cnt_x,

  ksp1.kspkz_dep_90d_cnt,
  ksp1.kspkz_dep_90d_cnt_x,
  ksp1.kspkz_dep_90d_sum,
  ksp1.kspkz_dep_90d_sum_x,
  ksp1.kspkz_dep_day_90d_cnt,
  ksp1.kspkz_dep_day_90d_cnt_x,

  ksp2.kspkz_sess_6m_cnt,
  ksp2.kspkz_sess_6m_cnt_x,

  --
  trm.trm_pay_cred_90d_sum,
  trm.trm_pay_cred_90d_sum_x,
  trm.trm_pay_90d_cnt,
  trm.trm_pay_90d_cnt_x,
  trm.trm_ext_pay_90d_cnt,
  trm.trm_ext_pay_90d_cnt_x,
  trm.trm_ext_pay_90d_rat,
  trm.trm_ext_pay_90d_rat_x,

  ----------------------------
  --
/*  rbo_d.balance_all_dep_beg_x,
  rbo_d.balance_all_dep_beg_m_x,
  rbo_d.sum_pritok_dep_3_m_x,
  rbo_d.share_usd_dep_sum_x,*/

  rbo_d.balance_all_dep_beg,
  rbo_d.balance_all_dep_beg_m,
  rbo_d.sum_pritok_dep_3_m,

  rbo_d.share_usd_dep_sum,

  rbo_d.count_ottok_last_m,
  rbo_d.count_ottok_last_3m,
  rbo_d.count_ottok_last_6m,
  rbo_d.count_ottok_last_12m,

  rbo_d.count_pritok_last_m,
  rbo_d.count_pritok_last_3m,
  rbo_d.count_pritok_last_6m,
  rbo_d.count_pritok_last_12m,


  --rbo_d.share_usd_dep_sum_op,
  rbo_d.deposit_balance_usd, --поменять на

  rbo_d.last_pritok_sum_usd,
  rbo_d.last_ottok_sum_usd,
  rbo_d.days_from_last_pritok_usd,
  rbo_d.days_from_last_ottok_usd,

  rbo_d.count_ottok_all_usd,
  rbo_d.count_pritok_all_usd,
  rbo_d.count_ottok_last_m_usd,
  rbo_d.count_ottok_last_3m_usd,
  rbo_d.count_ottok_last_6m_usd,
  rbo_d.count_ottok_last_12m_usd,
  rbo_d.count_pritok_last_m_usd,
  rbo_d.count_pritok_last_3m_usd,
  rbo_d.count_pritok_last_6m_usd,
  rbo_d.count_pritok_last_12m_usd,

  rbo_d2.dep_balance_30d_avg,
  rbo_d2.dep_balance_usd_30d_avg,
  rbo_d2.dep_balance_month_30d_avg,

  rbo_d3.dep_refill_sum,
  rbo_d3.dep_withdraw_sum,
  rbo_d3.dep_refill_90d_sum,
  rbo_d3.dep_withdraw_90d_sum,
  rbo_d3.oper_refill_days_90d_cnt,
  rbo_d3.oper_withdraw_days_90d_cnt,
  rbo_d3.last_refill_amount,
  rbo_d3.last_withdraw_amount,

  rbo_ds.dep_sp_life_length,
  rbo_ds.dep_sp_balance,

  --
  --M_APP_MINER_FORM_CLIENT2
  frm2.operator_value,
  frm2.unique_sumbol_qty,
  --M_APP_MINER_FORM_CLIENT3
  frm3.unique_contact_persons,
  frm3.unique_subs_on_a_number,

  --M_APP_MINER_FOLDER_PRE5
  fld5.application_flag,
  fld5.count_application,

  prm.unique_kaspikz_client,
  prm.subs_with_delay_in_contact,
  prm.delay_contacts_share,

  --U1.M_APP_MINER_MOB_PAY
  prm1.pmt_qty,
  prm1.share_of_kaspikz_pmt,
  prm1.share_of_term_pmt,
  prm1.ttl_pmt_amt,
  prm1.avg_pmt,
  prm1.days_from_first_mob_pay,

  --M_APP_MINER_KSPKZ_MOB
  prm5.kspkz_mob_pay_days_180d,
  prm5.kspkz_mob_pay_180d_cnt,
  prm5.kspkz_mob_pay_180d_sum,
  prm5.kspkz_mob_pay_180d_avg,

  --M_APP_MINER_TERM_MOB
  prm6.unique_terminal_qty,

  prm6.trm_mob_pay_days_180d,
  prm6.trm_mob_pay_180d_cnt,
  prm6.trm_mob_pay_180d_sum,
  prm6.trm_mob_pay_180d_avg,
  --

  prm.count_category_kspkz,
  prm.count_month_kspkz,
  prm.flag_avia_kspkz,
  prm.delay_contact_flag,

  --prm.client_life_length,
  /*greatest(coalesce(cl.reg_kaspikz_length, greatest(coalesce(rbo1.life_length, rbo1.deposit_life_length), rbo1.life_length, rbo1.deposit_life_length)),
           cl.reg_kaspikz_length,
           greatest(coalesce(rbo1.life_length, rbo1.deposit_life_length), rbo1.life_length, rbo1.deposit_life_length)) as client_life_length,*/

  coalesce(greatest(cl.reg_kaspikz_length, coalesce(greatest(rbo1.life_length, rbo1.deposit_life_length), rbo1.life_length, rbo1.deposit_life_length)),
           cl.reg_kaspikz_length,
          coalesce(greatest(rbo1.life_length, rbo1.deposit_life_length), rbo1.life_length, rbo1.deposit_life_length)) as client_life_length,

  --prm.bylo_ili_est_auto,
  prm.mobile_popularity,
  prm.mobile_popularity90,
  prm.mobile_popularity30,

  ext2.ip_flag,

  --M_APP_MINER_AUTO_GAI2
  gc2.years_from_issue_ever,
  gc2.actual_auto_flag,
  gc2.years_from_issue,

  --
  crd.days_all,
  crd.sum_all,
  crd.operations_all,
  crd.categories_all,
  crd.days_atm,
  crd.sum_atm,
  crd.operations_atm,
  crd.categories_atm,
  crd.days_kspkz,
  crd.sum_kspkz,
  crd.operation_kspkz,
  crd.categories_kspkz,
  crd.days_pos,
  crd.sum_pos,
  crd.operation_pos,
  crd.categories_pos,
  crd.days_int,
  crd.sum_int,
  crd.operation_int,
  crd.categories_int,
  crd.sum_atm_share,
  crd.operation_atm_share,
  crd.sum_kspkz_share,
  crd.operations_kspkz_share,
  crd.sum_pos_share,
  crd.operations_pos_share,
  crd.sum_int_share,
  crd.operations_int_share

from u1.M_APP_MINER am
left join U1.M_APP_MINER_GCVP gr on gr.app_id = am.app_id
left join U1.M_APP_MINER_PKB pr on pr.app_id = am.app_id
left join U1.M_APP_MINER_FORM_CLIENT frm on frm.app_id = am.app_id

left join U1.M_APP_MINER_FORM_GUESS frg on frg.app_id = am.app_id
left join U1.M_APP_MINER_FORM_GUESS_PRE1 frg1 on frg1.app_id = am.app_id

left join U1.M_APP_MINER_FORM_GUESS_30D frg30d on frg30d.app_id = am.app_id
left join U1.M_APP_MINER_FORM_GUESS_30DX frg30dx on frg30dx.app_id = am.app_id
left join U1.M_APP_MINER_FORM_GUESS_90D frg90d on frg90d.app_id = am.app_id
left join U1.M_APP_MINER_FORM_GUESS_90DX frg90dx on frg90dx.app_id = am.app_id

left join U1.M_APP_MINER_FORM_GUESS_PR_30D frg_pr30d on frg_pr30d.app_id = am.app_id
left join U1.M_APP_MINER_FORM_GUESS_PR_30DX frg_pr30dx on frg_pr30dx.app_id = am.app_id
left join U1.M_APP_MINER_FORM_GUESS_PR_90D frg_pr90d on frg_pr90d.app_id = am.app_id
left join U1.M_APP_MINER_FORM_GUESS_PR_90DX frg_pr90dx on frg_pr90dx.app_id = am.app_id

left join U1.M_APP_MINER_RBO_PORT rbo_p on rbo_p.app_id = am.app_id

left join U1.M_APP_MINER_ONLINE_PARAM onl1 on onl1.app_id = am.app_id
left join U1.M_APP_MINER_ONLINE_PHONE onl2 on onl2.app_id = am.app_id
left join U1.M_APP_MINER_ONLINE_GA onl3 on onl3.app_id = am.app_id
--left join U1.M_APP_MINER_TK onl4 on onl4.app_id = am.app_id
--left join U1.M_APP_MINER_KN onl5 on onl5.app_id = am.app_id

--
left join U1.M_APP_MINER_FORM_PMT frp on frp.app_id = am.app_id

left join U1.M_APP_MINER_FOLDER_PRE1 fld1 on fld1.app_id = am.app_id
left join U1.M_APP_MINER_FOLDER_PRE2 fld2 on fld2.app_id = am.app_id
left join U1.M_APP_MINER_FOLDER_PRE3 fld3 on fld3.app_id = am.app_id
left join U1.M_APP_MINER_FOLDER_PRE4 fld4 on fld4.app_id = am.app_id

--left join U1.M_APP_MINER_RBO_PORT
left join U1.M_APP_MINER_RBO_PORT2 rbo_p2 on rbo_p2.app_id = am.app_id

left join U1.M_APP_MINER_RBO_BAS rbo on rbo.app_id = am.app_id
left join U1.M_APP_MINER_RBO_BAS_PRE1 rbo1 on rbo1.app_id = am.app_id
left join U1.M_APP_MINER_RBO_BAS_PRE2 rbo2 on rbo2.app_id = am.app_id
left join U1.M_APP_MINER_RBO_BAS_PRE3 rbo3 on rbo3.app_id = am.app_id
left join U1.M_APP_MINER_RBO_BAS_PRE4 rbo4 on rbo4.app_id = am.app_id
left join U1.M_APP_MINER_RBO_BAS_PRE5 rbo5 on rbo5.app_id = am.app_id

left join U1.M_APP_MINER_CL_AGE cl on cl.app_id = am.app_id

left join U1.M_APP_MINER_EXT ext on ext.app_id = am.app_id

left join U1.M_APP_MINER_KASPSH_ORDER kspsh on kspsh.app_id = am.app_id

left join U1.M_APP_MINER_KASPIKZ_PAY ksp1 on ksp1.app_id = am.app_id
left join U1.M_APP_MINER_KASPIKZ_SESS ksp2 on ksp2.app_id = am.app_id

left join U1.M_APP_MINER_CASH_TERM trm on trm.app_id = am.app_id

--
left join U1.M_APP_MINER_RBO_DEPO rbo_d on rbo_d.app_id = am.app_id
left join U1.M_APP_MINER_RBO_DEPO2 rbo_d2 on rbo_d2.app_id = am.app_id
left join U1.M_APP_MINER_RBO_DEPO3 rbo_d3 on rbo_d3.app_id = am.app_id
left join U1.M_APP_MINER_RBO_DEPO_SPOUSE rbo_ds on rbo_ds.app_id = am.app_id

--На переработку
left join U1.M_PARAMS_FOR_MODEL prm on prm.app_id = am.app_id
--
left join u1.M_APP_MINER_FORM_CLIENT2 frm2 on frm2.app_id = am.app_id
left join U1.M_APP_MINER_MOB_PAY prm1 on prm1.app_id = am.app_id
left join U1.M_APP_MINER_KSPKZ_MOB prm5 on prm5.app_id = am.app_id
left join U1.M_APP_MINER_TERM_MOB prm6 on prm6.app_id = am.app_id
left join U1.M_APP_MINER_AUTO_GAI2 gc2 on gc2.app_id = am.app_id
left join u1.M_APP_MINER_EXT2 ext2 on ext2.app_id = am.app_id
left join U1.M_APP_MINER_FORM_CLIENT3 frm3 on frm3.app_id = am.app_id
left join U1.M_APP_MINER_FOLDER_PRE5 fld5 on fld5.app_id = am.app_id

--
left join u1.M_APP_FRAUD_CARDS crd on crd.app_id = am.app_id


where am.folder_date_create >= to_date('01012015', 'ddmmyyyy')
;
grant select on U1.V_APP_ALL_MINER to LOADDB;
grant select on U1.V_APP_ALL_MINER to SAS_USER;
grant select on U1.V_APP_ALL_MINER to UPD_USER;


