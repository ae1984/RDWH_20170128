create or replace procedure u1.kill_sessions is
begin

  for ses in (select s.sid, s.serial#
                from sys.v_$session s
               where (s.username in ('U1', 'DM', 'LOADER','RTDM_USER')
                      or s.username like 'RISK%')
                 and s.audsid != userenv('SESSIONID')
                 and s.OSUSER != 'SYSTEM'
                 and upper(s.OSUSER) != 'ORACLE'
                 --and s.ACTION not like 'Text Importer%'
                 and (s.program not like '%JDBC%' or upper(s.program) not like 'LAB128%')
                 and upper(s.program) not like '%LUNA_TASK_EXECUTER%'
                 and upper(s.program) not like upper('%GetPhotoFromPhotoDB%')
                 and upper(s.program) <> 'DBFORGEORACLE.EXE' 
                 and s.username <> 'RISK_ALEXEY'                   
                 ) loop
    begin
      execute immediate 'alter system kill session ''' || ses.sid || ',' || ses.serial# || '''';
      --dbms_output.put_line('alter system kill session ''' || ses.sid || ',' || ses.serial# || '''');
    exception when others then
      --dbms_output.put_line(sqlerrm);
      log_error (in_operation => 'kill_sessions',
                 in_error_code => sqlcode,
                 in_error_message => sqlerrm,
                 in_object_type => 'sid',
                 in_object_id => ses.sid);
      null;
    end;
  end loop;
  
  for rec in (select t.sid,t.serial# from v$session t where t.status = 'KILLED' ) loop begin
    execute immediate ('ALTER SYSTEM DISCONNECT SESSION '''||rec.sid||','||rec.serial#||''' IMMEDIATE');
    exception when others then
      log_error (in_operation => 'DISCONNECT_SESSION',
                 in_error_code => sqlcode,
                 in_error_message => sqlerrm,
                 in_object_type => 'sid',
                 in_object_id => rec.sid);      
      null;
    end;      
  end loop;
end kill_sessions;
/

