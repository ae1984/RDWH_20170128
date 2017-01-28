create or replace force view u1.v_rfo_credit_programs as
select pp.id as prop_id,
       upper(pp.c_name) as cred_program_name,
       pp.c_code as cred_program_code,
       pg.c_code as prop_group_code,
       upper(pg.c_name) as prop_group_name,
       pp.c_is_used as is_used,
       pp.c_date_audit as date_audit
from V_RFO_Z#PROD_PROPERTY pp
join V_RFO_Z#PROPERTY_GRP pg on pg.id = pp.c_group_prop and pg.c_code = 'KAS_CRED_PROGRAM';
grant select on U1.V_RFO_CREDIT_PROGRAMS to LOADDB;
grant select on U1.V_RFO_CREDIT_PROGRAMS to LOADER;


