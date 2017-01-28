create or replace force view u1.v_dwh_kolesa_kz as
select  /*+ noparallel */
        mn.kolesa_id as akk_id,
        mn.kolesa$change_date as akk$change_date,
/*        mn.akk$row_status,
        mn.akk$audit_id,
        mn.akk$hash,
        mn.akk$source,
        mn.akk$provider,
        mn.akk$source_pk,*/
/*        mn.akk_header,
        mn.akk_brend,
        mn.akk_model,
        mn.akk_drive,
        mn.akk_fuel,
        mn.akk_engine_volume,
        mn.akk_kpp_type,
        mn.akk_mileage,
        mn.akk_body_type,
        mn.akk_r_drive_flg,
        mn.akk_color,
        mn.akk_region,
        mn.akk_customs_flg,
        mn.akk_order_flg,
        mn.akk_state,
        mn.akk_accidents_flg,
        mn.akk_price,
        mn.akk_advert,
        mn.akk_number,*/
        mnp.phone1_clear,
        mnp.phone2_clear,
        mnp.phone3_clear,
        mnp.phone4_clear,
        mnp.phone5_clear,
        mnp.phone6_clear,
        mnp.phone7_clear,
        mnp.phone8_clear,
        mnp.phone9_clear,
        mnp.phone10_clear,
        mnp.phone11_clear,
        mnp.phone12_clear,
        mnp.phone13_clear,
        mnp.phone14_clear,
        mnp.phone15_clear,
/*        mn.akk_year_car,
        mn.akk_shop_name,
        mn.akk_quantity,*/
        mn.kolesa_updated_at akk_last_date

  from U1.M_DWH_KOLESA_KZ mn
  join U1.M_DWH_KOLESA_KZ_PRE mnp on mnp.akk_id = mn.kolesa_id;
grant select on U1.V_DWH_KOLESA_KZ to LOADDB;
grant select on U1.V_DWH_KOLESA_KZ to LOADER;


