create or replace force view u1.v_out_portfolio_cards as
select /*+  noparallel */
       t.yy_mm_report, t.yy_mm_report_num, t.contract_no, tt.client_iin, t.product_programm,
       t.contract_amount, t.total_debt, t.delinq_days, t.delinq_amount
from V_DATA_ALL t
join V_DWH_PORTFOLIO_CURRENT tt on tt.deal_number = t.contract_no
where t.yy_mm_report_num >= 201201 and
      tt.x_is_card = 1 and tt.x_is_credit_issued = 1 and tt.is_credit_active = 1;
grant select on U1.V_OUT_PORTFOLIO_CARDS to IT6_USER;
grant select on U1.V_OUT_PORTFOLIO_CARDS to LOADDB;
grant select on U1.V_OUT_PORTFOLIO_CARDS to LOADER;


