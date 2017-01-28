create or replace procedure u1.ETLT_RBO_Z#KAS_PC_SLIPS is
       s_mview_name     varchar2(30) := 'T_RBO_Z#KAS_PC_SLIPS';
       vStrDate         date := sysdate;
       n_cnt number;
       d_src_commit_date_last date; --дата последней загруженной строки
       d_src_commit_date_load date; --дата, по которую делаем загрузку

      begin
        select max(src_commit_date)
          into d_src_commit_date_load
          from s02.s$Z#KAS_PC_SLIPS@rdwh_exd;
          dbms_output.put_line('d_src_commit_date_load-'||to_char(d_src_commit_date_load,'dd-mm-yyyy hh24:mi:ss'));

        select last_date-10/24/60/60
          into d_src_commit_date_last
          from t_rdwh_increment_tables_load
         where object_name = s_mview_name;
          dbms_output.put_line('d_src_commit_date_last-'||to_char(d_src_commit_date_last,'dd-mm-yyyy hh24:mi:ss'));
        --
        delete from T_RBO_Z#KAS_PC_SLIPS
         where id in (select distinct id
                        from s02.s$Z#KAS_PC_SLIPS@rdwh_exd
                       where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
        select count(1)
                    into n_cnt
                    from T_RBO_Z#KAS_PC_SLIPS   ;

        dbms_output.put_line('nnn='||n_cnt);

        insert /*+ append */into T_RBO_Z#KAS_PC_SLIPS
        select *
          from s02.Z#KAS_PC_SLIPS@rdwh_exd
         where id in (select distinct id
                        from s02.s$Z#KAS_PC_SLIPS@rdwh_exd
                       where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
        commit;
        dbms_output.put_line('ins');
        --сохраняем информацию о послeдней загрузке
        update T_RDWH_INCREMENT_TABLES_LOAD
           set last_date = d_src_commit_date_load
         where object_name = s_mview_name;
        commit;

end ETLT_RBO_Z#KAS_PC_SLIPS;
/

