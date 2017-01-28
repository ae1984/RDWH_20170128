create or replace force view u1.v_tmp_jomart_exp as
select /*+ no_parallel*/
       x.iin,
       x.contract_no,
       x.total_debt,
       x.delinq_days,
       case when t.is_on_balance = 'W' then 0 else 1 end is_on_balance
from (
select
to_char(t.cdhd_rep_date,'yyyy - mm') as yy_mm_report,
trunc(t.cdhd_rep_date,'mm') as yy_mm_report_date,
t.cdhd_rep_date as report_date,
t.cdhd_deal_number as contract_no,
substr(ltrim(t.cdhd_deal_number,'R'),1,7) as client_id,
case when length(t.cdhd_client_rnn) = 11 then lpad(t.cdhd_client_rnn,12,0) else t.cdhd_client_rnn end as rnn,
coalesce(t.cdhd_client_iin,rc.iin) as iin,
upper(t.cdhd_client_name) as client_name,
coalesce(rp.product,rp1.product,'UNKNOWN') as product,
coalesce(rp.product_refin,rp1.product_refin,'UNKNOWN') as product_refin,------------------
coalesce(rp.product_program,rp1.product_program) as product_programm,
t.cdhd_card_limit as contract_amount,
to_char(coalesce(t.cdhd_set_revolving_date,t.cdhd_begin_date),'yyyy - mm') as yy_mm_start,
coalesce(t.cdhd_set_revolving_date,t.cdhd_begin_date) as start_date,
t.cdhd_set_revolving_date as set_revolving_date, ------------------
t.cdhd_plan_end_date as end_date,
t.cdhd_actual_end_date as actual_end_date,
coalesce(t.cdhd_pc_cred,0) +
coalesce(t.cdhd_pc_prc,0) +
coalesce(t.cdhd_pc_overlimit,0) +
coalesce(t.cdhd_pc_overdraft,0) +
coalesce(t.cdhd_pc_ovrd_cred,0) +
coalesce(t.cdhd_pc_ovrd_prc,0) +
coalesce(t.cdhd_pc_ovrd_overlimit,0) +
coalesce(t.cdhd_pc_ovrd_overdraft,0) +
coalesce(t.cdhd_pc_vnb_ovrd_cred,0) +
coalesce(t.cdhd_pc_vnb_ovrd_overdraft,0) +
coalesce(t.cdhd_pc_vnb_ovrd_overlimit,0) +
coalesce(t.cdhd_pc_vnb_ovrd_prc_cred,0) as total_debt,
t.cdhd_cl_ovrd_days as delinq_days,
t.cdhd_dept_number as pos_code,
case when upper(t.cdhd_unp_name)='ГОРОД НЕ ОПРЕДЕЛЕН' or t.cdhd_unp_name is null then 'UNKNOWN'
     else upper(t.cdhd_unp_name) end as branch_name,
translate(upper(t.cdhd_create_empl_name),
          chr(53388)||chr(53384)||chr(53383)||chr(53904)||
          chr(53390)||chr(53380)||chr(53381),
          chr(53914)||chr(54168)||chr(53934)||chr(54184)||
          chr(53936)||chr(53906)||chr(53922)) as expert_name,---'ҚӘҮӨҰҒҢ'
coalesce(t.cdhd_pc_ovrd_cred,0) +
coalesce(t.cdhd_pc_ovrd_prc,0) +
coalesce(t.cdhd_pc_ovrd_overlimit,0) +
coalesce(t.cdhd_pc_ovrd_overdraft,0) +
coalesce(t.cdhd_pc_vnb_ovrd_cred,0) +
coalesce(t.cdhd_pc_vnb_ovrd_overdraft,0) +
coalesce(t.cdhd_pc_vnb_ovrd_overlimit,0) +
coalesce(t.cdhd_pc_vnb_ovrd_prc_cred,0) as delinq_amount,
t.cdhd_ovrd_days as delinq_days_old,
upper(t.cdhd_deal_status) as deal_status,------new
lag(upper(t.cdhd_deal_status),1,null) over (
       partition by t.cdhd_deal_number order by t.cdhd_rep_date) as deal_status_prev,--------new
1 as is_card
from DWH_SAN.DM_CARDSDAILY_HD@DWH_PROD2 t
left join U1.REF_PRODUCTS rp on rp.product_program = upper(t.cdhd_prod_name)
left join U1.REF_PRODUCTS rp1 on rp1.product_program = upper(t.cdhd_prod_type)
left join (select c.x_rnn as rnn,
                max(c.x_iin) keep (dense_rank last order by c.id) as iin
            from U1.V_RFO_Z#CLIENT c
            where c.x_rnn is not null and
                  c.class_id = 'CL_PRIV'
            group by c.x_rnn
           ) rc on rc.rnn = t.cdhd_client_rnn
where upper(t.cdhd_prod_name) not like '%ТЕСТ%'
and upper(t.cdhd_prod_name) != 'СЧЕТ KASPI.KZ'
and upper(t.cdhd_deal_status) not in ('ОТКАЗ','ВВЕДЕН','ПОДПИСАН')
and t.cdhd_rep_date = to_date('27-02-2015','dd-mm-yyyy')
and not (upper(t.cdhd_client_name) like 'АХМЕТКАЛИЕВ АМАНГЕЛЬДЫ САДВОКАСОВИЧ'
and coalesce(rp.product_program,rp1.product_program) = 'ЛУЧШИЙ КЛИЕНТ (L)')
--and t.cdhd_cl_ovrd_days >= 91
--and t.cdhd_cl_ovrd_days <= 120
union all
select
to_char(s.exhd_rep_date,'yyyy - mm') as yy_mm_report,
trunc(s.exhd_rep_date,'mm') as yy_mm_report_date,
s.exhd_rep_date as report_date,
s.exhd_deal_number as contract_no,
substr(ltrim(s.exhd_deal_number,'R'),1,7) as client_id,
case when length(s.exhd_client_rnn) = 11 then lpad(s.exhd_client_rnn,12,0) else s.exhd_client_rnn end as rnn,
coalesce(s.exhd_client_iin,rc.iin) as iin,
upper(s.exhd_client_name) as client_name,
coalesce(rp.product,rp1.product,'UNKNOWN') as product,
coalesce(rp.product_refin,rp1.product_refin,'UNKNOWN') as product_refin,
coalesce(rp.product_program,rp1.product_program) as product_programm,
s.exhd_amount as contract_amount,
to_char(s.exhd_begin_date,'yyyy - mm') as yy_mm_start,
s.exhd_begin_date as start_date,
null as set_revolving_date,
s.exhd_plan_end_date as end_date,
s.exhd_actual_end_date as actual_end_date,
coalesce(s.exhd_fgu_cred,0) +
coalesce(s.exhd_fgu_prc,0) +
coalesce(s.exhd_fgu_ovrd_cred,0) +
coalesce(s.exhd_fgu_ovrd_prc,0) +
coalesce(s.exhd_vnb_ovrd_cred,0) +
coalesce(s.exhd_vnb_ovrd_prc,0) +
coalesce(s.exhd_vnb_comm,0) +
coalesce(s.exhd_fgu_overdraft,0) +
coalesce(s.exhd_fgu_ovrd_overdraft,0)
as total_debt,
s.exhd_cl_ovrd_days as delinq_days,
s.exhd_dept_number as pos_code,
case when upper(s.exhd_unp_name)='ГОРОД НЕ ОПРЕДЕЛЕН' or s.exhd_unp_name is null then 'UNKNOWN'
     else upper(s.exhd_unp_name) end as branch_name,
translate(upper(s.exhd_create_empl_name),
          chr(53388)||chr(53384)||chr(53383)||chr(53904)||
          chr(53390)||chr(53380)||chr(53381),
          chr(53914)||chr(54168)||chr(53934)||chr(54184)||
          chr(53936)||chr(53906)||chr(53922)) as expert_name,-----'ҚӘҮӨҰҒҢ'
coalesce(s.exhd_fgu_ovrd_cred,0) +
coalesce(s.exhd_fgu_ovrd_prc,0) +
coalesce(s.exhd_vnb_ovrd_cred,0) +
coalesce(s.exhd_vnb_ovrd_prc,0) +
coalesce(s.exhd_vnb_comm,0) +
coalesce(s.exhd_fgu_ovrd_overdraft,0)
as delinq_amount,
s.exhd_ovrd_days as delinq_days_old,
upper(s.exhd_deal_status) as deal_status,----------new
lag(upper(s.exhd_deal_status),1,null) over (
       partition by s.exhd_deal_number order by s.exhd_rep_date) as deal_status_prev,------new
0 as is_card
from DWH_SAN.DM_SPGU_HD@DWH_PROD2 s
left join REF_PRODUCTS rp on rp.product_program = upper(s.exhd_prod_name)
left join REF_PRODUCTS rp1 on rp1.product_program = upper(s.exhd_prod_type)
left join (select c.x_rnn as rnn,
                max(c.x_iin) keep (dense_rank last order by c.id) as iin
            from V_RFO_Z#CLIENT c
            where c.x_rnn is not null and
                  c.class_id = 'CL_PRIV'
            group by c.x_rnn
           ) rc on rc.rnn = s.exhd_client_rnn
where upper(s.exhd_prod_name) not like '%ТЕСТ%' and
      upper(s.exhd_prod_name) != 'СЧЕТ KASPI.KZ' and
      upper(s.exhd_deal_status) not in ('ОТКАЗ','ВВЕДЕН','ПОДПИСАН')
      and s.exhd_rep_date = to_date('27-02-2015','dd-mm-yyyy')
--     and s.exhd_cl_ovrd_days >= 91
--      and s.exhd_cl_ovrd_days <= 120
) x
left join V_DWH_PORTFOLIO_CURRENT t
  on x.contract_no = t.deal_number
where not (x.deal_status in ('ЗАКРЫТ','ОПЛАЧЕН СК','ЗАКРЫТО','ПОГАШЕН ДОСРОЧНО') and
           x.deal_status_prev in ('ЗАКРЫТ','ОПЛАЧЕН СК','ЗАКРЫТО','ПОГАШЕН ДОСРОЧНО') and
           x.deal_status_prev is not null)
;
grant select on U1.V_TMP_JOMART_EXP to LOADDB;
grant select on U1.V_TMP_JOMART_EXP to LOADER;


