create or replace procedure u1.ETLT_DWH_DM_SPGU_HD_H is
      s_mview_name     varchar2(30) := 'DWH_DM_SPGU_HD_H';
      vStrDate         date := sysdate;
      v_max_date2      timestamp;

    begin

      select max(t.exhd_rep_date)
        into v_max_date2
        from DWH_DM_SPGU_HD_H t;

      insert  into DWH_DM_SPGU_HD_H
      select /*+ driving_site*/ t.exhd_rep_date,
              substr(t.exhd_deal_number,1,250) as exhd_deal_number,
              t.exhd_begin_date,
              substr(t.exhd_prod_type,1,250) as exhd_prod_type,
              substr(t.exhd_old_ovd_scheme,1,1) as exhd_old_ovd_scheme,
              t.exhd_fgu_cred,
              t.exhd_fgu_prc,
              t.exhd_fgu_ovrd_cred,
              t.exhd_fgu_ovrd_prc,
              t.exhd_ovrd_days,
              trunc(sysdate),
              t.exhd_vnb_ovrd_cred,
              t.exhd_vnb_ovrd_prc,
              t.exhd_vnb_comm,
              t.exhd_fgu_overdraft,
              t.exhd_fgu_ovrd_overdraft,
              t.exhd_vnb_overdraft
      from DWH_SAN.DM_SPGU_HD@DWH_PROD2 t
      where t.exhd_rep_date  >= v_max_date2 + 1
      and nvl(t.exhd_fgu_cred,0) +
          nvl(t.exhd_fgu_prc,0)   +
          nvl(t.exhd_fgu_ovrd_cred,0) +
          nvl(t.exhd_fgu_ovrd_prc,0) +
          nvl(t.exhd_vnb_ovrd_cred,0) +
          nvl(t.exhd_vnb_ovrd_prc,0)  +
          nvl(t.exhd_vnb_comm,0)  +
          nvl(t.exhd_fgu_overdraft,0) +
          nvl(t.exhd_fgu_ovrd_overdraft,0) +
          nvl(t.exhd_vnb_overdraft,0) > 0;
      commit;



    end ETLT_DWH_DM_SPGU_HD_H;
/

