create or replace procedure u1.ETL_EVENT_MONTHLY_HOLDAY is
   v_event varchar2(50) := 'ETL_EVENT_MONTHLY_HOLDAY';
   v_dt date := trunc(sysdate);
   v_cnt number;
begin
  --Не определен последний рабочий день прошлого месяца. Последний заполненный выходной
  select count(*) into v_cnt from /*MONTHLY_UPDATE_EVENT*/ DAILY_UPDATE_EVENT t where t.e_date>= v_dt and t.event=v_event;
  if v_cnt > 0 then 
    return;
  end if;
  select count(*) into v_cnt from u1.T_HOLIDAYS th where th.data>=v_dt; 
  if v_cnt > 0 then 
    insert into /*monthly_update_event*/ DAILY_UPDATE_EVENT (event, e_detail, e_date)
    values (v_event, null, trunc(sysdate));
    commit;     
  end if;   
end ETL_EVENT_MONTHLY_HOLDAY;
/

