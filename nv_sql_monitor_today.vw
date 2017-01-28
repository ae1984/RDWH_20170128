create or replace force view u1.nv_sql_monitor_today as
select t."SQL_ID",t."SQL_EXEC_START",t."LAST_REFRESH_TIME",t."CNT_PSES",t."INTERVAL_SEC",s.sql_fulltext --nvl(s.sql_fulltext,s1.sql_fulltext) as sql_fulltext
from (
  select t.sql_id,t.sql_exec_start, max(t.last_refresh_time) as last_refresh_time,max(t.cnt_pses)as cnt_pses,(max(t.last_refresh_time)-t.sql_exec_start)*24*60*60 as interval_sec
  from NT_SQL_MONITOR_HIST t
  where t.sql_exec_start>=trunc(sysdate)
        --and extract (hour from cast(t.sql_exec_start as timestamp) ) in (0,1,2,3,4,5,6,7,8)
  group by t.sql_id,t.sql_exec_start
  order by t.sql_exec_start
) t
left join NT_SQLID s on s.sql_id=t.sql_id
--left join NT_SQL_HIST s1 on s1.sql_id=t.sql_id
;
grant select on U1.NV_SQL_MONITOR_TODAY to LOADDB;


