create or replace procedure u1.NPRC_REVOKE_LOAD_MO is
begin
  
   for rec in (
          select distinct 'revoke select on '||t.plan_object_name||' from LOAD_MO' as sql1 
          from NT_SQL_PLAN_MONITOR_HIST t
          where t.sql_exec_start>=trunc(sysdate) 
               and t.sql_id in (
                          select t.sql_id
                          from NT_SQLEXEC_HIST t
                          where t.sql_exec_start >= trunc(sysdate) and t.username='LOAD_MO' and extract (hour from cast(t.sql_exec_start as timestamp) ) in (0,1,2,3,4,5,6,7)
                          group by  t.sql_id, t.username
                          having count(*)>4
               ) and t.plan_object_owner='U1'
   ) loop
      begin
        execute immediate (rec.sql1); 
      exception when others then
        null;
      end;      
   end loop;  

end NPRC_REVOKE_LOAD_MO;
/

