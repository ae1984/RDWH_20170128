﻿create or replace procedure u1.ETL_MVIEW_ADDNEW_WEEK is
begin
  insert into NT_TASKS_EXECUTE (id, ins_dt, group_num, task_num, task_name, sql_exec, status,object_name)
  select N_TASKS_EXECUTE_SEQ.nextval
         ,sysdate
         ,1
         ,ttt.priority
         ,'WEEKLY_ADD_MVIEW'
         --,'dbms_mview.refresh(list => '''||z.object_name||''',parallelism => 20,atomic_refresh => false);'
         ,'nprc_mviewrefresh_daily('''||ttt.object_name||''');'
         ,'NEW'
         ,ttt.object_name
  from (
    select 
         tt.object_name 
        ,min(tt.priority) as priority
        ,count(dl.object_name) as cnt_ref_obj
        ,count(l.end_refresh) as cnt_ref_obj_ready
        ,count(tt.reference_from_event) as cnt_event
        ,count(e.dt) as cnt_event_ready
    from NVETL_WEEKLYADD_MVIEWNOTREADY tt
    left join NV_ETL_DEPENDENCIES dp on dp.owner = 'U1' and dp.name=tt.object_name and dp.name<>dp.referenced_name
    left join NVETL_WEEKLY_OBJECTS dl on dl.object_name= dp.referenced_name 
    left join update_log l on l.object_name=dl.object_name and l.end_refresh>=trunc(sysdate) and l.end_refresh+(20/24/60/60)<sysdate and l.status='OK'
    left join NVETL_DAILY_EVENTS e on e.event = tt.reference_from_event
    group by 
        tt.object_name 
  ) ttt    
  where ttt.cnt_ref_obj <= ttt.cnt_ref_obj_ready and ttt.cnt_event<=ttt.cnt_event_ready and rownum <= nfnc_get_task2exec
      /*and 900>=(select value from V$PX_PROCESS_SYSSTAT t where t.STATISTIC = 'Servers In Use                ')
      and 60>=(select value  from v$sysmetric t where t.METRIC_NAME = 'Host CPU Utilization (%)' and t.INTSIZE_CSEC < 2000)
      and 80>=(select t.used_percent from SYS.DBA_TABLESPACE_USAGE_METRICS t where t.tablespace_name = 'TEMP02') */
      --and 8000<=(select max(value) from SYS.V_$SYSMETRIC where metric_name='I/O Megabytes per Second')     
      /*and ttt.object_name  not in (
          select object_name
          from NT_ETL_OBJECTS_STAT 
          where cnt_process>=240
          group by object_name   
         )*/
         ;
  commit;    
end ETL_MVIEW_ADDNEW_WEEK;
/

