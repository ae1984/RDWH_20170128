create or replace procedure u1.log_error(
        in_operation in varchar2, -- наименование процедуры
        in_error_code in number,
        in_error_message in varchar2,
        in_object_type in varchar2 := null,
        in_object_id in number := null, -- id обрабатываемой записи
        in_send_bool in number default 1  -- 20160331_ERROR_LOG_INS  --Kazymbetov_30023
    ) is
PRAGMA AUTONOMOUS_TRANSACTION;
v_operation varchar2(50);
v_error_message varchar2(2000);
v_object_type varchar2(50);
begin
    v_operation := substr(in_operation,1,50);
    v_error_message := substr(in_error_message,1,2000);
    v_object_type := substr(in_object_type,1,50);

    insert into u1.error_log (
          operation,
          err_code,
          err_message,
          object_type,
          object_id,
          send_bool
        ) values (
          v_operation,
          in_error_code,
          v_error_message,
          v_object_type,
          in_object_id,
          in_send_bool
        );

    commit;
exception
  when others then
    log_error('log_error', -1, substr('log_error procedure fail '||sqlerrm,1,2000));
end log_error;
/
grant execute on U1.LOG_ERROR to RISK_AAMAN;
grant execute on U1.LOG_ERROR to RISK_GKIM;


