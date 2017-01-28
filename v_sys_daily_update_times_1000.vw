create or replace force view u1.v_sys_daily_update_times_1000 as
select
  x."E_DATE",x."SNAP_RFO_READY",x."SNAP_RFO_LOADED",x."RFO_ONLY_DATA_PROCESSED",x."DWH_READY",x."DWH_LOADED",x."RFO_AND_DWH_DATA_PROCESSED",x."COMPLETE",
  snap_rfo_loaded - snap_rfo_ready as snap_rfo_load_dur,
  rfo_only_data_processed - snap_rfo_loaded as rfo_only_data_process_dur,
  dwh_loaded - dwh_ready as dwh_load_dur,
  rfo_and_dwh_data_processed - dwh_loaded as rfo_and_dwh_data_process_dur,
  complete - snap_rfo_ready as total_dur,
  2.5 snap_rfo_ready_limit,
  5.5 dwh_ready_limit,
  8.25 complete_limit,
  avg(dwh_ready) over (partition by null order by e_date range between 6 preceding and current row) as dwh_ready_ma7
from (
select
    t.e_date,
        min(case when t.event = 'RFO_SNAP_READY' then
            to_number(to_char(cast(t.e_timestamp as date),'hh24'))+
                round(to_number(to_char(cast(t.e_timestamp as date),'mi'))/60,2) end) as
    snap_rfo_ready,
        max(case when t.event like 'RFO_SNAP_P%' then
            to_number(to_char(cast(t.e_timestamp as date),'hh24'))+
                round(to_number(to_char(cast(t.e_timestamp as date),'mi'))/60,2) end) as
    snap_rfo_loaded,
        max(case when t.event like 'RECALC_RDWH_RFO_P%' then
            to_number(to_char(cast(t.e_timestamp as date),'hh24'))+
                round(to_number(to_char(cast(t.e_timestamp as date),'mi'))/60,2) end) as
    rfo_only_data_processed,
        nvl(min(case when t.event = 'DWH_READY' then
            to_number(to_char(cast(t.e_timestamp as date),'hh24'))+
                round(to_number(to_char(cast(t.e_timestamp as date),'mi'))/60,2) end),18) as
    dwh_ready,
        max(case when t.event like 'DWH_P%' then
            to_number(to_char(cast(t.e_timestamp as date),'hh24'))+
                round(to_number(to_char(cast(t.e_timestamp as date),'mi'))/60,2) end) as
    dwh_loaded,
        max(case when t.event like 'RECALC_RDWH_P%' then
            to_number(to_char(cast(t.e_timestamp as date),'hh24'))+
                round(to_number(to_char(cast(t.e_timestamp as date),'mi'))/60,2) end) as
    rfo_and_dwh_data_processed,
        min(case when t.event = 'PROCESS_COMPLETE' then
            to_number(to_char(cast(t.e_timestamp as date),'hh24'))+
                round(to_number(to_char(cast(t.e_timestamp as date),'mi'))/60,2) end) as
    complete
from DAILY_UPDATE_EVENT t
where t.e_timestamp > trunc(sysdate) - 1000
group by t.e_date
) x
order by x.e_date;
grant select on U1.V_SYS_DAILY_UPDATE_TIMES_1000 to LOADDB;
grant select on U1.V_SYS_DAILY_UPDATE_TIMES_1000 to LOADER;


