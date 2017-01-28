create or replace package u1.pkg_util is

  -- Author  : KIM_17004
  -- Created : 19.08.2013 14:36:48
  -- Purpose :

  procedure clear_log;
  
  procedure clear_log_daily;
  
  --Запись времени обновления MV
  procedure rec_upd_mv(IN_MVIEW_NAME varchar2,
                       IN_DATE_START timestamp,
                       IN_DATE_END   timestamp);
end pkg_util;
/
grant execute on U1.PKG_UTIL to RISK_GKIM;


create or replace package body u1.pkg_util is

  procedure clear_log is
  begin
    /*    delete from trace_log t
    where t.trace_date < sysdate-30;
    commit;*/
  
    delete from ERROR_LOG t where t.err_date < sysdate - 90;
    commit;
  
    delete from EMAIL_LOG t
     where t.date_start < sysdate - 90
       and t.send_status > 0;
    commit;
  
    delete from T_RDWH_UPD_MV_LOG t where t.date_start < sysdate - 30;
    commit;
  
    delete from ONLINE_UPDATE_LOG ul where ul.p_date < sysdate - 90;
    commit;
  
    delete from u1.t_folder_cpr_sended t where t.date_create < trunc(sysdate);
    commit;
    
    dbms_scheduler.purge_log();
  
  end clear_log;
  
  procedure clear_log_daily is
  begin
    /*    delete from trace_log t
    where t.trace_date < sysdate-30;
    commit;*/
  
    delete from T_MO_RFOLDER_DD t where t.date_create < trunc(sysdate) - 1;
    commit;
    
    delete from T_MO_PROCESS_DD t where t.date_start < trunc(sysdate) - 1;
    commit;
    
    delete from T_MO_RFOLDER_PAR_VALUE_DD t where coalesce(t.date_update, t.date_create) < trunc(sysdate) - 1;
    commit;

  end clear_log_daily;

  --Запись времени обновления MV
  procedure rec_upd_mv(IN_MVIEW_NAME varchar2,
                       IN_DATE_START timestamp,
                       IN_DATE_END   timestamp) is
  begin
  
    insert into T_RDWH_UPD_MV_LOG
      (ID, MVIEW_NAME, DATE_START, DATE_END, DATE_DIFF)
    values
      (UPD_MV_LOG_ID_SEQ.NEXTVAL,
       IN_MVIEW_NAME,
       IN_DATE_START,
       IN_DATE_END,
       ceil(extract (second from IN_DATE_END-IN_DATE_START)));

    commit;
  
  exception
    when others then
      rollback;
    
      log_error(in_operation     => 'pkg_util.rec_upd_mv',
                in_error_code    => sqlcode,
                in_error_message => sqlerrm);
  end rec_upd_mv;

end pkg_util;
/
grant execute on U1.PKG_UTIL to RISK_GKIM;


