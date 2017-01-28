create or replace force view u1.v_rdb_approval_rfo_dwh as
select "TEXT_YYYY_MM_DD_WEEK_DAY","CARDS_AR_CON","CARDS_AR_CON_MA7","CARDS_AR_CLI","CARDS_AR_CLI_MA7","CARDS_APP_SUM_MLN","CARDS_AR_CON_DWH","CARDS_AR_CON_MA7_DWH","CARDS_AR_CLI_DWH","CARDS_AR_CLI_MA7_DWH","CARDS_APP_SUM_MLN_DWH","MONEY_AR_CON","MONEY_AR_CON_MA7","MONEY_AR_CLI","MONEY_AR_CLI_MA7","MONEY_APP_SUM_MLN","MONEY_AR_CON_DWH","MONEY_AR_CON_MA7_DWH","MONEY_AR_CLI_DWH","MONEY_AR_CLI_MA7_DWH","MONEY_APP_SUM_MLN_DWH","GOODS_AR_CON","GOODS_AR_CON_MA7","GOODS_AR_CLI","GOODS_AR_CLI_MA7","GOODS_APP_SUM_MLN","GOODS_AR_CON_DWH","GOODS_AR_CON_MA7_DWH","GOODS_AR_CLI_DWH","GOODS_AR_CLI_MA7_DWH","GOODS_APP_SUM_MLN_DWH","AUTO_AR_CON","AUTO_AR_CON_MA7","AUTO_AR_CLI","AUTO_AR_CLI_MA7","AUTO_APP_SUM_MLN","AUTO_AR_CON_DWH","AUTO_AR_CON_MA7_DWH","AUTO_AR_CLI_DWH","AUTO_AR_CLI_MA7_DWH","AUTO_APP_SUM_MLN_DWH","TOTAL_AR_CON","TOTAL_AR_CON_MA7","TOTAL_AR_CLI","TOTAL_AR_CLI_MA7","TOTAL_APP_SUM_MLN","TOTAL_AR_CON_DWH","TOTAL_AR_CON_MA7_DWH","TOTAL_AR_CLI_DWH","TOTAL_AR_CLI_MA7_DWH","TOTAL_APP_SUM_MLN_DWH" from (
    select y.text_yyyy_mm_dd_week_day,
           y.product_type,
           y.appr_rate_con,
           y.appr_rate_con_mov_avg_7,
           y.appr_rate_cli,
           y.appr_rate_cli_mov_avg_7,
           y.con_appr_amount_mln,
           y.appr_rate_con_dwh,
           y.appr_rate_cli_dwh,
           y.con_appr_amount_mln_dwh,
           round(avg(y.appr_rate_con_dwh) over (partition by y.product_type order by y.yyyy_mm_dd
                      range between 6 preceding and current row),2) as appr_rate_con_dwh_mov_avg_7,
           round(avg(y.appr_rate_cli_dwh) over (partition by y.product_type order by y.yyyy_mm_dd
                      range between 6 preceding and current row),2) as appr_rate_cli_dwh_mov_avg_7
      from (
          select x1.*,
                 round(avg(x1.appr_rate_con) over (partition by x1.product_type order by x1.yyyy_mm_dd
                            range between 6 preceding and current row),2) as appr_rate_con_mov_avg_7,
                 round(avg(x1.appr_rate_cli) over (partition by x1.product_type order by x1.yyyy_mm_dd
                            range between 6 preceding and current row),2) as appr_rate_cli_mov_avg_7,
                 case when x1.con_cnt > 0 then round(x2.con_cnt / x1.con_cnt * 100, 2) else 0 end as appr_rate_con_dwh,
                 case when x1.cli_cnt > 0 then round(x2.cli_cnt / x1.cli_cnt * 100, 2) else 0 end as appr_rate_cli_dwh,
                 x2.con_appr_amount_mln as con_appr_amount_mln_dwh
          from (
            select td.yyyy_mm_dd, td.text_yyyy_mm_dd_week_day, product_type,
                   round(sum(case when t.is_credit_issued = 1 then t.contract_amount end)/1000000,0) as con_appr_amount_mln,
                   round(count(distinct case when t.is_credit_issued = 1 then t.rfo_contract_id end) /
                            count(distinct t.rfo_contract_id) * 100, 2) as appr_rate_con,
                   round(count(distinct case when t.is_credit_issued = 1 then t.rfo_client_id end) /
                            count(distinct t.rfo_client_id) * 100, 2) as appr_rate_cli,
                   count(distinct t.rfo_contract_id) as con_cnt,
                   count(distinct t.rfo_client_id) as cli_cnt
            from V_TIME_DAYS td
            join V_CANCEL_FOLDER_CON_ONE_YEAR t on t.folder_date_day = td.yyyy_mm_dd
            where td.yyyy_mm_dd > add_months(trunc(sysdate), -3)
            group by td.yyyy_mm_dd, td.text_yyyy_mm_dd_week_day, t.product_type
            union all
            select td.yyyy_mm_dd, td.text_yyyy_mm_dd_week_day, 'ВСЕГО' as product_type,
                   round(sum(case when t.is_credit_issued = 1 then t.contract_amount end)/1000000,0) as con_appr_amount_mln,
                   round(count(distinct case when t.is_credit_issued = 1 then t.rfo_contract_id end) /
                            count(distinct t.rfo_contract_id) * 100, 2) as appr_rate_con,
                   round(count(distinct case when t.is_credit_issued = 1 then t.rfo_client_id end) /
                            count(distinct t.rfo_client_id) * 100, 2) as appr_rate_cli,
                   count(distinct t.rfo_contract_id) as con_cnt,
                   count(distinct t.rfo_client_id) as cli_cnt
            from V_TIME_DAYS td
            join V_CANCEL_FOLDER_CON_ONE_YEAR t on t.folder_date_day = td.yyyy_mm_dd
            where td.yyyy_mm_dd > add_months(trunc(sysdate), -3)
            group by td.yyyy_mm_dd, td.text_yyyy_mm_dd_week_day
          ) x1 left join ( -- выданные по версии ДВХ (выдачи карт - по дате установки револьверности)
            select td.yyyy_mm_dd, td.text_yyyy_mm_dd_week_day, t.x_product_type,
                   count(*) as con_cnt,
                   count(distinct t.client_iin) as cli_cnt,
                   round(sum(t.x_amount)/1000000,0) as con_appr_amount_mln
            from V_TIME_DAYS td
            join V_DWH_PORTFOLIO_CURRENT t on t.x_start_date_actual = td.yyyy_mm_dd
            where t.x_is_credit_issued = 1 and t.x_start_date_actual is not null and
                  td.yyyy_mm_dd > add_months(trunc(sysdate), -3)
            group by td.yyyy_mm_dd, td.text_yyyy_mm_dd_week_day, t.x_product_type
            union all
            select td.yyyy_mm_dd, td.text_yyyy_mm_dd_week_day, 'ВСЕГО' as x_product_type,
                   count(*) as con_cnt,
                   count(distinct t.client_iin) as cli_cnt,
                   round(sum(t.x_amount)/1000000,0) as con_appr_amount_mln
            from V_TIME_DAYS td
            join V_DWH_PORTFOLIO_CURRENT t on t.x_start_date_actual = td.yyyy_mm_dd
            where t.x_is_credit_issued = 1 and t.x_start_date_actual is not null and
                  td.yyyy_mm_dd > add_months(trunc(sysdate), -3)
            group by td.yyyy_mm_dd, td.text_yyyy_mm_dd_week_day
          ) x2 on x2.yyyy_mm_dd = x1.yyyy_mm_dd and x2.x_product_type = x1.product_type
      ) y
) pivot (
    avg(appr_rate_con) as ar_con,
    avg(appr_rate_con_mov_avg_7) as ar_con_ma7,
    avg(appr_rate_cli) as ar_cli,
    avg(appr_rate_cli_mov_avg_7) as ar_cli_ma7,
    sum(con_appr_amount_mln) as app_sum_mln,

    avg(appr_rate_con_dwh) as ar_con_dwh,
    avg(appr_rate_con_dwh_mov_avg_7) as ar_con_ma7_dwh,
    avg(appr_rate_cli_dwh) as ar_cli_dwh,
    avg(appr_rate_cli_dwh_mov_avg_7) as ar_cli_ma7_dwh,
    sum(con_appr_amount_mln_dwh) as app_sum_mln_dwh

    for product_type in (
        'КАРТЫ' as cards,
        'ДЕНЬГИ' as money,
        'ТОВАРЫ' as goods,
        'АВТО' as auto,
        'ВСЕГО' as total)
) order by 1
;
grant select on U1.V_RDB_APPROVAL_RFO_DWH to LOADDB;
grant select on U1.V_RDB_APPROVAL_RFO_DWH to LOADER;
grant select on U1.V_RDB_APPROVAL_RFO_DWH to LOAD_RDWH_PROD;


