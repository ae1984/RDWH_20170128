create or replace procedure u1.NPRC_MVIEWREFRESH(p_object_name varchar2) is
   v_cnt number;
begin
  select count(*) into v_cnt from SYS.USER_OBJECTS t where t.OBJECT_NAME = p_object_name and t.OBJECT_TYPE = 'MATERIALIZED VIEW';
  if v_cnt<=0 then return; end if;
  
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
                     parallelism    => 15,
                     atomic_refresh => false);  
  --null;
end NPRC_MVIEWREFRESH;
/

