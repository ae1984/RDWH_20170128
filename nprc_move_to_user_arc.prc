create or replace procedure u1.NPRC_MOVE_TO_USER_ARC is
begin
  insert into NT_TASKS_EXECUTE (id, ins_dt, group_num, task_num, task_name, sql_exec, status)
  select N_TASKS_EXECUTE_SEQ.nextval
           ,sysdate
           ,1
           ,1
           ,'MOVE_TO_USER_ARC_ITEMS'
           --,'dbms_mview.refresh(list => '''||z.object_name||''',parallelism => 20,atomic_refresh => false);'
           ,'execute immediate (''ALTER TABLE '||ttt.object_name||' move tablespace USERS_ARC  parallel 10'');'
           ,'NEW'
    --select ttt.object_name, ttt.priority
   from (
      /*select \*+parallel(5)*\ tt.object_name, max(tt.cnt_startsql) as cnt_startsql
      from (
        select t.* from u1.nt_objectsuse t
        join user_all_tables o on o.table_name=t.object_name and o.tablespace_name in ('USERS_F','USERS')
        left join u1.nt_objectsuse a on a.object_name=t.object_name and a.username not in ('U1','SYS','SYSTEM')
        left join u1.nt_objectsuse b on b.object_name=t.object_name and b.username not in ('SYS','SYSTEM') and b.cnt_startsql>3 and b.dt>=trunc(sysdate)-31
        left join u1.t_rdwh_proc_object p on p.object_name=t.object_name and p.is_used=1
        left join user_views v on v.view_name=t.object_name
        left join NT_LOCKEDOBJ_HIST l on l.object_name=t.object_name and l.sdt+(10/24/60) >= sysdate
        where t.owner='U1'
            and t.object_name is not null
            and a.object_name is null
            and a.object_name is null
            and p.object_name is null
            and v.view_name is null
            and l.object_name is null
        --order by t.cnt_startsql
      ) tt
      group by tt.object_name
      having  max(tt.cnt_startsql)<4 and count(distinct tt.dt) > 7*/
      select t.table_name as object_name from user_all_tables t
      left join NT_LOCKEDOBJ_HIST l on l.object_name=t.table_name and l.sdt+(10/24/60) >= sysdate
      where t.table_name not in (select object_name from NT_OBJECT_NAME_USED)
            and t.tablespace_name<>'USERS_ARC'
            and t.tablespace_name in ('USERS','USERS_F')
            and t.table_name not like 'NT%'
            and l.object_name is null 
  ) ttt
  where rownum <=50/* least(15,nfnc_get_task2exec)*/;
  commit;
end NPRC_MOVE_TO_USER_ARC;
/

