create or replace force view u1.v_out_rep_dinara_region as
select /*+ parallel 5 */
         x_dnp_region,
         x_dnp_name,
         count(distinct rfo_client_id) as client_cnt,
         avg(sal) as avg_salary
from
  (
select mfcc.x_dnp_region,
       mfcc.x_dnp_name,
       mfcc.rfo_client_id,
       case when gr.salary is not null and gr.salary > 2121 then gr.salary end as sal,
       row_number() over (partition by  mfcc.x_dnp_region, mfcc.rfo_client_id order by mfcc.folder_date_create_mi desc) as rn


from u1.m_folder_con_cancel mfcc
left join u1.v_gcvp_report gr on mfcc.folder_id = gr.folder_id
left join u1.v_client_folder_all_cal cfac on cfac.client_iin = mfcc.iin
where trunc(mfcc.folder_date_create_mi) >= to_date('01.10.2016','dd.mm.yyyy')
and  trunc(mfcc.folder_date_create_mi) < to_date('01.01.2017','dd.mm.yyyy')
and x_dnp_region is not null
--and mfcc.rfo_client_id in ()

)
where rn = 1

group by x_dnp_region,
         x_dnp_name
;
grant select on U1.V_OUT_REP_DINARA_REGION to LOADDB;
grant select on U1.V_OUT_REP_DINARA_REGION to LOADER;
grant select on U1.V_OUT_REP_DINARA_REGION to RISK_2FLOOR;


