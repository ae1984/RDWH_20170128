create or replace force view u1.v_sys_daily_process_time as
select t.process,
       trunc(t.p_begin) as p_begin,
       round((cast(t.p_end as date) - cast(t.p_begin as date))*24*60, 4) as dur,
       t.p_status
from DAILY_UPDATE_LOG t
where t.p_begin > trunc(sysdate) - 30
and p_status = 'COMPLETE'
union all
select process,
       trunc(p_begin) as p_begin,
      round((max(p_end) - min(p_begin))*24*60, 4) as dur,
     --  max(p_end) - min(p_begin)  as   p_total_min,
       p_status
       from (
          select t.id,
                 case when t.process like 'LOAD_RFO_P%' then 'LOAD_RFO'
                      when  t.process in ('LOAD_RBO_P1','LOAD_RBO_P2','LOAD_RBO_P3') then 'LOAD_RBO_P123'
                      when  t.process in ('LOAD_RBO_P4','LOAD_RBO_P5') then 'LOAD_RBO_P45'
                      when  t.process like 'LOAD_DWH_P%' then 'LOAD_DWH'
                      when  t.process in ('RECALC_RDWH_RFO_P1','RECALC_RDWH_RFO_P2','RECALC_RDWH_RFO_P3') then 'RECALC_RDWH_RFO_P123'
                      when  t.process in ('RECALC_RDWH_RFO_P4','RECALC_RDWH_RFO_P5') then 'RECALC_RDWH_RFO_P45'
                      when  t.process in ('RECALC_RDWH_P1','RECALC_RDWH_P2') then 'RECALC_RDWH_P12'
                      when  t.process in ('LOAD_MO','UPDATE_MO_D','UPDATE_MO_SCO_REQUEST') then 'LOAD_MO'
                      when t.process like 'RECALC_ADD_P%' then 'RECALC_ADD'
                      when t.process like 'LOAD_RFO_P%' then 'LOAD_RFO'
                      ELSE NULL
                 end as PROCESS  ,
                 cast(t.p_end as date) as  p_end,
                 cast(t.p_begin as date) as p_begin,
                 t.p_status
          from DAILY_UPDATE_LOG t
          where t.p_begin > trunc(sysdate) - 30
          and p_status = 'COMPLETE'
          order by p_begin)
          where process is not null
group by process,p_status,trunc(p_begin)
order by p_begin
;
comment on table U1.V_SYS_DAILY_PROCESS_TIME is 'Мониторинг времени работы процессов ежедневного пересчета по отдельности и общее';
comment on column U1.V_SYS_DAILY_PROCESS_TIME.PROCESS is 'Навание процесса пересчета';
comment on column U1.V_SYS_DAILY_PROCESS_TIME.P_BEGIN is 'Дата пересчета';
comment on column U1.V_SYS_DAILY_PROCESS_TIME.DUR is 'Продолжительность';
comment on column U1.V_SYS_DAILY_PROCESS_TIME.P_STATUS is 'Статус';
grant select on U1.V_SYS_DAILY_PROCESS_TIME to LOADDB;
grant select on U1.V_SYS_DAILY_PROCESS_TIME to LOADER;


