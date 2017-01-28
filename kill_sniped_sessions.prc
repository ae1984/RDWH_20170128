create or replace procedure u1.kill_sniped_sessions is
begin



  for i in (select 'alter system disconnect session ''' || t.SID || ',' || t.SERIAL# || ''' immediate' as killtext,
                   t.program,
                   t.action,
                   t.username,
                   t.OSUSER,
                   t.sid
            from v$session t
            where t.status = 'KILLED' or t.status = 'SNIPED'
                  /*and t.username in ('U1', 'DM', 'LOADER','RISK_BRENAT','RISK_SDARYA','RISK_DERBOL','RISK_MROZA','RISK_DSHOLPAN','RISK_VERIF',
                                    'RISK_RKATE','RISK_OALEX','RISK_SDIANA','RISK_ERBOL','RISK_SHNARGIZ','RISK_TMALIKA','RISK_AAMAN','RISK_MVERA',
                                    'RISK_GKIM','RISK_CHDEN','RISK_NALMAZ','RISK_ESERGEY','RISK_GTANYA','RISK_ARCHIL','RISK_JAN','RISK_2FLOOR')*/)
  loop

    begin

    execute immediate i.killtext;
    exception when others then

      log_error (in_operation => 'kill_killed_sessions',
                 in_error_code => sqlcode,
                 in_error_message => sqlerrm,
                 in_object_type => 'sid',
                 in_object_id => i.sid);
    end;

  end loop;

end kill_sniped_sessions;
/

