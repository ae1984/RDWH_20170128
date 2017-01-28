create or replace procedure u1.ETLT_IBSO_Z#MAIN_DOCUM is
       s_mview_name     varchar2(30) := 'T_IBSO_Z#MAIN_DOCUM';
       vStrDate         date := sysdate;

       d_src_commit_date_last date; --дата последней загруженной строки
       d_src_commit_date_load date; --дата, по которую делаем загрузку
       d_date_start_ins date;
      begin
          d_date_start_ins := sysdate;
          select max(src_commit_date)
            into d_src_commit_date_load
            from s06.s$Z#MAIN_DOCUM@rdwh_exd;
          select last_date
            into d_src_commit_date_last
            from t_rdwh_increment_tables_load
           where object_name = 'T_IBSO_Z#MAIN_DOCUM';
          --
          delete from T_IBSO_Z#MAIN_DOCUM
           where id in (select distinct id
                          from s06.s$Z#MAIN_DOCUM@rdwh_exd
                         where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
          insert into T_IBSO_Z#MAIN_DOCUM
          select *
            from s06.Z#MAIN_DOCUM@rdwh_exd
           where id in (select distinct id
                          from s06.s$Z#MAIN_DOCUM@rdwh_exd
                         where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
          commit;
          --сохраняем информацию о послденей загрузке
          update t_rdwh_increment_tables_load
             set last_date = d_src_commit_date_load
           where object_name = 'T_IBSO_Z#MAIN_DOCUM';
          commit;



       end ETLT_IBSO_Z#MAIN_DOCUM;
/

