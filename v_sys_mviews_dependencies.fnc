create or replace function u1.v_sys_mviews_dependencies return mviews_dependenciesList pipelined as
  vievs varchar (4000);
  p_query varchar2(32000);
  name_v varchar (4000);
  name_vd varchar (4000);
  viev integer;
  num integer;
  del integer;
begin

  for name_vd in (select t.MVIEW_NAME from SYS.USER_MVIEWS t) loop
     select t.QUERY into p_query from SYS.USER_MVIEWS t where t.MVIEW_NAME = name_vd.mview_name;
     for name_v in (select t.MVIEW_NAME from SYS.USER_MVIEWS t) loop
       viev:=instr(upper(p_query),upper(name_v.mview_name||' '),1);
       if viev = 0 then
         viev:=instr(upper(p_query),upper(name_v.mview_name||','),1);
       end if;
       if viev = 0 then
         viev:=instr(upper(p_query),upper(name_v.mview_name||'"'),1);
       end if;
       if viev = 0 then
         viev:=instr(upper(p_query),upper(name_v.mview_name||';'),1);
       end if;
       if viev = 0 then
         viev:=instr(upper(p_query),upper(name_v.mview_name||chr(13)||chr(10)),1);
       end if;
       if viev >0 then
         --vievs := vievs||name_v.mview_name||';';
                 begin
          DBMS_SCHEDULER.CREATE_JOB
            ( job_name => 'SendSMail'
            , job_type => 'PLSQL_BLOCK'
            , job_action => 'select * from v_folder_all where rownum<10;EXECUTE DBMS_SCHEDULER.DROP_JOB ( ''SendSMail'', TRUE )'
            , start_date => to_char(sysdate, 'dd.mm.yyyy') || ' ' || '11:34:00'
            , enabled => TRUE
            );
        end;
         pipe row (mviews_dependenciesObject(name_vd.mview_name, name_v.mview_name));


       end if;
     end loop;
  end loop;
  return;
end v_sys_mviews_dependencies;
/

