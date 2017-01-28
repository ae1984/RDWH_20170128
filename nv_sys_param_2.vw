create or replace force view u1.nv_sys_param_2 as
select t.position,t.name,t.value, t.name||' '||to_char(round(t.value))||'%' as label, round(value) as value_r
from (
  select '1' as position ,'CPU' as name, value from v$sysmetric t where t.METRIC_NAME = 'Host CPU Utilization (%)' and t.INTSIZE_CSEC < 2000
  union
  select '5' as position ,'TEMP2' as name, nvl(max(t.used_percent),0) as value from SYS.DBA_TABLESPACE_USAGE_METRICS t where t.tablespace_name = 'TEMP02'--'TEMP_8450'
  union
  select '99' as position ,'TEMP' as name, t.used_percent as value from SYS.DBA_TABLESPACE_USAGE_METRICS t where t.tablespace_name = 'TEMP_8450'
  union
  select
    '2' as position ,'PGA' as name
    ,(select value from v$pgastat where name = 'total PGA allocated')/
    (select value from v$parameter where name =  'pga_aggregate_limit')*100 as value
  from dual
  union
  select
    '3' as position ,'PX' as name
    ,(select value  from V$PX_PROCESS_SYSSTAT t where t.STATISTIC = 'Servers In Use                ')/
    (select value  from V$PARAMETER t where t.NAME = 'parallel_max_servers')*100
     as value
  from dual
  union
  select
    '4' as position ,'NET' as name
    ,(select value from v$sysmetric t where t.metric_name='Network Traffic Volume Per Sec')/
    (select t.value_max from NT_RDWH_SYSMETRIC_MAX t where t.metric_name='Network Traffic Volume Per Sec')*100
     as value
  from dual
  union
  select
    '6' as position ,'HDD WR' as name
    ,(select value from v$sysmetric t where t.metric_name='Physical Write Total Bytes Per Sec')/
    (select t.value_max from NT_RDWH_SYSMETRIC_MAX t where t.metric_name='Physical Write Total Bytes Per Sec')*100
     as value
  from dual
  union
  select
    '7' as position ,'HDD RD' as name
    ,(select value from v$sysmetric t where t.metric_name='Physical Read Total Bytes Per Sec')/
    (select t.value_max from NT_RDWH_SYSMETRIC_MAX t where t.metric_name='Physical Read Total Bytes Per Sec')*100
     as value
  from dual
) t
;
grant select on U1.NV_SYS_PARAM_2 to DISPLAY_MON;
grant select on U1.NV_SYS_PARAM_2 to LOADDB;


