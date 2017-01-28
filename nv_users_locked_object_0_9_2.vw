create or replace force view u1.nv_users_locked_object_0_9_2 as
select distinct t.name as object_name
from NV_ETL_DEPENDENCIES t
join NV_USERS_LOCKED_OBJECT_0_9 a on a.object_name = t.referenced_name;
grant select on U1.NV_USERS_LOCKED_OBJECT_0_9_2 to LOADDB;


