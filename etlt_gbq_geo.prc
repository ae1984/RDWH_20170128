create or replace procedure u1.ETLT_GBQ_GEO
is
   s_mview_name     varchar2(30) := 'T_GBQ_GEO';
   n_max_id number;
begin
             select nvl(max(id),0)
             into n_max_id
             from T_GBQ_GEO; 
           
             insert into T_GBQ_GEO
             select *
             from GBQ.GBQ_GEO@KSVISIT
             where id > n_max_id;
             commit;

end ETLT_GBQ_GEO;
/

