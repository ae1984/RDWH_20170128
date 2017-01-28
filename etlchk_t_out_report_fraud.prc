create or replace procedure u1.ETLCHK_T_OUT_REPORT_FRAUD is
   v_chk_name varchar2(50) := 'ETLCHK_T_OUT_REPORT_FRAUD';
   p_out_message varchar2(1000);
   v_cnt number;

   e_user_exception exception;
begin

  
    select count(1)
      into v_cnt
      from T_OUT_REPORT_FRAUD
     where type_report in ('КРАЖА ТЕРМИНАЛА ИБСО','КРАЖА ТЕРМИНАЛА')
       and comments is null;
             
    if v_cnt > 0 then
       p_out_message := 'Не определены все номера терминалов = '||v_cnt;
    end if;      

    select sum(c_sum*(case when is_db_kt = 'КРЕДИТ' then -1 else 1 end)*(case when type_report = 'КРАЖА ТЕРМИНАЛА ИБСО' then -1 else 1 end))
      into v_cnt
      from T_OUT_REPORT_FRAUD
     where type_report in ('КРАЖА ТЕРМИНАЛА ИБСО','КРАЖА ТЕРМИНАЛА')
       and mm_yyyy_report_date = to_char(add_months(sysdate,-1),'mm-yyyy');
           
    if v_cnt != 0 then
       p_out_message := p_out_message||'Существуют расхождения в суммах по типу "КРАЖА ТЕРМИНАЛА"';
    end if;
 
    /*select sum(c_sum*(case when is_db_kt = 'КРЕДИТ' then -1 else 1 end)*(case when type_report = 'ОФОРМЛЕНИЕ КРЕДИТА НА 3-Е ЛИЦО ИБСО' then -1 else 1 end))
      into v_cnt
      from T_OUT_REPORT_FRAUD
     where type_report in ('ОФОРМЛЕНИЕ КРЕДИТА НА 3-Е ЛИЦО ИБСО','ОФОРМЛЕНИЕ КРЕДИТА НА 3-Е ЛИЦО')
       and mm_yyyy_report_date = to_char(add_months(sysdate,-1),'mm-yyyy');
    
    if v_cnt != 0 then
       p_out_message := p_out_message||'Существуют расхождения в суммах по типу "ОФОРМЛЕНИЕ КРЕДИТА НА 3-Е ЛИЦО"';
    end if;*/
  
    if p_out_message is not null then
        insert into NT_ETLCHK_LOG (chk_name,descr) values (v_chk_name,p_out_message); 
        commit;
        raise e_user_exception;            
    end if;    


          
end ETLCHK_T_OUT_REPORT_FRAUD;
/

