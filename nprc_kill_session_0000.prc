create or replace procedure u1.NPRC_KILL_SESSION_0000 is
begin
  insert into NT_KILLED_SESSIONS
  select sysdate as sdt,t.*, null as sql_text, 'Уничтожаем все сессии в 23:58 c action=JOBRT%' as DESCR
  from (
    select t.sql_id,t.sql_exec_start,t.module, t.machine, t.username, t.osuser,t.action, count(*) as cnt from v$session t
    where upper(t.action) like 'JOBRT%'
    group by t.sql_id,t.sql_exec_start,t.module, t.machine, t.username, t.osuser,t.action
  ) t;   
  commit;

  for ses in (select s.sid, s.serial#
              from sys.v_$session s
              where upper(s.action) like 'JOBRT%'
             ) loop
    begin
      execute immediate 'alter system kill session ''' || ses.sid || ',' || ses.serial# || '''';
    exception when others then
      null;
    end;
  end loop; 
  for rec in (select t.sid,t.serial# from v$session t where t.status = 'KILLED' ) loop 
    begin
      execute immediate ('ALTER SYSTEM DISCONNECT SESSION '''||rec.sid||','||rec.serial#||''' IMMEDIATE');
    exception when others then
      null;
    end;    
  end loop;   
end NPRC_KILL_SESSION_0000;
/

