create or replace force view u1.v_dwh_port as
select t.rep_date,
       t.deal_number,
       t.total_debt,
       t.total_debt_decrease,
       t.delinq_days,
       t.delinq_days_previous,
       t.start_date,
       t.prod_type,
       t.delinq_days_old,
       t.delinq_amount,
       t.is_card,
       t.client_id,
       t.is_active,
       t.is_on_balance,
       t.pmt_date,
       t.pmt_date_first,
       t.prod_avto from T_DWH_PORT_2013 t

union all
select t.rep_date,
       t.deal_number,
       t.total_debt,
       t.total_debt_decrease,
       t.delinq_days,
       t.delinq_days_previous,
       t.start_date,
       t.prod_type,
       t.delinq_days_old,
       t.delinq_amount,
       t.is_card,
       to_number(t.client_id) client_id,
       t.is_active,
       t.is_on_balance,
       t.pmt_date,
       t.pmt_date_first,
       t.prod_avto from DWH_PORT t;
grant select on U1.V_DWH_PORT to LOADDB;
grant select on U1.V_DWH_PORT to LOADER;


