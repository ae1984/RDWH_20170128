create or replace force view u1.v_dwh_port_cd_cr_300914 as
select /*+ parallel(10) */
--  cdhd$change_date as change_date,
--  cdhd$audit_id as audit_id,
  cdhd_rep_date as rep_date,
  cdhd_clnt_gid as clnt_gid,
  cdhd_dcard_gid as dcard_gid,
  upper(cdhd_client_name) as client_name,
  cdhd_client_iin as client_iin,
  cdhd_client_rnn as client_rnn,
  cdhd_client_rfo_id as client_rfo_id,
  cdhd_deal_number as deal_number,
  cdhd_currency as currency,
  cdhd_begin_date as begin_date,
  cdhd_plan_end_date as plan_end_date,
  cdhd_actual_end_date as actual_end_date,
  upper(cdhd_deal_status) as deal_status,
  upper(cdhd_prod_type) as prod_type,
  upper(cdhd_prod_name) as prod_name,
  upper(cdhd_dept_name) as dept_name,
  cdhd_dept_number as dept_number,
  upper(cdhd_unp_name) as unp_name,
  cdhd_unp_number as unp_number,
  upper(cdhd_fil_name) as fil_name,
  cdhd_fil_number as fil_number,
  upper(cdhd_create_empl_name) as create_empl_name,
  cdhd_create_empl_number as create_empl_number,
  upper(cdhd_empl_name) as sign_empl_name,
  cdhd_empl_number as sign_empl_number,
  cdhd_rate_value as rate_value,
  cdhd_to_ovrd_date as to_ovrd_date,
  cdhd_ovrd_days as ovrd_days,
  cdhd_cl_to_ovrd_date as cl_to_ovrd_date,
  cdhd_cl_ovrd_days as cl_ovrd_days,

  cdhd_card_limit as card_limit,
  null as credit_amount,
  null as is_not_on_balance,
  cdhd_set_revolving_date as set_revolving_date,

  cdhd_pc_cred as principal,
  cdhd_pc_prc as interest,
  cdhd_pc_overlimit as overlimit,
  cdhd_pc_overdraft as overdraft,
  cdhd_pc_ovrd_cred as overdue_principal,
  cdhd_pc_ovrd_prc as overdue_interest,
  cdhd_pc_ovrd_overlimit as overdue_overlimit,
  cdhd_pc_ovrd_overdraft as overdue_overdraft,

  cdhd_pc_vnb_ovrd_cred as w_principal_del,
  cdhd_pc_vnb_ovrd_overlimit as w_overlimit_del,
  cdhd_pc_vnb_ovrd_overdraft as w_overdraft_del,
  cdhd_pc_vnb_ovrd_prc_cred w_interest_del,

  cdhd_available_balance as card_available_balance,
  cdhd_fst_dept_auto_date as card_fst_dept_auto_date,
  cdhd_fst_dept_date as fst_dept_date,

      cdhd_card_limit as
  x_amount,
      nvl(cdhd_pc_cred,0) +
      nvl(cdhd_pc_prc,0) +
      nvl(cdhd_pc_overlimit,0) +
      nvl(cdhd_pc_overdraft,0) +
      nvl(cdhd_pc_ovrd_cred,0) +
      nvl(cdhd_pc_ovrd_prc,0) +
      nvl(cdhd_pc_ovrd_overlimit,0) +
      nvl(cdhd_pc_ovrd_overdraft,0) +
      nvl(cdhd_pc_vnb_ovrd_cred,0) +
      nvl(cdhd_pc_vnb_ovrd_prc_cred,0) +
      nvl(cdhd_pc_vnb_ovrd_overlimit,0) +
      nvl(cdhd_pc_vnb_ovrd_overdraft,0) as
  x_total_debt,
      nvl(cdhd_pc_ovrd_cred,0) +
      nvl(cdhd_pc_ovrd_prc,0) +
      nvl(cdhd_pc_ovrd_overlimit,0) +
      nvl(cdhd_pc_ovrd_overdraft,0) as
  x_delinq_amount,
      1 as
  x_is_card

from DWH_SAN.DM_CARDSDAILY_HD@DWH_PROD2 t
where t.cdhd_rep_date = to_date('2014-09-30','yyyy-mm-dd')

union all

select /*+ parallel(10) */
--  exhd$change_date as change_date,
--  exhd$audit_id as audit_id,
  exhd_rep_date as rep_date,
  exhd_clnt_gid as clnt_gid,
  exhd_dcard_gid as dcard_gid,
  upper(exhd_client_name) as client_name,
  exhd_client_iin as client_iin,
  exhd_client_rnn as client_rnn,
  exhd_client_rfo_id as client_rfo_id,
  exhd_deal_number as deal_number,
  exhd_currency as currency,
  exhd_begin_date as begin_date,
  exhd_plan_end_date as plan_end_date,
  exhd_actual_end_date as actual_end_date,
  upper(exhd_deal_status) as deal_status,
  upper(exhd_prod_type) as prod_type,
  upper(exhd_prod_name) as prod_name,
  upper(exhd_dept_name) as dept_name,
  exhd_dept_number as dept_number,
  upper(exhd_unp_name) as unp_name,
  exhd_unp_number as unp_number,
  upper(exhd_fil_name) as fil_name,
  exhd_fil_number as fil_number,
  upper(exhd_create_empl_name) as create_empl_name,
  exhd_create_empl_number as create_empl_number,
  upper(exhd_sign_empl_name) as sign_empl_name,
  exhd_sign_empl_number as sign_empl_number,
  exhd_rate_value as rate_value,
  exhd_to_ovrd_date as to_ovrd_date,
  exhd_ovrd_days as ovrd_days,
  exhd_cl_to_ovrd_date as cl_to_ovrd_date,
  exhd_cl_ovrd_days as cl_ovrd_days,

  null as card_limit,
  exhd_amount as credit_amount,
  exhd_old_ovd_scheme as is_not_on_balance,
  null as set_revolving_date,
  exhd_fgu_cred as principal,
  exhd_fgu_prc as interest,
  null as overlimit,
  null as overdraft,
--  exhd_fgu_as_of_date,
  exhd_fgu_ovrd_cred as overdue_principal,
  exhd_fgu_ovrd_prc as overdue_interest,
  null as overdue_overlimit,
  null as overdue_overdraft,

  exhd_vnb_ovrd_cred as w_principal_del,
  null as w_overlimit_del,
  null as w_overdraft_del,
  exhd_vnb_ovrd_prc + exhd_vnb_comm as w_interest_del,

  null as card_available_balance,
  null as card_fst_dept_auto_date,
  null as fst_dept_date,

    exhd_amount as
  x_amount,
    nvl(exhd_fgu_cred,0) +
    nvl(exhd_fgu_prc,0) +
    nvl(exhd_fgu_ovrd_cred,0) +
    nvl(exhd_fgu_ovrd_prc,0) +
    nvl(exhd_vnb_ovrd_cred,0) +
    nvl(exhd_vnb_ovrd_prc,0) +
    nvl(exhd_vnb_comm,0) as
  x_total_debt,
    nvl(exhd_fgu_ovrd_cred,0) +
    nvl(exhd_fgu_ovrd_prc,0) as
  x_delinq_amount,
    0 as
  x_is_card

from DWH_SAN.DM_SPGU_HD@DWH_PROD2 s
where s.exhd_rep_date = to_date('2014-09-30','yyyy-mm-dd')
;
grant select on U1.V_DWH_PORT_CD_CR_300914 to LOADDB;
grant select on U1.V_DWH_PORT_CD_CR_300914 to LOADER;


