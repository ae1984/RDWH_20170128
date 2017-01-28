create or replace procedure u1.NPRC_SQL_PLAN_MONITOR_HIST_AGR is
begin
    --create table NT_SQL_PLAN_MONITOR_HIST_AGR as
    insert into NT_SQL_PLAN_MONITOR_HIST_AGR
    select /*+parallel(20)*/
       min(sdt) as sdt_min
       ,max(sdt) as sdt_max
       ,t.sql_exec_start
       ,t.sql_id
       ,t.sql_plan_hash_value
       ,t.plan_operation
       ,t.plan_options
       ,t.plan_object_name
       ,t.status
       ,t.plan_line_id
       ,t.plan_object_owner
       ,min(t.first_refresh_time) as  first_refresh_time
       ,max(t.last_refresh_time) as  last_refresh_time 
       ,t.cnt_row
       ,t.plan_cost 
       ,t.plan_bytes   
       ,t.plan_time
    from NT_SQL_PLAN_MONITOR_HIST t
    left join NT_SQL_PLAN_MONITOR_HIST_AGR a on a.sql_id=t.sql_id and a.sql_exec_start=t.sql_exec_start
    where a.sql_id is null
    --where 1=2
    group by 
        t.sql_exec_start
       ,t.sql_id
       ,t.sql_plan_hash_value
       ,t.plan_operation
       ,t.plan_options
       ,t.plan_object_name
       ,t.status
       ,t.plan_line_id
       ,t.plan_object_owner
       ,t.cnt_row
       ,t.plan_cost 
       ,t.plan_bytes   
       ,t.plan_time
    ;
    commit;
    
    delete from NT_SQL_PLAN_MONITOR_HIST t
    where t.sql_exec_start <trunc(sysdate)-5;
    commit;      
end NPRC_SQL_PLAN_MONITOR_HIST_AGR;
/

