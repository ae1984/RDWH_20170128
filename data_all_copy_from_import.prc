create or replace procedure u1.data_all_copy_from_import is
begin

insert /*+rule*/ into data_all (
  pos_code,
  branch_name,
  client_name,
  rnn,
  iin,
  contract_no,
  product_programm,
  start_date,
  end_date,
--  closing_date,
  delinq_days,
  contract_amount,
--  contract_interest_rate,
  expert_name,
  yy_mm_report,
--  product,
  yy_mm_start,
--  short_delinq,
--  long_delinq,
  total_debt,
--  fraud_level,
--  closed_open,
--  write_off,

  el_principal,
  el_interest,
  el_principal_del,
  el_interest_del,
  cc_principal,
  cc_principal_del,
  cc_overlimit,
  cc_overdraft,
  cc_overlimit_del,
  cc_overdraft_del,
  cc_interest,
  cc_interest_del,
  imp_is_card,
  cc_contract_start_date--,

--  is_calculated_post_import
) (
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

--    d.is_calculated_post_import
  from v_data_all_import d
);

commit;

end data_all_copy_from_import;
/

