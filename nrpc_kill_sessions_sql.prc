create or replace procedure u1.NRPC_KILL_SESSIONS_SQL is
   v_cnt number;
   v_cnt2 number;
   
begin

/**************************************************************************************************************************************/
  insert into NT_KILLED_SESSIONS
  select sysdate as sdt,t.*, s.sql_text, 'Превысил 70сессий на запрос' as DESCR
  from (
    select t.sql_id,t.sql_exec_start,t.module, t.machine, t.username, t.osuser,t.action, count(*) as cnt from v$session t
    where t.sql_id is not null 
          and lower(t.osuser) in (
                      'golovkina_10532'
                      ,'kazymbetov_30023'
                      ,'kim_17004'
                      ,'nazirov_19076'
                      ,'sukhorukova_28014'
                      --,'yevseyev_30149'
                      ,'kerimkul_31700'
                     )
    group by t.sql_id,t.sql_exec_start, t.module, t.machine, t.username, t.osuser,t.action
    having count(*)>70
  ) t
  join NT_SQLID s on s.sql_id = t.sql_id;  
  commit;
  
  for ses in (select s.sid, s.serial#
              from sys.v_$session s
              where sql_id in (
                  select t.sql_id
                  from (
                    select t.sql_id,t.sql_exec_start,t.module, t.machine, t.username, t.osuser,t.action, count(*) as cnt from v$session t
                    where t.sql_id is not null 
                        and lower(t.osuser) in (
                          'golovkina_10532'
                          ,'kazymbetov_30023'
                          ,'kim_17004'
                          ,'nazirov_19076'
                          ,'sukhorukova_28014'
                          --,'yevseyev_30149'
                          ,'kerimkul_31700'
                         )
                    group by t.sql_id,t.sql_exec_start, t.module, t.machine, t.username, t.osuser,t.action
                    having count(*)>70
                  ) t
                  join NT_SQLID s on s.sql_id = t.sql_id
               )             
             ) loop
    begin
      execute immediate 'alter system kill session ''' || ses.sid || ',' || ses.serial# || '''';
    exception when others then
      null;
    end;
  end loop;

/**************************************************************************************************************************************/

  /*select count(*) into v_cnt 
  from NT_RDWH_PROC_OBJECT_HIST t
  left join UPDATE_LOG a on a.object_name = trim(t.object_name) and nvl(a.status,'-') = 'OK' and a.begin_refresh between trunc(sysdate) and sysdate--12/24 
  where t.type_load='DAILY' and t.load_group <> 'ADD' and t.is_used=1 and trunc(t.sdt)=trunc(sysdate)-1 and t.object_type<>'VIEW' and a.id is null;

  select count(t.object_name) - count(l.end_refresh)  into v_cnt2
  from NT_RDWH_PROC_OBJECT_HIST t
  left join update_log l on l.object_name=t.object_name and l.begin_refresh >=trunc(sysdate)
  where t.sdt >=trunc(sysdate)-1 and t.type_load='DAILY' and t.is_used=1 and t.load_group='ADD';
  
  if v_cnt2+v_cnt >0 then
    return;
  end if;*/
          
  insert into NT_KILLED_SESSIONS
  select sysdate as sdt,t.*, s.sql_text, 'Превысил 150сессий на запрос' as DESCR
  from (
    select t.sql_id,t.sql_exec_start,t.module, t.machine, t.username, t.osuser,t.action, count(*) as cnt from v$session t
    where t.sql_id is not null and t.username like 'RISK%'
    group by t.sql_id,t.sql_exec_start, t.module, t.machine, t.username, t.osuser,t.action
    having count(*)>150--290
  ) t
  join NT_SQLID s on s.sql_id = t.sql_id;  
  commit;
  
  for ses in (select s.sid, s.serial#
              from sys.v_$session s
              where sql_id in (
                  select t.sql_id
                  from (
                    select t.sql_id,t.sql_exec_start,t.module, t.machine, t.username, t.osuser,t.action, count(*) as cnt from v$session t
                    where t.sql_id is not null and t.username like 'RISK%'
                    group by t.sql_id,t.sql_exec_start, t.module, t.machine, t.username, t.osuser,t.action
                    having count(*)>150--290
                  ) t
                  join NT_SQLID s on s.sql_id = t.sql_id
               )             
             ) loop
    begin
      execute immediate 'alter system kill session ''' || ses.sid || ',' || ses.serial# || '''';
    exception when others then
      /*log_error (in_operation => 'kill_sessions_sql',
                 in_error_code => sqlcode,
                 in_error_message => sqlerrm,
                 in_object_type => 'sid',
                 in_object_id => ses.sid);*/
      null;
    end;
  end loop;
