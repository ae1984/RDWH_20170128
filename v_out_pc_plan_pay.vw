create or replace force view u1.v_out_pc_plan_pay as
select /*+ parallel 5 */
       pd.c_num_dog, ps.c_plan_pay_off_dat,
       ps.c_summa_plan
  from v_rbo_z#kas_pc_stmt ps,
       v_rbo_z#kas_pc_dog pd
where ps.state_id = 'TO_PAY'
   and ps.c_plan_pay_off_dat != to_date('01-01-3000','dd-mm-yyyy')
   and ps.collection_id = pd.c_stmt_arr;
grant select on U1.V_OUT_PC_PLAN_PAY to IT6_USER;
grant select on U1.V_OUT_PC_PLAN_PAY to LOADDB;
grant select on U1.V_OUT_PC_PLAN_PAY to LOADER;


