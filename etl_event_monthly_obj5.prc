create or replace procedure u1.ETL_EVENT_MONTHLY_OBJ5 is
   v_event varchar2(50) := 'ETL_EVENT_MONTHLY_OBJ5';
   v_dt date := trunc(sysdate);
   v_cnt number;
   v_cnt1 number;
begin
  --Не определен последний рабочий день прошлого месяца. Последний заполненный выходной
  select count(*) into v_cnt from /*MONTHLY_UPDATE_EVENT*/DAILY_UPDATE_EVENT t where t.e_date>= v_dt and t.event=v_event;
  if v_cnt > 0 then 
    return;
  end if;

  select count(*) into v_cnt 
  from (
    select 
             to_char(t.exld_rep_date, 'yyyy - mm') as yy_mm_report
             ,t.exld_deal_number as contract_no
             ,count(*) as cnt
    from DWH_DM_SPGU_LD t
    group by t.exld_deal_number,to_char(t.exld_rep_date, 'yyyy - mm') 
    having count(*)>1
  );

  select count(*) into v_cnt 
  from (
    select 
             to_char(t.exhd_rep_date, 'yyyy - mm') as yy_mm_report
             ,t.exhd_deal_number as contract_no
             ,count(*) as cnt
    from DM_SPGU_LD_TMP t
    group by t.exhd_deal_number,to_char(t.exhd_rep_date, 'yyyy - mm') 
    having count(*)>1
  );

  
  if v_cnt+v_cnt1 > 0 then 
    return;
  end if;  

  insert into /*monthly_update_event*/DAILY_UPDATE_EVENT (event, e_detail, e_date)
  values (v_event, null, trunc(sysdate));
  commit;     
  
end ETL_EVENT_MONTHLY_OBJ5;
/

