create or replace procedure u1.NPRC_MOVE_TO_USERS_INDEX is
begin
  insert into NT_TASKS_EXECUTE (id, ins_dt, group_num, task_num, task_name, sql_exec, status,object_name)
  select N_TASKS_EXECUTE_SEQ.nextval
         ,sysdate
         ,1
         ,1
         ,'MOVE_TO_USERS_INDEX'
         --,'dbms_mview.refresh(list => '''||z.object_name||''',parallelism => 20,atomic_refresh => false);'
         ,ttt.sql1
         ,'NEW'
         ,null
  --select ttt.object_name, ttt.priority
  from (
      select 'execute immediate (''ALTER INDEX '||tt.index_name||' REBUILD TABLESPACE USERS PARALLEL 30''); ' as sql1
      from
      (
          select distinct i.index_name 
          from user_indexes i
          left join NT_LOCKEDOBJ_HIST l on l.object_name=i.table_name and l.sdt+(3/24/60) >= sysdate
          where i.tablespace_name <> 'USERS' and i.table_owner='U1'
                and i.table_name in (select table_name from user_all_tables where tablespace_name='USERS')
                and l.object_name is null 
                and i.index_name not like 'SYS_IL%'         
      ) tt
      where rownum <=50/*least(15,trunc(nfnc_get_task2exec/2))*/
  ) ttt;
  commit;
end NPRC_MOVE_TO_USERS_INDEX;
/

