create or replace force view u1.nv_tasks_execute_error_now as
select id,task_id, ins_dt, group_num, task_num, task_name, sql_exec, task_start, task_end
   ,(task_end- task_start)*24*60*60 as interval_sec
   , t.err.getclobval() err, status, detail,object_name
   ,t.job_prefix
   ,t.update_log_id
   ,t.send_mail
   --,rowid
from NT_TASKS_EXECUTE t
where --t.status in ('FAILED','WAIT') and t.ins_dt >= sysdate -60/60/24 and t.task_num<999
     t.ins_dt >=trunc(sysdate)--between  trunc(sysdate)-10 and trunc(sysdate)-7
     --and t.task_name like 'DAILY%'
     and t.status in ('FAILED','STOPPED')
order by
       id desc


/*select distinct object_name
from NT_TASKS_EXECUTE t
where --t.status in ('FAILED','WAIT') and t.ins_dt >= sysdate -60/60/24 and t.task_num<999
     t.ins_dt >=trunc(sysdate)

     and t.status in ('FAILED','STOPPED')
*/
;
grant select on U1.NV_TASKS_EXECUTE_ERROR_NOW to MON_AOLEG;


