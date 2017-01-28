create or replace force view u1.v_pkb_report_ok_to_beki_11_12 as
with p as (
  select distinct t.report_id, t.rfo_report_date, t.report_iin_rnn, t.report_status, t.report_type
  from V_PKB_REPORT t
  where t.orig_report_id is null and to_char(t.rfo_report_date,'yyyy') in ('2012','2011')
) select p2.report_id as rep_id_2, p1.report_id as rep_id_1,
         p2.report_iin_rnn as rnn,
         p2.rfo_report_date as rep_date_2, p1.rfo_report_date as rep_date_1,
         p2.rfo_report_date - p1.rfo_report_date as rep_date_diff,
         p2.report_status as rep_status_2, p1.report_status as rep_status_1,
         p2.report_type as rep_type_2, p1.report_type as rep_type_1
from p p2
join p p1 on p1.report_iin_rnn = p2.report_iin_rnn and
             p1.report_status = 'OK' and p1.rfo_report_date < p2.rfo_report_date
where p2.report_status = 'БЕКИ' and p1.report_status = 'OK' and p1.rfo_report_date < p2.rfo_report_date
order by p2.report_id, p1.report_id;
grant select on U1.V_PKB_REPORT_OK_TO_BEKI_11_12 to LOADDB;
grant select on U1.V_PKB_REPORT_OK_TO_BEKI_11_12 to LOADER;


