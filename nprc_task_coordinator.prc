create or replace procedure u1.NPRC_TASK_COORDINATOR is
  v_task_id number;
  --v_temp_space number;
  --v_px number;
  --v_px_max number; 
  --v_cpu number; 
begin
   for rec in (
      select 
         t.task_name
      from NT_TASKS_EXECUTE t 
      where t.ins_dt>=trunc(sysdate) and t.status='NEW' and t.task_id is null
      group by t.task_name
   ) loop
      v_task_id:=N_TASKS_EXECUTE_TASKID_SEQ.nextval;
      update NT_TASKS_EXECUTE
         set task_id = v_task_id
      where ins_dt>=trunc(sysdate) and status='NEW' and task_name=rec.task_name;
      commit;
      DBMS_SCHEDULER.CREATE_JOB( --запуск новой, независимой сессии plsql
            job_name   => 'NJPEP'||to_char(v_task_id)||'_'||substr(rec.task_name,1,15), --уникальное имя сессии
            job_type   => 'PLSQL_BLOCK',
            job_action => 'begin  NPRC_TASKS_EXECUTEID2('||to_char(v_task_id)||'); end;',--исполняемый код сессии
            enabled    => TRUE
      );      
   end loop;
end NPRC_TASK_COORDINATOR;
/

