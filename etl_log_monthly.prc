create or replace procedure u1.ETL_LOG_MONTHLY is
  v_cnt number;
begin
  select count(*) into v_cnt from nt_alerts_rt_dashboard2 t where t.alert_name='MONTHLY_UPDATE' and t.status='OK';
  if v_cnt > 0 then 
    return;
  end if;    
  
  insert into u1.update_log (id, object_name, begin_refresh, end_refresh, status)
  select 
    update_log_seq.nextval
    ,a.object_name
    ,sysdate
    ,sysdate
    ,'OK'
  from (  
        select distinct t.object_name
        from (select ins_dt, object_name,status,task_name from NT_TASKS_EXECUTE union all select ins_dt, object_name,status,task_name from NT_TASKS_EXECUTE_HIST) t
        left join T_RDWH_PROC_OBJECT o on (o.type_load like 'DAILY%' or o.type_load = 'ONLINE') and o.is_used=1 and o.object_name=t.object_name
        left join update_log l on l.begin_refresh>=trunc(sysdate) and l.object_name=t.object_name
        where  t.ins_dt >=trunc(sysdate,'mm')--2
             and t.task_name in ('MONTHLY_ADD_TABLE','MONTH_ADD_MVIEW')
             and t.status='COMPLETED'
             and o.object_name is null
             and l.object_name is null
  ) a;
  commit;

end ETL_LOG_MONTHLY;
/

