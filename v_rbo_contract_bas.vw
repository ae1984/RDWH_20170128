create or replace force view u1.v_rbo_contract_bas as
select
--RDWH2.0
   con."RBO_CLIENT_ID",con."RBO_CONTRACT_ID",con."CONTRACT_NUMBER",con."IS_ACTIVE",con."IS_CREDIT_PRODUCT"
   ,case when refin.rbo_contract_id_to is null then 0 else 1 end is_refin

   -----------возможно часть не используется
  /*,ref_old.deal_number_to
  ,ref_old.refin_deal_number
  ,ref_old.refin_rbo_contract_id
  ,ref_old.refin_type
  ,ref_old.refin_summa
  ,ref_old.refin_date
  ,ref_old.kas_pc_fo_id  */
from (
      select
          pc.c_client as rbo_client_id
          ,pc.id as rbo_contract_id
          ,pc.c_num_dog as contract_number
          ,nvl(csp.is_active,0) as is_active
          ,cast(1 as number)  as is_credit_product
      from V_RBO_Z#PR_CRED pc
      left join V_RBO_Z#COM_STATUS_PRD_ADD1 csp on csp.id = pc.c_com_status
      union all
      select
          kpd.c_client_ref as rbo_client_id
          ,kpd.id as rbo_contract_id
          ,kpd.c_num_dog as contract_number
          ,nvl(csp.is_active,0) as is_active
          ,nvl(cp.is_credit_product,0) as is_credit_product
      from V_RBO_Z#KAS_PC_DOG kpd
      left join V_RBO_Z#COM_STATUS_PRD_ADD1 csp on csp.c_code = kpd.state_id
      left join V_RBO_Z#TARIF_PLAN tp on tp.id = kpd.c_tarif_plan_ref
      left join V_RBO_Z#CRED_PROGRAM_ADD1 cp on cp.id = tp.c_kas_cr_prog_ref
       where nvl(cp.c_code,'-') <> 'KASPI_KZ'                      --исключаем контракты по кошельку
         and nvl(tp.c_code,'-') <> 'GR_TEST_GRC'                  --исключаем контракты по тестовому ТП(2 договора)
) con
left join (
   select
       refin1.rbo_contract_id_to
   from u1.V_RBO_CONTRACT_REFIN_LINK refin1
   group by  refin1.rbo_contract_id_to
) refin on  refin.rbo_contract_id_to = con.rbo_contract_id
;
grant select on U1.V_RBO_CONTRACT_BAS to LOADDB;


