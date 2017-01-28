create or replace force view u1.v_rfo_z#prod_property_add1 as
select
--RDWH2.0
  t."ID",t."C_NAME",t."C_CODE",t."C_GROUP_PROP",t."C_DEFAULT_PROP",t."C_IS_USED",t."C_DATE_AUDIT",t."SN",t."SU"
  ,case when t.c_code in ('BEST_MONEY','POST_MONEY','OSOB_CLIENT','MONEY_KN_P','EC_MANY',
                                   'MONEY','EC_MONEY','OSOB_CLIENT_MONEY') then 'ДЕНЬГИ'
     when t.c_code in ('OSOB_CLIENT_PC','PC_POST_CLIENT','PC_BEST_CLIENT',
                                   'KAS_PC_DOG','ZP_CARDS','PROST_KART','KASPI_RED') then 'КАРТЫ'
     when t.c_code in ('AUTO','GU_AVTO','GU_AVTO_BU','AUTO_USE','GU_AVTO_ZALOG') then 'АВТО'
     when t.c_code in ('EC_GOODS','EC_SERVICE','AUTO_SERV','EC_GOODS_STAND','EC_SERVICE_STAND') then 'ТОВАРЫ' -- включая автозапчасти
     when t.c_code in ('PC_REFIN_RESTR','GU_AVTO_REF') then 'ОПТИМИЗАЦИЯ'
     else 'ДРУГОЕ'
   end as product_type
from V_RFO_Z#PROD_PROPERTY t
;
grant select on U1.V_RFO_Z#PROD_PROPERTY_ADD1 to LOADDB;


