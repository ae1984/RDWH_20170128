create or replace force view u1.v_mo_sco_request_dict as
select t.id sco_request_id_orig,
       t.date_create,
       tt."ID",tt."SCO_REQUEST_ID",tt."CLASS_ID",tt."FIELD_CODE",tt."FIELD_NAME",tt."ID_RFO",tt."CODE",tt."NAME"
from u1.mo_sco_request t
join u1.mo_sco_request_dict tt on tt.sco_request_id = t.id
--where t.date_create >= to_date('01012015', 'ddmmyyyy')
;
grant select on U1.V_MO_SCO_REQUEST_DICT to LOADDB;
grant select on U1.V_MO_SCO_REQUEST_DICT to LOADER;


