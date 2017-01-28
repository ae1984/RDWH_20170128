create or replace procedure u1.NRPC_KILL_SESSIONS_LOCKEDOBJ is
   v_cnt number;
   v_cnt2 number;
   
begin
  null;
       
  /*insert into NT_KILLED_SESSIONS
  select sysdate as sdt,t.*, null as sql_text, 'Пользователь заблокировал объект более 60мин' as DESCR
  from (
    select t.sql_id,t.sql_exec_start,t.module, t.machine, t.username, t.osuser,t.action, count(*) as cnt from v$session t
              where t.osuser in (
                  select osuser from NV_USERS_LOCKED_OBJECT    
              )
            group by t.sql_id,t.sql_exec_start,t.module, t.machine, t.username, t.osuser,t.action
  ) t;   
  commit;

  for ses in (select s.sid, s.serial#
              from sys.v_$session s
              where s.osuser in (
                 select osuser from NV_USERS_LOCKED_OBJECT           
              )
             ) loop
    begin
      execute immediate 'alter system kill session ''' || ses.sid || ',' || ses.serial# || '''';
    exception when others then
      null;
    end;
  end loop;*/

end NRPC_KILL_SESSIONS_LOCKEDOBJ;
/

