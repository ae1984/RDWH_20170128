create or replace procedure u1.data_all_calc_bi(in_yymmreport varchar2) is
  v_seq      NUMBER(38); -- для отслеживания
--  v_report_month_max             VARCHAR2(9);
--  v_yymmreport_previous VARCHAR2(9);
-------- 1
  v_c_num_months               NUMBER(4);
--  v_c_client_id                NUMBER(7);
  v_c_status                   VARCHAR2(5);
  v_c_year                     NUMBER(4);
  v_c_delinq                   VARCHAR2(1);
  v_c_del_short                VARCHAR2(7);
  v_c_del_middle               VARCHAR2(7);
  v_c_del_long                 VARCHAR2(7);
--------- 2
  v_c_is_card                    NUMBER(1);
  v_c_planned_pmt_month          NUMBER(4);
  v_c_delinq_mm                  NUMBER(4);
  v_c_delinq_type                VARCHAR2(2);
  v_c_fact_pmts                  NUMBER(4);
  v_contract_month_max           VARCHAR2(9);
--  v_c_report_month_all_contracts VARCHAR2(9);
  v_c_contract_amount_categ      VARCHAR2(10);
  v_c_max_debt_used              NUMBER(38);
--  v_c_new_total_debt             NUMBER(38);
--  v_same_rnn_prior_contr_count   NUMBER(4);
--  v_c_is_new_client              NUMBER(1);
---------
--   v_c_first_start_date date;

v_start_month date;
v_rep_month_diff number;

begin
--DBMS_OUTPUT.PUT_LINE ('calculated data range: in_yymmreport = ' || in_yymmreport);
  
--  расчет v_report_month_max           VARCHAR2(9)
--  select max(yy_mm_report) into v_report_month_max from data_all;  
--DBMS_OUTPUT.PUT_LINE ('max report month in table: v_report_month_max = ' || v_report_month_max);



--  расчет v_rep_month_diff  number;
    v_start_month := to_date('2002 - 12','yyyy - mm');
    select MONTHS_BETWEEN(to_date(in_yymmreport,'yyyy - mm'), v_start_month)
           into v_rep_month_diff from dual;

-- большой цикл
  for d in (
--          select /*+rule*/ da.* from data_all_tmp da where da.yy_mm_report = in_yymmreport --and rownum < 10000 ---
          select /*+rule*/ da.* from data_all da where da.yy_mm_report = in_yymmreport
                -- and c_is_new_client is null ----- УБРАТЬ!!!!!
    ) loop


  v_c_num_months := null;
--  v_c_client_id := null;
  v_c_status := null;
  v_c_year := null;
  v_c_delinq := null;
  v_c_del_short := null;
  v_c_del_middle := null;
  v_c_del_long := null;
  v_c_is_card := null;
  v_c_planned_pmt_month := null;
  v_c_delinq_mm := null;
  v_c_delinq_type := null;
  v_c_fact_pmts := null;
  v_contract_month_max := null;
--  v_c_report_month_all_contracts := null;
  v_c_contract_amount_categ := null;
  v_c_max_debt_used := null;
--  v_c_new_total_debt := null;
--  v_same_rnn_prior_contr_count := null;
--  v_c_is_new_client := null;


--  расчет c_num_months               NUMBER(4),  --- 1
  select MONTHS_BETWEEN(
         to_date(d.yy_mm_report,'yyyy - mm'),
         to_date(d.yy_mm_start,'yyyy - mm')
         ) into v_c_num_months
       from dual;

  if (v_c_num_months < 0) then
     v_c_num_months := 0;
  end if;

--  расчет c_client_id                NUMBER(7),
--  v_c_client_id := substr(ltrim(d.contract_no, 'R'),1,7);

--  расчет c_status                   VARCHAR2(5),
  if (d.total_debt > 0) then
     v_c_status := 'Open';
  elsif (d.total_debt < 0) then
     v_c_status := 'Depo';
  else
     v_c_status := 'Sleep';
  end if;
     
--  расчет c_year                     NUMBER(4),
  v_c_year := to_number(substr(d.yy_mm_start,1,4));

--  расчет c_delinq                   VARCHAR2(1),
  if (d.delinq_days > 0) then
     v_c_delinq := 'Y';
  else
     v_c_delinq := 'N';
  end if;

--  расчет c_del_short, c_del_middle, c_del_long         VARCHAR2(7),
  if (d.delinq_days is not null) then
    select rd.del_short, rd.del_middle, rd.del_long
           into v_c_del_short, v_c_del_middle, v_c_del_long
           from ref_delinq rd
           where rd.days_del_from <= d.delinq_days and rd.days_del_to >= d.delinq_days;
  end if;
  
------------------------
--  расчет c_is_card                    NUMBER(1),
  if (d.end_date is null) then
     v_c_is_card := 2;
  else 
     v_c_is_card := 1;
  end if;  
  
--  расчет c_planned_pmt_month          NUMBER(4);
  if (v_c_num_months is not null) then
    if (v_c_num_months = 0) then
       v_c_planned_pmt_month := 0;
    else
       v_c_planned_pmt_month := nvl(v_c_num_months,0) - nvl(v_c_is_card,0) + 1;
    end if;
  end if;
    
