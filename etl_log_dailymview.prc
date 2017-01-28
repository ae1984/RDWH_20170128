create or replace procedure u1.ETL_LOG_DAILYMVIEW is
begin
 
    insert into u1.update_log (id, object_name, begin_refresh, end_refresh, status)
    select 
      update_log_seq.nextval
      ,tt.object_name
      ,tt.last_refresh_date
      ,tt.last_refresh_end_time
      ,'OK'
    from (
    select   distinct
       o.object_name
       ,mv.last_refresh_date
       ,mv.last_refresh_end_time
    from all_objects o 
    left join all_mviews mv on mv.owner = 'U1' and mv.mview_name = o.object_name and mv.last_refresh_end_time between trunc(sysdate) and sysdate--(2/60/24)
    left join update_log l on l.object_name=o.object_name and l.begin_refresh>=trunc(sysdate)
    where o.owner='U1' and o.object_type='MATERIALIZED VIEW' and l.object_name is null and mv.last_refresh_end_time is not null
    ) tt;
    commit;

end ETL_LOG_DAILYMVIEW;
/

