CREATE OR REPLACE FORCE VIEW U1.NV_SYS_PARAM AS
select 'TASK2EXEC' as name, nfnc_get_task2exec as value from dual
union all
select 'PEP_RUNNING' as name,count(*) as value  from SYS.ALL_SCHEDULER_RUNNING_JOBS t
where t.job_name like 'NJPEP%' and t.owner='U1'
union all
select 'JOBRT_RUNNING' as name,count(*) as value  from SYS.ALL_SCHEDULER_RUNNING_JOBS t
where t.job_name like 'JOB%RT%' and t.owner='U1'
union all
select 'SES-'||t.MODULE as name, count(*) as value from v$session t
where t.USERNAME = 'RISK_ALEXEY'
group by t.MODULE
union all
select t.METRIC_NAME as name, t.VALUE from v$sysmetric t where t.METRIC_NAME = 'Process Limit %'
union all
select name, bytes/1024/1024/1024 as value from v$sgainfo t where name='Buffer Cache Size'
union all
select t.METRIC_NAME as name, t.value from v$sysmetric t where t.METRIC_NAME = 'Buffer Cache Hit Ratio' and t.INTSIZE_CSEC<3000
--union all
--select 'Shared pool Size' as name, sum(bytes)/1024/1024/1024 as value from v$sgastat where pool = 'shared pool'
--union all
--select t.name,to_number(t.value) as value from SYS.V_$PARAMETER t where t.NAME = 'parallel_max_servers'
--union all
--select t.name,to_number(t.value)/1024/1024/1024 as value from SYS.V_$PARAMETER t where t.NAME = 'sga_max_size'
--union all
--select t.name,to_number(t.value) as value from SYS.V_$PARAMETER t where t.NAME = 'cpu_count'
union all
select 'SGA size' as name, round(sum(bytes)/1024/1024/1024,2) as value from v$sgastat
union all
select 'shared pool Free Size' as name, round(sum(decode(name,'free memory',bytes))/1024/1024/1024,2) as value from v$sgastat where pool = 'shared pool'
union all
select decode(pool,null,name,pool) as name,round(sum(bytes)/1024/1024/1024,2) as value from v$sgastat
where pool in ('shared pool')
group by decode(pool,null,name,pool)
union all
select name, value/1024/1024/1024 as value from v$pgastat where name = 'total PGA allocated'
union all
select name, value/1024/1024/1024 as value from v$pgastat where name = 'aggregate PGA target parameter'
union all
select name, value/1024/1024/1024 as value from v$pgastat where name = 'maximum PGA allocated'
union all
select name,value/1024/1024/1024 as value from v$parameter where name =  'pga_aggregate_limit'
union all
select name, value from v$pgastat where name = 'cache hit percentage'
union all
SELECT 'memory sort Ratio' as name, round(100*(a.value-b.value)/(a.value),4) AS value
FROM v$sysstat a, v$sysstat b
WHERE a.name = 'sorts (memory)' AND b.name ='sorts (disk)'
union all
select 'RDWH size' as name, round(sum(bytes)/1024/1024/1024,0) as value
from dba_segments t where t.owner = 'U1'
union all
SELECT 'Dictionary Cache Hit Ratio(ok>90)' as name,(1 - (Sum(getmisses)/(Sum(gets) + Sum(getmisses)))) * 100 as value FROM   v$rowcache
union all
SELECT 'Library Cache Hit Ratio(ok>99)' as name, (1 -(Sum(reloads)/(Sum(pins) + Sum(reloads)))) * 100 as value  FROM   v$librarycache
union all
/*SELECT 'DB Block Buffer Cache Hit Ratio(ok>89)' as name, (1 - (phys.value / (db.value + cons.value))) * 100 as value --кривая формула
FROM   v$sysstat phys,
       v$sysstat db,
       v$sysstat cons
WHERE  phys.name  = 'physical reads'
AND    db.name    = 'db block gets'
AND    cons.name  = 'consistent gets'*/
/*SELECT 'Cache Hit Ratio(ok>89)' as name, ROUND((1-(phy.value / (cur.value + con.value)))*100,2)as value
FROM v$sysstat cur, v$sysstat con, v$sysstat phy
WHERE cur.name = 'db block gets from cache'
AND con.name = 'consistent gets from cache'
AND phy.name = 'physical reads cache'
union all*/
SELECT 'Latch Hit Ratio(ok>98)' as name , (1 - (Sum(misses) / Sum(gets))) * 100 as value FROM   v$latch
union all
SELECT 'Disk Sort Ratio(ok<5)' as name, (disk.value/mem.value) * 100 as value
FROM   v$sysstat disk,
       v$sysstat mem
WHERE  disk.name = 'sorts (disk)'
AND    mem.name  = 'sorts (memory)'
union all
SELECT 'Rollback Segment Waits(ok<5)' as name, (Sum(waits) / Sum(gets)) * 100 as value FROM   v$rollstat
--union all
--SELECT 'Dispatcher Workload(ok<50)' as name, NVL((Sum(busy) / (Sum(busy) + Sum(idle))) * 100,0) as value FROM   v$dispatcher
/*union all
select name, to_number(value) as value  from v$parameter t where t.name in ('db_block_size',
                                                                            'db_block_buffers',
                                                                            'db_cache_size')*/
union all
select
  name
  ,percentage as value
from (
SELECT name, cnt, DECODE(total, 0, 0, ROUND(cnt*100/total,4)) percentage
  FROM (SELECT name, value cnt, (SUM(value) over ()) total
  FROM V$SYSSTAT
 WHERE name
  LIKE 'workarea exec%')
)
union all
select t.NAME, to_number(t.VALUE) as VALUE from v$parameter t where t.name in ('parallel_max_servers','cpu_count')
union all
select name, to_number(value) as value from v$parameter t where t.NAME = 'hash_area_size'
union all
select name, to_number(value) as value from v$parameter where name = 'processes'
union all
select name, to_number(value) as value from v$parameter where name = 'sessions'
union all
select t.tablespace_name as name, round(t.used_percent,2) as value from SYS.DBA_TABLESPACE_USAGE_METRICS t where t.tablespace_name in ('TEMP_8450','UNDO02')
;
grant select on U1.NV_SYS_PARAM to LOADDB;


