create or replace procedure u1.ETLT_FACT_OPER is
      s_mview_name           varchar2(30) := 'T_RBO_Z#FACT_OPER';
      vStrDate               date := sysdate;
      n_max_id_cred          number;
      n_max_id_cred_load     number(20);
      d_date_load            date := trunc(sysdate); --обязательное для заполнения
    begin
     select max(fo.id)
       into n_max_id_cred
       from t_rbo_z#fact_oper fo;

     --TODO: из OBJ_TMP?
     select max(id)
       into n_max_id_cred_load
       from s02.s$z#fact_oper@rdwh_exd
      where src_commit_date >= to_timestamp(to_char(d_date_load,'dd-mm-yyyy')||'00:01:00.000','DD-MM-YYYY HH24:MI:SS.FF')
        and src_commit_date <= to_timestamp(to_char(d_date_load,'dd-mm-yyyy')||'04:00:00.000','DD-MM-YYYY HH24:MI:SS.FF')
        and row_status = 'I';
     --после того, как определили какие договора и проводки надо изменить
     --сначала удаляем проводки, по которым были изменения
     delete from t_rbo_z#fact_oper where id in (
            select distinct c_id_object
              from T_RBO_Z#KAS_EDIT_OBJ_TMP
             where c_class_object = 'FACT_OPER'
               and c_status = 0
              -- and c_str in ('UPDATE','DELETE'))
             );

     for r in (select /*+ driving_site(fo) */
                      fo.id,
                      fo.collection_id,
                      fo.c_date,
                      fo.c_oper,
                      fo.c_summa,
                      fo.c_valuta,
                      fo.c_doc,
                      fo.c_beg_date,
                      fo.c_end_date,
                      fo.c_order_num,
                      fo.c_reg_currency_sum,
                      fo.class_id,
                      fo.c_obj_ref,
                      fo.c_obj_class,
                      fo.c_sum_next_cap,
                      fo.c_cash,
                      fo.c_print_sk,
                      fo.c_tmp_oper,
                      fo.c_tmp_date,
                      fo.c_is_storno,
                      fo.c_summa_add,
                      fo.c_not_paid_sum,
                      fo.c_out_memo_sum,
                      fo.c_not_set_depend,
                      fo.c_reverse_fo,
                      fo.c_audit,
                      fo.c_kas_date_prov,
                      fo.c_kas_doc_state
                 from rdwh.v_rbo_z#fact_oper@rdwh_exd fo
                where fo.id in (select distinct c_id_object
                 from T_RBO_Z#KAS_EDIT_OBJ_TMP
                where c_class_object = 'FACT_OPER'
                  and c_status = 0
                  and c_id_object <= n_max_id_cred)
              )
     loop
       insert into T_RBO_Z#FACT_OPER
       values (r.id,
              r.collection_id,
              r.c_date,
              r.c_oper,
              r.c_summa,
              r.c_valuta,
              r.c_doc,
              r.c_beg_date,
              r.c_end_date,
              r.c_order_num,
              r.c_reg_currency_sum,
              r.class_id,
              r.c_obj_ref,
              r.c_obj_class,
              r.c_sum_next_cap,
              r.c_cash,
              r.c_print_sk,
              r.c_tmp_oper,
              r.c_tmp_date,
              r.c_is_storno,
              r.c_summa_add,
              r.c_not_paid_sum,
              r.c_out_memo_sum,
              r.c_not_set_depend,
              r.c_reverse_fo,
              r.c_audit,
              r.c_kas_date_prov,
              r.c_kas_doc_state);
     end loop;

     commit;
     --вставим все данные по вновь заносимым проводкам
     insert /*+ APPEND*/into T_RBO_Z#FACT_OPER
     select /*+ parallel(5)*/
            fo.id,
            fo.collection_id,
            fo.c_date,
            fo.c_oper,
            fo.c_summa,
            fo.c_valuta,
            fo.c_doc,
            fo.c_beg_date,
            fo.c_end_date,
            fo.c_order_num,
            fo.c_reg_currency_sum,
            fo.class_id,
            fo.c_obj_ref,
            fo.c_obj_class,
            fo.c_sum_next_cap,
            fo.c_cash,
            fo.c_print_sk,
            fo.c_tmp_oper,
            fo.c_tmp_date,
            fo.c_is_storno,
            fo.c_summa_add,
            fo.c_not_paid_sum,
            fo.c_out_memo_sum,
            fo.c_not_set_depend,
            fo.c_reverse_fo,
            fo.c_audit,
            fo.c_kas_date_prov,
            fo.c_kas_doc_state
       from rdwh.v_rbo_z#fact_oper@rdwh_exd fo
      where fo.id > n_max_id_cred
        and fo.id <= nvl(n_max_id_cred_load,fo.id);
     commit;
     ---конец обновили все данные по проводкам по кредитам


    end ETLT_FACT_OPER;
/

