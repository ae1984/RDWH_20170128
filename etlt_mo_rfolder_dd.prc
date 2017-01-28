create or replace procedure u1.ETLT_MO_RFOLDER_DD is
  v_max_date timestamp;
begin
   v_max_date := null;
   select /*+ parallel(10) */ max(t.date_create) into v_max_date 
   from T_MO_RFOLDER_DD t
   where t.date_create >= trunc(sysdate) - 1;
   
   if v_max_date is null then 
     v_max_date := trunc(sysdate) - 1; 
   end if;
           
   insert /*+ APPEND */ into T_MO_RFOLDER_DD 
   select * from RFOLDER@MO1_PROD t where t.date_create > v_max_date;
   commit;  
end ETLT_MO_RFOLDER_DD;
/

