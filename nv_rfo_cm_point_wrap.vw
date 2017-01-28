create or replace force view u1.nv_rfo_cm_point_wrap as
select
--RDWH2.0
  cmp."ID",cmp."COLLECTION_ID",cmp."C_NAME",cmp."C_STATUS",cmp."C_PERIOD",cmp."C_CODE",cmp."C_STATUS_GROUP",cmp."C_PRIORITY",cmp."SN",cmp."SU"
  ,case when (upper(cmp.c_code) in ('EXECUTE','CREDIT_EXEC','KAS_CHK_DOC_PACK','TO_RECLAMATION',
               'ARCHIVE','ERR_ARCHIVE','KAS_SENT_PKD','KAS_WITHDRAWN1','KAS_WITHDRAWN2',
               'KAS_PKD_CONTROL','KAS_PKD_REV','TR_CHANGED',
               'TAKE_DEPART') or cmp.c_priority >= 80
             ) then 1 else 0
   end as is_issued --признак выдачи
   , case
         when upper(cmp.c_code) = 'CANCEL_SCORING' then 'CANCEL_MIDDLE_OFFICE'
         when upper(cmp.c_name) in ('ОТКАЗ ЦПР','ОТКАЗ АВТОАНДДЕРАЙТИНГА','ОТКАЗ СБ') then 'CANCEL_CPR_AA'
         when upper(cmp.c_name)  in ('ОТКАЗ КЛИЕНТА') then 'CANCEL_CLIENT'
         when upper(cmp.c_name)  in ('ОТКАЗ МЕНЕДЖЕРА ПРОДАЖ') then 'CANCEL_MANAGER'
         when upper(cmp.c_name)  in ('ОТКАЗАНО') then 'CANCEL'
         when upper(cmp.c_name)  in ('ОТКАЗ КОНТРОЛЕРА') then 'CANCEL_CONTROLLER'
         else  '-'
     end as cancel_type --тип отказа, если нет отказа то '-'
   ,case when cmp.c_status_group = '#OPEN#' then 1 else 0 end as  is_point_active --признак активого состояния
from V_RFO_Z#CM_POINT cmp
;
grant select on U1.NV_RFO_CM_POINT_WRAP to LOADDB;


