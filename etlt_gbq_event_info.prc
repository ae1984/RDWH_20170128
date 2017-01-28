create or replace procedure u1.ETLT_GBQ_EVENT_INFO
is
   s_mview_name     varchar2(30) := 'T_GBQ_EVENT_INFO';
   n_max_id number;
begin
             select nvl(max(id),0)
             into n_max_id
             from T_GBQ_EVENT_INFO; 
           
             insert into T_GBQ_EVENT_INFO
             select *
             from GBQ.GBQ_EVENT_INFO@KSVISIT
             where id > n_max_id;
             commit;

end ETLT_GBQ_EVENT_INFO;
/

