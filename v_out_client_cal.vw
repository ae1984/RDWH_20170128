﻿create or replace force view u1.v_out_client_cal as
select /*+ parallel 5 */
CLIENT_ID,
CONTRACT_NUMBER_FIRST,
CLIENT_NAME,
PRODUCT_FIRST,
PRODUCT_PROGRAM_FIRST,
START_DATE_FIRST,
END_DATE_FIRST,
CONTRACT_AMOUNT_FIRST,
EXPERT_NAME_FIRST,
POS_CODE_FIRST,
PRODUCT_LAST,
PRODUCT_PROGRAM_LAST,
START_DATE_LAST,
END_DATE_LAST,
CONTRACT_AMOUNT_LAST,
EXPERT_NAME_LAST,
POS_CODE_LAST,
CONTRACT_AMOUNT_MAX,
CONTRACT_AMOUNT_MIN,
MAX_DEBT_USED,
DELINQ_DAYS_MAX,
NUMBER_OF_CONTRACTS,
YY_MM_REPORT_MAX,
CLIENT_RNN_FIRST,
CLIENT_RNN_LAST,
CLIENT_IIN_FIRST,
CLIENT_IIN_LAST,
YY_MM_START_FIRST,
YY_MM_START_FIRST_NUM,
YY_MM_START_LAST,
YY_MM_START_LAST_NUM,
BIRTH_DATE,
BIRTH_PLACE

from v_client_cal t;
grant select on U1.V_OUT_CLIENT_CAL to IT6_USER;
grant select on U1.V_OUT_CLIENT_CAL to LOADDB;
grant select on U1.V_OUT_CLIENT_CAL to LOADER;


