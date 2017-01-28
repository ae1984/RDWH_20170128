create or replace procedure u1.ETLT_RBO_Z#KAS_PLAN_EPS
   is
       s_mview_name     varchar2(30) := 'T_RBO_Z#KAS_PLAN_EPS';
       vStrDate         date := sysdate;

       d_src_commit_date_last date; --дата последней загруженной строки
       d_src_commit_date_load date; --дата, по которую делаем загрузку

      begin
        select max(src_commit_date)
          into d_src_commit_date_load
          from s02.s$Z#KAS_PLAN_EPS@rdwh_exd;

        select last_date-10/24/60/60
          into d_src_commit_date_last
          from t_rdwh_increment_tables_load
         where object_name = s_mview_name;
        --
        delete from T_RBO_Z#KAS_PLAN_EPS
         where id in (select distinct id
                        from s02.s$Z#KAS_PLAN_EPS@rdwh_exd
                       where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
        insert /*+ append */into T_RBO_Z#KAS_PLAN_EPS
        select *
          from s02.Z#KAS_PLAN_EPS@rdwh_exd
         where id in (select distinct id
                        from s02.s$Z#KAS_PLAN_EPS@rdwh_exd
                       where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
        commit;
        --сохраняем информацию о послeдней загрузке
        update T_RDWH_INCREMENT_TABLES_LOAD
           set last_date = d_src_commit_date_load
         where object_name =s_mview_name;
        commit;

end ETLT_RBO_Z#KAS_PLAN_EPS;
/

