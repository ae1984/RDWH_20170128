create or replace procedure u1.NPRC_MVIEWREFRESH_DAILY(p_object_name varchar2) is
   v_cnt number;
   user_exception       exception;
begin
  select count(*) into v_cnt from SYS.USER_OBJECTS t where t.OBJECT_NAME = p_object_name and t.OBJECT_TYPE = 'MATERIALIZED VIEW';
  if v_cnt<=0 then return; end if;
  select count(*) into v_cnt from update_log t where t.object_name=p_object_name and t.begin_refresh>= trunc(sysdate) and t.status='OK';
  if v_cnt>0 then return; end if;
  select count(*) into v_cnt from update_log t where t.object_name=p_object_name and t.begin_refresh>= trunc(sysdate) and nvl(t.status,'PROCESSING')='PROCESSING';
  if v_cnt>1 then raise user_exception; end if;

  --begin
    select count(*) into v_cnt from SYS.USER_OBJECTS t where t.OBJECT_NAME = p_object_name and t.status = 'INVALID' and t.OBJECT_TYPE = 'MATERIALIZED VIEW';
    if v_cnt >0 then
      execute immediate 'alter materialized view ' || p_object_name ||' compile';
    end if;
    /*exception
      when others then
        null;
  end;  */
  dbms_mview.refresh(list           => p_object_name,
                     method         => 'C',
                     parallelism    => 5,
                     atomic_refresh => false);
  --null;
end NPRC_MVIEWREFRESH_DAILY;
/

