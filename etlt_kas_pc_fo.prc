create or replace procedure u1.ETLT_KAS_PC_FO is
      s_mview_name           varchar2(30) := 'T_RBO_Z#KAS_PC_FO';
      vStrDate               date := sysdate;
      n_max_id_card          number;
      d_date_load            date := trunc(sysdate);
      n_max_id_card_load     number;
    begin
      select max(fo.id)
        into n_max_id_card
        from t_rbo_z#kas_pc_fo fo;

      select max(id)
        into n_max_id_card_load
        from s02.s$z#kas_pc_fo@rdwh_exd
       where src_commit_date >= to_timestamp(to_char(d_date_load,'dd-mm-yyyy')||'00:01:00.000','DD-MM-YYYY HH24:MI:SS.FF')
         and src_commit_date <= to_timestamp(to_char(d_date_load,'dd-mm-yyyy')||'04:00:00.000','DD-MM-YYYY HH24:MI:SS.FF')
         and row_status = 'I';

      --после того, как определили какие договора и проводки надо изменить
      for rec in (select distinct c_id_object
                    from T_RBO_Z#KAS_EDIT_OBJ_TMP
                   where c_class_object = 'KAS_PC_FO'
                     and c_status = 0
                     and c_str in ('UPDATE','DELETE')) loop
         --сначала удаляем проводки, по которым были изменения
         delete from T_RBO_Z#KAS_PC_FO where id = rec.c_id_object;
         --вставляем обновленные данные по удаленным проводкам
         insert  into T_RBO_Z#KAS_PC_FO
         select /*+ driving_site*/
                id,
                class_id,
                collection_id,
                state_id,
                c_key,
                c_num,
                c_oper_date,
                c_vid_oper_ref,
                c_date_grace_end,
                c_card_ref,
                c_summa,
                c_exec_summa,
                c_doc_ref,
                c_parent_ref,
                c_child_ref,
                c_reverse_fo,
                c_is_grace_exec,
                c_is_storno,
                c_slip_ref,
                c_tarifchik_ref,
                c_pay_off_date,
                c_prc_ref,
                c_op_ref,
                c_stmt_ref,
                c_fld_num,
                c_req_ref,
                c_correct_date,
                c_client_summa,
                c_grace_type_ref,
                c_grace_state_ref,
                c_grace_date_plan,
                c_grace_date_fact,
                c_sum_for_pay,
                c_doc_date,
                c_doc_state
           from rdwh.V_RBO_Z#KAS_PC_FO@rdwh_exd
          where id = rec.c_id_object;
         commit;
      end loop;
      --вставим все данные по вновь заносимым проводкам
      insert /*+ APPEND*/into T_RBO_Z#KAS_PC_FO
      select /*+ parallel(5)*/
             id,
             class_id,
             collection_id,
             state_id,
             c_key,
             c_num,
             c_oper_date,
             c_vid_oper_ref,
             c_date_grace_end,
             c_card_ref,
             c_summa,
             c_exec_summa,
             c_doc_ref,
             c_parent_ref,
             c_child_ref,
             c_reverse_fo,
             c_is_grace_exec,
             c_is_storno,
             c_slip_ref,
             c_tarifchik_ref,
             c_pay_off_date,
             c_prc_ref,
             c_op_ref,
             c_stmt_ref,
             c_fld_num,
             c_req_ref,
             c_correct_date,
             c_client_summa,
             c_grace_type_ref,
             c_grace_state_ref,
             c_grace_date_plan,
             c_grace_date_fact,
             c_sum_for_pay,
             c_doc_date,
             c_doc_state
        from rdwh.V_RBO_Z#KAS_PC_FO@rdwh_exd fo
       where fo.id > n_max_id_card
         and fo.id <= nvl(n_max_id_card_load,fo.id);
     commit;
     ---конец обновили все данные по проводкам по кредитам

    end ETLT_KAS_PC_FO;
/

