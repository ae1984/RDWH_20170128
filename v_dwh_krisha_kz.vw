﻿create or replace force view u1.v_dwh_krisha_kz as
select /*+ noparallel */
        mn.krisha_id,
        mn.krisha$change_date,
        mn.krisha$row_status,
        mn.krisha$audit_id,
        mn.krisha$hash,
        mn.krisha$source,
        mn.krisha$provider,
        mn.krisha$source_pk,
        mn.krisha_type,
        mn.krisha_category,
        mn.krisha_href,
        mn.krisha_title,
        mn.krisha_rentperiod,
        mn.krisha_costkzt,
        mn.krisha_costusd,
        mn.krisha_costeur,
        mn.krisha_costrur,
        mn.krisha_costfor,
        mn.krisha_viewcount,
        mn.krisha_addate,
        mn.krisha_phones,
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
        mn.krisha_phones_clear,
        mn.krisha_location,
        mn.krisha_address,
        mn.krisha_adowner,
        mn.krisha_pawn,
        mn.krisha_roomcount,
        mn.krisha_structuretype,
        mn.krisha_yearbuilt,
        mn.krisha_floor,
        mn.krisha_floorcount,
        mn.krisha_levelnumber,
        mn.krisha_totalarea,
        mn.krisha_livingarea,
        mn.krisha_kitchenarea,
        mn.krisha_privatizedhostel,
        mn.krisha_productionarea,
        mn.krisha_warehousespace,
        mn.krisha_officespace,
        mn.krisha_landarea,
        mn.krisha_areatype,
        mn.krisha_plotcharact,
        mn.krisha_purposeof,
        mn.krisha_fence,
        mn.krisha_condition,
        mn.krisha_communications,
        mn.krisha_phone,
        mn.krisha_phonelines,
        mn.krisha_internet,
        mn.krisha_wc,
        mn.krisha_sewerage,
        mn.krisha_water,
        mn.krisha_irrigationwater,
        mn.krisha_drinkingwater,
        mn.krisha_heating,
        mn.krisha_electricity,
        mn.krisha_gas,
        mn.krisha_balcony,
        mn.krisha_door,
        mn.krisha_separateentrance,
        mn.krisha_parking,
        mn.krisha_furniture,
        mn.krisha_flooring,
        mn.krisha_clnghght,
        mn.krisha_clnghghtprod,
        mn.krisha_clnghghtwh,
        mn.krisha_roofing,
        mn.krisha_security,
        mn.krisha_locationname,
        mn.krisha_commercetype,
        mn.krisha_railwaysiding,
        mn.krisha_maxpower,
        mn.krisha_ownsubstation,
        mn.krisha_scope,
        mn.krisha_existingbusiness
  from U1.M_DWH_KRISHA_KZ mn
  join U1.M_DWH_KRISHA_KZ_PRE mnp on mnp.krisha_id = mn.krisha_id;
grant select on U1.V_DWH_KRISHA_KZ to LOADDB;
grant select on U1.V_DWH_KRISHA_KZ to LOADER;


