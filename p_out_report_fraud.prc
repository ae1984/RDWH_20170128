create or replace procedure u1.P_OUT_REPORT_FRAUD(p_result out number,
                                               p_error  out varchar2)
is
 d_date_load date; --дата последнего рабочего дня прошлого месяца - дата загрузки
 d_date_max  date; --послденняя загруженная дата
 n_result    number;
begin
  execute immediate 'alter session enable parallel dml';
   select max(value)
    into d_date_load
    from M_RBO_CALENDAR_VALUE
   where calendar_name = 'LAST_MONTH_DAY'      
     and value < trunc(sysdate);
-----------------------КРАЖА ТЕРМИНАЛА------------------------------------
  --последняя загруженная дата
  select max(trunc(c_date_prov))
    into d_date_max
    from t_out_report_fraud
   where type_report in ('КРАЖА ТЕРМИНАЛА');
  p_error := substr(p_error||'КРАЖА ТЕРМИНАЛА='||to_char(d_date_max,'dd-mm-yyyy'),1,2000);
  --грузим будет с даты d_date_max+1
  insert /*+ append enable_parallel_dml parallel */ into T_OUT_REPORT_FRAUD
  select /*+ parallel(15)*/
       cast('КРАЖА ТЕРМИНАЛА' as varchar2(500)) as type_report,
       af.c_main_v_id, 
       af.c_name, 
       to_char(coalesce(h.first_work_day,md.c_date_doc),'mm-yyyy') as mm_yyyy_report_date,
       coalesce(h.first_work_day,md.c_date_doc) as c_date_doc_x,
       md.c_date_prov,
       md.c_nazn,
       md.c_sum,
       fm.c_cur_short as valuta,
       cast('ДЕБЕТ' as varchar2(100)) as is_db_kt,
       cast(replace(coalesce(cr.c_code,regexp_substr(md.c_nazn,'PT[[:digit:]]*',1),regexp_substr(md.c_nazn,'РТ[[:digit:]]*',1)),
                    'РТ','PT') as varchar2(2000)) as comments,
       substr(pu.c_num,1,4),
       null,
       null,
       td.quarter            
  from T_RBO_Z#AC_FIN af
  join V_RBO_Z#PL_USV             pu on pu.id = af.c_main_usv
  join T_RBO_Z#MAIN_DOCUM_FRAUD   md on md.c_acc_dt = af.id
  join V_RBO_Z#FT_MONEY           fm on fm.id = md.c_valuta
  left join T_RBO_Z#KAS_ACASH_DOC ad on ad.c_quit_doc_ref = md.id
  left join V_RBO_Z#KAS_CASH_REG  cr on cr.id = ad.c_device
  left join V_TIME_HOLIDAYS        h on h.holiday = trunc(md.c_date_doc)
  join V_TIME_DAYS                td on td.yyyy_mm_dd = coalesce(h.first_work_day,trunc(md.c_date_doc))
 where substr(pu.c_num,1,4) = '1860' 
   and upper(af.c_name) like '%ВАНД%' 
   and af.c_acc_summary is not null
   and md.state_id = 'PROV'
   and md.c_date_doc >= d_date_max + 1
   and md.c_date_doc <= d_date_load
