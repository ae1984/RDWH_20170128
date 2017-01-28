create or replace procedure u1.NPRC_REBUILD_INDEX is
begin
  insert into NT_TASKS_EXECUTE (id, ins_dt, group_num, task_num, task_name, sql_exec, status,object_name)
  select N_TASKS_EXECUTE_SEQ.nextval
         ,sysdate
         ,1
         ,1
         ,'REBUILD_INDEX_ITEM'
         --,'dbms_mview.refresh(list => '''||z.object_name||''',parallelism => 20,atomic_refresh => false);'
         ,ttt.sql1
         ,'NEW'
         ,null
  --select ttt.object_name, ttt.priority
  from (
      select 'execute immediate (''ALTER INDEX '||tt.index_name||' REBUILD PARALLEL 20''); ' as sql1
      from
      (
          select i.index_name
          from  user_indexes i
          left join NT_LOCKEDOBJ_HIST l on l.object_name=i.table_name and l.sdt+(3/24/60) >= sysdate
          where i.status='UNUSABLE' and   l.object_name is null  and i.table_owner='U1'
               and i.index_name not in (
                  'IDX_CLIENT_DRAW_DOWN_PRE1_1'
               )
          order by i.table_name
      ) tt
      where rownum <=100/*least(15,trunc(nfnc_get_task2exec/2))*/
  ) ttt;
  commit;
end NPRC_REBUILD_INDEX;
/

