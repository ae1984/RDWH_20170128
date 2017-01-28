create or replace force view u1.v_out_dwh_portfolio_cur as
select /*+ parallel(5) */
       t.deal_number, t.client_iin, t.begin_date, t.set_revolving_date,
       t.plan_end_date, t.actual_end_date, t.prod_type, t.prod_name, t.deal_status,
       t.x_total_debt, t.x_amount, t.x_is_card, t.is_on_balance
from V_DWH_PORTFOLIO_CURRENT t
where t.x_is_credit_issued = 1;
grant select on U1.V_OUT_DWH_PORTFOLIO_CUR to IT6_USER;
grant select on U1.V_OUT_DWH_PORTFOLIO_CUR to LOADDB;
grant select on U1.V_OUT_DWH_PORTFOLIO_CUR to LOADER;


