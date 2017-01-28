create or replace force view u1.v_tmp_j_kaspi_red_mon_mo_stat as
select count(*) as cnt,
       count(distinct t.fld_id) as fld_all_cnt,

       count(distinct case when t.is_mo_reject is not null then t.fld_id end) as fld_mo_cnt,
       count(distinct case when t.is_mo_reject = 0 then t.fld_id end) as fld_mo_approved_cnt,
       round(count(distinct case when t.is_mo_reject = 0 then t.fld_id end) /
          count(distinct case when t.is_mo_reject is not null then t.fld_id end) * 100, 1) as mo_fld_approval_rate,

       count(distinct case when t.mo_cred_limit_k = 100 then t.fld_id end) as fld_lim_100k_cnt,
       count(distinct case when t.mo_cred_limit_k = 50 then t.fld_id end) as fld_lim_50k_cnt,
       round(count(distinct case when t.mo_cred_limit_k = 100 then t.fld_id end) /
          count(distinct case when t.is_mo_reject = 0 then t.fld_id end) * 100, 1) as fld_100k_in_approved_rate,

       count(distinct t.rfo_client_id) as cli_all_cnt,
       count(distinct case when t.is_mo_reject is not null then t.rfo_client_id end) as cli_mo_cnt,
       count(distinct case when t.is_mo_reject = 0 then t.rfo_client_id end) as cli_mo_approved_cnt,
       round(count(distinct case when t.is_mo_reject = 0 then t.rfo_client_id end) /
          count(distinct case when t.is_mo_reject is not null then t.rfo_client_id end) * 100, 1) as mo_cli_approval_rate

from V_TMP_J_KASPI_RED_MON t;
grant select on U1.V_TMP_J_KASPI_RED_MON_MO_STAT to LOADDB;


