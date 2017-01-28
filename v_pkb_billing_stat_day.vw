create or replace force view u1.v_pkb_billing_stat_day as
select --+ noparallel
       -- представление для проверки счетов от ПКБ
       to_char(p.rfo_report_date,'yyyy-mm') as a_mon,
       trunc(p.rfo_report_date) as a_date,
       p.report_source, p.report_status,
       p.report_type, d.c_name as err_status,
       ---
       count(p.report_id) as cnt,
       count(distinct p.report_id) as cnt_dist
from V_PKB_REPORT p
left join V_RFO_Z#KAS_UNIVERSAL_D d on d.id = p.err_status
where p.rfo_report_date > to_date('2015-01-01','yyyy-mm-dd') and
      p.is_from_cache = 0
group by to_char(p.rfo_report_date,'yyyy-mm'),
         trunc(p.rfo_report_date),
         p.report_source, p.report_status,
         p.report_type, d.c_name
;
grant select on U1.V_PKB_BILLING_STAT_DAY to LOADDB;


