create or replace procedure u1.ETLT_RFO_Z#PACK_DOC is
       s_mview_name     varchar2(30) := 'T_RFO_Z#PACK_DOC';
       vStrDate         date := sysdate;

       d_src_commit_date_last date; --дата последней загруженной строки
       d_src_commit_date_load date; --дата, по которую делаем загрузку

      begin
        select max(src_commit_date)
          into d_src_commit_date_load
          from s01.s$Z#PACK_DOC@rdwh_exd;

        select last_date-10/24/60/60
          into d_src_commit_date_last
          from t_rdwh_increment_tables_load
         where object_name = 'T_RFO_Z#PACK_DOC';
        --
        delete from T_RFO_Z#PACK_DOC
         where id in (select distinct id
                        from s01.s$Z#PACK_DOC@rdwh_exd
                       where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
        insert into T_RFO_Z#PACK_DOC
        select
             id, c_doc_group, c_doc_type, c_present, c_images
             , upper(c_note) as c_note, c_need_image, c_reclaimed, c_accepted
             , c_phase, c_to_recl, collection_id, c_type_recl, sn, su
             , c_kas_recl_his_arr
        from s01.Z#PACK_DOC@rdwh_exd
        where id in (select distinct id
                        from s01.s$Z#PACK_DOC@rdwh_exd
                       where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
        commit;
        --сохраняем информацию о послeдней загрузке
        update t_rdwh_increment_tables_load
           set last_date = d_src_commit_date_load
         where object_name = 'T_RFO_Z#PACK_DOC';
        commit;


       end ETLT_RFO_Z#PACK_DOC;
/

