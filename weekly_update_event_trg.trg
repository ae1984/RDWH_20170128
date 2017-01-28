﻿CREATE OR REPLACE TRIGGER U1.WEEKLY_UPDATE_EVENT_TRG
BEFORE INSERT ON WEEKLY_UPDATE_EVENT
FOR EACH ROW 
BEGIN
 SELECT WEEKLY_UPDATE_EVENT_SEQ.NEXTVAL INTO :NEW.ID FROM DUAL;
exception
  when others then
    raise_application_error(-20010,'Ошибка в WEEKLY_UPDATE_EVENT_TRG'||sqlerrm);
end;
/

