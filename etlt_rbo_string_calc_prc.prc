create or replace procedure u1.ETLT_RBO_STRING_CALC_PRC is
   s_mview_name     varchar2(30) := 'T_RBO_Z#STRING_CALC_PRC';
   vStrDate         date := sysdate;
   d_date_start_ins date; --дата логирования инсерта

   d_src_commit_date_last date; --дата последней загруженной строки
   d_src_commit_date_load date; --дата, по которую делаем загрузку

  begin
    --дата необходима для логирования времени инсерта
    dbms_output.put_line('dd '||to_char(sysdate,'dd-mm-yyyy hh24:mi:ss'));

    d_date_start_ins := sysdate;
    select max(src_commit_date)-5/24/60/60
      into d_src_commit_date_load
      from s02.s$Z#STRING_CALC_PRC@rdwh_exd;
    select last_date
      into d_src_commit_date_last
      from t_rdwh_increment_tables_load
     where object_name = 'T_RBO_Z#STRING_CALC_PRC';
    --
    delete /*+ append parallel(10) */  from T_RBO_Z#STRING_CALC_PRC
     where id in (select  id
                    from s02.s$Z#STRING_CALC_PRC@rdwh_exd
                   where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
    commit;

    insert /*+ append parallel(10) */ into T_RBO_Z#STRING_CALC_PRC
    select t.*
      from s02.Z#STRING_CALC_PRC@rdwh_exd t
     where id in (select  id
                    from s02.s$Z#STRING_CALC_PRC@rdwh_exd
                   where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
    commit;
    dbms_output.put_line('dd4 '||to_char(sysdate,'dd-mm-yyyy hh24:mi:ss'));
    --сохраняем информацию о послeдней загрузке
    update t_rdwh_increment_tables_load
       set last_date = d_src_commit_date_load
     where object_name = 'T_RBO_Z#STRING_CALC_PRC';
    commit;

   end ETLT_RBO_STRING_CALC_PRC;
 --
/

