create or replace force view u1.v_dwh_plan_oper as
select c1.date_plan_pay as operation_date, 1 as is_card, c1.dcard_gid as dwh_contract_id,c1.dcard_number as contract_number, c1.plan_payment_amount,
c1.cardplanr_number,c1.stmt_status_cd as status_id,c1.stmt_status_name as status_name,null as type_id,null as type_name from M_DWH_PLAN_OPER_CARD c1
union all
select t1.crdtplanr_date_plan_pay as operation_date, 0 as is_card, t1.crdtplanr_crdt_gid as dwh_contract_id,t1.crdt_number as contract_number, t1.crdtplanr_plan_payment_amount as plan_payment_amount,
t1.crdtplanr_number,null as status_id,null as status_name,t1.crdtplanr_operation_type_cd as type_id,t1.operation_type_name as type_name from M_DWH_PLAN_OPER_CREDIT t1;
grant select on U1.V_DWH_PLAN_OPER to LOADDB;
grant select on U1.V_DWH_PLAN_OPER to LOADER;


