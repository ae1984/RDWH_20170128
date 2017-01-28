create or replace procedure u1.NPRC_TASKS_MONITOR is
  v_sec number;
begin
 /* update NT_TASKS_EXECUTE
     set task_end= sysdate
         ,status = 'FAILED'
         ,detail = 'Job не был запущен из-за ошибки в job_action (NPRC_TASKS_MONITOR.1)'
  where id in
            (select t.id
            from  NT_TASKS_EXECUTE t
            join user_scheduler_job_log a on a.job_name = 'JOBRT_'||to_char(t.id)||'_'||substr(t.task_name,1,15) and trunc(a.log_date)=trunc(t.ins_dt)
            where a.status = 'FAILED' and trunc(t.ins_dt)=trunc(sysdate)-1 and t.status <> 'FAILED');
  commit;

  update NT_TASKS_EXECUTE
     set task_end= sysdate
         ,status = 'FAILED'
         ,detail = 'задача висела в статусе RUNNING, но Job отработал (NPRC_TASKS_MONITOR.1)'
  where id in
           (select t.id
            from NT_TASKS_EXECUTE t
            join user_scheduler_job_log a on a.job_name = 'JOBRT_'||to_char(t.id)||'_'||substr(t.task_name,1,15)
            left join USER_SCHEDULER_JOBS a on a.job_name = 'JOBRT_'||to_char(t.id)||'_'||substr(t.task_name,1,15) 
            where t.ins_dt >= sysdate-2 and t.STATUS = 'RUNNING' and a.job_name is null);
  commit;
  
  update NT_TASKS_EXECUTE
     set task_end= task_start
         ,status = 'STOPPED'
         ,detail = 'задача висела в статусе WAIT более суток (NPRC_TASKS_MONITOR.1)'
  where ins_dt < sysdate-1 and status = 'WAIT';
  commit;*/
  select (sysdate - max(ins_dt)) *24*60*60 into v_sec from NT_TASKS_EXECUTE t;
  if v_sec>=300 then
     dbms_scheduler.stop_job('NJOB_TASKS_CREATE',true);
  end if;   
  
  /*update NT_TASKS_EXECUTE 
     set task_end= sysdate 
         ,status = 'STOPPED'
         ,detail = 'Job не был запущен либо был принудительно остановлен. Причина неизвестна (PLAN m1)'
  where id in (
      select e.id from NT_TASKS_EXECUTE e
      left join SYS.ALL_SCHEDULER_RUNNING_JOBS j on j.job_name like '%'||to_char(e.id)||'%'
      where e.task_start between trunc(sysdate) and sysdate-(5/24/60) and e.status = 'RUNNING' and j.job_name is null
    );
  commit;  */ 
      
end NPRC_TASKS_MONITOR;
/

