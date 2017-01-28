CREATE OR REPLACE TRIGGER U1.EMAIL_LOG_INSERT_TMP
before insert on email_log_tst
for each row
begin
  if (:new.id is null) then
    select email_log_id_seq_tmp.nextval into :new.id from dual;
  end if;
end;
/

