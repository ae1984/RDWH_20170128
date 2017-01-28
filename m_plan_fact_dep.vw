create or replace force view u1.m_plan_fact_dep as
select trunc(sysdate)-1 as dat,
       p.sum_plan/1000 as sum_plan,
       t.sum_fact as sum_fact,
       p.sum_plan/1000-t.sum_fact as diff,
       round(((t.sum_fact-p.sum_plan/1000)/abs(p.sum_plan/1000)+1)*100,1) as pers
       --round(t.sum_fact*100/p.sum_plan*1000,1) as pers
from M_FACT_DEPN t
JOIN M_PLAN_DEPN P on p.dat_plan=t.dat_fact
;
grant select on U1.M_PLAN_FACT_DEP to LOADDB;
grant select on U1.M_PLAN_FACT_DEP to LOADER;


