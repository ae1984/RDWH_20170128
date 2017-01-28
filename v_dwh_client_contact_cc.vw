create or replace force view u1.v_dwh_client_contact_cc as
select /*+ parallel 20 */
       cc.id,
       cc.rbo_client_id,
       cc.clnt_iin,
       rc.iin as rdwh_iin,
       cc.phone_date,
       cc.phone_number,
       ccp.phone_number_clear,
       cc.status_code,
       cc.status_name,
       cc.result_code,
       cc.result_desc,
       cc.result_name,
       cc.cont_theme,
       cc.clnt_name,
       cc.empl_login,
       cc.empl_name,
       cc.direct_type,
       cc.direct_desc
  from U1.M_DWH_CLIENT_CONTACT_CC cc
  left join U1.M_DWH_CLIENT_CONTACT_CC_PRE ccp on ccp.id = cc.id
  left join u1.M_CLIENT_LINK mc on mc.rbo_client_id = cc.rbo_client_id
  left join u1.V_CLIENT_RFO_BY_ID rc on mc.rfo_client_id = rc.rfo_client_id;
grant select on U1.V_DWH_CLIENT_CONTACT_CC to LOADDB;
grant select on U1.V_DWH_CLIENT_CONTACT_CC to LOADER;
grant select on U1.V_DWH_CLIENT_CONTACT_CC to RISK_VERIF;


