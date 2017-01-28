create or replace procedure u1.NPRC_FIND_USE_OBJECTS(p_name varchar2) is
begin
  /*delete from nt_objectsuse2;
  commit;*/
  insert into nt_objectsuse2
  select distinct p_name, tt.name as name_ref
  from (
    select level
           ,CONNECT_BY_ISCYCLE as is_cycle
           ,t.*
           ,CONNECT_BY_ISLEAF as is_source 

    from USER_DEPENDENCIES t
    start with
        name = p_name
    connect by nocycle prior
        --name=referenced_name
        referenced_name=name
  ) tt;
  commit;  
end NPRC_FIND_USE_OBJECTS;
/

