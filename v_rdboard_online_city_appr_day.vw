create or replace force view u1.v_rdboard_online_city_appr_day as
select "REQ_DATE",x_dnp_name,"APP_CON_CNT_AVG","APP_CON_CNT_MED","APP_CON_CNT_MOV_AVG_AVG_5","APP_CON_MOV_AVG_AVG_5_PREV","APP_CON_MOV_AVG_MED_5","APP_CON_MOV_AVG_MED_5_PREV","APP_CLI_CNT_AVG","APP_CLI_CNT_MED","APP_CLI_CNT_MOV_AVG_AVG_5","APP_CLI_MOV_AVG_AVG_5_PREV","APP_CLI_MOV_AVG_MED_5","APP_CLI_MOV_AVG_MED_5_PREV"
  from (select y.text_hh as req_date,
  y.x_dnp_name,
              --
               y.app_con_cnt_avg,
               y.app_con_cnt_med,
               avg(y.app_con_cnt_avg) over(partition by null order by y.text_hh rows between 4 preceding and 4 following) as app_con_cnt_mov_avg_avg_5, -- moving average of 9 avg rows
               avg(y.app_con_cnt_avg) over(partition by null order by y.text_hh rows between 5 preceding and 3 following) as app_con_mov_avg_avg_5_prev, -- previous moving average
               avg(y.app_con_cnt_med) over(partition by null order by y.text_hh rows between 4 preceding and 4 following) as app_con_mov_avg_med_5, -- moving average of 9 median rows
               avg(y.app_con_cnt_med) over(partition by null order by y.text_hh rows between 5 preceding and 3 following) as app_con_mov_avg_med_5_prev, -- previous moving average
               --
               y.app_cli_cnt_avg,
               y.app_cli_cnt_med,
               avg(y.app_cli_cnt_avg) over(partition by null order by y.text_hh rows between 4 preceding and 4 following) as app_cli_cnt_mov_avg_avg_5, -- moving average of 9 avg rows
               avg(y.app_cli_cnt_avg) over(partition by null order by y.text_hh rows between 5 preceding and 3 following) as app_cli_mov_avg_avg_5_prev, -- previous moving average
               avg(y.app_cli_cnt_med) over(partition by null order by y.text_hh rows between 4 preceding and 4 following) as app_cli_mov_avg_med_5, -- moving average of 9 median rows
               avg(y.app_cli_cnt_med) over(partition by null order by y.text_hh rows between 5 preceding and 3 following) as app_cli_mov_avg_med_5_prev -- previous moving average
          from (select x.text_hh,
            ---
                         avg(x.approval_rate_by_con) as app_con_cnt_avg,
                       median(x.approval_rate_by_con) as app_con_cnt_med,
                       avg(x.approval_rate_by_cli) as app_cli_cnt_avg,
                       median(x.approval_rate_by_cli) as app_cli_cnt_med,
                       x.x_dnp_name
                  from (select /*tm.yyyy_mm_dd,*/
                         tm.text_hh,
                         round(count(case
                                       when f.is_credit_issued = 1 then
                                        f.rfo_contract_id
                                     end) / count(*) * 100,
                               2) as approval_rate_by_con,
                         round(count(distinct case
                                       when f.is_credit_issued = 1 then
                                        f.rfo_client_id
                                     end) / count(distinct f.rfo_client_id) * 100,
                               2) as approval_rate_by_cli,
                         round(sum(case
                                     when f.is_credit_issued = 1 then
                                      f.contract_amount
                                   end) / 1000000) as sales_mln,
                                   f.x_dnp_name
                          from V_TIME_MINUTES tm
                          left join m_rfo_online_fld_ekt_day f
                            on trunc(f.folder_date_create_mi, 'mi') =
                               tm.yyyy_mm_dd_hh_mi
                           and (f.cr_program_name =
                                'ЭКСПРЕСС-КРЕДИТОВАНИЕ-ТОВАР' or
                                f.cr_program_name =
                                'ЭКСПРЕСС-КРЕДИТЫ (УСЛУГИ)')
                          and f.is_point_active = 0
                        --     and f.x_dnp_name='АЛМАТЫ'
                        --   and  trunc(f.folder_date_create_mi) =to_date('20.01.2014','DD.MM.YYYY')
                         where /*to_number(to_char(tm.yyyy_mm_dd_hh_mi, 'hh24mi')) >= 845
                                                   and*/
                         tm.yyyy_mm_dd_hh_mi >= trunc(sysdate) + 8.75 / 24
                           and -- ПРОД
                         tm.yyyy_mm_dd_hh_mi < trunc(sysdate) + 22 / 24
                         and
                         f.folder_date_create_mi <= sysdate and f.x_dnp_name is not null
                         group by  tm.text_hh,f.x_dnp_name) x
                 group by x.text_hh, x.x_dnp_name) y) z
;
grant select on U1.V_RDBOARD_ONLINE_CITY_APPR_DAY to LOADDB;
grant select on U1.V_RDBOARD_ONLINE_CITY_APPR_DAY to LOADER;
grant select on U1.V_RDBOARD_ONLINE_CITY_APPR_DAY to LOAD_RDWH_PROD;


