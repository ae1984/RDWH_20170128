create or replace procedure u1.NPRC_TASKS_EXECUTEID(p_task_id number) is
/*
    alexey.yevseyev
    20/10/2016
    PEPv1.1-engine  (Parallel execution of programs)
*/
   v_thread_num_max number;
   v_thread_num number;
   v_thread_num_min number;
   i number;
   v_process number;
   v_cpu number;
   --v_px number;
   --v_px_max number;
   v_group_num number;
   v_num_tmp number;
   v_num_tmp2 number;
   v_status varchar2(100);
   v_first_status varchar2(100);
   --v_start_dt date;
   v_jobprefix varchar2(100);
   v_temp_used_prc number;
   v_pga_used_prc number;
   v_px_used_prc number;
   v_cnt number;
begin
  --v_start_dt:= sysdate;
  v_jobprefix:='JOB'||to_char(p_task_id)||'RT';
  v_first_status:= 'NEW_'||to_char(p_task_id)||'_'||to_char(sysdate,'yyyymmddhh24miss');
  update NT_TASKS_EXECUTE t
     set t.status = v_first_status,t.job_prefix = v_jobprefix, t.update_log_id = u1.update_log_seq.nextval
  where t.task_id=p_task_id ;
  commit;

  insert into u1.update_log (id, object_name, begin_refresh, end_refresh, status)
  select  t.update_log_id,t.object_name,t.ins_dt,t.task_end,'PROCESSING'
  from NT_TASKS_EXECUTE t where t.task_id=p_task_id and t.object_name is not null ;
  commit;

  v_thread_num:= 30; --кол-во исполняемых потоков
  select
    (select value from V$PGASTAT where name = 'total PGA allocated')/
    (select value from V$PARAMETER where name =  'pga_aggregate_limit')*100
    into v_pga_used_prc
  from dual;
  v_temp_used_prc:=0;
  --select nvl(max(t.used_percent),0) into v_temp_used_prc from SYS.DBA_TABLESPACE_USAGE_METRICS t where t.tablespace_name = 'TEMP_8450';

  select
    (select value  from V$PX_PROCESS_SYSSTAT t where t.STATISTIC = 'Servers In Use                ')/
    (select value  from V$PARAMETER t where t.NAME = 'parallel_max_servers')*100
    into v_px_used_prc
  from dual;

  if v_px_used_prc >90 or v_temp_used_prc>80 or v_pga_used_prc>80 then
      v_thread_num:= 1; --кол-во исполняемых потоков
  end if;
  if  v_px_used_prc <90 and v_temp_used_prc<60 and v_pga_used_prc<60 then
      v_thread_num:= 3; --кол-во исполняемых потоков
  end if;
  if  v_px_used_prc <80 and v_temp_used_prc<50 and v_pga_used_prc<50  then
      v_thread_num:= 5; --кол-во исполняемых потоков
  end if;
  if  v_px_used_prc <70  and v_temp_used_prc<40 and v_pga_used_prc<40  then
      v_thread_num:= 10; --кол-во исполняемых потоков
  end if;
  if  v_px_used_prc <60 and  v_temp_used_prc<40 and v_pga_used_prc<40  then
      v_thread_num:= 10; --кол-во исполняемых потоков
  end if;


  v_thread_num_max:=100; --макс. кол-во исполняемых потоков
  v_thread_num_min:=3; --мин. кол-во исполняемых потоков
  i:=0; --счетчик запущенных потоков
  v_group_num:=-1; --группа в рамках которой возможно распараллеливание
  v_num_tmp:=0;
  for rec in (select
                t.id
                ,t.ins_dt
                ,t.group_num
                ,t.task_name
                ,
                'declare
                 v_sqlcode varchar2(32000);
                 v_sqlerrm varchar2(32000);
                 v_n_tmp number;
                 v_dt_tmp date;
                begin
                  '||t.sql_exec||'
                  update NT_TASKS_EXECUTE
                     set task_end= sysdate,err = null,status = ''COMPLETED''
                  where id = '||to_char(t.id)||';
                  commit;
                  update update_log
                      set end_refresh=sysdate, status=''OK''
                  where id = '||to_char(t.update_log_id)||';
                  commit;
                exception
                  when others then
                    rollback;
                    v_sqlcode:=sqlcode;
                    v_sqlerrm:=sqlerrm;
                    update NT_TASKS_EXECUTE
                       set task_end= sysdate
                          ,err=NFNC_FILL_INFO_ERR(v_sqlcode,v_sqlerrm,Dbms_Utility.format_error_stack,Dbms_Utility.format_call_stack,Dbms_Utility.format_error_backtrace)
                          ,status = ''FAILED''
                    where id = '||to_char(t.id)||';
                    commit;
                    update update_log
                        set end_refresh=sysdate, status=''ERROR''
                    where id = '||to_char(t.update_log_id)||';
                    commit;
                end;' as sql_exec
              from NT_TASKS_EXECUTE t
              where t.task_id = p_task_id
              order by t.group_num,t.task_num
             ) loop --задачник
      if v_group_num<>rec.group_num  then --если изменился номер группы в рамках задачи
         update NT_TASKS_EXECUTE
            set task_end= sysdate
                ,status = 'FAILED'
                ,detail = 'Job не был запущен из-за ошибки в job_action (1)'
         where id in
                   (select t.id
                   from  NT_TASKS_EXECUTE t
                   join user_scheduler_job_log a on a.job_name = v_jobprefix||to_char(t.id)||'_'||substr(t.task_name,1,10) and trunc(a.log_date)=trunc(t.ins_dt)
                   where a.status = 'FAILED' and t.status<>'FAILED' );
         commit;
         update NT_TASKS_EXECUTE
            set task_end= sysdate
                ,status = 'STOPPED'
                ,detail = 'Job был принудительно остановлен(1)'
         where id in
                   (select t.id
                   from  NT_TASKS_EXECUTE t
                   join user_scheduler_job_log a on a.job_name = v_jobprefix||to_char(t.id)||'_'||substr(t.task_name,1,10) and trunc(a.log_date)=trunc(t.ins_dt)
                   where a.status = 'STOPPED' and t.status<>'STOPPED');
         commit;
         update update_log
             set end_refresh=sysdate, status='ERROR'
         where id in
                   (select t.update_log_id
                   from  NT_TASKS_EXECUTE t
                   join user_scheduler_job_log a on a.job_name = v_jobprefix||to_char(t.id)||'_'||substr(t.task_name,1,10) and trunc(a.log_date)=trunc(t.ins_dt)
                   where a.status = 'FAILED' and t.status<>'FAILED' and t.object_name is not null );
         commit;
         update update_log
             set end_refresh=sysdate, status='STOPPED'
         where id in
                   (select t.update_log_id
                   from  NT_TASKS_EXECUTE t
                   join user_scheduler_job_log a on a.job_name = v_jobprefix||to_char(t.id)||'_'||substr(t.task_name,1,10) and trunc(a.log_date)=trunc(t.ins_dt)
                   where a.status = 'STOPPED' and t.status<>'STOPPED' and t.object_name is not null);
         commit;
         loop
           dbms_lock.sleep(5);
           select count(*) into v_num_tmp from USER_SCHEDULER_JOBS /*ALL_SCHEDULER_RUNNING_JOBS*/ where job_name like v_jobprefix||'%';
           select count(*) into v_num_tmp2 from ALL_SCHEDULER_RUNNING_JOBS where job_name like v_jobprefix||'%';
           /*if v_num_tmp+v_num_tmp2>0  --закончилось исполнение текущей группы?
              then dbms_lock.sleep(2); --нет, ждем 3сек
           end if;*/
           exit when v_num_tmp+v_num_tmp2<=0; --выход из цикла, продолжаем исполнение следующей группы
         end loop;

         v_num_tmp:=0;
         --проверяем всё ли отработало корректно в группе
         select count(*) into v_num_tmp from NT_TASKS_EXECUTE
         where ins_dt = rec.ins_dt
               and task_id = p_task_id
               and task_name=rec.task_name
               and group_num = v_group_num
               and status in ('FAILED','STOPPED','WAIT');
         if v_num_tmp > 0 then --если нет, то останавливаем следующие группы
            update NT_TASKS_EXECUTE
               set status = 'FAILED'--'WAIT'
                   ,detail = 'группа задач group_num = '||to_char(v_group_num)||' отработала с ошибкой (1)'
            where ins_dt = rec.ins_dt and group_num > v_group_num and task_id = p_task_id and detail is null and status <> 'COMPLETED' ;
            commit;
         end if;
      end if;
      v_group_num:=rec.group_num; --изменяем номер группы

      select status into v_status from NT_TASKS_EXECUTE where id = rec.id; --это действие необходимо, т.к. в процессе исполнения могут измениться статусы у новых задач
      if v_status = /*'NEW'*/ v_first_status then
          i:=i+1; --счетчик потоков plsql
          update NT_TASKS_EXECUTE
             set task_start= sysdate
                 ,status = 'RUNNING'
          where id = rec.id; --время начала исполнения задачи
          commit;
          DBMS_SCHEDULER.CREATE_JOB( --запуск новой, независимой сессии plsql
                job_name   => v_jobprefix||to_char(rec.id)||'_'||substr(rec.task_name,1,10), --уникальное имя сессии, JOBRT (job runtime)-признак что сессия/job временный и самоликвидируется
                job_type   => 'PLSQL_BLOCK',
                job_action => rec.sql_exec,--исполняемый код сессии
                enabled    => TRUE
          );
          if i>=v_thread_num then --если запущеные потоки достигли допустимого максимума
            loop
              dbms_lock.sleep(4); --ожидаем 5 секунд
              select max(t.value) into v_process from V$SYSMETRIC t where t.METRIC_NAME = 'Process Limit %';
              select value into v_cpu from V$SYSMETRIC t where t.METRIC_NAME = 'Host CPU Utilization (%)' and t.INTSIZE_CSEC < 2000; -- загруженность ЦПУ
              --select value into v_px from V$PX_PROCESS_SYSSTAT t where t.STATISTIC = 'Servers In Use                '; --загруженность параллельных сессий (пробелы не убираем!!!)
              --select nvl(max(t.used_percent),0) into v_temp_used_prc from SYS.DBA_TABLESPACE_USAGE_METRICS t where t.tablespace_name = 'TEMP_8450';
              select
                (select value  from V$PX_PROCESS_SYSSTAT t where t.STATISTIC = 'Servers In Use                ')/
                (select value  from V$PARAMETER t where t.NAME = 'parallel_max_servers')*100
                into v_px_used_prc
              from dual;
              if v_temp_used_prc<80 and v_cpu < 90 and v_px_used_prc<80 and v_process<80 --если загруженность ЦПУ <80% и загруженность потоков <864-200
                then if v_thread_num_max<=v_thread_num then v_thread_num:=v_thread_num+2; end if; --тогда кол-во исполяемых потоков увеличиваем на 2
                else if v_thread_num>v_thread_num_min then v_thread_num:=v_thread_num-2; else v_thread_num:=v_thread_num_min; end if; --число исп. потоков не может быть менее 10
              end if;
              select count(*) into i from USER_SCHEDULER_JOBS where job_name like v_jobprefix||'%'; --проверяем число активных сессий(JOB_RT) на текущий момент и изменяем счетчик потоков
              --select count(*) into i from ALL_SCHEDULER_RUNNING_JOBS where job_name like 'JOBRT%'; --проверяем число активных сессий(JOB_RT) на текущий момент и изменяем счетчик потоков
              exit when i<v_thread_num; --если число активных сессий меньше максимально допустимого, то разрешаем создание новых сессий
            end loop;
          end if;
      end if;
  end loop;
  --ждем завершения работы всех созданных джобов
  loop
    dbms_lock.sleep(3); --ожидаем 5 секунд
    select count(*) into i from USER_SCHEDULER_JOBS where job_name like v_jobprefix||'%'; --проверяем число активных сессий(JOB_RT) на текущий момент и изменяем счетчик потоков
    exit when i<=0;
  end loop;
  dbms_lock.sleep(5);

  update NT_TASKS_EXECUTE
     set task_end= sysdate
         ,status = 'FAILED'
         ,detail = 'Job не был запущен из-за ошибки в job_action (2)'
  where id in
            (select t.id
            from  NT_TASKS_EXECUTE t
            join user_scheduler_job_log a on a.job_name = v_jobprefix||to_char(t.id)||'_'||substr(t.task_name,1,10) and trunc(a.log_date)=trunc(t.ins_dt)
            where a.status = 'FAILED' and trunc(t.ins_dt)=trunc(sysdate) and t.status<>'FAILED' )
        and status<>'COMPLETED';
  commit;
  update NT_TASKS_EXECUTE
     set task_end= sysdate
         ,status = 'STOPPED'
         ,detail = 'Job был принудительно остановлен(2)'
  where id in
            (select t.id
            from  NT_TASKS_EXECUTE t
            join user_scheduler_job_log a on a.job_name = v_jobprefix||to_char(t.id)||'_'||substr(t.task_name,1,10) and trunc(a.log_date)=trunc(t.ins_dt)
            where a.status = 'STOPPED' and trunc(t.ins_dt)=trunc(sysdate) and t.status<>'STOPPED')
        and status<>'COMPLETED';
  commit;

  update update_log
      set end_refresh=sysdate, status='ERROR'
  where id in
            (select t.update_log_id
            from  NT_TASKS_EXECUTE t
            join user_scheduler_job_log a on a.job_name = v_jobprefix||to_char(t.id)||'_'||substr(t.task_name,1,10) and trunc(a.log_date)=trunc(t.ins_dt)
            where a.status = 'FAILED' and trunc(t.ins_dt)=trunc(sysdate) and t.status<>'FAILED' )
        and status<>'OK'    ;
  commit;
  update update_log
      set end_refresh=sysdate, status='STOPPED'
  where id in
            (select t.update_log_id
            from  NT_TASKS_EXECUTE t
            join user_scheduler_job_log a on a.job_name = v_jobprefix||to_char(t.id)||'_'||substr(t.task_name,1,10) and trunc(a.log_date)=trunc(t.ins_dt)
            where a.status = 'STOPPED' and trunc(t.ins_dt)=trunc(sysdate) and t.status<>'STOPPED' )
        and status<>'OK';
  commit;

  /*delete from u1.update_log
  where id in (select update_log_id from NT_TASKS_EXECUTE t where t.task_start>=trunc(v_start_dt)\*-60/24/60*\ and t.object_name is not null);
  insert into u1.update_log (id, object_name, begin_refresh, end_refresh, status)
  select
    t.update_log_id
    ,t.object_name
    ,t.task_start
    ,t.task_end
    ,case when t.status = 'RUNNING' then 'PROCESSING'
          when t.status like 'NEW%' then 'PROCESSING'
          when t.status = 'STOPPED' then 'STOPPED'
          when t.status = 'COMPLETED' then 'OK'
          else 'ERROR'
     end
  from NT_TASKS_EXECUTE t
  where t.task_start>=trunc(v_start_dt)\*-60/24/60*\ and t.object_name is not null;
  commit;  */
/*
OK
PROCESSING
STOPPED
ERROR
*/

end NPRC_TASKS_EXECUTEID;
/

