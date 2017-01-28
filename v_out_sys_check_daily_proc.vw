create or replace force view u1.v_out_sys_check_daily_proc as
select t.proc_name as process_name,
       1 as process_priority,
       case when to_char(sysdate,'hh24mi') >= '0200' then to_date(to_char(sysdate,'dd-mm-yyyy')||'02:00:00','dd-mm-yyyy hh24:mi:ss') else null end as date_process_start,
       to_date(to_char(e.e_timestamp,'dd-mm-yyyy hh24:mi:ss'),'dd-mm-yyyy hh24:mi:ss') as date_process_end,
       case when e.event is not null and to_char(e.e_timestamp,'hh24mi') between '0000' and '0210' then 'RFO_SNAP готов вовремя.'
            when e.event is not null and to_char(e.e_timestamp,'hh24mi') > '0210'
                 then 'RFO_SNAP готов, время задержки = '||
                       extract (hour from (e.e_timestamp-to_date(to_char(sysdate,'dd-mm-yyyy')||'02:10:00','dd-mm-yyyy hh24:mi:ss')))||
                       ':'||extract (minute from (e.e_timestamp-to_date(to_char(sysdate,'dd-mm-yyyy')||'02:10:00','dd-mm-yyyy hh24:mi:ss')))||'.'
            when e.event is null and to_char(sysdate,'hh24mi') > '0210' then 'RFO_SNAP не готов, время задержки = '||
                       extract (hour from (systimestamp-to_date(to_char(sysdate,'dd-mm-yyyy')||'02:10:00','dd-mm-yyyy hh24:mi:ss')))||
                       ':'||extract (minute from (systimestamp-to_date(to_char(sysdate,'dd-mm-yyyy')||'02:10:00','dd-mm-yyyy hh24:mi:ss')))||'.'
            when e.event is null and to_char(sysdate,'hh24mi') between '0000' and '0210' then 'RFO_SNAP не готов, приблизительное время готовности в 02:10.'
       else null end as comments,
       case when e.event is not null and to_char(e.e_timestamp,'hh24mi') between '0000' and '0210' then 'OK'
            when e.event is not null and to_char(e.e_timestamp,'hh24mi') > '0210' then 'OK WITH TIMEOUT'
            when e.event is null and to_char(sysdate,'hh24mi') > '0210' then 'ERROR'
            when e.event is null and to_char(sysdate,'hh24mi') between '0000' and '0210' then 'PROCESSING'
       else null end as process_status,
       null as process_dependence
  from (select 'RFO_SNAP_READY' proc_name from dual) t
  left join daily_update_event e on e.event = t.proc_name and trunc(e.e_date) = trunc(sysdate)
union all
select t.proc_name,
       2 as process_priority,
       case when to_char(sysdate,'hh24mi') >= '0200' then to_date(to_char(sysdate,'dd-mm-yyyy')||'02:00:00','dd-mm-yyyy hh24:mi:ss') else null end as date_process_start,
       to_date(to_char(e.e_timestamp,'dd-mm-yyyy hh24:mi:ss'),'dd-mm-yyyy hh24:mi:ss') as date_process_end,
       case when e.event is not null and to_char(e.e_timestamp,'hh24mi') between '0000' and '0530' then 'DWH готов вовремя.'
            when e.event is not null and to_char(e.e_timestamp,'hh24mi') > '0530' then 'DWH готов, время задержки = '||
                       extract (hour from (e.e_timestamp-to_date(to_char(sysdate,'dd-mm-yyyy')||'05:30:00','dd-mm-yyyy hh24:mi:ss')))||
                       ':'||extract (minute from (e.e_timestamp-to_date(to_char(sysdate,'dd-mm-yyyy')||'05:30:00','dd-mm-yyyy hh24:mi:ss')))||'.'
            when e.event is null and to_char(sysdate,'hh24mi') > '0530' then 'DWH не готов, время задержки = '||
                       extract (hour from (systimestamp-to_date(to_char(sysdate,'dd-mm-yyyy')||'05:30:00','dd-mm-yyyy hh24:mi:ss')))||
                       ':'||extract (minute from (systimestamp-to_date(to_char(sysdate,'dd-mm-yyyy')||'05:30:00','dd-mm-yyyy hh24:mi:ss')))||'.'
            when e.event is null and to_char(sysdate,'hh24mi') between '0000' and '0530' then 'DWH не готов, приблизительное время готовности в 05:30.'
       else null end as comments,
       case when e.event is not null and to_char(e.e_timestamp,'hh24mi') between '0000' and '0530' then 'OK'
            when e.event is not null and to_char(e.e_timestamp,'hh24mi') > '0530' then 'OK WITH TIMEOUT'
            when e.event is null and to_char(sysdate,'hh24mi') > '0530' then 'ERROR'
            when e.event is null and to_char(sysdate,'hh24mi') between '0000' and '0530' then 'PROCESSING'
       else null end as process_status,
       null as process_dependence
  from (select 'DWH_READY' proc_name from dual) t
  left join daily_update_event e on e.event = t.proc_name and trunc(e.e_date) = trunc(sysdate)
