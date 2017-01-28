create or replace function u1.NFNC_GET_TASK2EXEC return number is
  v_res number;
  
  v_process number;
  v_cpu number;
  v_temp_used_prc number;
  --v_temp1_used_prc number;
  v_pga_used_prc number;
  v_px_used_prc number;
  v_network_used_prc number;
  v_disk_write_used_prc number;
  v_disk_read_used_prc number;
  i number;
  --v_obj_used_prc number;
begin
  select max(t.value) into v_process from v$sysmetric t where t.METRIC_NAME = 'Process Limit %';
  select value into v_cpu from v$sysmetric t where t.METRIC_NAME = 'Host CPU Utilization (%)' and t.INTSIZE_CSEC < 2000; -- загруженность ЦПУ
  select nvl(max(t.used_percent),0) into v_temp_used_prc from SYS.DBA_TABLESPACE_USAGE_METRICS t where t.tablespace_name = 'TEMP02';

  --select t.used_percent into v_temp1_used_prc from SYS.DBA_TABLESPACE_USAGE_METRICS t where t.tablespace_name = 'TEMP01';
  select 
    (select value from v$pgastat where name = 'total PGA allocated')/
    (select value from v$parameter where name =  'pga_aggregate_limit')*100 
    into v_pga_used_prc
  from dual;
  select
    (select value  from V$PX_PROCESS_SYSSTAT t where t.STATISTIC = 'Servers In Use                ')/
    (select value  from V$PARAMETER t where t.NAME = 'parallel_max_servers')*100
    into v_px_used_prc
  from dual;
  select 
    (select value from v$sysmetric t where t.metric_name='Network Traffic Volume Per Sec')/
    (select t.value_max from NT_RDWH_SYSMETRIC_MAX t where t.metric_name='Network Traffic Volume Per Sec')*100
    into v_network_used_prc
  from dual;
  select 
    (select value from v$sysmetric t where t.metric_name='Physical Write Total Bytes Per Sec')/
    (select t.value_max from NT_RDWH_SYSMETRIC_MAX t where t.metric_name='Physical Write Total Bytes Per Sec')*100
    into v_disk_write_used_prc
  from dual;    
  select 
    (select value from v$sysmetric t where t.metric_name='Physical Read Total Bytes Per Sec')/
    (select t.value_max from NT_RDWH_SYSMETRIC_MAX t where t.metric_name='Physical Read Total Bytes Per Sec')*100
    into v_disk_read_used_prc
  from dual;  
  
  /*select count(1)/60 \*цифра полученная из графика *\ *100 into v_obj_used_prc
  from NT_TASKS_EXECUTE t
  where 
       t.ins_dt >=trunc(sysdate)
       and t.task_name like 'DAILY_%' 
       and t.status='RUNNING';*/
  
  /*
    <?xml version="1.0" standalone="yes"?>
    <root>
      <action>
        <error sqlcode="-4091" sqlerrm="ORA-04091: table U1.NT_TASKS_EXECUTE is mutating, trigger/function may not see it">
          <stacktrace>ORA-04091: table U1.NT_TASKS_EXECUTE is mutating, trigger/function may not see it
    </stacktrace>
          <callstack>----- PL/SQL Call Stack -----
      object      line  object
      handle    number  name
    700011a4e3d3690         1  anonymous block
    70001194b6f8de8        21  anonymous block
    </callstack>
          <backtrace>ORA-06512: at "U1.NFNC_GET_TASK2EXEC", line 43
    ORA-06512: at "U1.ETL_TABLE_ADDNEW2", line 3
    ORA-06512: at line 7
    </backtrace>
        </error>
      </action>
    </root>  
  */
       
  v_res:=30;

  if v_px_used_prc > 10 then v_res:=15; end if;
  if v_px_used_prc > 20 then v_res:=10; end if;
  if v_px_used_prc > 50 or v_cpu > 50 or v_network_used_prc>35 or v_disk_write_used_prc>55 or v_disk_read_used_prc>65  then v_res:=4; end if;
  if v_px_used_prc > 60 or v_cpu > 60 or v_network_used_prc>45 or v_disk_write_used_prc>65 or v_disk_read_used_prc>75 then v_res:=2; end if;
  --if v_px_used_prc > 60 or v_cpu > 60 then v_res:=2; end if;

  --if v_temp_used_prc>70 or v_process>70 or v_pga_used_prc>85 then v_res:=1; end if;
  
  if v_temp_used_prc>85 
     --or v_temp1_used_prc>80
     or v_process>85 
     or v_pga_used_prc>95
     or v_px_used_prc>75 
     or v_cpu>75 
     or v_network_used_prc>65
     or v_disk_write_used_prc>75
     or v_disk_read_used_prc>85
     --or v_obj_used_prc>100
  then 
    v_res:=0; 
  end if;
  
  return(v_res);
end NFNC_GET_TASK2EXEC;
/

