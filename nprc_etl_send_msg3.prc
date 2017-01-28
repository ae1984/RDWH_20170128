create or replace procedure u1.NPRC_ETL_SEND_MSG3 is
       v_event varchar2(50) := 'NPRC_ETL_SEND_MSG3';
       v_msg varchar2(2000);
       v_i number;
       v_cnt number;
       v_dt date := trunc(sysdate,'mm');
begin
   --Не определен последний рабочий день прошлого месяца. Последний заполненный выходной
    select count(*) into v_cnt from /*MONTHLY_UPDATE_EVENT*/ DAILY_UPDATE_EVENT t where t.e_date>= v_dt and t.event=v_event;
    if v_cnt > 0 then 
      return;
    end if;
    
    select count(*) into v_cnt from nt_alerts_rt_dashboard2 t where t.alert_name='MONTHLY_UPDATE' and t.status='OK';
    
    if v_cnt <= 0 then 
      return;
    end if;  

   v_msg:='Ежемесячный пересчет окончен.'; 
    
      -- dbms_output.put_line(v_msg);
    pkg_mail.add_email(in_email_code =>'RDWH_DAILY_UPD_UAMR' /*'RDWH_DAILY_ERR'*/,
                                          --'TEST',
                        in_email_body => substr(v_msg,1,2000),
                        in_email_subject => 'ETL_MONTHLY'); 

    insert into /*monthly_update_event*/ DAILY_UPDATE_EVENT (event, e_detail, e_date)
    values (v_event, null, trunc(sysdate));
    commit;    
                                       
end NPRC_ETL_SEND_MSG3;
/

