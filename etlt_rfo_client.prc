create or replace procedure u1.ETLT_RFO_CLIENT is
   s_mview_name     varchar2(30) := 'T_RFO_Z#CLIENT';
   vStrDate         date := sysdate;
   d_date_start_ins date; --дата логирования инсерта

   d_src_commit_date_last date; --дата последней загруженной строки
   d_src_commit_date_load date; --дата, по которую делаем загрузку

  begin
    --дата необходима для логирования времени инсерта
    d_date_start_ins := sysdate;
    select max(src_commit_date)-5/24/60/60
      into d_src_commit_date_load
      from s01.s$Z#CLIENT@rdwh_exd;
    select last_date
      into d_src_commit_date_last
      from t_rdwh_increment_tables_load
     where object_name = 'T_RFO_Z#CLIENT';
    --
    delete from T_RFO_Z#CLIENT
     where id in (select distinct id
                    from s01.s$Z#CLIENT@rdwh_exd
                   where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
    insert into T_RFO_Z#CLIENT
    select t.*,
           case when sysdate > to_date('2013-01-03','yyyy-mm-dd')
                then c_inn else c_kas_rnn end as x_iin,
           case when sysdate > to_date('2013-01-03','yyyy-mm-dd')
                then c_kas_rnn else c_inn end as x_rnn
      from s01.Z#CLIENT@rdwh_exd t
     where id in (select distinct id
                    from s01.s$Z#CLIENT@rdwh_exd
                   where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
    commit;
    --сохраняем информацию о послeдней загрузке
    update t_rdwh_increment_tables_load
       set last_date = d_src_commit_date_load
     where object_name = 'T_RFO_Z#CLIENT';
    commit;

   end ETLT_RFO_CLIENT;
/

