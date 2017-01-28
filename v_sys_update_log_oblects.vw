create or replace force view u1.v_sys_update_log_oblects as
select d.name                                                                    as name,
       d.type                                                                    as type,
       coalesce(u.begin_refresh,a.last_refresh_date)                             as beg_refresh_name,
       coalesce(u.end_refresh,a.last_refresh_date + (a.fullrefreshtim)/60/60/24) as end_refresh_name,
       d.referenced_name                                                         as referenced_name,
       d.referenced_type                                                         as referenced_type,
       coalesce(uu.begin_refresh,aa.last_refresh_date)                           as beg_refresh_ref_name,
       coalesce(uu.end_refresh,aa.last_refresh_date + (aa.fullrefreshtim)/60/60/24) as end_refresh_ref_name,
       d.d_date                                                                  as d_date,
       case
         when u.end_refresh >= uu.end_refresh
           or u.end_refresh >= (aa.last_refresh_date + (aa.fullrefreshtim)/60/60/24)
           or a.last_refresh_date + (a.fullrefreshtim)/60/60/24 >= uu.end_refresh
           or a.last_refresh_date + (a.fullrefreshtim)/60/60/24 >= (aa.last_refresh_date + (aa.fullrefreshtim)/60/60/24)
           or coalesce(po.type_load,'DAILY') != 'DAILY' then
           'YES'
         else
           'NO'
       end                                       as time_yes_no,
       1                                         as select_number,
       po.type_load                              as referenced_type_load
  from u1.T_RDWH_DEPENDENCIES   d
  left join (select distinct type_load, object_name
               from t_rdwh_proc_object
              where is_used = 1
                and type_load = 'DAILY'
              union all
             select distinct type_load, object_name
               from t_rdwh_proc_object tt
              where is_used = 1
                and type_load != 'DAILY'
                and not exists (select 1 from t_rdwh_proc_object
                                where object_name = tt.object_name
                                  and type_load = 'DAILY'
                                  and is_used = 1))   po on po.object_name = d.referenced_name
  left join u1.UPDATE_LOG       u on               u.object_name = d.name
                                 and      trunc(u.begin_refresh) = d.d_date
  left join u1.UPDATE_LOG      uu on              uu.object_name = d.referenced_name
                                 and     trunc(uu.begin_refresh) = d.d_date
  left join ALL_MVIEW_ANALYSIS  a on                a.mview_name = d.name
                                 and  trunc(a.last_refresh_date) = d.d_date
  left join ALL_MVIEW_ANALYSIS aa on               aa.mview_name = d.referenced_name
                                 and trunc(aa.last_refresh_date) = d.d_date
 where d.d_date = trunc(sysdate)
   and d.type != 'VIEW'
union all
select d.name                                                                    as name,
       d.type                                                                    as type,
       coalesce(u.begin_refresh,a.last_refresh_date)                             as beg_refresh_name,
       coalesce(u.end_refresh,a.last_refresh_date + (a.fullrefreshtim)/60/60/24) as end_refresh_name,
       d.referenced_name                                                         as referenced_name,
       d.referenced_type                                                         as referenced_type,
       coalesce(uu.begin_refresh,aa.last_refresh_date)                           as beg_refresh_ref_name,
       coalesce(uu.end_refresh,aa.last_refresh_date + (aa.fullrefreshtim)/60/60/24) as end_refresh_ref_name,
       d.d_date                                                                  as d_date,
       case
         when (uu.begin_refresh between u.begin_refresh and u.end_refresh
           or uu.end_refresh between u.begin_refresh and u.end_refresh
           or uu.begin_refresh between a.last_refresh_date and a.last_refresh_date + (a.fullrefreshtim)/60/60/24
           or uu.end_refresh between a.last_refresh_date and a.last_refresh_date + (a.fullrefreshtim)/60/60/24
           or aa.last_refresh_date between u.begin_refresh and u.end_refresh
           or aa.last_refresh_date + (aa.fullrefreshtim)/60/60/24 between u.begin_refresh and u.end_refresh)
           and coalesce(po.type_load,'*') = 'DAILY' then
           'NO'
         else
           'YES'
       end                                       as time_yes_no,
       2                                         as select_number,
       po.type_load                              as referenced_type_load
  from u1.T_RDWH_DEPENDENCIES d
  left join (select distinct type_load, object_name
               from t_rdwh_proc_object
              where is_used = 1
                and type_load = 'DAILY'
              union all
             select distinct type_load, object_name
               from t_rdwh_proc_object tt
              where is_used = 1
                and type_load != 'DAILY'
                and not exists (select 1 from t_rdwh_proc_object
                                where object_name = tt.object_name
                                  and type_load = 'DAILY'
                                  and is_used = 1))   po on po.object_name = d.referenced_name
  left join u1.UPDATE_LOG       u on               u.object_name = d.name
                                 and      trunc(u.begin_refresh) = d.d_date
  left join u1.UPDATE_LOG      uu on              uu.object_name = d.referenced_name
                                 and     trunc(uu.begin_refresh) = d.d_date
  left join ALL_MVIEW_ANALYSIS  a on                a.mview_name = d.name
                                 and  trunc(a.last_refresh_date) = d.d_date
  left join ALL_MVIEW_ANALYSIS aa on               aa.mview_name = d.referenced_name
                                 and trunc(aa.last_refresh_date) = d.d_date
 where d.d_date = trunc(sysdate)
   and d.type != 'VIEW'
