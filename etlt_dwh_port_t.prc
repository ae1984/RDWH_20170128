create or replace procedure u1.ETLT_DWH_PORT_T is
      s_mview_name     varchar2(30) := 'DWH_PORT_T';
      vStrDate         date := sysdate;
      v_sql            varchar2(1024);

    begin
      v_sql := 'truncate table DWH_PORT_T';

      execute immediate v_sql;

      insert /*+ append enable_parallel_dml parallel(10)*/ into DWH_PORT_T
      SELECT /*+ parallel(20) */ vv.*,
               max(vv.delinq_days_old) over (partition by vv.x_client_id, vv.rep_date) as
          x_delinq_days,
               case when vv.x_total_debt > 0 then 1 else 0 end as
          x_is_active
      from (
      select
        t.cdhd_rep_date as rep_date,
        upper(t.cdhd_prod_type) as prod_type,
        t.cdhd_deal_number as deal_number,
        t.cdhd_ovrd_days as delinq_days_old,

            nvl(t.cdhd_pc_cred,0) +
            nvl(t.cdhd_pc_prc,0) +
            nvl(t.cdhd_pc_overlimit,0) +
            nvl(t.cdhd_pc_overdraft,0) +
            nvl(t.cdhd_pc_ovrd_cred,0) +
            nvl(t.cdhd_pc_ovrd_prc,0) +
            nvl(t.cdhd_pc_ovrd_overlimit,0) +
            nvl(t.cdhd_pc_ovrd_overdraft,0) +

            nvl(t.cdhd_pc_vnb_ovrd_cred,0) +
            nvl(t.cdhd_pc_vnb_ovrd_overdraft,0) +
            nvl(t.cdhd_pc_vnb_ovrd_overlimit,0) +
            nvl(t.cdhd_pc_vnb_ovrd_prc_cred,0) as x_total_debt,

            nvl(t.cdhd_pc_ovrd_cred,0) +
            nvl(t.cdhd_pc_ovrd_prc,0) +
            nvl(t.cdhd_pc_ovrd_overlimit,0) +
            nvl(t.cdhd_pc_ovrd_overdraft,0) as x_delinq_amount,

            1 as  x_is_card,
            substr(ltrim(t.cdhd_deal_number,'R'),1,7) as  x_client_id,
            nvl(t.cdhd_set_revolving_date, t.cdhd_begin_date) as x_start_date,
            case when nvl(t.cdhd_pc_vnb_ovrd_cred,0) > 0 or
                 nvl(t.cdhd_pc_vnb_ovrd_overlimit,0) > 0 or
                 nvl(t.cdhd_pc_vnb_ovrd_overdraft,0) > 0 or
                 nvl(t.cdhd_pc_vnb_ovrd_prc_cred,0) > 0 then 'W'
            else
                 'Y' end as is_on_balance

      from  DWH_DM_CARDSDAILY_HD_T t

      union all

      select
      s.exhd_rep_date as rep_date,
      upper(s.exhd_prod_type) as prod_type,
      s.exhd_deal_number AS deal_number,
          s.exhd_ovrd_days as delinq_days_old,

          nvl(s.exhd_fgu_cred,0) +
          nvl(s.exhd_fgu_prc,0) +
          nvl(s.exhd_fgu_overdraft,0) +

          nvl(s.exhd_fgu_ovrd_cred,0) +
          nvl(s.exhd_fgu_ovrd_prc,0) +
          nvl(s.exhd_fgu_ovrd_overdraft,0) +

          nvl(s.exhd_vnb_ovrd_cred,0) +
          nvl(s.exhd_vnb_ovrd_prc,0) +
          nvl(s.exhd_vnb_comm,0) +
          nvl(s.exhd_vnb_overdraft,0) as x_total_debt,

          nvl(s.exhd_fgu_ovrd_cred,0) +
          nvl(s.exhd_fgu_ovrd_prc,0) +
          nvl(s.exhd_vnb_overdraft,0) as x_delinq_amount,

          0 as x_is_card,
          substr(ltrim(s.exhd_deal_number,'R'),1,7) as x_client_id,
          s.exhd_begin_date as x_start_date,
          case when nvl(s.exhd_vnb_ovrd_cred,0) > 0 or
               nvl(s.exhd_vnb_ovrd_prc,0) > 0 or
               nvl(s.exhd_vnb_comm,0) > 0 or
               nvl(s.exhd_vnb_overdraft,0) > 0 then 'W'
               when s.exhd_old_ovd_scheme is null then 'Y'
               when s.exhd_old_ovd_scheme = 'N' then 'Y'
               when s.exhd_old_ovd_scheme = 'Y' then 'I' end
          as is_on_balance
      from DWH_DM_SPGU_HD_T s
      ) vv
      where vv.x_total_debt > 0
      ;

      commit;


    end ETLT_DWH_PORT_T;
/

