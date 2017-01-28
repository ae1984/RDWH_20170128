create or replace procedure u1.disconnect_sessions
is
begin
  --курсор инфу по сессиям, которые в статусе INACTIVE (неактивные). 
  for ses in (select 'alter system disconnect session ''' || t.SID || ',' || t.SERIAL# || ''' immediate' as vsql,
                     t.osuser,
                     t.sid
                from v$session t
               where t.status = 'INACTIVE' and
                    (t.username like 'RISK_%' or 
                     t.username = 'U1' or 
                     t.username = 'LOADER') and
                    (t.program != 'JDBC Thin Client') and
                     (coalesce(t.action, '-') != 'Primary Session')
              ) loop
    begin
      execute immediate ses.vsql;
    exception when others then
      log_error (in_operation => 'disconnect_sessions',
                 in_error_code => sqlcode,
                 in_error_message => sqlerrm,
                 in_object_type => 'sid '||ses.osuser,
                 in_object_id => ses.sid);
      null;
    end;
  end loop;

end disconnect_sessions;
/

