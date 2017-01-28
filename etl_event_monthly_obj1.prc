create or replace procedure u1.ETL_EVENT_MONTHLY_OBJ1 is
   v_event varchar2(50) := 'ETL_EVENT_MONTHLY_OBJ1';
   v_dt date := trunc(sysdate);
   v_cnt number;
begin
  --Не определен последний рабочий день прошлого месяца. Последний заполненный выходной
  select count(*) into v_cnt from /*MONTHLY_UPDATE_EVENT*/ DAILY_UPDATE_EVENT t where t.e_date>= v_dt and t.event=v_event;
  if v_cnt > 0 then 
    return;
  end if;
  
  select count(distinct l.object_name) into v_cnt from update_log l where l.end_refresh>=v_dt 
      and l.object_name in ('V_REPORT_CAL_1','M_DATA_ASOKR_FOLDER','V_DATA_ALL') and l.status='OK';
  
  if v_cnt < 3 then 
    return;
  end if;  

  insert into /*monthly_update_event*/ DAILY_UPDATE_EVENT (event, e_detail, e_date)
  values (v_event, null, trunc(sysdate));
  commit;     
  
end ETL_EVENT_MONTHLY_OBJ1;
/

