CREATE OR REPLACE FORCE VIEW U1.V_FLOWS AS
SELECT rep_date, facts_sum_open + facts_sum_add as inflow , fact_out_sum + fact_out_sum_close as outflow
  FROM dwh_san.s5_deposit_facts_v@dwh_prod2 t;
grant select on U1.V_FLOWS to LOADDB;
grant select on U1.V_FLOWS to LOADER;


