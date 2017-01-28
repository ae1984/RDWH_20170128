﻿create or replace force view u1.v_mo_res_rfo_res_params as
select z.rfo_res_from_mo_id,
       z.c_res_mo_id_txt,
       trunc(z.res_date) as res_date,
       z.res_date as res_date_time,
       z.c_client_ref,
       z.c_folder_ref,
       z.c_type_process,
       z.par_code as res_par_code,
       z.par_value as res_par_value,
       z.par_value_to_cancel,
       case when par_value = par_value_to_cancel then 1 else 0 end is_to_cancel,
       z.c_result,
       z.c_use_ch_res_arr,
       z.c_res_mo_id
from (
select y.rfo_res_from_mo_id,
       y.c_res_mo_id_txt,
       y.res_date,
       y.c_client_ref,
       y.c_folder_ref,
       y.c_type_process,
       y.par_code,
--       nullif(substr(y.c_result,instr(y.c_result,y.par_code)+length(y.par_code)+1,1),']') as par_value,
       substr(y.c_result, instr(y.c_result,y.par_code)+length(y.par_code)+1,
                    instr(y.c_result,']',instr(y.c_result,y.par_code)) - (instr(y.c_result,y.par_code)+length(y.par_code)+1)
              ) as par_value,
       y.par_value_to_cancel,
       y.c_result,
       y.c_use_ch_res_arr,
       y.c_res_mo_id
from (
    select 'BL_REJECT' as par_code, '1' as par_value_to_cancel, x.*
    from V_MO_RES_RFO_KAS_RES_FROM_MO x where x.c_result like '%BL_REJECT%'
    union all
    select 'PKB_NEED' as par_code, '0' as par_value_to_cancel, x.*
    from V_MO_RES_RFO_KAS_RES_FROM_MO x where x.c_result like '%PKB_NEED%'
    union all
    select 'GCVP_NEED' as par_code, '0' as par_value_to_cancel, x.*
    from V_MO_RES_RFO_KAS_RES_FROM_MO x where x.c_result like '%GCVP_NEED%'
    union all
    select 'MON_NEED' as par_code, '0' as par_value_to_cancel, x.*
    from V_MO_RES_RFO_KAS_RES_FROM_MO x where x.c_result like '%MON_NEED%'
    union all
    select 'VER_PHONE_NEED' as par_code, '0' as par_value_to_cancel, x.*
    from V_MO_RES_RFO_KAS_RES_FROM_MO x where x.c_result like '%VER_PHONE_NEED%'
    union all
    select 'PHONE_COUNTER_NEED' as par_code, '0' as par_value_to_cancel, x.*
    from V_MO_RES_RFO_KAS_RES_FROM_MO x where x.c_result like '%PHONE_COUNTER_NEED%'
    union all
    select 'PH_CNT_REJECT' as par_code, '1' as par_value_to_cancel, x.*
    from V_MO_RES_RFO_KAS_RES_FROM_MO x where x.c_result like '%PH_CNT_REJECT%'
    union all
    select 'MO_SCO_REJECT' as par_code, '1' as par_value_to_cancel, x.*
    from V_MO_RES_RFO_KAS_RES_FROM_MO x where x.c_result like '%MO_SCO_REJECT%'
) y
) z
;
grant select on U1.V_MO_RES_RFO_RES_PARAMS to LOADDB;
grant select on U1.V_MO_RES_RFO_RES_PARAMS to LOADER;