--  расчет c_delinq_mm                  NUMBER(4);
  if (v_c_planned_pmt_month is not null) then
    if (v_c_planned_pmt_month = 0) then
       v_c_delinq_mm := 0;
    else
       v_c_delinq_mm := ceil(nvl(d.delinq_days,0)/30.62);
    end if;
  end if;  

--  расчет c_delinq_type                VARCHAR2(2);
  if (v_c_delinq_mm is not null) then
    if (v_c_delinq_mm > 0) then -- !!!!!!!!!!!!!!!!!!!!!!!! see v_c_num_months
       if (v_c_delinq_mm = v_c_planned_pmt_month) then
          v_c_delinq_type := 'F1';
       elsif ((v_c_planned_pmt_month - v_c_delinq_mm) < 3) then
          v_c_delinq_type := 'F2';
       else
          v_c_delinq_type := 'N';
       end if;
    else
       v_c_delinq_type := '0';
    end if;
  end if;

--  расчет c_fact_pmts                  NUMBER(4);
  if (v_c_delinq_mm is not null) then
    if (v_c_planned_pmt_month < v_c_delinq_mm) then
       v_c_fact_pmts := 0;
    else
       v_c_fact_pmts := v_c_planned_pmt_month - v_c_delinq_mm;
    end if;
  end if;
    
  
  --  расчет c_report_month_all_contracts и расчет c_new_total_debt 
/*  select max(dd.yy_mm_report) into v_contract_month_max from data_all dd
         where dd.contract_no = d.contract_no;
  if (v_contract_month_max > d.yy_mm_report) then
     v_c_report_month_all_contracts := d.yy_mm_report;
     v_c_new_total_debt := d.total_debt;
  else
     v_c_report_month_all_contracts := v_report_month_max;
     v_c_new_total_debt := 0;
  end if; */  

--  расчет c_contract_amount_categ      VARCHAR2(10);
  if (d.contract_amount is not null) then
    select rcac.categ into v_c_contract_amount_categ
           from REF_CONTRACT_AMOUNT_CATEG rcac
           where rcac.amount_from <= d.contract_amount and
                 rcac.amount_to >= d.contract_amount;
  end if;

--  расчет c_max_debt_used              NUMBER(38);
  select max(total_debt) into v_c_max_debt_used from data_all
         where contract_no = d.contract_no;



--  расчет c_new_total_debt             NUMBER(38);
/*  if (v_c_report_month_all_contracts = d.yy_mm_report) then
     v_c_new_total_debt := d.total_debt;
  else
     v_c_new_total_debt := 0;
  end if;*/

--  расчет c_is_new_client              NUMBER(1);
/*  v_same_rnn_prior_contr_count := 0;
  select count(*) into v_same_rnn_prior_contr_count from data_all da2
    where da2.rnn = d.rnn
    and da2.id < d.id
    and da2.contract_no != d.contract_no;
  
  if (v_same_rnn_prior_contr_count > 0) then
     v_c_is_new_client := 0;
  else
     v_c_is_new_client := 1;
  end if;*/


-- UPDATE -------------------------------------------------------------------
--update data_all_tmp set
update /*+rule*/ data_all set
  c_num_months = v_c_num_months,
--  c_client_id = v_c_client_id,
  c_status = v_c_status,
  c_year = v_c_year,
  c_delinq = v_c_delinq,
  c_del_short = v_c_del_short,
  c_del_middle = v_c_del_middle,
  c_del_long = v_c_del_long,
-----
  c_planned_pmt_month = v_c_planned_pmt_month,
  c_delinq_mm = v_c_delinq_mm,
  c_delinq_type = v_c_delinq_type,
  c_fact_pmts = v_c_fact_pmts,
--  c_report_month_all_contracts = v_c_report_month_all_contracts,
  c_contract_amount_categ = v_c_contract_amount_categ,
  c_max_debt_used = v_c_max_debt_used,
--  c_new_total_debt = v_c_new_total_debt,
--  c_is_new_client = v_c_is_new_client,
  c_is_card = v_c_is_card,
  c_report_month = v_rep_month_diff,
  is_calculated_for_bi = 1
where id = d.id;

commit;

-- увеличиваем sequence для отслеживания ------------------------------------
select data_all_calc_bi_seq.nextval into v_seq from dual;

end loop;

----------------
---- не правильно. надо пересчитывать по всем
/*
-- пересчет некоторых полей за прошлый месяц
v_yymmreport_previous := to_char(add_months(to_date(in_yymmreport,'yyyy - mm'), -1), 'yyyy - mm');
--DBMS_OUTPUT.PUT_LINE ('v_yymmreport_previous = ' || v_yymmreport_previous);

  for d in (
--          select da.* from data_all_tmp da where da.yy_mm_report = v_yymmreport_previous and rownum < 10000 ---
          select da.* from data_all da where da.yy_mm_report = v_yymmreport_previous
    ) loop

  v_c_report_month_all_contracts := null;
  v_c_new_total_debt := null;

--  расчет c_report_month_all_contracts
  v_c_report_month_all_contracts := d.yy_mm_report;
    
--  расчет c_new_total_debt             NUMBER(38);
  v_c_new_total_debt := d.total_debt;
  
  
-- UPDATE -------------------------------------------------------------------
--  update data_all_tmp set
  update data_all set
    c_report_month_all_contracts = v_c_report_month_all_contracts,
    c_new_total_debt = v_c_new_total_debt
  where id = d.id;  
  
  end loop;    
*/

end data_all_calc_bi;
/

