create or replace procedure u1.ETLCHK_RBO_CONTRACT_PORTFOLIO is
   v_chk_name varchar2(50) := 'ETLCHK_RBO_CONTRACT_PORTFOLIO';
   p_out_message varchar2(200);
   v_cnt number;

   e_user_exception exception;
begin
     select count(1) into v_cnt 
       from (
             select t.rbo_contract_id, t.rep_date 
               from T_RBO_CONTRACT_PORTFOLIO t 
              group by t.rbo_contract_id, t.rep_date
             having count(1) > 1);
     --
     if v_cnt != 0 then
        p_out_message := 'Обновление T_RBO_CONTRACT_PORTFOLIO. Дублируется "rbo_contract_id"';
        insert into NT_ETLCHK_LOG (chk_name,descr) values (v_chk_name,p_out_message); 
        commit;
        raise e_user_exception;                   
     end if;      
          
end ETLCHK_RBO_CONTRACT_PORTFOLIO;
/

