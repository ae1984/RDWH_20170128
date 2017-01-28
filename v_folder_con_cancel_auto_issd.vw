create or replace force view u1.v_folder_con_cancel_auto_issd as
select f.folder_date_create_mi, f.folder_id, a."RFO_CONTRACT_ID",a."CONTRACT_NUMBER",a."RFO_CLIENT_ID",a."CONTRACT_DATE",a."CONTRACT_STATUS_CODE",a."CONTRACT_STATUS_NAME",a."CR_PROGRAM_CODE",a."CR_PROGRAM_NAME",a."CR_SCHEME_CODE",a."CR_SCHEME_NAME",a."DATE_BEGIN",a."DATE_END",a."SHOP_CODE",a."SHOP_PLACE",a."AUTO_PRICE",a."INFO_AUTO_ID",a."VIN",a."BRAND",a."MODEL",a."PROD_REGION",a."FUEL_TYPE",a."PROD_YEAR",a."TECH_PASSPORT_DATE",a."COLOR",a."ENGINE_VOLUME",a."DEALER_IIN",a."DEALER_FIO",a."DEALER_ORG"
from M_FOLDER_CON_CANCEL f
join V_CONTRACT_ALL_RFO_AUTO a on a.rfo_contract_id = f.rfo_contract_id
where f.is_credit_issued = 1;
grant select on U1.V_FOLDER_CON_CANCEL_AUTO_ISSD to LOADDB;
grant select on U1.V_FOLDER_CON_CANCEL_AUTO_ISSD to LOADER;


