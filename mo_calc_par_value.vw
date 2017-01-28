create or replace force view u1.mo_calc_par_value as
select id,
        calc_id,
        d_calc_par_id,
        value_text,
        value_date,
        value_number,
        date_create,
        date_update,
        d_par_datatype_id,
        value_index,
        d_par_id,
        d_par_object_id,
        d_system_id
from T_MO_CALC_PAR_VALUE_2014
union all
select id,
        calc_id,
        d_calc_par_id,
        value_text,
        value_date,
        value_number,
        date_create,
        date_update,
        d_par_datatype_id,
        value_index,
        d_par_id,
        d_par_object_id,
        d_system_id
from T_MO_CALC_PAR_VALUE_2015
union all
select id,
        calc_id,
        d_calc_par_id,
        value_text,
        value_date,
        value_number,
        date_create,
        date_update,
        d_par_datatype_id,
        value_index,
        d_par_id,
        d_par_object_id,
        d_system_id
from T_MO_CALC_PAR_VALUE_2016;
grant select on U1.MO_CALC_PAR_VALUE to LOADDB;
grant select on U1.MO_CALC_PAR_VALUE to LOADER;


