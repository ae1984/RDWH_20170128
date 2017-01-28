create or replace force view u1.nv_etl_daily_objects_notused as
select t."OBJECT_NAME"
from (select distinct object_name from T_RDWH_PROC_OBJECT where type_load in ('DAILY','ONLINE') and is_used=1) t
left join NV_ETL_DAILY_OBJECTS_USED2 a on a.object_name=t.object_name
where a.object_name is null;
grant select on U1.NV_ETL_DAILY_OBJECTS_NOTUSED to LOADDB;


