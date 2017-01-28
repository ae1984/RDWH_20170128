create or replace procedure u1.NPRC_PROCESS_RESIZE_INDEX is
begin
  insert into NT_TASKS_EXECUTE (id, ins_dt, group_num, task_num, task_name, sql_exec, status,object_name)
  select N_TASKS_EXECUTE_SEQ.nextval
         ,sysdate
         ,1
         ,1
         ,'RESIZE_PROCESS_INDEX'
         --,'dbms_mview.refresh(list => '''||z.object_name||''',parallelism => 20,atomic_refresh => false);'
         ,ttt.sql1
         ,'NEW'
         ,null
  --select ttt.object_name, ttt.priority
  from (
      select 'execute immediate (''ALTER INDEX '||tt.index_name||' REBUILD PARALLEL 10''); ' as sql1
      from
      (
        select distinct i.index_name, p.table_name 
        from NT_PROCESS_RESIZE_TABLE p
        join USER_INDEXES i on i.table_name=p.table_name and i.status='UNUSABLE'
        left join NT_LOCKEDOBJ_HIST l on l.object_name=p.table_name and l.sdt+(4/24/60) >= sysdate
        where p.sdt>=trunc(sysdate,'mm') and p.processed_dt is not null and l.object_name is null
      ) tt
      where rownum <=least(10,trunc(nfnc_get_task2exec/2))
  ) ttt;
  commit;
end NPRC_PROCESS_RESIZE_INDEX;
/

