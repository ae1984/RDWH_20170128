create or replace procedure u1.ETLT_CONTRACT_DEPN_OPER_ALL is
      s_mview_name           varchar2(30) := 'T_CONTRACT_DEPN_OPER_ALL';
      vStrDate               date := sysdate;
      d_date_start_ins       date;
      n_fact_oper_id_max     number;
      ts_src_commit_date_max timestamp;
      ts_fact_oper_id_max    timestamp;
    begin
      --дата необходима для логирования времени инсерта
      d_date_start_ins := sysdate;
      --определяем последний загруженный id
      select max(fact_oper_id)
        into n_fact_oper_id_max
        from T_CONTRACT_DEPN_OPER_ALL;
      --определяем время просадки данной записи
      select src_commit_date
        into ts_fact_oper_id_max
        from s02.s$z#fact_oper@rdwh_exd
       where id = n_fact_oper_id_max
         and row_status = 'I';
      --определяем время , по которое будем грузить
      select max(src_commit_date)
        into ts_src_commit_date_max
        from s02.s$z#fact_oper@rdwh_exd;
      --чистим временную таблицу и загружаем в нее данные по измененным id
      execute immediate 'truncate table T_CONTRACT_DEPN_OPER_ALL_GT';
      insert into T_CONTRACT_DEPN_OPER_ALL_GT
      select id, row_status
        from s02.s$z#fact_oper@rdwh_exd
        where src_commit_date >= ts_fact_oper_id_max
          and src_commit_date <  ts_src_commit_date_max;
      commit;
      --удаленные данных из таблицы
      delete /*+ append enable_parallel_dml parallel(20)*/
        from T_CONTRACT_DEPN_OPER_ALL
       where fact_oper_id in (select  fact_oper_id
                                from t_contract_depn_oper_all_gt);
      commit;
      insert /*+ append enable_parallel_dml parallel(20)*/ into T_CONTRACT_DEPN_OPER_ALL
      select  /*+ index(fo T_RBO_Z#FACT_OPER_IND2) parallel(20)*/
             dp.c_client      as rbo_client_id,
             dp.id            as rbo_contract_id,
             dp.c_num_dog     as contract_number,
             ft.id            as contract_currency_id,
             ft.c_cur_short   as contract_currency,
             vdd.c_name       as product_name,
             vdd.c_has_timeout as is_has_timeout,
             vod.c_code       as oper_dog_code,
             vod.sys_name     as oper_dog_name,
             td.c_dt          as is_dt_ct,
             fo.c_summa       as ammount_oper,
             fo.c_kas_date_prov  as date_doc_prov,
             fo.c_doc           as main_docum_id,
             fo.id              as fact_oper_id,
             fo.c_is_storno as is_storno ,
             fo.c_reverse_fo as reverse_fo_id
        from u1.T_RBO_Z#FACT_OPER fo
        join u1.V_RBO_Z#VID_OPER_DOG vod on vod.id = fo.c_oper
        join u1.V_RBO_Z#DEPN          dp on dp.c_list_pay = fo.collection_id
        join u1.V_RBO_Z#VID_DEPOSIT  vdd on vdd.id = dp.c_vid_dog
        join u1.V_RBO_Z#TAKE_IN_DEBT  td on td.collection_id = vod.c_take_debt
        join u1.V_RBO_Z#VID_DEBT      vd on vd.id = td.c_debt
        left join V_RBO_Z#FT_MONEY    ft on ft.id = dp.c_fintool
       where vd.c_code = 'ОСТ_ВКЛАД'
         and fo.c_kas_doc_state = 'PROV'
         and exists
         (select 1 from T_CONTRACT_DEPN_OPER_ALL_GT gt
           where gt.fact_oper_id = fo.id);
      commit;
    --вставка измененных данных

    --логирование
    --pkg_object_update_util.log_upd(s_mview_name, vStrDate, 'OK');

    end ETLT_CONTRACT_DEPN_OPER_ALL;
/