union all
select /*+ parallel(15)*/
       cast('КРАЖА ТЕРМИНАЛА' as varchar2(500)) as type_report,
       af.c_main_v_id, 
       af.c_name, 
       to_char(coalesce(h.first_work_day,md.c_date_doc),'mm-yyyy') as mm_yyyy_report_date,
       coalesce(h.first_work_day,md.c_date_doc) as c_date_doc_x,
       md.c_date_prov,
       md.c_nazn,
       md.c_sum,
       fm.c_cur_short as valuta,
       cast('КРЕДИТ' as varchar2(100)) as is_db_kt,
       cast(replace(coalesce(cr.c_code,regexp_substr(md.c_nazn,'PT[[:digit:]]*',1),regexp_substr(md.c_nazn,'РТ[[:digit:]]*',1)),
                    'РТ','PT') as varchar2(2000)) as comments,
       substr(pu.c_num,1,4),
       null,
       null,
       td.quarter
  from T_RBO_Z#AC_FIN af
  join V_RBO_Z#PL_USV             pu on pu.id = af.c_main_usv
  join T_RBO_Z#MAIN_DOCUM_FRAUD   md on md.c_acc_kt = af.id
  join V_RBO_Z#FT_MONEY           fm on fm.id = md.c_valuta
  left join T_RBO_Z#KAS_ACASH_DOC ad on ad.c_quit_doc_ref = md.id
  left join V_RBO_Z#KAS_CASH_REG  cr on cr.id = ad.c_device
  left join V_TIME_HOLIDAYS        h on h.holiday = trunc(md.c_date_doc) 
  join V_TIME_DAYS                td on td.yyyy_mm_dd = coalesce(h.first_work_day,trunc(md.c_date_doc))  
 where substr(pu.c_num,1,4) = '1860' 
   and upper(af.c_name) like '%ВАНД%' 
   and af.c_acc_summary is not null
   and md.state_id = 'PROV'
   and md.c_date_doc >= d_date_max + 1
   and md.c_date_doc <= d_date_load;
  commit;
   
  --последняя загруженная дата
  select max(trunc(c_date_prov))
    into d_date_max
    from t_out_report_fraud
   where type_report in ('КРАЖА ТЕРМИНАЛА ИБСО')
     and is_db_kt = 'ДЕБЕТ';
  p_error := substr(p_error||' КРАЖА ТЕРМИНАЛА ИБСО='||to_char(d_date_max,'dd-mm-yyyy'),1,2000);
insert /*+ append enable_parallel_dml parallel */ into T_OUT_REPORT_FRAUD
select /*+ parallel(30)*/
       cast('КРАЖА ТЕРМИНАЛА ИБСО' as varchar2(500)) as type_report,
       ca.c_num, 
       ca.c_name,
       to_char(pd.c_date_dok,'mm-yyyy') as mm_yyyy_report_date,
       pd.c_date_dok,
       pd.c_opdate,
       pd.c_nazn,
       pd.c_turn#val,
       pd.c_code_val,
       cast('ДЕБЕТ' as varchar2(100)) as is_db_kt,
       cast(replace(coalesce(regexp_substr(pd.c_nazn,'PT[[:digit:]]*',1),regexp_substr(pd.c_nazn,'РТ[[:digit:]]*',1)),
                    'РТ','PT') as varchar2(2000))  as comments,
       substr(ca.c_gk_num,1,4),
       cca.c_num,
       substr(cca.c_gk_num,1,4),
       td.quarter           
  from V_ODWH_Z#CLS_ACC  ca
  join T_ODWH_Z#PAY_DOK  pd on pd.c_c_deb = ca.c_num
  join V_ODWH_Z#CLS_ACC cca on cca.c_num = pd.c_c_cre
  join V_TIME_DAYS       td on td.yyyy_mm_dd = trunc(pd.c_date_dok)
where substr(ca.c_gk_num,1,4) = '1860' 
  and upper(ca.c_name) like '%ВАНД%'
  and pd.c_opdate >= d_date_max + 1
  and pd.c_opdate <= d_date_load;
commit;
select max(trunc(c_date_prov))
    into d_date_max
    from t_out_report_fraud
   where type_report in ('КРАЖА ТЕРМИНАЛА ИБСО')
     and is_db_kt = 'КРЕДИТ';
insert /*+ append enable_parallel_dml parallel */ into T_OUT_REPORT_FRAUD
select /*+ parallel(30)*/
       cast('КРАЖА ТЕРМИНАЛА ИБСО' as varchar2(500)) as type_report,
       ca.c_num, 
       ca.c_name,
       to_char(pd.c_date_dok,'mm-yyyy') as mm_yyyy_report_date,
       pd.c_date_dok,
       pd.c_opdate,
       pd.c_nazn,
       pd.c_turn#val,
       pd.c_code_val,
       cast('КРЕДИТ' as varchar2(100)) as is_db_kt,
       cast(replace(coalesce(regexp_substr(pd.c_nazn,'PT[[:digit:]]*',1),regexp_substr(pd.c_nazn,'РТ[[:digit:]]*',1)),
                    'РТ','PT') as varchar2(2000)) as comments,
       substr(ca.c_gk_num,1,4),
       cca.c_num,
       substr(cca.c_gk_num,1,4),
       td.quarter
  from V_ODWH_Z#CLS_ACC  ca
  join T_ODWH_Z#PAY_DOK  pd on pd.c_c_cre = ca.c_num
  join V_ODWH_Z#CLS_ACC cca on cca.c_num = pd.c_c_deb
  join V_TIME_DAYS       td on td.yyyy_mm_dd = trunc(pd.c_date_dok)  
