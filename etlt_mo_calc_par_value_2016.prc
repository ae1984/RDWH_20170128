create or replace procedure u1.ETLT_MO_CALC_PAR_VALUE_2016
       is
       s_mview_name     varchar2(30) := 'T_MO_CALC_PAR_VALUE_2016';
       vStrDate         date := sysdate;
       v_max_date       date;
      begin
        select /*+ parallel(20) */ max(t.date_create)
        into v_max_date
        from T_MO_CALC_PAR_VALUE_2016 t;

        insert /*+ APPEND */ into T_MO_CALC_PAR_VALUE_2016
        select * from CALC_PAR_VALUE@MO1_PROD t where t.date_create > v_max_date;
        commit;

 end ETLT_MO_CALC_PAR_VALUE_2016;
/

