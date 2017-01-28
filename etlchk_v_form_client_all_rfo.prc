create or replace procedure u1.ETLCHK_V_FORM_CLIENT_ALL_RFO is
   v_chk_name varchar2(50) := 'ETLCHK_V_FORM_CLIENT_ALL_RFO';
   p_out_message varchar2(1000);
   v_cnt number;
   --e_user_exception exception;
begin
  select count(*) into v_cnt from  U1.V_FORM_CLIENT_ALL_RFO;
  if  v_cnt>0  then
      p_out_message:='Тест';--объект пустой после обновления
      insert into NT_ETLCHK_LOG (chk_name,descr) values (v_chk_name,p_out_message);
     commit;
      --raise e_user_exception;
  end if;

end ETLCHK_V_FORM_CLIENT_ALL_RFO;
/

