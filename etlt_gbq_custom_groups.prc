create or replace procedure u1.ETLT_GBQ_CUSTOM_GROUPS
is
   s_mview_name     varchar2(30) := 'T_GBQ_CUSTOM_GROUPS';
   n_max_id number;
begin
             select nvl(max(id),0)
             into n_max_id
             from T_GBQ_CUSTOM_GROUPS; 
           
             insert into T_GBQ_CUSTOM_GROUPS
             select *
             from GBQ.GBQ_CUSTOM_GROUPS@KSVISIT
             where id > n_max_id;
             commit;

end ETLT_GBQ_CUSTOM_GROUPS;
/

