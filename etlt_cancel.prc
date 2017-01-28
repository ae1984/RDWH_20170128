CREATE OR REPLACE PROCEDURE U1.ETLT_CANCEL is
      s_mview_name varchar2(30) := 'T_CANCEL';
      vLast_load_date date;
      vStrDate date := sysdate;
    begin
      --Дата последней загрузки
      select last_date
        into vLast_load_date
        from t_rdwh_increment_tables_load tl
       where tl.object_name = s_mview_name;

      --Собираем данные на удаление
      delete from T_CANCEL_GT;

      insert into T_CANCEL_GT
      (select /*+ driving_site*/
              distinct id
         from ( select fc.id
                  from s01.s$Z#KAS_CANCEL@rdwh_exd fc
                 where fc.src_commit_date >= vLast_load_date
                       and fc.src_commit_date < trunc(sysdate)
                union all
                select kc.id
                  from s01.s$Z#folders@rdwh_exd f
                  join s01.Z#KAS_CANCEL@rdwh_exd kc on kc.c_folders = f.id

                 where f.src_commit_date >= vLast_load_date
                       and f.src_commit_date < trunc(sysdate)));

      insert into t_cancel_gt
      (select /*+ driving_site*/
             distinct id
        from s01.s$Z#KAS_CANCEL@rdwh_exd kc
       where kc.src_commit_date >= vLast_load_date
         and kc.src_commit_date < trunc(sysdate));


      insert into t_cancel_gt
      (select /*+ driving_site*/
              distinct id
        from (select fc.id
                from s01.s$Z#FORM_CLIENT@rdwh_exd fc
               where fc.src_commit_date >= vLast_load_date
                     and fc.src_commit_date < trunc(sysdate)
               union all
              select rfd.form_client_id
                from s01.s$Z#folders@rdwh_exd f
                join s01.z#folders@rdwh_exd fl on fl.id = f.id

                join (select rd.collection_id, fd.id as form_client_id
                        from s01.Z#RDOC@rdwh_exd rd
                        join s01.Z#FDOC@rdwh_exd fd on fd.id = rd.c_doc and fd.class_id = 'FORM_CLIENT') rfd
                   on rfd.collection_id = fl.c_docs

               where f.src_commit_date >= vLast_load_date
                     and f.src_commit_date < trunc(sysdate)));
      --Удаляем
      delete /*+ append enable_parallel_dml parallel(20)*/
      from T_CANCEL tt
      where tt.cancel_id in (select /*+ parallel(5) */ distinct cancel_id from T_CANCEL_GT);

      commit;

      --Вставляем
      insert /*+ append enable_parallel_dml parallel(20)*/
        into t_cancel
      (select /*+ parallel(5) */ * from V_CANCEL_CHN);
      commit;

      update t_rdwh_increment_tables_load
         set last_date = trunc(sysdate)
        where object_name = s_mview_name;

      commit;


      end ETLT_CANCEL;
/

