create or replace force view u1.v_dwh_client_contact_sms_tst as
select /*+ parallel 20 */
        cc.id,
        cc.rbo_client_id,
        cc.clnt_inn,
        cc.phone_date,
        cc.phone_number,
        ccp.phone_number_clear,
        cc.status_code,
        cc.status_name,
        cc.result_name,
        cc.result_desc,
        cc.cont_theme,
        cc.text,
        cc.clnt_name,
        system_name

  from U1.M_DWH_CLIENT_CONTACT_SMS_TST cc
  join U1.M_DWH_CLIENT_CONTACT_SMS_PRE  ccp on ccp.id = cc.id;
grant select on U1.V_DWH_CLIENT_CONTACT_SMS_TST to LOADDB;
grant select on U1.V_DWH_CLIENT_CONTACT_SMS_TST to LOADER;


