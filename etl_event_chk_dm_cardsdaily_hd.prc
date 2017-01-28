create or replace procedure u1.ETL_EVENT_CHK_DM_CARDSDAILY_HD is
   v_event varchar2(50) := 'ETL_EVENT_CHK_DM_CARDSDAILY_HD';
   v_dt date := trunc(sysdate);
   v_dt2 date;
   v_cnt number;
   v_cntavg number;
begin
  --Не определен последний рабочий день прошлого месяца. Последний заполненный выходной
  select count(*) into v_cnt from DAILY_UPDATE_EVENT t where t.e_date>= v_dt and t.event=v_event;
  if v_cnt > 0 then 
    return;
  end if;
  
  pkg_object_update_util.check_dwh_availability;
  
  select count(*) into v_cnt from DAILY_UPDATE_EVENT t where t.e_date>= v_dt and t.event='DWH_READY';
  if v_cnt <= 0 then 
    return;
  end if;
  
  select avg(t.numrows)*0.95 into v_cntavg from NT_RDWH_OBJ_NUMROWS t
  where t.obj_name='V_DWH_PORT_CARDS' and t.numrows>0 and t.dt >= trunc(sysdate)-14;
   
  select count(1) into v_cnt
  from DWH_SAN.DM_CARDSDAILY_HD@DWH_PROD2 t --DWH_RAN.DM_CARDSDAILY_HD_V@DWH_PROD2 t
  where t.cdhd_rep_date = trunc(sysdate) - 1;

  if v_cnt>v_cntavg then 
    dbms_lock.sleep(120); --ожидаем 120 секунд
    insert into DAILY_UPDATE_EVENT (event, e_detail, e_date)
    values (v_event, null, trunc(sysdate));
    commit;     
  end if;   
  
end ETL_EVENT_CHK_DM_CARDSDAILY_HD;
/

