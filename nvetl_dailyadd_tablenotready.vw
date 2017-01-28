create or replace force view u1.nvetl_dailyadd_tablenotready as
select b.object_name,p.procedure_name_new, b.reference_from_event, min(b.priority) as priority, b.check_proc --,l.object_name
 from T_RDWH_PROC_OBJECT b
 join T_RDWH_TABLE_UTIL_PROCEDURES p on p.object_name= b.object_name
 left join update_log l on l.object_name=b.object_name and l.begin_refresh>=trunc(sysdate) and l.status not in ('ERROR','STOPPED') --and l.status='OK'
 where b.is_used=1 and b.type_load in ('DAILY','ONLINE') and nvl(b.load_group,'-')='ADD' and l.object_name is null
       and p.procedure_name_new is not null
 group by b.object_name, b.reference_from_event,p.procedure_name_new, b.check_proc--,l.object_name
;
grant select on U1.NVETL_DAILYADD_TABLENOTREADY to LOADDB;