union all
select t.proc_name,
       3 as process_priority,
       case when to_char(sysdate,'hh24mi') >= '0700' then to_date(to_char(sysdate,'dd-mm-yyyy')||'07:00:00','dd-mm-yyyy hh24:mi:ss') else null end as date_process_start,
       to_date(to_char(e.e_timestamp,'dd-mm-yyyy hh24:mi:ss'),'dd-mm-yyyy hh24:mi:ss') as date_process_end,
       case when e.event is not null and to_char(e.e_timestamp,'hh24mi') between '0000' and '0710' then 'RBO_SNAP готов вовремя.'
            when e.event is not null and to_char(e.e_timestamp,'hh24mi') > '0710' then 'RBO_SNAP готов, время задержки = '||
                       extract (hour from (e.e_timestamp-to_date(to_char(sysdate,'dd-mm-yyyy')||'07:10:00','dd-mm-yyyy hh24:mi:ss')))||
                       ':'||extract (minute from (e.e_timestamp-to_date(to_char(sysdate,'dd-mm-yyyy')||'07:10:00','dd-mm-yyyy hh24:mi:ss')))||'.'
            when e.event is null and to_char(sysdate,'hh24mi') > '0710' then 'RBO_SNAP не готов, время задержки = '||
                       extract (hour from (systimestamp-to_date(to_char(sysdate,'dd-mm-yyyy')||'07:10:00','dd-mm-yyyy hh24:mi:ss')))||
                       ':'||extract (minute from (systimestamp-to_date(to_char(sysdate,'dd-mm-yyyy')||'07:10:00','dd-mm-yyyy hh24:mi:ss')))||'.'
            when e.event is null and to_char(sysdate,'hh24mi') between '0000' and '0710' then 'RBO_SNAP не готов, приблизительное время готовности в 07:10.'
       else null end as comments,
       case when e.event is not null and to_char(e.e_timestamp,'hh24mi') between '0000' and '0710' then 'OK'
            when e.event is not null and to_char(e.e_timestamp,'hh24mi') > '0710' then 'OK WITH TIMEOUT'
            when e.event is null and to_char(sysdate,'hh24mi') > '0710' then 'ERROR'
            when e.event is null and to_char(sysdate,'hh24mi') between '0000' and '0710' then 'PROCESSING'
       else null end as process_status,
       '#1#2#4#' as process_dependence
  from (select 'RBO_SNAP_READY' proc_name from dual) t
  left join daily_update_event e on e.event = t.proc_name and trunc(e.e_date) = trunc(sysdate)
