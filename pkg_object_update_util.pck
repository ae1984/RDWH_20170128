create or replace package u1.PKG_OBJECT_UPDATE_UTIL is

  procedure put_event(pEvent in varchar2, pDetail in varchar2 := NULL);

  function check_event(pEvent in varchar2) return boolean;

  procedure mv_truncate_refresh(pMV_Name in varchar2);
  
  procedure mv_refresh(pMV_Name in varchar2);
  
  procedure log_upd (vObject varchar2, vStrDate date default null, vStatus varchar2);
  
  procedure compile_invalid_views;
  
  procedure check_RFOSNAP_availability;
  
  procedure check_RBO_availability;
  
  procedure check_DWH_availability;
  
  procedure check_RBOSNAP_availability;
  
  -- Проверка готовности RFO через EXADATA
  procedure check_RFOEXD_availability;
  
   -- Проверка готовности IBSO через EXADATA
  procedure check_IBSOEXD_availability ;
  
    -- Проверка готовности MO через EXADATA
  procedure check_MO_availability;

-- Проверка готовности KASPIKZ на EXADATA
  procedure check_KASPIKZ_exd_availability;
       
  -- Проверка готовности KASPIKZ
  procedure check_KASPIKZ_availability;

  --проверка инкрементальной загрузки  
  procedure P_CHECK_INCREMENT_TABLES;
  
end PKG_OBJECT_UPDATE_UTIL;
/

