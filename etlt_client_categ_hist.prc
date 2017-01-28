create or replace procedure u1.ETLT_CLIENT_CATEG_HIST is
  s_mview_name     varchar2(30) := 'T_CLIENT_CATEG_HIST';
  vStrDate         date := sysdate;
begin
  execute immediate ('truncate table T_CLIENT_FIRSTDATE_FOLDER');
  insert into T_CLIENT_FIRSTDATE_FOLDER
  select /*+parallel(20)*/
       nvl(t.iin,'-') as iin
      ,t.rfo_client_id
      ,a.rbo_client_id
      ,min (t.folder_date_create_mi) as first_folder_date_create_mi
  from M_FOLDER_CON_CANCEL_BASE t
  left join m_client_link a on a.rfo_client_id = t.rfo_client_id
  group by t.iin, t.rfo_client_id, a.rbo_client_id;
  commit;

  execute immediate ('truncate table T_CLIENT_CATEG_HIST_PRE2');
  insert into T_CLIENT_CATEG_HIST_PRE2
  select /*+parallel(50)*/
      t.*
      ,a.value as last_month_workday
  from T_CLIENT_FIRSTDATE_FOLDER t
  join (select * from m_rbo_calendar_value where calendar_name = 'LAST_MONTH_DAY') a on a.value between add_months(t.first_folder_date_create_mi,-1) and sysdate
  left join T_CLIENT_CATEG_HIST ch on ch.rfo_client_id=t.rfo_client_id and ch.last_month_workday=a.value
  where ch.rfo_client_id is null;
  commit;

  execute immediate ('truncate table T_CLIENT_CATEG_HIST_PRE1');
  insert into T_CLIENT_CATEG_HIST_PRE1
  select /*+use_hash(f,d,d1,d2,d3,o) parallel(f,30) parallel(d,10) parallel(d2,10) parallel(d3,10) parallel(o,10)*/
     f.iin, f.rfo_client_id, f.rbo_client_id ,f.last_month_workday
    ,case when count(distinct d.deal_number) > 0 then 0 else 1 end as is_client_new
    ,count(distinct d2.deal_number) as prev_con_closed_cnt
    ,count(distinct o.spof_end_date) as prior_optim_count

  from T_CLIENT_CATEG_HIST_PRE2 f
  left join V_DWH_PORTFOLIO_CURRENT d on d.client_iin = f.iin and
                                         d.x_start_date_actual <= f.last_month_workday and
                                         d.x_is_credit_issued = 1

  left join V_DWH_PORTFOLIO_CURRENT d2 on d2.client_iin = f.iin and
                                          d2.actual_end_date <= f.last_month_workday and
                                          d2.x_is_credit_issued = 1 and
                                          d2.x_start_date_actual is not null and
                                          d2.x_product_type != 'ОПТИМИЗАЦИЯ'
  left join V_DWH_PORTFOLIO_CURRENT d3 on d3.client_iin = f.iin and d3.x_is_credit_issued = 1
  left join M_DWH_ACC_SPECIAL_OFFER_CON o on o.contract_number = d3.deal_number and
                                             o.spof_spec_offer_status_cd in ('EXECUTED','DEFAULT','WORK') and
                                             o.spof_end_date <= f.last_month_workday
  group by f.iin, f.rfo_client_id, f.rbo_client_id, f.last_month_workday;
  commit;

  execute immediate ('truncate table T_CLIENT_CATEG_HIST_PRE');
  insert into T_CLIENT_CATEG_HIST_PRE
  select  /*+use_hash(t,cc,ch) parallel(t,30) parallel(cc,10) parallel(ch,10) */
      t.iin, t.rfo_client_id, t.rbo_client_id, t.last_month_workday
     ,max(ch.delinq_days_in_month) as prev_con_del_days_max
     ,count(distinct case when ch.fact_pmts_in_month > 0 then ch.yyyy_mm_num end) as fact_pmt_mon_before
     ,count(distinct case when ch.yyyy_mm_num >= to_number(to_char(add_months(t.last_month_workday,-12),'yyyymm')) and
                                  ch.fact_pmts_in_month > 0 then ch.yyyy_mm_num end) as fact_pmt_mon_before_12_mon
  from T_CLIENT_CATEG_HIST_PRE2 t
  left join V_CLIENT_CAL cc on cc.client_iin_last = t.iin
  left join V_CLIENT_HISTORY ch on ch.client_id = cc.client_id and
                                   ch.yyyy_mm_num <= to_number(to_char(t.last_month_workday,'yyyymm'))
  group by t.iin, t.rfo_client_id, t.rbo_client_id, t.last_month_workday;
  commit;

  insert into T_CLIENT_CATEG_HIST
  select /*+parallel(50)*/
     t.iin, t.rfo_client_id, t.rbo_client_id, t.last_month_workday
     ,t.is_client_new
     , case when coalesce(t.prev_con_closed_cnt, 0) >= 2 and     --Закрыл несколько кредитов
               coalesce(t.prior_optim_count, 0) = 0 and        --Не было оптимизации
               coalesce(a.prev_con_del_days_max, 0) <= 15 and  --Не допускал просрочку > 15
               coalesce(a.fact_pmt_mon_before, 0) >= 12 and    --Кол-во платежей
               coalesce(a.fact_pmt_mon_before_12_mon, 0) > 0   --Платил в течении последних 12 мес
          then 1 else 0 end as is_categ_a
     ,case when coalesce(t.prev_con_closed_cnt, 0) >= 1 and     --Закрыл несколько кредитов
               coalesce(a.prev_con_del_days_max, 0) < 31 and  --Не допускал просрочку > 15
               coalesce(a.fact_pmt_mon_before, 0) >= 6     --Кол-во платежей
          then 1 else 0 end as is_categ_b
  from T_CLIENT_CATEG_HIST_PRE1 t
  left join T_CLIENT_CATEG_HIST_PRE a on a.rfo_client_id=t.rfo_client_id and a.last_month_workday =t.last_month_workday ;
  commit;

end ETLT_CLIENT_CATEG_HIST;
/

