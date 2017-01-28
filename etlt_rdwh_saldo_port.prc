create or replace procedure u1.ETLT_RDWH_SALDO_PORT
  is
  s_mview_name     varchar2(30) := 'T_RDWH_SALDO_PORT';
  vStrDate         date := sysdate;
  d_date_check     date;
  n_saldo_out      number(21,2);
  begin
    select max(c_rep_date)+1
      into d_date_check
      from T_RDWH_SALDO_PORT;
    while d_date_check < trunc(sysdate) loop
      for rec in (select 1 np, '1401' main_usv from dual union all
                  select 2 np, '1403' main_usv from dual union all
                  select 3 np, '1411' main_usv from dual union all
                  select 4 np, '1417' main_usv from dual union all
                  select 5 np, '1740' main_usv from dual union all
                  select 6 np, '1424' main_usv from dual union all
                  select 7 np, '1741' main_usv from dual union all
                  select 8 np, '9130' main_usv from dual
                   order by 1)
      loop
        n_saldo_out := rdwh.F_GET_ACCFIN_SALDO@rdwh_exd(rec.main_usv,d_date_check);
        insert into T_RDWH_SALDO_PORT(c_rep_date,c_summa_saldo,c_pl_usv_num)
        values (d_date_check,n_saldo_out,rec.main_usv);
        
      end loop;
      
     d_date_check := d_date_check + 1;
   end loop;
   commit;

  end  ETLT_RDWH_SALDO_PORT;
/

