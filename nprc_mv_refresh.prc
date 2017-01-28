create or replace procedure u1.NPRC_MV_REFRESH(pMV_Name in varchar2)
is
   v_cnt number;
  begin
    select count(1) into v_cnt from SYS.USER_OBJECTS t
    where t.OBJECT_NAME = pMV_Name and t.status = 'INVALID' and t.OBJECT_TYPE = 'MATERIALIZED VIEW';
    if v_cnt >0 then
      execute immediate 'alter materialized view ' || pMV_Name ||' compile';
    end if;

    dbms_mview.refresh(list           => pMV_Name,
                       method         => 'C',
                       parallelism    => 5,
                       atomic_refresh => true);

  end NPRC_MV_REFRESH;
/

