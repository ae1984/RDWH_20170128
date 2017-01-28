CREATE OR REPLACE FORCE VIEW U1.M_PLAN_FACT_DEP_PIE AS
SELECT t.sum_plan-T.sum_fact as sum_fact, 100-t.pers as pers
from M_PLAN_FACT_DEP t
union all
SELECT p.sum_fact as sum_plan,p.pers as pers
from M_PLAN_FACT_DEP p;
grant select on U1.M_PLAN_FACT_DEP_PIE to LOADDB;
grant select on U1.M_PLAN_FACT_DEP_PIE to LOADER;


