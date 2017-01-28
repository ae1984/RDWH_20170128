create or replace force view u1.hs_rfo_mo_tmp as
select distinct t.iin, t.name_last as last_name, t.name_first as first_name, t.name_patronymic as sur_name, t.date_birth as date_birth,
t.add_cause_desc as note, t.add_date as date_add, t.delete_date as date_delete, t.delete_cause_desc as reason_delete
from CLIENT_BL_ARCHIVE@Mo1_Prod t
join (
select t.iin, max(t.add_date) as date_add from CLIENT_BL_ARCHIVE@Mo1_Prod t
group by t.iin
) a on a.iin = t.iin and a.date_add = t.add_date
where t.delete_cause_desc = 'Категория клиента пересмотрена в связи с давностью данных.'
union
select distinct t.c_inn as iin, t.c_last_name as last_name, t.c_first_name as first_name, t.c_sur_name as sur_name, t.c_date_birth as date_birth,
       t.c_note as note, t.c_date_add as date_add, t.c_date_delete as date_delete, t.c_reason_delete as reason_delete
from V_RFO_Z#KAS_BLACK_LIST_D t
join (
select t1.c_inn, max(t1.c_date_add) as date_add from V_RFO_Z#KAS_BLACK_LIST_D t1
group by t1.c_inn
) a on a.c_inn = t.c_inn and a.date_add = t.c_date_add
where t.c_reason_delete = 'Задолженность погашена, категория клиента пересмотрена.';
grant select on U1.HS_RFO_MO_TMP to LOADDB;
grant select on U1.HS_RFO_MO_TMP to LOADER;


