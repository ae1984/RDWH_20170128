create or replace procedure u1.NPRC_REVOKE is
begin
  
  execute immediate('revoke select on M_FOLDER_CON_CANCEL_ONLINE_1 from LOAD_MO');
  execute immediate('revoke select on V_FORM_CLIENT_ALL_RFO from LOAD_MO');
  execute immediate('revoke select on M_CRED_PREPARE from LOAD_MO');
  execute immediate('revoke select on T_MO_CLIENT_PHOTO_LIST from LOAD_MO');
  execute immediate('revoke select on M_CLIENT_CAL_CATEG from LOAD_MO');
  execute immediate('revoke select on M_CRED_PREPARE from LOAD_MO');
  
  
  execute immediate('revoke select on V_RD_ONLINE_ZAP_APPR_DAY_NEW from LOADDB');
  execute immediate('revoke select on V_RD_ONLINE_UG_APPR_DAY_NEW from LOADDB');
  execute immediate('revoke select on V_RDBOARD_ONLINE_ALL_SALE_DAY2 from LOADDB');
  execute immediate('revoke select on V_RD_ONLINE_SEV_APPR_DAY_NEW from LOADDB');
  execute immediate('revoke select on V_RD_ONLINE_CEN_APPR_DAY_NEW from LOADDB');  
  execute immediate('revoke select on V_RDBOARD_ONLINE_ALL_SALE_HOUR from LOADDB');
  execute immediate('revoke select on V_RDB_ONLINE_ALL_SALE_HOUR2 from LOADDB');
  execute immediate('revoke select on V_RDBOARD_ONLINE_SEV_SALE_DAY from LOADDB');
  execute immediate('revoke select on V_RDBOARD_ONLINE_CEN_SALE_DAY from LOADDB');
  execute immediate('revoke select on V_RDBOARD_ONLINE_ALL_SALE_DAY from LOADDB');
  execute immediate('revoke select on V_RDBOARD_ONLINE_ZAP_SALE_DAY from LOADDB');
  execute immediate('revoke select on V_RDBOARD_ONLINE_ALM_SALE_DAY from LOADDB');
  execute immediate('revoke select on V_RDBOARD_ONLINE_VOS_SALE_DAY from LOADDB');
  execute immediate('revoke select on V_RDBOARD_ONLINE_UG_SALE_DAY from LOADDB');

end NPRC_REVOKE;
/

