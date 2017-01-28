create or replace force view u1.nvetl_daily_not_ready as
select tt."TP",tt."OBJECT_NAME",tt."PROCEDURE_NAME_NEW",tt."CNT_REF_OBJ",tt."CNT_REF_OBJ_READY",tt."CNT_EVENT",tt."CNT_EVENT_READY"
    ,l.begin_refresh
    ,l.end_refresh
from (
    select
        'DAILY_MAIN_MVIEW' as tp
        ,tt.object_name
        ,'' as procedure_name_new
        --,min(tt.priority) as priority
        ,count(dl.object_name) as cnt_ref_obj
        ,count(l.end_refresh) as cnt_ref_obj_ready
        ,count(tt.reference_from_event) as cnt_event
        ,count(e.dt) as cnt_event_ready
    from NVETL_DAILYMAINMVIEW_NOTREADY tt
    left join NV_ETL_DEPENDENCIES dp on dp.owner = 'U1' and dp.name=tt.object_name and dp.name<>dp.referenced_name
    left join NVETL_DAILY_OBJECTS dl on dl.object_name= dp.referenced_name
    left join update_log l on l.object_name=dl.object_name and l.end_refresh>=trunc(sysdate) and l.end_refresh+(20/24/60/60)<sysdate and l.status='OK'
    left join NVETL_DAILY_EVENTS e on e.event = tt.reference_from_event
    group by
        tt.object_name
    union all
    select
         'DAILY_ADD_MVIEW'
        ,tt.object_name
        ,'' as procedure_name_new
        --,min(tt.priority) as priority
        ,count(dl.object_name) as cnt_ref_obj
        ,count(l.end_refresh) as cnt_ref_obj_ready
        ,count(tt.reference_from_event) as cnt_event
        ,count(e.dt) as cnt_event_ready
    from NVETL_DAILYADD_MVIEWNOTREADY tt
    left join NV_ETL_DEPENDENCIES dp on dp.owner = 'U1' and dp.name=tt.object_name and dp.name<>dp.referenced_name
    left join NVETL_DAILY_OBJECTS dl on dl.object_name= dp.referenced_name
    left join update_log l on l.object_name=dl.object_name and l.end_refresh>=trunc(sysdate) and l.end_refresh+(20/24/60/60)<sysdate and l.status='OK'
    left join NVETL_DAILY_EVENTS e on e.event = tt.reference_from_event
    group by
        tt.object_name
    union all
    select
         'DAILY_MAIN_TABLE'
        ,tt.object_name
        ,tt.procedure_name_new
        --,min(tt.priority) as priority
        ,count(dl.object_name) as cnt_ref_obj
        ,count(l.end_refresh) as cnt_ref_obj_ready
        ,count(tt.reference_from_event) as cnt_event
        ,count(e.dt) as cnt_event_ready
    from NVETL_DAILYMAIN_TABLENOTREADY tt
    left join NV_ETL_DEPENDENCIES dp on dp.owner = 'U1' and dp.name=tt.procedure_name_new /*tt.object_name*/ and dp.name<>dp.referenced_name and dp.referenced_name<> tt.object_name
    left join NVETL_DAILY_OBJECTS dl on dl.object_name= dp.referenced_name
    left join update_log l on l.object_name=dl.object_name and l.end_refresh>=trunc(sysdate) and l.end_refresh+(20/24/60/60)<sysdate and l.status='OK'
    left join NVETL_DAILY_EVENTS e on e.event = tt.reference_from_event
    group by tt.object_name,tt.procedure_name_new
    union all
    select
         'DAILY_ADD_TABLE'
        ,tt.object_name
        ,tt.procedure_name_new
        --,min(tt.priority) as priority
        ,count(dl.object_name) as cnt_ref_obj
        ,count(l.end_refresh) as cnt_ref_obj_ready
        ,count(tt.reference_from_event) as cnt_event
        ,count(e.dt) as cnt_event_ready
    from NVETL_DAILYADD_TABLENOTREADY tt
    left join NV_ETL_DEPENDENCIES dp on dp.owner = 'U1' and dp.name=tt.procedure_name_new /*tt.object_name*/ and dp.name<>dp.referenced_name and dp.referenced_name<> tt.object_name
    left join NVETL_DAILY_OBJECTS dl on dl.object_name= dp.referenced_name
    left join update_log l on l.object_name=dl.object_name and l.end_refresh>=trunc(sysdate) and l.end_refresh+(20/24/60/60)<sysdate and l.status='OK'
    left join NVETL_DAILY_EVENTS e on e.event = tt.reference_from_event
    group by tt.object_name,tt.procedure_name_new
) tt
left join (
  select t.object_name
      , min(t.begin_refresh) as begin_refresh
      ,min(t.end_refresh) as end_refresh
  from UPDATE_LOG t
  where t.end_refresh>=trunc(sysdate)-1 and t.status='OK'
  group by t.object_name
) l on l.object_name=tt.object_name
;
grant select on U1.NVETL_DAILY_NOT_READY to LOADDB;


