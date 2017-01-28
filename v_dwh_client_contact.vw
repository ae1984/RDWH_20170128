create or replace force view u1.v_dwh_client_contact as
select  cc.id,
        cc.rbo_client_id,
        cc.clnt_iin,
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
        cc.system_name,
        cc.direct_type,
        cc.direct_desc
  from U1.M_DWH_CLIENT_CONTACT cc
  join U1.M_DWH_CLIENT_CONTACT_PRE ccp on ccp.id = cc.id;
grant select on U1.V_DWH_CLIENT_CONTACT to LOADDB;
grant select on U1.V_DWH_CLIENT_CONTACT to LOADER;


