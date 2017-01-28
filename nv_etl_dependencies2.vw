create or replace force view u1.nv_etl_dependencies2 as
select zz.owner, zz.name, zz.referenced_name from (
  select distinct owner, name, referenced_name from SYS.DBA_DEPENDENCIES where owner='U1' and referenced_owner='U1' and referenced_link_name is null
  union
  select distinct owner, name, referenced_name from NT_ETL_DEPENDENCIES where owner='U1'
) zz
left join NT_ETL_DEPENDENCIES_EXCLUSION ex on ex.owner='U1' and ex.name=zz.name and ex.referenced_name=zz.referenced_name
left join NTETL_DAILY_OBJ_DEPENDENCIES exo on exo.object_name=zz.referenced_name
where ex.name is null and exo.object_name is null
     and zz.name <> zz.referenced_name
     and zz.referenced_name not in (
       'DUAL','STANDARD','DBMS_STANDARD','XML_SCHEMA_NAME_PRESENT'
     );
grant select on U1.NV_ETL_DEPENDENCIES2 to LOADDB;


