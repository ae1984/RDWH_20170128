create or replace procedure u1.NPRC_OBJECT_DAILY_USED is
begin
  execute immediate ('truncate table NT_OBJECT_NAME_USED');
  execute immediate ('truncate table NT_OBJECT_NAME_USED_BUFF');
  insert into NT_OBJECT_NAME_USED_BUFF
  select distinct t.object_name, sysdate as sdt --,t.* 
  from (
     select object_name from NV_ETL_DAILY_OBJECTS_USED
     union 
     select object_name from T_RDWH_PROC_OBJECT where is_used=1
  ) t;
  commit;          
  for rec in (
          /*select nvl(a.procedure_name_new,t.object_name) as object_name_real --,t.* 
          from NV_ETL_DAILY_OBJECTS_USED t
          left join T_RDWH_TABLE_UTIL_PROCEDURES a on a.object_name=t.object_name*/    
          select distinct nvl(a.procedure_name_new,t.object_name) as object_name_real --,t.* 
          from (
             select object_name from NV_ETL_DAILY_OBJECTS_USED
             union 
             select object_name from T_RDWH_PROC_OBJECT where is_used=1
          ) t
          left join T_RDWH_TABLE_UTIL_PROCEDURES a on a.object_name=t.object_name            
  ) loop
      insert into NT_OBJECT_NAME_USED_BUFF
      select distinct t.referenced_name as object_name, sysdate as sdt
      from (
        select t.*,nvl(a.procedure_name_new,t.referenced_name) as referenced_name_real
        from NV_ETL_DEPENDENCIES t
        left join T_RDWH_TABLE_UTIL_PROCEDURES a on a.object_name=t.referenced_name
        where t.owner='U1'
      ) t --and t.name='ETLT_DWH_PORT'
        
      start with
            name =rec.object_name_real
      connect by nocycle prior
           --name=referenced_name_real
           referenced_name_real=name ;
      commit; 
  end loop;  
  insert into NT_OBJECT_NAME_USED
  select object_name, min(sdt) sdt from NT_OBJECT_NAME_USED_BUFF
  group by object_name;
  commit;
end NPRC_OBJECT_DAILY_USED;
/

