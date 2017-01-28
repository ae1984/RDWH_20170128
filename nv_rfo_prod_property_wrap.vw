create or replace force view u1.nv_rfo_prod_property_wrap as
select
--RDWH2.0
  t."ID"
  ,upper(t."C_NAME") as C_NAME
  ,upper(t."C_CODE") as C_CODE
  ,t."C_GROUP_PROP"
  ,t."C_DEFAULT_PROP"
  ,t."C_IS_USED"
  ,t."C_DATE_AUDIT"
  ,t."SN"
  ,t."SU"
  ,case when upper(t.c_code) in ('BEST_MONEY','POST_MONEY','OSOB_CLIENT','MONEY_KN_P','EC_MANY',
                                   'MONEY','EC_MONEY','OSOB_CLIENT_MONEY') then 'ДЕНЬГИ'
     when upper(t.c_code) in ('OSOB_CLIENT_PC','PC_POST_CLIENT','PC_BEST_CLIENT',
                                   'KAS_PC_DOG','ZP_CARDS','PROST_KART','KASPI_RED') then 'КАРТЫ'
     when upper(t.c_code) in ('AUTO','GU_AVTO','GU_AVTO_BU','AUTO_USE','GU_AVTO_ZALOG') then 'АВТО'
     when upper(t.c_code) in ('EC_GOODS','EC_SERVICE','AUTO_SERV','EC_GOODS_STAND','EC_SERVICE_STAND') then 'ТОВАРЫ' -- включая автозапчасти
     when upper(t.c_code) in ('PC_REFIN_RESTR','GU_AVTO_REF') then 'ОПТИМИЗАЦИЯ'
     else 'ДРУГОЕ'
   end as product_type --тип продукта
from V_RFO_Z#PROD_PROPERTY t
;
grant select on U1.NV_RFO_PROD_PROPERTY_WRAP to LOADDB;


