create or replace force view u1.nv_etl_daily_objects_used as
select tt.object_name
      ,count(distinct tt.username)  as cnt_user
      ,max(cnt_dt) as cnt_dt_max
      ,max(cnt_sql) as cnt_sql_max
      ,sum(cnt_dt) as cnt_dt_sum
      ,sum(cnt_sql) as cnt_sql_sum
from (
    select
          t.object_name
         ,t.username
         ,count(distinct t.dt) as cnt_dt
         ,sum(cnt_sql) as cnt_sql
    from NT_OBJECTSUSE t
    join (select distinct object_name from T_RDWH_PROC_OBJECT where type_load in ('DAILY','ONLINE') and is_used=1) r on r.object_name=t.object_name
    where t.owner='U1' and t.username not in ('U1','SYS') and t.dt>=trunc(sysdate)-45
    group by t.object_name, t.username
    having count(distinct t.dt)>0
           and sum(cnt_sql)>0
    order by t.object_name
) tt
group by tt.object_name;
grant select on U1.NV_ETL_DAILY_OBJECTS_USED to LOADDB;


