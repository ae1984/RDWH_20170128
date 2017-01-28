create or replace procedure u1.NPRC_OBJ_NUMROWS is
        v_thread_num number; --32:22 --29:29
        v_thread_num_min number;
        i number;
        v_process number;
        v_cpu number;
        v_px number;
        v_px_max number;
        
        e_user_exception exception;
begin
  /*select count(*) into i from NT_ALERTS_RT t
  where t.alert_name='RDWH_DAILY_UPDATE' and t.status='OK' and t.sdt >trunc(sysdate);
  if i<=0 then
     raise e_user_exception; 
  end if;*/
  
  select value into v_px_max from v$parameter t where t.NAME = 'parallel_max_servers'; --максимальное кол-во допустимых параллельных сессий
  v_thread_num:= 60; --макс. кол-во исполняемых потоков
  v_thread_num_min:=10; --мин. кол-во исполняемых потоков
  i:=0; --счетчик запущенных потоков
  for rec in (
              select  --сюда можно подсунуть план исполнения :)
                   distinct t.object_name 
                   ,'declare v_num number;
                      begin
                        begin
                          select /*+parallel(4)*/ count(1) /*auto*/ into v_num from '||t.object_name||';
                          insert into NT_RDWH_OBJ_NUMROWS(DT,OBJ_NAME,NUMROWS,ERR) values(sysdate,'''||t.object_name||''',v_num,0);
                          commit;
                        exception
                          when OTHERS then
                              rollback;
                              insert into NT_RDWH_OBJ_NUMROWS(DT,OBJ_NAME,NUMROWS,ERR) values(sysdate,'''||t.object_name||''',null,1);
                              commit;
                        end;          
                      end;
                     ' as sql_q
              from NT_RDWH_OBJSTATICTICS t
              join all_objects a on a.OBJECT_NAME = t.object_name 
              where a.status = 'VALID'    
             ) loop
      i:=i+1; --счетчик потоков plsql    
      begin
        DBMS_SCHEDULER.CREATE_JOB( --запуск новой, независимой сессии plsql
              job_name   => 'JOBRT'||to_char(trunc(dbms_random.value(1,9999999)))||to_char(trunc(dbms_random.value(0,99)))||nvl(substr(rec.object_name,8,15),to_char(trunc(dbms_random.value(1,9999999)))), --уникальное имя сессии, JOB_RT (job runtime)-признак что сессия/job временный и самоликвидируется 
              job_type   => 'PLSQL_BLOCK',
              job_action => rec.sql_q,--исполняемый код сессии
              enabled    => TRUE
        );     
      exception when others then
         null;
      end;      
      
      if i>=v_thread_num then --если запущеные потоки достигли допустимого максимума
        loop
          dbms_lock.sleep(5); --ожидаем 5 секунд
          select max(t.value) into v_process from v$sysmetric t where t.METRIC_NAME = 'Process Limit %';
          select value into v_cpu from v$sysmetric t where t.METRIC_NAME = 'Host CPU Utilization (%)' and t.INTSIZE_CSEC < 2000; -- загруженность ЦПУ
          select value into v_px from V$PX_PROCESS_SYSSTAT t where t.STATISTIC = 'Servers In Use                '; --загруженность параллельных сессий (пробелы не убираем!!!) 
          if v_cpu < 80 and v_px < v_px_max-300 and v_process<90 --если загруженность ЦПУ <80% и загруженность потоков <1200-400 
            then v_thread_num:=v_thread_num+2; --тогда макс.кол-во исполяемых потоков увеличиваем на 2
            else if v_thread_num>v_thread_num_min then v_thread_num:=v_thread_num-2; else v_thread_num:=v_thread_num_min; end if; --число макс.потоков не может быть менее 10
          end if;  
          select count(*) into i from USER_SCHEDULER_JOBS where job_name like 'JOBRT%'; --проверяем число активных сессий(JOB_RT) на текущий момент и изменяем счетчик потоков
          exit when i<v_thread_num; --если число активных сессий меньше максимально допустимого, то разрешаем создание новых сессий
        end loop; 
      end if;
  end loop;
 
end NPRC_OBJ_NUMROWS;
/

