create or replace procedure u1.ETLT_DWH_DM_SPGU_LD is
begin
   insert /*+append*/ into u1.DWH_DM_SPGU_LD
       ( exld$change_date, exld$audit_id, exld_clnt_gid, exld_dcard_gid, exld_rep_date,
         exld_client_name, exld_client_iin, exld_client_rnn, exld_client_rfo_id, exld_deal_number,
         exld_currency, exld_begin_date, exld_plan_end_date, exld_actual_end_date, exld_amount,
         exld_deal_status, exld_rate_value, exld_prod_name, exld_prod_type, exld_old_ovd_scheme,
         exld_dept_name, exld_dept_number, exld_unp_name, exld_unp_number, exld_fil_name,
         exld_fil_number, exld_create_empl_name, exld_create_empl_number, exld_sign_empl_name, exld_sign_empl_number,
         exld_fgu_as_of_date, exld_fgu_cred, exld_fgu_prc, exld_fgu_ovrd_cred, exld_fgu_ovrd_prc,
         exld_to_ovrd_date, exld_ovrd_days, exld_cl_to_ovrd_date, exld_cl_ovrd_days,
         exld_vnb_ovrd_cred, exld_vnb_ovrd_prc, exld_vnb_comm, exld_fgu_overdraft, exld_fgu_ovrd_overdraft,exld_vnb_overdraft
       )
   select /*+ parallel(20)*/
          s.exhd$change_date as exld$change_date,
          s.exhd$audit_id as exld$audit_id,
          s.exhd_clnt_gid as exld_clnt_gid,
          s.exhd_dcard_gid as exld_dcard_gid,
          s.exhd_rep_date as exld_rep_date,
          s.exhd_client_name as exld_client_name,
          s.exhd_client_iin as exld_client_iin,
          s.exhd_client_rnn as exld_client_rnn,
          s.exhd_client_rfo_id as exld_client_rfo_id,
          s.exhd_deal_number as exld_deal_number,
          s.exhd_currency as exld_currency,
          s.exhd_begin_date as exld_begin_date,
          s.exhd_plan_end_date as exld_plan_end_date,
          s.exhd_actual_end_date as exld_actual_end_date,
          s.exhd_amount as exld_amount,
          s.exhd_deal_status as exld_deal_status,
          s.exhd_rate_value as exld_rate_value,
          s.exhd_prod_name as exld_prod_name,
          s.exhd_prod_type as exld_prod_type,
          s.exhd_old_ovd_scheme as exld_old_ovd_scheme,
          s.exhd_dept_name as exld_dept_name,
          s.exhd_dept_number as exld_dept_number,
          s.exhd_unp_name as exld_unp_name,
          s.exhd_unp_number as exld_unp_number,
          s.exhd_fil_name as exld_fil_name,
          s.exhd_fil_number as exld_fil_number,
          s.exhd_create_empl_name as exld_create_empl_name,
          s.exhd_create_empl_number as exld_create_empl_number,
          s.exhd_sign_empl_name as exld_sign_empl_name,
          s.exhd_sign_empl_number as exld_sign_empl_number,
          s.exhd_fgu_as_of_date as exld_fgu_as_of_date,
          s.exhd_fgu_cred as exld_fgu_cred,
          s.exhd_fgu_prc as exld_fgu_prc,
          s.exhd_fgu_ovrd_cred as exld_fgu_ovrd_cred,
          s.exhd_fgu_ovrd_prc as exld_fgu_ovrd_prc,
          s.exhd_to_ovrd_date as exld_to_ovrd_date,
          s.exhd_ovrd_days as exld_ovrd_days,
          s.exhd_cl_to_ovrd_date as exld_cl_to_ovrd_date,
          s.exhd_cl_ovrd_days as exld_cl_ovrd_days,
          s.exhd_vnb_ovrd_cred as exld_vnb_ovrd_cred ,
          s.exhd_vnb_ovrd_prc as exld_vnb_ovrd_prc,
          s.exhd_vnb_comm as exld_vnb_comm,
          s.exhd_fgu_overdraft as exld_fgu_overdraft, 
          s.exhd_fgu_ovrd_overdraft as exld_fgu_ovrd_overdraft,
          s.exhd_vnb_overdraft as exld_vnb_overdraft
     from u1.DM_SPGU_LD_TMP s;
   commit;
end ETLT_DWH_DM_SPGU_LD;
/

