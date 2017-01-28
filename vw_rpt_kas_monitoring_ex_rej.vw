create or replace force view u1.vw_rpt_kas_monitoring_ex_rej as
select
  min(CREATE_DATE) as prc_date_min,
  upper(min(FIO)) as FIO,
  min(CL_ID) as CL_ID,
  min(IIN) as IIN,
  min(RNN) as rnn,
  min(USER_NAME) as sales_manager,
  round(max(CR_SUMMA),0) as CR_SUMMA,
  min(PROG_REF_NAME) as PROG_REF_NAME,
  upper(min(DEP_NAME)) as DEP_NAME,
  min(DEP_CODE) as DEP_CODE,
  'UNKNOWN' as monitoring_manager,
  min(decline_reason) as cause_name,
  min(c_comments) as rej_comment,
  folder_id
from (
  select
--    substr(t.CREATE_DATE,1,10) as create_date,
    t.CREATE_DATE as create_date,
    t.FIO,
    t.CL_ID,
    t.IIN,
    t.RNN,
    upper(t.USER_NAME) as USER_NAME,
    t.CR_SUMMA,
    upper(last_value(t.PROG_REF_NAME) over (partition by t.FOLDER_ID)) as PROG_REF_NAME,
    t.DEP_NAME,
    u2.c_name as decline_reason,
    m.c_comments,
    t.FOLDER_ID,
    t.DEP_CODE
  from VW_RPT_KAS_MONITORING_EX t, v_rfo_z#kas_monitoring m, V_RFO_z#kas_universal_d u2
  where t.MON_RES = 'Отказано' and t.FOLDER_ID is not null and m.id = t.ID and
        u2.id(+) = m.c_decline_reason
) group by folder_id
;
grant select on U1.VW_RPT_KAS_MONITORING_EX_REJ to LOADDB;
grant select on U1.VW_RPT_KAS_MONITORING_EX_REJ to LOADER;


