create or replace procedure u1.NPRC_METRIC_HIST_30D is
  v_dt date;
begin
  insert into NT_RDWH_PX_SERVERS 
  select 
    sysdate as dt
    ,(select t.VALUE from v$px_process_sysstat t where t.STATISTIC = 'Servers In Use                ') as Servers_In_Use 
    ,(select t.VALUE from v$px_process_sysstat t where t.STATISTIC = 'Servers Available             ') as Servers_Available
  from dual;  
  commit;
  
  insert into NT_TOTAL_PGA_ALLOCATED_HIST
  select sysdate as dt, value/1024/1024/1024 as value from v$pgastat where name = 'total PGA allocated';
  commit;

  select max(dt) into v_dt  from NT_RDWH_HOST_CPU_UTILIZATION;
  insert into NT_RDWH_HOST_CPU_UTILIZATION 
  select
    t.end_time as dt
    ,t.value 
  from v$sysmetric t
  where t.METRIC_NAME = 'Host CPU Utilization (%)'
        and t.INTSIZE_CSEC<3000
        and t.end_time <> v_dt
  ;


  /*insert into NT_SQL_WORKAREA_ACTIVE_HIST
  SELECT 
         sysdate as sdt
         ,t.sql_id
         ,t.SQL_EXEC_START
         ,TO_NUMBER(DECODE(t.sid, 65535, null, t.sid)) sid,
         t.operation_type,
         t.OPERATION_ID,
         t.expected_size/1024/1024 expected_size_MB,
         t.actual_mem_used/1024/1024 actual_mem_used_MB,
         t.max_mem_used/1024/1024 max_mem_used_MB,
         t.number_passes pass,
         t.TEMPSEG_SIZE/1024/1024 TEMPSEG_SIZE_MB
         ,a.USERNAME
         ,a.TABLESPACE
         ,a.SEGTYPE
         ,a.SQL_ID as SQL_ID_t
         ,a.SQL_ID_TEMPSEG
  FROM V$SQL_WORKAREA_ACTIVE t
  left join V$TEMPSEG_USAGE a on  a.TABLESPACE = t.TABLESPACE and a.SEGRFNO# = a.SEGRFNO# and a.SEGBLK# = t.SEGBLK#;
  commit;*/  
end NPRC_METRIC_HIST_30D;
/

