create or replace procedure u1.ETLCHK_V_DATA_ALL is
   v_chk_name varchar2(50) := 'ETLCHK_V_DATA_ALL';
   p_out_message varchar2(200);
   v_cnt number;

   e_user_exception exception;
begin

     -- проверка невалидности рнн
     select count(1) 
       into v_cnt 
       from u1.V_DATA_ALL t 
      where length(t.rnn) != 12;
     --
     if v_cnt != 0 then
        p_out_message := 'Обновление V_DATA_ALL. Обнаруженны невалидные РНН';
        insert into NT_ETLCHK_LOG (chk_name,descr) values (v_chk_name,p_out_message); 
        commit;
        raise e_user_exception;

     end if;
     -- проверка невалидности иин
     select count(1) into v_cnt
       from u1.V_DATA_ALL t 
      where length(t.iin) != 12;
     --
     if v_cnt != 0 then
        p_out_message := 'Обновление V_DATA_ALL. Обнаруженны невалидные ИИН';
        insert into NT_ETLCHK_LOG (chk_name,descr) values (v_chk_name,p_out_message); 
        commit;
        raise e_user_exception;
     end if;
     -- проверка наличия казахских символов
     select count(1) into v_cnt
       from u1.V_DATA_ALL t 
      where t.is_card = 0 
        and t.client_name like '%?%';
     --
     if v_cnt = 0 then
        p_out_message := 'Обновление V_DATA_ALL. Пропали казахские символы';
        insert into NT_ETLCHK_LOG (chk_name,descr) values (v_chk_name,p_out_message); 
        commit;
        raise e_user_exception;

     end if;
     -- еще одна проверка на разницу тарифных планов
     select count(distinct dai.product_programm) into v_cnt 
       from u1.V_DATA_ALL dai
      where not exists (select 1 from u1.REF_PRODUCTS rp
                         where rp.product_program = dai.product_programm);
     --
     if v_cnt != 0 then
        p_out_message := 'Обновление V_DATA_ALL. Есть разница в продуктах';
        insert into NT_ETLCHK_LOG (chk_name,descr) values (v_chk_name,p_out_message); 
        commit;
        raise e_user_exception;

     end if;
     -- еще одна проверка на подразделение
     select count(1) into v_cnt
       from u1.V_DATA_ALL dai
      where not exists (select 1 from u1.ref_branch rb
                         where rb.old_branch = dai.branch_name)
        and dai.branch_name is not null
        and dai.branch_name != 'UNKNOWN';
     --
     if v_cnt != 0  then
        p_out_message := 'Обновление V_DATA_ALL. Есть разница в подразделениях branch_name <> UNKNOWN';
        insert into NT_ETLCHK_LOG (chk_name,descr) values (v_chk_name,p_out_message); 
        commit;
        raise e_user_exception;

     end if;
     --
     
end ETLCHK_V_DATA_ALL;
/

