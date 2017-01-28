create or replace force view u1.v_cancel_all as
select /*+ first_rows */
  c.id as cancel_id,
  c.c_folders as folder_id,
--  f.c_n as folder_number,
  c.c_client as rfo_client_id,
  c.c_date as cancel_date,
  c.c_hist_err_level as cancel_level,
  ct.c_type as cancel_type_group,
  ct.c_code as cancel_type_code,
  upper(ct.c_name) as cancel_type_name,
  null as scorecard,
  upper(c.c_note) as cancel_notes,
  u.c_username as user_login,
  u.c_num_tab as user_num_tab,
  upper(u.c_name) as user_name,
  upper(u.c_name_depart) as user_department,
  case when ct.c_code = 'PKB_CRD_OVERDUE_CUR' then
          round(to_number(substr(c.c_note,
                        instr(c.c_note,'(',1,2)+2,
                        instr(c.c_note,'>') - (instr(c.c_note,'(',1,2)+3))),0) end as
  OVERDUE_AMOUNT_TOTAL_cancel,
    case when ct.c_code = 'PKB_CRD_OVERDUE_CUR' then
          round(to_number(substr(c.c_note,
                        instr(c.c_note,'>')+2,
                        instr(c.c_note,')') - (instr(c.c_note,'>')+3))),0) end as
  OVERDUE_AMOUNT_CUTOFF/*,
      case when upper(ct.c_name) = 'ПКБ. ИМЕЕТСЯ ПРОСРОЧКА С УЧЕТОВ КУРСОВ ВАЛЮТ' then
          p.OVERDUE_AMOUNT_TOTAL_pkb
          end as
  OVERDUE_AMOUNT_TOTAL_pkb*/
from V_RFO_Z#KAS_CANCEL c
join V_RFO_Z#KAS_CANCEL_TYPES ct on ct.id = c.c_type
/*
join --V_RFO_Z#KAS_CANCEL_TYPES ct on ct.id = c.c_type and
     (select cth.cancel_type_id, cth.valid_from, cth.valid_to,
             cth.cancel_type_code, cth.cancel_type_type, cth.cancel_type_name,
             cth.err_level
          from V_CANCEL_TYPES_HIST_ERR_LEVEL cth
          where cth.err_level = 1) ct on ct.cancel_type_id = c.c_type and
               c.c_date >= ct.valid_from and c.c_date < ct.valid_to
*/
join V_RFO_Z#USER u on u.id = c.c_user
--join V_RFO_Z#FOLDERS f on f.id = c.c_folders
--left join (select t.FOLDER_ID, max(t.OVERDUE_AMOUNT_TOTAL) as OVERDUE_AMOUNT_TOTAL_pkb
--      from V_PKB t where t.folder_id is not null group by t.FOLDER_ID) p on p.folder_id = c.c_folders
where --c.c_date >= add_months(trunc(sysdate,'mm'),-12) and
      c.c_folders is not null and
      (c.c_hist_err_level = 1 or (ct.c_type in ('CLIENT_PC_TO_EKT') and upper(c.c_note) like '%ОТКАЗАЛСЯ%'))
union all
select mc1.cancel_id, mc1.folder_id, mc1.rfo_client_id, mc1.cancel_date,
       mc1.cancel_err_level as cancel_level, mc1.cancel_type_group, mc1.cancel_type_code,
       mc1.cancel_type_name, mc1.scorecard, null as cancel_notes, null as user_login,
       null as user_num_tab, null as user_name, null as user_department,
       null as OVERDUE_AMOUNT_TOTAL_cancel, null as OVERDUE_AMOUNT_CUTOFF--,
--       null as OVERDUE_AMOUNT_TOTAL_pkb
from T_MO_RESULT_SCO_CANCEL_DAY mc1
--where mc1.cancel_date >= add_months(trunc(sysdate,'mm'),-12)

--where mc2.cancel_date >= add_months(trunc(sysdate,'mm'),-12)
union all
select fc.form_client_id as cancel_id, f.folder_id, f.rfo_client_id, fc.form_client_date as cancel_date,
       '1' as cancel_level, 'RFO_FORM_CLIENT' as cancel_type_group, 'RFO_SCORING_RES' as cancel_type_code,
       'ОТКАЗ СКОРИНГА ПО ДАННЫМ РФО' as cancel_type_name, null as scorecard, null as cancel_notes,
       null as user_login, null as user_num_tab, null as user_name, null as user_department,
       null as OVERDUE_AMOUNT_TOTAL_cancel, null as OVERDUE_AMOUNT_CUTOFF--,
--       null as OVERDUE_AMOUNT_TOTAL_pkb
from V_FOLDER_ALL_RFO f
join V_FORM_CLIENT_ALL_RFO fc on fc.form_client_id = f.form_client_id and fc.scoring_result = 0
--where fc.form_client_date >= add_months(trunc(sysdate,'mm'),-12)
;
grant select on U1.V_CANCEL_ALL to LOADDB;
grant select on U1.V_CANCEL_ALL to LOADER;


