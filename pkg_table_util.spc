create or replace package u1.PKG_TABLE_UTIL is
  
  ----------------------------------
  --------------RFO-----------------
  ----------------------------------
  
  procedure P_PKB_REPORT_PARAM;

  procedure P_CANCEL;

  procedure P_MO_RESULT_SCO_CANCEL_DAY;

  procedure P_RFO_ONLINE_CV;
  
  procedure P_RFO_KAS_ONLINE_CLAIM_CANCEL;

  procedure P_KAS_PKB_PC;
  
  procedure P_RFO_Z#PACK_DOC;

  ----------------------------------
  --------------RBO-----------------
  ----------------------------------
  
  procedure P_JOURNAL_SALDO;
  
  procedure P_CONTRACT_DEPN_OPER;
  
  procedure P_CONTRACT_INCOME_PRE;
  
  procedure P_KAS_EDIT_OBJ_TMP;
  
  procedure P_CONTRACT_DEPN_OPER_ALL;
  
  procedure P_FACT_OPER;
  
  procedure P_CONTRACT_DEBT_OPER;
  
  procedure P_KAS_PC_FO;
  
  procedure P_RBO_PORT;
  
  procedure P_CON_REFIN_LINK_PERCENT_PRE;
  
  procedure P_DWH_PORT_AUTO;
  
  procedure P_DWH_PROVISIONS;
  
  procedure P_RBO_PAYMENT_CARD;
  
  procedure P_KAS_ACASH_DOC;
  
  -----------------------------------
  ----------------DWH----------------
  -----------------------------------

  procedure P_DWH_PORT;
  
  procedure P_DWH_DM_SPGU_HD_H;
  
  procedure P_DWH_DM_CARDSDAILY_HD_H;
  
  procedure P_DWH_PORT_T;
  
  procedure P_DWH_DM_CARDSDAILY_HD_T;
  
  procedure P_DWH_DM_SPGU_HD_T;
  
  -------------------------------------
  -------------RECALC_ADD--------------
  -------------------------------------
    
  procedure P_OUT_DWH_QUESTION;
  
  -------------------------------------
  ------------RFO----------------------
  -------------------------------------
  
  procedure P_RFO_Z#PROPERTIES;

  procedure P_PKB_REPORT;
  -------------------------------------
  --------------------IBSO-------------
  -------------------------------------
  procedure P_IBSO_Z#MAIN_DOCUM;
  -------------------------------------
  --------------------MO---------------
  -------------------------------------
  
  procedure P_MO_CALC;
  
  procedure P_MO_CALC_PAR_VALUE_2016;
  
  procedure P_MO_PROCESS;
  
  procedure P_MO_PROCESS_PAR_VALUE_2016;
  
  procedure P_MO_RFOLDER;
  
  procedure P_MO_RFOLDER_PAR_VALUE_2016;
  
  procedure P_MO_CLIENT_PHOTO;
  
  procedure P_MOGW_PROCESS_MO1;
  
  procedure P_MO_LUNA_CHECK;
  
  procedure P_MO_LUNA_REQUEST;
  
  procedure P_MO_AUTOCHECK_RESULT;
  
  procedure POPULATE_MO_REJECT;
  
  procedure POPULATE_MO_REJECT_PARAM(in_reject_code varchar2);
  
  procedure P_MO_SCO_REQUEST;
  
  procedure P_MO_SCO_REQUEST_DICT;
  
  procedure P_MO_SCO_REQUEST_NUMB;
  
  procedure P_MO_SCO_REQUEST_STR;
  
  procedure P_MO_SCO_REQUEST_DATE;
  
  procedure P_MO_SCO_REQUEST_CANCEL;
  
  procedure P_MO_AA_REQUEST;
  
  procedure P_MO_AA_REQUEST_CANCEL;
  
  procedure P_MO_AA_REQUEST_DATE;

  procedure P_MO_AA_REQUEST_DICT;
  
  procedure P_MO_AA_REQUEST_NUMB;
  
  procedure P_MO_AA_REQUEST_STR;  
  --kaspikz
  
  procedure P_KASPIKZ_ACC_INFO_ACC;

  procedure P_KASPIKZ_LOG_HTTP_REQUEST;
  
  procedure P_KASPIKZ_PAY_PAY_INFO; 
   
  procedure P_KASPIKZ_PAY_PAYINFOPARAMS;

  procedure P_KASPIKZ_LOG_USER_AGENT;

  procedure P_KASPIKZ_TRANSF_TRANSFER;
  
   procedure P_KASPIKZ_LOG_URI;
  
---for online  
  procedure P_RFO_FOLDERS;
  
  procedure P_RFO_CLIENT;
  
  procedure P_RFO_CL_PRIV;
  
  procedure P_RFO_RDOC;
  
  procedure P_RFO_FDOC;
  
  procedure P_RFO_DRAW_DOWN;
  
  procedure P_RFO_USER;
  
  procedure P_RFO_MAIN_DOCUM;
  
  procedure P_RFO_CM_CHECKPOINT;
  
  procedure P_KASPIKZ_FRM_REGISTRATION;
  
  procedure P_KASPIKZ_USER_REQUEST;
  
  procedure P_RBO_STRING_CALC_PRC;
  
  procedure P_RFO_KAS_ONLINE_BUY;
  
  procedure P_RFO_KAS_ONLINE_CLAIM;
  
  procedure P_RFO_KAS_GCVP_REPORT;
  
  procedure P_RFO_PROD_INFO;
  
  procedure P_RFO_CREDIT_DOG;
  
  procedure P_RFO_KAS_CANCEL;

  procedure P_RFO_Z_KAS_UNIVERSA_REF;
  
  procedure P_RFO_Z_SHOPS;
  
  procedure P_RFO_Z_KAS_TOV_NAME;
  
  procedure P_RFO_Z_KAS_STRING_250;
  procedure P_RFO_Z_KAS_PKB_CI;
  procedure P_RFO_Z_PKB_REPORT;
  procedure P_RFO_Z_KAS_PC_DOG;

  ----------------------------------
  ---------VERIFICATION-------------
  ----------------------------------
  
  procedure P_VERIF_IN_COLLECTION;
  
  procedure P_KASPIKZ_SAL_MANAGER_ACC;
  
  -----------------------------------
  
  procedure P_RBO_Z#PLAN_OPER;
  
  procedure P_RBO_Z#KAS_PC_SLIPS;
  
  procedure P_RBO_Z#AC_FIN;
       
  procedure P_RBO_Z#KAS_PLAN_EPS;
  
  procedure P_RFO_Z#KAS_UNIVERSAL_S;
  
  procedure P_RFO_Z#KAS_VERIFICATION;
  
  procedure P_RFO_Z#CM_HISTORY;
  
  procedure P_RFO_Z#IMAGES;

  procedure P_KASPIRED_RULES_BY_IIN;
  procedure P_KASPIRED_RULES_BY_PHONE;  
  procedure P_KASPIRED_RULES_TOP;
  procedure P_KASPIRED_RULES_OTH; 
  --таблица для проверки остатков по T_RBO_PORT
  procedure P_RDWH_SALDO_PORT; 


  procedure P_AUTO_VIN;
  procedure P_CLIENT_CATEG_HIST ;
  
  procedure P_MO_AUTO_PHOTO_HG_HIST ;
  procedure P_MO_RFOLDER_PAR_VALUE_TST;
end PKG_TABLE_UTIL;
/

