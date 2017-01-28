create or replace procedure u1.NPRC_PROCESS_RESIZE_TABLE is
begin
  insert into NT_TASKS_EXECUTE (id, ins_dt, group_num, task_num, task_name, sql_exec, status,object_name)
  select N_TASKS_EXECUTE_SEQ.nextval
         ,sysdate
         ,1
         ,1
         ,'RESIZE_PROCESS'
         --,'dbms_mview.refresh(list => '''||z.object_name||''',parallelism => 20,atomic_refresh => false);'
         ,ttt.sql1
         ,'NEW'
         ,null
  --select ttt.object_name, ttt.priority
  from (
      select 'execute immediate (''ALTER TABLE '||tt.table_name||' MOVE PARALLEL 10''); nprc_proc_resize_tab_savestat('||to_char(tt.id)||');' as sql1
      from
      (
        select t.* from NT_PROCESS_RESIZE_TABLE t
        left join NT_LOCKEDOBJ_HIST l on l.object_name=t.table_name and l.sdt+(4/24/60) >= sysdate
        where t.sdt>=trunc(sysdate,'mm') and l.object_name is null and t.processed_dt is null
        order by t.mb
      ) tt
      where rownum <=least(10,trunc(nfnc_get_task2exec/2))
  ) ttt;
  commit;
end NPRC_PROCESS_RESIZE_TABLE;
/

