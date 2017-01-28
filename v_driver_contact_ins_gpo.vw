create or replace force view u1.v_driver_contact_ins_gpo as
select c.id as contact_id,
c.collection_id as driver_contacts_id,
c.c_numb as contact_phone, upper(oc.c_value) as phone_type
from V_RFO_Z#CL_PRIV_REQ t
join V_RFO_Z#CONTACTS c on c.collection_id = t.c_contacts
left join V_RFO_Z#OWNER_COM oc on oc.id = c.c_private;
grant select on U1.V_DRIVER_CONTACT_INS_GPO to LOADDB;
grant select on U1.V_DRIVER_CONTACT_INS_GPO to LOADER;