create or replace package body u1.PKG_OBJECT_UPDATE_UTIL is

  -- Инсерт в таблицу событий
  procedure put_event(pEvent in varchar2, pDetail in varchar2 := NULL) is
    vCnt integer;
  begin
    vCnt := -1;
    -- Каждое событие может присутствовать только один раз в сутки
    select count(*)
      into vCnt
      from u1.daily_update_event
     where event = pEvent
       and e_date = trunc(sysdate);

    if vCnt > 0 then
      /*u1.log_error('PKG_UPDATE_UTIL.put_event',
                           '-1',
                           'Event ''' || pEvent || ''' already exist',
                           null,
                           null);*/
      return;
    end if;

    insert into u1.daily_update_event
      (event, e_detail, e_date)
    values
      (pEvent, pDetail, trunc(sysdate));
    commit;

  exception
    when others then
      u1.log_error('PKG_OBJECT_UPDATE_UTIL.put_event', sqlcode, sqlerrm, null, null);
  end put_event;

  function check_event(pEvent in varchar2) return boolean is
    vCnt integer;
  begin

    select count(*)
      into vCnt
      from u1.daily_update_event
     where event = pEvent
       and e_date = trunc(sysdate);

    if vCnt > 0 then
      return true;
    end if;

    return false;
  exception
    when others then
      u1.log_error('PKG_OBJECT_UPDATE_UTIL.check_event',
                sqlcode,
                sqlerrm,
                null,
                null);
      return false;
  end check_event;



  procedure mv_truncate_refresh(pMV_Name in varchar2) 
    is
   vStrDate date := sysdate;
   v_cnt number;
   --для теста процесса
   v_sleep number;
  begin

    --pkg_object_update_util.log_upd(pMV_Name, vStrDate, 'PROCESSING');
    
    --для теста процесса
     
    /*select \*+ noparallel *\
           case when max(rt.fullrefreshtim_sec) < 60
                then max(rt.fullrefreshtim_sec)
                when max(rt.fullrefreshtim_sec) < 300
                then 90
                else 120 end
      into v_sleep
      from risk_chden.V_SYS_OBJECT_REFRESHTIM rt
     where rt.v_name = pMV_Name;

    dbms_lock.sleep(v_sleep);*/

    
    --Обновление
    begin
        select count(1) into v_cnt from SYS.USER_OBJECTS t
    where t.OBJECT_NAME = pMV_Name and t.status = 'INVALID' and t.OBJECT_TYPE = 'MATERIALIZED VIEW';
    if v_cnt >0 then
      execute immediate 'alter materialized view ' || pMV_Name ||' compile';
    end if;
    exception
      when others then
        null;
    end;
  
    dbms_mview.refresh(list           => pMV_Name,
                       method         => 'C',
                       parallelism    => 5,
                       atomic_refresh => false);

    
    pkg_object_update_util.log_upd(pMV_Name, vStrDate, 'OK');
    
  exception
    when others then
      pkg_object_update_util.log_upd(pMV_Name, vStrDate, 'ERROR');
      u1.log_error('PKG_OBJECT_UPDATE_UTIL.mv_truncate_refresh',
                    sqlcode,
                    substr(dbms_utility.format_error_backtrace || ',' ||
                           sqlerrm,
                           1,
                           2000),
                    pMV_Name,
                    null);

  end mv_truncate_refresh;
  
  procedure mv_refresh(pMV_Name in varchar2) 
  is
   vStrDate date := sysdate;
   v_cnt number;
  begin

    --pkg_object_update_util.log_upd(pMV_Name, vStrDate, 'PROCESSING');
    
    --Обновление
    begin
       select count(1) into v_cnt from SYS.USER_OBJECTS t
      where t.OBJECT_NAME = pMV_Name and t.status = 'INVALID' and t.OBJECT_TYPE = 'MATERIALIZED VIEW';
      if v_cnt >0 then
        execute immediate 'alter materialized view ' || pMV_Name ||' compile';
      end if;
    exception
      when others then
        null;
    end;
  
    dbms_mview.refresh(list           => pMV_Name,
                       method         => 'C',
                       parallelism    => 5,
                       atomic_refresh => true);

    
    pkg_object_update_util.log_upd(pMV_Name, vStrDate, 'OK');
    
  exception
    when others then
      pkg_object_update_util.log_upd(pMV_Name, vStrDate, 'ERROR');
      u1.log_error('PKG_OBJECT_UPDATE_UTIL.mv_refresh',
                    sqlcode,
                    substr(dbms_utility.format_error_backtrace || ',' ||
                           sqlerrm,
                           1,
                           2000),
                    pMV_Name,
                    null);

  end mv_refresh;
  
  procedure log_upd (vObject varchar2, vStrDate date default null, vStatus varchar2) 
   
  as
   d_date date;
  begin
    
    case 
      when vStatus = 'PROCESSING' then    
        insert into u1.update_log el (id, object_name, begin_refresh, end_refresh, status)
        values(u1.update_log_seq.nextval, vObject, vStrDate, null, vStatus);
      
      when vStatus = 'OK' then
        -- Костыль, иначе T_RBO_PORT вылетает
        if vObject = 'M_RBO_CONTRACT_BAS' then
           d_date := sysdate+2/24/60;         
        end if;  
      
        update u1.update_log ul
            set ul.status = vStatus, ul.end_refresh = nvl(d_date,sysdate)
           where ul.object_name = vObject
                 and ul.begin_refresh >= trunc(sysdate)
                 and ul.status = 'PROCESSING';

      --ERROR         
      else merge into (select * from update_log ul where ul.status = 'PROCESSING' and ul.begin_refresh >= trunc(sysdate) and ul.object_name = vObject) ul
           using (select vObject as object_name, 'ERROR' as STATUS from dual ) ud
           on (ul.object_name = ud.object_name)
           when matched then update set ul.status = ud.STATUS, ul.end_refresh = sysdate
           when not matched then insert (ID, OBJECT_NAME, BEGIN_REFRESH, END_REFRESH, STATUS)
                                 values (update_log_seq.nextval, ud.object_name, sysdate, null, ud.STATUS);
                               
    end case;
    
    commit;

  exception  
   when others then
      u1.log_error(in_operation     => 'log_upd',
                   in_error_code    => sqlcode,
                   in_error_message => sqlerrm,
                   in_object_type   => vObject,
                   in_object_id     => null);
  end;


  procedure compile_invalid_views is
    v_sql varchar2(1000);
  begin
  
    --TODO: Убрать привязку к процессам
    for cur in (select 'alter ' || o.object_type || ' ' || o.object_name ||
                       ' compile' as sql_t, o.object_name
                  from user_objects o
                  left join t_rdwh_proc_object po on po.object_name = o.object_name 
                                            and po.type_load = 'DAILY'
                                            and po.is_used = 1
                                            /*and po.proc_name in ('LOAD_DWH_P1',
                                                                     'LOAD_DWH_P2',
                                                                     'LOAD_DWH_P3',
                                                                     'LOAD_RFO_P1',
                                                                     'LOAD_RFO_P2',
                                                                     'LOAD_RFO_P3',
                                                                     'LOAD_RFO_P4',
                                                                     'RECALC_RDWH_P1',
                                                                     'RECALC_RDWH_P2',
                                                                     'RECALC_RDWH_P3',
                                                                     'RECALC_RDWH_P4',
                                                                     'RECALC_RDWH_RFO_P1',
                                                                     'RECALC_RDWH_RFO_P2',
                                                                     'RECALC_RDWH_RFO_P3',
                                                                     'RECALC_RDWH_RFO_P4',
                                                                     'RECALC_RDWH_RFO_P5',
                                                                     'RECALC_RDWH_RFO_P6',
                                                                     'RECALC_RDWH_RFO_P7',
                                                                     'LOAD_RBO_P0',
                                                                     'LOAD_RBO_P1',
                                                                     'LOAD_RBO_P2',
                                                                     'LOAD_RBO_P3',
                                                                     'LOAD_RBO_P4',
                                                                     'LOAD_RBO_P5',
                                                                     'RECALC_RBO_P1',
                                                                     'RECALC_RBO_P2',
                                                                     'RECALC_RBO_P3',
                                                                     'RECALC_RBO_P4',
                                                                     'RECALC_RDWH_RBO_P1',
                                                                     'RECALC_RDWH_RBO_P2',
                                                                     'RECALC_RDWH_RBO_P3',
                                                                     'RECALC_RDWH_RBO_P4',
                                                                     'RECALC_RDWH_RBO_P5',
                                                                     'RECALC_RDWH_RBO_P6',
                                                                     'LOAD_MO',
                                                                     'UPDATE_MO_D',
                                                                     'UPDATE_MO_SCO_REQUEST',
                                                                     'LOAD_KASPIKZ1')*/ --убрала , компилим все объекты ежеденевного
                 where o.status <> 'VALID'
                   and (o.object_type = 'VIEW'
                         or o.object_type = 'MATERIALIZED VIEW'
                         and po.object_name is not null)) loop
      begin
        v_sql := cur.sql_t;
        execute immediate v_sql;
      exception
        when others then
          --dbms_output.put_line(v_sql);
          --null;
          log_error(in_operation => 'compile',
                    in_error_code => sqlcode,
                    in_error_message => sqlerrm,
                    in_object_type => cur.object_name);
      end;
    end loop;
  
  end compile_invalid_views;
  
  
  -- Проверка готовности RFO_SNAP
  procedure check_RFOSNAP_availability is
    vRFO_SNAP_date date;
    vLim_date      varchar2(32);
    n_cnt_proc     number(32);
    n_hour_min     number;
  begin
    select to_number(to_char(sysdate, 'HH24MI'))
      into n_hour_min
      from dual;
    if  n_hour_min <= 30/*0210*/ then
        return;
    end if;     

    -- данные в RFO_SNAP д.б. за вечер вчерашнего дня
    vLim_date := to_char(trunc(sysdate - 1), 'dd.mm.yyyy') || ' 17:00:00';
  
    begin
      execute immediate 'select max(C_DATE_CREATE) from ' ||
                        'IBS.Z#CM_CHECKPOINT@RFO/*_SNAP*/'
        into vRFO_SNAP_date;
    
    exception
      when others then
        u1.log_error('pkg_object_update_util.check_RFOSNAP_availability',
                  sqlcode,
                  sqlerrm,
                  null,
                  null);
        -- если будут проблемы с доступностью rfo_snap попадем сюда
        return;
    end;
  
    -- данные в RFO_SNAP д.б. за вечер вчерашнего дня, как минимум
    if vRFO_SNAP_date >= trunc(sysdate)--to_date(vLim_date, 'dd.mm.yyyy hh24:mi:ss') 
    then
      /*--если такие данные сущесвуют, то дополнительно проверяем их количественный состав относительно день - 1 
      begin
       select round((sum(decode(trunc(c_date_create),trunc(sysdate)-1,1,0))/
              sum(decode(trunc(c_date_create),trunc(sysdate)-2,1,0)))*100)  
         into n_cnt_proc     
         from IBS.Z#CM_CHECKPOINT@RFO\*_SNAP*\
        where trunc(c_date_create) >= trunc(sysdate)-2;
      exception
      when others then
        u1.log_error('pkg_object_update_util.check_RFOSNAP_availability',
                  sqlcode,
                  sqlerrm,
                  null,
                  null);
        -- если будут проблемы с доступностью rfo_snap попадем сюда
        return;
      end;
      if n_cnt_proc > 50 then
         -- пишем что RFO_SNAP готов, в противном случае ничего не делаем
         put_event('RFO_SNAP_READY');
      end if; */  
      put_event('RFO_SNAP_READY');
    end if;
  
  exception
    when others then
      log_error('pkg_object_update_util.check_RFOSNAP_availability',
                sqlcode,
                sqlerrm,
                null,
                null);
  end check_RFOSNAP_availability;
  
  -- Проверка готовности RBO_STAGE
  procedure check_RBO_availability is
    n_hour_min      number;
    v_day_week      varchar2(1);
    n_flag          number(1);
  begin
    --загрузка возможна после 01-00
    select to_number(to_char(sysdate, 'HH24MI')), to_char(sysdate,'D')
      into n_hour_min, v_day_week
      from dual;
    if n_hour_min <= 0100 /*0200*/ then
       return; 
    end if;
    if n_hour_min >= 1300 then
       put_event(pEvent => 'RBO_READY');
       --null;
    end if;  
    --проверяем закрыт ли вчерашний день и можно ли приступить к загрузке данных
    select count(1)
      into n_flag
      from rdwh.V_DWH_SYSTEM_OP_DATE_GG@rdwh_exd gg
     where gg.op_date_close = trunc(sysdate) - 1
       and upper(gg.type_cl) = 'OP_DATE_WITH_BUF' 
       and gg.scheme in ('RBO','RBOSTD')
       and gg.status_hb = 1;
    if n_flag = 1 then 
       --вчерашний день закрыт   
       put_event(pEvent => 'RBO_READY');
       --null;
    end if;   
  exception
    when others then
      u1.log_error('pkg_object_update_util.check_RBO_availability',
                sqlcode,
                sqlerrm,
                null,
                null);
  end check_RBO_availability;
  
  --ПРоверка готовности DWH
  procedure check_DWH_availability
  is
    vTName_cnt integer;
    vMax_time date;
    vComment varchar2(500);
  begin
    vtname_cnt := -1;

    -- проверяем, что процессы подготовки данных на DWH закончились
    begin
      execute immediate
        'select count(distinct table_name), max(fill_date) ' ||
          'from dwh_ran.meta_table_fill_v@dwh_prod2 t ' ||
         'where trunc(t.as_of_date) = trunc(sysdate) - 1 ' ||
           'and t.table_name IN (''D_CP_DEAL'', ''F_CP_FIDX'')'
        into vTName_cnt, vMax_time;

    exception
      when others then
        u1.log_error('pkg_object_update_util.check_DWH_availability', sqlcode, sqlerrm, null, null);
        return;
    end;

    if vTName_cnt = 2 /*and vMax_time < systimestamp*/ then
      -- пишем что DWH готов, в противном случае ничего не делаем
      put_event('DWH_READY', vComment);
    end if;

  exception
    when others then
      u1.log_error('pkg_object_update_util.check_DWH_availability', sqlcode, sqlerrm, null, null);

  end check_DWH_availability;

