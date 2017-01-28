create or replace procedure u1.NPRC_PROCESS_RESIZE_TABLE_NEW is
begin
    insert into NT_PROCESS_RESIZE_TABLE
    select sysdate as sdt, NSEQ_PROCESS_RESIZE_TABLE.nextval as id, t.table_name,round(a.bytes/(1024 * 1024)) as mb, null as processed_dt
    from user_all_tables t
    join SYS.user_segments a on a.segment_name=t.table_name
    left join NT_LOCKEDOBJ_HIST l on l.object_name=t.table_name and l.sdt+(4/24/60) >= sysdate
    left join user_mviews mv on mv.mview_name=t.table_name
    where /*t.table_name='T_RBO_PORT' and */ t.partitioned <> 'YES'
         and (a.bytes/(1024 * 1024))>500 and l.object_name is null and mv.mview_name is null;
    commit;
end NPRC_PROCESS_RESIZE_TABLE_NEW;
/

