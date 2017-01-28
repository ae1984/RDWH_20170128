create or replace procedure u1.ETLT_GBQ_ECOMMERCE_ACTION
is
   s_mview_name     varchar2(30) := 'T_GBQ_ECOMMERCE_ACTION';
   n_max_id number;
begin
             select nvl(max(id),0)
             into n_max_id
             from T_GBQ_ECOMMERCE_ACTION; 
           
             insert into T_GBQ_ECOMMERCE_ACTION
             select *
             from GBQ.GBQ_ECOMMERCE_ACTION@KSVISIT
             where id > n_max_id;
             commit;
end ETLT_GBQ_ECOMMERCE_ACTION;
/

