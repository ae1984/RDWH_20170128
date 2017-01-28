create or replace force view u1.nvetl_monthly_not_ready as
select
        'TABLE' as type_object
        ,tt.object_name
        ,tt.procedure_name_new
        ,tt.check_proc
        ,min(tt.priority) as priority
        ,count(dl.object_name) as cnt_ref_obj
        ,count(l.end_refresh) as cnt_ref_obj_ready
        ,count(tt.reference_from_event) as cnt_event
        ,count(e.dt) as cnt_event_ready
    from NVETL_MONTHLYADD_TABLENOTREADY tt
    left join NV_ETL_DEPENDENCIES dp on dp.owner = 'U1' and dp.name=tt.procedure_name_new /*tt.object_name*/ and dp.name<>dp.referenced_name and dp.referenced_name<> tt.object_name
    left join NVETL_MONTHLY_OBJECTS dl on dl.object_name= dp.referenced_name
    left join update_log l on l.object_name=dl.object_name and l.end_refresh>=trunc(sysdate) and l.end_refresh+(20/24/60/60)<sysdate and l.status='OK'
    left join NVETL_DAILY_EVENTS e on e.event = tt.reference_from_event
    group by tt.object_name,tt.procedure_name_new,tt.check_proc
    union all
    select
        'MVIEW'
        ,tt.object_name
        ,''
        ,tt.check_proc
        ,min(tt.priority) as priority
        ,count(dl.object_name) as cnt_ref_obj
        ,count(l.end_refresh) as cnt_ref_obj_ready
        ,count(tt.reference_from_event) as cnt_event
        ,count(e.dt) as cnt_event_ready
    from NVETL_MONTHLYADD_MVIEWNOTREADY tt
    left join NV_ETL_DEPENDENCIES dp on dp.owner = 'U1' and dp.name=tt.object_name and dp.name<>dp.referenced_name
    left join NVETL_MONTHLY_OBJECTS dl on dl.object_name= dp.referenced_name
    left join update_log l on l.object_name=dl.object_name and l.end_refresh>=trunc(sysdate) and l.end_refresh+(20/24/60/60)<sysdate and l.status='OK'
    left join NVETL_DAILY_EVENTS e on e.event = tt.reference_from_event
    group by
        tt.object_name,tt.check_proc;
grant select on U1.NVETL_MONTHLY_NOT_READY to LOADDB;


