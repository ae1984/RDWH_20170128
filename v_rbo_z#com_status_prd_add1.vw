create or replace force view u1.v_rbo_z#com_status_prd_add1 as
select
  t."ID",t."C_CODE",t."C_NAME",t."C_SHORT_NAME_USB",t."C_COLOR",t."C_END"
  ,case when t.c_code in ('CLOSE','CLOSED','TO_CLOSE','PAID_IC','REDUMPED','EDIT','CANCEL','SIGNED') then 0 else 1 end as is_active
from V_RBO_Z#COM_STATUS_PRD t;
grant select on U1.V_RBO_Z#COM_STATUS_PRD_ADD1 to LOADDB;


