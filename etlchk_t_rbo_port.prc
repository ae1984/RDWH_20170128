create or replace procedure u1.ETLCHK_T_RBO_PORT is
   v_chk_name varchar2(50) := 'ETLCHK_T_RBO_PORT';
   p_out_message varchar2(1000);
   v_cnt number;
   v_cntavg number;
   v_cntavg1 number;
   
   e_user_exception exception;
begin
  select count(1) into v_cnt from  T_RBO_PORT t 
  where t.rep_date >= trunc(sysdate)-1;

  select avg(tt.delta)*0.95,avg(tt.delta)*1.05 into v_cntavg,v_cntavg1
  from (  
    select 
       t.*
       ,trunc(t.dt) as dt_t
       ,t.numrows-lag(t.numrows) over (partition by t.obj_name order by t.dt) as delta_cnt
       ,trunc(t.dt)-lag(trunc(t.dt)) over (partition by t.obj_name order by t.dt) as delta_dt
       ,(t.numrows-lag(t.numrows) over (partition by t.obj_name order by t.dt))
        / (trunc(t.dt)-lag(trunc(t.dt)) over (partition by t.obj_name order by t.dt)) as delta
    from NT_RDWH_OBJ_NUMROWS t
    where t.obj_name='T_RBO_PORT' and t.dt >= trunc(sysdate)-15 
  ) tt
  where tt.delta>0;
  
  if v_cntavg> v_cnt or v_cntavg1< v_cnt then
     p_out_message:='>5% отклонение количества записей от среднего 14дневного';
     insert into NT_ETLCHK_LOG (chk_name,descr) values (v_chk_name,p_out_message); 
     commit;
     raise e_user_exception;
  end if; 

      
end ETLCHK_T_RBO_PORT;
/

