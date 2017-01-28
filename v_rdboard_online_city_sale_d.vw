create or replace force view u1.v_rdboard_online_city_sale_d as
select text_yyyy_mm_dd_hh, fld_cnt_avg, x_dnp_name
  from (select y.text_yyyy_mm_dd_hh, y.fld_cnt_avg, y.x_dnp_name
          from (select /*tm.yyyy_mm_dd,*/
                 tm.text_yyyy_mm_dd_hh,
                 count(f.rfo_contract_id) as fld_cnt_avg,
                 f.x_dnp_name
                  from V_TIME_MINUTES tm
                  left join m_rfo_online_fld_ekt_day f
                    on trunc(f.folder_date_create_mi, 'mi') =
                       tm.yyyy_mm_dd_hh_mi
                   and (f.cr_program_name = 'ЭКСПРЕСС-КРЕДИТОВАНИЕ-ТОВАР' or
                        f.cr_program_name = 'ЭКСПРЕСС-КРЕДИТЫ (УСЛУГИ)') /*AND F.IS_CREDIT_ISSUED=1*/
                --     and f.x_dnp_name='АЛМАТЫ'
                --   and  trunc(f.folder_date_create_mi) =to_date('20.01.2014','DD.MM.YYYY')
                 where /*to_number(to_char(tm.yyyy_mm_dd_hh_mi, 'hh24mi')) >= 845
                                           and*/
                 f.folder_date_create_mi <= sysdate and f.x_dnp_name is not null
                 group by tm.text_yyyy_mm_dd_hh, f.x_dnp_name) y) z
;
grant select on U1.V_RDBOARD_ONLINE_CITY_SALE_D to LOADDB;
grant select on U1.V_RDBOARD_ONLINE_CITY_SALE_D to LOADER;
grant select on U1.V_RDBOARD_ONLINE_CITY_SALE_D to LOAD_RDWH_PROD;


