create or replace procedure u1.ETLT_GBQ_TRAFFIC
is
   s_mview_name     varchar2(30) := 'T_GBQ_TRAFFIC';
   n_max_id number;
begin
             select nvl(max(id),0)
             into n_max_id
             from T_GBQ_TRAFFIC; 
           
             insert into T_GBQ_TRAFFIC
             select id,
                    hit_id,
                    cast(referral_path as varchar2(4000)) as referral_path,
                    campaign,
                    source,
                    medium,
                    keyword,
                    ad_content,
                    campaign_id,
                    gcl_id,
                    dcl_id,
                    idate             
             from GBQ.GBQ_TRAFFIC@KSVISIT
             where id > n_max_id;
             commit;

end ETLT_GBQ_TRAFFIC;
/

