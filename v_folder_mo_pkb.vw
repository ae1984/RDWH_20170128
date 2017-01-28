create or replace force view u1.v_folder_mo_pkb as
select rfolder_id,
       date_create,
       folder_id,
       sco_pkb_status,
       sco_kaspi_pkb_status,
       pkb_status
  from M_FOLDER_MO_PKB_2015

union all
select rfolder_id,
       date_create,
       folder_id,
       sco_pkb_status,
       sco_kaspi_pkb_status,
       pkb_status
  from M_FOLDER_MO_PKB_2016;
grant select on U1.V_FOLDER_MO_PKB to LOADDB;
grant select on U1.V_FOLDER_MO_PKB to LOADER;


