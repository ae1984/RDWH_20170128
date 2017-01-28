create or replace procedure u1.ETLCHK_V_CONTRACT_CAL_PRE is
   v_chk_name varchar2(50) := 'ETLCHK_V_CONTRACT_CAL_PRE';
   p_out_message varchar2(200);
   v_cnt number;

   e_user_exception exception;
begin
     select count(1) into v_cnt 
       from (
             select c.contract_number 
               from V_CONTRACT_CAL_PRE c 
              group by c.contract_number 
             having count(1) > 1);
     --
     if v_cnt != 0 then
        p_out_message := 'Обновление V_CONTRACT_CAL_PRE. Дублируется "contract_number"';
        insert into NT_ETLCHK_LOG (chk_name,descr) values (v_chk_name,p_out_message); 
        commit;
        raise e_user_exception;              
     end if;       
     
end ETLCHK_V_CONTRACT_CAL_PRE;
/

