create or replace force view u1.nv_daily_update_log as
select /*id,task_id,*/ ins_dt,object_name, /*group_num, task_num, task_name,*/ sql_exec, task_start, task_end
   ,(task_end- task_start)*24*60*60 as interval_sec
   , t.err.getclobval() err, status/*, detail
   ,t.job_prefix
   ,t.update_log_id
   ,t.send_mail*/
from NT_TASKS_EXECUTE t
where
     t.ins_dt >=trunc(sysdate)
     and t.task_name like  'DAILY_%' and t.task_name<>'DAILY_LOAD'
order by  id desc;
grant select on U1.NV_DAILY_UPDATE_LOG to LOADDB;


