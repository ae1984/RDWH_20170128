create or replace force view u1.v_rdwh_object_refresh_time as
select  ul.process,
        ul.p_date,
        po.priority,
        po.object_name,
        round((case when instr(p_detail,po.object_name||' ',1) = 0 or p_detail like '%Errors%' then null
              else to_date(substr(p_detail,instr(p_detail,po.object_name||' ',1)+length(po.object_name)+17,8),'hh24:mi:ss') end-
        case when instr(p_detail,po.object_name||' ',1) = 1 then to_date(to_char(ul.p_begin,'hh24:mi:ss'),'hh24:mi:ss')
                        when instr(p_detail,po.object_name||' ',1) = 0 or p_detail like '%Errors%' then null
                        else to_date(substr(p_detail,instr(p_detail,po.object_name||' ',1)-22,8),'hh24:mi:ss') end)*24*60,2) as obj_total_min
from U1.DAILY_UPDATE_LOG ul
 join t_rdwh_proc_object po on po.object_name||' ' = substr(ul.p_detail,instr(ul.p_detail,po.object_name||' '),length(po.object_name||' '))
where ul.p_date >= trunc(sysdate)-30
    and po.is_used = 1
    and po.proc_name not IN ('RECALC_RBO_P4','LOAD_MO')
    and po.type_load = 'DAILY'
ORDER BY p_date;
comment on table U1.V_RDWH_OBJECT_REFRESH_TIME is 'Мониторинг времени обновления объектов ежедневного пересчета';
comment on column U1.V_RDWH_OBJECT_REFRESH_TIME.PROCESS is 'Название процесса';
comment on column U1.V_RDWH_OBJECT_REFRESH_TIME.P_DATE is 'Дата обновления';
comment on column U1.V_RDWH_OBJECT_REFRESH_TIME.PRIORITY is 'Приоритетность';
comment on column U1.V_RDWH_OBJECT_REFRESH_TIME.OBJECT_NAME is 'Название объекта';
comment on column U1.V_RDWH_OBJECT_REFRESH_TIME.OBJ_TOTAL_MIN is 'Длительность обновления';
grant select on U1.V_RDWH_OBJECT_REFRESH_TIME to LOADDB;
grant select on U1.V_RDWH_OBJECT_REFRESH_TIME to LOADER;