where substr(ca.c_gk_num,1,4) = '1860' 
  and upper(ca.c_name) like '%ВАНД%'
  and pd.c_opdate >= d_date_max + 1
  and pd.c_opdate <= d_date_load;
  commit;  
  ----------------------НЕДОСТАЧА В КАССЕ---------------------------------------
  --последняя загруженная дата
  select max(trunc(c_date_prov))
    into d_date_max
    from t_out_report_fraud
   where type_report in ('НЕДОСТАЧА В КАССЕ');
  p_error := substr(p_error||' НЕДОСТАЧА В КАССЕ='||to_char(d_date_max,'dd-mm-yyyy'),1,2000);
  --грузим будет с даты d_date_max+1  
insert /*+ append enable_parallel_dml parallel */ into T_OUT_REPORT_FRAUD
select 
       cast('НЕДОСТАЧА В КАССЕ' as varchar2(500)) as type_report,
       ca.c_num, 
       ca.c_name,
       to_char(pd.c_date_dok,'mm-yyyy') as mm_yyyy_report_date,
       pd.c_date_dok,
       pd.c_opdate,
       pd.c_nazn,
       pd.c_turn#val,
       pd.c_code_val,
       cast('ДЕБЕТ' as varchar2(100)) as is_db_kt,
       null as comments,
       null, null, null,
       td.quarter
  from V_ODWH_Z#CLS_ACC ca
  join T_ODWH_Z#PAY_DOK pd on pd.c_c_deb = ca.c_num
  join V_TIME_DAYS      td on td.yyyy_mm_dd = trunc(pd.c_opdate)
  join V_IBSO_Z#AC_FIN   af on af.c_main_v_id = ca.c_num
  join V_IBSO_Z#PR_ARR_ITEM pr on pr.collection_id = af.c_pr_list
                              and pr.c_pr = 14270960434                           
 where ca.c_num in (select c_num
                     from V_ODWH_Z#CLS_ACC
                    where substr(c_gk_num,1,4) = '1860' 
                      and upper(c_name) like '%НЕДОСТ%КАСС%'
                  )
  and pd.c_opdate >= d_date_max + 1
  and pd.c_opdate <= d_date_load 
  and upper(pd.c_nazn) not like '%ПЕРЕОЦЕНК%'; 
commit;  

insert /*+ append enable_parallel_dml parallel */ into T_OUT_REPORT_FRAUD
select 
       cast('НЕДОСТАЧА В КАССЕ' as varchar2(500)) as type_report,
       ca.c_num, 
       ca.c_name,
       to_char(pd.c_date_dok,'mm-yyyy') as mm_yyyy_report_date,
       pd.c_date_dok,
       pd.c_opdate,
       pd.c_nazn,
       pd.c_turn#val,
       pd.c_code_val,
       cast('КРЕДИТ' as varchar2(100)) as is_db_kt,
       null as comments,
       null, null, null,
       td.quarter
  from V_ODWH_Z#CLS_ACC ca
  join T_ODWH_Z#PAY_DOK pd on pd.c_c_cre = ca.c_num
  join V_TIME_DAYS      td on td.yyyy_mm_dd = trunc(pd.c_opdate)
  join V_IBSO_Z#AC_FIN   af on af.c_main_v_id = ca.c_num
  join V_IBSO_Z#PR_ARR_ITEM pr on pr.collection_id = af.c_pr_list
                              and pr.c_pr = 14270960434                           
 where ca.c_num in (select c_num
                     from V_ODWH_Z#CLS_ACC
                    where substr(c_gk_num,1,4) = '1860' 
                      and upper(c_name) like '%НЕДОСТ%КАСС%'
                  )
  and pd.c_opdate >= d_date_max + 1
  and pd.c_opdate <= d_date_load 
  and upper(pd.c_nazn) not like '%ПЕРЕОЦЕНК%'; 
