create or replace procedure u1.ETL_TABLE_ADDNEW is
begin
  insert into NT_TASKS_EXECUTE (id, ins_dt, group_num, task_num, task_name, sql_exec, status,object_name)
  select N_TASKS_EXECUTE_SEQ.nextval
         ,sysdate
         ,1
         ,ttt.priority
         ,'DAILY_MAIN_TABLE'
         ,ttt.procedure_name_new||'; '||nvl(ttt.check_proc,'null')||';'
         ,'NEW'
         ,ttt.object_name
  from (
    select
         tt.object_name
        ,tt.procedure_name_new
        ,tt.check_proc
        ,min(tt.priority) as priority
        ,count(dl.object_name) as cnt_ref_obj
        ,count(l.end_refresh) as cnt_ref_obj_ready
        ,count(tt.reference_from_event) as cnt_event
        ,count(e.dt) as cnt_event_ready
    from NVETL_DAILYMAIN_TABLENOTREADY tt
    left join NV_ETL_DEPENDENCIES dp on dp.owner = 'U1' and dp.name=tt.procedure_name_new /*tt.object_name*/ and dp.name<>dp.referenced_name and dp.referenced_name<> tt.object_name
    left join NVETL_DAILY_OBJECTS dl on dl.object_name= dp.referenced_name
    left join update_log l on l.object_name=dl.object_name and l.end_refresh>=trunc(sysdate) and l.end_refresh+(2/24/60/60)<sysdate and l.status='OK'
    left join NVETL_DAILY_EVENTS e on e.event = tt.reference_from_event
    group by tt.object_name,tt.procedure_name_new,tt.check_proc
  ) ttt
  where ttt.cnt_ref_obj <= ttt.cnt_ref_obj_ready and ttt.cnt_event<=ttt.cnt_event_ready and rownum <= nfnc_get_task2exec
       and ttt.object_name not in (select object_name from NV_USERS_LOCKED_OBJECT_0_9)
       and ttt.object_name not in (select object_name from NV_USERS_LOCKED_OBJECT_0_9_2)
      /*and 900>=(select value from V$PX_PROCESS_SYSSTAT t where t.STATISTIC = 'Servers In Use                ')
      and 80>=(select value  from v$sysmetric t where t.METRIC_NAME = 'Host CPU Utilization (%)' and t.INTSIZE_CSEC < 2000)
      and 80>=(select t.used_percent from SYS.DBA_TABLESPACE_USAGE_METRICS t where t.tablespace_name = 'TEMP02') */
      --and 8000<=(select max(value) from SYS.V_$SYSMETRIC where metric_name='I/O Megabytes per Second')
  ;
  commit;
end ETL_TABLE_ADDNEW;
/

