create or replace procedure u1.NPRC_TASKS_CREATE is
  /*v_process number;
  v_cpu number;
  v_px number;
  v_px_max number;*/
  DayOfWeek  number;
  DayOfMonth  number;
begin
   DayOfWeek :=mod(to_char(sysdate, 'J'), 7) + 1;
   DayOfMonth:= extract (day from sysdate);
   /*select value into v_px_max from v$parameter t where t.NAME = 'parallel_max_servers'; --максимальное кол-во допустимых параллельных сессий
   select max(t.value) into v_process from v$sysmetric t where t.METRIC_NAME = 'Process Limit %';
   select value into v_cpu from v$sysmetric t where t.METRIC_NAME = 'Host CPU Utilization (%)' and t.INTSIZE_CSEC < 2000; -- загруженность ЦПУ
   select value into v_px from V$PX_PROCESS_SYSSTAT t where t.STATISTIC = 'Servers In Use                '; --загруженность параллельных сессий (пробелы не убираем!!!)
   if \*v_cpu > 90 and*\ v_px > v_px_max-100 or v_process>95 then
     return;
   end if;*/
   


   /*запуск с переодичностью в минутах*/
   for rec in ( /*использован курсор, если потребуется усложнять логику*/
      select t.* from NT_TASKS_PLAN t
      join (
         select task_name,group_num,task_num, max(ins_dt) as ins_dt from  NT_TASKS_EXECUTE
         where status in ('COMPLETED','FAILED','WAIT','STOPPED')
         group by task_name,group_num,task_num
      ) b on b.task_name=t.task_name and b.group_num=t.group_num and b.task_num=t.task_num
                                     and (sysdate- b.ins_dt)*24*60 >= t.interval
      left join NT_TASKS_EXECUTE a on a.task_name=t.task_name and a.group_num=t.group_num and a.task_num=t.task_num
              and (a.status like 'NEW%' or a.status='RUNNING')
              and (sysdate- a.ins_dt)*24*60 <= t.interval+60
      where t.is_active = 1 and to_number(to_char(sysdate, 'HH24MI')) between t.start_time and t.end_time and a.id is null
            and t.interval is not null 
            and nvl(t.weekday,'1,2,3,4,5,6,7')  like '%'||to_char(DayOfWeek)||'%' 
            and nvl(t.day,'1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,')
                  like '%'||to_char(DayOfMonth)||',%'
      order by t.task_name, t.group_num,t.task_num
   ) loop
            insert into NT_TASKS_EXECUTE (id, ins_dt, group_num, task_num, task_name, sql_exec, status,object_name)
            values( N_TASKS_EXECUTE_SEQ.nextval
                   ,sysdate
                   ,rec.group_num
                   ,rec.task_num
                   ,rec.task_name
                   ,replace(rec.sql_code,'v_dt','to_date('''||to_char(sysdate,'ddmmyyyy hh24miss')||''',''ddmmyyyy hh24miss'')')
                   ,'NEW'
                   ,rec.object_name
            );
   end loop;
   commit;

   /*разовый запуск за сутки*/
   for rec in ( /*использован курсор, если потребуется усложнять логику*/
      select t.* from NT_TASKS_PLAN t
      left join NT_TASKS_EXECUTE a on a.task_name=t.task_name and a.group_num=t.group_num and a.task_num=t.task_num
              and a.ins_dt>=trunc(sysdate) and (a.status like 'NEW%' or a.status='RUNNING' or a.status='COMPLETED')
      where is_active = 1 and to_number(to_char(sysdate, 'HH24MI')) between t.start_time and t.end_time and a.id is null
            and t.interval is null
            and nvl(t.weekday,'1,2,3,4,5,6,7')  like '%'||to_char(DayOfWeek)||'%'  
            and nvl(t.day,'1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,')
                  like '%'||to_char(DayOfMonth)||',%'
      order by t.task_name, t.group_num,t.task_num
   ) loop
            insert into NT_TASKS_EXECUTE (id, ins_dt, group_num, task_num, task_name, sql_exec, status,object_name)
            values( N_TASKS_EXECUTE_SEQ.nextval
                   ,sysdate
                   ,rec.group_num
                   ,rec.task_num
                   ,rec.task_name
                   ,replace(rec.sql_code,'v_dt','to_date('''||to_char(sysdate,'ddmmyyyy hh24miss')||''',''ddmmyyyy hh24miss'')')
                   ,'NEW'
                   ,rec.object_name
            );
   end loop;
   commit;
   
   
   /*запуск задачи первый раз по интервалу*/
   for rec in ( /*использован курсор, если потребуется усложнять логику*/
      select t.* from NT_TASKS_PLAN t
      left join NT_TASKS_EXECUTE a on a.task_name=t.task_name and a.group_num=t.group_num and a.task_num=t.task_num
      where is_active = 1 and to_number(to_char(sysdate, 'HH24MI')) between t.start_time and t.end_time 
            and a.id is null
            and t.interval is not null
            and nvl(t.weekday,'1,2,3,4,5,6,7')  like '%'||to_char(DayOfWeek)||'%'  
            and nvl(t.day,'1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,')
                  like '%'||to_char(DayOfMonth)||',%'
      order by t.task_name, t.group_num,t.task_num
   ) loop
            insert into NT_TASKS_EXECUTE (id, ins_dt, group_num, task_num, task_name, sql_exec, status,object_name)
            values( N_TASKS_EXECUTE_SEQ.nextval
                   ,sysdate
                   ,rec.group_num
                   ,rec.task_num
                   ,rec.task_name
                   ,replace(rec.sql_code,'v_dt','to_date('''||to_char(sysdate,'ddmmyyyy hh24miss')||''',''ddmmyyyy hh24miss'')')
                   ,'NEW'
                   ,rec.object_name
            );
   end loop;
   commit;   

      
end NPRC_TASKS_CREATE;
/

