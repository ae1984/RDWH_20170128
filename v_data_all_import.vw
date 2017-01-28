create or replace force view u1.v_data_all_import as
select
    d.pos_code,
    d.branch_name,
    d.client_name,
    d.rnn,
    d.iin,
    d.contract_no,
    d.product_programm,
    d.start_date,
    d.end_date,
--    d.closing_date,
    d.delinq_days,
    d.contract_amount,
--    d.contract_interest_rate,
    d.expert_name,
    d.yy_mm_report,
--    d.product,
    d.yy_mm_start,
--    d.short_delinq,
--    d.long_delinq,
    d.total_debt,
--    d.fraud_level,
--    d.closed_open,
--    d.write_off,

    d.el_principal,
    d.el_interest,
    d.el_principal_del,
    d.el_interest_del,
    d.cc_principal,
    d.cc_principal_del,
    d.cc_overlimit,
    d.cc_overdraft,
    d.cc_overlimit_del,
    d.cc_overdraft_del,
    d.cc_interest,
    d.cc_interest_del,
    d.is_card,
    d.cc_contract_start_date--,

--    1 as is_calculated_post_import
  from data_all_import d
  order by d.yy_mm_report asc, d.start_date asc, d.contract_no asc
;
grant select on U1.V_DATA_ALL_IMPORT to LOADDB;
grant select on U1.V_DATA_ALL_IMPORT to LOADER;


