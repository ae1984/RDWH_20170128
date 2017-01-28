create or replace force view u1.v_mo_res_rfo_cancel_types as
select c.id, c.c_code, c.c_type, upper(c.c_name) as c_name,
       c.c_err_level,
/*       decode(c.c_code,
              'BL_REJECT','MO_EPO',
              'PKB_NEED','MO_EPO',
              'GCVP_NEED','MO_EPO',
              'VER_PHONE_NEED','MO_EPO',
              'PHONE_COUNTER_NEED','MO_EPO',
              'MON_NEED','MO_EPO',
              'BL_REJECT_ASOKR','ROUTE',
              'PH_CNT_REJECT_ASOKR','ROUTE') as process_code, */
       decode(c.c_code,
              'BL_REJECT','BL_REJECT',
              'PKB_NEED','PKB_NEED',
              'GCVP_NEED','GCVP_NEED',
              'VER_PHONE_NEED','VER_PHONE_NEED',
              'PHONE_COUNTER_NEED','PHONE_COUNTER_NEED',
              'MON_NEED','MON_NEED',
              'BL_REJECT_ASOKR','BL_REJECT',
              'PH_CNT_REJECT_ASOKR','PH_CNT_REJECT',
              'MO_SCO_REJECT','MO_SCO_REJECT',
              'MO_ROUTE_REJECT_ASOKR','MO_ROUTE_REJECT') as par_code,
       c.c_priority, c.c_term_arr
from V_RFO_Z#KAS_CANCEL_TYPES c
where c.c_code in (
        'BL_REJECT',
        'PKB_NEED',
        'GCVP_NEED',
        'VER_PHONE_NEED',
        'PHONE_COUNTER_NEED',
        'MON_NEED',
        'BL_REJECT_ASOKR',
        'PH_CNT_REJECT_ASOKR',
        'MO_SCO_REJECT',
        'MO_ROUTE_REJECT_ASOKR') --
order by c.c_code
;
grant select on U1.V_MO_RES_RFO_CANCEL_TYPES to LOADDB;
grant select on U1.V_MO_RES_RFO_CANCEL_TYPES to LOADER;


