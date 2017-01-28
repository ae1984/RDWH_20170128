create or replace force view u1.v_folder_mo_gcvp as
select rfolder_id,
        date_create,
        folder_id,
        sco_rfo_client_id,
        sco_gcvp_salary,
        sco_gcvp_pmt_cnt
from M_FOLDER_MO_GCVP_2013
union all
select rfolder_id,
        date_create,
        folder_id,
        sco_rfo_client_id,
        sco_gcvp_salary,
        sco_gcvp_pmt_cnt
from M_FOLDER_MO_GCVP_2014
union all
select rfolder_id,
        date_create,
        folder_id,
        sco_rfo_client_id,
        sco_gcvp_salary,
        sco_gcvp_pmt_cnt
from M_FOLDER_MO_GCVP_2015
union all
select rfolder_id,
        date_create,
        folder_id,
        sco_rfo_client_id,
        sco_gcvp_salary,
        sco_gcvp_pmt_cnt
from M_FOLDER_MO_GCVP_2016;
grant select on U1.V_FOLDER_MO_GCVP to LOADDB;
grant select on U1.V_FOLDER_MO_GCVP to LOADER;


