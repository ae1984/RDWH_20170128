create or replace package u1.PKG_UPDATE_UTIL is

  -- Author  : KIM_17004
  -- Created : 11.12.2013 15:36:28
  -- Purpose : 
  -- Инсерт в таблицу событий
  procedure put_event(pEvent in varchar2, pDetail in varchar2 := NULL);

  -- формируем записи для журнала здесь, чтобы оптимизировать код
  procedure log_mv_refresh(pLog in out varchar2,
                           pMV  in varchar2,
                           pRes in integer);

  -- Обновление мат.вьюхи с удалением данных
  -- return 0 - если все нормально
  -- return 1 - если ошибка
  function mv_truncate_refresh(pMV_Name in varchar2) return integer;

  -- Обновление мат.вьюхи
  -- return 0 - если все нормально
  -- return 1 - если ошибка
  function mv_refresh(pMV_Name in varchar2) return integer;
  function mv_truncate_refresh2(pMV_Name in varchar2) return integer;
  -- возвращает разницу во времени между pTS2 и pTS1 в формате МИНУТЫ:СЕКУНДЫ                
  function get_proc_time(pTS1 in timestamp, pTS2 in timestamp)
    return varchar2;

  --
  --логирования информации о времени обновления объектов
  --для mview испольуется в mv_truncate_refresh
  --для table необходимо использовать и добавлять в те пакеты, котоорые делают инкрементальный инсерт
  procedure log_upd (vObject varchar2, vStrDate date);

end PKG_UPDATE_UTIL;
/
grant execute on U1.PKG_UPDATE_UTIL to RISK_GKIM;


