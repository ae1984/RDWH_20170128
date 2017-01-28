create or replace procedure u1.NPRC_PROC_COMPRESS_TABLE is
begin
  --alter table M_RFO_FRAUD_SEARCH_14_CLN move compress parallel 10; 
  insert into NT_TASKS_EXECUTE (id, ins_dt, group_num, task_num, task_name, sql_exec, status,object_name)
  select N_TASKS_EXECUTE_SEQ.nextval
         ,sysdate
         ,1
         ,1
         ,'COMPRESS_PROCESS'
         --,'dbms_mview.refresh(list => '''||z.object_name||''',parallelism => 20,atomic_refresh => false);'
         ,ttt.sql1
         ,'NEW'
         ,null
  --select ttt.object_name, ttt.priority
  from (
      select 'execute immediate (''ALTER TABLE '||tt.table_name||' MOVE COMPRESS PARALLEL 20''); nprc_proc_compress_tab_stat('||to_char(tt.id)||');' as sql1
      from
      (
        select t.* from NT_PROCESS_COMPRESS_TABLE t
        left join NT_LOCKEDOBJ_HIST l on l.object_name=t.table_name and l.sdt+(4/24/60) >= sysdate
        where t.sdt>=trunc(sysdate,'mm') and l.object_name is null and t.processed_dt is null --and t.mb >100
        order by t.mb desc
      ) tt
      where rownum <=50--least(15,nfnc_get_task2exec)
  ) ttt;
  commit;
end NPRC_PROC_COMPRESS_TABLE;
/

