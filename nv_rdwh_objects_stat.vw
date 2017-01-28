create or replace force view u1.nv_rdwh_objects_stat as
select t.obj_name, avg(t.delta) as delta_avg, min(t.numrows) as numrows_min, max(t.numrows) as numrows_max
from (
  select
     t.*
     ,trunc(t.dt) as dt_t
     ,t.numrows-lag(t.numrows) over (partition by t.obj_name order by t.dt) as delta
  from NT_RDWH_OBJ_NUMROWS t
  where t.dt >= trunc(sysdate)-45
) t
group by t.obj_name;
grant select on U1.NV_RDWH_OBJECTS_STAT to LOADDB;


