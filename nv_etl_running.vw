create or replace force view u1.nv_etl_running as
select b.status,b.begin_refresh,t."SDT",t."TYPE_LOAD",t."PROC_NAME",t."OBJECT_NAME",t."PRIORITY",t."OBJECT_TYPE",t."PROC_PRIORITY",t."IS_CRITICAL",t."IS_USED",t."COMMENTS",t."IS_MAIN_OBJECT",t."ID",t."LOAD_GROUP",t."REFERENCE_FROM_EVENT"
        from NT_RDWH_PROC_OBJECT_HIST t
        left join UPDATE_LOG a on a.object_name = t.object_name and nvl(a.status,'-') = 'OK' and a.begin_refresh between trunc(sysdate) and sysdate--12/24
        left join UPDATE_LOG b on b.object_name = t.object_name and b.begin_refresh between trunc(sysdate) and sysdate--12/24
        where t.type_load='DAILY' and t.load_group <> 'ADD' and t.is_used=1 and trunc(t.sdt)=trunc(sysdate)-1 and t.object_type<>'VIEW' and a.id is null
;
grant select on U1.NV_ETL_RUNNING to LOADDB;