-- Проверка готовности RBO_SNAP
  procedure check_RBOSNAP_availability is
--    n_RBO_SNAP_date number;
    n_hour_min      number;
    v_day_week      varchar2(1);
    n_flag          number(1);
    d_rbo_change_dt date := to_date( '14-08-2016','dd-mm-yyyy');      
  begin
   -- return; 
    -- данные в RBO_SNAP д.б. за вечер вчерашнего дня
    --обновление rbo_snap проходит каждый будний день в 06-30 утра
    --добавляем проверку, что сегодня будний день, и время больше 07:00
    select to_number(to_char(sysdate, 'HH24MI')), to_char(sysdate,'D')
      into n_hour_min, v_day_week
      from dual;
  --  if n_hour_min <= 0700 or v_day_week in ('1','7') then
/*    if n_hour_min <= 0800 or v_day_week in ('1','7') then
       return; 
    end if;  
    --анализируем количество провоеддных проводок на день минус 1
    begin
      execute immediate 'select count(1) from v_rbo_Z#fact_oper@Rdwh11 '||
                        'where c_date = trunc(sysdate)-1'
        into n_RBO_SNAP_date;
        exception
      when others then
        log_error('pkg_daily_update_rbo.check_RBOSNAP_availability',
                  sqlcode,
                  sqlerrm,
                  null,
                  null);
        -- если будут проблемы с доступностью rbo_snap попадем сюда
        return;
    end;  
    -- кол-во операций за вчерашний день должно быть более 500000
    if n_RBO_SNAP_date >= 500000 then
      -- пишем что RBO_SNAP готов, в противном случае ничего не делаем
      pkg_update_util.put_event('RBO_SNAP_READY');
    end if;*/
  if trunc(sysdate) = d_rbo_change_dt then
    if n_hour_min <= 1200 then
       return; 
    end if;  
  else
   if n_hour_min <= 0720 then
       return; 
    end if;  
  end if;  
    --анализируем флаг в контрольной таблице
   if trunc(sysdate) >= d_rbo_change_dt then
     begin
      execute immediate 'select COUNT(1) from V_RBO_Z#KAS_VID_SPEC@RDWH11'
        into n_flag;
        exception
      when others then
        u1.log_error('pkg_object_update_util.check_RBOSNAP_availability',
                  sqlcode,
                  sqlerrm,
                  null,
                  null);
        -- если будут проблемы с доступностью rbo_snap попадем сюда
        return;
    end; 
   else  
    begin
      execute immediate 'select value from V_REBOOT_FLAG@rdwh11 where flag=1'
        into n_flag;
        exception
      when others then
        u1.log_error('pkg_object_update_util.check_RBOSNAP_availability',
                  sqlcode,
                  sqlerrm,
                  null,
                  null);
        -- если будут проблемы с доступностью rbo_snap попадем сюда
        return;
    end; 
    end if; 
    if n_flag = 1 then
      -- пишем что RBO_SNAP готов, в противном случае ничего не делаем
      put_event('RBO_SNAP_READY');
    end if;
  exception
    when others then
      u1.log_error('pkg_object_update_util.check_RBOSNAP_availability',
                sqlcode,
                sqlerrm,
                null,
                null,
                0);--поменять на 1, если какие-то объекты будут обновляться с RBO_SNAP

  end check_RBOSNAP_availability;
  
