CREATE OR REPLACE FORCE VIEW U1.M_FACT AS
SELECT rep_date, facts_sum_open + facts_sum_add - fact_out_sum - fact_out_sum_close as fact_sum
  FROM dwh_san.s5_deposit_facts_v@dwh_prod2 t;
grant select on U1.M_FACT to LOADDB;
grant select on U1.M_FACT to LOADER;


