create or replace force view u1.v_tdwh_vin_info as
select
    v.e#vin$vin as vin,
    ma.code as mark,
    m.code as model,
    v.ar_model_year as model_year,
    oc.code as country,
    r.code as region,
    ac.code as assemblage_country,
    mf.code as factory,
    bt.code as body_type,
    ct.code as car_type,
    d.code as drive,
    v.d#ar#doors_count as doors_count,
    et.code as engine_type, ev.code as engine_volume,
    scp.code as steering_column_place,
    ft.code as fuel_type, ed.code as engine_description,
    kp.code as transmission,
    md.code as manufacture_date
from TDWH_E#VIN_INFO v
left join V_TDWH_D#AR#MARK ma on ma.id = v.d#ar#mark
left join V_TDWH_D#AR#MODEL m on m.id = v.d#ar#model
left join V_TDWH_D#AR#ORIGIN_COUNTRY oc on oc.id = v.d#ar#origin_country
left join v_tdwh_d#ar#manuf_factory mf on mf.id = v.d#ar#manufacture_factory
left join v_tdwh_d#ar#body_type bt on bt.id = v.d#ar#body_type
left join v_tdwh_d#ar#engine_type et on et.id = v.d#ar#engine_type
left join V_TDWH_D#AR#ENGINE_VOLUME ev on ev.id = v.d#ar#engine_volume
left join v_tdwh_d#ar#car_type ct on ct.id = v.d#ar#car_type
left join V_TDWH_D#AR#MANUFACTURE_DATE md on md.id = v.d#ar#manufacture_date
left join v_tdwh_d#ar#steering_col_place scp on scp.id = v.d#ar#steering_column_place
left join v_tdwh_d#ar#engine_description ed on ed.id = v.d#ar#engine_description
left join v_tdwh_d#ar#kpp_type kp on kp.id = v.d#ar#kpp_type
left join V_TDWH_D#AR#DRIVE d on d.id = v.d#ar#drive
left join v_tdwh_d#ar#region r on r.id = v.d#ar#region
left join v_tdwh_d#ar#assemblage_country ac on ac.id = v.d#ar#assemblage_country
left join v_tdwh_d#ar#fuel_type ft on ft.id = v.d#ar#fuel_type;
grant select on U1.V_TDWH_VIN_INFO to LOADDB;
grant select on U1.V_TDWH_VIN_INFO to LOADER;


