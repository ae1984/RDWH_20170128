create or replace procedure u1.edit_log is
text varchar2(2000);
text2 varchar2(2000);
begin
  for info in (select s.OSUSER, cur.SQL_TEXT, s.PREV_EXEC_START
               from sys.v_$session s
               join SYS.GV_$OPEN_CURSOR cur on cur.SADDR = s.SADDR
               where  s.status = 'ACTIVE' and s.OSUSER <> 'orcl'
               group by s.OSUSER,cur.SQL_TEXT,s.PREV_EXEC_START) loop
  begin
      text := 'null';
      text2 := 'null';
-- create materialized view
      if INSTR(info.sql_text,'create materialized view',1) > 0 then
      begin
          text := substr(info.sql_text,INSTR(info.sql_text,'create materialized view',1)+25,INSTR(info.sql_text,' ',
                  INSTR(info.sql_text,'create materialized view',1)+26)-INSTR(info.sql_text,'create materialized view',1)-25);
          select coalesce(max(l.object),'not') into text2 from T_LOG_USER_ACTIONS l where
                 l.action = 'create materialized view' and l.object = text and l.start_time = info.prev_exec_start and l.users = info.osuser;
          if text2 = 'not' and INSTR(text,'$',1) = 0 then
          begin
              insert into T_LOG_USER_ACTIONS (action,object,start_time,users) values ('create materialized view',text,info.prev_exec_start,info.osuser);
              commit;
          end;
          end if;
      end;
      end if;
-- drop materialized view
      if INSTR(info.sql_text,'drop materialized view',1) > 0 then
      begin
          if INSTR(info.sql_text,' ',INSTR(info.sql_text,'drop materialized view',1)+24) > 0 then
              text := substr(info.sql_text,INSTR(info.sql_text,'drop materialized view',1)+23,
              INSTR(info.sql_text,' ',INSTR(info.sql_text,'drop materialized view',1)+24)-INSTR(info.sql_text,'drop materialized view',1)-23);
          else
              text := substr(info.sql_text,INSTR(info.sql_text,'drop materialized view',1)+23,length(info.sql_text));
          end if;
          select coalesce(max(l.object),'not') into text2 from T_LOG_USER_ACTIONS l where
                 l.action = 'drop materialized view' and l.object = text and l.start_time = info.prev_exec_start and l.users = info.osuser;
          if text2 = 'not' and INSTR(text,'$',1) = 0 then
          begin
              insert into T_LOG_USER_ACTIONS (action,object,start_time,users) values ('drop materialized view',text,info.prev_exec_start,info.osuser);
              commit;
          end;
          end if;
      end;
      end if;
-- create view
      if INSTR(info.sql_text,'create view',1) > 0 then
      begin
          text := substr(info.sql_text,13,INSTR(info.sql_text,' ',13)-13);
          select coalesce(max(l.object),'not') into text2 from T_LOG_USER_ACTIONS l where
                 l.action = 'create view' and l.object = text and l.start_time = info.prev_exec_start and l.users = info.osuser;
          if text2 = 'not' and INSTR(text,'$',1) = 0 then
          begin
              insert into T_LOG_USER_ACTIONS (action,object,start_time,users) values ('create view',text,info.prev_exec_start,info.osuser);
              commit;
          end;
          end if;
      end;
      end if;
-- drop view
      if INSTR(info.sql_text,'drop view',1) > 0 then
      begin
          text := substr(info.sql_text,11,INSTR(info.sql_text,' ',11)-11);
          select coalesce(max(l.object),'not') into text2 from T_LOG_USER_ACTIONS l where
                 l.action = 'drop view' and l.object = text and l.start_time = info.prev_exec_start and l.users = info.osuser;
          if text2 = 'not' and INSTR(text,'$',1) = 0 then
          begin
              insert into T_LOG_USER_ACTIONS (action,object,start_time,users) values ('drop view',text,info.prev_exec_start,info.osuser);
              commit;
          end;
          end if;
      end;
      end if;
-- update
      if INSTR(info.sql_text,'update',1) > 0 then
      begin
          text := substr(info.sql_text,8,INSTR(info.sql_text,' ',8)-8);
          select coalesce(max(l.object),'not') into text2 from T_LOG_USER_ACTIONS l where
                 l.action = 'update' and l.object = text and l.start_time = info.prev_exec_start and l.users = info.osuser;
          if text2 = 'not' and INSTR(text,'$',1) = 0 then
          begin
              insert into T_LOG_USER_ACTIONS (action,object,start_time,users) values ('update',text,info.prev_exec_start,info.osuser);
              commit;
          end;
          end if;
      end;
      end if;
-- delete
      if INSTR(info.sql_text,'delete',1) > 0 then
      begin
      if INSTR(info.sql_text,' ',INSTR(info.sql_text,'from',1)+5) > 0 then
          text := substr(info.sql_text,INSTR(info.sql_text,'from',1)+5,INSTR(info.sql_text,' ',INSTR(info.sql_text,'from',1)+5)-INSTR(info.sql_text,'from',1)-5);
      else
          text := substr(info.sql_text,INSTR(info.sql_text,'from',1)+5,length(info.sql_text));
      end if;
          select coalesce(max(l.object),'not') into text2 from T_LOG_USER_ACTIONS l where
                 l.action = 'delete' and l.object = text and l.start_time = info.prev_exec_start and l.users = info.osuser;
          if text2 = 'not' and INSTR(text,'$',1) = 0 then
          begin
              insert into T_LOG_USER_ACTIONS (action,object,start_time,users) values ('delete',text,info.prev_exec_start,info.osuser);
              commit;
          end;
          end if;
      end;
      end if;
-- insert
      if INSTR(info.sql_text,'insert',1) > 0 then
      begin
      if INSTR(info.sql_text,' ',INSTR(info.sql_text,'into',1)+5) > 0 then
          text := substr(info.sql_text,INSTR(info.sql_text,'into',1)+5,INSTR(info.sql_text,' ',INSTR(info.sql_text,'into',1)+5)-INSTR(info.sql_text,'into',1)-5);
      else
          text := substr(info.sql_text,INSTR(info.sql_text,'into',1)+5,length(info.sql_text));
      end if;
          select coalesce(max(l.object),'not') into text2 from T_LOG_USER_ACTIONS l where
                 l.action = 'insert' and l.object = text and l.start_time = info.prev_exec_start and l.users = info.osuser;
          if text2 = 'not' and INSTR(text,'$',1) = 0 then
          begin
              insert into T_LOG_USER_ACTIONS (action,object,start_time,users) values ('insert',text,info.prev_exec_start,info.osuser);
              commit;
          end;
          end if;
      end;
      end if;
  end;
  end loop;

end edit_log;
/

