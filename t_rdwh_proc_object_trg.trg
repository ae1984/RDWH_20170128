CREATE OR REPLACE TRIGGER U1.T_RDWH_PROC_OBJECT_TRG
BEFORE INSERT or UPDATE or DELETE ON T_RDWH_PROC_OBJECT
FOR EACH ROW
declare
  S_STR_NEW VARCHAR2(4000 CHAR):='';
  S_STR_OLD VARCHAR2(4000 CHAR):='';
  S_FIELDS VARCHAR2(4000 CHAR):='';
  n_id number;
  s_action varchar2(100);
BEGIN
 case
  when INSERTING then
     SELECT T_RDWH_PROC_OBJECT_SEQ.NEXTVAL INTO :NEW.ID FROM DUAL;
     n_id      := :NEW.id;
     S_STR_NEW := :NEW.PROC_NAME||':'||:NEW.OBJECT_NAME||':'||:NEW.PRIORITY ||':'||:NEW.OBJECT_TYPE ||':'||:NEW.PROC_PRIORITY ||':'||:NEW.IS_CRITICAL ||':'||:NEW.IS_USED ||':'||:NEW.COMMENTS ||':'||:NEW.IS_MAIN_OBJECT;
     s_str_old := null;
     s_fields  := 'PROC_NAME:OBJECT_NAME:PRIORITY:OBJECT_TYPE:PROC_PRIORITY:IS_CRITICAL:IS_USED:COMMENTS:IS_MAIN_OBJECT:LOAD_GROUP:REFERENCE_FROM_EVENT';
     s_action  := 'INSERT';
   when UPDATING then
       n_id     := :NEW.id;
       s_action := 'UPDATE';
       IF :new.proc_name != :old.proc_name then
         s_str_new := s_str_new||':'||:new.proc_name;
         s_str_old := s_str_old||':'||:old.proc_name;
         s_fields := s_fields||':PROC_NAME';
       end if;
       IF :new.OBJECT_NAME != :old.OBJECT_NAME then
         s_str_new := s_str_new||':'||:new.OBJECT_NAME;
         s_str_old := s_str_old||':'||:old.OBJECT_NAME;
         s_fields := s_fields||':OBJECT_NAME';
       end if;
       IF :new.PRIORITY != :old.PRIORITY then
         s_str_new := s_str_new||':'||:new.PRIORITY;
         s_str_old := s_str_old||':'||:old.PRIORITY;
         s_fields := s_fields||':PRIORITY';
       end if;
       IF :new.OBJECT_TYPE != :old.OBJECT_TYPE then
         s_str_new := s_str_new||':'||:new.OBJECT_TYPE;
         s_str_old := s_str_old||':'||:old.OBJECT_TYPE;
         s_fields := s_fields||':OBJECT_TYPE';
       end if;
       IF :new.PROC_PRIORITY != :old.PROC_PRIORITY then
         s_str_new := s_str_new||':'||:new.PROC_PRIORITY;
         s_str_old := s_str_old||':'||:old.PROC_PRIORITY;
         s_fields := s_fields||':PROC_PRIORITY';
     end if;
       IF :new.IS_CRITICAL != :old.IS_CRITICAL then
         s_str_new := s_str_new||':'||:new.IS_CRITICAL;
         s_str_old := s_str_old||':'||:old.IS_CRITICAL;
         s_fields := s_fields||':IS_CRITICAL';
       end if;
       IF :new.IS_USED != :old.IS_USED then
         s_str_new := s_str_new||':'||:new.IS_USED;
         s_str_old := s_str_old||':'||:old.IS_USED;
         s_fields := s_fields||':IS_USED';
       end if;
       IF :new.COMMENTS != :old.COMMENTS then
         s_str_new := s_str_new||':'||:new.COMMENTS;
         s_str_old := s_str_old||':'||:old.COMMENTS;
         s_fields := s_fields||':COMMENTS';
      end if;
       IF :new.IS_MAIN_OBJECT != :old.IS_MAIN_OBJECT then
         s_str_new := s_str_new||':'||:new.IS_MAIN_OBJECT;
         s_str_old := s_str_old||':'||:old.IS_MAIN_OBJECT;
         s_fields := s_fields||':IS_MAIN_OBJECT';
       END IF;
       IF :NEW.LOAD_GROUP  != :OLD.LOAD_GROUP then
         s_str_new := s_str_new||':'||:new.IS_MAIN_OBJECT;
         s_str_old := s_str_old||':'||:old.IS_MAIN_OBJECT;
         s_fields := s_fields||':LOAD_GROUP';
       END IF;
       IF :NEW.REFERENCE_FROM_EVENT  != :old.REFERENCE_FROM_EVENT then
         s_str_new := s_str_new||':'||:new.IS_MAIN_OBJECT;
         s_str_old := s_str_old||':'||:old.IS_MAIN_OBJECT;
         s_fields := s_fields||':REFERENCE_FROM_EVENT';
       END IF;

   when deleting then
     n_id      := :OLD.id;
     S_STR_NEW := NULL;
     s_str_old := :OLD.PROC_NAME||':'||:OLD.OBJECT_NAME||':'||:OLD.PRIORITY ||':'||:OLD.OBJECT_TYPE ||':'||:OLD.PROC_PRIORITY ||':'||:OLD.IS_CRITICAL ||':'||:OLD.IS_USED ||':'||:OLD.COMMENTS ||':'||:OLD.IS_MAIN_OBJECT;
     s_fields  := 'PROC_NAME:OBJECT_NAME:PRIORITY:OBJECT_TYPE:PROC_PRIORITY:IS_CRITICAL:IS_USED:COMMENTS:IS_MAIN_OBJECT:LOAD_GROUP:REFERENCE_FROM_EVENT';
     s_action  := 'DELETE';

    end case;
      insert into t_rdwh_log(table_name,
                            id,
                            action,
                            new_value,
                            old_value,
                            fields,
                            user_name,
                            host_name,
                            rep_date)
      values
           ('T_RDWH_PROC_OBJECT',
             n_id ,
             s_action,
             s_str_new,
             s_str_old,
             s_fields,
             user,
             sys_context( 'userenv', 'os_user' ),
             sysdate
           );


/*exception
  when others then
    raise_application_error(-20010,'Ошибка в T_RDWH_PROC_OBJECT_TRG'||sqlerrm);*/
end;
/

