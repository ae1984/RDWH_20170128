create or replace force view u1.v_rdboard_online_pos_sale_d2 as
select text_hh, fld_cnt_avg, x_dnp_name,pos_name,fld_cnt_sum,dep_code
  from (select y.text_hh, y.fld_cnt_avg, sum(round(y.fld_cnt_avg)) over (partition by x_dnp_name, pos_name order by  y.text_hh rows 14 preceding) fld_cnt_sum,
   y.x_dnp_name,y.pos_name,y.dep_code
          from (select /*tm.yyyy_mm_dd,*/
                 tm.text_hh,
                -- tm.text_yyyy_mm_dd_hh,
                 count(f.rfo_contract_id) as fld_cnt_avg,

                 f.x_dnp_name,
                 f.dep_name as pos_name,
                 f.dep_code
                  from V_TIME_MINUTES tm
                  left join m_rfo_online_fld_ekt_day f
                    on trunc(f.folder_date_create_mi, 'mi') =
                       tm.yyyy_mm_dd_hh_mi
                   and (f.cr_program_name = 'ЭКСПРЕСС-КРЕДИТОВАНИЕ-ТОВАР' or
                        f.cr_program_name = 'ЭКСПРЕСС-КРЕДИТЫ (УСЛУГИ)')  AND F.IS_CREDIT_ISSUED=1 and f.is_point_active=0
                           and f.dep_name not like '%ИП%'
                           and f.dep_name not like '%ЧП%'
                           and f.dep_name not like  '%ГОЛОВНОЙ ОФИС%'
                --     and f.x_dnp_name='АЛМАТЫ'
                --   and  trunc(f.folder_date_create_mi) =to_date('20.01.2014','DD.MM.YYYY')
                 where /*to_number(to_char(tm.yyyy_mm_dd_hh_mi, 'hh24mi')) >= 845
                                           and*/
                 f.folder_date_create_mi <= sysdate and f.x_dnp_name is not null
                 group by tm.text_hh, f.x_dnp_name,f.dep_name,f.dep_code) y) z
;
grant select on U1.V_RDBOARD_ONLINE_POS_SALE_D2 to LOADDB;
grant select on U1.V_RDBOARD_ONLINE_POS_SALE_D2 to LOADER;
grant select on U1.V_RDBOARD_ONLINE_POS_SALE_D2 to LOAD_RDWH_PROD;


