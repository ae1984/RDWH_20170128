create or replace function u1.par_effect_rate (name_u in varchar2) return par_effect_rateList pipelined as
  name_vd varchar (4000);
  viev integer;
  sec integer;
  ae float;
  average_effect float;
begin
  select count(*) into viev from sys.v_$session s where s.OSUSER like ''||name_u||'%' and s.status = 'ACTIVE';
  sec := 0;
  average_effect := 0;
  ae:=0;
  while viev>1 loop
  for name_vd in (select * from (select count(*) as session_count,
                         count(case when s.PGA_TUNABLE_MEM > 0 then s.SID end) as session_active_count,
                         round(count(case when s.PGA_TUNABLE_MEM > 0 then s.SID end) /
                         count(*) * 100,1) as par_effect_rate,
                          s.OSUSER, s.username, s.MACHINE,s.SQL_ID
                          from sys.v_$session s
                          where s.OSUSER like ''||name_u||'%' and s.status = 'ACTIVE'
                          group by s.username, s.OSUSER, s.MACHINE,s.SQL_ID
                          order by 1 desc) a where a.session_count >1) loop
       begin
       DBMS_LOCK.SLEEP(SECONDS => 1);
       end;
       pipe row (par_effect_rateObject(name_vd.session_count, name_vd.session_active_count,name_vd.par_effect_rate,name_vd.osuser,name_vd.username,name_vd.machine,name_vd.sql_id,sec,average_effect));
       sec:= sec+1;
       ae:=ae+name_vd.par_effect_rate;
       average_effect:= ae/sec;
       select count(*) into viev from sys.v_$session s where s.OSUSER like ''||name_u||'%' and s.status = 'ACTIVE';
       
  end loop;
  end loop;
  return;
end par_effect_rate;
/

