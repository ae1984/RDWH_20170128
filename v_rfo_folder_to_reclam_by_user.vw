create or replace force view u1.v_rfo_folder_to_reclam_by_user as
select /*+parallel(12)*/
     u.c_username
     ,u.c_name
    ,count(*) as cnt_folder
from v_folder_all_rfo f
left join v_rfo_Z#user u on u.c_username = f.expert_login
where f.folder_state = 'НА РЕКЛАМАЦИЮ'
group by
     u.c_username
     ,u.c_name
order by count(*) desc;
grant select on U1.V_RFO_FOLDER_TO_RECLAM_BY_USER to LOADDB;


