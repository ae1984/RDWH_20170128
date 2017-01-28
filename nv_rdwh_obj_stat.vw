create or replace force view u1.nv_rdwh_obj_stat as
select t.obj_name
       ,t.numrows as numrows_t1
       ,b.numrows as numrows_t7
       ,a.numrows_avg_2w
       , case when t.numrows <>0
           then abs(100-round(greatest(t.numrows,a.numrows_avg_2w)/least(t.numrows,a.numrows_avg_2w),2)*100)
           else 100
         end as diff_prc_t1
       , case when b.numrows <>0
           then abs(100-round(greatest(b.numrows,a.numrows_avg_2w)/least(b.numrows,a.numrows_avg_2w),2)*100)
           else 100
         end as diff_prc_t7
       ,abs( case when t.numrows <>0
           then abs(100-round(greatest(t.numrows,a.numrows_avg_2w)/least(t.numrows,a.numrows_avg_2w),2)*100)
           else 100
         end
       - case when b.numrows <>0
           then abs(100-round(greatest(b.numrows,a.numrows_avg_2w)/least(b.numrows,a.numrows_avg_2w),2)*100)
           else 100
         end
       ) as diff_prc
from (
    select t.obj_name
          ,max(t.numrows) as numrows
    from NT_RDWH_OBJ_NUMROWS t
    where trunc(t.dt) = trunc(sysdate)-1
    group by t.obj_name
) t
join T_RDWH_PROC_OBJECT o on o.object_name=t.obj_name and o.is_used=1 and o.type_load in ('DAILY','ONLINE')
left join (
    select t.obj_name
          ,max(t.numrows) as numrows
    from NT_RDWH_OBJ_NUMROWS t
    where trunc(t.dt) = trunc(sysdate)-7
    group by t.obj_name
) b on b.obj_name=t.obj_name
join (
  select t.obj_name
        ,trunc(avg(t.numrows)) as numrows_avg_2w
  from NT_RDWH_OBJ_NUMROWS t
  where trunc(t.dt) between trunc(sysdate)-15 and trunc(sysdate)-2 --and t.numrows>0
  group by t.obj_name
) a on a.obj_name =t.obj_name and a.numrows_avg_2w>0
;
grant select on U1.NV_RDWH_OBJ_STAT to LOADDB;


