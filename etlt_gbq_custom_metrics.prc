create or replace procedure u1.ETLT_GBQ_CUSTOM_METRICS
is
   s_mview_name     varchar2(30) := 'T_GBQ_CUSTOM_METRICS';
   n_max_id number;
begin
             select nvl(max(id),0)
             into n_max_id
             from T_GBQ_CUSTOM_METRICS; 
           
             insert into T_GBQ_CUSTOM_METRICS
             select 
                ID
                ,HIT_ID
                ,METRIC_INDEX
                ,METRIC_VALUE
                ,IDATE
             
             from GBQ.GBQ_CUSTOM_METRICS@KSVISIT
             where id > n_max_id;
             commit;

end ETLT_GBQ_CUSTOM_METRICS;
/

