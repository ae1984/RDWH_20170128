create or replace procedure u1.data_all_calc_bi_rmac_ntd(
       in_yymmreport_from varchar2,
       in_yymmreport_to varchar2
) is
  v_seq      NUMBER(38); -- для отслеживания
  v_report_month_max varchar2(9);
  v_contract_month_max           VARCHAR2(9);
  v_c_report_month_all_contracts VARCHAR2(9);
  v_c_new_total_debt             NUMBER(38);

  v_c_report_month_all_contr_n NUMBER(38);
  v_start_month date;
begin

  v_start_month := to_date('2002 - 12','yyyy - mm');
  select max(yy_mm_report) into v_report_month_max from data_all; 

  for d in (
          select /*+rule*/ da.* from data_all da where
                 da.yy_mm_report >= in_yymmreport_from and
                 da.yy_mm_report <= in_yymmreport_to
    ) loop

--  v_c_report_month_all_contracts := null;
--  v_c_new_total_debt := null;

  --  расчет c_report_month_all_contracts и расчет c_new_total_debt 
  select /*+rule*/ max(dd.yy_mm_report) into v_contract_month_max from data_all dd
         where dd.contract_no = d.contract_no;
  -- если последний отчетный месяц по данному договору > отч. месяца текущей записи, то повторяем значения
  if (v_contract_month_max > d.yy_mm_report) then
     v_c_report_month_all_contracts := d.yy_mm_report;
     v_c_new_total_debt := d.total_debt;
  else -- если последний месяц по договоруц равен или меньше месяца текущей записи, то..
     v_c_report_month_all_contracts := v_report_month_max; -- равен последнему отчетному месяцу по всей таблице 
     
     if (v_c_report_month_all_contracts = d.yy_mm_report) then -- и, если отчетный месяц текущий записи равен последнему по всей таблице,
          v_c_new_total_debt := d.total_debt; -- оставляем total debt
     else
          v_c_new_total_debt := 0; -- в противном случае, обнуляем его (по ранее закрытым договорам)
     end if;
  end if;  

-- на будущее  
--  update data_all set c_new_total_debt = total_debt
--       where c_report_month_all_contracts = '2012 - 06' and yy_mm_report = '2012 - 06'
  
  
  select MONTHS_BETWEEN(to_date(v_c_report_month_all_contracts,'yyyy - mm'), v_start_month)
           into v_c_report_month_all_contr_n from dual;
  
-- UPDATE
  update /*+rule*/ data_all set
    c_report_month_all_contracts = v_c_report_month_all_contracts,
    c_new_total_debt = v_c_new_total_debt,
    c_report_month_all_contracts_n = v_c_report_month_all_contr_n
--    is_calculated_for_bi = 2
  where id = d.id;  
  
  commit;
  
  -- увеличиваем sequence для отслеживания ------------------------------------
  select data_all_calc_bi_rmac_ntd_SEQ.nextval into v_seq from dual;
  
  end loop;    

end data_all_calc_bi_rmac_ntd;
/