commit;   
  ----------------------ВОЗМЕЩЕНИЕ ПО РЕШЕНИЮ СУДА---------------------------------------
  --последняя загруженная дата
  select max(trunc(c_date_prov))
    into d_date_max
    from t_out_report_fraud
   where type_report in ('ВОЗМЕЩЕНИЕ ПО РЕШЕНИЮ СУДА');
  p_error := substr(p_error||' ВОЗМЕЩЕНИЕ ПО РЕШЕНИЮ СУДА='||to_char(d_date_max,'dd-mm-yyyy'),1,2000);
  --грузим будет с даты d_date_max+1  
 insert /*+ append enable_parallel_dml parallel */ into T_OUT_REPORT_FRAUD
select /*+ parallel(15)*/
       cast('ВОЗМЕЩЕНИЕ ПО РЕШЕНИЮ СУДА' as varchar2(500)) as type_report,
       ca.c_num, 
       ca.c_name,
       to_char(pd.c_date_dok,'mm-yyyy') as mm_yyyy_report_date,
       pd.c_date_dok,
       pd.c_opdate,
       pd.c_nazn,
       pd.c_turn#val,
       pd.c_code_val,
       cast('ДЕБЕТ' as varchar2(100)) as is_db_kt,
       null as comments,
       null, null, null,
       td.quarter
  from V_ODWH_Z#CLS_ACC ca
  join T_ODWH_Z#PAY_DOK pd on pd.c_c_deb = ca.c_num
  join V_TIME_DAYS      td on td.yyyy_mm_dd = trunc(pd.c_opdate)  
 where substr(ca.c_gk_num,1,4) = '5921' 
  and (upper(ca.c_name) like '% СУД%' or upper(ca.c_name) like 'СУД%')
  and pd.c_opdate >= d_date_max + 1
  and pd.c_opdate <= d_date_load 
union all
select /*+ parallel(15)*/
       cast('ВОЗМЕЩЕНИЕ ПО РЕШЕНИЮ СУДА' as varchar2(500)) as type_report,
       ca.c_num, 
       ca.c_name,
       to_char(pd.c_date_dok,'mm-yyyy') as mm_yyyy_report_date,
       pd.c_date_dok,
       pd.c_opdate,
       pd.c_nazn,
       pd.c_turn#val,
       pd.c_code_val,
       cast('КРЕДИТ' as varchar2(100)) as is_db_kt,
       null as comments,
       null, null,null,
       td.quarter
  from V_ODWH_Z#CLS_ACC ca
  join T_ODWH_Z#PAY_DOK pd on pd.c_c_cre = ca.c_num
  join V_TIME_DAYS      td on td.yyyy_mm_dd = trunc(pd.c_opdate)  
 where substr(ca.c_gk_num,1,4) = '5921' 
  and (upper(ca.c_name) like '% СУД%' or upper(ca.c_name) like 'СУД%')
  and pd.c_opdate >= d_date_max + 1
  and pd.c_opdate <= d_date_load;   
commit;
  ----------------------НЕУСТОЙКА,ШТРАФ,ПЕНЯ---------------------------------------
  --последняя загруженная дата
  select max(trunc(c_date_prov))
    into d_date_max
    from t_out_report_fraud
   where type_report in ('НЕУСТОЙКА,ШТРАФ,ПЕНЯ');
  p_error := substr(p_error||' НЕУСТОЙКА,ШТРАФ,ПЕНЯ='||to_char(d_date_max,'dd-mm-yyyy'),1,2000);
  --грузим будет с даты d_date_max+1  
insert /*+ append enable_parallel_dml parallel */ into T_OUT_REPORT_FRAUD
select /*+ parallel(15)*/
       cast('НЕУСТОЙКА,ШТРАФ,ПЕНЯ' as varchar2(500)) as type_report,
       ca.c_num, 
       ca.c_name,
       to_char(pd.c_date_dok,'mm-yyyy') as mm_yyyy_report_date,
       pd.c_date_dok,
       pd.c_opdate,
       pd.c_nazn,
       pd.c_turn#val,
       pd.c_code_val,
       cast('ДЕБЕТ' as varchar2(100)) as is_db_kt,
       null as comments,
       null, null, null,
       td.quarter
  from V_ODWH_Z#CLS_ACC ca
  join T_ODWH_Z#PAY_DOK pd on pd.c_c_deb = ca.c_num
  join V_TIME_DAYS      td on td.yyyy_mm_dd = trunc(pd.c_opdate)
 where ca.c_num in (select c_num
                      from V_ODWH_Z#CLS_ACC
                     where substr(c_gk_num,1,4) = '5900' 
                  )
  and pd.c_opdate >= d_date_max + 1
  and pd.c_opdate <= d_date_load
