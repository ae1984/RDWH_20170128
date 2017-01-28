create or replace procedure u1.ETLT_MO_RFOLDER
       is
       s_mview_name     varchar2(30) := 'MO_RFOLDER';
       vStrDate         date := sysdate;
       v_max_date       date;
      begin
        select /*+ parallel(20) */ max(t.date_create) into v_max_date
        from MO_RFOLDER t;

        insert /*+ APPEND */ into MO_RFOLDER
        select * from RFOLDER@MO1_PROD t where t.date_create > v_max_date;
        commit;

 end ETLT_MO_RFOLDER;
/

