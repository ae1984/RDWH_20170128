﻿create or replace procedure u1.ETLT_RFO_KAS_ONLINE_CLAIM
  is
   s_mview_name     varchar2(30) := 'T_RFO_Z#KAS_ONLINE_CLAIM';
   vStrDate         date := sysdate;
   d_date_start_ins date; --дата логирования инсерта

   d_src_commit_date_last date; --дата последней загруженной строки
   d_src_commit_date_load date; --дата, по которую делаем загрузку

  begin
    --дата необходима для логирования времени инсерта
    d_date_start_ins := sysdate;
    select max(src_commit_date)-5/24/60/60
      into d_src_commit_date_load
      from s01.s$Z#KAS_ONLINE_CLAIM@rdwh_exd;

    select last_date
      into d_src_commit_date_last
      from t_rdwh_increment_tables_load
     where object_name = 'T_RFO_Z#KAS_ONLINE_CLAIM';
    --
    delete from T_RFO_Z#KAS_ONLINE_CLAIM
     where id in (select  id
                    from s01.s$Z#KAS_ONLINE_CLAIM@rdwh_exd
                   where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
    insert into T_RFO_Z#KAS_ONLINE_CLAIM
    select t.*
      from s01.Z#KAS_ONLINE_CLAIM@rdwh_exd t
     where id in (select  id
                    from s01.s$Z#KAS_ONLINE_CLAIM@rdwh_exd
                   where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
    commit;
    --сохраняем информацию о послeдней загрузке
    update t_rdwh_increment_tables_load
       set last_date = d_src_commit_date_load
     where object_name = 'T_RFO_Z#KAS_ONLINE_CLAIM';
    commit;

   end ETLT_RFO_KAS_ONLINE_CLAIM;
 --
/

