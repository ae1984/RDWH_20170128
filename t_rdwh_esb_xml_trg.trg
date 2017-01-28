create or replace trigger u1.T_RDWH_ESB_XML_TRG
before insert on T_RDWH_ESB_XML
for each row
begin
 select T_RDWH_ESB_XML_SEQ.NEXTVAL into :new.id from DUAL;
exception
  when others then
    raise_application_error(-20010,'Ошибка в T_RDWH_ESB_XML_TRG'||sqlerrm);
end;
/

