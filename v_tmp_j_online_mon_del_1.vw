create or replace force view u1.v_tmp_j_online_mon_del_1 as
select td.text_yyyy_mm_dd_week_day,
       x.sales_mln, x.del_1_rate_by_vol, x.del_7_rate_by_vol,--, x.del_30_rate_by_vol,
       y.pos_del_1_rate_by_vol, y.pos_del_7_rate_by_vol,--, y.pos_del_30_rate_by_vol
       x.sales_mln / y.pos_sales_mln as online_to_pos_sales_ratio,
       x.del_7_rate_by_vol / y.pos_del_7_rate_by_vol as online_to_pos_del_7_ratio
/*       case when td.yyyy_mm_dd <= add_months(trunc(sysdate),-1)-1 then 1 end as del_1_maturity,
       case when td.yyyy_mm_dd <= add_months(trunc(sysdate),-1)-8 then 1 end as del_7_maturity,
       case when td.yyyy_mm_dd <= add_months(trunc(sysdate),-2)-1 then 1 end as del_30_maturity,*/
--       x.*, y.*
from V_TIME_DAYS td
left join (
    select d.begin_date,
--           count(*) as cnt, count(distinct d.deal_number) as con_cnt,
--           count(distinct d.client_iin) as cli_cnt,
           sum(d.amount) / 1000000 as sales_mln,
           coalesce(sum(case when d.x_delinq_days > 0 then d.x_total_debt end) / sum(d.amount),0) as del_1_rate_by_vol,
           case when d.begin_date <= add_months(trunc(sysdate),-1)-10 then
                     coalesce(sum(case when d.x_delinq_days > 7 then d.x_total_debt end) / sum(d.amount),0)
                end as del_7_rate_by_vol/*,
           case when d.begin_date <= add_months(trunc(sysdate),-2)-5 then
                     sum(case when d.x_delinq_days > 30 then d.x_total_debt end) / sum(d.amount)
                end as del_30_rate_by_vol*/
    from V_DWH_PORTFOLIO_CURRENT d
    join M_FOLDER_CON_CANCEL t on t.folder_id = d.folder_id_first
    where d.x_is_credit_issued = 1 and
          d.begin_date >= to_date('2014-12-08','yyyy-mm-dd') and
          d.prod_type = 'ЭКСПРЕСС-КРЕДИТЫ (ТОВАРЫ)' and
          t.process_name = 'ОНЛАЙН КРЕДИТ'
    group by d.begin_date
) x on x.begin_date = td.yyyy_mm_dd
left join (
    select d.begin_date,
--           count(*) as pos_cnt, count(distinct d.deal_number) as pos_con_cnt,
--           count(distinct d.client_iin) as pos_cli_cnt,
           sum(d.amount) / 1000000 as pos_sales_mln,
           coalesce(sum(case when d.x_delinq_days > 0 then d.x_total_debt end) / sum(d.amount),0) as pos_del_1_rate_by_vol,
           case when d.begin_date <= add_months(trunc(sysdate),-1)-10 then
                     coalesce(sum(case when d.x_delinq_days > 7 then d.x_total_debt end) / sum(d.amount),0)
                end as pos_del_7_rate_by_vol/*,
           case when d.begin_date <= add_months(trunc(sysdate),-2)-5 then
                     sum(case when d.x_delinq_days > 30 then d.x_total_debt end) / sum(d.amount)
                end as pos_del_30_rate_by_vol*/
    from V_DWH_PORTFOLIO_CURRENT d
    join M_FOLDER_CON_CANCEL t on t.folder_id = d.folder_id_first
    where d.x_is_credit_issued = 1 and
          d.begin_date >= to_date('2014-12-08','yyyy-mm-dd') and
          d.prod_type = 'ЭКСПРЕСС-КРЕДИТЫ (ТОВАРЫ)' and
          t.process_name != 'ОНЛАЙН КРЕДИТ'
    group by d.begin_date
) y on y.begin_date = td.yyyy_mm_dd
where td.yyyy_mm_dd >= to_date('2014-12-08','yyyy-mm-dd') and
      td.yyyy_mm_dd < trunc(sysdate)
order by 1
;
grant select on U1.V_TMP_J_ONLINE_MON_DEL_1 to LOADDB;
grant select on U1.V_TMP_J_ONLINE_MON_DEL_1 to LOADER;


