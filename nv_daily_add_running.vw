create or replace force view u1.nv_daily_add_running as
select t.object_name, l.begin_refresh,l.end_refresh,l.status
from NT_RDWH_PROC_OBJECT_HIST t
left join update_log l on l.object_name=t.object_name and l.begin_refresh >=trunc(sysdate)
where t.sdt >=trunc(sysdate)-1 and t.type_load='DAILY' and t.is_used=1 and t.load_group='ADD'
order by l.end_refresh desc, l.status--t.object_name
;
grant select on U1.NV_DAILY_ADD_RUNNING to LOADDB;


