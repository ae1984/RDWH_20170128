create or replace force view u1.v_rfo_folder_cpr as
select c.id as folder_id,
       c.c_date_create as folder_date_create,
       f.c_n folder_number,
       cmp.c_name folder_state,
       cmp.c_code fodler_state_code,
       bp.c_code business_process_code,
       bp.c_name business_process
from u1.T_RFO_Z#CM_CHECKPOINT c
join u1.T_RFO_Z#FOLDERS f on f.id = c.id
join u1.V_RFO_Z#CM_POINT cmp on cmp.id = c.c_point
join u1.V_RFO_Z#BUS_PROCESS bp on bp.id = f.c_business
where c.c_date_create > trunc(sysdate);
grant select on U1.V_RFO_FOLDER_CPR to LOADDB;


