create or replace procedure u1.ETL_EVENT_DAILY_1H30M is
   v_event varchar2(50) := 'ETL_EVENT_DAILY_1H30M';
   v_dt date := trunc(sysdate);
   v_cnt number;
begin
  --Не определен последний рабочий день прошлого месяца. Последний заполненный выходной
  select count(*) into v_cnt from DAILY_UPDATE_EVENT t where t.e_date>= v_dt and t.event=v_event;
  if v_cnt > 0 then
    return;
  end if;


  if to_number(to_char(sysdate, 'HH24MI'))>=130 then
    insert into DAILY_UPDATE_EVENT (event, e_detail, e_date)
    values (v_event, null, trunc(sysdate));
    commit;
  end if;

end ETL_EVENT_DAILY_1H30M;
/

