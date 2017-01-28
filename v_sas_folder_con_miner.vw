﻿create or replace force view u1.v_sas_folder_con_miner as
select /*+ parallel 5 */
"RFO_CONTRACT_ID",
"FOLDER_ID",
"CONTRACT_NUMBER",
"CONTRACT_ID",
"RFO_CLIENT_ID",
"FORM_CLIENT_ID",
"FOLDER_DATE_CREATE",
"IS_CREDIT_ISSUED",
"IS_BAD_BY_CON_DEL_MAX_90",

"DELINQ_DAYS_MAX",
"CR_PROGRAM_NAME",
"IS_CARD",
"CONTRACT_AMOUNT",
"X_DNP_REGION",
"X_DNP_NAME",
"POS_TYPE",
"SEX",
"REG_ADDRESS_REGION",
"REG_ADDRESS_CITY",
"REG_ADDRESS_AGE_DAYS",
"REG_ADDRESS_AGE_MON_FLOOR",
"FACT_ADDRESS_REGION",
"FACT_ADDRESS_CITY",
"FACT_ADDRESS_AGE_DAYS",
"FACT_ADDRESS_AGE_MON_FLOOR",
"EDUCATION",
"MARITAL_STATUS",
"CHILDREN",
"JOB_POSITION",
"ORG_ACTIVITY",
"ORG_SECTOR",
"ORG_TYPE",
"JOB_POSITION_TYPE",
"IS_BANK_ACCOUNT_EXISTS",
"IS_AUTO_EXISTS",
"REAL_ESTATE_RELATION",
"IS_GARAGE_EXISTS",
"WORK_EXPR_LAST_PLACE_DAYS",
"WORK_EXPR_LAST_PLACE_MON_FLOOR",
"AGE_FULL_YEARS",
"DEPENDANTS_COUNT",
"INC_SAL",
"INC_SAL_ADD",
"INC_SAL_SPOUSE",
"INC_RENT",
"INC_PENSION_BENEFITS",
"INC_INTEREST",
"INC_TOTAL",
"EXP_UTILITIES",
"EXP_TRANSPORT",
"EXP_CHILDREN",
"EXP_NUTRITION",
"EXP_CLOTHES",
"EXP_OBLIGATIONS",
"EXP_OTHER",
"EXP_TOTAL",
"CONTRACT_TERM_MONTHS",
"TIME_NUM_HOUR",
"TIME_DAY_NUM_OF_WEEK",
"PKB_REPORT_STATUS",
"PKB_ACTIVE_CONTRACTS",
"PKB_CLOSED_CONTRACTS",
"PKB_PMT_ACTIVE_ALL_SUM",
"PKB_TOTAL_DEBT",
"GCVP_SALARY",
"GCVP_LAST_PMT_DAYS_AGO_FLOOR",
"GCVP_FIRST_PMT_DAYS_AGO_FLOOR",
"GCVP_PMTS_COUNT_FROM_REP",
"GCVP_ORG_COUNT_BY_NAME",
"GCVP_PMTS_PER_DAY_MAX",
"ORG_GCVP_MAXPMTD_AGE_DAYS",
"ORG_GCVP_MAXPMTD_AGE_MON_FLOOR",
"SAL_GCVP_TO_SAL_FORM_PRC_FLOOR",
"PMT_OURS",
"FLD_NUMBER_IN_24H",
"FLD_NUMBER_IN_48H",
"FLD_NUMBER_IN_1W",
"FLD_NUMBER_IN_1M",
"CANCEL_FLD_COUNT_IN_24H",
"CANCEL_FLD_COUNT_IN_48H",
"CANCEL_FLD_COUNT_IN_1W",
"CANCEL_FLD_COUNT_IN_1M",
"START_TOTAL_FACT_PMTS_BY_CLI",
"START_CON_DEL_DAYS_MAX_BY_CLI",
"START_NUM_OF_CON_BY_CLI",
"START_NUM_OF_CON_BY_CLI_PR_REP",
"CLI_AGE_BASING_ON_CON",
"CLI_AGE_BASING_ON_CON_MON_FL",
"CLI_AGE_BASED_ON_FLD",
"CLI_AGE_BASED_ON_FLD_MON_FL",
/*"KDN_OURSEND",
"KDN_OUR_ALL_CONS",
"KDN_PMT_NOM_RATE_TO_GCVP_SAL",*/
"START_CON_AMOUNT_MAX_BY_CLI",
"START_PMT_MAX_BY_CLI",
"PMT_NOM_RATE",
"AMOUNT_RISE_PERC",
"PMT_RISE_PERC",
"CLIENT_NEW_FRESH_OLD",
"CLIENT_PATRONYMIC_TYPE",
"START_PRODUCT_COUNT",
"PRODUCT_START_NUMBER",
"PAID_SAL_COUNT",
"PAID_SAL_COUNT_ALL_CON",
"IS_TEST",
"IS_REFIN"
from u1.M_FOLDER_CON_MINER t;
grant select on U1.V_SAS_FOLDER_CON_MINER to IT6_USER;
grant select on U1.V_SAS_FOLDER_CON_MINER to LOADDB;
grant select on U1.V_SAS_FOLDER_CON_MINER to LOADER;


