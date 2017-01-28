create or replace force view u1.v_out_rep_dinara_age as
select  /*+ parallel 5 */
        case when trunc(months_between(sysdate,cfac.birth_date_client)/12) between 0 and 25 then 'до 25'
             when trunc(months_between(sysdate,cfac.birth_date_client)/12) between 26 and 30 then '26 - 30'
             when trunc(months_between(sysdate,cfac.birth_date_client)/12) between 31 and 35 then '31 - 35'
             when trunc(months_between(sysdate,cfac.birth_date_client)/12) between 36 and 40 then '36 - 40'
             when trunc(months_between(sysdate,cfac.birth_date_client)/12) between 41 and 45 then '41 - 45'
             when trunc(months_between(sysdate,cfac.birth_date_client)/12) between 46 and 50 then '46 - 50'
             when trunc(months_between(sysdate,cfac.birth_date_client)/12) between 51 and 55 then '51 - 55'
             when trunc(months_between(sysdate,cfac.birth_date_client)/12) between 56 and 60 then '56 - 60'
             when trunc(months_between(sysdate,cfac.birth_date_client)/12) >= 61 then 'старше 61'
             end as age_group,

        count(1) as cnt,
        count(distinct mfcc.rfo_client_id) as client_cnt,
        avg(case when gr.salary is not null and gr.salary>2121 then gr.salary end)  as avg_client_salary
/*select avg(gr.salary),avg(case when gr.salary is not null and gr.salary>2000 then gr.salary end),
count(*),count(case when gr.salary is not null and gr.salary>2000 then gr.salary end)*/
from u1.m_folder_con_cancel mfcc
left join u1.v_gcvp_report gr on mfcc.folder_id = gr.folder_id
left join u1.v_client_folder_all_cal cfac on cfac.client_iin = mfcc.iin
where trunc(mfcc.folder_date_create_mi) >= to_Date('01.10.2016','dd.mm.yyyy')
and  trunc(mfcc.folder_date_create_mi) < to_Date('01.01.2017','dd.mm.yyyy')

--and cfac.birth_date_client is null
--and mfcc.process_name like 'ОНЛАЙН КРЕДИТ'
group by case when trunc(months_between(sysdate,cfac.birth_date_client)/12) between 0 and 25 then 'до 25'
             when trunc(months_between(sysdate,cfac.birth_date_client)/12) between 26 and 30 then '26 - 30'
             when trunc(months_between(sysdate,cfac.birth_date_client)/12) between 31 and 35 then '31 - 35'
             when trunc(months_between(sysdate,cfac.birth_date_client)/12) between 36 and 40 then '36 - 40'
             when trunc(months_between(sysdate,cfac.birth_date_client)/12) between 41 and 45 then '41 - 45'
             when trunc(months_between(sysdate,cfac.birth_date_client)/12) between 46 and 50 then '46 - 50'
             when trunc(months_between(sysdate,cfac.birth_date_client)/12) between 51 and 55 then '51 - 55'
             when trunc(months_between(sysdate,cfac.birth_date_client)/12) between 56 and 60 then '56 - 60'
             when trunc(months_between(sysdate,cfac.birth_date_client)/12) >= 61 then 'старше 61'
             end
;
grant select on U1.V_OUT_REP_DINARA_AGE to LOADDB;
grant select on U1.V_OUT_REP_DINARA_AGE to LOADER;
grant select on U1.V_OUT_REP_DINARA_AGE to RISK_2FLOOR;


