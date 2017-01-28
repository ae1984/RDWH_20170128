create or replace force view u1.v_rfo_black_list_removed as
select /*+all_rows*/
  t.id as rfo_black_list_id,
  t.c_inn as iin,
  t.c_rnn as rnn,
  upper(t.c_last_name) as surname,
  upper(t.c_first_name) as first_name,
  upper(t.c_sur_name) as patronymic,
  t.c_date_birth as birth_date,
  t.c_date_delete as remove_date,
  upper(t.c_reason_delete) as remove_reason,
--  t.c_user_delete as user_delete,
  upper(ur.c_name) as remove_user_name,
  ur.c_num_tab as remove_user_num_tab,
  t.c_date_add as add_date,
  upper(ud.c_name) as add_reason,
  upper(t.c_note) as add_note,
  upper(u.c_name) as add_user_name_add,
  u.c_num_tab as add_user_num_tab,
  upper(ct.c_name) as pers_doc_type,
  t.c_passport#num as pers_doc_num,
--  t.c_passport#seria as personal_doc_series,
  upper(t.c_passport#who) as pers_doc_issuer,
  t.c_passport#date_doc as pers_doc_date_begin,
  t.c_passport#date_end as pers_doc_date_end,
  upper(t.c_passport#place) as pers_doc_issue_place,
  upper(t.c_address) as address,
  upper(t.c_place_birth) as place_of_birth,
--  t.c_passport#depart_code
  upper(ur.c_username) as remove_user_login,
  upper(u.c_username) as add_user_login,
  upper(sd.c_name) as dep_name,
  sd.c_code as dep_code,
  t.c_date_edit as date_edit
--  t.c_kas_rnn_replaced
from V_RFO_Z#KAS_BLACK_LIST_D t, v_rfo_z#certific_type ct,
     v_rfo_z#user u, v_rfo_z#struct_depart sd, v_rfo_z#kas_universal_d ud,
     v_rfo_z#user ur
where ct.id(+) = t.c_passport#type and u.id(+) = t.c_user_ref and
      sd.id(+) = u.c_st_depart and ud.id(+) = t.c_kas_reason and
      ur.id(+) = t.c_user_delete
order by t.c_date_add desc
;
grant select on U1.V_RFO_BLACK_LIST_REMOVED to LOADDB;
grant select on U1.V_RFO_BLACK_LIST_REMOVED to LOADER;


