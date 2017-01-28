create or replace procedure u1.ETLCHK_M_FOLDER_CON_CANCEL is
   v_chk_name varchar2(50) := 'ETLCHK_M_FOLDER_CON_CANCEL';
   p_out_message varchar2(1000);
   v_cnt number;
   v_cntavg number;
   v_cntavg1 number;
   
   e_user_exception exception;
begin
  select sum(t.is_categ_a) into v_cnt from  M_FOLDER_CON_CANCEL t;

  select avg(tt.val)*0.8,avg(tt.val)*1.2 into v_cntavg,v_cntavg1
  from (  
    select avg(t.val) as val from NT_KEY_PARAM_HIST t
    where t.object_name='M_FOLDER_CON_CANCEL' and t.param_name='SUM IS_CATEG_A' and t.sdt>=trunc(sysdate)-15
  ) tt;
  
  if v_cntavg> v_cnt or v_cntavg1< v_cnt then
     p_out_message:='>20% отклонение количества записей от среднего 14дневного';
     insert into NT_ETLCHK_LOG (chk_name,descr) values (v_chk_name,p_out_message); 
     commit;
     raise e_user_exception;
  end if; 

  select sum(t.is_categ_b) into v_cnt from  M_FOLDER_CON_CANCEL t;

  select avg(tt.val)*0.8,avg(tt.val)*1.2 into v_cntavg,v_cntavg1
  from (  
    select avg(t.val) as val from NT_KEY_PARAM_HIST t
    where t.object_name='M_FOLDER_CON_CANCEL' and t.param_name='SUM IS_CATEG_B' and t.sdt>=trunc(sysdate)-15
  ) tt;
  
  if v_cntavg> v_cnt or v_cntavg1< v_cnt then
     p_out_message:='>20% отклонение количества записей от среднего 14дневного';
     insert into NT_ETLCHK_LOG (chk_name,descr) values (v_chk_name,p_out_message); 
     commit;
     raise e_user_exception;
  end if; 
        
end ETLCHK_M_FOLDER_CON_CANCEL;
/

