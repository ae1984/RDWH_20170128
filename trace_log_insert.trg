CREATE OR REPLACE TRIGGER U1."TRACE_LOG_INSERT"
before insert on TRACE_LOG
for each row
begin
  if (:new.id is null) then
    select TRACE_LOG_ID_SEQ.nextval into :new.id from dual;
  end if;
end;
/

