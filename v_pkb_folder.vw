create or replace force view u1.v_pkb_folder as
select p."FOLDER_ID",p."PKB_REPORT_ID",p."REPORT_IIN_RNN",p."REPORT_DATE",p."REPORT_STATUS",p."REPORT_TYPE",p."OVERDUE_AMOUNT_TOTAL",p."CONTRACT_STATE",p."CONTRACT_STATE_COUNT",p."CONTRACT_STATUS",p."CONTRACT_TYPE",p."CREDIT_PURPOSE",p."OVERDUE_AMOUNT",p."OVERDUE_INSTALMENTS",p."UPDATE_DATE",p."CONTRACT_ID" from v_pkb p
where p.folder_id is not null;
grant select on U1.V_PKB_FOLDER to LOADDB;
grant select on U1.V_PKB_FOLDER to LOADER;


