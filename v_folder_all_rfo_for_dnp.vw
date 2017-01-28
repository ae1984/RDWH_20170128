create or replace force view u1.v_folder_all_rfo_for_dnp as
select /*+parallel(5)*/ f."FOLDER_ID",f."FOLDER_NUMBER",f."FOLDER_DATE_CREATE",f."FOLDER_YY_MM_CREATE",f."FOLDER_YEAR_CREATE",f."RFO_CLIENT_ID",f."FOLDER_STATE",f."PROCESS_CODE",f."PROCESS_NAME",f."ROUTE_CODE",f."ROUTE_NAME",f."DELIVERY_TYPE",f."SOURCE_SYSTEM",f."CARD_CONTRACT_ID",f."CARD_CONTRACT_NUMBER",f."CREDIT_CONTRACT_ID",f."CREDIT_CONTRACT_NUMBER",f."CONTRACT_ID",f."POS_CODE",f."DNP_NAME",f."IS_CREDIT_PROCESS",f."IS_CREDIT_ISSUED",f."IS_FORM_EXISTS",f."UNDERWRITER",f."UNDERWRITER_SENIOR",f."FORM_CLIENT_ID",f."FLD_C_DOCS",f."AUTOCALC_DOC_ID",f."ORG_BIN",f."ROUTE_POINT_CODE",f."ROUTE_POINT_NAME",f."EXPERT_LOGIN",f."EXPERT_NAME",f."EXPERT_POSITION",f."IS_DAYTIME_DECISION_FOLDER",f."MANAGER_RESULT",f."MANAGER_RESULT_NOTE",f."MANAGER_INPUT_TIME", c.iin, p.x_dnp_name, p.x_dnp_region, p.pos_type
from V_FOLDER_ALL_RFO f
left join V_POS p on p.pos_code = f.pos_code
left join V_CLIENT_RFO_BY_ID c on c.rfo_client_id = f.rfo_client_id
where f.folder_date_create >= to_date('2014-01-01','yyyy-mm-dd');
grant select on U1.V_FOLDER_ALL_RFO_FOR_DNP to DNP;
grant select on U1.V_FOLDER_ALL_RFO_FOR_DNP to LOADDB;
grant select on U1.V_FOLDER_ALL_RFO_FOR_DNP to LOADER;


