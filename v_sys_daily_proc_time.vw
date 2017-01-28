create or replace force view u1.v_sys_daily_proc_time as
select t.p_begin,
max(case when process = 'LOAD_RFO_P1' then dur end) as LOAD_RFO_P1,
max(case when process = 'LOAD_RFO_P2' then dur end) as LOAD_RFO_P2,
max(case when process = 'LOAD_RFO_P3' then dur end) as LOAD_RFO_P3,
max(case when process = 'LOAD_RFO_P4' then dur end) as LOAD_RFO_P4,

max(case when process = 'RECALC_RDWH_RFO_P1' then dur end) as RECALC_RDWH_RFO_P1,
max(case when process = 'RECALC_RDWH_RFO_P2' then dur end) as RECALC_RDWH_RFO_P2,
max(case when process = 'RECALC_RDWH_RFO_P3' then dur end) as RECALC_RDWH_RFO_P3,
max(case when process = 'RECALC_RDWH_RFO_P4' then dur end) as RECALC_RDWH_RFO_P4,
max(case when process = 'LOAD_DWH_P1' then dur end) as LOAD_DWH_P1,
max(case when process = 'LOAD_DWH_P2' then dur end) as LOAD_DWH_P2,
max(case when process = 'LOAD_DWH_P3' then dur end) as LOAD_DWH_P3,
max(case when process = 'RECALC_RDWH_P3' then dur end) as RECALC_RDWH_P3,
max(case when process = 'RECALC_RDWH_P1' then dur end) as RECALC_RDWH_P1,
max(case when process = 'RECALC_RDWH_P2' then dur end) as RECALC_RDWH_P2,

max(case when process = 'RECALC_ADD_P1' then dur end) as RECALC_ADD_P1,
max(case when process = 'RECALC_ADD_P2' then dur end) as RECALC_ADD_P2,
max(case when process = 'RECALC_ADD_P3' then dur end) as RECALC_ADD_P3,
max(case when process = 'RECALC_ADD_P4' then dur end) as RECALC_ADD_P4,

--rbo
max(case when process = 'LOAD_RBO_P0' then dur end) as LOAD_RBO_P0,
max(case when process = 'LOAD_RBO_P1' then dur end) as LOAD_RBO_P1,
max(case when process = 'LOAD_RBO_P2' then dur end) as LOAD_RBO_P2,
max(case when process = 'LOAD_RBO_P3' then dur end) as LOAD_RBO_P3,
max(case when process = 'LOAD_RBO_P4' then dur end) as LOAD_RBO_P4,
max(case when process = 'LOAD_RBO_P5' then dur end) as LOAD_RBO_P5,
max(case when process = 'RECALC_RBO_P1' then dur end) as RECALC_RBO_P1,
max(case when process = 'RECALC_RBO_P2' then dur end) as RECALC_RBO_P2,
max(case when process = 'RECALC_RBO_P3' then dur end) as RECALC_RBO_P3,

--mo
max(case when process = 'LOAD_MO' then dur end) as LOAD_MO,
max(case when process = 'UPDATE_MO_D' then dur end) as UPDATE_MO_D,
max(case when process = 'UPDATE_MO_SCO_REQUEST' then dur end) as UPDATE_MO_SCO_REQUEST
   from (
          select t.id,
                 t.process,
                 trunc(t.p_begin) as p_begin,
                 --t.p_detail,
                 round((cast(t.p_end as date) - cast(t.p_begin as date))*24*60, 4) as dur,
               --  t.p_total_min,
                 t.p_status
          from DAILY_UPDATE_LOG t
          where trunc(t.p_begin) > trunc(sysdate)- 180
        )  t

group by t.p_begin
order by t.p_begin
;
grant select on U1.V_SYS_DAILY_PROC_TIME to LOADDB;
grant select on U1.V_SYS_DAILY_PROC_TIME to LOADER;


