create or replace force view u1.gb_2012_10_19 as
select c.start_date_first,
       c.contract_number,
       f.folder_number,
       c.folder_id_first,
       n.client_rnn_first,
       n.client_id,
       c.delinq_days_max,
       c.delinq_days_last_rep,
       c.delinq_type_last,
       c.yy_mm_report_min,
       c.yy_mm_report_max,
       c.product_program_first,
       c.product_first,
       c.product_program_last,
       c.product_last,
       c.contract_amount_first,
       c.contract_amount_last
from v_contract_cal c, v_client_cal n, v_folder f
where c.start_date_first > to_date('20110101','yyyymmdd') and
      c.start_date_first < to_date('20120630','yyyymmdd') + 1 and
      n.client_id = c.client_id and
      f.folder_id = c.folder_id_first and
      n.client_rnn_first = n.client_rnn_last;
grant select on U1.GB_2012_10_19 to LOADDB;
grant select on U1.GB_2012_10_19 to LOADER;


