create or replace force view u1.v_sys_daily_update_log as
select t.id, t.process, cast (t.p_begin as date) as p_begin,
       cast(t.p_end as date) as p_end, t.p_detail, t.p_total_min, t.p_status
from DAILY_UPDATE_LOG t
where t.p_begin > trunc(sysdate)
order by t.p_begin;
grant select on U1.V_SYS_DAILY_UPDATE_LOG to LOADDB;
grant select on U1.V_SYS_DAILY_UPDATE_LOG to LOADER;


