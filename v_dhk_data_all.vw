create or replace force view u1.v_dhk_data_all as
select --+ parallel(5)
       t.contract_no,
       t.yy_mm_report,
       t.yy_mm_report_date,
       t.yy_mm_start,
       t.total_debt,
       t.contract_amount,
       t.delinq_days,
       t.iin,
       t.rnn
  from U1.V_DATA_ALL t
;
grant select on U1.V_DHK_DATA_ALL to LOADDB;
grant select on U1.V_DHK_DATA_ALL to LOADER;


