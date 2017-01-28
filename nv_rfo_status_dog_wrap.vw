create or replace force view u1.nv_rfo_status_dog_wrap as
select
   sd."ID",sd."C_CODE",sd."C_NAME",sd."SN",sd."SU"
   ,case when sd.c_code = 'RFO_CLOSE' then 1 -- СЛУЖЕБНОЕ
         when sd.c_code in ('CANCEL','PREPARE','PREP_REVOLV') then 0 --ОТКАЗ, ПОДГОТОВКА, ПОДГОТОВКА К УСТНОВКЕ РЕВОЛЬВЕРНОСТИ
         else 1
    end as is_credit_issued --признак выдачи кредита по рфо, окончательно расчитывается с другими признаками
from V_RFO_Z#STATUS_DOG sd
;
grant select on U1.NV_RFO_STATUS_DOG_WRAP to LOADDB;


