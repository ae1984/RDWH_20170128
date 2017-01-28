create or replace force view u1.v_rd_online_ug_sale_day2_new as
select "TEXT_YYYY_MM_DD_HH_10MI","FLD_CNT_AVG"
  from (select y.text_yyyy_mm_dd_hh_10mi,
               y.fld_cnt_avg
                  from (select /*tm.yyyy_mm_dd,*/
                               tm.text_yyyy_mm_dd_hh_10mi,
                               count(f.rfo_contract_id) as fld_cnt_avg
                          from u1.V_TIME_MINUTES tm
                          left join m_rfo_online_fld_ekt_day_new f
                            on trunc(f.folder_date_create_mi, 'mi') =
                               tm.yyyy_mm_dd_hh_mi
                           and (f.cr_program_name =
                               'ЭКСПРЕСС-КРЕДИТОВАНИЕ-ТОВАР'   or f.cr_program_name =
                               'ЭКСПРЕСС-КРЕДИТЫ (УСЛУГИ)' ) AND F.IS_CREDIT_ISSUED=1 and f.is_point_active=0 and f.x_dnp_region='ЮГ'
                                    --     and f.x_dnp_name='АЛМАТЫ'
                          --   and  trunc(f.folder_date_create_mi) =to_date('20.01.2014','DD.MM.YYYY')
                         where /*to_number(to_char(tm.yyyy_mm_dd_hh_mi, 'hh24mi')) >= 845
                           and*/ f.folder_date_create_mi <= sysdate
                         group by  tm.text_yyyy_mm_dd_hh_10mi)  y) z
;
grant select on U1.V_RD_ONLINE_UG_SALE_DAY2_NEW to LOADDB;


