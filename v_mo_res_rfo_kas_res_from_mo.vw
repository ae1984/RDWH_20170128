create or replace force view u1.v_mo_res_rfo_kas_res_from_mo as
select r1.id as rfo_res_from_mo_id,
       r1.c_res_mo_id,
       to_char(r1.c_res_mo_id) as c_res_mo_id_txt,
       r1.c_date as res_date,
       r1.c_client_ref,
       r1.c_folder_ref,
       r1.c_result,
       r1.c_type_process,
       r1.c_use_ch_res_arr
from V_RFO_Z#KAS_RES_FROM_MO r1;
grant select on U1.V_MO_RES_RFO_KAS_RES_FROM_MO to LOADDB;
grant select on U1.V_MO_RES_RFO_KAS_RES_FROM_MO to LOADER;


