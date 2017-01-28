create or replace force view u1.v_phone_counter_cancel_all as
select
  fld.id as folder_id,
  cl.id as rfo_client_id,
  cl.x_iin as client_iin,
  cl.x_rnn as client_rnn,
  c.c_date as cancel_date,
  ct.c_type as cancel_type_type,
  ct.c_code as cancel_type_code,
  upper(ct.c_name) as cancel_type_name,
--  upper(c.c_note) as cancel_notes,
  f.total_prior_pmts,
  f.max_prior_delinq_days
from
  V_RFO_Z#KAS_CANCEL c,
  V_RFO_Z#KAS_CANCEL_TYPES ct,
  V_RFO_Z#CLIENT cl,
  V_RFO_Z#FOLDERS fld,
  V_FOLDER f
where
  ct.id = c.c_type and
  cl.id = c.c_client and
  fld.id = c.c_folders and
  ct.c_code = 'VERIFICATION_RATING' and
  c.c_date > to_date('2011-04-12','yyyy-mm-dd') and
  f.folder_id(+) = fld.id
;
grant select on U1.V_PHONE_COUNTER_CANCEL_ALL to LOADDB;
grant select on U1.V_PHONE_COUNTER_CANCEL_ALL to LOADER;


