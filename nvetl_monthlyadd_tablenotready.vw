create or replace force view u1.nvetl_monthlyadd_tablenotready as
select b.object_name,p.procedure_name_new, b.reference_from_event, min(b.priority) as priority, max(b.check_proc) as check_proc --,l.object_name
 from T_RDWH_PROC_OBJECT b
 join T_RDWH_TABLE_UTIL_PROCEDURES p on p.object_name= b.object_name
 left join update_log l on l.object_name=b.object_name and l.begin_refresh>=trunc(sysdate) and l.status not in (/*'ERROR',*/'STOPPED') --and l.status='OK'
 where b.is_used=1 and b.type_load in ('MONTHLY_NEW') and l.object_name is null
       and p.procedure_name_new is not null
           and b.object_name not in (
              select object_name
              from (select ins_dt, object_name,status,task_name from NT_TASKS_EXECUTE union all select ins_dt, object_name,status,task_name from NT_TASKS_EXECUTE_HIST) t
              where  t.ins_dt >=trunc(sysdate,'mm')--2
                   and t.task_name in ('MONTHLY_ADD_TABLE','MONTH_ADD_MVIEW')
                   and t.status='COMPLETED'
           )
 group by b.object_name, b.reference_from_event,p.procedure_name_new--,l.object_name
;
grant select on U1.NVETL_MONTHLYADD_TABLENOTREADY to LOADDB;


