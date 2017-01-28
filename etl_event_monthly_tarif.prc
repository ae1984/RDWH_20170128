create or replace procedure u1.ETL_EVENT_MONTHLY_TARIF is
   v_event varchar2(50) := 'ETL_EVENT_MONTHLY_TARIF';
   v_dt date := trunc(sysdate);
   v_cnt number;
begin
  --Не определен последний рабочий день прошлого месяца. Последний заполненный выходной
  select count(*) into v_cnt from /*MONTHLY_UPDATE_EVENT*/DAILY_UPDATE_EVENT t where t.e_date>= v_dt and t.event=v_event;
  if v_cnt > 0 then 
    return;
  end if;
  
  select count(distinct l.object_name) into v_cnt from update_log l where l.end_refresh>=v_dt and l.object_name in ('DWH_DM_CARDSDAILY_LD','DWH_DM_SPGU_LD') and l.status='OK';
  if v_cnt < 2 then 
    return;
  end if;  
  
  select count(1) into v_cnt 
  from (
        select /*+parallel(5)*/t.cdld_prod_name as prod_name, t.cdld_prod_type as prod_type,
               coalesce(rp.product,rp1.product,'UNKNOWN') as product,
               coalesce(rp.product_refin,rp1.product_refin,'UNKNOWN') as product_refin,
               coalesce(rp.product_program,rp1.product_program) as product_programm
        from u1.DWH_DM_CARDSDAILY_LD t
        left join u1.REF_PRODUCTS rp on rp.product_program = upper(t.cdld_prod_name)
        left join u1.REF_PRODUCTS rp1 on rp1.product_program = upper(t.cdld_prod_type)
        where t.cdld_prod_name not in ('Тест 1','Тест 2','Счет kaspi.kz')
        group by coalesce(rp.product,rp1.product,'UNKNOWN') ,
                 coalesce(rp.product_refin,rp1.product_refin,'UNKNOWN') ,
                 coalesce(rp.product_program,rp1.product_program),t.cdld_prod_name, t.cdld_prod_type
        union all
        select /*+parallel(5)*/sp.exld_prod_name as prod_name, sp.exld_prod_type as prod_type,
               coalesce(rp.product,rp1.product,'UNKNOWN') as product,
               coalesce(rp.product_refin,rp1.product_refin,'UNKNOWN') as product_refin,
               coalesce(rp.product_program,rp1.product_program) as product_programm
        from u1.DWH_DM_SPGU_LD sp
        left join u1.REF_PRODUCTS rp on rp.product_program = upper(sp.exld_prod_name)
        left join u1.REF_PRODUCTS rp1 on rp1.product_program = upper(sp.exld_prod_type)
        group by coalesce(rp.product,rp1.product,'UNKNOWN') ,
                 coalesce(rp.product_refin,rp1.product_refin,'UNKNOWN') ,
                 coalesce(rp.product_program,rp1.product_program),sp.exld_prod_name, sp.exld_prod_type
  ) 
  where product = 'UNKNOWN' or product_refin = 'UNKNOWN';
    
  if v_cnt = 0 then 
    insert into /*monthly_update_event*/ DAILY_UPDATE_EVENT(event, e_detail, e_date)
    values (v_event, null, trunc(sysdate));
    commit;     
  end if;   
  

  --
  /*if n_tmp != 0 then
     s_error_message := 'Проверка на наличие новых тарифных планов. Работа прервана для ручной поправки';
     raise e_user_exception;
  end if;  */
  
  
end ETL_EVENT_MONTHLY_TARIF;
/

