create or replace force view u1.v_sys_daily_update_times as
select
  x."E_DATE",
  x."SNAP_RFO_READY",
  x."SNAP_RFO_LOADED",
  x."RFO_ONLY_DATA_PROCESSED",
  x."DWH_READY",
  x."DWH_LOADED",
  x."RFO_AND_DWH_DATA_PROCESSED",
  x."RFO_AND_DWH_ADD_PROCESSED",
  x."PROD_RBO_LOADED",
  x."SNAP_RBO_READY",
  x."SNAP_RBO_LOADED",
  x."RBO_ONLY_DATA_PROCESSED",
  x."MO_LOADED",
  X."COMPLETE",
  snap_rfo_loaded - snap_rfo_ready as snap_rfo_load_dur,
  rfo_only_data_processed - snap_rfo_loaded as rfo_only_data_process_dur,
  dwh_loaded - dwh_ready as dwh_load_dur,
  rfo_and_dwh_data_processed - dwh_loaded as rfo_and_dwh_data_process_dur,
  snap_rbo_loaded - snap_rbo_ready as snap_rbo_load_dur,
  rbo_only_data_processed - snap_rbo_loaded as rbo_only_data_process_dur,
  complete - snap_rfo_ready as total_dur,
  2.5 snap_rfo_ready_limit,
  5.5 dwh_ready_limit,
  7.2 snap_rbo_ready_limit,
  8.25 complete_limit,
  avg(dwh_ready) over (partition by null order by e_date range between 6 preceding and current row) as dwh_ready_ma7
from (
select
    t.e_date,
        min(case when t.event = 'RFO_SNAP_READY' then
            to_number(to_char(cast(t.e_timestamp as date),'hh24'))+
                round(to_number(to_char(cast(t.e_timestamp as date),'mi'))/60,2) end) as
    snap_rfo_ready,
        max(case when t.event like 'RFO_SNAP_P%COMPLETE' then
            to_number(to_char(cast(t.e_timestamp as date),'hh24'))+
                round(to_number(to_char(cast(t.e_timestamp as date),'mi'))/60,2) end) as
    snap_rfo_loaded,
        max(case when t.event like 'RECALC_RDWH_RFO_P%COMPLETE' then
            to_number(to_char(cast(t.e_timestamp as date),'hh24'))+
                round(to_number(to_char(cast(t.e_timestamp as date),'mi'))/60,2) end) as
    rfo_only_data_processed,
    --DWH
        nvl(min(case when t.event = 'DWH_READY' then
            to_number(to_char(cast(t.e_timestamp as date),'hh24'))+
                round(to_number(to_char(cast(t.e_timestamp as date),'mi'))/60,2) end),18) as
    dwh_ready,
        max(case when t.event like 'DWH_P%COMPLETE' then
            to_number(to_char(cast(t.e_timestamp as date),'hh24'))+
                round(to_number(to_char(cast(t.e_timestamp as date),'mi'))/60,2) end) as
    dwh_loaded,
        max(case when t.event like 'RECALC_RDWH_P%COMPLETE' then
            to_number(to_char(cast(t.e_timestamp as date),'hh24'))+
                round(to_number(to_char(cast(t.e_timestamp as date),'mi'))/60,2) end) as
    rfo_and_dwh_data_processed,
        max(case when t.event like 'RECALC_ADD_P%COMPLETE' then
            to_number(to_char(cast(t.e_timestamp as date),'hh24'))+
                round(to_number(to_char(cast(t.e_timestamp as date),'mi'))/60,2) end) as
    rfo_and_dwh_add_processed,
    --RBO
     max(case when t.event like 'RBO_PROD%COMPLETE' then
            to_number(to_char(cast(t.e_timestamp as date),'hh24'))+
                round(to_number(to_char(cast(t.e_timestamp as date),'mi'))/60,2) end) as
    prod_rbo_loaded,
    min(case when t.event = 'RBO_SNAP_READY' then
            to_number(to_char(cast(t.e_timestamp as date),'hh24'))+
                round(to_number(to_char(cast(t.e_timestamp as date),'mi'))/60,2) end) as
    snap_rbo_ready,
        max(case when t.event like 'RBO_SNAP_P%_COMPLETE' then
            to_number(to_char(cast(t.e_timestamp as date),'hh24'))+
                round(to_number(to_char(cast(t.e_timestamp as date),'mi'))/60,2) end) as
    snap_rbo_loaded,
        max(case when t.event like 'RECALC_RBO_P%_COMPLETE' then
            to_number(to_char(cast(t.e_timestamp as date),'hh24'))+
                round(to_number(to_char(cast(t.e_timestamp as date),'mi'))/60,2) end) as
    rbo_only_data_processed,
    --MO
       max(case when t.event like 'MO%COMPLETE' then
            to_number(to_char(cast(t.e_timestamp as date),'hh24'))+
                round(to_number(to_char(cast(t.e_timestamp as date),'mi'))/60,2) end) as
    mo_loaded,

    --
        min(case when t.event = 'PROCESS_COMPLETE' then
            to_number(to_char(cast(t.e_timestamp as date),'hh24'))+
                round(to_number(to_char(cast(t.e_timestamp as date),'mi'))/60,2) end) as
    complete
from DAILY_UPDATE_EVENT t
where t.e_timestamp > trunc(sysdate) - 60
group by t.e_date
) x
order by x.e_date desc
;
grant select on U1.V_SYS_DAILY_UPDATE_TIMES to LOADDB;
grant select on U1.V_SYS_DAILY_UPDATE_TIMES to LOADER;


