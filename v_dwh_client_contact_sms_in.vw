create or replace force view u1.v_dwh_client_contact_sms_in as
select  cc.id,
        cc.rbo_client_id,
        cc.clnt_inn,
        cc.phone_date,
        cc.phone_number,
        ccp.phone_number_clear,
        cc.text,
        cc.clnt_name

  from U1.M_DWH_CLIENT_CONTACT_SMS_IN cc
  join U1.M_DWH_CLIENT_CONT_SMS_IN_PRE ccp on cc.id = ccp.id;
grant select on U1.V_DWH_CLIENT_CONTACT_SMS_IN to LOADDB;
grant select on U1.V_DWH_CLIENT_CONTACT_SMS_IN to LOADER;


