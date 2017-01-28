create or replace procedure u1.NPRC_GRANT_LOADDB is
begin

  execute immediate('grant select on V_RD_ONLINE_ZAP_APPR_DAY_NEW to LOADDB');
  execute immediate('grant select on V_RD_ONLINE_UG_APPR_DAY_NEW to LOADDB');
  execute immediate('grant select on V_RDBOARD_ONLINE_ALL_SALE_DAY2 to LOADDB');
  execute immediate('grant select on V_RD_ONLINE_SEV_APPR_DAY_NEW to LOADDB');
  execute immediate('grant select on V_RD_ONLINE_CEN_APPR_DAY_NEW to LOADDB');
  execute immediate('grant select on V_RDBOARD_ONLINE_ALL_SALE_HOUR to LOADDB');
  execute immediate('grant select on V_RDB_ONLINE_ALL_SALE_HOUR2 to LOADDB');

  execute immediate('grant select on V_RDBOARD_ONLINE_SEV_SALE_DAY to LOADDB');
  execute immediate('grant select on V_RDBOARD_ONLINE_CEN_SALE_DAY to LOADDB');
  execute immediate('grant select on V_RDBOARD_ONLINE_ALL_SALE_DAY to LOADDB');
  execute immediate('grant select on V_RDBOARD_ONLINE_ZAP_SALE_DAY to LOADDB');
  execute immediate('grant select on V_RDBOARD_ONLINE_ALM_SALE_DAY to LOADDB');
  execute immediate('grant select on V_RDBOARD_ONLINE_VOS_SALE_DAY to LOADDB');
  execute immediate('grant select on V_RDBOARD_ONLINE_UG_SALE_DAY to LOADDB');

end NPRC_GRANT_LOADDB;
/