/**************************************************************************************************************************************/

 
  insert into NT_KILLED_SESSIONS 
  select sysdate as sdt,t.*, s.sql_text, '30мин простой запроса с превышением в 10сессий' as DESCR
  from (
    select t.sql_id,t.sql_exec_start,t.module, t.machine, t.username, t.osuser,t.action,count(*) as cnt from v$session t
    where t.sql_id is not null and (sysdate-t.sql_exec_start)*24*60 >30
          and --t.username not in ('LOADDB','DHK_USER','LOAD_MO')
              (
               (t.username like 'RISK%' and t.username <> 'RISK_ALEXEY')
               or  (t.username='U1' 
                    and lower(t.osuser) in (
                      'golovkina_10532'
                      ,'kazymbetov_30023'
                      ,'kim_17004'
                      ,'nazirov_19076'
                      ,'nurgaliyev_11431'
                      ,'sukhorukova_28014'
                      --,'yevseyev_30149'
                      ,'kerimkul_31700'
                     )
                   )
              )
    group by t.sql_id,t.module, t.machine, t.username,t.osuser,t.action,t.sql_exec_start
    having count(*)>=10
  ) t
  join NT_SQLID s on s.sql_id = t.sql_id and substr(lower(s.sql_fulltext),1,20) like '%select%';
  commit;

  for ses in (select s.sid, s.serial#
              from sys.v_$session s
              where sql_id in (
                select t.sql_id
                from (
                  select t.sql_id,t.sql_exec_start,t.module, t.machine, t.username, t.osuser,t.action from v$session t
                  where t.sql_id is not null and (sysdate-t.sql_exec_start)*24*60 >30
                        and --t.username not in ('LOADDB','DHK_USER','LOAD_MO')
                            (
                             (t.username like 'RISK%' and t.username <> 'RISK_ALEXEY')
                             or  (t.username='U1' 
                                  and lower(t.osuser) in (
                                    'golovkina_10532'
                                    ,'kazymbetov_30023'
                                    ,'kim_17004'
                                    ,'nazirov_19076'
                                    ,'nurgaliyev_11431'
                                    ,'sukhorukova_28014'
                                    --,'yevseyev_30149'
                                    ,'kerimkul_31700'
                                   )
                                 )
                            )
                  group by t.sql_id,t.module, t.machine, t.username,t.osuser,t.action,t.sql_exec_start
                  having count(*)>=10
                ) t
                join NT_SQLID s on s.sql_id = t.sql_id and substr(lower(s.sql_fulltext),1,20) like '%select%'
               )             
             ) loop
    begin
      execute immediate 'alter system kill session ''' || ses.sid || ',' || ses.serial# || '''';
    exception when others then
      /*log_error (in_operation => 'kill_sessions_sql',
                 in_error_code => sqlcode,
                 in_error_message => sqlerrm,
                 in_object_type => 'sid',
                 in_object_id => ses.sid);*/
      null;
    end;
  end loop;
  
