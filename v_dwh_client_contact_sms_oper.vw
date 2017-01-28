create or replace force view u1.v_dwh_client_contact_sms_oper as
select  cc.id,
        cc.rbo_client_id,
        cc.clnt_iin,
        cc.phone_date,
        cc.phone_number,
        ccp.phone_number_clear,
        cc.result_name,
        cc.result_desc,
        cc.status_code,
        cc.status_name,
        cc.cont_theme,
        cc.text,
        cc.clnt_name,
        cc.clnt_first_name,
        cc.system_name

  from U1.M_DWH_CLIENT_CONTACT_SMS_OPER cc
  join U1.M_DWH_CLIENT_CONT_SMS_OPER_PRE ccp on ccp.id = cc.id;
comment on table U1.V_DWH_CLIENT_CONTACT_SMS_OPER is 'Контакт с клиентом. Операционные СМС';
comment on column U1.V_DWH_CLIENT_CONTACT_SMS_OPER.ID is 'Id контакта ';
comment on column U1.V_DWH_CLIENT_CONTACT_SMS_OPER.RBO_CLIENT_ID is 'Id клиента в РБО';
comment on column U1.V_DWH_CLIENT_CONTACT_SMS_OPER.CLNT_IIN is 'ИИН клиента';
comment on column U1.V_DWH_CLIENT_CONTACT_SMS_OPER.PHONE_DATE is 'Дата контакта';
comment on column U1.V_DWH_CLIENT_CONTACT_SMS_OPER.PHONE_NUMBER is 'Номер телефона';
comment on column U1.V_DWH_CLIENT_CONTACT_SMS_OPER.RESULT_NAME is 'Наименование результата';
comment on column U1.V_DWH_CLIENT_CONTACT_SMS_OPER.RESULT_DESC is 'Описание результата';
comment on column U1.V_DWH_CLIENT_CONTACT_SMS_OPER.CONT_THEME is 'Тема контакта';
comment on column U1.V_DWH_CLIENT_CONTACT_SMS_OPER.TEXT is 'Текст смс';
comment on column U1.V_DWH_CLIENT_CONTACT_SMS_OPER.CLNT_NAME is 'ФИО клиента';
comment on column U1.V_DWH_CLIENT_CONTACT_SMS_OPER.CLNT_FIRST_NAME is 'Имя клиента';
comment on column U1.V_DWH_CLIENT_CONTACT_SMS_OPER.SYSTEM_NAME is 'Источник СМС';
grant select on U1.V_DWH_CLIENT_CONTACT_SMS_OPER to LOADDB;
grant select on U1.V_DWH_CLIENT_CONTACT_SMS_OPER to LOADER;


