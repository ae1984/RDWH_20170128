create or replace force view u1.nv_rfo_application_easy as
select
    r."RFO_CON_OR_CLAIM_ID",r."RFO_CON_CLAIM_TYPE",r."FOLDER_CON_DATE",r."FOLDER_CON_DATE_TIME",r."FOLDER_ID",r."CONTRACT_NUMBER",r."C_CLIENT_REF"
    --,min(r.folder_id) over (partition by r.contract_number) as folder_id_first
    ,c.id as rfo_client_id
    ,c.x_iin as iin
    ,c.x_rnn as rnn
    ,trunc(r.folder_con_date_time,'mi') as folder_date_create_mi

from (
  select
         oc.id as rfo_con_or_claim_id
         ,'CLAIM' as rfo_con_claim_type
         ,trunc(b.c_date_create) as folder_con_date
         ,b.c_date_create as folder_con_date_time
         ,null as folder_id
         ,'-' as contract_number
         ,oc.c_client_ref
  from u1.V_RFO_Z#KAS_ONLINE_CLAIM oc
  left join u1.V_RFO_Z#KAS_ONLINE_BUY b on b.id = oc.c_buy_ref
  where oc.c_folder_ref is null
  union all
  select cd.id as rfo_con_or_claim_id
         ,'CREDIT' as rfo_con_claim_type
         ,trunc(cp.c_date_create) as folder_con_date
         ,cp.c_date_create as folder_con_date_time
         ,cp.id as folder_id
         ,cd.c_num_dog as contract_number
         ,cd.c_client_ref
  from u1.V_RFO_Z#CM_CHECKPOINT cp
  join u1.V_RFO_Z#FOLDERS fld on fld.id = cp.id
  join NV_RFO_BUS_PROCESS_WRAP bp on bp.id = fld.c_business and bp.is_credit_process = 1
  join u1.V_RFO_Z#RDOC rd on rd.collection_id = fld.c_docs
  join u1.V_RFO_Z#FDOC fd on fd.id = rd.c_doc and fd.class_id = 'CREDIT_DOG'
  left join u1.V_RFO_Z#CREDIT_DOG cd on cd.id = fd.id
  union all
  select cd2.id as rfo_con_or_claim_id
         ,'CARD' as rfo_con_claim_type
         ,trunc(cp.c_date_create) as folder_con_date
         ,cp.c_date_create as folder_con_date_time
         ,cp.id as folder_id
         ,cd2.c_num_dog as contract_number
         ,cd2.c_client_ref
  from u1.V_RFO_Z#CM_CHECKPOINT cp
  join u1.V_RFO_Z#FOLDERS fld on fld.id = cp.id
  join NV_RFO_BUS_PROCESS_WRAP bp on bp.id = fld.c_business and bp.is_credit_process = 1
  join u1.V_RFO_Z#RDOC rd on rd.collection_id = fld.c_docs
  join u1.V_RFO_Z#FDOC fd on fd.id = rd.c_doc and fd.class_id = 'KAS_PC_DOG'
  left join u1.V_RFO_Z#KAS_PC_DOG cd2 on cd2.id = fd.id
) r
  left join u1.V_RFO_Z#CLIENT c on c.id = r.c_client_ref
;
grant select on U1.NV_RFO_APPLICATION_EASY to LOADDB;


