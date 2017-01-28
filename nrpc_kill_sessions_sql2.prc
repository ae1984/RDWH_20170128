create or replace procedure u1.NRPC_KILL_SESSIONS_SQL2 is
   v_cnt number;
   v_cnt2 number;
begin
  return; 
/**************************************************************************************************************************************/
  insert into NT_KILLED_SESSIONS
  select sysdate as sdt,t.*, s.sql_text, 'sql_id в черном списке' as DESCR
  from (
    select t.sql_id,t.sql_exec_start,t.module, t.machine, t.username, t.osuser,t.action, count(*) as cnt from v$session t
    where t.sql_id  in (
                        select distinct t.sql_id from NT_SQL_SESSION_COUNT_HIST t
                        where t.sdt>=trunc(sysdate)-7 
                             and t.cnt_ses>150 
                             and t.sql_id is not null 
                             and t.machine<>'rdwhexp' 
                             and t.osuser<>'oracle' 
                             and t.osuser not in ('yevseyev_30149','krotov_29783')
                     )
    group by t.sql_id,t.sql_exec_start, t.module, t.machine, t.username, t.osuser,t.action
  ) t
  join NT_SQLID s on s.sql_id = t.sql_id;  
  commit;
  
  for ses in (select s.sid, s.serial#
              from sys.v_$session s
              where sql_id in (
                    select distinct t.sql_id from NT_SQL_SESSION_COUNT_HIST t
                    where t.sdt>=trunc(sysdate)-7 
                         and t.cnt_ses>150 
                         and t.sql_id is not null 
                         and t.machine<>'rdwhexp' 
                         and t.osuser<>'oracle' 
                         and t.osuser not in ('yevseyev_30149','krotov_29783')
               )             
             ) loop
    begin
      execute immediate 'alter system kill session ''' || ses.sid || ',' || ses.serial# || '''';
    exception when others then
      null;
    end;
  end loop;


end NRPC_KILL_SESSIONS_SQL2;
/

