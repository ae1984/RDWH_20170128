create or replace force view u1.mo_rfolder_par_value as
select id,
        rfolder_id,
        d_par_id,
        value_text,
        value_date,
        value_number,
        date_create,
        date_update,
        d_par_datatype_id,
        calc_par_value_last_id,
        value_index,
        d_par_object_id,
        d_system_id,
        null as value_index2
from  T_MO_RFOLDER_PAR_VALUE_2014
union all
select id,
        rfolder_id,
        d_par_id,
        value_text,
        value_date,
        value_number,
        date_create,
        date_update,
        d_par_datatype_id,
        calc_par_value_last_id,
        value_index,
        d_par_object_id,
        d_system_id,
        value_index2
from  T_MO_RFOLDER_PAR_VALUE_2015
union all
select id,
        rfolder_id,
        d_par_id,
        value_text,
        value_date,
        value_number,
        date_create,
        date_update,
        d_par_datatype_id,
        calc_par_value_last_id,
        value_index,
        d_par_object_id,
        d_system_id,
        value_index2
from  T_MO_RFOLDER_PAR_VALUE_2016;
grant select on U1.MO_RFOLDER_PAR_VALUE to LOADDB;
grant select on U1.MO_RFOLDER_PAR_VALUE to LOADER;


