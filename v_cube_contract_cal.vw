﻿create or replace force view u1.v_cube_contract_cal as
select /*+parallel(5)*/ "CONTRACT_NUMBER","CLIENT_ID","PRODUCT_FIRST","PRODUCT_REFIN_FIRST","PRODUCT_PROGRAM_FIRST","START_DATE_FIRST","END_DATE_FIRST","CONTRACT_AMOUNT_FIRST","EXPERT_NAME_FIRST","POS_CODE_FIRST","BRANCH_NAME_FIRST","PRODUCT_LAST","PRODUCT_REFIN_LAST","PRODUCT_PROGRAM_LAST","START_DATE_LAST","END_DATE_LAST","CONTRACT_AMOUNT_LAST","YY_MM_REPORT_MIN","YY_MM_REPORT_MAX","MAX_DEBT_USED","DELINQ_DAYS_MAX","DELINQ_DAYS_LAST","CONTRACT_AMOUNT_MAX","IS_REFIN_RESTRUCT_FIRST","IS_REFIN_RESTRUCT_LAST","FIRST_PMT_DAYS_FIRST","FIRST_PMT_DAYS_LAST","FIRST_PMT_DAYS_REFIN_FIRST","FIRST_PMT_DAYS_REFIN_LAST","TOTAL_DEBT_FIRST","TOTAL_DEBT_LAST","IS_CARD","CONTRACT_AMOUNT_CATEG_FIRST","CONTRACT_AMOUNT_CATEG_LAST","DELINQ_TYPE_LAST","CLIENT_RNN_FIRST","CLIENT_RNN_LAST","CLIENT_IIN_FIRST","CLIENT_IIN_LAST","YY_MM_START_FIRST","YY_MM_START_FIRST_NUM","START_YEAR_FIRST","CONTRACT_TERM_DAYS_FIRST","CONTRACT_TERM_MONTHS_FIRST","YY_MM_START_LAST","YY_MM_START_LAST_NUM","START_YEAR_LAST","CONTRACT_TERM_DAYS_LAST","CONTRACT_TERM_MONTHS_LAST","FACT_PMTS","PLANNED_PMTS","PMT","START_CON_AMOUNT_MAX_BY_CLI","START_CON_DEL_DAYS_MAX_BY_CLI","START_TOT_DEBT_ALL_CON_BY_CLI","START_NUM_OF_CON_BY_CLI_PR_REP","START_NUM_OF_CON_BY_CLI","START_TOTAL_FACT_PMTS_BY_CLI","START_PMT_MAX_BY_CLI","PROVISION_MAX","CONTRACT_AMOUNT_LAST_REP","TOTAL_DEBT_LAST_REP","DELINQ_DAYS_LAST_REP","FOLDER_ID_FIRST","START_NUM_OF_FOL_ALL","START_NUM_OF_FOL_1_MONTH","PREV_CON_NUM_BY_START_DATE","NEXT_CON_NUM_BY_START_DATE","PREV_CON_NUM_BY_YYMM_LAST","NEXT_CON_NUM_BY_YYMM_LAST","PREV_CON_ST_DATE_BY_START_DATE","PREV_CON_ST_DATE_BY_YYMM_LAST","PREV_CON_PROD_FIRST_BY_STD","PREV_CON_PROD_FIRST_BY_YML","PREV_CON_TOT_DEBT_FIRST_BY_STD","PREV_CON_TOT_DEBT_FIRST_BY_YML","YY_MM_START_DEBT" from V_CONTRACT_CAL t;
grant select on U1.V_CUBE_CONTRACT_CAL to LOADDB;
grant select on U1.V_CUBE_CONTRACT_CAL to LOADER;

