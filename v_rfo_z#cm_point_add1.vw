create or replace force view u1.v_rfo_z#cm_point_add1 as
select
--RDWH2.0
  cmp."ID",cmp."COLLECTION_ID",cmp."C_NAME",cmp."C_STATUS",cmp."C_PERIOD",cmp."C_CODE",cmp."C_STATUS_GROUP",cmp."C_PRIORITY",cmp."SN",cmp."SU"
  ,case when (cmp.c_code in ('EXECUTE','CREDIT_EXEC','KAS_CHK_DOC_PACK','TO_RECLAMATION',
               'ARCHIVE','ERR_ARCHIVE','KAS_SENT_PKD','KAS_WITHDRAWN1','KAS_WITHDRAWN2',
               'KAS_PKD_CONTROL','KAS_PKD_REV','TR_CHANGED',
               'TAKE_DEPART') or cmp.c_priority >= 80
             ) then 1 else 0
   end as is_issued
from V_RFO_Z#CM_POINT cmp
;
grant select on U1.V_RFO_Z#CM_POINT_ADD1 to LOADDB;


