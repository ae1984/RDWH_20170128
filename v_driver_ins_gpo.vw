create or replace force view u1.v_driver_ins_gpo as
select t.collection_id as gpo_drivers_id,
t.id as driver_id, t.c_inn as iin, upper(t.c_last_name) as name_last,
upper(t.c_first_name) as name_first, upper(t.c_sur_name) as name_patronymic,
t.c_date_pers as birth_date, t.c_sex#0 as sex,
upper(t.c_place_birth) as birth_place, upper(ci.c_value) as marital_status,
upper(a.c_place) as address_place,
t.c_contacts as driver_contacts_id
--c.c_numb as contact_phone, upper(oc.c_value) as phone_type
from V_RFO_Z#CL_PRIV_REQ t
left join V_RFO_Z#ADRESSES a on a.collection_id = t.c_addresses
--left join V_RFO_Z#CONTACTS c on c.collection_id = t.c_contacts
--left join V_RFO_Z#OWNER_COM oc on oc.id = c.c_private
left join V_RFO_Z#CLIENT_INDEX ci on ci.id = t.c_kas_family
;
grant select on U1.V_DRIVER_INS_GPO to LOADDB;
grant select on U1.V_DRIVER_INS_GPO to LOADER;


