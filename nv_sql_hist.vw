create or replace force view u1.nv_sql_hist as
select
   trunc(t.LAST_ACTIVE_TIME) as dt
   ,extract (hour from cast(t.LAST_ACTIVE_TIME as timestamp)) as hh
  ,t.SDT, t.SCHEMA, t.SQL_ID, t.SQL_TEXT, t.MODULE, t.ACTION, t.LAST_ACTIVE_TIME
from NT_SQL_HIST t;
grant select on U1.NV_SQL_HIST to LOADDB;


