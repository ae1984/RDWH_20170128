create or replace procedure u1.ETL_LOG_DAILYVIEW is
begin
 
  insert into u1.update_log (id, object_name, begin_refresh, end_refresh, status)
  select 
    update_log_seq.nextval
    ,a.object_name
    ,sysdate
    ,sysdate
    ,'OK'
  from (  
      select distinct tt.object_name 
      from (
        --select a.object_name,count(l.object_name) as ref_obj, count(l.end_refresh) as ref_obj_ready
        select a.object_name,count(d.referenced_name) as ref_obj, count(l.end_refresh) as ref_obj_ready
        from all_objects a 
        left join NV_ETL_DEPENDENCIES d on d.owner='U1' and d.name=a.object_name and d.name<>d.referenced_name
        left join update_log l on l.begin_refresh>=trunc(sysdate) and l.object_name=d.referenced_name and l.status='OK' and l.end_refresh+(20/24/60/60) < sysdate
        where a.owner='U1' and a.object_type='VIEW'
        group by a.object_name
      ) tt
      left join update_log l on l.begin_refresh>=trunc(sysdate) and l.object_name=tt.object_name and l.status='OK' 
      where ref_obj<=ref_obj_ready and l.object_name is null
  ) a;
  commit;

end ETL_LOG_DAILYVIEW;
/

