create or replace procedure u1.ETLT_RFO_KIND_ZAL_BODY is
s_mview_name     varchar2(30) := 'T_RFO_Z#KIND_ZAL_BODY';
   vStrDate         date := sysdate;
   d_date_start_ins date; --дата логирования инсерта

   d_src_commit_date_last date; --дата последней загруженной строки
   d_src_commit_date_load date; --дата, по которую делаем загрузку


   begin
          --дата необходима для логирования времени инсерта
      d_date_start_ins := sysdate;
      select max(src_commit_date)-5/24/60/60
      into d_src_commit_date_load
      from s01.s$Z#KIND_ZAL_BODY@rdwh_exd;
   select last_date
      into d_src_commit_date_last
      from t_rdwh_increment_tables_load
     where object_name = 'T_RFO_Z#KIND_ZAL_BODY';

     delete from T_RFO_Z#KIND_ZAL_BODY
     where id in (select distinct id
                    from s01.s$Z#KIND_ZAL_BODY@rdwh_exd
                   where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
    insert into T_RFO_Z#KIND_ZAL_BODY
    select t.*
      from s01.Z#KIND_ZAL_BODY@rdwh_exd t
     where id in (select distinct id
                    from s01.s$Z#KIND_ZAL_BODY@rdwh_exd
                   where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
    commit;
    --сохраняем информацию о послeдней загрузке
    update t_rdwh_increment_tables_load
       set last_date = d_src_commit_date_load
     where object_name = 'T_RFO_Z#KIND_ZAL_BODY';
    commit;
 end ETLT_RFO_KIND_ZAL_BODY;
/

