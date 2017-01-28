create or replace trigger u1.T_OUT_FRAUD_1C_TRG
before insert on T_OUT_FRAUD_1C
for each row
begin
 select T_OUT_FRAUD_1C_SEQ.NEXTVAL into :new.id from DUAL;
exception
  when others then
    raise_application_error(-20010,'Ошибка в T_OUT_FRAUD_1C_TRG'||sqlerrm);
end;
/

