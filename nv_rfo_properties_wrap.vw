create or replace force view u1.nv_rfo_properties_wrap as
select
   p."C_PROP",p."C_STR",p."C_BOOL",p."C_GROUP_PROP",p."COLLECTION_ID",p."C_OBJ",p."C_V_DATE"
   --,case when p.C_GROUP_PROP = (select pg.id from V_RFO_Z#PROPERTY_GRP pg where pg.c_code = 'KAS_AUTO_CALC_STATE') then 1 else 0 end is_auto_calc
   ,case when p.C_GROUP_PROP = (
                               select pg.id
                               from V_RFO_Z#PROPERTY_GRP pg
                               where upper(pg.c_code) = 'KAS_AUTO_CALC_STATE'
                              )
         then case when  upper(p.c_str) like upper('%Обход проверки ЦПР по композиционным условиям%')
                      or upper(p.c_str) like upper('Автоматический расчет%')
                   then 1 else 0
              end
    end as is_aa_approved --признак одобрения АА
from V_RFO_Z#PROPERTIES p
;
grant select on U1.NV_RFO_PROPERTIES_WRAP to LOADDB;


