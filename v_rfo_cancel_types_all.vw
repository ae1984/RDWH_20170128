create or replace force view u1.v_rfo_cancel_types_all as
select --+ noparallel
  t.c_type as cancel_type,
  upper(t.c_code) as cancel_code,
  upper(t.c_name) as cancel_name,
  t.c_err_level as cancel_error_level,
  r.c_group as term_group,
  r.c_priority as term_priority,
  r.c_bind as term_bind,
  r.c_check_obj as term_checked_object,
  r.c_type as term_type,
  r.c_term as term_term,
  upper(r.c_arg) as term_argument,
  a.c_num_pp as arg_value_number,
  a.c_value as arg_value_value,
  upper(bp.c_name) as arg_value_process_name,
  upper(w.c_name) as arg_value_way_name,
  upper(cs.c_name) as arg_value_cred_scheme_name,
  upper(ks.c_name) as arg_value_card_scheme_name,
  upper(sd.c_name) as arg_value_pos_name,
  upper(cp.c_name) as arg_value_cred_program_name
from V_RFO_Z#KAS_CANCEL_TYPES t
left join V_RFO_Z#KAS_TERM r on r.collection_id = t.c_term_arr
left join V_RFO_Z#KAS_TERM_TAV a on a.collection_id = r.c_arg_arr
left join V_RFO_Z#BUS_PROCESS bp on bp.id = a.c_bp_ref
left join V_RFO_Z#CM_WAY w on w.id = a.c_way_ref
left join V_RFO_Z#CRED_SCHEME cs on cs.id = a.c_cs_ref
left join V_RFO_Z#KAS_CARD_SCHEME ks on ks.id = a.c_ks_ref
left join V_RFO_Z#STRUCT_DEPART sd on sd.id = a.c_sd_ref
left join V_RFO_Z#PROD_PROPERTY cp on cp.id = a.c_cred_prog
order by t.c_type, t.c_name, r.c_group, r.c_priority, a.c_num_pp
;
grant select on U1.V_RFO_CANCEL_TYPES_ALL to LOADDB;
grant select on U1.V_RFO_CANCEL_TYPES_ALL to LOADER;