create or replace package body u1.PKG_UPDATE_UTIL is

  -- Инсерт в таблицу событий
  procedure put_event(pEvent in varchar2, pDetail in varchar2 := NULL) is
    vCnt integer;
  begin
    vCnt := -1;
    -- Каждое событие может присутствовать только один раз в сутки
    select count(*)
      into vCnt
      from daily_update_event
     where event = pEvent
       and e_date = trunc(sysdate);
  
    if vCnt > 0 then
      log_error('PKG_UPDATE_UTIL.put_event',
                '-1',
                'Event ''' || pEvent || ''' already exist',
                null,
                null);
      return;
    end if;
  
    insert into daily_update_event
      (event, e_detail, e_date)
    values
      (pEvent, pDetail, trunc(sysdate));
    commit;
  
  exception
    when others then
      log_error('PKG_UPDATE_UTIL.put_event', sqlcode, sqlerrm, null, null);
  end put_event;

  -- формируем записи для журнала здесь, чтобы оптимизировать код
  procedure log_mv_refresh(pLog in out varchar2,
                           pMV  in varchar2,
                           pRes in integer) is
  begin
    pLog := pLog || pMV || ' is refreshed at ' ||
            to_char(sysdate, 'hh24:mi:ss') || ' ' || case
              when pRes = 0 then
               'successfully'
              else
               'with error'
            end || chr(10);
  end log_mv_refresh;

  -- Обновление мат.вьюхи с удалением данных
  -- return 0 - если все нормально
  -- return 1 - если ошибка
  function mv_truncate_refresh(pMV_Name in varchar2) return integer is
        /* V_DATE_START timestamp:=systimestamp;*/
    v_cnt number;
  begin
  
    begin
      select count(1) into v_cnt from SYS.USER_OBJECTS t
      where t.OBJECT_NAME = pMV_Name and t.status = 'INVALID' and t.OBJECT_TYPE = 'MATERIALIZED VIEW';
      if v_cnt >0 then
         execute immediate 'alter materialized view '||pMV_Name||' compile';
      end if;
    exception
      when others then
        null;
    end;
  
    dbms_mview.refresh(list           => pMV_Name,
                       method         => 'C',
                       parallelism    => 5,
                       atomic_refresh => false);
                       
                         /* pkg_util.rec_upd_mv(pMV_Name,
                          V_DATE_START,
                          systimestamp);*/

  
    return(0);
  exception
    when others then
      log_error('PKG_UPDATE_UTIL.mv_truncate_refresh',
                sqlcode,
                substr(dbms_utility.format_error_backtrace || ',' ||
                       sqlerrm,
                       1,
                       2000),
                pMV_Name,
                null);
      return(1);
  end mv_truncate_refresh;
  function mv_truncate_refresh2(pMV_Name in varchar2) return integer is
        /* V_DATE_START timestamp:=systimestamp;*/
    v_cnt number;
  begin
    select count(1) into v_cnt from u1.update_log t 
    where t.object_name = pMV_Name and t.begin_refresh>=trunc(sysdate) and t.status='OK';
    if v_cnt >0 then
       return(0);
       --null;
    end if;    
    
    begin
      select count(1) into v_cnt from SYS.USER_OBJECTS t
      where t.OBJECT_NAME = pMV_Name and t.status = 'INVALID' and t.OBJECT_TYPE = 'MATERIALIZED VIEW';
      if v_cnt >0 then
         execute immediate 'alter materialized view '||pMV_Name||' compile';
      end if;
    exception
      when others then
        null;
    end;
  
    dbms_mview.refresh(list           => pMV_Name,
                       method         => 'C',
                       parallelism    => 5,
                       atomic_refresh => false);
                       
                         /* pkg_util.rec_upd_mv(pMV_Name,
                          V_DATE_START,
                          systimestamp);*/

  
    return(0);
  exception
    when others then
      log_error('PKG_UPDATE_UTIL.mv_truncate_refresh',
                sqlcode,
                substr(dbms_utility.format_error_backtrace || ',' ||
                       sqlerrm,
                       1,
                       2000),
                pMV_Name,
                null);
      return(1);
  end mv_truncate_refresh2;
  -- Обновление мат.вьюхи
  -- return 0 - если все нормально
  -- return 1 - если ошибка
  function mv_refresh(pMV_Name in varchar2) return integer is
     v_cnt number;
  begin
  
    begin
      select count(1) into v_cnt from SYS.USER_OBJECTS t
      where t.OBJECT_NAME = pMV_Name and t.status = 'INVALID' and t.OBJECT_TYPE = 'MATERIALIZED VIEW';
      if v_cnt >0 then
         execute immediate 'alter materialized view '||pMV_Name||' compile';
      end if;
    exception
      when others then
        null;
    end;
  
    dbms_mview.refresh(list => pMV_Name, method => 'C', parallelism => 5);
  
    return(0);
  exception
    when others then
      log_error('pkg_daily_update.mv_refresh',
                sqlcode,
                sqlerrm,
                pMV_Name,
                null);
      return(1);
  end mv_refresh;

  -- возвращает разницу во времени между pTS2 и pTS1 в формате МИНУТЫ:СЕКУНДЫ
  function get_proc_time(pTS1 in timestamp, pTS2 in timestamp)
    return varchar2 is
    vMin varchar2(10);
    vSec varchar2(10);
  begin
    if pTS1 is null or pTS2 is null then
      return null;
    end if;
    select extract(minute from(pTS2 - pTS1)) +
           (extract(hour from(pTS2 - pTS1))) * 60
      into vMin
      from dual;
    select round(extract(second from(pTS2 - pTS1))) into vSec from dual;
    if length(vMin) = 1 then
      vMin := '0' || vMin;
    end if;
    if length(vSec) = 1 then
      vSec := '0' || vSec;
    end if;
    return(vMin || ':' || vSec);
  exception
    when others then
      log_error(in_operation     => 'PKG_UPDATE_UTIL.get_proc_time',
                in_error_code    => sqlcode,
                in_error_message => sqlerrm,
                in_object_type   => null,
                in_object_id     => null);
  end;
  ---
  --логирования информации о времени обновления объектов
  --для mview испольуется в mv_truncate_refresh
  --для table необходимо использовать и добавлять в те пакеты, котоорые делают инкрементальный инсерт
  procedure log_upd (vObject varchar2, vStrDate date) 
  as
  begin
    insert into update_log(id,object_name,begin_refresh,end_refresh,status) 
    values(update_log_seq.nextval, vObject, vStrDate, sysdate,'OK');
    commit;
  exception  
   when others then
      log_error(in_operation     => 'log_upd',
                in_error_code    => sqlcode,
                in_error_message => sqlerrm,
                in_object_type   => vObject,
                in_object_id     => null);
  end;
  ---
end PKG_UPDATE_UTIL;
/
grant execute on U1.PKG_UPDATE_UTIL to RISK_GKIM;


