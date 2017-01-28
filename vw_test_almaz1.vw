create or replace force view u1.vw_test_almaz1 as
select z."TEXT_HH_10MI",z."FLD_CNT_AVG",z."FLD_CNT_MOV_AVG_AVG_5",z."FLD_CNT_MOV_AVG_AVG_5_PREV" /*, case when fld_cnt_mov_avg_med_5_prev > 0 then
              fld_cnt_mov_avg_med_5 / fld_cnt_mov_avg_med_5_prev else 1 end as rise_coefficient*/
  from (select y.text_hh_10mi,
               --Кол-во продажи по папкам
               y.fld_cnt_avg,
               avg(y.fld_cnt_avg) over(partition by null order by y.text_hh_10mi rows between 4 preceding and 4 following) as fld_cnt_mov_avg_avg_5, -- moving average of 9 avg rows
               avg(y.fld_cnt_avg) over(partition by null order by y.text_hh_10mi rows between 5 preceding and 3 following) as fld_cnt_mov_avg_avg_5_prev -- previous moving average

          from (select x.text_hh_10mi,
                       avg(x.fld_cnt) as fld_cnt_avg
                  from (select /*tm.yyyy_mm_dd,*/
                               tm.text_hh_10mi,
                               count(f.rfo_contract_id) as fld_cnt
                          from V_TIME_MINUTES tm
                          left join M_FOLDER_CON_CANCEL f
                            on trunc(f.folder_date_create_mi, 'mi') =
                               tm.yyyy_mm_dd_hh_mi
                           and (f.cr_program_name =
                               'ЭКСПРЕСС-КРЕДИТОВАНИЕ-ТОВАР'   or f.cr_program_name =
                               'ЭКСПРЕСС-КРЕДИТЫ (УСЛУГИ)' ) -- and   f.cr_program_name = 'ЭКСПРЕСС-КРЕДИТЫ (УСЛУГИ)'
                                    --     and f.x_dnp_name='АЛМАТЫ'
                             and  trunc(f.folder_date_create_mi) =to_date('20.01.2014','DD.MM.YYYY')
                         where to_number(to_char(tm.yyyy_mm_dd_hh_mi, 'hh24mi')) >= 845
                           and to_number(to_char(tm.yyyy_mm_dd_hh_mi, 'hh24mi')) <= 2200
                         group by  tm.text_hh_10mi) x
                 group by x.text_hh_10mi) y) z
;
grant select on U1.VW_TEST_ALMAZ1 to LOADDB;
grant select on U1.VW_TEST_ALMAZ1 to LOADER;


