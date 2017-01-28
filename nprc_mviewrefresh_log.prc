create or replace procedure u1.NPRC_MVIEWREFRESH_LOG(p_object_name varchar2) is
   v_cnt number;
   v_id number;
begin
  v_id:=u1.update_log_seq.nextval;
  insert into u1.update_log (id, object_name, begin_refresh, end_refresh, status)
  values(v_id,p_object_name,sysdate,null,'PROCESSING');
  commit;

  begin
  select count(*) into v_cnt from SYS.USER_OBJECTS t where t.OBJECT_NAME = p_object_name and t.OBJECT_TYPE = 'MATERIALIZED VIEW';
  if v_cnt<=0 then return; end if;
  
  select count(*) into v_cnt from SYS.USER_OBJECTS t where t.OBJECT_NAME = p_object_name and t.status = 'INVALID' and t.OBJECT_TYPE = 'MATERIALIZED VIEW';
  if v_cnt >0 then
     execute immediate 'alter /*h1*/ materialized view ' || p_object_name ||' compile';
  end if;
    
  dbms_mview.refresh(list           => p_object_name,
                     method         => 'C',
                     parallelism    => 15,
                     atomic_refresh => false);  
  --null;
  update u1.update_log set end_refresh= sysdate,status = 'OK' where id = v_id; commit;
  exception
    when others then
       rollback;  
       update u1.update_log  set end_refresh= sysdate,status = 'ERROR' where id = v_id; commit;   
  end;
    
end NPRC_MVIEWREFRESH_LOG;
/

