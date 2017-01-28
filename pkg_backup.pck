create or replace package u1.PKG_BACKUP is

  -- Author  : ANTON
  -- Created : 06.03.2013 11:50:22
  -- Purpose : 

  -- Экспорт DB LINK ddl в файл
  /*procedure ddl_dblink_tofile(pFile_name in varchar2 default 'dblink_test.sql',
                              pDir in varchar2 default 'DATA_PUMP_DIR',
                              pOwner in varchar2 default 'USER_1');*/

  -- Экспорт MATERIALIZED VIEW ddl в файл
  procedure ddl_mview_tofile(pFile_name in varchar2 default 'mview_test.sql',
                             pDir in varchar2 default 'DATA_PUMP_DIR',
                             pOwner in varchar2 default 'U1');

  -- Экспорт TABLE ddl в файл
  /*procedure ddl_table_tofile(pFile_name in varchar2 default 'table_test.sql',
                             pDir in varchar2 default 'DATA_PUMP_DIR',
                             pOwner in varchar2 default 'USER_1');*/

  -- Ежедневное создание дампа БД EE28
  procedure daily_ee28_bu;
  
  -- создание полного дампа БД EE28
  procedure full_ee28_bu;
  
  -- Получить процент выполнения JOB DBMS_DATAPUMP
  function dpjob_get_percent(pJobName in varchar2,
                             pUser in varchar2 default 'U1') return varchar2 ;
  
  -- Остановить JOB DBMS_DATAPUMP
  procedure dpjob_stop_immediate(pJobName in varchar2,
                                 pUser in varchar2 default 'U1');


end PKG_BACKUP;
/

