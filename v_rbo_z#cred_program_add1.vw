create or replace force view u1.v_rbo_z#cred_program_add1 as
select
  t."ID",t."C_CODE",t."C_NAME",t."C_PENALTY_PAY_REF",t."PRODUCT_TYPE",t."PROD",t."PROD_BELONG_SIGN"
  ,cast(case when t.prod_belong_sign = 'CRED_CARD' or t.c_code in ('PC_REFIN_RESTR','MONEY_KN_P','MONEY_CN','OSOB_CLIENT_MON') then 1 else 0 end as number) as is_credit_product
from V_RBO_Z#CRED_PROGRAM t;
grant select on U1.V_RBO_Z#CRED_PROGRAM_ADD1 to LOADDB;


