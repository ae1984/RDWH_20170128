create or replace force view u1.v_client_images as
select t.id as rfo_client_id, t.x_iin as iin,
       cp.c_last_name as name_last, cp.c_first_name as name_first,
       cp.c_sur_name as name_patronymic, cp.c_pasport#num as personal_id_doc_num,
       i.c_date as photo_date,
       i.c_name as photo_name,
       i.c_uid
from V_RFO_Z#CLIENT t
join V_RFO_Z#CL_PRIV cp on cp.id = t.id
join V_RFO_Z#IMAGES i on i.collection_id = t.c_images;
grant select on U1.V_CLIENT_IMAGES to LOADDB;
grant select on U1.V_CLIENT_IMAGES to LOADER;


