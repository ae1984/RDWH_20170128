create or replace force view u1.v_mo_res_rfo_cancel_types_term as
select c.id as cancel_id, c.c_code, c.c_type as cancel_type,
       c.c_name as cancel_name, c.c_priority, c.c_err_level,
       t.id as term_id, t.c_name as term_name, t.c_check_obj,
       t.c_type as term_type, t.c_term, t.c_arg, t.c_adds, t.c_arg_arr
from V_MO_RES_RFO_CANCEL_TYPES c
join V_RFO_Z#KAS_TERM t on t.collection_id = c.c_term_arr
order by c.c_code, t.c_check_obj;
grant select on U1.V_MO_RES_RFO_CANCEL_TYPES_TERM to LOADDB;
grant select on U1.V_MO_RES_RFO_CANCEL_TYPES_TERM to LOADER;


