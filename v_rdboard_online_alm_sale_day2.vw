create or replace force view u1.v_rdboard_online_alm_sale_day2 as
select "TEXT_YYYY_MM_DD_HH_10MI","FLD_CNT_AVG"
  from (select y.text_yyyy_mm_dd_hh_10mi,
               y.fld_cnt_avg
                  from (select /*tm.yyyy_mm_dd,*/
                               tm.text_yyyy_mm_dd_hh_10mi,
                               count(f.rfo_contract_id) as fld_cnt_avg
                          from V_TIME_MINUTES tm
                          left join m_rfo_online_fld_ekt_day f
                            on trunc(f.folder_date_create_mi, 'mi') =
                               tm.yyyy_mm_dd_hh_mi
                           and (f.cr_program_name ='ЭКСПРЕСС-КРЕДИТОВАНИЕ-ТОВАР'   or f.cr_program_name ='ЭКСПРЕСС-КРЕДИТЫ (УСЛУГИ)')  AND F.IS_CREDIT_ISSUED=1 and f.is_point_active=0
                           and f.x_dnp_region='АЛМАТЫ'
                     --     and f.x_dnp_name='АЛМАТЫ'
                          --   and  trunc(f.folder_date_create_mi) =to_date('20.01.2014','DD.MM.YYYY')
                         where /*to_number(to_char(tm.yyyy_mm_dd_hh_mi, 'hh24mi')) >= 845
                           and*/ f.folder_date_create_mi <= sysdate
                         group by  tm.text_yyyy_mm_dd_hh_10mi)  y) z
;
grant select on U1.V_RDBOARD_ONLINE_ALM_SALE_DAY2 to LOADDB;
grant select on U1.V_RDBOARD_ONLINE_ALM_SALE_DAY2 to LOADER;
grant select on U1.V_RDBOARD_ONLINE_ALM_SALE_DAY2 to LOAD_RDWH_PROD;


