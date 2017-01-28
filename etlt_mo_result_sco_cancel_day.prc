create or replace procedure u1.ETLT_MO_RESULT_SCO_CANCEL_DAY is
     s_mview_name varchar2(30) := 'T_MO_RESULT_SCO_CANCEL_DAY';
     vStrDate date := sysdate;
     vLast_load_date date;
  BEGIN
    select last_date
      into vLast_load_date
      from t_rdwh_increment_tables_load tl
     where tl.object_name = s_mview_name;

    --удаляем

      delete
        from T_MO_RESULT_SCO_CANCEL_DAY cd
       where cd.folder_id in (select distinct rc.cancel_folder
                               from u1.V_MO_RES_RFO_CANCEL rc
                              where rc.cancel_id in (select CANCEL_ID from T_MO_RESULT_SCO_CANCEL_DAY_TMP));

      delete from T_MO_RESULT_SCO_CANCEL_DAY_TMP;

      insert into T_MO_RESULT_SCO_CANCEL_DAY_TMP
      (select /*+ driving_site*/ distinct id
         from s01.s$Z#KAS_CANCEL@rdwh_exd kc
        where kc.src_commit_date >= vLast_load_date
              and kc.src_commit_date < trunc(sysdate));

      commit;

    --добавляем
    insert /*+ append enable_parallel_dml parallel(10)*/ into T_MO_RESULT_SCO_CANCEL_DAY cd
    (
    select /*+parallel(30) parallel_index(30) */
           -- params to add to v_cancel
           rcd.cancel_id_max as cancel_id,
           rcd.cancel_folder as folder_id,
           rcd.cancel_client as rfo_client_id,
           rcd.cancel_date_max as cancel_date,
           rcd.cancel_err_level as cancel_err_level,
           'MO-' || cancel_type_code as cancel_type_group,
           dp2.code_int as cancel_type_code,
           dp2.name as cancel_type_name,
           --ppv1.value_number as scorecard,
           scr.card_prod as scorecard,
           --additional params
           r.rfo_res_from_mo_id,
           r.res_date as rfo_res_date,
           r.c_client_ref as rfo_res_client_id,
           r.c_folder_ref as rfo_res_folder_id,
           r.c_result as rfo_result,
           dpr.code as process_code,
           p.id as process_id,
           w.id as mogw_process_id,
           cast(w.date_start as date) as mogw_date_start
      from (select /*+ parallel(20) */
                 rc.cancel_folder, rc.cancel_client, rc.cancel_type_code, rc.cancel_type_type, rc.cancel_err_level,
                 max(rc.cancel_id) as cancel_id_max,
                 max(rc.cancel_date) keep (dense_rank last
                      order by rc.cancel_id) as cancel_date_max,
                 max(rc.cancel_rfo_res_from_mo_id) keep (dense_rank last
                      order by rc.cancel_id) as cancel_rfo_res_from_mo_id_max
            from u1.V_MO_RES_RFO_CANCEL rc
           where rc.cancel_type_code in ('MO_SCO_REJECT'/*,'BL_REJECT_ASOKR'*/) and
                 rc.cancel_folder is not null and
                 rc.cancel_folder in (select distinct rc2.cancel_folder
                                        from u1.V_MO_RES_RFO_CANCEL rc2
                                        join T_MO_RESULT_SCO_CANCEL_DAY_TMP ct on ct.cancel_id = rc2.cancel_id)
           group by rc.cancel_folder, rc.cancel_client, rc.cancel_type_code, rc.cancel_type_type, rc.cancel_err_level) rcd
      join u1.V_MO_RES_RFO_KAS_RES_FROM_MO r on r.rfo_res_from_mo_id = rcd.cancel_rfo_res_from_mo_id_max
      join u1.MOGW_PROCESS_MO1 w on w.id = r.c_res_mo_id and trunc(w.date_start) = trunc(r.res_date)
      join u1.MO_PROCESS p on p.id = w.process_id
      join u1.V_MO_D_PROCESS dpr on dpr.id = p.d_process_id and dpr.code = 'MO_SCO'
      join u1.MO_PROCESS_PAR_VALUE ppv1 on ppv1.process_id = p.id
           join u1.V_MO_D_PAR dp1 on dp1.id = ppv1.d_par_id and dp1.code_int = 'IN_SCO_NUM_SCORING'
      join u1.MO_CALC c on c.process_id = p.id
      join u1.MO_CALC_PAR_VALUE cpv on cpv.calc_id = c.id and cpv.value_number = 1
      join u1.V_MO_D_CALC_PAR dcp on dcp.id = cpv.d_calc_par_id and dcp.is_out = 1
      join u1.V_MO_D_PAR dp2 on dp2.id = cpv.d_par_id
      join (select /*+ parallel(20) */
                   distinct dp.code_int
              from u1.V_MO_D_PAR dp
              join u1.V_MO_D_CALC_PAR cp on cp.d_par_code = dp.code_int and cp.is_out = 1
              join u1.V_MO_D_CALC dc on dc.code = cp.d_calc_code and
                                     (dc.d_calc_group_code like 'SC_%' or
                                     dc.d_calc_group_code in ('AR1_EKT','AR1_KN','AR1_KN15_LKN_PKN','AR1_KNP'))
             where dp.code_int like '%_RES_PRE%' or
                   dp.code_int in ('CLIENT_BL_EXISTS_SCO', 'CLIENT_DOC_BL_EXISTS',
                                   'RISK_AUTO_AMOUNT_BEKI_GCVP', 'SC_RISK_EKT_UNMARRIED_BEKI_LOW_SAL',
                                   'SC_RISK_KN_KDN_HIGH_INCOME', 'SC_RISK_KN_KDN_LOW_INCOME',
                                   'SC_AR1_KN15_LKN_PKN', 'SC_AR1_EKT', 'SC_AR1_KN', 'SC_AR1_KNP',
                                   'SC_2_KN_RULES_SET_J1', 'SC_22_ANTIFRAUD_201405', 'SC_8_ANTIFRAUD_201405',
                                   'SC_17_ANTIFRAUD_201406', 'SC_CHECK_MAN_REJ', 'SC_AUTO_GAI_NO_GCVP',
                                   'SC_ROUTE_RES'
                                   )) cpa on cpa.code_int = dp2.code_int
      left join u1.V_SCO_CARDS scr on scr.card_id = ppv1.value_number);
    commit;

    update t_rdwh_increment_tables_load
       set last_date = trunc(sysdate)
      where object_name = s_mview_name;

    commit;
 END ETLT_MO_RESULT_SCO_CANCEL_DAY;
/

