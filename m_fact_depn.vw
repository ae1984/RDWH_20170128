CREATE OR REPLACE FORCE VIEW U1.M_FACT_DEPN AS
SELECT sum(floor(facts_sum_open) + floor(facts_sum_add) - floor(fact_out_sum) - floor(fact_out_sum_close)) as sum_fact, trunc(t.rep_date,'mm') as dat_fact
  FROM dwh_san.s5_deposit_facts_v@dwh_prod2 t
WHERE t.rep_date BETWEEN  trunc(sysdate,'mm') AND  last_day(sysdate)--t.rep_date > trunc(sysdate)-30/*substr(to_char(trunc(sysdate)),1,2)*/ and t.rep_date <= trunc(sysdate)-1
group by trunc(t.rep_date,'mm')
;
grant select on U1.M_FACT_DEPN to LOADDB;
grant select on U1.M_FACT_DEPN to LOADER;


