create or replace procedure u1.ETLT_CONTRACT_DEBT_OPER is
      s_mview_name           varchar2(30) := 'T_CONTRACT_DEBT_OPER';
      vStrDate               date := sysdate;
      d_max_date_debt_cred   date;
      d_date_load            date := trunc(sysdate);
      d_max_date_debt_card   date;
    begin

      --определяем последнюю дату по задолженности
      select max(do.c_date_begin_saldo)
        into d_max_date_debt_cred
        from T_CONTRACT_DEBT_OPER do
       where do.is_card = 0;
      --
      for cur in (select d_max_date_debt_cred + level as rep_date
                    from dual
                   where d_max_date_debt_cred + level < d_date_load
                 connect by rownum < d_date_load - d_max_date_debt_cred
                   order by 1
       ) loop
         --добавляем расчеты по новым датам
         --
         insert /*+ append enable_parallel_dml parallel(20)*/ into T_CONTRACT_DEBT_OPER(rbo_contract_id,c_code_debt,c_name_debt,c_date_begin_saldo,c_summa_saldo,c_sum_oper_db,c_sum_oper_cr,is_card)
         select /*+ parallel(15)*/
                x.id rbo_contract_id,
                x.c_code c_code_debt,
                x.c_name c_name_debt,
                x.c_kas_date_prov c_date_begin_saldo,
                sum(x.sum_oper_db*(-1)+x.sum_oper_cr)
                    over (partition by x.id, x.collection_id, x.c_code order by x.c_kas_date_prov rows unbounded preceding) +
                +
                nvl((select sum(do.c_sum_oper_db*(-1)+do.c_sum_oper_cr)
                   from t_contract_debt_oper do where do.rbo_contract_id = x.id
                    and do.c_code_debt = x.c_code
                    and do.c_date_begin_saldo < cur.rep_date),0)  saldo,
                x.sum_oper_db,
                x.sum_oper_cr,
                0 is_card
          from (select trunc(fo.c_kas_date_prov) as c_kas_date_prov, fo.collection_id, pc.id, pc.c_num_dog, pc.c_date_close,
                       sum(case when td.c_dt = 1 then fo.c_summa else 0 end) sum_oper_db,
                       sum(case when td.c_dt = 0 then fo.c_summa else 0 end) sum_oper_cr,
                       vd.c_code, vd.c_name
                  from u1.V_RBO_Z#VID_OPER_DOG vod,
                       u1.V_RBO_Z#VID_DEBT vd,
                       u1.V_RBO_Z#TAKE_IN_DEBT td,
                       u1.T_RBO_Z#FACT_OPER fo,
                       u1.V_RBO_Z#PR_CRED pc
                 where vod.c_code_group = 'КРЕДИТЫ'
                   and vod.c_take_debt = td.collection_id
                   and td.c_debt = vd.id
                   and fo.collection_id = pc.c_list_pay
                   and fo.c_oper = vod.id
                   and fo.c_kas_doc_state = 'PROV'
                   and vd.c_code in ('КРЕДИТ','ПРОСРОЧ_КРЕДИТ','КРЕД_ВНБ_ПРИБ',
                                     'УЧТЕН_ПРОЦЕНТЫ','ПРОЦ_КРЕД_112','ПРОСРОЧ_ПРОЦЕНТЫ','ПРОСРОЧЕН_ПР_НА_ВНБ','ПРЦ_КРЕД_112_ВНБ',
                                     'ПЛАТА_ВЕДЕНИЕ_ПРОСРОЧ','ПЛАТА_ВЕДЕНИЕ_ПР_ВНБ',
                                     'EK_CRED_OVER','EK_OVR_OVER','EK_OVR_OVER_ВНБ')
                   and fo.c_kas_date_prov = cur.rep_date
                   and fo.c_kas_date_prov < d_date_load
                group by pc.c_num_dog, pc.id, pc.c_date_close,
                      fo.collection_id, trunc(fo.c_kas_date_prov), vd.c_code, vd.c_name) x
         union all
         select /*+ parallel(15)*/
                x.id rbo_contract_id,
                x.c_code c_code_debt,
                x.c_name c_name_debt,
                x.c_kas_date_prov c_date_begin_saldo,
                sum(x.sum_oper_db*(-1)+x.sum_oper_cr)
                    over (partition by x.id, x.collection_id, x.c_code order by x.c_kas_date_prov rows unbounded preceding) +
                +
                nvl((select sum(do.c_sum_oper_db*(-1)+do.c_sum_oper_cr)
                   from t_contract_debt_oper do where do.rbo_contract_id = x.id
                    and do.c_code_debt = x.c_code
                    and do.c_date_begin_saldo < cur.rep_date),0)  saldo,
                x.sum_oper_db,
                x.sum_oper_cr,
                0 is_card
           from (select trunc(fo.c_kas_date_prov) as c_kas_date_prov, fo.collection_id, pc.id, pc.c_num_dog, pc.c_date_close,
                        sum(case when td.c_dt = 1 then fo.c_summa else 0 end) sum_oper_db,
                        sum(case when td.c_dt = 0 then fo.c_summa else 0 end) sum_oper_cr,
                        vd.c_code, vd.c_name
                   from u1.V_RBO_Z#VID_OPER_DOG vod,
                        u1.V_RBO_Z#VID_DEBT vd,
                        u1.V_RBO_Z#TAKE_IN_DEBT td,
                        u1.T_RBO_Z#FACT_OPER fo,
                        u1.V_RBO_Z#PR_CRED pc
                  where vod.c_code_group = 'КРЕДИТЫ'
                    and vod.c_take_debt = td.collection_id
                    and td.c_debt = vd.id
                    and fo.collection_id = pc.c_list_pay
                    and fo.c_oper = vod.id
                    and fo.c_kas_doc_state = 'PROV'
                    and vd.c_code = 'ПЛАТА_ВЕДЕНИЕ'
                    and pc.c_kas_pc_dog_ref is null
                    and fo.c_kas_date_prov = cur.rep_date
                    and fo.c_kas_date_prov < d_date_load
                 group by pc.c_num_dog, pc.id, pc.c_date_close,
                       fo.collection_id, trunc(fo.c_kas_date_prov), vd.c_code, vd.c_name) x;
         commit;
         end loop;

     --LOAD_RBO_P5

       --определяем последнюю дату по задолженности
       select max(do.c_date_begin_saldo)
         into d_max_date_debt_card
         from T_CONTRACT_DEBT_OPER do
        where do.is_card = 1;
           --
           for cur in (select d_max_date_debt_card + level as rep_date
                         from dual
                        where d_max_date_debt_card + level <  d_date_load
                      connect by rownum < d_date_load - d_max_date_debt_card
                        order by 1
            ) loop
          --добавляем расчеты по новым датам
          --
          insert /*+ append enable_parallel_dml parallel(20)*/ into T_CONTRACT_DEBT_OPER(rbo_contract_id,c_code_debt,c_name_debt,c_date_begin_saldo,c_summa_saldo,c_sum_oper_db,c_sum_oper_cr,is_card)
          select /*+ parallel(20)*/
                 x.id rbo_contract_id,
                 x.c_code c_code_debt,
                 x.c_name c_name_debt,
                 x.c_doc_date c_date_begin_saldo,
                 sum(x.sum_oper_db*(-1)+x.sum_oper_cr)
                     over (partition by x.id, x.collection_id, x.c_code order by x.c_doc_date rows unbounded preceding) +
                 nvl((select sum(do.c_sum_oper_db*(-1)+do.c_sum_oper_cr)
                    from t_contract_debt_oper do where do.rbo_contract_id = x.id
                     and do.c_code_debt = x.c_code
                     and do.c_date_begin_saldo < cur.rep_date),0)  saldo,
                 x.sum_oper_db,
                 x.sum_oper_cr,
                 1 is_card
            from (
          select /*+ parallel(20)*/
                 trunc(fo.c_doc_date) as c_doc_date, fo.collection_id, kpd.id, kpd.c_num_dog, kpd.c_date_close,
                 sum(case when td.c_dt = 1 then fo.c_summa else 0 end) sum_oper_db,
                 sum(case when td.c_dt = 0 then fo.c_summa else 0 end) sum_oper_cr,
                 vd.c_code, vd.c_name
            from V_RBO_Z#VID_OPER_DOG vod,
                 V_RBO_Z#VID_DEBT vd,
                 V_RBO_Z#TAKE_IN_DEBT td,
                 T_RBO_Z#KAS_PC_FO fo,
                 V_RBO_Z#KAS_PC_DOG kpd
           where vod.c_code_group = 'KAS_PC'
             and vod.c_take_debt = td.collection_id
             and td.c_debt = vd.id
             and fo.collection_id = kpd.c_fo_arr
             and fo.c_vid_oper_ref = vod.id
             and fo.c_doc_state = 'PROV'
             and fo.c_doc_date = cur.rep_date
             and vd.c_code in ('PC_CRED_LIMIT',                                                                                                           --свободный кредитный лимит
                               'PC_CRED','PC_OVRD_CRED','PC_VNB_OVRD_CRED',                                                                               --ОД
                               'PC_OVRD_PRC_CRED','PC_VNB_OVRD_PRC_CRED','PC_VNB_PRC_OVRD_CRED','PC_PRC_CRED','PC_PRC_OVRD_CRED',                         --%
                               'PC_OVERLIMIT','PC_OVRD_OVERLIMIT','PC_VNB_OVRD_OVERLIMIT',                                                                --оверлимит
                               'PC_OVRD_PRC_OVERLIMIT','PC_VNB_OVRD_PRC_OVERLIMIT','PC_VNB_PRC_OVRD_OVERLIMIT','PC_PRC_OVERLIMIT','PC_PRC_OVRD_OVERLIMIT',--% оверлимит
                               'PC_OVERDRAFT','PC_OVRD_OVERDRAFT','PC_VNB_OVRD_OVERDRAFT',                                                                --овердрафт
                               'PC_OVRD_PRC_OVERDRAFT','PC_VNB_OVRD_PRC_OVERDRAFT','PC_VNB_PRC_OVRD_OVERDRAFT','PC_PRC_OVERDRAFT','PC_PRC_OVRD_OVERDRAFT')--% овердрафт
          group by kpd.c_num_dog, kpd.id, kpd.c_date_close,
                fo.collection_id, trunc(fo.c_doc_date), vd.c_code, vd.c_name) x
               union all
               select /*+ parallel(20)*/
                 x.id rbo_contract_id,
                 x.c_code c_code_debt,
                 x.c_name c_name_debt,
                 x.c_doc_date c_date_begin_saldo,
                 sum(x.sum_oper_db*(-1)+x.sum_oper_cr)
                     over (partition by x.id, x.collection_id, x.c_code order by x.c_doc_date rows unbounded preceding) +
                 nvl((select sum(do.c_sum_oper_db*(-1)+do.c_sum_oper_cr)
                    from t_contract_debt_oper do where do.rbo_contract_id = x.id
                     and do.c_code_debt = x.c_code
                     and do.c_date_begin_saldo < cur.rep_date),0)  saldo,
                 x.sum_oper_db,
                 x.sum_oper_cr,
                 1 is_card
            from (
          select
                 trunc(fo.c_doc_date) as c_doc_date, fo.collection_id, kpd.id, kpd.c_num_dog, kpd.c_date_close,
                 sum(case when vod.c_code in ('PC_CALC_PRC_OD_ADD','PC_CALC_PRC_OD_DEL_B','PC_CALC_PRC_RL_ADD','PC_CALC_PRC_RL_DEL_B',
                              'PC_CALC_PRC_RD_ADD','PC_CALC_PRC_RD_DEL_B','PC_CALC_PRC_OVRD_OD_ADD','PC_CALC_PRC_OVRD_OD_DEL_B',
                              'PC_CALC_PRC_OVRD_RL_ADD','PC_CALC_PRC_OVRD_RL_DEL_B','PC_CALC_PRC_OVRD_RD_ADD','PC_CALC_PRC_OVRD_RD_DEL_B')
                          then fo.c_summa else 0 end) sum_oper_cr,
                 sum(case when vod.c_code in ('PC_CALC_PRC_OD_DEL','PC_CALC_PRC_RL_DEL','PC_CALC_PRC_RD_DEL',
                                              'PC_CALC_PRC_OVRD_OD_DEL','PC_CALC_PRC_OVRD_RL_DEL','PC_CALC_PRC_OVRD_RD_DEL')
                          then fo.c_summa else 0 end) sum_oper_db,
                 vd.c_code, vd.c_name
            from V_RBO_Z#VID_OPER_DOG vod,
                 V_RBO_Z#VID_DEBT     vd,
                 T_RBO_Z#KAS_PC_FO    fo,
                 V_RBO_Z#KAS_PC_DOG kpd
           where vod.c_vid_debt = vd.id
             and fo.collection_id = kpd.c_fo_arr
             and fo.c_vid_oper_ref = vod.id
             and fo.c_doc_state = 'PROV'
             and fo.c_doc_date = cur.rep_date
             and vod.c_code in ('PC_CALC_PRC_OD_ADD','PC_CALC_PRC_OD_DEL','PC_CALC_PRC_OD_DEL_B',                   --interest
                                'PC_CALC_PRC_RL_ADD','PC_CALC_PRC_RL_DEL','PC_CALC_PRC_RL_DEL_B',                   --overlimit_interest
                                'PC_CALC_PRC_RD_ADD','PC_CALC_PRC_RD_DEL','PC_CALC_PRC_RD_DEL_B',                   --overdraft_interest
                                'PC_CALC_PRC_OVRD_OD_ADD','PC_CALC_PRC_OVRD_OD_DEL','PC_CALC_PRC_OVRD_OD_DEL_B',    --interest_del
                                'PC_CALC_PRC_OVRD_RL_ADD','PC_CALC_PRC_OVRD_RL_DEL','PC_CALC_PRC_OVRD_RL_DEL_B',    --overlimit_interest_del
                                'PC_CALC_PRC_OVRD_RD_ADD','PC_CALC_PRC_OVRD_RD_DEL','PC_CALC_PRC_OVRD_RD_DEL_B')    --overdraft_interest_del
          group by kpd.c_num_dog, kpd.id, kpd.c_date_close,
                fo.collection_id, trunc(fo.c_doc_date), vd.c_code, vd.c_name) x;
          commit;
          end loop;

        --после того как изменили проводки, необходимо пересчитать задолженность по таким договорам
       --кредитные договора
       delete from T_CONTRACT_DEBT_OPER do
         where do.rbo_contract_id in (select rbo_contract_id from T_CONTRACT_EDIT_OBJ_TMP);
       commit;

       insert /*+ append enable_parallel_dml parallel(20)*/ into T_CONTRACT_DEBT_OPER(rbo_contract_id,c_code_debt,c_name_debt,c_date_begin_saldo,c_summa_saldo,c_sum_oper_db,c_sum_oper_cr,is_card)
       select /*+ parallel(20)*/
              x.id rbo_contract_id,
              x.c_code c_code_debt,
              x.c_name c_name_debt,
              x.c_kas_date_prov c_date_begin_saldo,
              sum(x.sum_oper_db*(-1)+x.sum_oper_cr)
                  over (partition by x.id, x.collection_id, x.c_code order by x.c_kas_date_prov rows unbounded preceding) saldo,
              x.sum_oper_db,
              x.sum_oper_cr,
              0 is_card
         from (select /*+ parallel(20)*/
                      trunc(fo.c_kas_date_prov) as c_kas_date_prov, fo.collection_id, pc.id, pc.c_num_dog, pc.c_date_close,
                      sum(case when td.c_dt = 1 then fo.c_summa else 0 end) sum_oper_db,
                      sum(case when td.c_dt = 0 then fo.c_summa else 0 end) sum_oper_cr,
                      vd.c_code, vd.c_name
                 from u1.V_RBO_Z#VID_OPER_DOG vod,
                      u1.V_RBO_Z#VID_DEBT vd,
                      u1.V_RBO_Z#TAKE_IN_DEBT td,
                      u1.T_RBO_Z#FACT_OPER fo,
                      u1.V_RBO_Z#PR_CRED pc
                where vod.c_code_group = 'КРЕДИТЫ'
                  and vod.c_take_debt = td.collection_id
                  and td.c_debt = vd.id
                  and fo.collection_id = pc.c_list_pay
                  and fo.c_oper = vod.id
                  and fo.c_kas_doc_state = 'PROV'
                  and fo.c_kas_date_prov < d_date_load
                  and vd.c_code in ('КРЕДИТ','ПРОСРОЧ_КРЕДИТ','КРЕД_ВНБ_ПРИБ',
                                    'УЧТЕН_ПРОЦЕНТЫ','ПРОЦ_КРЕД_112','ПРОСРОЧ_ПРОЦЕНТЫ','ПРОСРОЧЕН_ПР_НА_ВНБ','ПРЦ_КРЕД_112_ВНБ',
                                    'ПЛАТА_ВЕДЕНИЕ_ПРОСРОЧ','ПЛАТА_ВЕДЕНИЕ_ПР_ВНБ',
                                    'EK_CRED_OVER','EK_OVR_OVER','EK_OVR_OVER_ВНБ')
                  and pc.id  in (select rbo_contract_id from T_CONTRACT_EDIT_OBJ_TMP)
               group by pc.c_num_dog, pc.id, pc.c_date_close,
                     fo.collection_id, trunc(fo.c_kas_date_prov), vd.c_code, vd.c_name) x
         union all
    select /*+ parallel(20)*/
           x.id rbo_contract_id,
           x.c_code c_code_debt,
           x.c_name c_name_debt,
           x.c_kas_date_prov c_date_begin_saldo,
           sum(x.sum_oper_db*(-1)+x.sum_oper_cr)
               over (partition by x.id, x.collection_id, x.c_code order by x.c_kas_date_prov rows unbounded preceding) saldo,
           x.sum_oper_db,
           x.sum_oper_cr,
           0 is_card
      from (select trunc(fo.c_kas_date_prov) as c_kas_date_prov, fo.collection_id, pc.id, pc.c_num_dog, pc.c_date_close,
                   sum(case when td.c_dt = 1 then fo.c_summa else 0 end) sum_oper_db,
                   sum(case when td.c_dt = 0 then fo.c_summa else 0 end) sum_oper_cr,
                   vd.c_code, vd.c_name
              from u1.V_RBO_Z#VID_OPER_DOG vod,
                   u1.V_RBO_Z#VID_DEBT vd,
                   u1.V_RBO_Z#TAKE_IN_DEBT td,
                   u1.T_RBO_Z#FACT_OPER fo,
                   u1.V_RBO_Z#PR_CRED pc
             where vod.c_code_group = 'КРЕДИТЫ'
               and vod.c_take_debt = td.collection_id
               and td.c_debt = vd.id
               and fo.collection_id = pc.c_list_pay
               and fo.c_oper = vod.id
               and fo.c_kas_doc_state = 'PROV'
               and vd.c_code = 'ПЛАТА_ВЕДЕНИЕ'
               and pc.c_kas_pc_dog_ref is null
               and pc.id in (select rbo_contract_id from T_CONTRACT_EDIT_OBJ_TMP)
               and fo.c_kas_date_prov < d_date_load
            group by pc.c_num_dog, pc.id, pc.c_date_close,
                  fo.collection_id, trunc(fo.c_kas_date_prov), vd.c_code, vd.c_name) x;
      commit;
         --карточные договора
         insert /*+ append enable_parallel_dml parallel(20)*/ into T_CONTRACT_DEBT_OPER(rbo_contract_id,c_code_debt,c_name_debt,c_date_begin_saldo,c_summa_saldo,c_sum_oper_db,c_sum_oper_cr,is_card)
          select /*+ parallel(20)*/
             x.id rbo_contract_id,
             x.c_code c_code_debt,
             x.c_name c_name_debt,
             x.c_doc_date c_date_begin_saldo,
             sum(x.sum_oper_db*(-1)+x.sum_oper_cr)
                 over (partition by x.id, x.collection_id, x.c_code order by x.c_doc_date rows unbounded preceding) saldo,
             x.sum_oper_db,
             x.sum_oper_cr,
             1 is_card
        from (
      select /*+ parallel(20)*/
             trunc(fo.c_doc_date) as c_doc_date, fo.collection_id, kpd.id, kpd.c_num_dog, kpd.c_date_close,
             sum(case when td.c_dt = 1 then fo.c_summa else 0 end) sum_oper_db,
             sum(case when td.c_dt = 0 then fo.c_summa else 0 end) sum_oper_cr,
             vd.c_code, vd.c_name
        from V_RBO_Z#VID_OPER_DOG vod,
             V_RBO_Z#VID_DEBT vd,
             V_RBO_Z#TAKE_IN_DEBT td,
             T_RBO_Z#KAS_PC_FO fo,
             V_RBO_Z#KAS_PC_DOG kpd
       where vod.c_code_group = 'KAS_PC'
         and vod.c_take_debt = td.collection_id
         and td.c_debt = vd.id
         and fo.collection_id = kpd.c_fo_arr
         and fo.c_vid_oper_ref = vod.id
         and fo.c_doc_state = 'PROV'
         and fo.c_doc_date < d_date_load
         and kpd.id in (select rbo_contract_id from T_CONTRACT_EDIT_OBJ_TMP)
         and vd.c_code in ('PC_CRED_LIMIT',                                                                                                           --свободный кредитный лимит
                           'PC_CRED','PC_OVRD_CRED','PC_VNB_OVRD_CRED',                                                                               --ОД
                           'PC_OVRD_PRC_CRED','PC_VNB_OVRD_PRC_CRED','PC_VNB_PRC_OVRD_CRED','PC_PRC_CRED','PC_PRC_OVRD_CRED',                         --%
                           'PC_OVERLIMIT','PC_OVRD_OVERLIMIT','PC_VNB_OVRD_OVERLIMIT',                                                                --оверлимит
                           'PC_OVRD_PRC_OVERLIMIT','PC_VNB_OVRD_PRC_OVERLIMIT','PC_VNB_PRC_OVRD_OVERLIMIT','PC_PRC_OVERLIMIT','PC_PRC_OVRD_OVERLIMIT',--% оверлимит
                           'PC_OVERDRAFT','PC_OVRD_OVERDRAFT','PC_VNB_OVRD_OVERDRAFT',                                                                --овердрафт
                           'PC_OVRD_PRC_OVERDRAFT','PC_VNB_OVRD_PRC_OVERDRAFT','PC_VNB_PRC_OVRD_OVERDRAFT','PC_PRC_OVERDRAFT','PC_PRC_OVRD_OVERDRAFT')--% овердрафт
      group by kpd.c_num_dog, kpd.id, kpd.c_date_close,
            fo.collection_id, trunc(fo.c_doc_date), vd.c_code, vd.c_name) x
         union all
         select /*+ parallel(20)*/
             x.id rbo_contract_id,
             x.c_code c_code_debt,
             x.c_name c_name_debt,
             x.c_doc_date c_date_begin_saldo,
             sum(x.sum_oper_db*(-1)+x.sum_oper_cr)
                 over (partition by x.id, x.collection_id, x.c_code order by x.c_doc_date rows unbounded preceding) saldo,
             x.sum_oper_db,
             x.sum_oper_cr,
             1 is_card
        from (
      select /*+ parallel(20)*/
             trunc(fo.c_doc_date) as c_doc_date, fo.collection_id, kpd.id, kpd.c_num_dog, kpd.c_date_close,
             sum(case when vod.c_code in ('PC_CALC_PRC_OD_ADD','PC_CALC_PRC_OD_DEL_B','PC_CALC_PRC_RL_ADD','PC_CALC_PRC_RL_DEL_B',
                          'PC_CALC_PRC_RD_ADD','PC_CALC_PRC_RD_DEL_B','PC_CALC_PRC_OVRD_OD_ADD','PC_CALC_PRC_OVRD_OD_DEL_B',
                          'PC_CALC_PRC_OVRD_RL_ADD','PC_CALC_PRC_OVRD_RL_DEL_B','PC_CALC_PRC_OVRD_RD_ADD','PC_CALC_PRC_OVRD_RD_DEL_B')
                      then fo.c_summa else 0 end) sum_oper_cr,
             sum(case when vod.c_code in ('PC_CALC_PRC_OD_DEL','PC_CALC_PRC_RL_DEL','PC_CALC_PRC_RD_DEL',
                                          'PC_CALC_PRC_OVRD_OD_DEL','PC_CALC_PRC_OVRD_RL_DEL','PC_CALC_PRC_OVRD_RD_DEL')
                      then fo.c_summa else 0 end) sum_oper_db,
             vd.c_code, vd.c_name
        from V_RBO_Z#VID_OPER_DOG vod,
             V_RBO_Z#VID_DEBT     vd,
             T_RBO_Z#KAS_PC_FO    fo,
             V_RBO_Z#KAS_PC_DOG kpd
       where vod.c_vid_debt = vd.id
         and fo.collection_id = kpd.c_fo_arr
         and fo.c_vid_oper_ref = vod.id
         and fo.c_doc_state = 'PROV'
         and fo.c_doc_date < d_date_load
         and kpd.id in (select rbo_contract_id from T_CONTRACT_EDIT_OBJ_TMP)
         and vod.c_code in ('PC_CALC_PRC_OD_ADD','PC_CALC_PRC_OD_DEL','PC_CALC_PRC_OD_DEL_B',                   --interest
                            'PC_CALC_PRC_RL_ADD','PC_CALC_PRC_RL_DEL','PC_CALC_PRC_RL_DEL_B',                   --overlimit_interest
                            'PC_CALC_PRC_RD_ADD','PC_CALC_PRC_RD_DEL','PC_CALC_PRC_RD_DEL_B',                   --overdraft_interest
                            'PC_CALC_PRC_OVRD_OD_ADD','PC_CALC_PRC_OVRD_OD_DEL','PC_CALC_PRC_OVRD_OD_DEL_B',    --interest_del
                            'PC_CALC_PRC_OVRD_RL_ADD','PC_CALC_PRC_OVRD_RL_DEL','PC_CALC_PRC_OVRD_RL_DEL_B',    --overlimit_interest_del
                            'PC_CALC_PRC_OVRD_RD_ADD','PC_CALC_PRC_OVRD_RD_DEL','PC_CALC_PRC_OVRD_RD_DEL_B')    --overdraft_interest_del
      group by kpd.c_num_dog, kpd.id, kpd.c_date_close,
            fo.collection_id, trunc(fo.c_doc_date), vd.c_code, vd.c_name) x;
         -----------------------------------
        commit;
     --   end loop;



    end ETLT_CONTRACT_DEBT_OPER;
/