/**************************************************************************************************************************************/        
  insert into NT_KILLED_SESSIONS
  select sysdate as sdt,t.*, null as sql_text, 'Более 30мин. заблокировал объект с 0 до 9 утра' as DESCR
  from (
    select t.sql_id,t.sql_exec_start,t.module, t.machine, t.username, t.osuser,t.action, count(*) as cnt from v$session t
              where t.osuser in (
                  select tt.osuser --tt.*, (tt.sdt_max- tt.sdt_min)*24*60*60 as interval_sec
                  from (
                  select t.osuser, t.object_name
                      , min(t.sdt) as sdt_min
                      , max(t.sdt) as sdt_max
                  from NT_LOCKEDOBJ_HIST t
                  where t.sdt>=trunc(sysdate) and extract (hour from cast(t.sdt as timestamp) ) in (0,1,2,3,4,5,6,7,8)
                       and t.owner='U1' 
                       --and t.object_name like 'T_RDWH_PROC_OBJECT%'
                       --and t.osuser='kerimkul_31700'
                       and lower(t.osuser) in (
                                        'golovkina_10532'
                                        ,'kazymbetov_30023'
                                        --,'kim_17004'
                                        ,'nazirov_19076'
                                        ,'sukhorukova_28014'
                                        --,'yevseyev_30149'
                                        ,'kerimkul_31700'
                                       )     
                  group by t.osuser, t.object_name
                  ) tt
                  where (tt.sdt_max- tt.sdt_min)*24*60*60> 1800  and extract (hour from cast(sysdate as timestamp) ) in (0,1,2,3,4,5,6,7,8)             
              )
            group by t.sql_id,t.sql_exec_start,t.module, t.machine, t.username, t.osuser,t.action
  ) t;   
  commit;

  for ses in (select s.sid, s.serial#
              from sys.v_$session s
              where s.osuser in (
                  select tt.osuser --tt.*, (tt.sdt_max- tt.sdt_min)*24*60*60 as interval_sec
                  from (
                  select t.osuser, t.object_name
                      , min(t.sdt) as sdt_min
                      , max(t.sdt) as sdt_max
                  from NT_LOCKEDOBJ_HIST t
                  where t.sdt>=trunc(sysdate) and extract (hour from cast(t.sdt as timestamp) ) in (0,1,2,3,4,5,6,7,8)
                       and t.owner='U1' 
                       --and t.object_name like 'T_RDWH_PROC_OBJECT%'
                       --and t.osuser='kerimkul_31700'
                       and lower(t.osuser) in (
                                        'golovkina_10532'
                                        ,'kazymbetov_30023'
                                        --,'kim_17004'
                                        ,'nazirov_19076'
                                        ,'sukhorukova_28014'
                                        --,'yevseyev_30149'
                                        ,'kerimkul_31700'
                                       )     
                  group by t.osuser, t.object_name
                  ) tt
                  where (tt.sdt_max- tt.sdt_min)*24*60*60> 1800 and extract (hour from cast(sysdate as timestamp) ) in (0,1,2,3,4,5,6,7,8)              
              )
             ) loop
    begin
      execute immediate 'alter system kill session ''' || ses.sid || ',' || ses.serial# || '''';
    exception when others then
      null;
    end;
  end loop;
  
/**************************************************************************************************************************************/  
  insert into NT_KILLED_SESSIONS
  select sysdate as sdt,t.*, null as sql_text, 'Сессия висит более 20ти часов' as DESCR
  from (
    select t.sql_id,t.sql_exec_start,t.module, t.machine, t.username, t.osuser,t.action, count(*) as cnt from v$session t
    where (sysdate-t.sql_exec_start)*24>20
    group by t.sql_id,t.sql_exec_start,t.module, t.machine, t.username, t.osuser,t.action
  ) t;   
  commit;

  for ses in (select s.sid, s.serial#
              from sys.v_$session s
              where (sysdate-s.sql_exec_start)*24>20
             ) loop
    begin
      execute immediate 'alter system kill session ''' || ses.sid || ',' || ses.serial# || '''';
    exception when others then
      null;
    end;
  end loop;

/**************************************************************************************************************************************/ 


            
  for rec in (select t.sid,t.serial# from v$session t where t.status = 'KILLED' ) loop begin
    execute immediate ('ALTER SYSTEM DISCONNECT SESSION '''||rec.sid||','||rec.serial#||''' IMMEDIATE');
    exception when others then
      /*log_error (in_operation => 'DISCONNECT_SESSION',
                 in_error_code => sqlcode,
                 in_error_message => sqlerrm,
                 in_object_type => 'sid',
                 in_object_id => rec.sid);*/      
      null;
    end;      
  end loop;
end NRPC_KILL_SESSIONS_SQL;
/

