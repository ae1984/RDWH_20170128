create or replace procedure u1.ETLT_RBO_CONTRACT_DATA_PMT is
   v_rep_date date;
begin
   select max(rep_date) into v_rep_date from t_rbo_port;
   delete from M_RBO_CONTRACT_DATA_PMT where rbo_contract_id in (select rbo_contract_id from M_RBO_CONTRACT_DATA_PMT_BUFF5);
   commit;
   insert /*+append parallel(10)*/ into M_RBO_CONTRACT_DATA_PMT
   select /*+parallel(10)*/ * from M_RBO_CONTRACT_DATA_PMT_BUFF5;
   commit;
   
   update M_RBO_CONTRACT_DATA_PMT
      set rep_date=v_rep_date;
   commit;   
end ETLT_RBO_CONTRACT_DATA_PMT;
/

