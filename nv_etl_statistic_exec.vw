create or replace force view u1.nv_etl_statistic_exec as
select
       trunc(l.end_refresh) as dt
       ,count(*) as cnt_ready
       ,sum(case when extract (hour from cast(l.end_refresh as timestamp) ) in (0,1,2,3,4,5,6,7,8,9,10) then 1 else 0 end) as cnt_ready_11
       ,sum(case when extract (hour from cast(l.end_refresh as timestamp) ) in (0,1,2,3,4,5,6,7,8,9) then 1 else 0 end) as cnt_ready_10
       ,sum(case when extract (hour from cast(l.end_refresh as timestamp) ) in (0,1,2,3,4,5,6,7,8) then 1 else 0 end) as cnt_ready_9
       ,sum(case when extract (hour from cast(l.end_refresh as timestamp) ) in (0,1,2,3,4,5,6,7) then 1 else 0 end) as cnt_ready_8
       ,sum(case when extract (hour from cast(l.end_refresh as timestamp) ) in (0,1,2,3,4,5,6) then 1 else 0 end) as cnt_ready_7
       ,sum(case when extract (hour from cast(l.end_refresh as timestamp) ) in (0,1,2,3,4,5) then 1 else 0 end) as cnt_ready_6
       ,sum(case when extract (hour from cast(l.end_refresh as timestamp) ) in (0,1,2,3,4) then 1 else 0 end) as cnt_ready_5
       ,sum(case when extract (hour from cast(l.end_refresh as timestamp) ) in (0,1,2,3) then 1 else 0 end) as cnt_ready_4
       ,sum(case when extract (hour from cast(l.end_refresh as timestamp) ) in (0,1,2) then 1 else 0 end) as cnt_ready_3
       ,sum(case when extract (hour from cast(l.end_refresh as timestamp) ) in (0,1) then 1 else 0 end) as cnt_ready_2
       ,sum(case when extract (hour from cast(l.end_refresh as timestamp) ) in (0) then 1 else 0 end) as cnt_ready_1


       ,sum(case when extract (hour from cast(l.end_refresh as timestamp) ) in (12) then 1 else 0 end) as cnt_13
       ,sum(case when extract (hour from cast(l.end_refresh as timestamp) ) in (11) then 1 else 0 end) as cnt_12
       ,sum(case when extract (hour from cast(l.end_refresh as timestamp) ) in (10) then 1 else 0 end) as cnt_11
       ,sum(case when extract (hour from cast(l.end_refresh as timestamp) ) in (9) then 1 else 0 end) as cnt_10
       ,sum(case when extract (hour from cast(l.end_refresh as timestamp) ) in (8) then 1 else 0 end) as cnt_9
       ,sum(case when extract (hour from cast(l.end_refresh as timestamp) ) in (7) then 1 else 0 end) as cnt_8
       ,sum(case when extract (hour from cast(l.end_refresh as timestamp) ) in (6) then 1 else 0 end) as cnt_7
       ,sum(case when extract (hour from cast(l.end_refresh as timestamp) ) in (5) then 1 else 0 end) as cnt_6
       ,sum(case when extract (hour from cast(l.end_refresh as timestamp) ) in (4) then 1 else 0 end) as cnt_5
       ,sum(case when extract (hour from cast(l.end_refresh as timestamp) ) in (3) then 1 else 0 end) as cnt_4
       ,sum(case when extract (hour from cast(l.end_refresh as timestamp) ) in (2) then 1 else 0 end) as cnt_3
       ,sum(case when extract (hour from cast(l.end_refresh as timestamp) ) in (1) then 1 else 0 end) as cnt_2
       ,sum(case when extract (hour from cast(l.end_refresh as timestamp) ) in (0) then 1 else 0 end) as cnt_1
  from T_RDWH_PROC_OBJECT t
  join (select object_name, min(end_refresh) as end_refresh from update_log group by object_name, trunc(end_refresh))
  l on l.object_name = t.object_name and l.end_refresh >= to_date('27.03.2016','dd.mm.yyyy')
  where t.type_load in ('DAILY','ONLINE')
  group by trunc(l.end_refresh)
  order by trunc(l.end_refresh);
grant select on U1.NV_ETL_STATISTIC_EXEC to LOADDB;


