create or replace procedure u1.ETLT_MO_CALC is
       s_mview_name     varchar2(30) := 'MO_CALC';
       vStrDate         date := sysdate;
       v_max_date       date;
      begin
         select /*+ parallel(20) */ max(t.date_start)
         into v_max_date
         from MO_CALC t;

          insert /*+ APPEND */ into MO_CALC
          select * from CALC@MO1_PROD t where t.date_start > v_max_date;
          commit;

end ETLT_MO_CALC;
/