union all
select /*+ parallel(15)*/
       cast('НЕУСТОЙКА,ШТРАФ,ПЕНЯ' as varchar2(500)) as type_report,
       ca.c_num, 
       ca.c_name,
       to_char(pd.c_date_dok,'mm-yyyy') as mm_yyyy_report_date,
       pd.c_date_dok,
       pd.c_opdate,
       pd.c_nazn,
       pd.c_turn#val,
       pd.c_code_val,
       cast('КРЕДИТ' as varchar2(100)) as is_db_kt,
       null as comments,
       null, null, null,
       td.quarter
  from V_ODWH_Z#CLS_ACC ca
  join T_ODWH_Z#PAY_DOK pd on pd.c_c_cre = ca.c_num
  join V_TIME_DAYS      td on td.yyyy_mm_dd = trunc(pd.c_opdate)
 where ca.c_num in (select c_num
                      from V_ODWH_Z#CLS_ACC
                     where substr(c_gk_num,1,4) = '5900' 
                  )
  and pd.c_opdate >= d_date_max + 1
  and pd.c_opdate <= d_date_load;   
commit;
  ----------------------ОФОРМЛЕНИЕ КРЕДИТА НА 3-Е ЛИЦО ИБСО---------------------------------------
  --последняя загруженная дата
  select max(trunc(c_date_prov))
    into d_date_max
    from t_out_report_fraud
   where type_report in ('ОФОРМЛЕНИЕ КРЕДИТА НА 3-Е ЛИЦО ИБСО');
  p_error := substr(p_error||' ОФОРМЛЕНИЕ КРЕДИТА НА 3-Е ЛИЦО ИБСО='||to_char(d_date_max,'dd-mm-yyyy'),1,2000);
  --грузим будет с даты d_date_max+1  
insert /*+ append enable_parallel_dml parallel */ into T_OUT_REPORT_FRAUD
select /*+ parallel(15)*/
       cast('ОФОРМЛЕНИЕ КРЕДИТА НА 3-Е ЛИЦО ИБСО' as varchar2(500)) as type_report,
       ca.c_num, 
       ca.c_name,
       to_char(pd.c_date_dok,'mm-yyyy') as mm_yyyy_report_date,
       pd.c_date_dok,
       pd.c_opdate,
       pd.c_nazn,
       pd.c_turn#val,
       pd.c_code_val,
       cast('ДЕБЕТ' as varchar2(100)) as is_db_kt,
       null as comments,
       null, null, null,
       td.quarter
  from V_ODWH_Z#CLS_ACC ca
  join T_ODWH_Z#PAY_DOK pd on pd.c_c_deb = ca.c_num
  join V_TIME_DAYS      td on td.yyyy_mm_dd = trunc(pd.c_opdate)
 where ca.c_num in (select c_num
                      from V_ODWH_Z#CLS_ACC
                     where substr(c_gk_num,1,4) = '1860'
                       and upper(c_name) like '%МОШЕН%' 
                  )
  and pd.c_opdate >= d_date_max + 1
  and pd.c_opdate <= d_date_load
union all
--добавила учет проводок по кредиту
select /*+ parallel(15)*/
       cast('ОФОРМЛЕНИЕ КРЕДИТА НА 3-Е ЛИЦО ИБСО' as varchar2(500)) as type_report,
       ca.c_num, 
       ca.c_name,
       to_char(pd.c_date_dok,'mm-yyyy') as mm_yyyy_report_date,
       pd.c_date_dok,
       pd.c_opdate,
       pd.c_nazn,
       pd.c_turn#val,
       pd.c_code_val,
       cast('КРЕДИТ' as varchar2(100)) as is_db_kt,
       null as comments,
       null, null, null,
       td.quarter
  from V_ODWH_Z#CLS_ACC ca
  join T_ODWH_Z#PAY_DOK pd on pd.c_c_cre = ca.c_num
  join V_TIME_DAYS      td on td.yyyy_mm_dd = trunc(pd.c_opdate)
 where ca.c_num in (select c_num
                      from V_ODWH_Z#CLS_ACC
                     where substr(c_gk_num,1,4) = '1860'
                       and upper(c_name) like '%МОШЕН%' 
                  )
  and pd.c_opdate >= d_date_max + 1
  and pd.c_opdate <= d_date_load
  and upper(nvl(pd.c_nazn,'0')) not like '%ОЦЕНК%' -- кроме переоценки в связи с курсовой разницей
   and upper(pd.c_nazn) not like '%ЗА ПОГ КРЕДИТА%'; -- видимо комиссия, не учитываем
