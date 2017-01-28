create or replace force view u1.v_folder_all_rfo_tst_1 as
select f.folder_id, e.expert_min_date,
       floor(MONTHS_BETWEEN(f.folder_date_create, e.expert_min_date)) as expert_kaspi_age_full_months
from V_FOLDER_ALL_RFO f
join (select t.expert_login, trunc(min(t.folder_date_create)) as expert_min_date from V_FOLDER_ALL_RFO t
group by t.expert_login) e on e.expert_login = f.expert_login;
grant select on U1.V_FOLDER_ALL_RFO_TST_1 to LOADDB;
grant select on U1.V_FOLDER_ALL_RFO_TST_1 to LOADER;