-- Проверка готовности RFO через EXADATA
  procedure check_RFOEXD_availability 
  is
  d_target_commit date; -- дата последней репликации
  begin
  --определяем готова ли сегодня   репликация базы РФО
  --надо выяснить по поводу PMPGROUP  и DELGROUP(что это и надо ли как-то их анализировать)
  select min(target_commit)-30/24/60/60
    into d_target_commit
    from ggadmin.gg_heartbeat@rdwh_exd t
   where target_commit > to_date(to_char(trunc(sysdate),'dd-mm-yyyy')||'00:00:00','dd-mm-yyyy hh24:mi:ss') -- на какую дату/время готовы репликаты
     and upper(src_db) in ( 'RFO','RFOSTD');
  -- так как отнимаем полминуты, то еще раз проверяем на соответсвие даты
  if trunc(d_target_commit) = trunc(sysdate) and d_target_commit is not null then
     --если все нормально, то  возвращаем RFO_EXD_READY
     put_event(pEvent => 'RFO_EXD_READY');
  else  
     return;  
  end if;
  --
  exception
    when others then
      u1.log_error('pkg_object_update_util.check_RFOEXD_availability',
                sqlcode,
                sqlerrm,
                null,
                null);
  end check_RFOEXD_availability;  
  
-- Проверка готовности IBSO через EXADATA
  procedure check_IBSOEXD_availability 
  is
  d_target_commit date; -- дата последней репликации
  begin
  --определяем готова ли сегодня   репликация базы РФО
  --надо выяснить по поводу PMPGROUP  и DELGROUP(что это и надо ли как-то их анализировать)
  select min(target_commit)-30/24/60/60
    into d_target_commit
    from ggadmin.gg_heartbeat@rdwh_exd t
   where target_commit > to_date(to_char(trunc(sysdate),'dd-mm-yyyy')||'00:00:00','dd-mm-yyyy hh24:mi:ss') -- на какую дату/время готовы репликаты
     and upper(src_db) in ('IBSO','IBSOSTD');
  -- так как отнимаем полминуты, то еще раз проверяем на соответсвие даты
  if trunc(d_target_commit) = trunc(sysdate) and d_target_commit is not null then
     --если все нормально, то  возвращаем IBSO_EXD_READY
     put_event(pEvent => 'IBSO_EXD_READY');
  else  
     return;  
  end if;
  --
  exception
    when others then
      u1.log_error('pkg_object_update_util.check_IBSOEXD_availability',
                sqlcode,
                sqlerrm,
                null,
                null);
  end check_IBSOEXD_availability;  
  
  
  -- Проверка готовности MO
  procedure check_MO_availability is
    vMO_date       date;
    vLim_date      varchar2(32);
    n_cnt_proc     number(32);
    n_hour_min     number;
  begin
    select to_number(to_char(sysdate, 'HH24MI'))
      into n_hour_min
      from dual;
    if  n_hour_min <= 0015 then
        return;
    else
      put_event(pEvent => 'MO_READY');    
    end if;     
   
    exception
      when others then
        u1.log_error('pkg_object_update_util.check_MO_availability',
                  sqlcode,
                  sqlerrm,
                  null,
                  null);
        return;
   -- если будут проблемы с доступностью МО попадем сюда

    end;
    
 -- Проверка готовности KASPIKZ на EXADATA
  procedure check_KASPIKZ_exd_availability is
    vkaspikz_date  date;
    n_hour_min     number;
  begin
    select to_number(to_char(sysdate, 'HH24MI'))
      into n_hour_min
      from dual;
    if  n_hour_min <= 0010 then
        return;
    else       
      execute immediate 'select max(dtlastupdate) from ' ||
                        's37.tb_AccountInfo_Accounts@rdwh_exd'
      into vkaspikz_date;
           
    end if;
    
    if nvl(vkaspikz_date,trunc(sysdate)-1) > trunc(sysdate) then         
      put_event(pEvent => 'KASPIKZ_EXD_READY');   
    end if; 
    exception
      when others then
        u1.log_error('pkg_object_update_util.check_KASPIKZ_exd_availability',
                  sqlcode,
                  substr(sqlerrm||'-'||dbms_utility.format_error_backtrace,1,2000),
                  null,
                  null);
        return;

    end;
  
 -- Проверка готовности KASPIKZ
  procedure check_KASPIKZ_availability is
    vkaspikz_date  date;
    n_hour_min     number;
  begin
    select to_number(to_char(sysdate, 'HH24MI'))
      into n_hour_min
      from dual;
    if  n_hour_min <= 0100 then
        return;
    else       
      execute immediate 'select max(t."dtLastUpdate") from  "dbo"."tb_AccountInfo_Accounts"@"db_kr2" t ' 
      into vkaspikz_date;
           
    end if;
    
    if nvl(vkaspikz_date,trunc(sysdate)-1) > trunc(sysdate) then         
      put_event(pEvent => 'KASPIKZ_READY');   
    end if; 
    exception
      when others then
        u1.log_error('pkg_object_update_util.check_KASPIKZ_availability',
                  sqlcode,
                  substr(sqlerrm||'-'||dbms_utility.format_error_backtrace,1,2000),
                  null,
                  null);
        return;
   -- если будут проблемы с доступностью KASPIKZ попадем сюда

    end;
  
