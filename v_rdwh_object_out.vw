CREATE OR REPLACE FORCE VIEW U1.V_RDWH_OBJECT_OUT AS
select tp.grantee, --Пользователь имеющий доступ
       tp.table_name as object_name, --Объект
       nvl(do.object_type, tp.type) as object_type --Тип объекта
  from dba_tab_privs tp
  left join dba_objects do on tp.table_name = do.object_name and do.owner = 'U1' and do.OBJECT_TYPE = 'MATERIALIZED VIEW'
 where tp.owner = 'U1'
       and tp.grantee in ('AIDA','AUTO_USER','DHK_USER','DNP','DSM_USER','FINAN','IT6_USER','RISK_VERIF','RISK_2FLOOR','LOAD_MO','LOAD_RDWH_PROD')
       and tp.privilege = 'SELECT'
       and tp.TABLE_NAME not like 'BIN%'
 group by tp.grantee, tp.table_name, nvl(do.object_type, tp.type)
 order by tp.table_name
;
grant select on U1.V_RDWH_OBJECT_OUT to LOADDB;
grant select on U1.V_RDWH_OBJECT_OUT to LOADER;


