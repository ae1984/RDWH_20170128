create or replace force view u1.v_sys_checks_daily_uamr as
select 1 as n, 'Ежеденевный пересчет окончен в ' as test_name,
      to_char(x.test_value,'hh24:mi') as test_info,
      'MAIN' as test_proc
from (select (cast(t.e_timestamp as date)) as test_value from DAILY_UPDATE_EVENT t
                  where trunc(t.e_date) = trunc(sysdate) and event = 'PROCESS_COMPLETE') x
union all
select 2 as n, 'Всего объектов РФО' as test_name,
       to_char(x.test_value) as test_info,
       'MAIN' as test_proc
from (select count(distinct po.object_name) as test_value
        from t_rdwh_proc_object po
       where po.load_group in ('LOAD_RFO','RECALC_RFO')
             and po.is_used = 1
             and po.object_type in ('TABLE','MVIEW')
             and po.type_load = 'DAILY'
     ) x
union all
select 3 as n, 'Объектов обновлено РФО' as test_name,
       to_char(x.test_value) as test_info,
       'MAIN' as test_proc
from (select count(distinct po.object_name) as test_value
        from t_rdwh_proc_object po
        join update_log ul on ul.object_name = po.object_name and ul.begin_refresh >= trunc(sysdate) and ul.status = 'OK'
       where po.load_group in ('LOAD_RFO','RECALC_RFO')
             and po.is_used = 1
             and po.object_type in ('TABLE','MVIEW')
             and po.type_load = 'DAILY'
     ) x
union all
--Кол-во ошибок
select 4 as n, 'Количество ошибок ' as test_name,
      to_char(x.test_value) as test_info,
      'MAIN' as test_proc
from (select count(1) as test_value from ERROR_LOG t where trunc(t.err_date) >= trunc(sysdate) and
                t.operation not in ('pkg_daily_update.check_RFOSNAP_availability','kill_sessions',
                                    'pkg_daily_update_rbo.check_RBOSNAP_availability', 'compile')
             and t.operation not like '%pkg_monthly_update%'
             and t.operation not like '%pkg_weekly_update%'
) x
union all
--Дата загрузки DWH PORT
select 5 as n, 'DWH_PORT загружен за дату ' as test_name,
      to_char(x.test_value,'yyyy-mm-dd') as test_info,
      'MAIN' as test_proc
from (select max(t.rep_date) as test_value from DWH_PORT t
) x

union all
select 1 as n, 'Дополнительный пересчет окончен в ' as test_name,
        to_char(du.e_timestamp ,'hh24:mi') as test_info,
        'ADD' as test_proc
  from daily_update_event du
 where event = 'PROCESS_ADD_COMPLETE'
   and e_date = trunc(sysdate)

union all
select 2 as n, 'Количество ошибок ' as test_name,
      (select to_char(nvl(sum(regexp_count(p_detail,'with error')),0)) from daily_update_log t where t.process in ('RECALC_ADD_P1','RECALC_ADD_P2','RECALC_ADD_P3','RECALC_ADD_P4') and p_date = trunc(sysdate) and p_status = 'COMPLETE') as test_info,
      'ADD' as test_proc
from (select count(1) as test_value from daily_update_log t where t.process in ('RECALC_ADD_P1','RECALC_ADD_P2','RECALC_ADD_P3','RECALC_ADD_P4') and p_date = trunc(sysdate) and p_status = 'COMPLETE') x
union all
select 1 as n, 'Процесс РБО окончен в ' as test_name,
        to_char(du.e_timestamp ,'hh24:mi') as test_info,
        'RBO' as test_proc
  from daily_update_event du
 where event = 'PROCESS_RBO_COMPLETE'
   and e_date = trunc(sysdate)
union all
select 2 as n, 'Всего объектов РБО' as test_name,
       to_char(x.test_value) as test_info,
       'RBO' as test_proc
from (select count(distinct po.object_name) as test_value
        from t_rdwh_proc_object po
       where po.load_group in ('LOAD_RBO','RECALC_RBO')
             and po.is_used = 1
             and po.object_type in ('TABLE','MVIEW')
             and po.type_load = 'DAILY'
     ) x
union all
select 2.5 as n, 'Объектов обновлено РБО' as test_name,
       to_char(x.test_value) as test_info,
       'RBO' as test_proc
from (select count(distinct po.object_name) as test_value
        from t_rdwh_proc_object po
        join update_log ul on ul.object_name = po.object_name and ul.begin_refresh >= trunc(sysdate) and ul.status = 'OK'
       where po.load_group in ('LOAD_RBO','RECALC_RBO')
             and po.is_used = 1
             and po.object_type in ('TABLE','MVIEW')
             and po.type_load = 'DAILY'
     ) x
union all
select 3 as n, 'Последний загруженный день ' as test_name,
      to_char(x.test_value,'yyyy-mm-dd') as test_info,
      'RBO' as test_proc
from (select max(t.rep_date) as test_value from T_RBO_PORT t) x
union all
select 1 as n, 'Всего объектов РФО' as test_name,
      to_char(x.test_value) as test_info,
      'MAIN_ERROR' as test_proc
from (select count(distinct po.object_name) as test_value
        from t_rdwh_proc_object po
       where po.load_group in ('LOAD_RFO','RECALC_RFO')
             and po.is_used = 1
             and po.object_type in ('TABLE','MVIEW')
             and po.type_load = 'DAILY'
     ) x
union all
select 2 as n, 'Объектов обновлено РФО' as test_name,
      to_char(x.test_value) as test_info,
      'MAIN_ERROR' as test_proc
from (select count(distinct po.object_name) as test_value
        from t_rdwh_proc_object po
        join update_log ul on ul.object_name = po.object_name and ul.begin_refresh >= trunc(sysdate) and ul.status = 'OK'
       where po.load_group in ('LOAD_RFO','RECALC_RFO')
             and po.is_used = 1
             and po.object_type in ('TABLE','MVIEW')
             and po.type_load = 'DAILY'
     ) x
;
grant select on U1.V_SYS_CHECKS_DAILY_UAMR to LOADDB;
grant select on U1.V_SYS_CHECKS_DAILY_UAMR to LOADER;


