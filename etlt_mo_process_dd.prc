create or replace procedure u1.ETLT_MO_PROCESS_DD is
   v_max_date timestamp;
begin
   v_max_date := null;
   select /*+ parallel(10) */ max(t.date_start) into v_max_date 
     from T_MO_PROCESS_DD t;
       
   insert /*+ APPEND */ into T_MO_PROCESS_DD 
   select * from PROCESS@MO1_PROD t where t.date_start > v_max_date;
   commit;  
end ETLT_MO_PROCESS_DD;
/

