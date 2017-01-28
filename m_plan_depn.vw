create or replace force view u1.m_plan_depn as
select sum(p.plan_dpst_trnsctn_plan_value) as sum_plan,
       to_date(substr(p.plan_dpst_period_cd,5,8),'yyyy.mm.dd') as dat_plan
from dwh_main.acc_plan_deposit@dwh_prod2 p
where to_date(substr(p.plan_dpst_period_cd,5,8),'yyyy.mm.dd') =  trunc(sysdate,'mm')
group by(to_date(substr(p.plan_dpst_period_cd,5,8),'yyyy.mm.dd'));
grant select on U1.M_PLAN_DEPN to LOADDB;
grant select on U1.M_PLAN_DEPN to LOADER;


