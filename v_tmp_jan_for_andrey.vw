create or replace force view u1.v_tmp_jan_for_andrey as
select /*+parallel(5)*/ --/*+index cm(IDX_Z#CM_CHECKPOINT_DATE_CR)*/
trunc(cm.c_date_create) as date_create, --"Дата создания",
u.c_name as manager_name, --"ФИО менеджера",
u.c_username as manager_login, --"Логин менеджера",
upper(ca.c_value) as manager_position,
sd.c_code || ' ' || sd.c_name as department, --"Структурное подразделение",
count(cm.id) as folder_count_per_day, --"количество папок за день"
u.id as manager_id,
u.c_num_tab as manager_num_tab
from V_RFO_z#cm_checkpoint cm, V_RFO_z#folders f,
     V_RFO_z#user u, V_RFO_z#STRUCT_DEPART sd, V_RFO_Z#CASTA ca
where f.id = cm.id
   and cm.c_create_user = u.id
   and u.c_st_depart = sd.id
   and u.c_casta = ca.id(+)
   and f.c_business != 90627365 -- id БП автокредитование
   and cm.c_date_create >=
--       to_date('01/11/2013 00:00:00', 'dd/mm/yyyy hh24:mi:ss') -- дата начала периода
       to_date('01/04/2014 00:00:00', 'dd/mm/yyyy hh24:mi:ss') -- дата начала периода
   and cm.c_date_create <
--       to_date('14/01/2014 16:00:00', 'dd/mm/yyyy hh24:mi:ss') -- дата окончания периода
       to_date('21/05/2014 00:00:00', 'dd/mm/yyyy hh24:mi:ss') -- дата окончания периода
   and cm.id not in (
      select f.folder_id from V_FOLDER_ALL_RFO f join V_CONTRACT_ALL_RFO c on c.rfo_contract_id = f.credit_contract_id
      where c.cr_program_name in ('ЭКСПРЕСС-КРЕДИТОВАНИЕ-ТОВАР','ЭКСПРЕСС-КРЕДИТЫ (УСЛУГИ)','АВТОКРЕДИТОВАНИЕ','АВТОКРЕДИТОВАНИЕ БУ',
            'АВТОКРЕДИТ','АВТОЗАПЧАСТИ','ЭКСПРЕСС-КРЕДИТЫ (ДЕНЬГИ)')
--      and f.folder_date_create >= to_date('01/11/2013 00:00:00', 'dd/mm/yyyy hh24:mi:ss') -- дата начала периода
--         and f.folder_date_create <= to_date('14/01/2014 16:00:00', 'dd/mm/yyyy hh24:mi:ss')
      and f.folder_date_create >= to_date('01/04/2014 00:00:00', 'dd/mm/yyyy hh24:mi:ss') -- дата начала периода
         and f.folder_date_create < to_date('21/05/2014 00:00:00', 'dd/mm/yyyy hh24:mi:ss')
   )
group by trunc(cm.c_date_create), u.c_name, u.c_username, ca.c_value, sd.c_code || ' ' || sd.c_name, u.id, u.c_num_tab
--)--131677 -- 138272
;
grant select on U1.V_TMP_JAN_FOR_ANDREY to LOADDB;
grant select on U1.V_TMP_JAN_FOR_ANDREY to LOADER;


