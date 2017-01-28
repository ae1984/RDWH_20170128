create or replace procedure u1.ETLT_RBO_Z#AC_FIN is
       s_mview_name     varchar2(30) := 'T_RBO_Z#AC_FIN';
       vStrDate         date := sysdate;

       d_src_commit_date_last date; --дата последней загруженной строки
       d_src_commit_date_load date; --дата, по которую делаем загрузку

      begin
        select max(src_commit_date)
          into d_src_commit_date_load
          from s02.s$Z#AC_FIN@rdwh_exd;

        select last_date-10/24/60/60
          into d_src_commit_date_last
          from t_rdwh_increment_tables_load
         where object_name = s_mview_name;
        --
        delete /*+ append enable_parallel_dml parallel(10) */ from T_RBO_Z#AC_FIN
         where id in (select distinct id
                        from s02.s$Z#AC_FIN@rdwh_exd
                       where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
        commit;
        insert /*+ append */into T_RBO_Z#AC_FIN
        select id,
                class_id,
                c_main_v_id,
                 translate(upper(c_name),
                  chr(53388)||chr(53384)||chr(53383)||chr(53904)||
                  chr(53390)||chr(53380)||chr(53381),
                  chr(53914)||chr(54168)||chr(53934)||chr(54184)||
                  chr(53936)||chr(53906)||chr(53922)) as
                c_name,
                c_fintool,
                c_user_op,
                c_client_r,
                c_client_v,
                c_date_op,
                c_ps,
                c_date_last,
                c_date_l_nt,
                c_saldo,
                c_saldo_nt,
                c_vid,
                c_date_close,
                c_user_close,
                c_to_product,
                c_com_status,
                c_depart,
                c_otv,
                c_recont_acc#0,
                c_recont_acc#rec_bs,
                c_recont_acc#rec_yes#rec_s_dt,
                c_recont_acc#rec_yes#rec_s_kt,
                c_recont_acc#rec_not,
                c_main_usv,
                c_turn_today_dt,
                c_turn_today_ct,
                c_turn_today_dt_nt,
                c_turn_today_ct_nt,
                c_filial,
                c_date_tax,
                c_order_ref,
                c_period_ref,
                c_acc_summary,
                c_delins_date,
                c_accs_arr,
                c_target,
                c_note,
                c_period_action,
                c_over,
                c_tune_delta#0,
                c_tune_delta#oper#sc_minus,
                c_tune_delta#oper#sc_plus,
                c_journal_sald_arr,
                c_oper_delta#sc_minus,
                c_oper_delta#sc_plus,
                c_course_delta#sc_minus,
                c_course_delta#sc_plus,
                c_old_acc_num,
                c_main_v_id_nokey,
                c_chapter,
                c_vid_p,
                c_today_recount,
                c_pr_list,
                c_acc_summary_kt,
                c_equal_odb,
                c_kas_prev_acc_20,
                c_kas_need_sign,
                c_kas_dis_conv_bl,
                c_kas_product_ref,
                c_kas_type_acc_ref,
                c_kas_date_last,
                c_kas_date_last_nt
          from s02.Z#AC_FIN@rdwh_exd
         where id in (select distinct id
                        from s02.s$Z#AC_FIN@rdwh_exd
                       where src_commit_date between d_src_commit_date_last and d_src_commit_date_load);
        commit;
        --сохраняем информацию о послeдней загрузке
        update T_RDWH_INCREMENT_TABLES_LOAD
           set last_date = d_src_commit_date_load
         where object_name =s_mview_name;
        commit;

end ETLT_RBO_Z#AC_FIN;
/

