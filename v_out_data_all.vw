create or replace force view u1.v_out_data_all as
select /*+ parallel(5) */
       t.yy_mm_report, t.yy_mm_report_num, t.yy_mm_report_date,
       t.iin, t.contract_no, t.product, t.product_programm, t.contract_amount,
       t.total_debt, t.delinq_days, t.delinq_days_old, t.is_card
from V_DATA_ALL t;
grant select on U1.V_OUT_DATA_ALL to IT6_USER;
grant select on U1.V_OUT_DATA_ALL to LOADDB;
grant select on U1.V_OUT_DATA_ALL to LOADER;


