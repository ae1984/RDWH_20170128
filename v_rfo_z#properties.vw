create or replace force view u1.v_rfo_z#properties as
select C_PROP,C_STR,C_BOOL,C_GROUP_PROP,COLLECTION_ID,C_OBJ,C_V_DATE/*, C_DATE_BEG, C_DATE_END*/ from V_RFO_Z#PROPERTIES_2012 p1
union all
select C_PROP,C_STR,C_BOOL,C_GROUP_PROP,COLLECTION_ID,C_OBJ,C_V_DATE/*, C_DATE_BEG, C_DATE_END*/ from V_RFO_Z#PROPERTIES_2013 p2;
comment on table U1.V_RFO_Z#PROPERTIES is 'Дополнительные свойства';
comment on column U1.V_RFO_Z#PROPERTIES.C_PROP is 'Значение. Свойство(FK на Z#PROD_PROPERTY)';
comment on column U1.V_RFO_Z#PROPERTIES.C_STR is 'Значение. Текст';
comment on column U1.V_RFO_Z#PROPERTIES.C_BOOL is 'Значение. Логика';
comment on column U1.V_RFO_Z#PROPERTIES.C_GROUP_PROP is 'Группа свойств(FK на Z#PROPERTY_GRP)';
comment on column U1.V_RFO_Z#PROPERTIES.C_OBJ is 'Значение. Ссылка(FK на OBJECTS)';
comment on column U1.V_RFO_Z#PROPERTIES.C_V_DATE is 'Значение. Дата';
grant select on U1.V_RFO_Z#PROPERTIES to LOADDB;
grant select on U1.V_RFO_Z#PROPERTIES to LOADER;
grant select on U1.V_RFO_Z#PROPERTIES to LOADER_RFO;


