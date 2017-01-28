create or replace force view u1.v_folder_mo_term_cred as
select t.rfolder_id,
       t.date_create,
       t.folder_id,
       t.sc_term_cred
from M_FOLDER_MO_TERM_CRED_2013 t

union all
select t.rfolder_id,
       t.date_create,
       t.folder_id,
       t.sc_term_cred
from M_FOLDER_MO_TERM_CRED_2014 t

union all
select t.rfolder_id,
       t.date_create,
       t.folder_id,
       t.sc_term_cred
from M_FOLDER_MO_TERM_CRED_2015 t

union all
select t.rfolder_id,
       t.date_create,
       t.folder_id,
       t.sc_term_cred
from M_FOLDER_MO_TERM_CRED_2016 t;
grant select on U1.V_FOLDER_MO_TERM_CRED to LOADDB;
grant select on U1.V_FOLDER_MO_TERM_CRED to LOADER;


