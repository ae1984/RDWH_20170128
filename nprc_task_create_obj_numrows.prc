create or replace procedure u1.NPRC_TASK_CREATE_OBJ_NUMROWS is
 --32:22 --29:29
   v_dt date;
begin
  v_dt:= sysdate;
  for rec in (
              select  
                   distinct 
                   t.object_name 
                   ,'insert into NT_RDWH_OBJ_NUMROWS(DT,OBJ_NAME,NUMROWS,ERR) values(sysdate,'''||t.object_name||''',(select '||nvl(b.parallel1,'/*+ parallel(8)*/')||' count(1) from '||t.object_name||'),0);
                     commit;
                    ' as sql_q
              from NT_RDWH_OBJSTATICTICS t
              join all_objects a on a.OBJECT_NAME = t.object_name 
              left join (
                  select 
                         t.obj_name
                       , max(t.numrows) as numrows 
                       , case when max(t.numrows) > 1000000001 then '/*+ parallel(64)*/'
                              when max(t.numrows) between 100000001 and 1000000000 then '/*+ parallel(32)*/'
                              when max(t.numrows) between 1000001 and 100000000 then '/*+ parallel(16)*/'
                              when max(t.numrows) <= 1000001 then '/*+ no_parallel*/'
                              else '/*+ parallel(8)*/'
                         end as parallel1         
                  from NT_RDWH_OBJ_NUMROWS t
                  group by t.obj_name
              ) b on b.obj_name = t.object_name
              where a.status = 'VALID' --and t.object_name = 'M_STAGE_S40_EXPORTEVENTDATA'
      ) loop
      
        insert into NT_TASKS_EXECUTE 
          (id, ins_dt, group_num, task_num, task_name, sql_exec, task_start, task_end, err, status)
        values (
          N_TASKS_EXECUTE_SEQ.nextval
          ,v_dt
          ,9000
          ,1
          ,'CALC_OBJ_NUMROWS'--rec.object_name
          ,rec.sql_q --код который необходимо исполнить
          ,null
          ,null
          ,null
          ,'NEW'
        );
   end loop; 
   commit;       
end NPRC_TASK_CREATE_OBJ_NUMROWS;
/

