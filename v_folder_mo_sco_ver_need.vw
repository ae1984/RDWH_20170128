create or replace force view u1.v_folder_mo_sco_ver_need as
select rfolder_id,
       date_create,
       folder_id,
       sc_ver_need
  from M_FOLDER_MO_SCO_VER_NEED_2015

union all
select rfolder_id,
       date_create,
       folder_id,
       sc_ver_need
  from M_FOLDER_MO_SCO_VER_NEED_2016;
grant select on U1.V_FOLDER_MO_SCO_VER_NEED to LOADDB;
grant select on U1.V_FOLDER_MO_SCO_VER_NEED to LOADER;


