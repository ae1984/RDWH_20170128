create or replace procedure u1.ETL_EVENT_ECO_ONL is
   v_event varchar2(50) := 'ETL_EVENT_ECO_ONL';
   v_dt date := trunc(sysdate);
   v_cnt number;
begin
  --Не определен последний рабочий день прошлого месяца. Последний заполненный выходной
  select count(*) into v_cnt from DAILY_UPDATE_EVENT t where t.e_date>= v_dt and t.event=v_event;
  if v_cnt > 0 then 
    return;
  end if;
  select count(*) into v_cnt from update_log t where t.end_refresh>=trunc(sysdate) and t.object_name='UPD_USER.ECO_ONL' and t.status='OK';

  if v_cnt>0 then 
    insert into DAILY_UPDATE_EVENT (event, e_detail, e_date)
    values (v_event, null, trunc(sysdate));
    commit;     
  end if;   
  
end ETL_EVENT_ECO_ONL;
/

