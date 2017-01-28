create or replace force view u1.v_j_tmp_xls_con_after_opt as
select to_char(d.x_start_date_actual, 'yyyy - mm') as start_mon,
       1 as is_con,
       d.x_start_date_actual, d.deal_number as contract_number, d.client_iin,
       d.prod_type, d.unp_name,
       d.x_total_debt as total_debt,
       case when d.x_delinq_days > 7 then d.x_total_debt else 0 end as total_debt_del_7,
       case when d.x_delinq_days > 0 then d.x_total_debt else 0 end as total_debt_del_1,
       case when d.x_delinq_days > 7 then 1 else 0 end as is_del_7,
       coalesce(greatest(c.max_debt_used, d.x_total_debt), c.max_debt_used, d.x_total_debt) as sales,
       case when coalesce(greatest(c.max_debt_used,d.x_total_debt),c.max_debt_used,d.x_total_debt) > 0 then
              case when d.x_delinq_days > 7 then d.x_total_debt end /
                   coalesce(greatest(c.max_debt_used,d.x_total_debt),c.max_debt_used,d.x_total_debt)
            end as del_7_rate_by_vol,
       i."DEAL_NUMBER",i."PRIOR_OPTIM_DATE_MAX",i."PRIOR_OPTIM_DATE_MIN",i."LAST_PRIOR_OPTIM_DAYS_AGO",i."FIRST_PRIOR_OPTIM_DAYS_AGO",i."PRIOR_OPTIM_COUNT",i."PRIOR_OPTIM_SOFT_COUNT",i."PRIOR_OPTIM_HARD_COUNT"
from V_DWH_PORTFOLIO_CURRENT d
left join V_CONTRACT_CAL c on c.contract_number = d.deal_number -- для max_debt_used
join (-- аггрегируем на договор данные по предыдущим оптимизациям
    select d.deal_number,
           max(o.spof_end_date) as prior_optim_date_max,
           min(o.spof_end_date) as prior_optim_date_min,
           min(d.x_start_date_actual) - max(o.spof_end_date) as last_prior_optim_days_ago,
           min(d.x_start_date_actual) - min(o.spof_end_date) as first_prior_optim_days_ago,
           count(o.spof_end_date) as prior_optim_count,
           count(case when o.restr_type = 'SOFT' then o.spof_end_date end) as prior_optim_soft_count,
           count(case when o.restr_type = 'HARD' then o.spof_end_date end) as prior_optim_hard_count
    from V_DWH_PORTFOLIO_CURRENT d
    join (-- ищем предыдущие оптимизации по клиенту
         -- оптимизации по договору ГУ - аггрегация по дням
         select t.spof_end_date, t.contract_number,
                max(p.client_iin) as client_iin,
                min(t.restr_type) as restr_type,
                max(t.restructing_type_name) keep (dense_rank last
                        order by t.spof_end_date, t.spof_gid) as restr_name
         from M_DWH_ACC_SPECIAL_OFFER_CON t
         join V_DWH_PORTFOLIO_CURRENT p on p.DEAL_NUMBER = t.CONTRACT_NUMBER
         where t.spof_spec_offer_status_cd in ('EXECUTED','DEFAULT','WORK')
         group by t.spof_end_date, t.contract_number
    ) o on o.client_iin = d.client_iin and o.spof_end_date < d.x_start_date_actual -- предыдущие
    where d.x_is_credit_issued = 1 and -- выданные
          d.x_start_date_actual is not null -- настоящие кредиты
    group by d.deal_number
) i on i.deal_number = d.deal_number
where d.x_is_credit_issued = 1 and -- выданные
      d.x_product_type != 'ОПТИМИЗАЦИЯ' and -- не оптимизация
      d.x_start_date_actual is not null -- настоящие кредиты
;
grant select on U1.V_J_TMP_XLS_CON_AFTER_OPT to LOADDB;
grant select on U1.V_J_TMP_XLS_CON_AFTER_OPT to LOADER;


