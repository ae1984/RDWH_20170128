create or replace procedure u1.ETLT_GBQ
is
   s_mview_name     varchar2(30) := 'T_GBQ';
   n_max_id number;
begin
             select nvl(max(id),0)
             into n_max_id
             from T_GBQ;            
             
             insert into T_GBQ
              select id,
                    hit_id,
                    user_id,
                    user_phone,
                    user_email,
                    client_id,
                    tracking_id,
                    hit_date,
                    hit_hour,
                    hit_minute,
                    hit_time,
                    queue_time,
                    is_secure,
                    is_interaction,
                    currency,
                    cast (referer as varchar2(4000)),
                    data_source,
                    hit_type,
                    idate
             from GBQ.GBQ@KSVISIT
             where id > n_max_id;
             commit;

end ETLT_GBQ;
/

