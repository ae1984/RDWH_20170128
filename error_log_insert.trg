CREATE OR REPLACE TRIGGER U1.error_log_insert
before insert on error_log
for each row

declare
  pragma autonomous_transaction;  -- 20160331_ERROR_LOG_INS  -- Kazymbetov_30023
  cnt    number;
   
begin
  select error_log_id_seq.nextval into :new.id from dual;
  --> 20160331_ERROR_LOG_INS  -- Kazymbetov_30023
  select count(*)
    into cnt
    from error_log e
   where trunc(e.err_date) = trunc(sysdate)
     and e.operation = :new.operation
     and e.operation not in ('compile', 'kill_sessions') -- исключаем везде операцию complie и kill_session
     and nvl(e.object_type, 0) = nvl(:new.object_type, 0);
    
   if cnt >= 1 or :new.operation in ('compile', 'kill_sessions') then
     :new.send_bool := 0;
   end if;
   --< 20160331_ERROR_LOG_INS  -- Kazymbetov_30023

end;
/

