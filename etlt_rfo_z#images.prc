create or replace procedure u1.ETLT_RFO_Z#IMAGES
   is
       s_mview_name     varchar2(30) := 'T_RFO_Z#IMAGES';
       vStrDate         date := sysdate;

       d_src_commit_date_last date; --дата последней загруженной строки
       d_src_commit_date_load date; --дата, по которую делаем загрузку

      begin

        select max(src_commit_date)
          into d_src_commit_date_load
          from s01.s$Z#IMAGES@rdwh_exd;

        select last_date-10/24/60/60
          into d_src_commit_date_last
          from T_RDWH_INCREMENT_TABLES_LOAD
         where object_name = s_mview_name;
        --

        delete from T_RFO_Z#IMAGES
         where id in (select distinct id
                        from s01.s$Z#IMAGES@rdwh_exd
                       where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);

        insert /*+ append */into T_RFO_Z#IMAGES(id, collection_id, c_name, c_date, c_fold_id, c_uid, c_load_date)
        select id, collection_id, c_name, c_date, c_fold_id, c_uid, c_load_date
          from s01.Z#IMAGES@rdwh_exd
         where id in (select distinct id
                        from s01.s$Z#IMAGES@rdwh_exd
                       where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
        commit;
        --сохраняем информацию о послeдней загрузке
        update T_RDWH_INCREMENT_TABLES_LOAD
           set last_date = d_src_commit_date_load
         where object_name =s_mview_name;
        commit;

end ETLT_RFO_Z#IMAGES;
/

