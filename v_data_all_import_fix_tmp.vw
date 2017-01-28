create or replace force view u1.v_data_all_import_fix_tmp as
select
    d.pos_code,
    d.branch_name,
    d.client_name,
    d.rnn,
    d.contract_no,
    d.product_programm,
    d.start_date,
    d.end_date,
    d.delinq_days,
    d.contract_amount,
    d.expert_name,
    d.yy_mm_report,
    d.product,
    d.yy_mm_start,
    d.total_debt,
    1 as is_calculated_post_import
  from data_all_import d
  where d.contract_no not in
           (select dd.contract_no from data_all dd where dd.yy_mm_report = '2012 - 07' and dd.end_date is null)
  order by d.yy_mm_report asc, d.start_date asc, d.contract_no asc;
grant select on U1.V_DATA_ALL_IMPORT_FIX_TMP to LOADDB;
grant select on U1.V_DATA_ALL_IMPORT_FIX_TMP to LOADER;


