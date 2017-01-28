create or replace force view u1.v_dhk_individual_a_c as
select t.rep_date, t.client_iin, t.client_name, t.deal_number,
       t.prod_type, t.prod_name, t.begin_date,
       t.set_revolving_date, t.actual_end_date, t.card_limit,
       t.amount, t.x_total_debt, t.x_delinq_days, t.deal_status
from V_DWH_PORTFOLIO_CURRENT t
where t.x_is_credit_issued = 1 and
      t.prod_name in ('ИНДИВИДУАЛЬНЫЙ (А)','ИНДИВИДУАЛЬНЫЙ (C)');
grant select on U1.V_DHK_INDIVIDUAL_A_C to LOADDB;
grant select on U1.V_DHK_INDIVIDUAL_A_C to LOADER;


