create or replace force view u1.v_mo_result_sco_cancel_day_p1x as
select /*+ parallel 30*/ t.rfo_res_folder_id,
       t.rfo_res_client_id,
       t.rfo_res_date,
       t.rfo_res_from_mo_id,
       t.rfo_result,
       t.cancel_type_code,
       t.cancel_type_name,
       t.is_rejecting,
       t.scorecard_num,
       t.rfolder_id,
       t.process_id,
       t.mogw_process_id
from M_MO_RES_SCO_CANCEL_DAY_P1X_13 t
union all
select /*+ parallel 30*/ t.rfo_res_folder_id,
       t.rfo_res_client_id,
       t.rfo_res_date,
       t.rfo_res_from_mo_id,
       t.rfo_result,
       t.cancel_type_code,
       t.cancel_type_name,
       t.is_rejecting,
       t.scorecard_num,
       t.rfolder_id,
       t.process_id,
       t.mogw_process_id
from M_MO_RES_SCO_CANCEL_DAY_P1X_14 t
union all
select  /*+ parallel 30*/ t.rfo_res_folder_id,
       t.rfo_res_client_id,
       t.rfo_res_date,
       t.rfo_res_from_mo_id,
       t.rfo_result,
       t.cancel_type_code,
       t.cancel_type_name,
       t.is_rejecting,
       t.scorecard_num,
       t.rfolder_id,
       t.process_id,
       t.mogw_process_id
from M_MO_RES_SCO_CANCEL_DAY_P1X_15 t
union all
select  /*+ parallel 30*/ t.rfo_res_folder_id,
       t.rfo_res_client_id,
       t.rfo_res_date,
       t.rfo_res_from_mo_id,
       t.rfo_result,
       t.cancel_type_code,
       t.cancel_type_name,
       t.is_rejecting,
       t.scorecard_num,
       t.rfolder_id,
       t.process_id,
       t.mogw_process_id
from M_MO_RES_SCO_CANCEL_DAY_P1X_16 t;
comment on table U1.V_MO_RESULT_SCO_CANCEL_DAY_P1X is 'Дневные фактические отказы скоринга МО (c холостыми)';
comment on column U1.V_MO_RESULT_SCO_CANCEL_DAY_P1X.RFO_RES_FOLDER_ID is 'Id папки в РФО';
comment on column U1.V_MO_RESULT_SCO_CANCEL_DAY_P1X.RFO_RES_CLIENT_ID is 'Id клиента в РФО';
comment on column U1.V_MO_RESULT_SCO_CANCEL_DAY_P1X.RFO_RES_DATE is 'Дата';
comment on column U1.V_MO_RESULT_SCO_CANCEL_DAY_P1X.CANCEL_TYPE_CODE is 'Код отказа';
comment on column U1.V_MO_RESULT_SCO_CANCEL_DAY_P1X.CANCEL_TYPE_NAME is 'Название отказа';
comment on column U1.V_MO_RESULT_SCO_CANCEL_DAY_P1X.IS_REJECTING is 'Признак отказа';
comment on column U1.V_MO_RESULT_SCO_CANCEL_DAY_P1X.SCORECARD_NUM is 'Номер скоркарты';
comment on column U1.V_MO_RESULT_SCO_CANCEL_DAY_P1X.RFOLDER_ID is 'Ссылка на MO_RFOLDER';
grant select on U1.V_MO_RESULT_SCO_CANCEL_DAY_P1X to LOADDB;
grant select on U1.V_MO_RESULT_SCO_CANCEL_DAY_P1X to LOADER;


