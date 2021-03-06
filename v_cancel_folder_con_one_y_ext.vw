﻿create or replace force view u1.v_cancel_folder_con_one_y_ext as
select /*+parallel(1)*/ "FOLDER_ID","RFO_CONTRACT_ID","RFO_CLIENT_ID","CONTRACT_NUMBER","FOLDER_DATE_MONTH","FOLDER_DATE_DAY","FOLDER_DATE_DAY_TEXT","CRED_PROG_CODE","CRED_PROG_NAME","IS_CARD","CONTRACT_DATE_BEGIN","SET_REVOLVE_DATE","CONTRACT_AMOUNT","IS_CREDIT_ISSUED","FOLDER_STATE","CONTRACT_STATUS","PROCESS_NAME","ROUTE_NAME","DNP_REGION","BRANCH_NAME","DNP_NAME","POS_CODE","POS_NAME","PARTNER","EXPERT_NAME","CANCEL_FOLDER_ID","CANCEL_TYPE_GROUP","CANCEL_TYPE_CODE","CANCEL_TYPE_NAME","SCORECARD","CANCEL_USER_NAME","CANCEL_USER_NUM_TAB","CANCEL_FOLDER_STATE","IS_PRESCORING_CANCEL","CANCEL_TYPE_GROUP_NEW","IS_DAYTIME_DECISION_FOLDER","CRED_SCHEME","TARIFF_PLAN","IS_AA_APPROVED","PKB_REP_STATUS","PRODUCT_TYPE" from V_CANCEL_FOLDER_CON_ONE_YEAR t
where t.cancel_type_group != 'MO-MO_SCO_REJECT' or t.cancel_type_group is null;
grant select on U1.V_CANCEL_FOLDER_CON_ONE_Y_EXT to LOADDB;
grant select on U1.V_CANCEL_FOLDER_CON_ONE_Y_EXT to LOADER;


