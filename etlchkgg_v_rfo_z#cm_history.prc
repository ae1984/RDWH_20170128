create or replace procedure u1.ETLCHKGG_V_RFO_Z#CM_HISTORY is
  v_object_name varchar2(100) :='V_RFO_Z#CM_HISTORY' ;
  v_row_cnt  number;
  v_id number;
begin
      select count(1) into v_row_cnt  from U1.V_RFO_Z#CM_HISTORY t where t.c_line_time>=trunc(sysdate) and rownum < 2;

      /*if v_row_cnt <= 0
        then raise_application_error(-20000, 'Объект не готово');
      end if;*/
      if v_row_cnt>0 then
        v_id:=u1.update_log_seq.nextval;
        insert into u1.update_log (id, object_name, begin_refresh, end_refresh, status)
        values (v_id,v_object_name,sysdate,sysdate,'OK');
        commit;
      end if;

end ETLCHKGG_V_RFO_Z#CM_HISTORY;
/

