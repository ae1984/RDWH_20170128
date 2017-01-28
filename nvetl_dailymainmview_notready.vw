﻿create or replace force view u1.nvetl_dailymainmview_notready as
select b.object_name, b.reference_from_event, min(b.priority) as priority , b.check_proc--,l.object_name
      from T_RDWH_PROC_OBJECT b
      join all_objects o on o.owner='U1' and o.object_name =b.object_name and o.object_type='MATERIALIZED VIEW'
      left join update_log l on l.object_name=b.object_name and l.begin_refresh>=trunc(sysdate) and l.status not in ('ERROR','STOPPED') --and l.status='OK'
      where b.is_used=1 and b.type_load in ('DAILY','ONLINE') and b.proc_name not in ('JOB'/*,'DWH_AUTO_PROCESSING'*/) and nvl(b.load_group,'-')<>'ADD' and l.object_name is null
      group by b.object_name, b.reference_from_event, b.check_proc --,l.object_name
;
grant select on U1.NVETL_DAILYMAINMVIEW_NOTREADY to LOADDB;


