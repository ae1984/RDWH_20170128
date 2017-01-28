create or replace force view u1.v_out_pr_plan_pay as
select /*+ no_parallel */
       pc.c_num_dog,
       po.c_date plan_date,
       sum(coalesce(po.c_summa, 0)) summa_plan
  from u1.T_RBO_Z#PLAN_OPER po,
       u1.V_RBO_Z#PR_CRED pc
where po.c_date >= to_date('01122014', 'ddmmyyyy')
   and po.c_oper != 2052198
   and po.c_is_executed = 0
   and po.collection_id = pc.c_list_plan_pay
   and po.c_date = (select /*+ no_parallel */
                           min(p.c_date)
                      from u1.t_rbo_z#plan_oper p
                     where p.collection_id = po.collection_id
                       and p.c_date >= to_date('01122014', 'ddmmyyyy')
                       and p.c_oper != 2052198
                       and p.c_is_executed = 0)
group by pc.c_num_dog, po.c_date;
grant select on U1.V_OUT_PR_PLAN_PAY to IT6_USER;
grant select on U1.V_OUT_PR_PLAN_PAY to LOADDB;
grant select on U1.V_OUT_PR_PLAN_PAY to LOADER;