create or replace package body u1.PKG_BACKUP is


  -- информация по текущим процессам:
  -- SELECT j.* FROM dba_datapump_jobs j
  
  -- форматируем ddl так как нам нужно
  function ddl_trim(pStr in clob) return clob
  is
    vStr clob;
  begin
    vStr := trim(pStr);
    vStr := trim(both chr(10) from vStr);
    vStr := trim(vStr) || ';' || chr(10) || chr(10);
    return(vStr);
  exception
    when others then
      log_error (in_operation => 'pkg_backup.ddl_trim',
                 in_error_code => sqlcode,
                 in_error_message => sqlerrm,
                 in_object_type => null,
                 in_object_id => null);   
  end ddl_trim;  


  -- Экспорт DB LINK ddl в файл
  /*procedure ddl_dblink_tofile(pFile_name in varchar2 default 'dblink_test.sql',
                              pDir in varchar2 default 'DATA_PUMP_DIR',
                              pOwner in varchar2 default 'USER_1')
  is
    vResult clob;
    bom_raw RAW (3); 
  begin
    -- добавляем byte order mark для utf8 файла
    bom_raw := HEXTORAW('EFBBBF'); 
    vResult := UTL_I18N.raw_to_nchar(bom_raw, 'UTF8');
  
    for cur in (select dl.db_link,
                       dbms_metadata.get_ddl('DB_LINK', dl.db_link, dl.owner) ddl
                  from all_db_links dl
                 where dl.owner = pOwner) loop
      
      vResult := vResult || ddl_trim(cur.ddl);
    end loop;

    -- пишем в файл
    DBMS_XSLPROCESSOR.clob2file(vResult,
                                pDir,
                                pFile_name);

  exception
    when others then
      log_error (in_operation => 'pkg_backup.ddl_dblink_tofile',
                 in_error_code => sqlcode,
                 in_error_message => sqlerrm,
                 in_object_type => null,
                 in_object_id => null);   
  end ddl_dblink_tofile;*/


  -- Экспорт MATERIALIZED VIEW ddl в файл
  procedure ddl_mview_tofile(pFile_name in varchar2 default 'mview_test.sql',
                             pDir in varchar2 default 'DATA_PUMP_DIR',
                             pOwner in varchar2 default 'U1')
  is
    --vStr clob;
    vResult clob;
    bom_raw RAW (3); 
  begin
    -- добавляем byte order mark для utf8 файла
    bom_raw := HEXTORAW('EFBBBF'); 
    vResult := UTL_I18N.raw_to_nchar(bom_raw, 'UTF8');
  
    for mcur in (select mv.mview_name,
                        dbms_metadata.get_ddl('MATERIALIZED_VIEW', mv.mview_name, mv.owner) ddl,
                        (select count(i.index_name) 
                           from all_indexes i 
                          where i.table_name = mv.mview_name
                            and i.owner = mv.owner) ind_cnt,       -- индексы
                        (select count(c.constraint_name) 
                           from all_constraints c 
                          where c.table_name = mv.mview_name
                            and c.owner = mv.owner) cons_cnt,      -- констрейнты
                        (select count(t.trigger_name) 
                           from all_triggers t 
                          where t.table_name = mv.mview_name
                            and t.owner = mv.owner) trig_cnt,      -- триггеры
                        (select count(tp.table_name) 
                           from all_tab_privs tp 
                          where tp.table_name = mv.mview_name 
                            and tp.table_schema = mv.owner) grant_cnt, -- гранты
                        (select tc.comments 
                           from all_tab_comments tc 
                          where tc.table_name = mv.mview_name
                            and tc.owner = mv.owner) tab_comment, -- коментарий к таблице
                        (select count(cc.comments) 
                           from all_col_comments cc 
                          where cc.table_name = mv.mview_name
                            and cc.owner = mv.owner) ccom_cnt     -- комментарии колонок

                   from all_mviews mv
                  where mv.owner = pOwner
                  -- сначала выгружаем вьюхи, которые обновились сегодня в порядке обновления, потом все остальные
                  order by (case when trunc(sysdate - 1) = trunc(mv.last_refresh_date) then 0 else 1 end), mv.last_refresh_date) loop
                  
      vResult := vResult || '-- Создаем мат. представление ' || mcur.mview_name || chr(10);
      vResult := vResult || ddl_trim(mcur.ddl); 
      
      -- выгружаем индексы
      if mcur.ind_cnt > 0 then
        for icur in (select i.index_name,
                            dbms_metadata.get_ddl('INDEX', i.index_name, i.owner) ddl
                       from all_indexes i 
                      where i.table_name = mcur.mview_name
                        and i.owner = pOwner) loop
          vResult := vResult || ddl_trim(icur.ddl);
        end loop;
      end if;

      -- выгружаем констрейнты
      if mcur.cons_cnt > 0 then
        for ccur in (select c.constraint_name,
                            dbms_metadata.get_ddl('CONSTRAINT', c.constraint_name, c.owner) ddl
                       from all_constraints c 
                      where c.table_name = mcur.mview_name
                        and c.owner = pOwner) loop
          vResult := vResult || ddl_trim(ccur.ddl);
        end loop;
      end if;

      -- выгружаем триггеры
      if mcur.trig_cnt > 0 then
        for tcur in (select t.trigger_name,
                            dbms_metadata.get_ddl('TRIGGER', t.trigger_name, t.owner) ddl
                       from all_triggers t 
                      where t.table_name = mcur.mview_name
                        and t.owner = pOwner) loop
          vResult := vResult || ddl_trim(tcur.ddl);
        end loop;
      end if;

      -- выгружаем гранты
      if mcur.grant_cnt > 0 then
        for pcur in (select UPPER(p.table_schema) table_schema, 
                            UPPER(p.table_name) table_name, 
                            UPPER(p.privilege) privilege, 
                            UPPER(p.grantee) grantee
                       from all_tab_privs p 
                      where p.table_name = mcur.mview_name
                        and p.table_schema = pOwner) loop
          vResult := vResult || 'GRANT ' || pcur.privilege || ' ON ' || pcur.table_schema || '.' || pcur.table_name || ' TO ' || pcur.grantee || ';' || chr(10);
        end loop;
        vResult := vResult || chr(10);
      end if;

      -- выгружаем коментарий к таблице
      if mcur.tab_comment is not null then
        vResult := vResult || 'COMMENT ON TABLE ' || UPPER(mcur.mview_name) || ' IS ''' || mcur.tab_comment || ''';' || chr(10) || chr(10);
      end if;

      -- выгружаем комментарии к колонкам
      if mcur.ccom_cnt > 0 then
        for ccur in (select UPPER(cc.table_name) table_name,
                            UPPER(cc.column_name) column_name,
                            cc.comments
                       from all_col_comments cc 
                      where cc.table_name = mcur.mview_name
                        and trim(cc.column_name) is not null
                        and cc.owner = pOwner) loop
          vResult := vResult || 'COMMENT ON COLUMN ' || ccur.table_name || '.' || ccur.column_name || ' IS ''' || ccur.comments || ''';' || chr(10);
        end loop;
        vResult := vResult || chr(10);
      end if;
            
    end loop;

    -- пишем в файл
    DBMS_XSLPROCESSOR.clob2file(vResult,
                                pDir,
                                pFile_name);

  exception
    when others then
      log_error (in_operation => 'pkg_backup.ddl_mview_tofile',
                 in_error_code => sqlcode,
                 in_error_message => sqlerrm,
                 in_object_type => null,
                 in_object_id => null);   
  end ddl_mview_tofile;


  -- Экспорт TABLE ddl в файл
  /*procedure ddl_table_tofile(pFile_name in varchar2 default 'table_test.sql',
                             pDir in varchar2 default 'DATA_PUMP_DIR',
                             pOwner in varchar2 default 'USER_1')
  is
    --vStr clob;
    vResult clob;
    bom_raw RAW (3); 
  begin
    -- добавляем byte order mark для utf8 файла
    bom_raw := HEXTORAW('EFBBBF'); 
    vResult := UTL_I18N.raw_to_nchar(bom_raw, 'UTF8');
  
    for tbcur in (select tb.table_name,
                        dbms_metadata.get_ddl('TABLE', tb.table_name, tb.owner) ddl,
                        (select count(t.trigger_name) 
                           from all_triggers t 
                          where t.table_name = tb.table_name 
                            and t.owner = tb.owner) trig_cnt,        -- триггеры
                        (select count(tp.table_name) 
                           from all_tab_privs tp 
                          where tp.table_name = tb.table_name 
                            and tp.table_schema = tb.owner) grant_cnt, -- гранты
                        (select tc.comments 
                           from all_tab_comments tc 
                          where tc.table_name = tb.table_name
                            and tc.owner = tb.owner) tab_comment,    -- коментарий к таблице
                        (select count(cc.comments) 
                           from all_col_comments cc 
                          where cc.table_name = tb.table_name
                            and cc.owner = tb.owner) ccom_cnt      -- комментарии колонок
                   from all_tables tb
                  where tb.owner = pOwner
                    and not tb.table_name in (select mv.mview_name from all_mviews mv where mv.owner = pOwner)
                  order by tb.table_name) loop
                  
      vResult := vResult || '-- Создаем таблицу ' || tbcur.table_name || chr(10);
      vResult := vResult || ddl_trim(tbcur.ddl);
      
      -- выгружаем триггеры
      if tbcur.trig_cnt > 0 then
        for tcur in (select t.trigger_name,
                            dbms_metadata.get_ddl('TRIGGER', t.trigger_name, t.owner) ddl
                       from all_triggers t 
                      where t.table_name = tbcur.table_name
                        and t.owner = pOwner) loop
          vResult := vResult || ddl_trim(tcur.ddl);
        end loop;
      end if;

      -- выгружаем гранты
      if tbcur.grant_cnt > 0 then
        for pcur in (select UPPER(p.table_schema) table_schema, 
                            UPPER(p.table_name) table_name, 
                            UPPER(p.privilege) privilege, 
                            UPPER(p.grantee) grantee
                       from all_tab_privs p 
                      where p.table_name = tbcur.table_name
                        and p.table_schema = pOwner) loop
          vResult := vResult || 'GRANT ' || pcur.privilege || ' ON ' || pcur.table_schema || '.' || pcur.table_name || ' TO ' || pcur.grantee || ';' || chr(10);
        end loop;
        vResult := vResult || chr(10);
      end if;

      -- выгружаем коментарий к таблице
      if tbcur.tab_comment is not null then
        vResult := vResult || 'COMMENT ON TABLE ' || UPPER(tbcur.table_name) || ' IS ''' || tbcur.tab_comment || ''';' || chr(10) || chr(10);
      end if;

      -- выгружаем комментарии к колонкам
      if tbcur.ccom_cnt > 0 then
        for ccur in (select UPPER(cc.table_name) table_name,
                            UPPER(cc.column_name) column_name,
                            cc.comments
                       from all_col_comments cc 
                      where cc.table_name = tbcur.table_name
                        and trim(cc.column_name) is not null
                        and cc.owner = pOwner) loop
          vResult := vResult || 'COMMENT ON COLUMN ' || ccur.table_name || '.' || ccur.column_name || ' IS ''' || ccur.comments || ''';' || chr(10);
        end loop;
        vResult := vResult || chr(10);
      end if;

    end loop;

    -- пишем в файл
    DBMS_XSLPROCESSOR.clob2file(vResult,
                                pDir,
                                pFile_name);

  exception
    when others then
      log_error (in_operation => 'pkg_backup.ddl_table_tofile',
                 in_error_code => sqlcode,
                 in_error_message => sqlerrm,
                 in_object_type => null,
                 in_object_id => null);   
  end ddl_table_tofile;*/



  -- Ежедневное создание дампа БД EE28
  procedure daily_ee28_bu
  is
    vHandler NUMBER;               -- Data Pump job handle
    vTime_label VARCHAR2(30);      -- метка будет использоваться в именах объектов, созданных в процессе
    vJob_name VARCHAR2(30);        -- имя DATAPUMP JOB
    vTable_list VARCHAR2(2000);    -- Список таблиц, которые выгружаем

    vBU_Dir CONSTANT VARCHAR2(32) := 'DATA_PUMP_DIR';  -- директория, где будут сохраняться бэкапы
    vOwner CONSTANT VARCHAR2(32) := 'U1';  -- схема, которую выгружаем

    vTable_exclude_list CONSTANT VARCHAR2(400) :=  -- Список таблиц, которые НЕ выгружаем
        '''T1'',' ||
        '''TABLE_TEST'',' ||
        '''TEMP_IIN_30_85''';
    
  begin
    vTime_label := 'RDWH_' || to_char(sysdate, 'yyyymmdd_hh24miss');

    vJob_name := 'JOB_RDWH_BACKUP';

    -- выгружаем ddl дблинков    
/*    ddl_dblink_tofile(pFile_name => vTime_label || '_DBLINK.SQL',
                      pDir => vBU_Dir,
                      pOwner => vOwner);
*/
    -- выгружаем ddl мат. представлений
    ddl_mview_tofile(pFile_name => vTime_label || '_MVIEW.SQL',
                     pDir => vBU_Dir,
                     pOwner => vOwner);

    -- выгружаем ddl таблиц
/*    ddl_table_tofile(pFile_name => vTime_label || '_TABLE.SQL',
                     pDir => vBU_Dir,
                     pOwner => vOwner);*/
    
    -- формируем список таблиц для экспорта
    for tbcur in (select tb.table_name
                    from all_tables tb
                   where tb.owner = vOwner
                     and not tb.table_name in (select mv.mview_name from all_mviews mv where mv.owner = vOwner) -- исключаем из списка таблицы мат. представлений
                     and instr(vTable_exclude_list, '''' || tb.TABLE_NAME || '''') = 0 -- исключаем из списка ненужные таблицы
                   order by tb.table_name) loop
      vTable_list := vTable_list || ',''' || tbcur.table_name || '''';
    end loop;
    vTable_list := '(' || substr(vTable_list, 2) || ')';
    
    vHandler := dbms_datapump.open (operation   => 'EXPORT',
                                    --job_mode    => 'TABLE',
                                    job_mode    => 'SCHEMA',
                                    job_name    => vJob_name,
                                    version     => 'LATEST');

    dbms_datapump.set_parallel (handle => vHandler, degree => 4);

    dbms_datapump.add_file (handle      => vHandler,
                            filename    => vTime_label || '.LOG',
                            directory   => vBU_Dir,
                            filetype    => 3);

    dbms_datapump.metadata_filter (handle   => vHandler,
                                   name     => 'SCHEMA_EXPR',
                                   VALUE    => 'IN(''' || vOwner || ''')');

    dbms_datapump.metadata_filter (handle   => vHandler,
                                   name     => 'EXCLUDE_PATH_EXPR',
                                   VALUE    => 'IN(''DB_LINK'',''MATERIALIZED_VIEW'',''MATERIALIZED_VIEW_LOG'')');

    dbms_datapump.metadata_filter (handle   => vHandler,
                                   name     => 'NAME_EXPR',
                                   VALUE    => 'IN' || vTable_list,
                                   object_path => 'TABLE');

    dbms_datapump.add_file (handle      => vHandler,
                            filename    => vTime_label || '_%u.DMP',  -- %u - кол-во dmp файлов зависит от кол-ва процессов
                            directory   => vBU_Dir,
                            filetype    => 1);

    dbms_datapump.set_parameter (handle   => vHandler,
                                 name     => 'INCLUDE_METADATA',
                                 VALUE    => 1);

    dbms_datapump.set_parameter (handle   => vHandler,
                                 name     => 'DATA_ACCESS_METHOD',
                                 VALUE    => 'AUTOMATIC');

    dbms_datapump.start_job (handle => vHandler, skip_current => 0, abort_step => 0);

    dbms_datapump.detach (handle => vHandler);

  exception
    when others then
      log_error (in_operation => 'pkg_backup.daily_ee28_bu',
                 in_error_code => sqlcode,
                 in_error_message => sqlerrm,
                 in_object_type => null,
                 in_object_id => null);  
  end daily_ee28_bu;


  -- создание полного дампа БД EE28
  procedure full_ee28_bu
  is
    vHandler NUMBER;               -- Data Pump job handle
    vTime_label VARCHAR2(30);      -- метка будет использоваться в именах объектов, созданных в процессе
    vJob_name VARCHAR2(30);        -- имя DATAPUMP JOB

    vBU_Dir CONSTANT VARCHAR2(32) := 'DATA_PUMP_DIR';  -- директория, где будут сохраняться бэкапы
    vOwner CONSTANT VARCHAR2(32) := 'U1';  -- схема, которую выгружаем
    
  begin
    vTime_label := 'RDWH_FULL_' || to_char(sysdate, 'yyyymmdd_hh24miss');

    vJob_name := 'JOB_RDWH_BACKUP_FULL';
    
    vHandler := dbms_datapump.open (operation   => 'EXPORT',
                                    job_mode    => 'SCHEMA',
                                    job_name    => vJob_name,
                                    version     => 'LATEST');

    dbms_datapump.set_parallel (handle => vHandler, degree => 4);

    dbms_datapump.add_file (handle      => vHandler,
                            filename    => vTime_label || '.LOG',
                            directory   => vBU_Dir,
                            filetype    => 3);

    dbms_datapump.metadata_filter (handle   => vHandler,
                                   name     => 'SCHEMA_EXPR',
                                   VALUE    => 'IN(''' || vOwner || ''')');

    dbms_datapump.add_file (handle      => vHandler,
                            filename    => vTime_label || '_%u.DMP',  -- %u - кол-во dmp файлов зависит от кол-ва процессов
                            directory   => vBU_Dir,
                            filetype    => 1);

    dbms_datapump.set_parameter (handle   => vHandler,
                                 name     => 'INCLUDE_METADATA',
                                 VALUE    => 1);

    dbms_datapump.set_parameter (handle   => vHandler,
                                 name     => 'DATA_ACCESS_METHOD',
                                 VALUE    => 'AUTOMATIC');

    dbms_datapump.start_job (handle => vHandler, skip_current => 0, abort_step => 0);

    dbms_datapump.detach (handle => vHandler);

  exception
    when others then
      log_error (in_operation => 'pkg_backup.full_ee28_bu',
                 in_error_code => sqlcode,
                 in_error_message => sqlerrm,
                 in_object_type => null,
                 in_object_id => null);  
  end full_ee28_bu;


  -- Получить процент выполнения JOB DBMS_DATAPUMP
  -- Антон: очень долго считает!
  function dpjob_get_percent(pJobName in varchar2,
                             pUser in varchar2 default 'U1') return varchar2 
  is
    vHandler number;
    percent_done NUMBER;     -- Percentage of job complete
    sts ku$_Status;          -- The status object returned by get_status
    js ku$_JobStatus;        -- The job status from get_status
    job_state VARCHAR2(100);
  begin
    percent_done := 0;

    vHandler := dbms_datapump.attach(pJobName, pUser);
    dbms_datapump.get_status(vHandler,
                             dbms_datapump.ku$_status_job_error +
                             dbms_datapump.ku$_status_job_status +
                             dbms_datapump.ku$_status_wip,-1,job_state,sts);
    js := sts.job_status;

    percent_done := js.percent_done;
    dbms_output.put_line('job_state=' || job_state || '; percent_done=' || percent_done);  
    dbms_datapump.detach(vHandler);

  return percent_done;

  exception
    when others then
      log_error (in_operation => 'pkg_backup.dpjob_get_percent',
                 in_error_code => sqlcode,
                 in_error_message => sqlerrm,
                 in_object_type => pJobName,
                 in_object_id => null);    
  end dpjob_get_percent;


  -- Остановить JOB DBMS_DATAPUMP
  procedure dpjob_stop_immediate(pJobName in varchar2,
                                 pUser in varchar2 default 'U1')  
  is
    vHandler number;
  begin
    
    vHandler := dbms_datapump.attach(job_name => pJobName, job_owner => pUser);
    dbms_datapump.stop_job(handle => vHandler,immediate => 1);
    
  exception
    when others then
      log_error (in_operation => 'pkg_backup.dpjob_stop_immediate',
                 in_error_code => sqlcode,
                 in_error_message => sqlerrm,
                 in_object_type => pJobName,
                 in_object_id => null);    
  end dpjob_stop_immediate;



begin
  -- Initialization
  null;
end PKG_BACKUP;
/

