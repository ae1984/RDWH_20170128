create or replace force view u1.v_dwh_soft_collection_calls as
select /*+ parallel 20 */
       cc.id,
       cc.rbo_client_id,
       cc.clnt_inn,
       cc.phone_date,
       cc.phone_number,
       ccp.phone_number_clear,
       cc.status_code,
       cc.status_name,
       cc.result_desc,
       cc.result_name,
       cc.cont_theme,
       cc.text,
       cc.clnt_name,
       cc.direct_type,
       cc.direct_desc,
       cc.dialing_flag,
       cc.empl_name
  from U1.M_DWH_SOFT_COLLECTION_CALLS cc
  join U1.M_DWH_SOFT_COLLECTION_CALL_pre ccp on ccp.id = cc.id;
comment on table U1.V_DWH_SOFT_COLLECTION_CALLS is 'Данные по звонкам Soft collection';
comment on column U1.V_DWH_SOFT_COLLECTION_CALLS.ID is 'Id контакта';
comment on column U1.V_DWH_SOFT_COLLECTION_CALLS.RBO_CLIENT_ID is 'Id клиента в РБО';
comment on column U1.V_DWH_SOFT_COLLECTION_CALLS.CLNT_INN is 'ИИН клиента';
comment on column U1.V_DWH_SOFT_COLLECTION_CALLS.PHONE_DATE is 'Дата контакта';
comment on column U1.V_DWH_SOFT_COLLECTION_CALLS.PHONE_NUMBER is 'Номер телефона';
comment on column U1.V_DWH_SOFT_COLLECTION_CALLS.STATUS_CODE is 'Код статуса контакта';
comment on column U1.V_DWH_SOFT_COLLECTION_CALLS.STATUS_NAME is 'Статус контакта';
comment on column U1.V_DWH_SOFT_COLLECTION_CALLS.RESULT_DESC is 'Описание результата';
comment on column U1.V_DWH_SOFT_COLLECTION_CALLS.RESULT_NAME is 'Наименование результата';
comment on column U1.V_DWH_SOFT_COLLECTION_CALLS.CONT_THEME is 'Тема контакта';
comment on column U1.V_DWH_SOFT_COLLECTION_CALLS.TEXT is 'Текст';
comment on column U1.V_DWH_SOFT_COLLECTION_CALLS.CLNT_NAME is 'ФИО клиента';
comment on column U1.V_DWH_SOFT_COLLECTION_CALLS.DIRECT_TYPE is 'Тип звонка';
comment on column U1.V_DWH_SOFT_COLLECTION_CALLS.DIRECT_DESC is 'наименование типа звонка';
comment on column U1.V_DWH_SOFT_COLLECTION_CALLS.DIALING_FLAG is 'Признак успешного дозвона по контакту (Y - успешный, N - не успешный)';
comment on column U1.V_DWH_SOFT_COLLECTION_CALLS.EMPL_NAME is 'Имя менеджера';
grant select on U1.V_DWH_SOFT_COLLECTION_CALLS to LOADDB;
grant select on U1.V_DWH_SOFT_COLLECTION_CALLS to LOADER;
grant select on U1.V_DWH_SOFT_COLLECTION_CALLS to RISK_VERIF;


