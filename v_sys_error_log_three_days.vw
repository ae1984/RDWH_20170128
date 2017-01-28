create or replace force view u1.v_sys_error_log_three_days as
select t.id, cast(t.err_date as date) as err_date,
       t.operation, t.err_message, t.object_type, t.object_id
from ERROR_LOG t
where t.err_date >= trunc(sysdate) - 3 and
      t.operation not in ('pkg_daily_update.check_RFOSNAP_availability',
                          'pkg_daily_update.check_DWH_availability',
                          'kill_sessions')
order by cast(t.err_date as date);
grant select on U1.V_SYS_ERROR_LOG_THREE_DAYS to LOADDB;
grant select on U1.V_SYS_ERROR_LOG_THREE_DAYS to LOADER;


