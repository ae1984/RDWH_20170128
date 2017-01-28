create or replace procedure u1.ETLCHK_V_DATA_ALL_DWH is
   v_chk_name varchar2(50) := 'ETLCHK_V_DATA_ALL_DWH';
   p_out_message varchar2(200);
   v_cnt number;

   e_user_exception exception;
begin
     select count(1) into v_cnt 
       from (
              select d.contract_no, d.yy_mm_report 
                from u1.V_DATA_ALL_DWH d
               group by d.contract_no, d.yy_mm_report 
              having count(1) > 1);
     --
     if v_cnt != 0 then
        p_out_message := 'Обновление V_DATA_ALL_DWH. Обнаруженны дубли.';
        insert into NT_ETLCHK_LOG (chk_name,descr) values (v_chk_name,p_out_message); 
        commit;
        --raise e_user_exception;
     end if;  
end ETLCHK_V_DATA_ALL_DWH;
/

