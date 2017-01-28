create or replace force view u1.nv_object_update_limit_time as
select tt.object_name
    , min(interval_sec) as interval_sec_min
    , max(interval_sec) as interval_sec_max
    ,round((max(interval_sec)+120)*5.1) as interval_sec_limit
from (
  select ins_dt
     ,(task_end- task_start)*24*60*60 as interval_sec
     ,object_name
  from NT_TASKS_EXECUTE_HIST t
  where
       t.ins_dt >=trunc(sysdate)-14--100
       and t.object_name is not null
       and t.task_name like 'DAILY_%'
       and t.status = 'COMPLETED'
) tt
group by tt.object_name
;
grant select on U1.NV_OBJECT_UPDATE_LIMIT_TIME to LOADDB;


