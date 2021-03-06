﻿create or replace force view u1.v_tmp_con_ekt_dwh_2013_10_11 as
select "CONTRACT_NUMBER","POS_CODE","POS_NAME","START_MONTH","BEGIN_DATE","CONTRACT_TERM_DAYS","ACTUAL_END_DATE","CONTRACT_TERM_MONTHS","PRODUCER","PRODUCT_NAME","PRODUCT_MODEL","QUANTITY","GOODS_COST","BILL_SUM","GOODS_PRICE","CONTRACT_AMOUNT","PRODUCT_TYPE_NAME","CLIENT_RNN","CLIENT_IIN","CLIENT_NAME","RFO_SHOP_ID","SHOP_CODE","SHOP_NAME","CITY_NAME","FIL_NAME","UNP_NAME" from V_CONTRACT_EKT_DWH t
where t.start_month in ('2013 - 10','2013 - 11');
grant select on U1.V_TMP_CON_EKT_DWH_2013_10_11 to LOADDB;
grant select on U1.V_TMP_CON_EKT_DWH_2013_10_11 to LOADER;