union all
select t.proc_name,
       4 as process_priority,
       (select to_date(to_char(min(dl.p_begin),'dd-mm-yyyy hh24:mi:ss'),'dd-mm-yyyy hh24:mi:ss') from daily_update_log dl
         where dl.p_date = l.p_date and dl.proc_type = l.proc_type) as date_process_start,
       to_date(to_char(e.e_timestamp,'dd-mm-yyyy hh24:mi'),'dd-mm-yyyy hh24:mi:ss'),
       case when count(distinct l.process) = 16 and to_char(e.e_timestamp,'hh24mi') between '0000' and '0845' then 'Основной процесс загрузки завершен вовремя.'
            when count(distinct l.process) = 16 and to_char(e.e_timestamp,'hh24mi') > '0845' then 'Основной процесс загрузки завершен, время задержки '||
                       extract (hour from (e.e_timestamp-to_date(to_char(sysdate,'dd-mm-yyyy')||'08:45:00','dd-mm-yyyy hh24:mi:ss')))||
                       ':'||extract (minute from (e.e_timestamp-to_date(to_char(sysdate,'dd-mm-yyyy')||'08:45:00','dd-mm-yyyy hh24:mi:ss')))||'.'
            when count(distinct l.process) != 16 and to_char(sysdate,'hh24mi') > '0845' and
                 (nvl((select to_number(to_char(min(p_begin),'hh24mi')) from daily_update_log dl
                   where dl.p_date = l.p_date and dl.proc_type = l.proc_type),0200) <= 0230)
              then 'Ошибка. Загрузка основного процесса не завершена. Количество завершенных процессов '||count(distinct l.process)||' из 16.'
            when count(distinct l.process) != 16 and nvl(to_char(sysdate,'hh24mi'),'0000') between '0000' and '0845'
              then 'Загрузка основного процесса должна быть завершена к 08:45. Количество завершенных процессов '||count(distinct l.process)||' из 16.'
       else null end as comments,
       case when count(distinct l.process) = 16 and to_char(e.e_timestamp,'hh24mi') between '0000' and '0845' then 'OK'
            when count(distinct l.process) = 16 and to_char(e.e_timestamp,'hh24mi') > '0845' then 'OK WITH TIMEOUT'
            when count(distinct l.process) != 16 and nvl(to_char(sysdate,'hh24mi'),'0000') between '0000' and '0845' then 'PROCESSING'
            when count(distinct l.process) != 16 and to_char(sysdate,'hh24mi') > '0845' and
                 (nvl((select to_number(to_char(min(p_begin),'hh24mi')) from daily_update_log dl
                   where dl.p_date = l.p_date and dl.proc_type = l.proc_type),0200) <= 0230) then 'ERROR'
            when count(distinct l.process) != 16 and count(distinct ul.process) != 0 then 'PROCESSING'
       else null end as process_status,
       '#1#2#' as process_dependence
 from (select 'MAIN' proc_name from dual) t
 left join daily_update_log l on l.proc_type = t.proc_name
                             and l.p_status = 'COMPLETE'
                             and trunc(l.p_date) = trunc(sysdate)
 left join daily_update_log ul on ul.proc_type = t.proc_name
                             and ul.p_status = 'PROCESSING'
                             and trunc(ul.p_date) = trunc(sysdate)
 left join daily_update_event e on e.event = 'PROCESS_COMPLETE' and trunc(e.e_date) = trunc(sysdate)
 group by t.proc_name, e.e_timestamp, l.p_date, l.proc_type
union all
select t.proc_name,
       5 as process_priority,
       (select to_date(to_char(min(p_begin),'dd-mm-yyyy hh24:mi:ss'),'dd-mm-yyyy hh24:mi:ss') from daily_update_log dl
         where dl.p_date = l.p_date and dl.proc_type = l.proc_type) as date_process_start,
       to_date(to_char(e.e_timestamp,'dd-mm-yyyy hh24:mi'),'dd-mm-yyyy hh24:mi:ss'),
       case when count(distinct l.process) = 2 and to_char(e.e_timestamp,'hh24mi') between '0000' and '0930'
                 then 'Дополнительный процесс загрузки завершен вовремя.'
            when count(distinct l.process) = 2 and to_char(e.e_timestamp,'hh24mi') > '0930'
                 then 'Дополнительный процесс загрузки завершен, время задержки '||
                       extract (hour from (e.e_timestamp-to_date(to_char(sysdate,'dd-mm-yyyy')||'09:30:00','dd-mm-yyyy hh24:mi:ss')))||
                       ':'||extract (minute from (e.e_timestamp-to_date(to_char(sysdate,'dd-mm-yyyy')||'09:30:00','dd-mm-yyyy hh24:mi:ss')))||'.'
            when count(distinct l.process) != 2 and to_char(sysdate,'hh24mi') > '0930' and
                 (nvl((select to_number(to_char(min(p_begin),'hh24mi')) from daily_update_log dl
                   where dl.p_date = l.p_date and dl.proc_type = l.proc_type),0700) <= 0800 )
                 then 'Ошибка. Загрузка дополнительного процесса не завершена. Количество завершенных процессов '||count(distinct l.process)||' из 2.'
            when count(distinct l.process) != 2 and nvl(to_char(sysdate,'hh24mi'),'0000') between '0000' and '0930'
                 then 'Загрузка дополнительного процесса должна быть завершена к 09:30. Количество завершенных процессов '||count(distinct l.process)||' из 2.'
       else null end as comments,
       case when count(distinct l.process) = 2 and to_char(e.e_timestamp,'hh24mi') between '0000' and '0930' then 'OK'
            when count(distinct l.process) = 2 and to_char(e.e_timestamp,'hh24mi') > '0930' then 'OK WITH TIMEOUT'
            when count(distinct l.process) != 2 and nvl(to_char(sysdate,'hh24mi'),'0000') between '0000' and '0930' then 'PROCESSING'
            when count(distinct l.process) != 2 and to_char(sysdate,'hh24mi') > '0930' and
                 (nvl((select to_number(to_char(min(p_begin),'hh24mi')) from daily_update_log dl
                   where dl.p_date = l.p_date and dl.proc_type = l.proc_type),0700) <= 0800 ) then 'ERROR'
            when count(distinct l.process) != 2 and count(distinct ul.process) != 0 then 'PROCESSING'
       else null end as process_status,
       '#1#2#4#' as process_dependence
 from (select 'ADD' proc_name from dual) t
 left join daily_update_log l on l.proc_type = t.proc_name
                             and l.p_status = 'COMPLETE' and trunc(l.p_date) = trunc(sysdate)
 left join daily_update_log ul on ul.proc_type = t.proc_name
                             and ul.p_status = 'PROCESSING'
                             and trunc(ul.p_date) = trunc(sysdate)
 left join daily_update_event e on e.event = 'PROCESS_ADD_COMPLETE' and trunc(e.e_date) = trunc(sysdate)
 group by t.proc_name, e.e_timestamp, l.p_date, l.proc_type
