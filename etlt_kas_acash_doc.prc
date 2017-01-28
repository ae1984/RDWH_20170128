create or replace procedure u1.ETLT_KAS_ACASH_DOC is
       s_mview_name     varchar2(30) := 'T_RBO_Z#KAS_ACASH_DOC';
       vStrDate         date := sysdate;
       d_date_start_ins date; --дата логирования инсерта

       d_src_commit_date_last date; --дата последней загруженной строки
       d_src_commit_date_load date; --дата, по которую делаем загрузку

      begin
        --дата необходима для логирования времени инсерта
        d_date_start_ins := sysdate;
        select max(src_commit_date)
          into d_src_commit_date_load
          from s02.s$Z#KAS_ACASH_DOC@rdwh_exd;
        select last_date
          into d_src_commit_date_last
          from t_rdwh_increment_tables_load
         where object_name = 'T_RBO_Z#KAS_ACASH_DOC';
        --
        delete from T_RBO_Z#KAS_ACASH_DOC
         where id in (select distinct id
                        from s02.s$Z#KAS_ACASH_DOC@rdwh_exd
                       where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
        insert into T_RBO_Z#KAS_ACASH_DOC
        select *
          from s02.Z#KAS_ACASH_DOC@rdwh_exd
         where id in (select distinct id
                        from s02.s$Z#KAS_ACASH_DOC@rdwh_exd
                       where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
        commit;
        --сохраняем информацию о послeдней загрузке
        update t_rdwh_increment_tables_load
           set last_date = d_src_commit_date_load
         where object_name = 'T_RBO_Z#KAS_ACASH_DOC';
        commit;
end ETLT_KAS_ACASH_DOC;
/