commit;  

  --последняя загруженная дата
  select max(trunc(c_date_prov))
    into d_date_max
    from t_out_report_fraud
   where type_report in ('ОФОРМЛЕНИЕ КРЕДИТА НА 3-Е ЛИЦО');
  p_error := substr(p_error||' ОФОРМЛЕНИЕ КРЕДИТА НА 3-Е ЛИЦО='||to_char(d_date_max,'dd-mm-yyyy'),1,2000);
  --грузим будет с даты d_date_max+1  
insert /*+ append enable_parallel_dml parallel */ into t_out_report_fraud
select /*+ parallel(15)*/
       cast('ОФОРМЛЕНИЕ КРЕДИТА НА 3-Е ЛИЦО' as varchar2(500)) as type_report,
       null,
       df.client_name,
       to_char(df.date_prov,'mm-yyyy'),
       coalesce(h.first_work_day,df.date_prov) as c_date_doc_x ,
       df.date_prov,
       null as c_nazn,
       df.summa_contract_po,
       'KZT' as valuta,
       'ДЕБЕТ' as is_db_kt,
       df.contract_number as comments,
       null,null,null,
       td.quarter
from M_DEBT_DEBTOR_FRAUD df
left join V_TIME_HOLIDAYS     h on h.holiday = trunc(df.date_prov)
join V_TIME_DAYS             td on td.yyyy_mm_dd = trunc(df.date_prov)
where date_prov >= d_date_max + 1
  and date_prov <= d_date_load
union all
select /*+ parallel(15)*/
       cast('ОФОРМЛЕНИЕ КРЕДИТА НА 3-Е ЛИЦО' as varchar2(500)) as type_report,
       fo.acc,
       fo.acc_name,
       to_char(coalesce(h.first_work_day,md.c_date_prov),'mm-yyyy') as mm_yyyy_report_date,
       coalesce(h.first_work_day,trunc(md.c_date_prov)) as c_date_doc_x,
       md.c_date_prov,
       md.c_nazn,
       md.c_sum,
       fm.c_cur_short,
       'КРЕДИТ' as is_db_kt,
       cast(coalesce(regexp_substr(md.c_nazn,'R[[:digit:]]{7}-[[:digit:]]{3}',1,1),
                     replace(regexp_substr(md.c_nazn,'№[[:digit:]]{7}-[[:digit:]]{3}',1,1),'№','')) as varchar2(2000)) as comments,
       null, null, null,              
       td.quarter 
  from M_ACC_FRAUD_OPER fo
  join T_RBO_Z#MAIN_DOCUM_FRAUD md on md.c_acc_kt = fo.rbo_ac_fin_id
  join V_RBO_Z#NAME_PAYDOC      np on np.id = md.c_vid_doc
                                  and np.c_code != 'БЕЗН_ПЛ_ПОРУЧ'
  left join V_TIME_HOLIDAYS     h on h.holiday = trunc(md.c_date_prov)
  join V_TIME_DAYS             td on td.yyyy_mm_dd = trunc(md.c_date_prov)
  left join V_RBO_Z#FT_MONEY   fm on fm.id = md.c_valuta
 where fo.pl_usv_code = '1860'
   and trunc(md.c_date_prov) >= d_date_max + 1
   and trunc(md.c_date_prov) <= d_date_load
   and upper(md.c_nazn) not like '%ОЦЕНК%';
commit;  
  --загрузка 1С
  p_result := 1;
  p_get_fraud_1c(p_date_load => d_date_load,p_result => n_result);
  p_error := substr(p_error||' Загрузка 1С='||n_result,1,2000);
  p_result := least(n_result,p_result);
  return;
exception
  when others then
    p_result := 0;
    p_error :=  substr(p_error||' ERROR='||sqlerrm||' '||dbms_utility.format_error_backtrace,1,2000);
end P_OUT_REPORT_FRAUD;
/

