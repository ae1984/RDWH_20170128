CREATE OR REPLACE TRIGGER U1."EMAIL_LOG_INSERT"
before insert on email_log
for each row
begin
  if (:new.id is null) then
    select email_log_id_seq.nextval into :new.id from dual;
  end if;
end;
/

