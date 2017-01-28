create or replace procedure u1.ETLT_RFO_KAS_GCVP_REPORT
  is
   s_mview_name     varchar2(30) := 'T_RFO_Z#KAS_GCVP_REPORT';
   vStrDate         date := sysdate;
   d_date_start_ins date; --дата логирования инсерта

   d_src_commit_date_last date; --дата последней загруженной строки
   d_src_commit_date_load date; --дата, по которую делаем загрузку

  begin
    --дата необходима для логирования времени инсерта
    d_date_start_ins := sysdate;
    select max(src_commit_date)-5/24/60/60
      into d_src_commit_date_load
      from s01.s$Z#KAS_GCVP_REPORT@rdwh_exd;

    select last_date
      into d_src_commit_date_last
      from t_rdwh_increment_tables_load
     where object_name = 'T_RFO_Z#KAS_GCVP_REPORT';
    --
    delete from T_RFO_Z#KAS_GCVP_REPORT
     where id in (select distinct id
                    from s01.s$Z#KAS_GCVP_REPORT@rdwh_exd
                   where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
    insert into T_RFO_Z#KAS_GCVP_REPORT
    select t.*,
          case when t.c_statement_date < to_date('2013-01-03','yyyy-mm-dd') then t.c_rnn else null end as x_client_rnn,
          case when t.c_statement_date < to_date('2013-01-03','yyyy-mm-dd') then t.c_iin else c_rnn end as  x_client_iin
      from s01.Z#KAS_GCVP_REPORT@rdwh_exd t
     where id in (select distinct id
                    from s01.s$Z#KAS_GCVP_REPORT@rdwh_exd
                   where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
    commit;
    --сохраняем информацию о послeдней загрузке
    update t_rdwh_increment_tables_load
       set last_date = d_src_commit_date_load
     where object_name = 'T_RFO_Z#KAS_GCVP_REPORT';
    commit;

  end ETLT_RFO_KAS_GCVP_REPORT;
 --
/

