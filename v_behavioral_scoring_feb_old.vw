create or replace force view u1.v_behavioral_scoring_feb_old as
select p1."YY_MM_REPORT",p1."YY_MM_END_DATE",p1."RFO_CLIENT_ID",p1."CON_AMOUNT_FIRST_SUM",p1."CON_START_FACT_PMTS_MIN",p1."CON_START_FACT_PMTS_MAX",p1."CON_START_UNDONE_PMTS_MIN",p1."CON_START_UNDONE_PMTS_MAX",p1."CON_START_DEL_DAYS_MIN",p1."CON_START_DEL_DAYS_MAX",p1."CON_START_PMT_MAX_BY_CLI",p1."CON_PKB_TOTAL_DEBT",p1."CON_PKB_PMT_ACTIVE_ALL_SUM",p1."PORT_CONTRACT_AMOUNT_SUM",p1."PORT_TOTAL_DEBT_SUM",p1."PORT_DELINQ_DAYS_MAX",p1."DELING_DAYS_ON_DATE",p1."PORT_PMT_BY_CLI_SUM",p1."PORT_PLANNED_PMTS_BY_CLI_SUM",p1."PORT_FACT_PMTS_BY_CLI_SUM",p1."PORT_BRANCH_NAME_FIRST",p1."PORT_BRANCH_NAME_LAST",p1."PORT_PRODUCT_REFIN_FIRST",p1."PORT_PRODUCT_REFIN_LAST",p1."IS_HIGH_DELING",p1."CON_FIRST_PMT_DELINQ_MIN",p1."CON_FIRST_PMT_DELINQ_MAX",p1."CON_FIRST_PMT_DELING_SUM",p1."CON_FIRST_PMT_DELINQ_AVG",p1."CON_FOUR_PMTS_DEL_MAX_MIN",p1."CON_FOUR_PMTS_DEL_MAX_MAX",p1."CON_FOUR_PMTS_DEL_MAX_SUM",p1."CON_FOUR_PMTS_DEL_MAX_AVG",p1."FOUR_PMTS_UNDONE_PMTS",p1."UNDONE_PMTS_THREE_MONTHS",p1."UNDONE_PMTS_SIX_MONTHS",p1."UNDONE_PMTS_TWELVE_MONTHS",
       p2.form_salary, p2.form_prescoring_result_first, p2.form_prescoring_result_last,
       p3.port_pkb_total_debt, p3.port_pkb_pmt_active_all_sum, p3.port_gcvp_sal,
       round(p3.gcvp_sal_to_start_pmt,4) as gcvp_sal_to_start_pmt,
       a.max_delinq_feb, a.debt_feb,a.delinq_feb,
       a.max_delinq_3,a.debt_3, a.delinq_3,
       a.max_delinq_6, a.debt_6, a.delinq_6,
       a.max_delinq_aug, a.delinq_aug, a.debt_aug,
       a.fpd, a.max_delinq_4pd, a.planned_pmts

from V_FOR_SCORING_JAN_P1_FEB p1
left join V_FOR_SCORING_JAN_P2_FEB p2 on p2.rfo_client_id = p1.rfo_client_id and p2.yy_mm_report = p1.yy_mm_report
left join V_FOR_SCORING_JAN_P3_FEB p3 on p3.rfo_client_id = p1.rfo_client_id and p3.yy_mm_report = p1.yy_mm_report
left join V_BEH_SCORING_AD_VERSION_1 a on a.rfo_client_id = p1.rfo_client_id;
grant select on U1.V_BEHAVIORAL_SCORING_FEB_OLD to LOADDB;
grant select on U1.V_BEHAVIORAL_SCORING_FEB_OLD to LOADER;


