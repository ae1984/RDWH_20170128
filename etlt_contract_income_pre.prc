create or replace procedure u1.ETLT_CONTRACT_INCOME_PRE is
     s_mview_name         varchar2(30) := 'T_CONTRACT_INCOME_PRE';
     vStrDate             date := sysdate;
     d_date_income_max    date;
     d_date_load          date := trunc(sysdate);
   begin


     --определяем последнюю загруженную дату
     select max(date_oper)
       into d_date_income_max
       from T_CONTRACT_INCOME_PRE
      where is_card = 0;
      for cur in (select d_date_income_max + level as rep_date
                    from dual
                   where d_date_income_max + level < d_date_load
                 connect by rownum < d_date_load - d_date_income_max
                   order by 1) loop

      --enable_parallel_dml parallel
     insert /*+ append */ into  T_CONTRACT_INCOME_PRE
     select /*+ parallel(20)*/
            pc.id                     as rbo_contract_id,
            trunc(fo.c_kas_date_prov) as date_oper,
            sum(case when vd.c_code in ('КРЕДИТ','ПРОСРОЧ_КРЕДИТ','КРЕД_ВНБ_ПРИБ','EK_CRED_OVER','EK_OVR_OVER',
                                    'EK_OVR_OVER_ВНБ') then fo.c_summa else 0 end)                           as principal,
            sum(case when vd.c_code in ('УЧТЕН_ПРОЦЕНТЫ','ПРОЦ_КРЕД_112','ПРОСРОЧ_ПРОЦЕНТЫ','ПРОСРОЧЕН_ПР_НА_ВНБ',
                                    'ПРЦ_КРЕД_112_ВНБ') then fo.c_summa else 0 end)                          as interest,
            sum(case when vd.c_code in ('ПЛАТА_ВЕДЕНИЕ_ПРОСРОЧ','ПЛАТА_ВЕДЕНИЕ_ПР_ВНБ','ПЛАТА_ВЕДЕНИЕ',
                                    'COM_EARLY_P') then fo.c_summa else 0 end)                               as commiss,
            sum(case when vd.c_code in ('ПЕНЯ_ЗА_ВЕДЕНИЕ','ПЕНЯ_КРЕДИТ','ПЕНЯ_ПРОЦЕНТЫ')
                                                   then fo.c_summa else 0 end)                               as fine,
            0 as is_card
       from
            u1.V_RBO_Z#VID_DEBT vd,
            u1.V_RBO_Z#TAKE_IN_DEBT td,
            u1.V_RBO_Z#VID_OPER_DOG vod,
            u1.T_RBO_Z#FACT_OPER fo,
            u1.V_RBO_Z#PR_CRED pc
      where vod.c_code_group = 'КРЕДИТЫ'
        and vod.c_take_debt = td.collection_id
        and td.c_debt = vd.id
        and td.c_dt = 1
        and vod.sys_name like '%ГАШ%' --v_rbo_z#vid_oper_dog.c_kas_signs_arr после общения с Бондаренко возможно выравнят справочник? не везде заполнен этот признак
        and fo.collection_id = pc.c_list_pay
        and fo.c_oper = vod.id
        and fo.c_kas_doc_state = 'PROV'
        and fo.c_kas_date_prov = cur.rep_date
        and fo.c_kas_date_prov < d_date_load
        and vd.c_code in ('КРЕДИТ','ПРОСРОЧ_КРЕДИТ','КРЕД_ВНБ_ПРИБ',
                          'УЧТЕН_ПРОЦЕНТЫ','ПРОЦ_КРЕД_112','ПРОСРОЧ_ПРОЦЕНТЫ','ПРОСРОЧЕН_ПР_НА_ВНБ','ПРЦ_КРЕД_112_ВНБ',
                          'ПЛАТА_ВЕДЕНИЕ_ПРОСРОЧ','ПЛАТА_ВЕДЕНИЕ_ПР_ВНБ','ПЛАТА_ВЕДЕНИЕ',
                          'EK_CRED_OVER','EK_OVR_OVER','EK_OVR_OVER_ВНБ',
                          'COM_EARLY_P','ПЕНЯ_ЗА_ВЕДЕНИЕ','ПЕНЯ_КРЕДИТ','ПЕНЯ_ПРОЦЕНТЫ')
        and not exists
        (select 1 from u1.T_RBO_Z#FACT_OPER where id = fo.c_reverse_fo
           and c_kas_doc_state = 'PROV')
      group by pc.id, trunc(fo.c_kas_date_prov);
      commit;
      end loop;


       delete from T_CONTRACT_INCOME_PRE do where do.rbo_contract_id in (select rbo_contract_id from T_CONTRACT_EDIT_OBJ_TMP);
       commit;
       --enable_parallel_dml parallel
       insert /*+ append */ into  T_CONTRACT_INCOME_PRE
       select /*+ parallel(20)*/
              pc.id                     as rbo_contract_id,
              trunc(fo.c_kas_date_prov) as date_oper,
              sum(case when vd.c_code in ('КРЕДИТ','ПРОСРОЧ_КРЕДИТ','КРЕД_ВНБ_ПРИБ','EK_CRED_OVER','EK_OVR_OVER',
                                      'EK_OVR_OVER_ВНБ') then fo.c_summa else 0 end)                           as principal,
              sum(case when vd.c_code in ('УЧТЕН_ПРОЦЕНТЫ','ПРОЦ_КРЕД_112','ПРОСРОЧ_ПРОЦЕНТЫ','ПРОСРОЧЕН_ПР_НА_ВНБ',
                                      'ПРЦ_КРЕД_112_ВНБ') then fo.c_summa else 0 end)                          as interest,
              sum(case when vd.c_code in ('ПЛАТА_ВЕДЕНИЕ_ПРОСРОЧ','ПЛАТА_ВЕДЕНИЕ_ПР_ВНБ','ПЛАТА_ВЕДЕНИЕ',
                                      'COM_EARLY_P') then fo.c_summa else 0 end)                               as commiss,
              sum(case when vd.c_code in ('ПЕНЯ_ЗА_ВЕДЕНИЕ','ПЕНЯ_КРЕДИТ','ПЕНЯ_ПРОЦЕНТЫ')
                                                     then fo.c_summa else 0 end)                               as fine,
              0 as is_card
         from
              u1.V_RBO_Z#VID_DEBT vd,
              u1.V_RBO_Z#TAKE_IN_DEBT td,
              u1.V_RBO_Z#VID_OPER_DOG vod,
              u1.T_RBO_Z#FACT_OPER fo,
              u1.V_RBO_Z#PR_CRED pc
        where vod.c_code_group = 'КРЕДИТЫ'
          and vod.c_take_debt = td.collection_id
          and td.c_debt = vd.id
          and td.c_dt = 1
          and vod.sys_name like '%ГАШ%' --v_rbo_z#vid_oper_dog.c_kas_signs_arr после общения с Бондаренко возможно выравнят справочник? не везде заполнен этот признак
          and fo.collection_id = pc.c_list_pay
          and fo.c_oper = vod.id
          and fo.c_kas_doc_state = 'PROV'
          and pc.id in (select rbo_contract_id from T_CONTRACT_EDIT_OBJ_TMP)
          and fo.c_kas_date_prov < d_date_load
          and vd.c_code in ('КРЕДИТ','ПРОСРОЧ_КРЕДИТ','КРЕД_ВНБ_ПРИБ',
                            'УЧТЕН_ПРОЦЕНТЫ','ПРОЦ_КРЕД_112','ПРОСРОЧ_ПРОЦЕНТЫ','ПРОСРОЧЕН_ПР_НА_ВНБ','ПРЦ_КРЕД_112_ВНБ',
                            'ПЛАТА_ВЕДЕНИЕ_ПРОСРОЧ','ПЛАТА_ВЕДЕНИЕ_ПР_ВНБ','ПЛАТА_ВЕДЕНИЕ',
                            'EK_CRED_OVER','EK_OVR_OVER','EK_OVR_OVER_ВНБ',
                            'COM_EARLY_P','ПЕНЯ_ЗА_ВЕДЕНИЕ','ПЕНЯ_КРЕДИТ','ПЕНЯ_ПРОЦЕНТЫ')
          and not exists
          (select 1 from u1.T_RBO_Z#FACT_OPER where id = fo.c_reverse_fo
             and c_kas_doc_state = 'PROV')
        group by pc.id, trunc(fo.c_kas_date_prov);
        commit;
       --end loop;

  end ETLT_CONTRACT_INCOME_PRE;
/

