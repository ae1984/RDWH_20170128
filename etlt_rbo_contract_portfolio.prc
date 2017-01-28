create or replace procedure u1.ETLT_RBO_CONTRACT_PORTFOLIO is
  d_rep_begin date;
  d_rep_end  date;
begin
           --определяем последний загруженный месяц
           select max(rep_date)
             into d_rep_begin
             from T_RBO_CONTRACT_PORTFOLIO;  
           --определяем последний рабочий день прошедшего месяца
           select value
             into d_rep_end
             from M_RBO_CALENDAR_VALUE
            where calendar_name = 'LAST_MONTH_DAY'
              and value > d_rep_begin            
              and value < trunc(sysdate);
           --загрузка данных за месяц на последний рабочий день
          insert /*+ append enable_parallel_dml parallel*/
          into T_RBO_CONTRACT_PORTFOLIO
            with dat_pcm as
             (select p.rbo_contract_id,
                     max(p.total_debt) as total_debt_max,
                     max(p.delinq_days) as delinq_days_max,
                     max(p.delinq_days_cli) as delinq_days_cli_max,
                     max(p.delinq_amount) as delinq_amount_max,
                     max(p.is_on_balance) keep(dense_rank last order by p.rep_date) as is_on_balance
                from V_RBO_PORT p
               where p.rep_date <= d_rep_end
               group by p.rbo_contract_id),
            dat_prmref as
             (select rfp.rbo_contract_id,
                     max(rfp.total_debt_plus) as total_debt_plus_max,
                     max(rfp.del_days_plus) as delinq_days_plus_max
                from M_RBO_REFIN_PORT rfp
               where rfp.rep_date <= d_rep_end
               group by rfp.rbo_contract_id),
            dat_prm as
             (select vp.rbo_contract_id,
                     max(vp.total_debt) as total_debt_plus_max,
                     max(vp.delinq_days) as delinq_days_plus_max
                from (select rbo_contract_id, min(min_refin_date) as min_refin_date
                        from M_RBO_CONTR_AFTER_REF_PERCENT
                       where date_change <= d_rep_end
                       group by rbo_contract_id) mr
                join u1.V_RBO_PORT vp
                  on vp.rbo_contract_id = mr.rbo_contract_id
                 and vp.rep_date < mr.min_refin_date
               group by vp.rbo_contract_id),
            dat_pcm_cl as
             (select p.rbo_client_id,
                     max(p.total_debt) as total_debt_max,
                     max(p.delinq_days) as delinq_days_max,
                     max(p.delinq_days_cli) as delinq_days_cli_max,
                     max(p.delinq_amount) as delinq_amount_max
                from V_RBO_PORT p
               where p.rep_date <= d_rep_end
               group by p.rbo_client_id)
              select /*+ parallel(20)*/
                     dp.rep_date,                            --отчетная дата
                     cast(to_char(dp.rep_date,'yyyy - mm') as varchar2(9)) as yy_mm_report, --отчетный месяц в char:yyyy - mm
                     ca.rbo_client_id,                       --id клиента РБО
                     ca.rbo_contract_id,                     --id договора РБО
                     cast(null as number) as rfo_contract_id,                     --нет больше этого поля в источкике
                     ca.rfo_client_id,                       --id клиента РФО
                     ca.contract_number,                     --номер договора
                     ca.start_date_actual,                   --дата начала договора по кредитам, дата установки револьверности по картам
                     to_char(ca.start_date_actual,'yyyy - mm') as yy_mm_start_date_act, --дата начала договора, учитывает дату установки револьверности в формате char: yyyy - mm
                     ca.start_date,                         --дата установки револьверности, если пусто, то дата начала договора
                     to_char(ca.start_date,'yyyy - mm') as yy_mm_start_date, --дата начала договора, учитывает дату установки револьверности в формате char: yyyy - mm
                     ca.debt_begin_date,                    --дата возникновения задолженности
                     case when ca.is_card = 0 then ca.cred_program_code
                          else coalesce(th.programm_code,ca.cred_program_code) 
                     end as cred_program_code,               --программа кредитования(код) на дату отчета(для кредитов не меняется, по картам берем историю)
                     case when ca.is_card = 0 then ca.cred_program_name
                          else coalesce(th.programm_name,ca.cred_program_name) 
                     end as cred_program_name,               --программа кредитования(наименование) на дату отчета(для кредитов не меняется, по картам берем историю)
                     ca.cred_program_code_x,
                     ca.cred_program_name_x,
                     ca.x_dnp_name,                          --наименование курирующего подразделения
                     ca.is_card,                            --тип договора
                     cast (case when lp.refin_rbo_contract_id is not null then 1
                                when lg.rbo_contract_id_to is not null then 2
                                else null end as number) as is_refin_contract,  --признак догова: 1 - рефинансированный договор, 2 - результирующий договор на текущий день
                     cast(case when refp.rbo_contract_id is not null then 1 
                               when rf.rbo_contract_id   is not null then 1
                               else null end as number) as is_ever_refin_contract, --признак рефианасированного или результирующего договора когда либо
                     lp.rbo_contract_id_to,                                                         --id результирующего договора, на котором сейчас рефиананс
                     coalesce(lp.refin_date, lg.refin_date_to)             as refin_date,           --дата начала рефинансирования
                     coalesce(refp.min_refin_date,rf.min_refin_date)       as refin_date_first,     --дата первого рефинансирования
                     coalesce(lp.part_percent,lg.card_gu_percent)          as refin_percent,      --процент от общей задолженности по рефинансируемым и результирующем договорам
                     coalesce(poc.cnt_pmt_plan,pod.cnt_pmt_plan,0)         as ppm,                  --номер планового платежа в этот отчетный период 
                     coalesce(poc.cnt_pmt_plan,pod.cnt_pmt,0)              as num_stmt,             --номер планового платежа с учетом нулевых сумм платежей(номер стейтмента)
                     rp.total_debt                                         as total_debt,           --общая задолженность договора  
                     coalesce(refp.total_debt_plus,rp.total_debt)          as total_debt_x,         --общая рассчитанная задолженности с учетом рефинанса
                     rp.delinq_days                                        as del_days,             --количество дней по договору
                     case when refp.rbo_contract_id is not null then refp.del_days_plus
                          else rp.delinq_days end                          as del_days_x,           --количество дней по с учетом рефинанса    
                     coalesce(rp.total_debt_max, dat_pcm.total_debt_max)       as max_debt_used,        --максимальная задолженность по договору на отчетную дату
                     coalesce(greatest(coalesce(dat_prm.total_debt_plus_max,dat_prmref.total_debt_plus_max),
                                       coalesce(dat_prmref.total_debt_plus_max,dat_prm.total_debt_plus_max)),
                              dat_pcm.total_debt_max)   as max_debt_used_x,      --максимальная задолженность по договору на отчетную дату с учетом рефинанса
                                    
                     dat_pcm.delinq_days_max                                 as del_days_max,         -- макс дней просрочки на исходном договоре
                     coalesce(greatest(coalesce(dat_prm.delinq_days_plus_max,dat_prmref.delinq_days_plus_max),
                                       coalesce(dat_prmref.delinq_days_plus_max,dat_prm.delinq_days_plus_max)),
                              dat_pcm.delinq_days_max)as del_days_max_x,        -- макс дней просрочки с учетом рефинанса,
                     dat_pcm_cl.delinq_days_cli_max                                     as del_days_cli_max,         -- макс дней просрочки на исходном договоре
                     dat_pcm_cl.delinq_days_cli_max                                     as del_days_cli_max_x,        -- макс дней просрочки с учетом рефинанса     
                     case when dat_pcm.is_on_balance = 1 then 'Y'
                          when dat_pcm.is_on_balance = 0 then 'W'
                          when dat_pcm.is_on_balance = 2 then 'I' end as is_on_balance,
                     coalesce(ca.contract_amount,lh.limit_sum_hst) as contract_amount
       
                from u1.M_RBO_CONTRACT_BAS ca
                join (select d_rep_end 
                             as rep_date from dual) dp on 1 = 1
                left join M_RBO_CONTR_REFIN_LINK_PERCENT lp on lp.refin_rbo_contract_id = ca.rbo_contract_id
                                                                  and lp.date_change <= dp.rep_date
                                                                  and coalesce(lp.date_change_end, trunc(sysdate)) >= dp.rep_date      --рефинансированные договора
                left join ( select rbo_contract_id_to, date_change,date_change_end,card_gu_percent, refin_date_to, min_refin_date_to
                              from M_RBO_CONTR_REFIN_LINK_PERCENT 
                             group by rbo_contract_id_to, date_change,date_change_end, card_gu_percent, refin_date_to, min_refin_date_to) lg    --данные по процентам на результируещем договороре 
                                                                  on lg.rbo_contract_id_to = ca.rbo_contract_id
                                                                  and lg.date_change <= dp.rep_date
                                                                  and coalesce(lg.date_change_end, trunc(sysdate)) >= dp.rep_date       
                left join V_RBO_PORT rp         on rp.rbo_contract_id = ca.rbo_contract_id                ---остатки по исходным договорам
                                               and rp.rep_date = dp.rep_date                          
                left join M_RBO_REFIN_PORT refp on refp.rbo_contract_id = ca.rbo_contract_id              ---остатки по рефинансированным/результирующим договорам
                                               and refp.rep_date = dp.rep_date
                --подключаем данные по закрытым договорам
                left join dat_pcm  on dat_pcm.rbo_contract_id = ca.rbo_contract_id
                left join dat_prm  on dat_prm.rbo_contract_id = ca.rbo_contract_id
                left join dat_prmref  on dat_prmref.rbo_contract_id = ca.rbo_contract_id
                left join dat_pcm_cl    on dat_pcm_cl.rbo_client_id = ca.rbo_client_id  
                left join (select rbo_contract_id,
                                  min(min_refin_date) as min_refin_date,
                                  max(refin_date_end) as max_refin_date_end 
                            from ( 
                                  select distinct rbo_contract_id_to as rbo_contract_id, min_refin_date_to as min_refin_date,
                                         coalesce(refin_end_to,to_date('01-01-3000','dd-mm-yyyy')) as refin_date_end
                                    from M_RBO_CONTR_REFIN_LINK_PERCENT
                                   union all
                                  select distinct refin_rbo_contract_id as rbo_contract_id, min_refin_date_to,
                                         coalesce(refin_date_end,to_date('01-01-3000','dd-mm-yyyy')) as refin_date_end
                                    from M_RBO_CONTR_REFIN_LINK_PERCENT)
                            group by  rbo_contract_id) rf on rf.rbo_contract_id = ca.rbo_contract_id
                                                         and rf.min_refin_date <= d_rep_end  
                left join u1.M_RBO_CONTRACT_TP_HIST th on th.rbo_contract_id = ca.rbo_contract_id        --добавляем историю по тарифному плану
                                                      and th.date_begin <= dp.rep_date
                                                      and coalesce(th.date_end,trunc(sysdate)) >= dp.rep_date    
                left join (select distinct 
                                  rbo_contract_id,
                                  max(cnt_pmt_plan) keep (dense_rank first order by is_decl_early_p nulls first)
                                      over (partition by rbo_contract_id) as cnt_pmt_plan
                             from u1.M_RBO_PLAN_OPER_CREDIT
                            where plan_date > d_rep_begin
                              and plan_date <= d_rep_end
                              and nvl(is_decl_early_p,0) != 1) poc on poc.rbo_contract_id = ca.rbo_contract_id  --плановые платежи по кредитам
                left join (select distinct
                                  rbo_contract_id,
                                  max(cnt_pmt_plan) keep (dense_rank first order by is_decl_early_p nulls first)
                                      over (partition by rbo_contract_id) as cnt_pmt_plan,
                                  max(cnt_pmt) keep (dense_rank first order by is_decl_early_p nulls first)
                                      over (partition by rbo_contract_id) as cnt_pmt    
                             from u1.M_RBO_PLAN_OPER_CARD
                            where plan_date > d_rep_begin
                              and plan_date <= d_rep_end
                              ) pod on pod.rbo_contract_id = ca.rbo_contract_id   --плановые платежи по картам
              left join M_CONTRACT_LIMIT_HST lh on lh.rbo_contract_id = ca.rbo_contract_id
                                          and lh.date_begin <= dp.rep_date
                                          and coalesce(lh.date_end,trunc(sysdate)) >= dp.rep_date
                              
               where ca.start_date <= d_rep_end
                 and (coalesce(ca.date_fact_end,trunc(sysdate)) > d_rep_begin
                      or
                      coalesce(rf.max_refin_date_end,trunc(sysdate)) > d_rep_begin); 
                commit;
          --запуск фнкцию проверок
  
end ETLT_RBO_CONTRACT_PORTFOLIO;
/

