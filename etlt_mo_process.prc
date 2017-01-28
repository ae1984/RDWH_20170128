create or replace procedure u1.ETLT_MO_PROCESS
       is
       s_mview_name     varchar2(30) := 'MO_PROCESS';
       vStrDate         date := sysdate;
       v_max_date       date;
      begin
         select /*+ parallel(20) */ max(t.date_start) into v_max_date
          from MO_PROCESS t;

          insert /*+ APPEND */ into MO_PROCESS
          select * from PROCESS@MO1_PROD t where t.date_start > v_max_date;
          commit;
 end ETLT_MO_PROCESS;
/

