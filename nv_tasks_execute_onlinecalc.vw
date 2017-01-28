create or replace force view u1.nv_tasks_execute_onlinecalc as
select id,task_id, ins_dt, group_num, task_num, task_name, sql_exec, task_start, task_end
   ,(task_end- task_start)*24*60*60 as interval_sec
   , t.err.getclobval() err, status, detail,object_name
   ,t.job_prefix
   ,t.update_log_id
   ,t.send_mail
from NT_TASKS_EXECUTE t
where
     t.ins_dt >=trunc(sysdate)
      and t.task_name like 'ETL_ONLINE%1'
order by
       id desc;

