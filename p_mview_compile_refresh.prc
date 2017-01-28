create or replace procedure u1.p_mview_compile_refresh (vObjName varchar2)

as
vLastRefresh date;
v_cnt number;
begin
    select count(1) into v_cnt from SYS.USER_OBJECTS t
    where t.OBJECT_NAME = vObjName and t.status = 'INVALID' and t.OBJECT_TYPE = 'MATERIALIZED VIEW';
    if v_cnt >0 then
       execute immediate 'alter materialized view '||vObjName||' compile';
    end if;

select /*+ noparallel */
       trunc(min(coalesce(ul.begin_refresh,ma.last_refresh_date,to_date('01.01.1900','dd.mm.yyyy'))))
  into vLastRefresh
  from (select /*+ noparallel */
               coalesce(dd2.referenced_name, dd.referenced_name) as object_name
          from dba_dependencies dd
          left join dba_dependencies dd2 on dd2.owner = dd.referenced_owner and dd2.name = dd.referenced_name and dd.referenced_type = 'FUNCTION'
                                                    and dd2.referenced_owner = 'U1'
         where dd.name = vObjName
               and dd.name <> dd.referenced_name
               and dd.referenced_type in ('VIEW', 'TABLE', 'MATERIALIZED VIEW', 'FUNCTION')
               and case when dd.referenced_type = 'TABLE' then nvl((select 0
                                                                      from dba_objects do
                                                                     where do.object_name = dd.referenced_name
                                                                           and do.owner = dd.referenced_owner
                                                                           and do.object_type = 'MATERIALIZED VIEW'),1)
                   else 1 end = 1
        union
        select tdd.referenced_name from t_rdwh_table_dependencies tdd where tdd.name = vObjName) t1
  join t_rdwh_proc_object po on po.is_used = 1 and po.type_load = 'DAILY' and po.object_name = t1.object_name
  left join update_log ul on ul.status = 'OK' and ul.object_name = t1.object_name and ul.begin_refresh >= trunc(sysdate)
  left join all_mview_analysis ma on ma.mview_name = t1.object_name;


if vLastRefresh = trunc(sysdate) or vLastRefresh is null
  then dbms_mview.refresh(list => vObjName,
                   parallelism=> 5,
                   method => 'C',
                   atomic_refresh => false);

end if;

end;


--select /*+ noparallel */ * from m_out_verification_revise
/

