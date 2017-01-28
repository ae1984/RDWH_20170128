﻿create or replace force view u1.v_sas_out_pkb_all as
select --+ parallel(5)
"REPORT_ID","REPORT_DATE","REPORT_DATE_TIME","FOLDER_ID","IIN_RNN","PKB_MERGED_CONTRACT_ID","REPORT_TYPE","REPORT_STATUS","IS_FROM_CACHE","BIRTH_DATE","GENDER","EDUCATION","MARITAL_STATUS","PKB_CLIENT_ID","NAME_LAST","NAME_FIRST","NAME_PATRONYMIC","BIRTH_NAME","BIRTH_CITY","BIRTH_REGION","BIRTH_COUNTRY","C_REGISTRATIONID","STREET","CITY","C_ZIPCODE","REGION","ADDRESS_INSERT_DATE","HOUSE_NUMBER","CLIENT_CLASSIFICATION","RESIDENT","POSITION","CITIZENSHIP","F_CITIZENSHIP","OCCUPATION_SECTOR","CLIENT_NEGATIVE_STATUS","CONTRACT_NEGATIVE_STATUS","CONTACT_INFO","DATE_OF_RPT_ISSUE","ACTIVE_CONTRACTS_RAW","ACTIVE_CONTRACTS","CLOSED_CONTRACTS_RAW","CLOSED_CONTRACTS","TOTAL_DEBT_RAW","TOTAL_DEBT","DELINQ_AMOUNT_RAW","DELINQ_AMOUNT","REJECTED_APPLICATION_COUNT","APPLICATION_COUNT_ONE_YEAR","PATENT_NUMBER","C_AGRE_STATUSES","C_CI","C_SI_DEBTOR#NOEC#TOTAL","C_SI_DEBTOR#NOEC#INSTALMENT_CR","C_SI_DEBTOR#NOEC#CARDS","C_BTOR#NOEC#NONINSTALMENT_CR47","C_SI_DEBTOR#NOTC#TOTAL","C_SI_DEBTOR#NOTC#INSTALMENT_CR","C_SI_DEBTOR#NOTC#CARDS","C_BTOR#NOTC#NONINSTALMENT_CR51","C_SI_DEBTOR#NORA#TOTAL","C_SI_DEBTOR#NORA#INSTALMENT_CR","C_SI_DEBTOR#NORA#CARDS","C_BTOR#NORA#NONINSTALMENT_CR55","C_SI_DEBTOR#TOD#TOTAL","C_SI_DEBTOR#TOD#INSTALMENT_CR","C_SI_DEBTOR#TOD#CARDS","C_EBTOR#TOD#NONINSTALMENT_CR59","C_SI_DEBTOR#TDO#TOTAL","C_SI_DEBTOR#TDO#INSTALMENT_CR","C_SI_DEBTOR#TDO#CARDS","C_EBTOR#TDO#NONINSTALMENT_CR63","C_SI_DEBTOR#NOI","C_SI_DEBTOR#NOI_1","C_SI_DEBTOR#NOI_2","C_SI_DEBTOR#NOI_3","C_SI_GUARANTOR#NOEC#TOTAL","C_ARANTOR#NOEC#INSTALMENT_CR69","C_SI_GUARANTOR#NOEC#CARDS","C_NTOR#NOEC#NONINSTALMENT_CR71","C_SI_GUARANTOR#NOTC#TOTAL","C_ARANTOR#NOTC#INSTALMENT_CR73","C_SI_GUARANTOR#NOTC#CARDS","C_NTOR#NOTC#NONINSTALMENT_CR75","C_SI_GUARANTOR#NORA#TOTAL","C_ARANTOR#NORA#INSTALMENT_CR77","C_SI_GUARANTOR#NORA#CARDS","C_NTOR#NORA#NONINSTALMENT_CR79","C_SI_GUARANTOR#TOD#TOTAL","C_UARANTOR#TOD#INSTALMENT_CR81","C_SI_GUARANTOR#TOD#CARDS","C_ANTOR#TOD#NONINSTALMENT_CR83","C_SI_GUARANTOR#TDO#TOTAL","C_UARANTOR#TDO#INSTALMENT_CR85","C_SI_GUARANTOR#TDO#CARDS","C_ANTOR#TDO#NONINSTALMENT_CR87","C_SI_GUARANTOR#NOI","C_SI_GUARANTOR#NOI_1","C_SI_GUARANTOR#NOI_2","C_SI_GUARANTOR#NOI_3","C_ID_DOC_ARR","C_CLOSED_CI","C_DOP_FIELD","C_PKB_REPORT_REF","PKB_CONTRACT_STATUS","COLLECTION_ID","C_DOG_TYPE","C_NUM_DOG","C_CR_PURPOSE","CONTRACT_STATUS","CONTRACT_STATUS_CLEAN","C_GUARANTEE_TYPE","C_GUARANTEE_VAL","C_DOG_CLASS","C_TOTAL_AMMOUNT","C_INSTALMENTS_NUM","C_PAYMENTS_PERIOD","C_PAYMENTS_METHOD","MONTHLY_PAYMENT_RAW","MONTHLY_PAYMENT","C_LAST_UPDATE","C_TYPE_OF_FOUNDING","C_CURRENCY","C_APPL_DATE","C_DATE_BEGIN","C_DATE_END","C_FACT_GASH_DATE","C_OUSTANDING_NUM","C_OUTSTANDING_SUM","C_OVERDUE_SUM","C_SUBJ_ROLE","C_FIN_INST","C_PC","C_ADD_INFO","C_AMOUNT","C_CREDIT_USAGE","C_RESIDUAL_AMOUNT","C_CREDIT_LIMIT","C_OVRD_INSTALMENTS","PKB_CONTRACT_DOP_FIELD" from V_PKB_ALL t
;
grant select on U1.V_SAS_OUT_PKB_ALL to IT6_USER;
grant select on U1.V_SAS_OUT_PKB_ALL to LOADDB;
grant select on U1.V_SAS_OUT_PKB_ALL to LOADER;

