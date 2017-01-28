create or replace procedure u1.ETLT_RBO_PORT is
      s_mview_name         varchar2(30) := 'T_RBO_PORT';
      vStrDate             date := sysdate;
      d_max_date_port      date; --дата последней загрузки в t_rbo_port
      d_min_date_load_port date;  --дата минимальной загрузки

      v_user_sqlcode       varchar2(50);
      v_user_sqlerrm       varchar2(200);
      user_exception       exception;
      d_date_load          date := trunc(sysdate);
      --s_client_id          varchar2(100);
    begin

           --определяем последнюю и первую  дату по портфелю
           select max(rp.rep_date)
             into d_max_date_port
             from T_RBO_PORT rp;
           select min(rep_date)
             into d_min_date_load_port
             from T_RBO_PORT rp;
           if d_max_date_port is null or d_min_date_load_port is null then
              v_user_sqlcode := '55555';
              v_user_sqlerrm := 'Не определены даты по t_rbo_port';
              raise user_exception;
           end if;
           --
           begin
           --
           for cur in (select d_max_date_port + level as rep_date
                         from dual
                        where d_max_date_port + level < d_date_load
                      connect by rownum < d_date_load - d_max_date_port
                        order by 1
           ) loop
             --очищаем темповую таблицу
             s_mview_name := 'T_RBO_PORT_TMP';
             execute immediate 'truncate table T_RBO_PORT_TMP';
             --добавляем расчеты по новым датам
             s_mview_name := 'T_RBO_PORT_TMP';
             --244 sec в t_rbo_port_tmp
             insert /*+ APPEND parallel(20)*/ into T_RBO_PORT_TMP
    with dat_contr_max as (select rp.rbo_contract_id,
                                  max(rp.total_debt) as total_debt_max,
                                  max(rp.delinq_days) as delinq_days_max,
                                  max(rp.delinq_amount) as delinq_amount_max,
                                  min(rp.delinq_date)   as delinq_date_min
                             from u1.V_RBO_PORT rp
                            where rp.rep_date < cur.rep_date
                            group by rp.rbo_contract_id),
         dat_cli_max as (select /*+ parallel(20)*/
                                rp.rbo_client_id,
                                max(rp.total_debt_cli) as total_debt_cli_max,
                                max(rp.delinq_days_cli) as del_days_cli_max,
                                max(rp.del_amount_cli) as del_amount_cli_max
                           from u1.V_RBO_PORT rp
                          where rp.rep_date < cur.rep_date
                          group by rp.rbo_client_id)
          select /*+ parallel(20)*/
             md.rep_date,
             md.rbo_contract_id,
             ca.rbo_client_id,
             md.principal,
             md.interest,
             md.overlimit,
             md.overlimit_interest,
             md.overdraft,
             md.overdraft_interest,
             md.principal_del,
             md.interest_del,
             md.overlimit_del,
             md.overlimit_interest_del,
             md.overdraft_del,
             md.overdraft_interest_del,
             md.w_principal_del,
             md.w_interest_del,
             md.w_overlimit_del,
             md.w_overlimit_interest_del,
             md.w_overdraft_del,
             md.w_overdraft_interest_del,
             md.pc_cred_limit,                                            --свободный кредитный лимит
             (md.rep_date - min(coalesce(crd.date_delinq_days,cdd.delinq_date)) + 1) as delinq_days, --количество дней просчроки по договору
             min(coalesce(crd.date_delinq_days,cdd.delinq_date)) as delinq_date,
             (md.rep_date - (min(min(coalesce(crd.date_delinq_days,cdd.delinq_date))) keep (dense_rank first order by min(coalesce(crd.date_delinq_days,cdd.delinq_date)))
                 over (partition by ca.rbo_client_id, md.rep_date)) + 1) as delinq_days_cli,                     --количество дней прсрочки по клиенту
             min(min(coalesce(crd.date_delinq_days,cdd.delinq_date))) keep (dense_rank first order by min(coalesce(crd.date_delinq_days,cdd.delinq_date)))
                 over (partition by ca.rbo_client_id, md.rep_date) as date_delinq_date_cli,
             md.principal+md.interest+md.overlimit+md.overlimit_interest+md.overdraft+md.overdraft_interest+
             md.principal_del+md.interest_del+md.overlimit_del+md.overlimit_interest_del+md.overdraft_del+
             md.overdraft_interest_del+md.w_principal_del+md.w_interest_del+md.w_overlimit_del+md.w_overlimit_interest_del+
             md.w_overdraft_del+md.w_overdraft_interest_del as total_debt,
             md.principal_del+md.interest_del+md.overlimit_del+md.overlimit_interest_del+md.overdraft_del+
             md.overdraft_interest_del as delinq_amount,
             (case when md.is_card = 0 and nvl(so.c_old_schema_overdue,'0') = '1'
                    then 2
                    when (md.w_principal_del+md.w_interest_del+md.w_overlimit_del+md.w_overlimit_interest_del+
                          md.w_overdraft_del+md.w_overdraft_interest_del) !=0
                    then 0
                    else 1
               end) as is_on_balance,
              md.is_card,
              sum(md.principal+md.interest+md.overlimit+md.overlimit_interest+md.overdraft+md.overdraft_interest+
                  md.principal_del+md.interest_del+md.overlimit_del+md.overlimit_interest_del+md.overdraft_del+
                  md.overdraft_interest_del+md.w_principal_del+md.w_interest_del+md.w_overlimit_del+md.w_overlimit_interest_del+
                  md.w_overdraft_del+md.w_overdraft_interest_del) over (partition by ca.rbo_client_id, md.rep_date)          as total_debt_cli,
              sum(md.principal_del+md.interest_del+md.overlimit_del+md.overlimit_interest_del+md.overdraft_del+
                  md.overdraft_interest_del) over (partition by ca.rbo_client_id, md.rep_date)                               as del_amount_cli,
              greatest((md.principal+md.interest+md.overlimit+md.overlimit_interest+md.overdraft+md.overdraft_interest+
                        md.principal_del+md.interest_del+md.overlimit_del+md.overlimit_interest_del+md.overdraft_del+
                        md.overdraft_interest_del+md.w_principal_del+md.w_interest_del+md.w_overlimit_del+md.w_overlimit_interest_del+
                        md.w_overdraft_del+md.w_overdraft_interest_del), nvl(pm.total_debt_max,0)
                       )                                                                                                     as total_debt_max,
              greatest(sum(md.principal+md.interest+md.overlimit+md.overlimit_interest+md.overdraft+md.overdraft_interest+
                           md.principal_del+md.interest_del+md.overlimit_del+md.overlimit_interest_del+md.overdraft_del+
                           md.overdraft_interest_del+md.w_principal_del+md.w_interest_del+md.w_overlimit_del+md.w_overlimit_interest_del+
                           md.w_overdraft_del+md.w_overdraft_interest_del) over (partition by ca.rbo_client_id, md.rep_date),
                       nvl(cm.total_debt_cli_max,0))                                                                         as total_debt_cli_max,
              case when greatest(nvl((md.rep_date - min(coalesce(crd.date_delinq_days,cdd.delinq_date)) + 1),0), nvl(pm.delinq_days_max,0)) = 0
                   then null
                   else greatest(nvl((md.rep_date - min(coalesce(crd.date_delinq_days,cdd.delinq_date)) + 1),0), nvl(pm.delinq_days_max,0)) end as del_days_max,
              case when greatest(nvl((md.rep_date - (min(min(coalesce(crd.date_delinq_days,cdd.delinq_date)))
                                 keep (dense_rank first order by min(coalesce(crd.date_delinq_days,cdd.delinq_date)))
                                 over (partition by ca.rbo_client_id, md.rep_date)) + 1),0), nvl(cm.del_days_cli_max,0)) = 0
                   then null
                   else greatest(nvl((md.rep_date - (min(min(coalesce(crd.date_delinq_days,cdd.delinq_date)))
                                 keep (dense_rank first order by min(coalesce(crd.date_delinq_days,cdd.delinq_date)))
                                 over (partition by ca.rbo_client_id, md.rep_date)) + 1),0), nvl(cm.del_days_cli_max,0)) end              as del_days_cli_max,
              greatest((md.principal_del+md.interest_del+md.overlimit_del+md.overlimit_interest_del+md.overdraft_del+
                        md.overdraft_interest_del),
                       nvl(pm.delinq_amount_max,0))                                                                                       as del_amount_max,
              greatest(sum(md.principal_del+md.interest_del+md.overlimit_del+md.overlimit_interest_del+md.overdraft_del+
                           md.overdraft_interest_del) over (partition by ca.rbo_client_id, md.rep_date),
                       nvl(cm.del_amount_cli_max,0))                                                                                      as del_amount_cli_max
        from (select
                    cur.rep_date as rep_date,
                    mcd.rbo_contract_id,
                    sum(case when mcd.c_code_debt in ('КРЕДИТ','PC_CRED') and sign(mcd.c_summa_saldo) != -1
                                                                                  then mcd.c_summa_saldo else 0 end)                          principal,
                    sum(case when mcd.c_code_debt in ('УЧТЕН_ПРОЦЕНТЫ','PC_PRC_CRED','ПЛАТА_ВЕДЕНИЕ',
                                               'PC_PRC_CRED_ADD')              and sign(mcd.c_summa_saldo) != -1
                                                                                  then mcd.c_summa_saldo else 0 end)              interest,
                    sum(case when mcd.c_code_debt in ('PC_OVERLIMIT') and sign(mcd.c_summa_saldo) != -1
                                                                                  then mcd.c_summa_saldo else 0 end)                              overlimit,
                    sum(case when mcd.c_code_debt in ('PC_PRC_OVERLIMIT','PC_PRC_OVERLIMIT_ADD') and sign(mcd.c_summa_saldo) != -1
                                                                                  then mcd.c_summa_saldo else 0 end)   overlimit_interest,
                    sum(case when mcd.c_code_debt in ('PC_OVERDRAFT','EK_CRED_OVER') and sign(mcd.c_summa_saldo) != -1
                                                                                  then mcd.c_summa_saldo else 0 end)               overdraft,
                    sum(case when mcd.c_code_debt in ('PC_PRC_OVERDRAFT','PC_PRC_OVERDRAFT_ADD')
                                                                   and sign(mcd.c_summa_saldo) != -1
                                                                                  then mcd.c_summa_saldo else 0 end)                          overdraft_interest,

                    sum(case when mcd.c_code_debt in ('ПРОСРОЧ_КРЕДИТ','PC_OVRD_CRED') and sign(mcd.c_summa_saldo) != -1
                                                                                  then mcd.c_summa_saldo else 0 end)             principal_del,
                    sum(case when mcd.c_code_debt in ('ПРОСРОЧ_ПРОЦЕНТЫ','ПРОЦ_КРЕД_112','PC_OVRD_PRC_CRED','PC_PRC_OVRD_CRED',
                                               'ПЛАТА_ВЕДЕНИЕ_ПРОСРОЧ','PC_PRC_OVRD_CRED_ADD')
                                                                                      and sign(mcd.c_summa_saldo) != -1
                                                                                  then mcd.c_summa_saldo else 0 end)       interest_del,
                    sum(case when mcd.c_code_debt in ('PC_OVRD_OVERLIMIT') and sign(mcd.c_summa_saldo) != -1
                                                                                  then mcd.c_summa_saldo else 0 end)                         overlimit_del,
                    sum(case when mcd.c_code_debt in ('PC_OVRD_PRC_OVERLIMIT','PC_PRC_OVRD_OVERLIMIT',
                                               'PC_PRC_OVRD_OVERLIMIT_ADD')       and sign(mcd.c_summa_saldo) != -1
                                                                                  then mcd.c_summa_saldo else 0 end)           overlimit_interest_del,
                    sum(case when mcd.c_code_debt in ('PC_OVRD_OVERDRAFT','EK_OVR_OVER') and sign(mcd.c_summa_saldo) != -1
                                                                                  then mcd.c_summa_saldo else 0 end)           overdraft_del,
                    sum(case when mcd.c_code_debt in ('PC_OVRD_PRC_OVERDRAFT','PC_PRC_OVRD_OVERDRAFT',
                                               'PC_PRC_OVRD_OVERDRAFT_ADD')       and sign(mcd.c_summa_saldo) != -1
                                                                                  then mcd.c_summa_saldo else 0 end)           overdraft_interest_del,

                    sum(case when mcd.c_code_debt in ('КРЕД_ВНБ_ПРИБ','PC_VNB_OVRD_CRED')
                                                                                   and sign(mcd.c_summa_saldo) != -1
                                                                                  then mcd.c_summa_saldo else 0 end)          w_principal_del,
                    sum(case when mcd.c_code_debt in ('ПРОСРОЧЕН_ПР_НА_ВНБ','ПРЦ_КРЕД_112_ВНБ','PC_VNB_OVRD_PRC_CRED',
                                               'PC_VNB_PRC_OVRD_CRED','ПЛАТА_ВЕДЕНИЕ_ПР_ВНБ')
                                                                                   and sign(mcd.c_summa_saldo) != -1
                                                                                  then mcd.c_summa_saldo else 0 end)          w_interest_del,
                    sum(case when mcd.c_code_debt in ('PC_VNB_OVRD_OVERLIMIT') and sign(mcd.c_summa_saldo) != -1
                                                                                  then mcd.c_summa_saldo else 0 end)                     w_overlimit_del,
                    sum(case when mcd.c_code_debt in ('PC_VNB_OVRD_PRC_OVERLIMIT','PC_VNB_PRC_OVRD_OVERLIMIT')
                                                                                            and sign(mcd.c_summa_saldo) != -1
                                                                                  then mcd.c_summa_saldo else 0 end) w_overlimit_interest_del,
                    sum(case when mcd.c_code_debt in ('PC_VNB_OVRD_OVERDRAFT','EK_OVR_OVER_ВНБ') and sign(mcd.c_summa_saldo) != -1
                                                                                  then mcd.c_summa_saldo else 0 end)   w_overdraft_del,
                    sum(case when mcd.c_code_debt in ('PC_VNB_OVRD_PRC_OVERDRAFT','PC_VNB_PRC_OVRD_OVERDRAFT')
                                                                                            and sign(mcd.c_summa_saldo) != -1
                                                                                         then mcd.c_summa_saldo else 0 end) w_overdraft_interest_del,
                    sum(case when mcd.c_code_debt in ('PC_CRED_LIMIT') then mcd.c_summa_saldo else 0 end)                             pc_cred_limit, --свободный кредитный лимит
                    mcd.is_card
              from T_CONTRACT_DEBT_OPER mcd
              where mcd.c_date_begin_saldo = (select max(c_date_begin_saldo)
                                          from T_CONTRACT_DEBT_OPER
                                         where rbo_contract_id = mcd.rbo_contract_id
                                           and c_code_debt = mcd.c_code_debt
                                           and c_date_begin_saldo <= cur.rep_date)
                and mcd.c_date_begin_saldo <= cur.rep_date
              group by mcd.rbo_contract_id, mcd.is_card) md
         join M_RBO_CONTRACT_BAS ca on ca.rbo_contract_id = md.rbo_contract_id
         left join U1.M_CONTR_CRED_DELINQ_DAYS crd on md.rbo_contract_id = crd.rbo_cred_id
                         and md.rep_date >= crd.d_fo
                         and md.rep_date <= crd.d_fo_next
         left join M_CONTRACT_CRED_SCHEMA_OVRD so on so.rbo_contract_id = md.rbo_contract_id
                         and md.rep_date between so.c_date_begin and coalesce(so.c_date_end,cur.rep_date)
         left join M_CONTR_CARD_DELINQ_DAYS cdd on cdd.rbo_contract_id = md.rbo_contract_id
                                               and md.rep_date >= cdd.del_date_begin
                                               and md.rep_date <= coalesce(cdd.del_date_end,cur.rep_date)
         left join dat_contr_max    pm on pm.rbo_contract_id = ca.rbo_contract_id
         left join dat_cli_max      cm on cm.rbo_client_id = ca.rbo_client_id
         where (md.principal+md.interest+md.overlimit+md.overlimit_interest+md.overdraft+md.overdraft_interest+
               md.principal_del+md.interest_del+md.overlimit_del+md.overlimit_interest_del+md.overdraft_del+
               md.overdraft_interest_del+md.w_principal_del+md.w_interest_del+md.w_overlimit_del+md.w_overlimit_interest_del+
               md.w_overdraft_del+md.w_overdraft_interest_del) != 0
         group by md.rep_date,             md.rbo_contract_id,             ca.rbo_client_id,             md.principal,
             md.interest,             md.overlimit,             md.overlimit_interest,             md.overdraft,             md.overdraft_interest,
             md.principal_del,             md.interest_del,             md.overlimit_del,             md.overlimit_interest_del,
             md.overdraft_del,             md.overdraft_interest_del,             md.w_principal_del,             md.w_interest_del,
             md.w_overlimit_del,             md.w_overlimit_interest_del,             md.w_overdraft_del,             md.w_overdraft_interest_del,
             md.pc_cred_limit, md.is_card, so.c_old_schema_overdue, pm.total_debt_max, cm.total_debt_cli_max, pm.delinq_days_max, cm.del_days_cli_max,
             pm.delinq_amount_max, cm.del_amount_cli_max;
          ---------------------------------------------------------------
          commit;

          ---делаем саму вставку в T_RBO_PORT
          s_mview_name := 'T_RBO_PORT';
          insert /*+ append enable_parallel_dml parallel(10) */ into T_RBO_PORT
          select /*+ parallel(20)*/*
          from T_RBO_PORT_TMP;
          commit;
       end loop;

         --после того как изменили проводки, необходимо пересчитать портфель по всем таким договорам,
         --но пересчет делаем по клиенту, так как есть поля, которые надо просчитать по клиенту
          /*for cur in (
                     select distinct pc.c_client
                       from T_RBO_Z#KAS_EDIT_OBJ_TMP ke,
                            T_RBO_Z#FACT_OPER fo,
                            v_rbo_z#pr_cred pc
                      where ke.c_class_object = 'FACT_OPER'
                        and ke.c_status = 0
                        and ke.c_id_object = fo.id
                        and fo.collection_id = pc.c_list_pay
                     union
                    select distinct pc.c_client_ref
                      from T_RBO_Z#KAS_EDIT_OBJ_TMP ke,
                           T_RBO_Z#KAS_PC_FO fo,
                           V_RBO_Z#KAS_PC_DOG pc
                     where ke.c_class_object = 'KAS_PC_FO'
                       and ke.c_status = 0
                       and ke.c_id_object = fo.id
                       and fo.collection_id = pc.c_fo_arr) loop*/
   /*select max(rp.rep_date)
     into d_max_date_port
     from T_RBO_PORT rp;

  delete from t_rbo_port where rbo_client_id in (select distinct rbo_client_id from T_CONTRACT_EDIT_OBJ_TMP);
  commit;*/
          --s_client_id := cur.c_client;
  /*execute immediate 'truncate table T_RBO_PORT_TMP';
  insert \*+ APPEND parallel(20)*\ into T_RBO_PORT_TMP
  with dat_contr_max as (select \*+ parallel(20)*\
                                rp.rbo_contract_id,
                                max(rp.total_debt) as total_debt_max,
                                max(rp.delinq_days) as delinq_days_max,
                                max(rp.delinq_amount) as delinq_amount_max
                           from (select rbo_contract_id, total_debt, delinq_days, delinq_amount from t_rbo_port_2009
                                  where rbo_client_id  in (select distinct rbo_client_id from T_CONTRACT_EDIT_OBJ_TMP) union all
                                 select rbo_contract_id, total_debt, delinq_days, delinq_amount from t_rbo_port_2010
                                  where rbo_client_id in (select distinct rbo_client_id from T_CONTRACT_EDIT_OBJ_TMP) union all
                                 select rbo_contract_id, total_debt, delinq_days, delinq_amount from t_rbo_port_2011
                                  where rbo_client_id in (select distinct rbo_client_id from T_CONTRACT_EDIT_OBJ_TMP) union all
                                 select rbo_contract_id, total_debt, delinq_days, delinq_amount from t_rbo_port_2012
                                  where rbo_client_id in (select distinct rbo_client_id from T_CONTRACT_EDIT_OBJ_TMP) union all
                                 select rbo_contract_id, total_debt, delinq_days, delinq_amount from t_rbo_port_2013
                                  where rbo_client_id in (select distinct rbo_client_id from T_CONTRACT_EDIT_OBJ_TMP) ) rp
                        group by rp.rbo_contract_id),
       dat_cli_max as (select \*+ parallel(20)*\
                              rp.rbo_client_id,
                              max(rp.total_debt_cli) as total_debt_cli_max,
                              max(rp.delinq_days_cli) as del_days_cli_max,
                              max(rp.del_amount_cli) as del_amount_cli_max
                         from (select rbo_client_id, total_debt_cli, delinq_days_cli, del_amount_cli from t_rbo_port_2009
                                  where rbo_client_id in (select distinct rbo_client_id from T_CONTRACT_EDIT_OBJ_TMP) union all
                               select rbo_client_id, total_debt_cli, delinq_days_cli, del_amount_cli from t_rbo_port_2010
                                  where rbo_client_id in (select distinct rbo_client_id from T_CONTRACT_EDIT_OBJ_TMP) union all
                               select rbo_client_id, total_debt_cli, delinq_days_cli, del_amount_cli from t_rbo_port_2011
                                  where rbo_client_id in (select distinct rbo_client_id from T_CONTRACT_EDIT_OBJ_TMP) union all
                               select rbo_client_id, total_debt_cli, delinq_days_cli, del_amount_cli from t_rbo_port_2012
                                  where rbo_client_id in (select distinct rbo_client_id from T_CONTRACT_EDIT_OBJ_TMP) union all
                               select rbo_client_id, total_debt_cli, delinq_days_cli, del_amount_cli from t_rbo_port_2013
                                  where rbo_client_id in (select distinct rbo_client_id from T_CONTRACT_EDIT_OBJ_TMP))rp
                        group by rp.rbo_client_id)
  select xx.rep_date,
         xx.rbo_contract_id,
         xx.rbo_client_id,
         xx.principal,
         xx.interest,
         xx.overlimit,
         xx.overlimit_interest,
         xx.overdraft,
         xx.overdraft_interest,
         xx.principal_del,
         xx.interest_del,
         xx.overlimit_del,
         xx.overlimit_interest_del,
         xx.overdraft_del,
         xx.overdraft_interest_del,
         xx.w_principal_del,
         xx.w_interest_del,
         xx.w_overlimit_del,
         xx.w_overlimit_interest_del,
         xx.w_overdraft_del,
         xx.w_overdraft_interest_del,
         xx.pc_cred_limit,                                            --свободный кредитный лимит
         xx.delinq_days, --количество дней просчроки по договору
         xx.delinq_date,
         xx.delinq_days_cli,                     --количество дней прсрочки по клиенту
         xx.date_delinq_date_cli,
         xx.total_debt,
         xx.delinq_amount,
         xx.is_on_balance,
         xx.is_card,
         xx.total_debt_cli,
         xx.del_amount_cli,
         greatest(max(xx.total_debt) over (partition by xx.rbo_contract_id order by xx.rep_date rows unbounded preceding),
                  nvl(pm.total_debt_max,0))                                                                                 as total_debt_max,
         greatest(max(xx.total_debt_cli) over (partition by xx.rbo_client_id   order by xx.rep_date rows unbounded preceding),
                  nvl(cm.total_debt_cli_max,0))                                                                             as total_debt_cli_max,
         case when greatest(max(nvl(xx.delinq_days,0)) over (partition by xx.rbo_contract_id order by xx.rep_date rows unbounded preceding),
                            nvl(pm.delinq_days_max,0)) = 0
              then null
              else greatest(max(nvl(xx.delinq_days,0)) over (partition by xx.rbo_contract_id order by xx.rep_date rows unbounded preceding),
                            nvl(pm.delinq_days_max,0)) end                                                                   as del_days_max,

         case when greatest(max(nvl(xx.delinq_days_cli,0)) over (partition by xx.rbo_client_id   order by xx.rep_date rows unbounded preceding),
                            nvl(cm.del_days_cli_max,0)) = 0
              then null
              else greatest(max(nvl(xx.delinq_days_cli,0)) over (partition by xx.rbo_client_id   order by xx.rep_date rows unbounded preceding),
                            nvl(cm.del_days_cli_max,0)) end                                                                  as del_days_cli_max,
         greatest(max(xx.delinq_amount) over (partition by xx.rbo_contract_id order by xx.rep_date rows unbounded preceding),
                  nvl(pm.delinq_amount_max,0))                                                                               as del_amount_max,
         greatest(max(xx.del_amount_cli) over (partition by xx.rbo_client_id order by xx.rep_date rows unbounded preceding),
                  nvl(cm.del_amount_cli_max,0))                                                                              as del_amount_cli_max
    from (
        select \*+ parallel(20)*\
               md.rep_date,
               md.rbo_contract_id,
               md.rbo_client_id,
               md.principal,
               md.interest,
               md.overlimit,
               md.overlimit_interest,
               md.overdraft,
               md.overdraft_interest,
               md.principal_del,
               md.interest_del,
               md.overlimit_del,
               md.overlimit_interest_del,
               md.overdraft_del,
               md.overdraft_interest_del,
               md.w_principal_del,
               md.w_interest_del,
               md.w_overlimit_del,
               md.w_overlimit_interest_del,
               md.w_overdraft_del,
               md.w_overdraft_interest_del,
               md.pc_cred_limit,                                            --свободный кредитный лимит
               (md.rep_date - min(coalesce(crd.date_delinq_days,cdd.delinq_date)) + 1) as delinq_days, --количество дней просчроки по договору
               min(coalesce(crd.date_delinq_days,cdd.delinq_date)) as delinq_date,
               (md.rep_date - (min(min(coalesce(crd.date_delinq_days,cdd.delinq_date))) keep (dense_rank first order by min(coalesce(crd.date_delinq_days,cdd.delinq_date)))
                   over (partition by md.rbo_client_id, md.rep_date)) + 1) as delinq_days_cli,                     --количество дней прсрочки по клиенту
               min(min(coalesce(crd.date_delinq_days,cdd.delinq_date))) keep (dense_rank first order by min(coalesce(crd.date_delinq_days,cdd.delinq_date)))
                   over (partition by md.rbo_client_id, md.rep_date) as date_delinq_date_cli,
               md.principal+md.interest+md.overlimit+md.overlimit_interest+md.overdraft+md.overdraft_interest+
               md.principal_del+md.interest_del+md.overlimit_del+md.overlimit_interest_del+md.overdraft_del+
               md.overdraft_interest_del+md.w_principal_del+md.w_interest_del+md.w_overlimit_del+md.w_overlimit_interest_del+
               md.w_overdraft_del+md.w_overdraft_interest_del as total_debt,
               md.principal_del+md.interest_del+md.overlimit_del+md.overlimit_interest_del+md.overdraft_del+
               md.overdraft_interest_del as delinq_amount,
               (case when md.is_card = 0 and nvl(so.c_old_schema_overdue,'0') = '1'
                      then 2
                      when (md.w_principal_del+md.w_interest_del+md.w_overlimit_del+md.w_overlimit_interest_del+
                            md.w_overdraft_del+md.w_overdraft_interest_del) !=0
                      then 0
                      else 1
                 end) as is_on_balance,
                md.is_card,
                sum(md.principal+md.interest+md.overlimit+md.overlimit_interest+md.overdraft+md.overdraft_interest+
                    md.principal_del+md.interest_del+md.overlimit_del+md.overlimit_interest_del+md.overdraft_del+
                    md.overdraft_interest_del+md.w_principal_del+md.w_interest_del+md.w_overlimit_del+md.w_overlimit_interest_del+
                    md.w_overdraft_del+md.w_overdraft_interest_del) over (partition by md.rbo_client_id, md.rep_date)          as total_debt_cli,
                sum(md.principal_del+md.interest_del+md.overlimit_del+md.overlimit_interest_del+md.overdraft_del+
                    md.overdraft_interest_del) over (partition by md.rbo_client_id, md.rep_date)                               as del_amount_cli
          from (select
                      vtd.calendar_date as rep_date,
                      mcd.rbo_contract_id,
                      ca.rbo_client_id,
                      sum(case when mcd.c_code_debt in ('КРЕДИТ','PC_CRED') and sign(mcd.c_summa_saldo) != -1
                                                                                    then mcd.c_summa_saldo else 0 end)                          principal,
                      sum(case when mcd.c_code_debt in ('УЧТЕН_ПРОЦЕНТЫ','PC_PRC_CRED','ПЛАТА_ВЕДЕНИЕ',
                                                 'PC_PRC_CRED_ADD')              and sign(mcd.c_summa_saldo) != -1
                                                                                    then mcd.c_summa_saldo else 0 end)              interest,
                      sum(case when mcd.c_code_debt in ('PC_OVERLIMIT') and sign(mcd.c_summa_saldo) != -1
                                                                                    then mcd.c_summa_saldo else 0 end)                              overlimit,
                      sum(case when mcd.c_code_debt in ('PC_PRC_OVERLIMIT','PC_PRC_OVERLIMIT_ADD') and sign(mcd.c_summa_saldo) != -1
                                                                                    then mcd.c_summa_saldo else 0 end)   overlimit_interest,
                      sum(case when mcd.c_code_debt in ('PC_OVERDRAFT','EK_CRED_OVER') and sign(mcd.c_summa_saldo) != -1
                                                                                    then mcd.c_summa_saldo else 0 end)               overdraft,
                      sum(case when mcd.c_code_debt in ('PC_PRC_OVERDRAFT','PC_PRC_OVERDRAFT_ADD')
                                                                     and sign(mcd.c_summa_saldo) != -1
                                                                                    then mcd.c_summa_saldo else 0 end)                          overdraft_interest,

                      sum(case when mcd.c_code_debt in ('ПРОСРОЧ_КРЕДИТ','PC_OVRD_CRED') and sign(mcd.c_summa_saldo) != -1
                                                                                    then mcd.c_summa_saldo else 0 end)             principal_del,
                      sum(case when mcd.c_code_debt in ('ПРОСРОЧ_ПРОЦЕНТЫ','ПРОЦ_КРЕД_112','PC_OVRD_PRC_CRED','PC_PRC_OVRD_CRED',
                                                 'ПЛАТА_ВЕДЕНИЕ_ПРОСРОЧ','PC_PRC_OVRD_CRED_ADD')
                                                                                        and sign(mcd.c_summa_saldo) != -1
                                                                                    then mcd.c_summa_saldo else 0 end)       interest_del,
                      sum(case when mcd.c_code_debt in ('PC_OVRD_OVERLIMIT') and sign(mcd.c_summa_saldo) != -1
                                                                                    then mcd.c_summa_saldo else 0 end)                         overlimit_del,
                      sum(case when mcd.c_code_debt in ('PC_OVRD_PRC_OVERLIMIT','PC_PRC_OVRD_OVERLIMIT',
                                                 'PC_PRC_OVRD_OVERLIMIT_ADD')       and sign(mcd.c_summa_saldo) != -1
                                                                                    then mcd.c_summa_saldo else 0 end)           overlimit_interest_del,
                      sum(case when mcd.c_code_debt in ('PC_OVRD_OVERDRAFT','EK_OVR_OVER') and sign(mcd.c_summa_saldo) != -1
                                                                                    then mcd.c_summa_saldo else 0 end)           overdraft_del,
                      sum(case when mcd.c_code_debt in ('PC_OVRD_PRC_OVERDRAFT','PC_PRC_OVRD_OVERDRAFT',
                                                 'PC_PRC_OVRD_OVERDRAFT_ADD')       and sign(mcd.c_summa_saldo) != -1
                                                                                    then mcd.c_summa_saldo else 0 end)           overdraft_interest_del,

                      sum(case when mcd.c_code_debt in ('КРЕД_ВНБ_ПРИБ','PC_VNB_OVRD_CRED')
                                                                                     and sign(mcd.c_summa_saldo) != -1
                                                                                    then mcd.c_summa_saldo else 0 end)          w_principal_del,
                      sum(case when mcd.c_code_debt in ('ПРОСРОЧЕН_ПР_НА_ВНБ','ПРЦ_КРЕД_112_ВНБ','PC_VNB_OVRD_PRC_CRED',
                                                 'PC_VNB_PRC_OVRD_CRED','ПЛАТА_ВЕДЕНИЕ_ПР_ВНБ')
                                                                                     and sign(mcd.c_summa_saldo) != -1
                                                                                    then mcd.c_summa_saldo else 0 end)          w_interest_del,
                      sum(case when mcd.c_code_debt in ('PC_VNB_OVRD_OVERLIMIT') and sign(mcd.c_summa_saldo) != -1
                                                                                    then mcd.c_summa_saldo else 0 end)                     w_overlimit_del,
                      sum(case when mcd.c_code_debt in ('PC_VNB_OVRD_PRC_OVERLIMIT','PC_VNB_PRC_OVRD_OVERLIMIT')
                                                                                              and sign(mcd.c_summa_saldo) != -1
                                                                                    then mcd.c_summa_saldo else 0 end) w_overlimit_interest_del,
                      sum(case when mcd.c_code_debt in ('PC_VNB_OVRD_OVERDRAFT','EK_OVR_OVER_ВНБ') and sign(mcd.c_summa_saldo) != -1
                                                                                    then mcd.c_summa_saldo else 0 end)   w_overdraft_del,
                      sum(case when mcd.c_code_debt in ('PC_VNB_OVRD_PRC_OVERDRAFT','PC_VNB_PRC_OVRD_OVERDRAFT')
                                                                                              and sign(mcd.c_summa_saldo) != -1
                                                                                           then mcd.c_summa_saldo else 0 end) w_overdraft_interest_del,
                      sum(case when mcd.c_code_debt in ('PC_CRED_LIMIT') then mcd.c_summa_saldo else 0 end)                             pc_cred_limit, --свободный кредитный лимит
                      mcd.is_card
                from T_CONTRACT_DEBT_OPER mcd
                join M_RBO_CONTRACT_BAS ca on ca.rbo_contract_id = mcd.rbo_contract_id
                join (select currdate calendar_date from (select level n,
                            d_min_date_load_port - 1 + numtodsinterval(level,'day') as currdate
                        from dual
                      connect by rownum <= d_max_date_port - d_min_date_load_port + 1)
                      ) vtd on mcd.c_date_begin_saldo <= vtd.calendar_date
                where mcd.c_date_begin_saldo = (select max(c_date_begin_saldo)
                                                  from T_CONTRACT_DEBT_OPER
                                                 where rbo_contract_id = mcd.rbo_contract_id
                                                   and c_code_debt = mcd.c_code_debt
                                                   and c_date_begin_saldo <= vtd.calendar_date)
                 and ca.rbo_client_id in (select  rbo_client_id from T_CONTRACT_EDIT_OBJ_TMP)
               group by mcd.rbo_contract_id, ca.rbo_client_id, mcd.is_card, vtd.calendar_date) md
           left join U1.M_CONTR_CRED_DELINQ_DAYS crd on md.rbo_contract_id = crd.rbo_cred_id
                           and md.rep_date >= crd.d_fo
                           and md.rep_date <= crd.d_fo_next
           left join M_CONTRACT_CRED_SCHEMA_OVRD so on so.rbo_contract_id = md.rbo_contract_id
                           and md.rep_date between so.c_date_begin and coalesce(so.c_date_end,md.rep_date)
           left join M_CONTR_CARD_DELINQ_DAYS cdd on cdd.rbo_contract_id = md.rbo_contract_id
                                                 and md.rep_date >= cdd.del_date_begin
                                                 and md.rep_date <= coalesce(cdd.del_date_end,md.rep_date)
           where (md.principal+md.interest+md.overlimit+md.overlimit_interest+md.overdraft+md.overdraft_interest+
                 md.principal_del+md.interest_del+md.overlimit_del+md.overlimit_interest_del+md.overdraft_del+
                 md.overdraft_interest_del+md.w_principal_del+md.w_interest_del+md.w_overlimit_del+md.w_overlimit_interest_del+
                 md.w_overdraft_del+md.w_overdraft_interest_del) != 0
           group by md.rep_date,             md.rbo_contract_id,    md.rbo_client_id,             md.principal,
               md.interest,             md.overlimit,             md.overlimit_interest,             md.overdraft,             md.overdraft_interest,
               md.principal_del,             md.interest_del,             md.overlimit_del,             md.overlimit_interest_del,
               md.overdraft_del,             md.overdraft_interest_del,             md.w_principal_del,             md.w_interest_del,
               md.w_overlimit_del,             md.w_overlimit_interest_del,             md.w_overdraft_del,             md.w_overdraft_interest_del,
               md.pc_cred_limit, md.is_card, so.c_old_schema_overdue) xx
   left join dat_contr_max    pm on pm.rbo_contract_id = xx.rbo_contract_id
   left join dat_cli_max      cm on cm.rbo_client_id   = xx.rbo_client_id;
   commit;
   --s_client_id := null;
      --    end loop;

   delete from t_rbo_port where rbo_client_id in (select  rbo_client_id from T_CONTRACT_EDIT_OBJ_TMP);
   commit;
   insert \*+ append enable_parallel_dml parallel(10) *\ into T_RBO_PORT
   select \*+ parallel(20)*\*
   from T_RBO_PORT_TMP;
   commit;

      --после тог как все сделали, меняем статус
     update t_rbo_z#kas_edit_obj_tmp
        set c_status = 1
       where c_class_object in ('FACT_OPER','KAS_PC_FO')
         and c_status = 0;
      commit;*/

   end;
    end ETLT_RBO_PORT;
/

