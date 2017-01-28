CREATE OR REPLACE FORCE VIEW U1.V_SYS_OBJECTS_SIZE AS
select /*+ first_rows*/
       s.owner,
       s.segment_name as object_name,
       coalesce(dd.object_type,s.segment_type) as object_type,
       s.tablespace_name,
       s.gbytes,
       dd.min_created_date,
       dd.max_created_date,
       ma.last_refresh_date,
       ma.last_refresh_date + ma.fullrefreshtim/24/60/60 as last_refresh_end_time,
       ma.fullrefreshtim,
       (select listagg(grantee,'#') within group (order by grantee) from dba_tab_privs
         where table_name = s.segment_name
           and owner = s.owner
           and privilege in ('SELECT','EXECUTE')
           ) as grants,
       (select listagg(po.type_load||' - '||po.proc_name,'#') within group (order by po.type_load, po.proc_name)
          from t_rdwh_proc_object po
         where po.object_name = s.segment_name
               and s.owner = 'U1') as type_load,
       cast(case when dd.object_name is null then 1 else null end as varchar2(1)) as is_drop_object,
       coalesce(tc.comments,mc.comments) as comments
  from (select owner, segment_name, tablespace_name, segment_type, round(sum(bytes)/1024/1024/1024,5) as gbytes
          from dba_segments
         where tablespace_name not in ('SYSAUX','SYSTEM')
         group by owner, segment_name, tablespace_name, segment_type) s
  left join (select do.owner, do.object_name, do.object_type,
               case when do.object_type = 'MATERIALIZED VIEW' then 'TABLE' else do.object_type end as obj_type,
               min(do.created) as min_created_date,
               max(do.created) as max_created_date
          from dba_objects do
         where not exists
              (select 1 from dba_objects o where o.object_name = do.object_name
                  and do.object_type = 'TABLE' and o.object_type = 'MATERIALIZED VIEW'
                  and do.owner = o.owner)
         group by do.owner, do.object_name, do.object_type) dd on dd.object_name = s.segment_name
                                                              and dd.owner = s.owner
                                                              and dd.obj_type = s.segment_type
  left join dba_mview_analysis ma on ma.mview_name = s.segment_name
                                 and ma.owner = s.owner
  left join dba_tab_comments   tc on tc.table_name = s.segment_name
                                 and tc.owner = s.owner
  left join dba_mview_comments   mc on mc.mview_name = s.segment_name
                                   and mc.owner = s.owner
 order by s.gbytes desc;
comment on table U1.V_SYS_OBJECTS_SIZE is 'Информация по объектам пользователя U1';
comment on column U1.V_SYS_OBJECTS_SIZE.OWNER is 'Владелец схемы';
comment on column U1.V_SYS_OBJECTS_SIZE.OBJECT_NAME is 'Наименование объекта';
comment on column U1.V_SYS_OBJECTS_SIZE.OBJECT_TYPE is 'Тип объекта';
comment on column U1.V_SYS_OBJECTS_SIZE.TABLESPACE_NAME is 'Наименование табличного пространства';
comment on column U1.V_SYS_OBJECTS_SIZE.GBYTES is 'Размер объекта в Гб';
comment on column U1.V_SYS_OBJECTS_SIZE.MIN_CREATED_DATE is 'Дата создания объекта';
comment on column U1.V_SYS_OBJECTS_SIZE.MAX_CREATED_DATE is 'Дата создания последней партиции';
comment on column U1.V_SYS_OBJECTS_SIZE.LAST_REFRESH_DATE is 'Дата начала обновления объекта';
comment on column U1.V_SYS_OBJECTS_SIZE.LAST_REFRESH_END_TIME is 'Дата окончания обнвления объекта';
comment on column U1.V_SYS_OBJECTS_SIZE.FULLREFRESHTIM is 'Время обновления в секундах';
comment on column U1.V_SYS_OBJECTS_SIZE.GRANTS is 'Пользователя, которым выданы права на объект';
comment on column U1.V_SYS_OBJECTS_SIZE.TYPE_LOAD is 'Тип загрузки';
comment on column U1.V_SYS_OBJECTS_SIZE.IS_DROP_OBJECT is 'Признак удаленного объекта';
comment on column U1.V_SYS_OBJECTS_SIZE.COMMENTS is 'Комментарий';
grant select on U1.V_SYS_OBJECTS_SIZE to LOADDB;
grant select on U1.V_SYS_OBJECTS_SIZE to LOADER;


