create or replace force view u1.v_rfo_z#cm_checkpoint as
select "ID","CLASS_ID","C_WAY","C_POINT","C_USERS","C_HISTORY","C_WORK_TYPE","C_FLAGS","C_TIMERS","STATE_ID","C_CREATE_USER","C_DATE_CREATE","C_ST_DEPART","SN","SU" from GG_RFO.Z#CM_CHECKPOINT t;
comment on column U1.V_RFO_Z#CM_CHECKPOINT.C_WAY is 'Маршрут(FK на Z#CM_WAY)';
comment on column U1.V_RFO_Z#CM_CHECKPOINT.C_POINT is 'Состояние(FK на Z#CM_POINT)';
comment on column U1.V_RFO_Z#CM_CHECKPOINT.C_USERS is 'Ответственные(COLLECTION в Z#CM_USER)';
comment on column U1.V_RFO_Z#CM_CHECKPOINT.C_HISTORY is 'История состояний(COLLECTION в Z#CM_HISTORY)';
comment on column U1.V_RFO_Z#CM_CHECKPOINT.C_WORK_TYPE is 'Режим работы';
comment on column U1.V_RFO_Z#CM_CHECKPOINT.C_FLAGS is 'Флаги(COLLECTION в Z#CM_FLAG_OBJ)';
comment on column U1.V_RFO_Z#CM_CHECKPOINT.C_TIMERS is 'Таймеры(COLLECTION в Z#CM_TIMER_OM)';
comment on column U1.V_RFO_Z#CM_CHECKPOINT.C_CREATE_USER is 'Создатель(FK на Z#USER)';
comment on column U1.V_RFO_Z#CM_CHECKPOINT.C_DATE_CREATE is 'Дата создания';
comment on column U1.V_RFO_Z#CM_CHECKPOINT.C_ST_DEPART is 'Структурное подразделение(FK на Z#STRUCT_DEPART)';
grant select on U1.V_RFO_Z#CM_CHECKPOINT to LOADDB;
grant select on U1.V_RFO_Z#CM_CHECKPOINT to LOADER;
grant select on U1.V_RFO_Z#CM_CHECKPOINT to LOAD_RDWH_PROD;


