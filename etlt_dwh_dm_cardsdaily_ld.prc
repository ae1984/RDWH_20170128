﻿create or replace procedure u1.ETLT_DWH_DM_CARDSDAILY_LD is
begin
    -- переносим данные в DWH_DM_CARDSDAILY_LD и DWH_DM_SPGU_LD
    insert /*+ append */
      into u1.DWH_DM_CARDSDAILY_LD
           (cdld$change_date, cdld$audit_id, cdld_rep_date, cdld_clnt_gid, cdld_dcard_gid,
            cdld_client_name, cdld_client_iin, cdld_client_rnn, cdld_client_rfo_id, cdld_deal_number,
            cdld_currency, cdld_begin_date, cdld_plan_end_date, cdld_actual_end_date, cdld_set_revolving_date,
            cdld_deal_status, cdld_fst_dept_auto_date, cdld_fst_dept_date, cdld_card_limit, cdld_rate_value,
            cdld_prod_name, cdld_prod_type, cdld_dept_name, cdld_dept_number, cdld_unp_name,
            cdld_unp_number, cdld_fil_name, cdld_fil_number, cdld_empl_name, cdld_empl_number,
            cdld_create_empl_name, cdld_create_empl_number, cdld_pc_cred, cdld_pc_overlimit, cdld_pc_overdraft,
            cdld_pc_prc, cdld_pc_ovrd_cred, cdld_pc_ovrd_overlimit, cdld_pc_ovrd_overdraft, cdld_pc_ovrd_prc,
            cdld_available_balance, cdld_to_ovrd_date, cdld_ovrd_days, cdld_cl_to_ovrd_date, cdld_cl_ovrd_days,
            cdld_pc_vnb_ovrd_cred, cdld_pc_vnb_ovrd_overdraft, cdld_pc_vnb_ovrd_overlimit, cdld_pc_vnb_ovrd_prc_cred)
    select /*+ parallel(20)*/
           s.cdhd$change_date as cdld$change_date,
           s.cdhd$audit_id as cdld$audit_id,
           s.cdhd_rep_date as cdld_rep_date,
           s.cdhd_clnt_gid as cdld_clnt_gid,
           s.cdhd_dcard_gid as cdld_dcard_gid,
           s.cdhd_client_name as cdld_client_name,
           s.cdhd_client_iin as cdld_client_iin,
           s.cdhd_client_rnn as cdld_client_rnn,
           s.cdhd_client_rfo_id as cdld_client_rfo_id,
           s.cdhd_deal_number as cdld_deal_number,
           s.cdhd_currency as cdld_currency,
           s.cdhd_begin_date as cdld_begin_date,
           s.cdhd_plan_end_date as cdld_plan_end_date,
           s.cdhd_actual_end_date as cdld_actual_end_date,
           s.cdhd_set_revolving_date as cdld_set_revolving_date,
           s.cdhd_deal_status as cdld_deal_status,
           s.cdhd_fst_dept_auto_date as cdld_fst_dept_auto_date,
           s.cdhd_fst_dept_date as cdld_fst_dept_date,
           s.cdhd_card_limit as cdld_card_limit,
           s.cdhd_rate_value as cdld_rate_value,
           s.cdhd_prod_name as cdld_prod_name,
           s.cdhd_prod_type as cdld_prod_type,
           s.cdhd_dept_name as cdld_dept_name,
           s.cdhd_dept_number as cdld_dept_number,
           s.cdhd_unp_name as cdld_unp_name,
           s.cdhd_unp_number as cdld_unp_number,
           s.cdhd_fil_name as cdld_fil_name,
           s.cdhd_fil_number as cdld_fil_number,
           s.cdhd_empl_name as cdld_empl_name,
           s.cdhd_empl_number as cdld_empl_number,
           s.cdhd_create_empl_name as cdld_create_empl_name,
           s.cdhd_create_empl_number as cdld_create_empl_number,
           s.cdhd_pc_cred as cdld_pc_cred,
           s.cdhd_pc_overlimit as cdld_pc_overlimit,
           s.cdhd_pc_overdraft as cdld_pc_overdraft,
           s.cdhd_pc_prc as cdld_pc_prc,
           s.cdhd_pc_ovrd_cred as cdld_pc_ovrd_cred,
           s.cdhd_pc_ovrd_overlimit as cdld_pc_ovrd_overlimit,
           s.cdhd_pc_ovrd_overdraft as cdld_pc_ovrd_overdraft,
           s.cdhd_pc_ovrd_prc as cdld_pc_ovrd_prc,
           s.cdhd_available_balance as cdld_available_balance,
           s.cdhd_to_ovrd_date as cdld_to_ovrd_date,
           s.cdhd_ovrd_days as cdld_ovrd_days,
           s.cdhd_cl_to_ovrd_date as cdld_cl_to_ovrd_date,
           s.cdhd_cl_ovrd_days as cdld_cl_ovrd_days,
           s.cdhd_pc_vnb_ovrd_cred as cdld_pc_vnb_ovrd_cred,
           s.cdhd_pc_vnb_ovrd_overdraft as cdld_pc_vnb_ovrd_overdraft,
           s.cdhd_pc_vnb_ovrd_overlimit as cdld_pc_vnb_ovrd_overlimit,
           s.cdhd_pc_vnb_ovrd_prc_cred as cdld_pc_vnb_ovrd_prc_cred
    from u1.DM_CARDSDAILY_LD_TMP s;
    commit;
end ETLT_DWH_DM_CARDSDAILY_LD;
/

