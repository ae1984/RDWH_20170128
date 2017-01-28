create or replace procedure u1.ETL_DAILY_UPDATE_STOP_FROZE is
begin
   for rec in (
      select 
         t.job_name,t.elapsed_time,(sysdate-e.task_start)*24*60*60 as elapsed_time_sec,e.ins_dt,e.task_start,e.task_end,e.sql_exec 
         ,e.object_name
         ,e.id
         ,l.interval_sec_limit
      from SYS.ALL_SCHEDULER_RUNNING_JOBS t
      join NT_TASKS_EXECUTE e on e.ins_dt>=trunc(sysdate) and t.job_name like '%'||to_char(e.id)||'%'
          --and e.task_name like 'ETL_ONLINE%'
          and t.job_name like '%DAILY%'
          and (sysdate-e.task_start)*24*60*60 >  7200
      join NV_OBJECT_UPDATE_LIMIT_TIME l on l.object_name = e.object_name 
      where l.interval_sec_limit < (sysdate-e.task_start)*24*60*60
   ) loop
        dbms_scheduler.stop_job(rec.job_name,true);
        update NT_TASKS_EXECUTE
           set status = 'STOPPED'
               ,detail = 'Превышен лимит времени на исполнение. Лимит: '||to_char(rec.interval_sec_limit)||'сек.'
               ,task_end = sysdate
        where id =rec.id;
        commit;
         --dbms_output.put_line(rec.job_name);
   end loop;  
end ETL_DAILY_UPDATE_STOP_FROZE;
/

