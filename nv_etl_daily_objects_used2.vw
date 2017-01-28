create or replace force view u1.nv_etl_daily_objects_used2 as
select distinct t.object_name  from NV_ETL_DAILY_OBJECTS_USED t
union
select distinct t.object_name from NT_OBJECT_NAME_USED t
join (select distinct object_name from T_RDWH_PROC_OBJECT where type_load in ('DAILY','ONLINE') and is_used=1) r on r.object_name=t.object_name
where t.sdt >=trunc(sysdate)-1;
grant select on U1.NV_ETL_DAILY_OBJECTS_USED2 to LOADDB;