union all
select d.name                                                                    as name,
       d.type                                                                    as type,
       coalesce(u.begin_refresh,a.last_refresh_date)                             as beg_refresh_name,
       coalesce(u.end_refresh,a.last_refresh_date + (a.fullrefreshtim)/60/60/24) as end_refresh_name,
       d.referenced_name                                                         as referenced_name,
       d.referenced_type                                                         as referenced_type,
       coalesce(uu.begin_refresh,aa.last_refresh_date)                           as beg_refresh_ref_name,
       coalesce(uu.end_refresh,aa.last_refresh_date + (aa.fullrefreshtim)/60/60/24) as end_refresh_ref_name,
       d.d_date                                                                  as d_date,
       case
         when (u.begin_refresh between uu.begin_refresh and uu.end_refresh
           or u.end_refresh between uu.begin_refresh and uu.end_refresh
           or u.begin_refresh between aa.last_refresh_date and aa.last_refresh_date + (aa.fullrefreshtim)/60/60/24
           or u.end_refresh between aa.last_refresh_date and aa.last_refresh_date + (aa.fullrefreshtim)/60/60/24
           or a.last_refresh_date between uu.begin_refresh and uu.end_refresh
           or a.last_refresh_date + (a.fullrefreshtim)/60/60/24 between uu.begin_refresh and uu.end_refresh)
           and coalesce(po.type_load,'*') = 'DAILY' then
           'NO'
         else
           'YES'
       end                                       as time_yes_no,
       3                                         as select_number,
       po.type_load                              as referenced_type_load
  from u1.T_RDWH_DEPENDENCIES d
  left join (select distinct type_load, object_name
               from t_rdwh_proc_object
              where is_used = 1
                and type_load = 'DAILY'
              union all
             select distinct type_load, object_name
               from t_rdwh_proc_object tt
              where is_used = 1
                and type_load != 'DAILY'
                and not exists (select 1 from t_rdwh_proc_object
                                where object_name = tt.object_name
                                  and type_load = 'DAILY'
                                  and is_used = 1))   po on po.object_name = d.referenced_name
  left join u1.UPDATE_LOG       u on               u.object_name = d.name
                                 and      trunc(u.begin_refresh) = d.d_date
  left join u1.UPDATE_LOG      uu on              uu.object_name = d.referenced_name
                                 and     trunc(uu.begin_refresh) = d.d_date
  left join ALL_MVIEW_ANALYSIS  a on                a.mview_name = d.name
                                 and  trunc(a.last_refresh_date) = d.d_date
  left join ALL_MVIEW_ANALYSIS aa on               aa.mview_name = d.referenced_name
                                 and trunc(aa.last_refresh_date) = d.d_date
 where d.d_date = trunc(sysdate)
   and d.type != 'VIEW';
comment on table U1.V_SYS_UPDATE_LOG_OBLECTS is 'Витрина для проверки обновления объектов от ссылочных объектов';
comment on column U1.V_SYS_UPDATE_LOG_OBLECTS.NAME is 'Наименование объекта';
comment on column U1.V_SYS_UPDATE_LOG_OBLECTS.TYPE is 'Тип объекта';
comment on column U1.V_SYS_UPDATE_LOG_OBLECTS.BEG_REFRESH_NAME is 'Дата начала обновления объекта';
comment on column U1.V_SYS_UPDATE_LOG_OBLECTS.END_REFRESH_NAME is 'Дата окончания обновления объекта';
comment on column U1.V_SYS_UPDATE_LOG_OBLECTS.REFERENCED_NAME is 'Наименование ссылочного объекта';
comment on column U1.V_SYS_UPDATE_LOG_OBLECTS.REFERENCED_TYPE is 'Тип ссылочного объекта';
comment on column U1.V_SYS_UPDATE_LOG_OBLECTS.BEG_REFRESH_REF_NAME is 'Дата начала обновления ссылочного объекта';
comment on column U1.V_SYS_UPDATE_LOG_OBLECTS.END_REFRESH_REF_NAME is 'Дата окончания обновления ссылочного объекта';
comment on column U1.V_SYS_UPDATE_LOG_OBLECTS.D_DATE is 'Дата обновления = текущий день';
comment on column U1.V_SYS_UPDATE_LOG_OBLECTS.TIME_YES_NO is 'Результат проверки: NO(ошибка)/YES(без ошибки)';
comment on column U1.V_SYS_UPDATE_LOG_OBLECTS.SELECT_NUMBER is 'Номер селекта(вспомогательное поле)';
comment on column U1.V_SYS_UPDATE_LOG_OBLECTS.REFERENCED_TYPE_LOAD is 'Тип загрузки ссылочного объекта';
grant select on U1.V_SYS_UPDATE_LOG_OBLECTS to LOADDB;


