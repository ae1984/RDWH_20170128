create or replace force view u1.nvetl_weeklyadd_mviewnotready as
select b.object_name, b.reference_from_event, min(b.priority) as priority --,l.object_name
      from T_RDWH_PROC_OBJECT b
      join all_objects o on o.owner='U1' and o.object_name =b.object_name and o.object_type='MATERIALIZED VIEW'
      left join update_log l on l.object_name=b.object_name and l.begin_refresh>=trunc(sysdate) and l.status not in ('ERROR','STOPPED') --and l.status='OK'
      where b.is_used=1 and b.type_load in ('WEEKLY_NEW','WEEKLY') and l.object_name is null
      group by b.object_name, b.reference_from_event--,l.object_name
;
grant select on U1.NVETL_WEEKLYADD_MVIEWNOTREADY to LOADDB;


