create or replace procedure u1.ETLT_ODWH_Z#PAY_DOK is
   d_date_load date;
   d_max_pay_dok date;
begin
   --определяем дату последнего рабочего дня прошлого месяца
   select max(value)
     into d_date_load
     from M_RBO_CALENDAR_VALUE
    where calendar_name = 'LAST_MONTH_DAY'      
      and value < trunc(sysdate);
   select max(c_opdate)
     into d_max_pay_dok
     from T_ODWH_Z#PAY_DOK;
   
   execute immediate ('truncate table T_ODWH_Z#PAY_DOK_PRE');
   insert into T_ODWH_Z#PAY_DOK_PRE
   select *
   from ibs.Z#PAY_DOK@dwh_old
   where c_opdate > d_max_pay_dok --to_date('30.09.2016','dd.mm.yyyy')
      and c_opdate <= d_date_load --to_date('31.10.2016','dd.mm.yyyy')
   ;
   commit;            
   
   insert /*+ append*/ into T_ODWH_Z#PAY_DOK
   select * from T_ODWH_Z#PAY_DOK_PRE;
   /*select *
     from ibs.Z#PAY_DOK@dwh_old
    where c_opdate > d_max_pay_dok
      and c_opdate <=  d_date_load;*/
   commit;
  
end ETLT_ODWH_Z#PAY_DOK;
/

