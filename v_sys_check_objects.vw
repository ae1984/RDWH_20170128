create or replace force view u1.v_sys_check_objects as
with x as (
     -- MAIN -- основные объекты для аналитики
     -- MAIN -- РФО
     select 'M_FOLDER_CON_CANCEL' o, 'U1' owner, '1 RFO' i, 9 plan_hour,
            (select count(*) from U1.M_FOLDER_CON_CANCEL) as row_cnt,
            (select max(folder_date_create_mi) from U1.M_FOLDER_CON_CANCEL) as max_date
            from dual union all
     select 'M_FOLDER_CON_CANCEL_ONLINE' o, 'U1' owner, '1 RFO' i, 9 plan_hour,
            (select count(*) from U1.M_FOLDER_CON_CANCEL_ONLINE) as row_cnt,
            (select max(folder_date_create_mi) from U1.M_FOLDER_CON_CANCEL_ONLINE) as max_date
            from dual union all
     select 'V_FOLDER_ALL_RFO' o, 'U1' owner, '1 RFO' i, 9 plan_hour,
            (select count(*) from U1.V_FOLDER_ALL_RFO) as row_cnt,
            (select max(folder_date_create) from U1.V_FOLDER_ALL_RFO) as max_date
            from dual union all
     select 'V_FORM_CLIENT_ALL_RFO' o, 'U1' owner, '1 RFO' i, 9 plan_hour,
            (select count(*) from U1.V_FORM_CLIENT_ALL_RFO) as row_cnt,
            (select max(form_client_date) from U1.V_FORM_CLIENT_ALL_RFO) as max_date
            from dual union all
     select 'V_PKB_REPORT' o, 'U1' owner, '1 RFO' i, 9 plan_hour,
            (select count(*) from U1.V_PKB_REPORT) as row_cnt,
            (select max(rfo_report_date_time) from U1.V_PKB_REPORT) as max_date
            from dual union all
     select 'V_GCVP_REPORT' o, 'U1' owner, '1 RFO' i, 9 plan_hour,
            (select count(*) from U1.V_GCVP_REPORT) as row_cnt,
            (select max(rep_date) from U1.V_GCVP_REPORT) as max_date
            from dual union all
/*     select 'V_CANCEL' o, 'U1' owner, '1 RFO' i, 9 plan_hour,
            (select count(*) from U1.V_CANCEL) as row_cnt,
            (select max(cancel_date) from U1.V_CANCEL) as max_date
            from dual union all  */
     -- MAIN -- РБО
     select 'M_RBO_CONTRACT_BAS' o, 'U1' owner, '2 RBO' i, 9 plan_hour,
            (select count(*) from U1.M_RBO_CONTRACT_BAS) as row_cnt,
            (select max(begin_date) from U1.M_RBO_CONTRACT_BAS) as max_date
            from dual union all
     select 'M_RBO_CONTRACT_DEL' o, 'U1' owner, '2 RBO' i, 9 plan_hour,
            (select count(*) from U1.M_RBO_CONTRACT_DEL) as row_cnt,
            (select max(rep_date) from U1.M_RBO_CONTRACT_DEL) as max_date
            from dual union all
     select 'T_RBO_PORT' o, 'U1' owner, '2 RBO' i, 9 plan_hour,
            (select count(*) from U1.T_RBO_PORT) as row_cnt,
            (select max(rep_date) from U1.T_RBO_PORT) as max_date
            from dual union all
     -- MAIN -- ДВХ
     select 'V_DWH_PORTFOLIO_CURRENT' o, 'U1' owner, '3 DWH' i, 9 plan_hour,
            (select count(*) from U1.V_DWH_PORTFOLIO_CURRENT) as row_cnt,
            (select max(begin_date) from U1.V_DWH_PORTFOLIO_CURRENT) as max_date
            from dual union all
     -- MAIN -- MO
     select 'M_FOLDER_MO_CANCEL_LAST' o, 'U1' owner, '4 MO' i, 9 plan_hour,
            (select count(*) from U1.M_FOLDER_MO_CANCEL_LAST) as row_cnt,
            to_date('3333-03-03','yyyy-mm-dd') as max_date -- не проверяем
            from dual union all

     -- объекты для HR
     select 'M_OUT_STAFF_CON_ACTIVE' o, 'U1' owner, '5 OUT HR' i, 9 plan_hour,
            (select count(*) from U1.M_OUT_STAFF_CON_ACTIVE) as row_cnt,
            to_date('3333-03-03','yyyy-mm-dd') as max_date -- не проверяем
            from dual union all
     select 'M_OUT_STAFF_DEL' o, 'U1' owner, '5 OUT HR' i, 9 plan_hour,
            (select count(*) from U1.M_OUT_STAFF_DEL) as row_cnt,
            to_date('3333-03-03','yyyy-mm-dd') as max_date -- не проверяем
            from dual union all
     select 'V_CLIENT_NEGATIVE' o, 'U1' owner, '5 OUT HR' i, 9 plan_hour,
            (select count(*) from U1.V_CLIENT_NEGATIVE) as row_cnt,
            to_date('3333-03-03','yyyy-mm-dd') as max_date -- не проверяем
            from dual union all

     -- объекты для MO (пока проверяем только мат представления)
     select p.table_name o, p.owner, '6 OUT MO' i, 8.75 plan_hour,
            -1 as row_cnt,-- не проверяем
            to_date('3333-03-03','yyyy-mm-dd') as max_date -- не проверяем
     from SYS.DBA_TAB_PRIVS p
     join SYS.DBA_MVIEWS d on d.mview_name = p.table_name and d.owner = p.owner
     where p.grantee = 'LOAD_MO'
)
select /*+ parallel(5) */ x.i as info, x.o as object,
       -- проверки OK/ERROR (.. - значит не проверяем)
       case when x.max_date = to_date('3333-03-03','yyyy-mm-dd') then '..'
            when x.max_date >= trunc(sysdate) - 1 then 'OK'
            else 'ERROR' end as is_data_actual,
       case when d.last_refresh_end_time is null then '..' -- значит это таблица
            when d.last_refresh_end_time > trunc(sysdate) then 'OK'
            else 'ERROR' end as is_refreshed,
       case when x.row_cnt = -1 then '..'
            when x.row_cnt > 0 then 'OK'
            else 'ERROR' end as is_not_empty,
       case when d.last_refresh_end_time is null then '..' -- значит это таблица
            when d.last_refresh_end_time < trunc(sysdate) + x.plan_hour/24 and d.last_refresh_end_time >= trunc(sysdate) then 'OK'
            else 'ERROR' end as is_on_time,
       -- доп информация
       case when d.last_refresh_end_time is null then null -- значит это таблица
            when d.last_refresh_end_time - (trunc(sysdate) + x.plan_hour/24) > 0
                 then round((d.last_refresh_end_time - (trunc(sysdate) + x.plan_hour/24)) * 24 * 60)
       end as minutes_late,
       case when x.max_date = to_date('3333-03-03','yyyy-mm-dd') then '..'
            else to_char(x.max_date,'yyyy-mm-dd hh24:mi') end as data_max_date,
       to_char(d.last_refresh_end_time,'yyyy-mm-dd') as refresh_date,
       to_char(d.last_refresh_end_time,'hh24:mi') as refresh_time,
       case when x.row_cnt = -1 then null
            else x.row_cnt end row_cnt,
       case when d.last_refresh_end_time is null then '..' -- значит это таблица
            else to_char(x.plan_hour) end as plan_hour,
       round((sysdate - d.last_refresh_end_time) * 24, 1) as refreshed_hours_ago,
       coalesce(d.owner, b.owner) as owner
from x
left join SYS.DBA_MVIEWS d on d.mview_name = x.o and d.owner = x.owner
left join SYS.DBA_TABLES b on b.table_name = x.o and b.owner = x.owner
order by 1, 2
;
grant select on U1.V_SYS_CHECK_OBJECTS to LOADDB;
grant select on U1.V_SYS_CHECK_OBJECTS to LOADER;


