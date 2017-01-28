create or replace package u1.pkg_util_tst is

  -- Author  : KIM_17004
  -- Created : 19.08.2013 14:36:48
  -- Purpose :

  procedure clear_log;
  --Запись времени обновления MV
  procedure rec_upd_mv(IN_MVIEW_NAME varchar2,
                       IN_DATE_START timestamp,
                       IN_DATE_END   timestamp);
end pkg_util_tst;
/

create or replace package body u1.pkg_util_tst is

  procedure clear_log is
  begin
    /*    delete from trace_log t
    where t.trace_date < sysdate-30;
    commit;*/
  
    delete from error_log t where t.err_date < sysdate - 90;
    commit;
  
    delete from EMAIL_LOG t
     where t.date_start < sysdate - 90
       and t.send_status > 0;
    commit;
  
    delete from T_RDWH_UPD_MV_LOG t where t.date_start < sysdate - 30;
    commit;
  
    dbms_scheduler.purge_log();
  
  end clear_log;

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
       ceil(extract (second from IN_DATE_END-IN_DATE_START)+extract (minute from IN_DATE_END-IN_DATE_START)*60+extract (hour from IN_DATE_END-IN_DATE_START)*60*60)
       );
    commit;
  
  exception
    when others then
      rollback;
    
      log_error(in_operation     => 'pkg_util.rec_upd_mv',
                in_error_code    => sqlcode,
                in_error_message => sqlerrm);
  end rec_upd_mv;

end pkg_util_tst;
/

