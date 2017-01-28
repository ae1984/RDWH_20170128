create or replace procedure u1.ETLT_KAS_EDIT_OBJ_TMP is
    s_mview_name varchar2(30) := 'T_RBO_Z#KAS_EDIT_OBJ_TMP';
    vStrDate date := sysdate;
    n_max_id_cred number(20);
    d_max_date_cred date;
    d_max_date_cred_st timestamp;
    d_kas_date_prov_cred date;
    d_date_load          date := trunc(sysdate); --обязательное для заполнения
    n_max_id_cred_load number(20);
    d_max_date_cred_load date;
    d_max_date_cred_load_st timestamp;
    n_max_id_card        number(20); --последний загруженный id проводки
    d_max_date_card      date;       --системная дата создания проводки n_max_id_card
    d_max_date_card_st   timestamp;
    d_kas_date_prov_card date;       --последняя дата одобрения проводки
    n_max_id_card_load   number(20);                                 --до какого id грузить
    d_max_date_card_load date;                                       --системная дата создания проводки n_max_id_card_load
    d_max_date_card_load_st timestamp;

  begin

    --LOAD_RBO_P4
    select max(fo.id)
      into n_max_id_cred
      from t_rbo_z#fact_oper fo;

    select max(c_kas_date_prov)
      into d_kas_date_prov_cred
      from t_rbo_z#fact_oper fo;

    --таблица, в которую заносим данные об изменениях в уже загруженные проводки
    --определяем максимальную дату, по которой уже делали анализ

    select cast(src_commit_date as date), src_commit_date
      into d_max_date_cred, d_max_date_cred_st
      from s02.s$z#fact_oper@rdwh_exd
     where id =  n_max_id_cred
       and row_status = 'I';

    if  trunc(d_max_date_cred) = trunc(sysdate) or to_number(to_char(d_max_date_cred,'hh24mi')) < 0900 then
        d_kas_date_prov_cred := d_kas_date_prov_cred - 1;
    end if;
     --
     --поседний id который будем грузить
     --необходимо для того, что если загрузка стартанет днем, то на следующий день
     --будет много договоров для редактирования


    select max(id)
      into n_max_id_cred_load
      from s02.s$z#fact_oper@rdwh_exd
     where src_commit_date >= to_timestamp(to_char(d_date_load,'dd-mm-yyyy')||'00:01:00.000','DD-MM-YYYY HH24:MI:SS.FF')
       and src_commit_date <= to_timestamp(to_char(d_date_load,'dd-mm-yyyy')||'04:00:00.000','DD-MM-YYYY HH24:MI:SS.FF')
       and row_status = 'I';

     --дата, позже которой не надо анализировать
    if n_max_id_cred_load is not null then
        select cast(src_commit_date as date), src_commit_date
          into d_max_date_cred_load, d_max_date_cred_load_st
          from s02.s$z#fact_oper@rdwh_exd
         where id = n_max_id_cred_load
           and row_status = 'I';
    else
      d_max_date_cred_load := null;
    end if;
     --во временную таблицу заносим данные, по которым было изменение(update or delete)
     --по уже загруженным ID - update and delete
     --только удаленные
     /*for rec in (select 'FACT_OPER' as c_class_object,
                        trunc(cast(src_commit_date as date))  as c_date_edit,
                        sfo.id as c_id_object,
                        'DELETE' as c_str,
                        cast(sfo.src_commit_date as date) as c_sys_date,
                        (select collection_id from t_rbo_z#fact_oper where id = sfo.id) as c_id_collection,
                        0 as c_status
                   from s02.s$z#fact_oper@rdwh_exd sfo
                  where sfo.src_commit_date >= d_max_date_cred_st
                    and sfo.src_commit_date <= d_max_date_cred_load_st
                    and sfo.id <=  n_max_id_cred
                    and sfo.row_status = 'D'
       )
     loop
        insert into T_RBO_Z#KAS_EDIT_OBJ_TMP(C_CLASS_OBJECT,C_DATE_EDIT,C_ID_OBJECT,C_STR,C_SYS_DATE,C_ID_COLLECTION,C_STATUS)
        values (rec.c_class_object,rec.c_date_edit,rec.c_id_object,rec.c_str, rec.c_sys_date, rec.c_id_collection,rec.c_status);
        
     end loop;
     commit;*/
      insert into T_RBO_Z#KAS_EDIT_OBJ_TMP(C_CLASS_OBJECT,C_DATE_EDIT,C_ID_OBJECT,C_STR,C_SYS_DATE,C_ID_COLLECTION,C_STATUS)
      select /*+parallel(10)*/ 'FACT_OPER' as c_class_object,
                              trunc(cast(src_commit_date as date))  as c_date_edit,
                              sfo.id as c_id_object,
                              'DELETE' as c_str,
                              cast(sfo.src_commit_date as date) as c_sys_date,
                              (select collection_id from t_rbo_z#fact_oper where id = sfo.id) as c_id_collection,
                              0 as c_status
                         from s02.s$z#fact_oper@rdwh_exd sfo
                        where sfo.src_commit_date >= d_max_date_cred_st
                          and sfo.src_commit_date <= d_max_date_cred_load_st
                          and sfo.id <=  n_max_id_cred
                          and sfo.row_status = 'D';
     commit;                     
     
     --только отредактированные
     /*for rec in (select 'FACT_OPER' as c_class_object,
                        trunc(coalesce(fx.c_kas_date_prov,fx.c_date,d_date_load))  as c_date_edit,
                        fx.id as c_id_object,
                        'UPDATE' as c_str,
                        coalesce(fx.c_kas_date_prov,fx.c_date,d_date_load) as c_sys_date,
                        fx.collection_id  as c_id_collection,
                        0 as c_status
                   from s02.z#fact_oper@rdwh_exd fx
                  where fx.id in (select id
                                    from s02.s$z#fact_oper@rdwh_exd
                                   where src_commit_date >= d_max_date_cred_st
                                     and src_commit_date <= d_max_date_cred_load_st
                                     and id <=  n_max_id_cred
                                     and row_status = 'U')
                   and not exists
                   (select 1 from t_rbo_z#fact_oper fo
                     where fo.id = fx.id
                       and nvl(fo.c_date,to_date('01-01-1900','dd-mm-yyyy')) = nvl(fx.c_date,to_date('01-01-1900','dd-mm-yyyy'))
                       and nvl(fo.c_summa,0) = nvl(fx.c_summa,0)
                       and nvl(fo.c_valuta,0) = nvl(fx.c_valuta,0)
                       and nvl(fo.c_doc,0) = nvl(fx.c_doc,0)
                       and nvl(fo.c_is_storno,0) = nvl(fx.c_is_storno,0)
                       and nvl(fo.c_reverse_fo,0) = nvl(fx.c_reverse_fo,0)
                       and nvl(fo.c_kas_date_prov,to_date('01-01-1900','dd-mm-yyyy')) = nvl(fx.c_kas_date_prov,to_date('01-01-1900','dd-mm-yyyy'))
                       and nvl(fo.c_kas_doc_state,'*') = nvl(fx.c_kas_doc_state,'*')
                       and nvl(fo.collection_id,0) = nvl(fx.collection_id,0)
                       and nvl(fo.c_oper,0) = nvl(fx.c_oper,0))
                        )
     loop
       insert into T_RBO_Z#KAS_EDIT_OBJ_TMP(C_CLASS_OBJECT,C_DATE_EDIT,C_ID_OBJECT,C_STR,C_SYS_DATE,C_ID_COLLECTION,C_STATUS)
       values (rec.c_class_object,rec.c_date_edit,rec.c_id_object,rec.c_str, rec.c_sys_date, rec.c_id_collection,rec.c_status);
       
     end loop;
     commit;*/
     
     insert into T_RBO_Z#KAS_EDIT_OBJ_TMP(C_CLASS_OBJECT,C_DATE_EDIT,C_ID_OBJECT,C_STR,C_SYS_DATE,C_ID_COLLECTION,C_STATUS)
      select /*+parallel(10)*/ 'FACT_OPER' as c_class_object,
                              trunc(coalesce(fx.c_kas_date_prov,fx.c_date,d_date_load))  as c_date_edit,
                              fx.id as c_id_object,
                              'UPDATE' as c_str,
                              coalesce(fx.c_kas_date_prov,fx.c_date,d_date_load) as c_sys_date,
                              fx.collection_id  as c_id_collection,
                              0 as c_status
                         from s02.z#fact_oper@rdwh_exd fx
                        where fx.id in (select id
                                          from s02.s$z#fact_oper@rdwh_exd
                                         where src_commit_date >= d_max_date_cred_st
                                           and src_commit_date <= d_max_date_cred_load_st
                                           and id <=  n_max_id_cred
                                           and row_status = 'U')
                         and not exists
                         (select 1 from t_rbo_z#fact_oper fo
                           where fo.id = fx.id
                             and nvl(fo.c_date,to_date('01-01-1900','dd-mm-yyyy')) = nvl(fx.c_date,to_date('01-01-1900','dd-mm-yyyy'))
                             and nvl(fo.c_summa,0) = nvl(fx.c_summa,0)
                             and nvl(fo.c_valuta,0) = nvl(fx.c_valuta,0)
                             and nvl(fo.c_doc,0) = nvl(fx.c_doc,0)
                             and nvl(fo.c_is_storno,0) = nvl(fx.c_is_storno,0)
                             and nvl(fo.c_reverse_fo,0) = nvl(fx.c_reverse_fo,0)
                             and nvl(fo.c_kas_date_prov,to_date('01-01-1900','dd-mm-yyyy')) = nvl(fx.c_kas_date_prov,to_date('01-01-1900','dd-mm-yyyy'))
                             and nvl(fo.c_kas_doc_state,'*') = nvl(fx.c_kas_doc_state,'*')
                             and nvl(fo.collection_id,0) = nvl(fx.collection_id,0)
                             and nvl(fo.c_oper,0) = nvl(fx.c_oper,0))                        ;
      commit;
     --отслеживаем данные, по которым была вставка ранней датой
     /*for rec in (
        select 'FACT_OPER' as c_class_object,
               trunc(cast(ke.src_commit_date as date)) as c_date_edit,
               ke.id as c_id_object,
               'INSERT' as c_str,
               cast(ke.src_commit_date as date) as c_sys_date,
               (select collection_id from s02.z#fact_oper@rdwh_exd where id = ke.id) as c_id_collection,
               0 as c_status
          from s02.s$z#fact_oper@rdwh_exd ke
         where ke.id in (
        select fo.id
          from s02.z#fact_oper@rdwh_exd fo
         where fo.id > n_max_id_cred
           and fo.c_kas_date_prov <= d_kas_date_prov_cred
           and fo.id <= nvl(n_max_id_cred_load,fo.id)
       )
        and ke.row_status = 'I'
        ) loop
       insert into T_RBO_Z#KAS_EDIT_OBJ_TMP(C_CLASS_OBJECT,C_DATE_EDIT,C_ID_OBJECT,C_STR,C_SYS_DATE,C_ID_COLLECTION,C_STATUS)
       values(rec.c_class_object,rec.c_date_edit,rec.c_id_object,rec.c_str, rec.c_sys_date, rec.c_id_collection,rec.c_status);
       

     end loop;
     commit;*/
     insert into T_RBO_Z#KAS_EDIT_OBJ_TMP(C_CLASS_OBJECT,C_DATE_EDIT,C_ID_OBJECT,C_STR,C_SYS_DATE,C_ID_COLLECTION,C_STATUS)
     select /*+parallel(10)*/ 'FACT_OPER' as c_class_object,
               trunc(cast(ke.src_commit_date as date)) as c_date_edit,
               ke.id as c_id_object,
               'INSERT' as c_str,
               cast(ke.src_commit_date as date) as c_sys_date,
               (select collection_id from s02.z#fact_oper@rdwh_exd where id = ke.id) as c_id_collection,
               0 as c_status
          from s02.s$z#fact_oper@rdwh_exd ke
         where ke.id in (
        select fo.id
          from s02.z#fact_oper@rdwh_exd fo
         where fo.id > n_max_id_cred
           and fo.c_kas_date_prov <= d_kas_date_prov_cred
           and fo.id <= nvl(n_max_id_cred_load,fo.id)
       )
        and ke.row_status = 'I';
   commit;   
     
     --LOAD_RBO_P5
     select max(fo.id)
       into n_max_id_card
       from t_rbo_z#kas_pc_fo fo;

     select max(fo.c_doc_date)
      into d_kas_date_prov_card
      from t_rbo_z#kas_pc_fo fo;

     --таблица, в которую заносим данные об изменениях в уже загруженные проводки
     --определяем максимальную дату, по которой уже делали анализ
    select cast(src_commit_date as date) , src_commit_date
      into d_max_date_card, d_max_date_card_st
      from s02.s$z#kas_pc_fo@rdwh_exd
     where id = n_max_id_card
           and row_status = 'I';

    if trunc(d_max_date_card) = trunc(sysdate) or to_number(to_char(d_max_date_card,'hh24mi')) < 0700 then
        d_kas_date_prov_card := d_kas_date_prov_card - 1;
    end if;
     --поседний id который будем грузить
     --необходимо для того, что если загрузка стартанет днем, то на следующий день
     --будет много договоров для редактирования

    select max(id)
      into n_max_id_card_load
      from s02.s$z#kas_pc_fo@rdwh_exd
     where src_commit_date >= to_timestamp(to_char(d_date_load,'dd-mm-yyyy')||'00:01:00.000','DD-MM-YYYY HH24:MI:SS.FF')
       and src_commit_date <= to_timestamp(to_char(d_date_load,'dd-mm-yyyy')||'04:00:00.000','DD-MM-YYYY HH24:MI:SS.FF')
       and row_status = 'I';
     --дата, позже которой не надо анализировать
    if n_max_id_card_load is not null then

        select cast(src_commit_date as date), src_commit_date
          into d_max_date_card_load, d_max_date_card_load_st
          from s02.s$z#kas_pc_fo@rdwh_exd
         where id = n_max_id_card_load
           and row_status = 'I';
    else
      d_max_date_card_load := null;
    end if;
    --во временную таблицу заносим данные, по которым было изменение(update or delete)
    --по уже загруженным ID - update and delete
    --только по удаленным
    /*for rec in (
      select 'KAS_PC_FO' as c_class_object,
             trunc(cast(src_commit_date as date))  as c_date_edit,
             sfo.id as c_id_object,
             'DELETE' as c_str,
             cast(sfo.src_commit_date as date) as c_sys_date,
             (select collection_id from t_rbo_z#kas_pc_fo where id = sfo.id) as c_id_collection,
             0 as c_status
        from s02.s$z#kas_pc_fo@rdwh_exd sfo
       where sfo.src_commit_date >= d_max_date_card_st
         and sfo.src_commit_date <= d_max_date_card_load_st
         and sfo.id <=  n_max_id_card
         and sfo.row_status = 'D'
          ) loop
      insert into T_RBO_Z#KAS_EDIT_OBJ_TMP(C_CLASS_OBJECT,C_DATE_EDIT,C_ID_OBJECT,C_STR,C_SYS_DATE,C_ID_COLLECTION,C_STATUS)
      values(rec.c_class_object,rec.c_date_edit,rec.c_id_object,rec.c_str,rec.c_sys_date,rec.c_id_collection,rec.c_status);
      
    end loop;
    commit;*/
    insert into T_RBO_Z#KAS_EDIT_OBJ_TMP(C_CLASS_OBJECT,C_DATE_EDIT,C_ID_OBJECT,C_STR,C_SYS_DATE,C_ID_COLLECTION,C_STATUS)
    select /*+parallel(10)*/ 'KAS_PC_FO' as c_class_object,
             trunc(cast(src_commit_date as date))  as c_date_edit,
             sfo.id as c_id_object,
             'DELETE' as c_str,
             cast(sfo.src_commit_date as date) as c_sys_date,
             (select collection_id from t_rbo_z#kas_pc_fo where id = sfo.id) as c_id_collection,
             0 as c_status
        from s02.s$z#kas_pc_fo@rdwh_exd sfo
       where sfo.src_commit_date >= d_max_date_card_st
         and sfo.src_commit_date <= d_max_date_card_load_st
         and sfo.id <=  n_max_id_card
         and sfo.row_status = 'D';
     commit;    
    --только по отредактированным, у которых были изменения влияющие на остатки и кол-во дней на просрочке
    /*for rec in (select 'KAS_PC_FO' as c_class_object,
                       trunc(coalesce(fx.c_doc_date,fx.c_oper_date,d_date_load))  as c_date_edit,
                       fx.id as c_id_object,
                       'UPDATE' as c_str,
                       coalesce(fx.c_doc_date,fx.c_oper_date,d_date_load) as c_sys_date,
                       fx.collection_id  as c_id_collection,
                       0 as c_status
                  from s02.z#kas_pc_fo@rdwh_exd fx
                 where fx.id in (select sfo.id
                         from s02.s$z#kas_pc_fo@rdwh_exd sfo
                        where sfo.src_commit_date >= d_max_date_card_st
                          and sfo.src_commit_date <= d_max_date_card_load_st
                          and sfo.id <=  n_max_id_card
                          and sfo.row_status = 'U')
                  and not exists
                  (select 1 from t_rbo_z#kas_pc_fo fo
                    where fo.id = fx.id
                      and nvl(fo.c_oper_date,to_date('01-01-1900','dd-mm-yyyy')) = nvl(fx.c_oper_date,to_date('01-01-1900','dd-mm-yyyy'))
                      and nvl(fo.c_summa,0) = nvl(fx.c_summa,0)
                      and nvl(fo.c_doc_ref,0) = nvl(fx.c_doc_ref,0)
                     -- and nvl(fo.c_is_storno,0) = nvl(fx.c_is_storno,0)
                    --  and nvl(fo.c_reverse_fo,0) = nvl(fx.c_reverse_fo,0)
                      and nvl(fo.c_doc_date,to_date('01-01-1900','dd-mm-yyyy')) = nvl(fx.c_doc_date,to_date('01-01-1900','dd-mm-yyyy'))
                      and nvl(fo.c_doc_state,'*') = nvl(fx.c_doc_state,'*')
                      and nvl(fo.collection_id,0) = nvl(fx.collection_id,0)
                      and nvl(fo.c_vid_oper_ref,0) = nvl(fx.c_vid_oper_ref,0))
           ) loop
       insert into T_RBO_Z#KAS_EDIT_OBJ_TMP(C_CLASS_OBJECT,C_DATE_EDIT,C_ID_OBJECT,C_STR,C_SYS_DATE,C_ID_COLLECTION,C_STATUS)
       values(rec.c_class_object,rec.c_date_edit,rec.c_id_object,rec.c_str,rec.c_sys_date,rec.c_id_collection,rec.c_status);
       
     end loop;
     commit;*/
     
     insert into T_RBO_Z#KAS_EDIT_OBJ_TMP(C_CLASS_OBJECT,C_DATE_EDIT,C_ID_OBJECT,C_STR,C_SYS_DATE,C_ID_COLLECTION,C_STATUS)
     select /*+parallel(10)*/ 'KAS_PC_FO' as c_class_object,
                       trunc(coalesce(fx.c_doc_date,fx.c_oper_date,d_date_load))  as c_date_edit,
                       fx.id as c_id_object,
                       'UPDATE' as c_str,
                       coalesce(fx.c_doc_date,fx.c_oper_date,d_date_load) as c_sys_date,
                       fx.collection_id  as c_id_collection,
                       0 as c_status
                  from s02.z#kas_pc_fo@rdwh_exd fx
                 where fx.id in (select sfo.id
                         from s02.s$z#kas_pc_fo@rdwh_exd sfo
                        where sfo.src_commit_date >= d_max_date_card_st
                          and sfo.src_commit_date <= d_max_date_card_load_st
                          and sfo.id <=  n_max_id_card
                          and sfo.row_status = 'U')
                  and not exists
                  (select 1 from t_rbo_z#kas_pc_fo fo
                    where fo.id = fx.id
                      and nvl(fo.c_oper_date,to_date('01-01-1900','dd-mm-yyyy')) = nvl(fx.c_oper_date,to_date('01-01-1900','dd-mm-yyyy'))
                      and nvl(fo.c_summa,0) = nvl(fx.c_summa,0)
                      and nvl(fo.c_doc_ref,0) = nvl(fx.c_doc_ref,0)
                     -- and nvl(fo.c_is_storno,0) = nvl(fx.c_is_storno,0)
                    --  and nvl(fo.c_reverse_fo,0) = nvl(fx.c_reverse_fo,0)
                      and nvl(fo.c_doc_date,to_date('01-01-1900','dd-mm-yyyy')) = nvl(fx.c_doc_date,to_date('01-01-1900','dd-mm-yyyy'))
                      and nvl(fo.c_doc_state,'*') = nvl(fx.c_doc_state,'*')
                      and nvl(fo.collection_id,0) = nvl(fx.collection_id,0)
                      and nvl(fo.c_vid_oper_ref,0) = nvl(fx.c_vid_oper_ref,0));
     commit;                 
     --отслеживаем данные, по которым была вставка ранней датой
     /*for rec in (
       select 'KAS_PC_FO' as c_class_object,
               trunc(cast(ke.src_commit_date as date)) as c_date_edit,
               ke.id as c_id_object,
               'INSERT' as c_str,
               cast(ke.src_commit_date as date) as c_sys_date,
               (select collection_id from s02.z#kas_pc_fo@rdwh_exd where id = ke.id) as c_id_collection,
               0 as c_status
          from s02.s$z#kas_pc_fo@rdwh_exd ke
         where ke.id in (
        select fo.id
          from s02.z#kas_pc_fo@rdwh_exd fo
         where fo.id >  n_max_id_card
           and fo.c_doc_date <= d_kas_date_prov_card
           and fo.id <= nvl(n_max_id_card_load,fo.id)
       )
        and ke.row_status = 'I'
       ) loop
       insert into T_RBO_Z#KAS_EDIT_OBJ_TMP(C_CLASS_OBJECT,C_DATE_EDIT,C_ID_OBJECT,C_STR,C_SYS_DATE,C_ID_COLLECTION,C_STATUS)
       values (rec.c_class_object,rec.c_date_edit,rec.c_id_object,rec.c_str,rec.c_sys_date,rec.c_id_collection,rec.c_status);
       
     end loop;
     commit;*/
     insert into T_RBO_Z#KAS_EDIT_OBJ_TMP(C_CLASS_OBJECT,C_DATE_EDIT,C_ID_OBJECT,C_STR,C_SYS_DATE,C_ID_COLLECTION,C_STATUS)
     select /*+parallel(10)*/ 'KAS_PC_FO' as c_class_object,
               trunc(cast(ke.src_commit_date as date)) as c_date_edit,
               ke.id as c_id_object,
               'INSERT' as c_str,
               cast(ke.src_commit_date as date) as c_sys_date,
               (select collection_id from s02.z#kas_pc_fo@rdwh_exd where id = ke.id) as c_id_collection,
               0 as c_status
          from s02.s$z#kas_pc_fo@rdwh_exd ke
         where ke.id in (
        select fo.id
          from s02.z#kas_pc_fo@rdwh_exd fo
         where fo.id >  n_max_id_card
           and fo.c_doc_date <= d_kas_date_prov_card
           and fo.id <= nvl(n_max_id_card_load,fo.id)
       )
        and ke.row_status = 'I';
     commit;      
     --
     --заполняем таблицу для остальных таблиц, по которым будем делать пересчет по договорам
     execute immediate 'truncate table T_CONTRACT_EDIT_OBJ_TMP';
     insert into T_CONTRACT_EDIT_OBJ_TMP(rbo_contract_id,rbo_client_id)
     select distinct pc.id as rbo_contract_id, pc.c_client as rbo_client_id
       from u1.T_RBO_Z#KAS_EDIT_OBJ_TMP ke
       join u1.V_RBO_Z#PR_CRED          pc on pc.c_list_pay = ke.c_id_collection
      where ke.c_class_object = 'FACT_OPER'
        and ke.c_status = 0
     union
     select distinct pc.id as rbo_contract_id, pc.c_client_ref as rbo_client_id
       from u1.T_RBO_Z#KAS_EDIT_OBJ_TMP ke
       join u1.V_RBO_Z#KAS_PC_DOG        pc on pc.c_fo_arr = ke.c_id_collection
      where ke.c_class_object = 'KAS_PC_FO'
        and ke.c_status = 0
     union
     select distinct dp.id as rbo_contract_id, dp.c_client as rbo_client_id
       from u1.T_RBO_Z#KAS_EDIT_OBJ_TMP ke
       join u1.V_RBO_Z#DEPN             dp on dp.c_list_pay = ke.c_id_collection
      where ke.c_class_object = 'FACT_OPER'
        and ke.c_status = 0;
     commit;
     --
end ETLT_KAS_EDIT_OBJ_TMP;
/

