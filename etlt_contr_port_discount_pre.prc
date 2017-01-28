CREATE OR REPLACE PROCEDURE U1.ETLT_CONTR_PORT_DISCOUNT_PRE is
      s_mview_name varchar2(30) := 'ETLT_CONTR_PORT_DISCOUNT_PRE';
begin
  --create table T_CONTRACT_PORT_DISCOUNT_PRE as
  insert into T_CONTRACT_PORT_DISCOUNT_PRE
  select /*+parallel(20)*/
         coalesce(pd.c_num_dog, c.c_num_dog, d.c_num_dog) contract_number
         ,coalesce(pd.id, c.id, d.id) rbo_contract_id
         ,vtd.yyyy_mm_dd rep_date
         ,mdt.total total_discount
         ,mdt.is_card
         ,coalesce(c.c_num_dog, d.c_num_dog) contract_number_discount
         ,coalesce(c.id, d.id) rbo_contract_id_discount
  from u1.M_CONTRACT_DISCOUNT mdt
  join V_TIME_DAYS vtd  on vtd.yyyy_mm_dd > (select max(rep_date) from T_CONTRACT_PORT_DISCOUNT_PRE) -->=to_date('2013-01-01', 'yyyy-mm-dd')
          and vtd.yyyy_mm_dd < trunc(sysdate)
          and vtd.yyyy_mm_dd >= mdt.c_date_in
          and vtd.yyyy_mm_dd <= mdt.c_date_out
  left join M_CONTRACT_PORT_DISCOUNT_PRE0 pd on mdt.rbo_contract_id =  coalesce(pd.c_kas_pc_dog_ref, pd.c_kas_pc_dog_t_ref)
           and pd.c_date_begin <= vtd.yyyy_mm_dd
           and pd.c_date_close >= vtd.yyyy_mm_dd
           and pd.c_limit_saldo is not null
  left join u1.V_RBO_Z#PR_CRED c on c.id = mdt.rbo_contract_id
  left join u1.V_RBO_Z#KAS_PC_DOG d on d.id = mdt.rbo_contract_id;
  --where 1=2

  commit;
end ETLT_CONTR_PORT_DISCOUNT_PRE;
/

