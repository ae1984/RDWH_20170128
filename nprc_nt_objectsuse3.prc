create or replace procedure u1.NPRC_NT_OBJECTSUSE3 is
        v_dt date;
        v_cnt number;
begin
    delete from nt_objectsuse3;
    commit;

    insert into nt_objectsuse3
    select 
       distinct 
       tt.object_name
       ,tt.oname
       ,null
       --,d.referenced_name
    from (
    select 
       t.object_name 
       , nvl(p.procedure_name_new, t.object_name) as oname
       , sum (t.cnt_startsql) as cnt_startsql
       , sum(t.cnt_sql) as cnt_sql
       , count(distinct dt) as dt_cnt 
       , min(t.dt) as dt_min
       , max(t.dt) as dt_max
    from nt_objectsuse t
    left join T_RDWH_TABLE_UTIL_PROCEDURES p on p.object_name=t.object_name
    where t.username not in ('U1','SYS','SYSTEM')  and t.object_name  is not null and t.dt>=trunc(sysdate)-100
    group by t.object_name, nvl(p.procedure_name_new, t.object_name)
    having min(t.dt)<> max(t.dt) 
          and  count(distinct dt)>1
    ) tt     
    --left join nv_etl_dependencies2 d on d.owner='U1' and d.name=tt.oname 
    ;
    commit;

       loop
         v_dt:=sysdate;
         update nt_objectsuse3
            set process_dt = v_dt
         where process_dt is null;
         commit;
         
         insert into nt_objectsuse3
         select distinct
                d.referenced_name as object_name
               ,nvl(p.procedure_name_new, d.referenced_name) as oname 
               ,null as process_dt
         from nt_objectsuse3 t
         join USER_DEPENDENCIES d on d.name=t.oname and d.referenced_owner='U1'
         left join T_RDWH_TABLE_UTIL_PROCEDURES p on p.object_name=d.referenced_name
         left join nt_objectsuse3 r on r.object_name=d.referenced_name
         where r.object_name is null and t.process_dt = v_dt
         ;
         commit;   
             
         select count(1) into v_cnt from nt_objectsuse3 where process_dt is null;
         exit when v_cnt<=0;
         dbms_lock.sleep(1); 
       end loop;

  
end NPRC_NT_OBJECTSUSE3;
/

