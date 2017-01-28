create or replace force view u1.v_sas_out_pkb_report as
select --+ parallel(5)
  t.report_id,
  t.folder_id,
  t.report_iin_rnn,
  t.rfo_report_date,
  t.rfo_report_date_time,
  t.active_contracts,
  t.closed_contracts,
  t.report_status,
  t.report_type,
  t.is_from_cache,
  t.orig_report_id,
  t.total_debt,
  t.pmt_active_all_sum
from V_PKB_REPORT t
;
grant select on U1.V_SAS_OUT_PKB_REPORT to IT6_USER;
grant select on U1.V_SAS_OUT_PKB_REPORT to LOADDB;
grant select on U1.V_SAS_OUT_PKB_REPORT to LOADER;


