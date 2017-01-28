﻿create or replace force view u1.v_out_rfo_z#kas_online_claim as
select /*+ parallel 5 */ "ID","SN","SU","C_CLIENT_REF","C_FORM_CLIENT_REF","C_FORM_CLIENT_ST#NUM","C_FORM_CLIENT_ST#DOC_DATE","C_FORM_CLIENT_ST#PRIOR_FIO","C_FORM_CLIENT_ST#PARENT_FDOC","C_FORM_CLIENT_ST#SEX#0","C_FORM_CLIENT_ST#SEX#MALE","C_FORM_CLIENT_ST#SEX#FEMALE","C_FORM_CLIENT_ST#DATE_BIRTH","C_FORM_CLIENT_ST#STATUS_DOC","C_FORM_CLIENT_ST#DATE_AUDIT","C_FORM_CLIENT_ST#PLACE_BIRTH","C_FORM_CLIENT_ST#COUNTRY","C_FORM_CLIENT_ST#MAIN_DOC#TYPE","C_FORM_CLIENT_ST#MAIN_DOC#NUM","C_M_CLIENT_ST#MAIN_DOC#SERIA17","C_FORM_CLIENT_ST#MAIN_DOC#WHO","C_LIENT_ST#MAIN_DOC#DATE_DOC19","C_M_CLIENT_ST#MAIN_DOC#PLACE20","C_LIENT_ST#MAIN_DOC#DATE_END21","C_NT_ST#MAIN_DOC#DEPART_CODE22","C_FORM_CLIENT_ST#ADD_DOC#TYPE","C_FORM_CLIENT_ST#ADD_DOC#NUM","C_FORM_CLIENT_ST#ADD_DOC#SERIA","C_FORM_CLIENT_ST#ADD_DOC#WHO","C_CLIENT_ST#ADD_DOC#DATE_DOC27","C_FORM_CLIENT_ST#ADD_DOC#PLACE","C_CLIENT_ST#ADD_DOC#DATE_END29","C_ENT_ST#ADD_DOC#DEPART_CODE30","C_T_ST#ADDRESS_FACT#POST_IND31","C_IENT_ST#ADDRESS_FACT#PLACE32","C_T_ST#ADDRESS_FACT#ADR_TYPE33","C_ST#ADDRESS_FACT#DATE_BEGIN34","C_T_ST#ADDRESS_FACT#DATE_END35","C_IENT_ST#ADDRESS_FACT#HOUSE36","C_IENT_ST#ADDRESS_FACT#FRAME37","C_LIENT_ST#ADDRESS_FACT#FLAT38","C_ENT_ST#ADDRESS_FACT#STREET39","C_ENT_ST#ADDRESS_FACT#REGION40","C_T_ST#ADDRESS_FACT#DISTRICT41","C_ST#ADDRESS_FACT#REGION_REF42","C_#ADDRESS_FACT#DISTRICT_REF43","C__ST#ADDRESS_FACT#PLACE_REF44","C_LIENT_ST#ADDRESS_FACT#CITY45","C_NT_ST#ADDRESS_FACT#COUNTRY46","C_ST#ADDRESS_FACT#DATE_AUDIT47","C_T_ST#ADDRESS_FACT#AFFIRMED48","C_IENT_ST#ADDRESS_FACT#ACTIV49","C_ST#ADDRESS_FACT#HOUSES_REF50","C_NT_ST#ADDRESS_REG#POST_IND51","C_LIENT_ST#ADDRESS_REG#PLACE52","C_NT_ST#ADDRESS_REG#ADR_TYPE53","C__ST#ADDRESS_REG#DATE_BEGIN54","C_NT_ST#ADDRESS_REG#DATE_END55","C_LIENT_ST#ADDRESS_REG#HOUSE56","C_LIENT_ST#ADDRESS_REG#FRAME57","C_CLIENT_ST#ADDRESS_REG#FLAT58","C_IENT_ST#ADDRESS_REG#STREET59","C_IENT_ST#ADDRESS_REG#REGION60","C_NT_ST#ADDRESS_REG#DISTRICT61","C__ST#ADDRESS_REG#REGION_REF62","C_T#ADDRESS_REG#DISTRICT_REF63","C_T_ST#ADDRESS_REG#PLACE_REF64","C_CLIENT_ST#ADDRESS_REG#CITY65","C_ENT_ST#ADDRESS_REG#COUNTRY66","C__ST#ADDRESS_REG#DATE_AUDIT67","C_NT_ST#ADDRESS_REG#AFFIRMED68","C_LIENT_ST#ADDRESS_REG#ACTIV69","C__ST#ADDRESS_REG#HOUSES_REF70","C_FORM_CLIENT_ST#EDUCATION","C_FORM_CLIENT_ST#SOCIAL_STATUS","C_FORM_CLIENT_ST#SENIORITY","C_FORM_CLIENT_ST#FORMA_ORG","C_FORM_CLIENT_ST#FAMILY","C_FORM_CLIENT_ST#QUANT_DEPEND","C_NT_ST#ADDRESS_ORG#POST_IND77","C_LIENT_ST#ADDRESS_ORG#PLACE78","C_NT_ST#ADDRESS_ORG#ADR_TYPE79","C__ST#ADDRESS_ORG#DATE_BEGIN80","C_NT_ST#ADDRESS_ORG#DATE_END81","C_LIENT_ST#ADDRESS_ORG#HOUSE82","C_LIENT_ST#ADDRESS_ORG#FRAME83","C_CLIENT_ST#ADDRESS_ORG#FLAT84","C_IENT_ST#ADDRESS_ORG#STREET85","C_IENT_ST#ADDRESS_ORG#REGION86","C_NT_ST#ADDRESS_ORG#DISTRICT87","C__ST#ADDRESS_ORG#REGION_REF88","C_T#ADDRESS_ORG#DISTRICT_REF89","C_T_ST#ADDRESS_ORG#PLACE_REF90","C_CLIENT_ST#ADDRESS_ORG#CITY91","C_ENT_ST#ADDRESS_ORG#COUNTRY92","C__ST#ADDRESS_ORG#DATE_AUDIT93","C_NT_ST#ADDRESS_ORG#AFFIRMED94","C_LIENT_ST#ADDRESS_ORG#ACTIV95","C__ST#ADDRESS_ORG#HOUSES_REF96","C_FORM_CLIENT_ST#PHONE_ORG","C_FORM_CLIENT_ST#CASTA","C_CLIENT_ST#SOCIAL_STAT_WIFE99","C_FORM_CLIENT_ST#NAME_ORG_WIFE","C_FORM_CLIENT_ST#NAME_ORG","C_ADDRESS_ORG_WIFE#POST_IND102","C_ST#ADDRESS_ORG_WIFE#PLACE103","C_ADDRESS_ORG_WIFE#ADR_TYPE104","C_DRESS_ORG_WIFE#DATE_BEGIN105","C_ADDRESS_ORG_WIFE#DATE_END106","C_ST#ADDRESS_ORG_WIFE#HOUSE107","C_ST#ADDRESS_ORG_WIFE#FRAME108","C__ST#ADDRESS_ORG_WIFE#FLAT109","C_T#ADDRESS_ORG_WIFE#STREET110","C_T#ADDRESS_ORG_WIFE#REGION111","C_ADDRESS_ORG_WIFE#DISTRICT112","C_DRESS_ORG_WIFE#REGION_REF113","C_ESS_ORG_WIFE#DISTRICT_REF114","C_DDRESS_ORG_WIFE#PLACE_REF115","C__ST#ADDRESS_ORG_WIFE#CITY116","C_#ADDRESS_ORG_WIFE#COUNTRY117","C_DRESS_ORG_WIFE#DATE_AUDIT118","C_ADDRESS_ORG_WIFE#AFFIRMED119","C_ST#ADDRESS_ORG_WIFE#ACTIV120","C_DRESS_ORG_WIFE#HOUSES_REF121","C__CLIENT_ST#PHONE_ORG_WIFE122","C_FORM_CLIENT_ST#CASTA_WIFE","C_FORM_CLIENT_ST#ADDRESS_FLAT","C_FORM_CLIENT_ST#ADDRESS_EQUAL","C_FORM_CLIENT_ST#NOTE","C_FORM_CLIENT_ST#DATE_CREATE","C_FORM_CLIENT_ST#PREV_EXP","C_FORM_CLIENT_ST#ID_REQ","C_FORM_CLIENT_ST#LAST_NAME","C_FORM_CLIENT_ST#FIRST_NAME","C_FORM_CLIENT_ST#SUR_NAME","C_LIENT_ST#PHONE_HOME#ACTIV133","C_CLIENT_ST#PHONE_HOME#NUMB134","C_ENT_ST#PHONE_HOME#PRIVATE135","C_CLIENT_ST#PHONE_HOME#TYPE136","C_NT_ST#PHONE_HOME#AFFIRMED137","C_ONE_HOME#ALLOW_COLLECTION138","C_ENT_ST#PHONE_HOME#ID_DEAL139","C_IENT_ST#PHONE_HOME#ID_RBO140","C_ENT_ST#PHONE_HOME#CID_RBO141","C_HONE_HOME#KAS_VERIFICATED142","C__ST#PHONE_HOME#DATE_AUDIT143","C__ST#PHONE_HOME#ALLOW_CC_2144","C_LIENT_ST#PHONE_WORK#ACTIV145","C_CLIENT_ST#PHONE_WORK#NUMB146","C_ENT_ST#PHONE_WORK#PRIVATE147","C_CLIENT_ST#PHONE_WORK#TYPE148","C_NT_ST#PHONE_WORK#AFFIRMED149","C_ONE_WORK#ALLOW_COLLECTION150","C_ENT_ST#PHONE_WORK#ID_DEAL151","C_IENT_ST#PHONE_WORK#ID_RBO152","C_ENT_ST#PHONE_WORK#CID_RBO153","C_HONE_WORK#KAS_VERIFICATED154","C__ST#PHONE_WORK#DATE_AUDIT155","C__ST#PHONE_WORK#ALLOW_CC_2156","C_FORM_CLIENT_ST#MOBILE#ACTIV","C_FORM_CLIENT_ST#MOBILE#NUMB","C__CLIENT_ST#MOBILE#PRIVATE159","C_FORM_CLIENT_ST#MOBILE#TYPE","C_CLIENT_ST#MOBILE#AFFIRMED161","C_T#MOBILE#ALLOW_COLLECTION162","C__CLIENT_ST#MOBILE#ID_DEAL163","C_FORM_CLIENT_ST#MOBILE#ID_RBO","C__CLIENT_ST#MOBILE#CID_RBO165","C_ST#MOBILE#KAS_VERIFICATED166","C_IENT_ST#MOBILE#DATE_AUDIT167","C_IENT_ST#MOBILE#ALLOW_CC_2168","C_CLIENT_ST#PHONE_ADD#ACTIV169","C__CLIENT_ST#PHONE_ADD#NUMB170","C_IENT_ST#PHONE_ADD#PRIVATE171","C__CLIENT_ST#PHONE_ADD#TYPE172","C_ENT_ST#PHONE_ADD#AFFIRMED173","C_HONE_ADD#ALLOW_COLLECTION174","C_IENT_ST#PHONE_ADD#ID_DEAL175","C_LIENT_ST#PHONE_ADD#ID_RBO176","C_IENT_ST#PHONE_ADD#CID_RBO177","C_PHONE_ADD#KAS_VERIFICATED178","C_T_ST#PHONE_ADD#DATE_AUDIT179","C_T_ST#PHONE_ADD#ALLOW_CC_2180","C_FORM_CLIENT_ST#EMAIL#ACTIV","C_FORM_CLIENT_ST#EMAIL#NUMB","C_FORM_CLIENT_ST#EMAIL#PRIVATE","C_FORM_CLIENT_ST#EMAIL#TYPE","C__CLIENT_ST#EMAIL#AFFIRMED185","C_ST#EMAIL#ALLOW_COLLECTION186","C_FORM_CLIENT_ST#EMAIL#ID_DEAL","C_FORM_CLIENT_ST#EMAIL#ID_RBO","C_FORM_CLIENT_ST#EMAIL#CID_RBO","C__ST#EMAIL#KAS_VERIFICATED190","C_LIENT_ST#EMAIL#DATE_AUDIT191","C_LIENT_ST#EMAIL#ALLOW_CC_2192","C_FORM_CLIENT_ST#RCLIENT_DOC","C_FORM_CLIENT_ST#IMAGES","C_FORM_CLIENT_ST#INN","C_FORM_CLIENT_ST#SIK","C_FORM_CLIENT_ST#RNN_ORG","C_FORM_CLIENT_ST#NUM_CERT_ORG","C_LIENT_ST#DATE_END_CER_ORG199","C_FORM_CLIENT_ST#TYPE_ORG","C_FORM_CLIENT_ST#QUANT_CHILD","C_FORM_CLIENT_ST#PASSWORD","C_FORM_CLIENT_ST#ADD_PROP","C_FORM_CLIENT_ST#EDUCATION_STR","C_FORM_CLIENT_ST#QUANT_INFANT","C_FORM_CLIENT_ST#RELATION_LAW","C_FORM_CLIENT_ST#CATEG_CLIENT","C_FORM_CLIENT_ST#NOTE_CLIENT","C__ST#ADDRESS_WIFE#POST_IND209","C_ENT_ST#ADDRESS_WIFE#PLACE210","C__ST#ADDRESS_WIFE#ADR_TYPE211","C_T#ADDRESS_WIFE#DATE_BEGIN212","C__ST#ADDRESS_WIFE#DATE_END213","C_ENT_ST#ADDRESS_WIFE#HOUSE214","C_ENT_ST#ADDRESS_WIFE#FRAME215","C_IENT_ST#ADDRESS_WIFE#FLAT216","C_NT_ST#ADDRESS_WIFE#STREET217","C_NT_ST#ADDRESS_WIFE#REGION218","C__ST#ADDRESS_WIFE#DISTRICT219","C_T#ADDRESS_WIFE#REGION_REF220","C_ADDRESS_WIFE#DISTRICT_REF221","C_ST#ADDRESS_WIFE#PLACE_REF222","C_IENT_ST#ADDRESS_WIFE#CITY223","C_T_ST#ADDRESS_WIFE#COUNTRY224","C_T#ADDRESS_WIFE#DATE_AUDIT225","C__ST#ADDRESS_WIFE#AFFIRMED226","C_ENT_ST#ADDRESS_WIFE#ACTIV227","C_T#ADDRESS_WIFE#HOUSES_REF228","C_FORM_CLIENT_ST#PHONE_WIFE","C_FORM_CLIENT_ST#ANY_CRED","C_FORM_CLIENT_ST#INFO_DT_CR","C_NT_ST#RESULT_SCORING#RATE232","C_#RESULT_SCORING#MAX_SUMMA233","C__SCORING#MAX_PERIOD#QUANT234","C_T_SCORING#MAX_PERIOD#UNIT235","C_T_SCORING#MAX_MONTHLY_PAY236","C_FORM_CLIENT_ST#SUMMA","C_FORM_CLIENT_ST#PERIOD#QUANT","C_FORM_CLIENT_ST#PERIOD#UNIT","C_FORM_CLIENT_ST#LIST_ESTATE","C_FORM_CLIENT_ST#CALL_COMMENT","C_FORM_CLIENT_ST#PREV_EXP_SCOR","C_FORM_CLIENT_ST#MONTH_PROFIT","C_CLIENT_ST#CONTACT_PERSONS244","C_FORM_CLIENT_ST#RESIDENT","C__CLIENT_ST#LAST_NAME_WIFE246","C_CLIENT_ST#FIRST_NAME_WIFE247","C_FORM_CLIENT_ST#SUR_NAME_WIFE","C__CLIENT_ST#ORG_DEPARTMENT249","C__CLIENT_ST#TRANSFER_BKI#0250","C_FORM_CLIENT_ST#BKI_CODE_SUBJ","C_FORM_CLIENT_ST#KAS_CLIENT_ID","C_MONTHLY_PAY","C_TERM_PERIOD","C_STAGE","C_CHECK_ROUTE","C_EXEC_COMMENT","C_MNG_VIS_SCEN","C_CHECK_RESULT","C_BUY_REF","C_FOLDER_REF","C_INTER_STATE","C_LIMIT_SUM","C_VER_DATE" from V_RFO_Z#KAS_ONLINE_CLAIM;
grant select on U1.V_OUT_RFO_Z#KAS_ONLINE_CLAIM to IT6_USER;
grant select on U1.V_OUT_RFO_Z#KAS_ONLINE_CLAIM to LOADDB;
grant select on U1.V_OUT_RFO_Z#KAS_ONLINE_CLAIM to LOADER;

