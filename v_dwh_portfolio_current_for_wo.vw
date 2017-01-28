create or replace force view u1.v_dwh_portfolio_current_for_wo as
select -- ВЫБОРКА ДЛЯ ЖУМАГАЙШИ ДЛЯ СПИСАНИЯ
       x_delinq_days as "День просрочки",
       total_debt as "Задолженность",
       sum(total_debt) over (partition by null order by x_delinq_days
           range between current row and unbounded following) as "Кум. задолж."
from (
select t.x_delinq_days, sum(t.x_total_debt) as total_debt
from V_DWH_PORTFOLIO_CURRENT t
where t.x_is_credit_issued = 1 and
      t.is_on_balance = 'Y' and
--      nvl(t.is_on_balance,'N') = 'N' and
      nvl(t.x_total_debt,0) > 0 and
      t.x_delinq_days > 0
group by t.x_delinq_days
order by t.x_delinq_days
)
;
grant select on U1.V_DWH_PORTFOLIO_CURRENT_FOR_WO to LOADDB;
grant select on U1.V_DWH_PORTFOLIO_CURRENT_FOR_WO to LOADER;


