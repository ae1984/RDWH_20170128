create or replace procedure u1.log_trace(
        in_operation in varchar2, -- наименование процедуры
        in_error_code in number,
        in_error_message in varchar2,
        in_object_type in varchar2 := null,
        in_object_id in number := null -- id обрабатываемой записи
    ) is
PRAGMA AUTONOMOUS_TRANSACTION;
v_operation varchar2(1024);
v_error_message varchar2(4000);
v_object_type varchar2(256);
begin
    v_operation := substr(in_operation,1,1024);
    v_error_message := substr(in_error_message,1,4000);
    v_object_type := substr(in_object_type,1,256);

    insert into trace_log (
          operation,
          err_code,
          err_message,
          object_type,
          object_id,
          trace_date
        ) values (
          v_operation,
          in_error_code,
          v_error_message,
          v_object_type,
          in_object_id,
          systimestamp
        );

    commit;
exception
  when others then
    log_error('log_error', -1, 'log_error procedure fail');
end log_trace;
/

