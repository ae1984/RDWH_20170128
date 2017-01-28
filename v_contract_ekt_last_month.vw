create or replace force view u1.v_contract_ekt_last_month as
select "CONTRACT_NUMBER","POS_CODE","POS_NAME","START_MONTH","START_DATE","PRODUCER","PRODUCT_NAME","PRODUCT_MODEL","QUANTITY","GOODS_COST","BILL_SUM","GOODS_PRICE","CONTRACT_AMOUNT","PRODUCT_TYPE_NAME","CLIENT_RNN","CLIENT_IIN","CLIENT_NAME" from v_contract_ekt e
where e.start_month = (select max(yy_mm_report) from v_data_all);
grant select on U1.V_CONTRACT_EKT_LAST_MONTH to LOADDB;
grant select on U1.V_CONTRACT_EKT_LAST_MONTH to LOADER;


