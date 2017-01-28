﻿create or replace force view u1.v_sys_tables_and_views_columns as
select c.table_name as object_name,
       decode(o.object_type,1,'MV',2,'T',3,'V') as object_type,
       c.column_name, c.data_type
from user_tab_cols c
join (
  select object_name, min(object_type) as object_type from (
          select dmv.mview_name as object_name, '1' as object_type from dba_mviews dmv where dmv.OWNER='USER_1' union
          select dt.table_name as object_name, '2' as object_type from dba_tables dt where dt.owner='USER_1' union
          select dv.view_name as object_name, '3' as object_type from dba_views dv where dv.owner='USER_1'
      ) group by object_name
  ) o on o.object_name = c.table_name
order by c.table_name, c.column_name;
grant select on U1.V_SYS_TABLES_AND_VIEWS_COLUMNS to LOADDB;
grant select on U1.V_SYS_TABLES_AND_VIEWS_COLUMNS to LOADER;


