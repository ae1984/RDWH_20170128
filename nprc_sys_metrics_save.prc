create or replace procedure u1.NPRC_SYS_METRICS_SAVE is
begin
    insert into NT_SYS_METRIC_HIST
    select sysdate as sdt, 'Servers In Use' as name, t.value from V$PX_PROCESS_SYSSTAT t where t.statistic = 'Servers In Use                '
    union 
    select sysdate as sdt, 'Servers Available' as name, t.value from V$PX_PROCESS_SYSSTAT t where t.statistic = 'Servers Available             '
    union 
    select sysdate as sdt,name, value/1024/1024/1024 as value from v$pgastat where name = 'total PGA allocated'
    union 
    select sysdate as sdt, t.metric_name as name,t.value from v$sysmetric t where t.METRIC_NAME = 'Host CPU Utilization (%)' and t.INTSIZE_CSEC<3000
    ;
    insert into NT_SQL_SESSION_COUNT_HIST
    select 
          sysdate as sdt
          ,t.sql_id,t.username, t.machine
          ,t.osuser,t.module,count(*) as cnt_ses--, t.status
          ,t.sql_exec_start
    from V$SESSION t
    where t.sql_id is not null
    group by t.sql_id,t.sql_exec_start, t.module, t.machine, t.username,t.osuser--,t.status
    having count(*)>61
    order by count(*) desc;
    commit;    
end NPRC_SYS_METRICS_SAVE;
/

