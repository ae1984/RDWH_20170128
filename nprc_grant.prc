create or replace procedure u1.NPRC_GRANT is
begin
   for rec in (
      select 'grant select on '||t.table_name||' to '||t.grantee as sql1
      from (
        select t.grantee, t.table_name, t.privilege, t.owner 
        from NT_USER_TAB_PRIVS_HIST t
        where t.sdt>=trunc(sysdate)-1
        group by t.grantee, t.table_name, t.privilege, t.owner
      ) t
      left join USER_TAB_PRIVS a on a.grantee=t.grantee and a.table_name=t.table_name and a.privilege=t.privilege and a.owner=t.owner
      join update_log l on l.object_name = t.table_name and l.end_refresh>=trunc(sysdate) and l.status='OK'
      where a.privilege is null and t.privilege='SELECT' and t.grantee='LOAD_MO'
   ) loop
      execute immediate (rec.sql1); 
   end loop;   
end NPRC_GRANT;
/

