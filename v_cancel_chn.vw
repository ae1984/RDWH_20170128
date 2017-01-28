create or replace force view u1.v_cancel_chn as
select /*+parallel(30) parallel_index(30) */
       c.id as cancel_id,
       c.c_folders as folder_id,
       --f.c_n as folder_number,
       c.c_client as rfo_client_id,
       c.c_date as cancel_date,
       c.c_hist_err_level as cancel_level,
       upper(ct.c_type) as cancel_type_group,
       upper(ct.c_code) as cancel_type_code,
       upper(ct.c_name) as cancel_type_name,
       null as scorecard,
       upper(c.c_note) as cancel_notes,
       u.c_username as user_login,
       u.c_num_tab as user_num_tab,
       case when upper(ct.c_name) = 'ПКБ. ИМЕЕТСЯ ПРОСРОЧКА С УЧЕТОВ КУРСОВ ВАЛЮТ' then
               round(to_number(substr(c.c_note,
                             instr(c.c_note,'(',1,2)+2,
                             instr(c.c_note,'>') - (instr(c.c_note,'(',1,2)+3))),0)
               end as
       OVERDUE_AMOUNT_TOTAL_cancel,
         case when upper(ct.c_name) = 'ПКБ. ИМЕЕТСЯ ПРОСРОЧКА С УЧЕТОВ КУРСОВ ВАЛЮТ' then
               round(to_number(substr(c.c_note,
                             instr(c.c_note,'>')+2,
                             instr(c.c_note,')') - (instr(c.c_note,'>')+3))),0)
               end as
       OVERDUE_AMOUNT_CUTOFF,
           case when upper(ct.c_name) = 'ПКБ. ИМЕЕТСЯ ПРОСРОЧКА С УЧЕТОВ КУРСОВ ВАЛЮТ' then
               p.OVERDUE_AMOUNT_TOTAL_pkb
               end as
       OVERDUE_AMOUNT_TOTAL_pkb,
       c.c_user as user_id
     from
       V_RFO_Z#KAS_CANCEL c,
       V_RFO_Z#KAS_CANCEL_TYPES ct,
       V_RFO_Z#USER u,
       --V_RFO_Z#FOLDERS f,
       (select t.FOLDER_ID, max(t.OVERDUE_AMOUNT_TOTAL) as OVERDUE_AMOUNT_TOTAL_pkb
           from V_PKB_FOLDER t group by t.FOLDER_ID) p
     where
       ct.id = c.c_type and
       u.id = c.c_user and
       --f.id(+) = c.c_folders and
       --p.folder_id(+) = f.id
       p.folder_id(+) = c.c_folders
       and c.id in (select distinct cancel_id from T_CANCEL_GT)
union all
select /*+ parallel 30 */
       mc1.cancel_id, mc1.folder_id, mc1.rfo_client_id, mc1.cancel_date,
       mc1.cancel_err_level as cancel_level, mc1.cancel_type_group, mc1.cancel_type_code,
       mc1.cancel_type_name, mc1.scorecard, null as cancel_notes, null as user_login,
       null as user_num_tab, null as OVERDUE_AMOUNT_TOTAL_cancel, null as OVERDUE_AMOUNT_CUTOFF,
       null as OVERDUE_AMOUNT_TOTAL_pkb, null as user_id
from T_MO_RESULT_SCO_CANCEL_DAY mc1
where mc1.cancel_id in (select distinct cancel_id from T_CANCEL_GT)
union all
select /*+ parallel 30 */
       fc.form_client_id as cancel_id, f.folder_id, f.rfo_client_id, fc.form_client_date as cancel_date,
       '1' as cancel_level, 'RFO_FORM_CLIENT' as cancel_type_group, 'RFO_SCORING_RES' as cancel_type_code,
       'ОТКАЗ СКОРИНГА ПО ДАННЫМ РФО' as cancel_type_name, null as scorecard, null as cancel_notes,
       null as user_login, null as user_num_tab, null as OVERDUE_AMOUNT_TOTAL_cancel, null as OVERDUE_AMOUNT_CUTOFF,
       null as OVERDUE_AMOUNT_TOTAL_pkb, null as user_id
from V_FOLDER_ALL_RFO f
join V_FORM_CLIENT_ALL_RFO fc on fc.form_client_id = f.form_client_id and fc.scoring_result = 0
and fc.form_client_id in (select distinct cancel_id from T_CANCEL_GT)
;
grant select on U1.V_CANCEL_CHN to LOADDB;
grant select on U1.V_CANCEL_CHN to LOADER;


