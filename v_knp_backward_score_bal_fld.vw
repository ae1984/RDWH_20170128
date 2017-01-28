create or replace force view u1.v_knp_backward_score_bal_fld as
select x."FOLDER_ID",x."KDN_FORM_SP",x."KDN_FORM_SALARY_MAX_SP",x."KDN_SIMPLE_NOM_RATE_SP",x."KDN_SIMPLE_RBO_SP",x."PAID_SAL_COUNT_ALL_CON_SP",x."PKB_TOTAL_DEBT_SP",x."SCORE_POINTS_SP",
       coalesce(x.kdn_form_sp, 0) + coalesce(x.KDN_FORM_SALARY_MAX_SP, 0) + coalesce(x.KDN_SIMPLE_NOM_RATE_SP, 0) +
       coalesce(x.KDN_SIMPLE_RBO_SP, 0) + coalesce(x.PAID_SAL_COUNT_ALL_CON_SP, 0) + coalesce(x.PKB_TOTAL_DEBT_SP, 0) +
       coalesce(x.SCORE_POINTS_SP, 0) as score_bal,
       x.score_bal_fw
from (
    select t1.folder_id,
           t2.SCORE_POINTS score_bal_fw,
           case when t3.KDN_FORM < 34.6    then 7
                when t3.KDN_FORM < 50.23   then 9
                when t3.KDN_FORM < 63.71   then 11
                when t3.KDN_FORM < 73.3    then 13
                when t3.KDN_FORM < 84.37   then 15
                when t3.KDN_FORM < 106.42  then 17
                when t3.KDN_FORM >= 106.42 then 23
                                           else 7 end as KDN_FORM_SP,
           case when t3.KDN_FORM_SALARY_MAX < 28.62   then -1
                when t3.KDN_FORM_SALARY_MAX < 41.96   then 4
                when t3.KDN_FORM_SALARY_MAX < 56.88   then 10
                when t3.KDN_FORM_SALARY_MAX < 74.15   then 16
                when t3.KDN_FORM_SALARY_MAX < 89.77   then 25
                when t3.KDN_FORM_SALARY_MAX < 119.56  then 36
                when t3.KDN_FORM_SALARY_MAX >= 119.56 then 49
                                                      else -1 end as KDN_FORM_SALARY_MAX_SP,
           case when t3.KDN_SIMPLE_NOM_RATE < 25.5   then 4
                when t3.KDN_SIMPLE_NOM_RATE < 34.47  then 7
                when t3.KDN_SIMPLE_NOM_RATE < 48.57  then 10
                when t3.KDN_SIMPLE_NOM_RATE < 55.77  then 16
                when t3.KDN_SIMPLE_NOM_RATE < 69.37  then 20
                when t3.KDN_SIMPLE_NOM_RATE < 96.66  then 29
                when t3.KDN_SIMPLE_NOM_RATE >= 96.66 then 42
                                                     else 4 end as KDN_SIMPLE_NOM_RATE_SP,
           case when t3.KDN_SIMPLE_RBO < 24.08   then 3
                when t3.KDN_SIMPLE_RBO < 34.81   then 6
                when t3.KDN_SIMPLE_RBO < 52.74   then 10
                when t3.KDN_SIMPLE_RBO < 60.14   then 15
                when t3.KDN_SIMPLE_RBO < 74.11   then 19
                when t3.KDN_SIMPLE_RBO < 101.42  then 27
                when t3.KDN_SIMPLE_RBO >= 101.42 then 43
                                                 else 3 end as KDN_SIMPLE_RBO_SP,
           case when t1.PAID_SAL_COUNT_ALL_CON < 5   then 20
                when t1.PAID_SAL_COUNT_ALL_CON < 8   then 17
                when t1.PAID_SAL_COUNT_ALL_CON < 11  then  15
                when t1.PAID_SAL_COUNT_ALL_CON < 17  then 9
                when t1.PAID_SAL_COUNT_ALL_CON < 23  then 4
                when t1.PAID_SAL_COUNT_ALL_CON < 30  then -5
                when t1.PAID_SAL_COUNT_ALL_CON >= 30 then -23
                                                     else 17 end as PAID_SAL_COUNT_ALL_CON_SP,
           case when t1.PKB_TOTAL_DEBT < 42803.07    then -3
                when t1.PKB_TOTAL_DEBT < 117537.08    then 8
                when t1.PKB_TOTAL_DEBT < 151065.93    then 16
                when t1.PKB_TOTAL_DEBT < 193443.52    then 10
                when t1.PKB_TOTAL_DEBT < 1417220.19  then 19
                when t1.PKB_TOTAL_DEBT >= 1417220.19 then 8
                                                     else 17 end as PKB_TOTAL_DEBT_SP,
           case when t2.SCORE_POINTS < 94  then 38
                when t2.SCORE_POINTS < 110 then 24
                when t2.SCORE_POINTS < 118 then 15
                when t2.SCORE_POINTS < 127 then 11
                when t2.SCORE_POINTS < 135 then 3
                when t2.SCORE_POINTS < 138 then -2
                                           else -8 end as SCORE_POINTS_SP
      from u1.m_folder_con_miner_folder t1
      left join U1.V_REJ_SCORE_KNP_BW_22_1_FLD t2 on t2.folder_id = t1.folder_id
      left join u1.m_tmp_j_k5_folder t3 on t3.folder_id = t1.folder_id
--      left join u1.m_folder_con_miner_v3 t4 on t4.contract_number = t1.contract_number
      where t1.cr_program_name = 'КРЕДИТ НАЛИЧНЫМИ ПОВТОРНИКУ'
) x
;
grant select on U1.V_KNP_BACKWARD_SCORE_BAL_FLD to LOADDB;
grant select on U1.V_KNP_BACKWARD_SCORE_BAL_FLD to LOADER;


