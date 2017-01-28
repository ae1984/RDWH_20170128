create or replace force view u1.v_rdb_approval_rfo as
select "TEXT_YYYY_MM_DD_WEEK_DAY","CARDS_AR_CON","CARDS_AR_CON_MA7","CARDS_AR_CLI","CARDS_AR_CLI_MA7","CARDS_APP_SUM_MLN","MONEY_AR_CON","MONEY_AR_CON_MA7","MONEY_AR_CLI","MONEY_AR_CLI_MA7","MONEY_APP_SUM_MLN","GOODS_AR_CON","GOODS_AR_CON_MA7","GOODS_AR_CLI","GOODS_AR_CLI_MA7","GOODS_APP_SUM_MLN","AUTO_AR_CON","AUTO_AR_CON_MA7","AUTO_AR_CLI","AUTO_AR_CLI_MA7","AUTO_APP_SUM_MLN","TOTAL_AR_CON","TOTAL_AR_CON_MA7","TOTAL_AR_CLI","TOTAL_AR_CLI_MA7","TOTAL_APP_SUM_MLN" from (
    select y.text_yyyy_mm_dd_week_day,
           y.product_type,
           y.appr_rate_con,
           y.appr_rate_con_mov_avg_7,
           y.appr_rate_cli,
           y.appr_rate_cli_mov_avg_7,
           y.con_appr_amount_mln
      from (
          select x1.*,
                 round(avg(x1.appr_rate_con) over (partition by x1.product_type order by x1.yyyy_mm_dd
                            range between 6 preceding and current row),2) as appr_rate_con_mov_avg_7,
                 round(avg(x1.appr_rate_cli) over (partition by x1.product_type order by x1.yyyy_mm_dd
                            range between 6 preceding and current row),2) as appr_rate_cli_mov_avg_7
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
          ) x1
      ) y
) pivot (
    avg(appr_rate_con) as ar_con,
    avg(appr_rate_con_mov_avg_7) as ar_con_ma7,
    avg(appr_rate_cli) as ar_cli,
    avg(appr_rate_cli_mov_avg_7) as ar_cli_ma7,
    sum(con_appr_amount_mln) as app_sum_mln

    for product_type in (
        'КАРТЫ' as cards,
        'ДЕНЬГИ' as money,
        'ТОВАРЫ' as goods,
        'АВТО' as auto,
        'ВСЕГО' as total)
) order by 1;
grant select on U1.V_RDB_APPROVAL_RFO to LOADDB;
grant select on U1.V_RDB_APPROVAL_RFO to LOADER;
grant select on U1.V_RDB_APPROVAL_RFO to LOAD_RDWH_PROD;


