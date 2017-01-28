create or replace procedure u1.NPRC_GET_TREE_OBJECT(p_object_name varchar2, p_date_stat date) is
begin
  execute immediate('truncate table NT_OBJECT_DEPENDENCIES');  
  insert into NT_OBJECT_DEPENDENCIES
  select distinct *  
  from(
         select owner, name, referenced_name from SYS.DBA_DEPENDENCIES   
         union all
         select owner, name, referenced_name from T_RDWH_TABLE_DEPENDENCIES--NT_ETL_DEPENDENCIES  
  ) dp 
  where dp.owner = 'U1' and dp.name<>dp.referenced_name and dp.name<>'DUAL' and dp.referenced_name<>'DUAL';
  commit;
  execute immediate('truncate table NT_TREE_OBJECTS_DET');
  
  insert into NT_TREE_OBJECTS_DET
  select level as lvl
         ,CONNECT_BY_ISCYCLE as is_cycle
         ,t.name
         ,t.referenced_name
         ,CONNECT_BY_ISLEAF as is_source 
         ,l1.end_refresh as end_refresh_name
         ,l.end_refresh as end_refresh_refname
  from NT_OBJECT_DEPENDENCIES t
  join T_RDWH_PROC_OBJECT o on o.object_name=t.referenced_name
  join (
    select object_name, min(end_refresh) as end_refresh 
    from update_log 
    where begin_refresh between trunc(p_date_stat)-1 and trunc(p_date_stat)  
          and status='OK'
    group by object_name
  ) l on l.object_name = t.referenced_name
  join (
    select object_name, min(end_refresh) as end_refresh 
    from update_log 
    where begin_refresh between trunc(p_date_stat)-1 and trunc(p_date_stat)  
          and status='OK'
    group by object_name
  ) l1 on l1.object_name = t.name
  start with
      name = p_object_name
  connect by nocycle prior
      referenced_name=name;
  commit;
  
end NPRC_GET_TREE_OBJECT;
/

