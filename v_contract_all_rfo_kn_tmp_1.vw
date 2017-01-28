create or replace force view u1.v_contract_all_rfo_kn_tmp_1 as
select c."RFO_CONTRACT_ID",c."CONTRACT_NUMBER",c."RFO_CLIENT_ID",c."IS_CARD",c."CONTRACT_STATUS_CODE",c."CONTRACT_STATUS_NAME",c."CR_PROGRAM_CODE",c."CR_PROGRAM_NAME",c."CREDIT_TYPE_OF_CONTRACT",c."CREDIT_TYPE_OF_SCHEME",c."CR_SCHEME_NAME",c."TARIFF_PLAN_CODE",c."TARIFF_PLAN_NAME",c."GU_CONTRACT_NUM",c."IS_AA_APPROVED",c."AUTO_CALC_RESULT" from V_CONTRACT_ALL_RFO c
join V_CONTRACT_CAL cc on cc.contract_number = c.contract_number and
            cc.start_date_first >= to_date('2012-07-01','yyyy-mm-dd') and
            cc.product_first in ('КН','КНП');
grant select on U1.V_CONTRACT_ALL_RFO_KN_TMP_1 to LOADDB;
grant select on U1.V_CONTRACT_ALL_RFO_KN_TMP_1 to LOADER;


