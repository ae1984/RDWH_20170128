﻿CREATE OR REPLACE FORCE VIEW U1.VW_RPT_KAS_MONITORING_EX AS
SELECT
a1.ID ID, 'KAS_MONITORING' Class_Id,
a2.C_NAME CREATOR,
TO_CHAR(a1.C_DATE_CREATE,'dd.mm.yyyy hh24:mi:ss') CREATE_DATE,
b1.ID CL_ID,
c1.C_LAST_NAME||' '||c1.C_FIRST_NAME||' '||c1.C_SUR_NAME FIO,
b1.C_INN RNN,
b1.C_KAS_RNN IIN,
b1.C_SIK SIK,
DECODE(a1.C_TYPE_DELIVERY,1,'Денежный кредит',2,'Товарный кредит',3,'Услуги',6,'Кредитная карта') CRED_TYPE,
a1.C_CERTIFICATE#NUM UD_L,
a1.C_CERTIFICATE#SERIA UD_L_SER,
d1.C_CODE UDL_COD,
d1.C_NAME UDL_NAME,
a1.C_CERTIFICATE#WHO UDL_WHO,
TO_CHAR(a1.C_CERTIFICATE#DATE_DOC,'dd-mon-yyyy') UDL_DOC_DATE,
TO_CHAR(a1.C_CERTIFICATE#DATE_END,'dd-mon-yyyy') UDL_DOC_DATE_END,
a1.C_TERM_CRED#QUANT CR_TERM,
a1.C_SUMMA_CRED CR_SUMMA,
e1.C_NAME SHOP_NAME,
j1.ID ID_TOV,
i1.C_NAME NAME_TOV,
j1.C_NAME TOV_NAME,
h1.C_PRICE TOV_PRICE,
h1.C_QUANT TOV_QUANTITY,
h1.C_COST TOV_COST,
h1.C_BILL_SUMM TOV_BILL_SUMM,
o1.C_N FOLDER_NUM,
l1.C_NAME FOLDER_STATE,
o1.ID FOLDER_ID,
f1.C_NAME MON_RES,
m1.C_NAME USER_NAME,
m1.C_USERNAME USER_LOGIN,
g1.C_CODE PROG_REF_CODE,
g1.C_NAME PROG_REF_NAME,
n1.C_NAME DEP_NAME,
n1.C_CODE DEP_CODE,
q1.C_NAME TYPE_SERV,
r1.C_NAME SERV_NAME,
p1.C_COST SERV_COST,
p1.C_BILL_SUMM SERV_BILL_SUMM,
c1.C_DATE_PERS DATE_PERS,
c1.C_PLACE_BIRTH PLACE_BIRTH,
a3.C_NAME BUS_NAME,
a3.C_CODE BUS_CODE
    from V_RFO_Z#KAS_SERV_NAME r1, V_RFO_Z#KAS_UNIVERSAL_D q1, V_RFO_Z#SERVICE_INFO p1,
     V_RFO_Z#FOLDERS o1, V_RFO_Z#STRUCT_DEPART n1, V_RFO_Z#USER m1, V_RFO_Z#CM_POINT l1, V_RFO_Z#CM_CHECKPOINT k1,
      V_RFO_Z#KAS_TOV_NAME j1, V_RFO_Z#KIND_ZAL_BODY i1, V_RFO_Z#PROD_INFO h1, V_RFO_Z#PROD_PROPERTY g1,
       V_RFO_Z#KAS_UNIVERSAL_D f1, V_RFO_Z#SHOPS e1, V_RFO_Z#CERTIFIC_TYPE d1, V_RFO_Z#CL_PRIV c1,
        V_RFO_Z#CLIENT b1, V_RFO_Z#BUS_PROCESS a3, V_RFO_Z#USER a2, V_RFO_Z#KAS_MONITORING a1
    where q1.COLLECTION_ID is NULL and a1.C_AUDIT#EDIT=a2.id(+) and a1.C_BUSINESS_REF=a3.id(+)
      and (a1.C_CLIENT_REF = b1.ID and a1.C_CLIENT_REF = c1.ID and a1.C_CERTIFICATE#TYPE = d1.ID(+) and a1.C_SHOP_REF = e1.ID(+) and a1.C_MONITORING_RES = f1.ID(+) and a1.C_PROGRAM_REF = g1.ID(+) and a1.C_PROD_INFO_ARR = h1.COLLECTION_ID(+) and h1.C_TYPE_TOV = i1.ID(+) and h1.C_NAME_REF = j1.ID(+) and a1.C_FOLDER_REF = k1.ID(+) and k1.C_POINT = l1.ID(+) and k1.C_CREATE_USER = m1.ID(+) and k1.C_ST_DEPART = n1.ID(+) and a1.C_FOLDER_REF = o1.ID(+) and a1.C_SERV_INFO_ARR = p1.COLLECTION_ID(+) and p1.C_TYPE_SERV = q1.ID(+) and p1.C_NAME_REF = r1.ID(+))
      order by a1.C_DATE_CREATE;
grant select on U1.VW_RPT_KAS_MONITORING_EX to LOADDB;
grant select on U1.VW_RPT_KAS_MONITORING_EX to LOADER;


