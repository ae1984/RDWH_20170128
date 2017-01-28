create or replace force view u1.mo_process_par_value_tmp as
select id,
        process_id,
        d_process_par_id,
        d_par_datatype_id,
        value_text,
        value_number,
        value_date,
        date_create,
        date_update,
        d_par_id,
        d_par_object_id,
        d_system_id,
        value_index
from T_MO_PROCESS_PAR_VALUE_2014
union all
select id,
        process_id,
        d_process_par_id,
        d_par_datatype_id,
        value_text,
        value_number,
        value_date,
        date_create,
        date_update,
        d_par_id,
        d_par_object_id,
        d_system_id,
        value_index
from T_MO_PROCESS_PAR_VALUE_2015
union all
select id,
        process_id,
        d_process_par_id,
        d_par_datatype_id,
        value_text,
        value_number,
        value_date,
        date_create,
        date_update,
        d_par_id,
        d_par_object_id,
        d_system_id,
        value_index
from T_MO_PROCESS_PAR_VALUE_2016;
grant select on U1.MO_PROCESS_PAR_VALUE_TMP to LOADDB;
grant select on U1.MO_PROCESS_PAR_VALUE_TMP to LOADER;


