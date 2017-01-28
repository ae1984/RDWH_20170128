create or replace force view u1.v_rdboard_online_all_sale_hour as
select text_hh_mi, fld_cnt, x_dnp_region
  from (select y.text_hh_mi, y.fld_cnt, y.x_dnp_region
          from (select
                 tm.text_hh_mi,
                 count(f.rfo_contract_id) as fld_cnt,
                 f.x_dnp_region
                  from U1.V_TIME_MINUTES tm
                  left join U1.m_rfo_online_fld_ekt
                f
                    on trunc(f.folder_date_create_mi, 'mi') =
                       tm.yyyy_mm_dd_hh_mi
                   and (f.cr_program_name = 'ЭКСПРЕСС-КРЕДИТОВАНИЕ-ТОВАР' or
                        f.cr_program_name = 'ЭКСПРЕСС-КРЕДИТЫ (УСЛУГИ)')
                        where
                 f.folder_date_create_mi <= sysdate
                 group by tm.text_hh_mi, f.x_dnp_region) y) z;
grant select on U1.V_RDBOARD_ONLINE_ALL_SALE_HOUR to LOADDB;
grant select on U1.V_RDBOARD_ONLINE_ALL_SALE_HOUR to LOADER;
grant select on U1.V_RDBOARD_ONLINE_ALL_SALE_HOUR to LOAD_RDWH_PROD;


