create or replace force view u1.nv_users_locked_object as
select distinct ttt.osuser
from (
  select
       tt.owner, tt.sql_id, tt.object_name, tt.osuser
       ,nvl(tt.sql_exec_start,tt.sdt_min) as start_dt
       ,tt.sdt_max as end_dt
       ,(tt.sdt_max - nvl(tt.sql_exec_start,tt.sdt_min))*24*60*60 as interval_sec
       ,s.sql_text,s.sql_fulltext
  from (
    select t.owner, t.sql_id, t.object_name, t.osuser, t.sql_exec_start, min(t.sdt) as sdt_min ,  max(t.sdt) as sdt_max from NT_LOCKEDOBJ_HIST t
    where t.sdt>=trunc(sysdate) and t.osuser not in ('oracle','informatica')
          and t.owner in ('SYS','U1')
          --and t.object_name='OBJ$'
    group by t.sql_id, t.sql_exec_start, t.object_name, t.osuser, t.owner
    order by t.sql_exec_start desc
  ) tt
  left join nt_sqlid s on s.sql_id = tt.sql_id
  where (upper(s.sql_text) not like '%NOT_KILL%' and upper(s.sql_text) not like 'INSERT%')
        or s.sql_text is null
)ttt
--where end_dt>= sysdate - (1*60/24/60)
where ttt.interval_sec > 3600 and ttt.end_dt>= sysdate - (0.5*60/24/60)
;
grant select on U1.NV_USERS_LOCKED_OBJECT to LOADDB;


