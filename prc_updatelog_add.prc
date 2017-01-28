create or replace procedure u1.PRC_UPDATELOG_ADD(p_objname varchar2) is
   v_id number;
begin
  begin
    v_id := update_log_seq.nextval;
    insert into u1.update_log (id, object_name, begin_refresh, end_refresh, status)
    values (
      v_id
      ,p_objname
      ,sysdate
      ,sysdate
      ,'OK'
    );
    commit;
  exception
     when others then
       rollback;
       u1.log_error('PRC_UPDATELOG_ADD',
                     sqlcode,
                     substr(dbms_utility.format_error_backtrace || ',' ||
                            sqlerrm,
                            1,
                            2000),
                     'PRC_UPDATELOG_ADD',
                     null);
  end;
end PRC_UPDATELOG_ADD;
/
grant execute on U1.PRC_UPDATELOG_ADD to ETL;
grant execute on U1.PRC_UPDATELOG_ADD to UPD_USER;