--проверка инкрементальной загрузки  
   procedure P_CHECK_INCREMENT_TABLES
  as
  --declare
  e_user_exception exception;
  s_error          varchar2(4000);
  n_count          number;
  n_max_id         number;
  n_count_exd      number;
  n_max_id_exd     number;
  n_check_result   number;
  s_error_text     varchar2(4000);  
  s_table_name     varchar2(100);
  n_recalc_cnt     number;
  vStartTime varchar2(32);
  vStopTime  varchar2(32);
begin
     -- ====== время запуска настраиваем здесь ======
    vStartTime := '09:00:00';
    vStopTime  := '16:00:00';
    -- =============================================

    vStartTime := to_char(sysdate, 'dd.mm.yyyy') || ' ' || vStartTime;
    vStopTime  := to_char(sysdate, 'dd.mm.yyyy') || ' ' || vStopTime;  

    -- окно времени, когда идет обновление
    if sysdate < to_date(vStartTime, 'dd.mm.yyyy hh24:mi:ss') or
       sysdate > to_date(vStopTime, 'dd.mm.yyyy hh24:mi:ss') then
      return;
    end if;  

    select count(1)
    into n_recalc_cnt
    from t_rdwh_proc_object o
    join t_rdwh_increm_check_param p on p.table_name = o.object_name
    where o.object_type = 'TABLE'
      and o.is_used = 1
      and p.is_used = 1
      and o.type_load in ('DAILY',/*'WEEKLY','MONTHLY',*/'ONLINE')--57
      and not exists (select 1 from UPDATE_LOG L
                      where l.object_name = o.object_name 
                       and trunc(l.begin_refresh) = trunc(sysdate));
                       
  if n_recalc_cnt = 0 and not pkg_object_update_util.check_event('INCREM_CHECK_PROCESSING') then 
     pkg_object_update_util.put_event('INCREM_CHECK_PROCESSING');
     for rec in (select table_name,select_tbl,where_tbl,source_name,select_txt,where_txt
                from T_RDWH_INCREM_CHECK_PARAM
                where is_used = 1               
                order by id ) 
     loop 
         s_table_name := rec.table_name;
          
         s_error_text:= '';
         execute immediate (rec.select_tbl||' '||rec.table_name||' '||rec.where_tbl) -- where not exists (select 1 from '||rec.source||'.S$'||rec.s_name||'@rdwh_exd r where r.id = o.id and r.row_status = ''D'')'
         into n_count,n_max_id ;  
        
          execute immediate (rec.select_txt||'  '||rec.source_name||' '||rec.where_txt||' '||n_max_id)
                              into n_count_exd,n_max_id_exd ;
          if n_count = n_count_exd then
            n_check_result := 1;
          else 
            n_check_result := 0;
            s_error_text := s_error_text||' '||rec.table_name||' - количество записей в источнике='||n_count_exd||', количество записей в таблице='||n_count||'.';
          end if;
          insert into T_RDWH_INCREM_CHECK_LOG(table_name,check_date,check_result,table_cnt,source_cnt,error_text,MAX_VALUE)
          values (rec.table_name,trunc(sysdate),n_check_result,n_count,n_count_exd,s_error_text,to_char(n_max_id));
          commit; 
    end loop;
     pkg_object_update_util.put_event('INCREM_CHECK_COMPLETE');
  end if;  
exception
  when others then
    rollback;
     u1.log_error('P_CHECK_INCREMENT_TABLES:'||s_table_name,
                              sqlcode,
                              substr(dbms_utility.format_error_backtrace||','||sqlerrm,1,2000),
                              null,
                              null);
 end P_CHECK_INCREMENT_TABLES;

end PKG_OBJECT_UPDATE_UTIL;
/

