create or replace procedure u1.ETLT_GBQ_DEVICE
is
   s_mview_name     varchar2(30) := 'T_GBQ_DEVICE';
   n_max_id number;
begin
             select nvl(max(id),0)
             into n_max_id
             from T_GBQ_DEVICE; 
           
             insert into T_GBQ_DEVICE
             select 
                ID
                ,HIT_ID
                ,IP
                ,USER_AGENT
                ,FLASH_VERSION
                ,JAVA_ENABLED
                ,LANGUAGE
                ,SCREEN_COLORS
                ,SCREEN_RESOLUTION
                ,IDATE
             
             from GBQ.GBQ_DEVICE@KSVISIT
             where id > n_max_id;
             commit;

end ETLT_GBQ_DEVICE;
/

