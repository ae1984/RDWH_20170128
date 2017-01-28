create or replace force view u1.t_rfo_z#cm_history as
select "ID","COLLECTION_ID","C_LINE","C_DESCRIPTION","C_USER","C_LINE_TIME","C_IS_LAST","C_NUM","C_KAS_USER_INFO","SN","SU" from GG_RFO.Z#CM_HISTORY t;
comment on column U1.T_RFO_Z#CM_HISTORY.C_LINE is 'Переход(FK на Z#CM_LINE)';
comment on column U1.T_RFO_Z#CM_HISTORY.C_USER is 'Пользователь(FK на Z#USER)';
comment on column U1.T_RFO_Z#CM_HISTORY.C_LINE_TIME is 'Время';
comment on column U1.T_RFO_Z#CM_HISTORY.C_IS_LAST is 'Признак актуальной записи';
comment on column U1.T_RFO_Z#CM_HISTORY.C_NUM is 'Порядковый номер';
grant select on U1.T_RFO_Z#CM_HISTORY to LOADDB;


