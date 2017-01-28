create or replace force view u1.v_j_tmp_xls_dwh_port_current as
select to_char(d.x_start_date_actual, 'yyyy - mm') as start_mon,
       d.deal_number as contract_number, d.client_iin,
       d.x_product_type, d.prod_type, d.unp_name,
       to_char(d.x_start_date_actual, 'yyyy') as start_year,
       trunc(d.x_start_date_actual) as x_start_date_actual,
       1 as is_con,
       case when d.x_delinq_days > 0 then 1 else 0 end as is_del_1,
       case when d.x_delinq_days > 7 then 1 else 0 end as is_del_7,
       case when d.x_delinq_days > 30 then 1 else 0 end as is_del_30,
       case when d.x_delinq_days > 60 then 1 else 0 end as is_del_60,
       case when d.x_delinq_days > 90 then 1 else 0 end as is_del_NPL,
       coalesce(greatest(c.max_debt_used, d.x_total_debt), c.max_debt_used, d.x_total_debt) as sales,
       d.x_total_debt as total_debt,
       case when d.x_delinq_days > 0 then d.x_total_debt else 0 end as total_debt_del_1,
       case when d.x_delinq_days > 7 then d.x_total_debt else 0 end as total_debt_del_7,
       case when d.x_delinq_days > 30 then d.x_total_debt else 0 end as total_debt_del_30,
       case when d.x_delinq_days > 60 then d.x_total_debt else 0 end as total_debt_del_60,
       case when d.x_delinq_days > 90 then d.x_total_debt else 0 end as total_debt_del_NPL
from V_DWH_PORTFOLIO_CURRENT d
left join V_CONTRACT_CAL c on c.contract_number = d.deal_number -- для max_debt_used
where d.x_is_credit_issued = 1 and -- выданные
      d.x_start_date_actual is not null -- настоящие кредиты
;
grant select on U1.V_J_TMP_XLS_DWH_PORT_CURRENT to LOADDB;
grant select on U1.V_J_TMP_XLS_DWH_PORT_CURRENT to LOADER;