union all
select t.proc_name,
       6 as process_priority,
       (select to_date(to_char(min(p_begin),'dd-mm-yyyy hh24:mi:ss'),'dd-mm-yyyy hh24:mi:ss') from daily_update_log dl
         where dl.p_date = l.p_date and dl.proc_type = l.proc_type) as date_process_start,
       to_date(to_char(e.e_timestamp,'dd-mm-yyyy hh24:mi'),'dd-mm-yyyy hh24:mi:ss'),
       case when count(distinct l.process) = 8 and to_char(e.e_timestamp,'hh24mi') between '0000' and '1100'
                 then 'Процесс загрузки RBO завершен вовремя.'
            when count(distinct l.process) = 8 and to_char(e.e_timestamp,'hh24mi') > '1100'
                 then 'Процесс загрузки RBO загрузки завершен, время задержки '||
                       extract (hour from (e.e_timestamp-to_date(to_char(sysdate,'dd-mm-yyyy')||'11:00:00','dd-mm-yyyy hh24:mi:ss')))||
                       ':'||extract (minute from (e.e_timestamp-to_date(to_char(sysdate,'dd-mm-yyyy')||'11:00:00','dd-mm-yyyy hh24:mi:ss')))||'.'
            when count(distinct l.process) != 8 and to_char(sysdate,'hh24mi') > '1100' and
                 (nvl((select to_number(to_char(min(p_begin),'hh24mi')) from daily_update_log dl
                   where dl.p_date = l.p_date and dl.proc_type = l.proc_type),0700) <= 0730 )
                 then 'Ошибка. Загрузка RBO не завершена. Количество завершенных процессов '||count(distinct l.process)||' из 8.'
            when count(distinct l.process) != 8 and nvl(to_char(sysdate,'hh24mi'),'0000') between '0000' and '1100'
                 then 'Загрузка RBO должна быть завершена к 11:00. Количество завершенных процессов '||count(distinct l.process)||' из 8.'
       else null end as comments,
       case when count(distinct l.process) = 8 and to_char(e.e_timestamp,'hh24mi') between '0000' and '1100' then 'OK'
            when count(distinct l.process) = 8 and to_char(e.e_timestamp,'hh24mi') > '1100' then 'OK WITH TIMEOUT'
            when count(distinct l.process) != 8 and nvl(to_char(sysdate,'hh24mi'),'0000') between '0000' and '1100' then 'PROCESSING'
            when count(distinct l.process) != 8 and to_char(sysdate,'hh24mi') > '1100' and
                 (nvl((select to_number(to_char(min(p_begin),'hh24mi')) from daily_update_log dl
                   where dl.p_date = l.p_date and dl.proc_type = l.proc_type),0700) <= 0730 ) then 'ERROR'
            when count(distinct l.process) != 8 and count(distinct ul.process) != 0 then 'PROCESSING'
       else null end as process_status,
       '#1#2#3#' as process_dependence
 from (select 'RBO' proc_name from dual) t
 left join daily_update_log l on l.proc_type = t.proc_name
                             and l.p_status = 'COMPLETE'
                             and trunc(l.p_date) = trunc(sysdate)
 left join daily_update_log ul on ul.proc_type = t.proc_name
                             and ul.p_status = 'PROCESSING'
                             and trunc(ul.p_date) = trunc(sysdate)
 left join daily_update_event e on e.event = 'PROCESS_RBO_COMPLETE' and trunc(e.e_date) = trunc(sysdate)
 where to_char(sysdate,'D') not in ('1','7')
 group by t.proc_name, e.e_timestamp, l.proc_type, l.p_date;
grant select on U1.V_OUT_SYS_CHECK_DAILY_PROC to DSM_USER;
grant select on U1.V_OUT_SYS_CHECK_DAILY_PROC to LOADDB;
grant select on U1.V_OUT_SYS_CHECK_DAILY_PROC to LOADER;


