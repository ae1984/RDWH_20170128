create or replace force view u1.nv_new_rdwh_proc_objects as
select t.object_name, count(*) as cnt
from (
  select trunc(t.sdt), t.object_name
  from NT_RDWH_PROC_OBJECT_HIST t
  where t.type_load in ('DAILY','ONLINE') and t.is_used=1
  group by trunc(t.sdt), t.object_name
) t
group by t.object_name
having count(*)<7;
grant select on U1.NV_NEW_RDWH_PROC_OBJECTS to LOADDB;


