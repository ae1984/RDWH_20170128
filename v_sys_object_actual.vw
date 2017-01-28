create or replace force view u1.v_sys_object_actual as
select t.proc_name,
       t.object_name,
       t.object_type,
       t.priority,
       case when nvl(dp.is_not_proc_name,0) = 0 then 'Конечная' else to_char(nvl(dp.is_not_proc_name,0)) end as is_not_proc_name,
       case when nvl(dp.is_proc_name,0) = 0 then 'Конечная' else to_char(nvl(dp.is_proc_name,0)) end as is_proc_name,
       case when t.is_main_object = 1 or dad.referenced_name is not null then 1 else 0 end as is_main_object,
       xx.is_mo,
       xx.is_rdboard,
       xx.is_out
  from t_rdwh_proc_object t
  left join (select sum(case when o.proc_name is null and dd.TYPE not in ('PACKAGE BODY','PROCEDURE','FUNCTION') then 1 else 0 end) is_not_proc_name,
                    dd.referenced_name,
                    sum(case when o.proc_name is not null or dd.TYPE in ('PACKAGE BODY','PROCEDURE','FUNCTION') then 1 else 0 end) as is_proc_name
               from dba_dependencies dd
               left join t_rdwh_proc_object o on o.object_name = dd.name
              where dd.name != dd.referenced_name
                and dd.referenced_owner = 'U1'
             group by dd.referenced_name) dp on dp.referenced_name = t.object_name
  left join (select distinct ad.referenced_name
               from
                   (select ad.*
                      from all_dependencies ad
                      join t_rdwh_proc_object po on po.object_name = ad.REFERENCED_NAME
                     where ad.owner = 'U1'
                       and ad.name <> ad.REFERENCED_NAME
                       and po.type_load = 'DAILY'
                       and po.proc_name not like '%LOAD%'
                       and ad.REFERENCED_OWNER = 'U1') ad
               connect by nocycle prior ad.REFERENCED_NAME = ad.name
                 start with ad.name in (select object_name from t_rdwh_proc_object
                                         where type_load = 'DAILY'
                                           and is_main_object = 1))  dad on dad.referenced_name = t.object_name
   left join (select *
                from (select distinct
                             case when grantee = 'LOAD_MO' then 'LOAD_MO'
                                  when grantee = 'LOAD_RDWH_PROD' then 'RDBOARD'
                                  else 'OUT' end as type_out,
                             object_name
                        from V_RDWH_OBJECT_OUT
                      )
               pivot (max(type_out) for type_out in ('LOAD_MO'as is_mo,'RDBOARD' as is_rdboard,'OUT' as is_out))) xx on xx.object_name = t.object_name
 where t.type_load = 'DAILY'
   and t.proc_name not like '%LOAD%'
   and t.proc_name not like '%RBO%'
order by proc_name, priority;
comment on table U1.V_SYS_OBJECT_ACTUAL is 'Данные по объектам ежедневного пересчета на основе РФО/DWH(без LOAD)';
comment on column U1.V_SYS_OBJECT_ACTUAL.PROC_NAME is 'Наименование процесса';
comment on column U1.V_SYS_OBJECT_ACTUAL.OBJECT_NAME is 'Наименование объекта';
comment on column U1.V_SYS_OBJECT_ACTUAL.OBJECT_TYPE is 'Тип объекта';
comment on column U1.V_SYS_OBJECT_ACTUAL.PRIORITY is 'Приоритетность обновления объекта в процессе';
comment on column U1.V_SYS_OBJECT_ACTUAL.IS_NOT_PROC_NAME is 'Количество зависимых объектов, не находящихся в автоматических пересчетах';
comment on column U1.V_SYS_OBJECT_ACTUAL.IS_PROC_NAME is 'Количество зависимых объектов, находящихся в автоматических пересчетах';
comment on column U1.V_SYS_OBJECT_ACTUAL.IS_MAIN_OBJECT is 'Признак основного объекта';
comment on column U1.V_SYS_OBJECT_ACTUAL.IS_MO is 'Используется в базе MO';
comment on column U1.V_SYS_OBJECT_ACTUAL.IS_RDBOARD is 'Используется в базе RDBBOARD';
comment on column U1.V_SYS_OBJECT_ACTUAL.IS_OUT is 'Используется внешними подразделениями';
grant select on U1.V_SYS_OBJECT_ACTUAL to LOADDB;
grant select on U1.V_SYS_OBJECT_ACTUAL to LOADER;


