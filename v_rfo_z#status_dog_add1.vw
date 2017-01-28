create or replace force view u1.v_rfo_z#status_dog_add1 as
select
   sd."ID",sd."C_CODE",sd."C_NAME",sd."SN",sd."SU"
   ,case when sd.c_code = 'RFO_CLOSE' then 1 -- СЛУЖЕБНОЕ
         when sd.c_code in ('CANCEL','PREPARE','PREP_REVOLV') then 0 --ОТКАЗ, ПОДГОТОВКА, ПОДГОТОВКА К УСТНОВКЕ РЕВОЛЬВЕРНОСТИ
         else 1
    end as is_credit_issued
from V_RFO_Z#STATUS_DOG sd
;
grant select on U1.V_RFO_Z#STATUS_DOG_ADD1 to LOADDB;


