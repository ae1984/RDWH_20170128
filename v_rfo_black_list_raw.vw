create or replace force view u1.v_rfo_black_list_raw as
select
  id,
  c_passport#type,
  c_passport#num,
  c_passport#seria,
  c_passport#who,
--  c_passport#date_doc,
  to_char(c_passport#date_doc,'dd.mm.yyyy') as c_passport#date_doc,
  c_passport#place,
--  c_passport#date_end,
  to_char(c_passport#date_end,'dd.mm.yyyy') as c_passport#date_end,
  c_note,
  c_inn,
--  c_date_birth,
  to_char(c_date_birth,'dd.mm.yyyy') as c_date_birth,
  c_last_name,
  c_first_name,
  c_sur_name,
  c_address,
  c_place_birth,
  c_passport#depart_code,
--  trunc(c_date_add,'mm') as c_date_add,
  to_char(trunc(c_date_add,'mm'),'dd.mm.yyyy') as c_date_add,
--  trunc(c_date_edit,'mm') as c_date_edit,
  to_char(trunc(c_date_edit,'mm'),'dd.mm.yyyy') as c_date_edit,
  c_user_ref,
  c_kas_reason,
  c_kas_rnn,
  c_kas_rnn_replaced,
  x_iin,
  x_rnn
from V_RFO_Z#BLACK_LIST_CL t
;
grant select on U1.V_RFO_BLACK_LIST_RAW to LOADDB;
grant select on U1.V_RFO_BLACK_LIST_RAW to LOADER;


