create or replace force view u1.v_photo_client_all as
select
       ph1.client_id as rfo_client_id
      ,ph1.photo_luna_id as luna_id
      ,ph1.photo_type_id as photo_guid
      ,trunc(ph1.photo_date_create) as photo_date
      ,ph1.photo_date_create
from u1.T_MO_CLIENT_PHOTO ph1
where ph1.client_id is not null and ph1.photo_luna_id is not null and ph1.photo_type_id is not null
union all
select
     ph2.c_client_id as rfo_client_id
    ,ph2.c_bin_id  as luna_id
    ,ph2.c_uid  as photo_guid
    ,trunc(ph2.c_photo_date) as photo_date
    ,ph2.c_photo_date as photo_date_create
from u1.v_rfo_dev_z#photo4upload ph2
where ph2.c_client_id is not null and ph2.c_bin_id is not null and ph2.c_uid is not null
union all
select
     ph3.rfo_client_id
    ,ph3.luna_id
    ,ph3.photo_guid
    ,trunc(ph3.photo_date_create) as photo_date
    ,ph3.photo_date_create
from u1.T_LUNA_PHOTO_MANUALGEN ph3;
grant select on U1.V_PHOTO_CLIENT_ALL to LOADDB;
grant select on U1.V_PHOTO_CLIENT_ALL to RISK_ALEXEY;
grant select on U1.V_PHOTO_CLIENT_ALL to RISK_ALEXEY2;


