create or replace force view u1.v_terminal_fraud as
select /*+ parallel 20*/
       cast('КРАЖА ТЕРМИНАЛА' as varchar2(500)) as type_report,
       af.c_main_v_id                           as acc_num,
       af.c_name                                as acc_name,
       to_char(coalesce(h.first_work_day,
               md.c_date_doc),'mm-yyyy')        as mm_yyyy_report_date,
       coalesce(h.first_work_day,md.c_date_doc) as date_prov_x,
       md.c_date_prov                           as date_prov,
       md.c_nazn                                as nazn_pay,
       md.c_sum                                 as amount,
       fm.c_cur_short                           as valuta,
       cast('ДЕБЕТ' as varchar2(100))           as is_db_kt,
       cast(replace(coalesce(cr.c_code,regexp_substr(md.c_nazn,'PT[[:digit:]]*',1),regexp_substr(md.c_nazn,'РТ[[:digit:]]*',1)),
                    'РТ','PT') as varchar2(2000)) as comments,
       substr(pu.c_num,1,4)                       as gk_num,
       td.quarter
  from u1.T_RBO_Z#AC_FIN af
  join u1.V_RBO_Z#PL_USV             pu on pu.id = af.c_main_usv
  join u1.T_RBO_Z#MAIN_DOCUM_FRAUD   md on md.c_acc_dt = af.id
  join u1.V_RBO_Z#FT_MONEY           fm on fm.id = md.c_valuta
  left join u1.T_RBO_Z#KAS_ACASH_DOC ad on ad.c_quit_doc_ref = md.id
  left join u1.V_RBO_Z#KAS_CASH_REG  cr on cr.id = ad.c_device
  left join u1.V_TIME_HOLIDAYS        h on h.holiday = md.c_date_doc
  join u1.V_TIME_DAYS                td on td.yyyy_mm_dd = coalesce(h.first_work_day,trunc(md.c_date_doc))
 where substr(pu.c_num,1,4) = '1860'
   and upper(af.c_name) like '%ВАНД%'
   and af.c_acc_summary is not null
   and md.state_id = 'PROV'
union all
select /*+ parallel 20*/
       cast('КРАЖА ТЕРМИНАЛА' as varchar2(500)) as type_report,
       af.c_main_v_id                           as acc_num,
       af.c_name                                as acc_name,
       to_char(coalesce(h.first_work_day,
               md.c_date_doc),'mm-yyyy')        as mm_yyyy_report_date,
       coalesce(h.first_work_day,md.c_date_doc) as date_prov_x,
       md.c_date_prov                           as date_prov,
       md.c_nazn                                as nazn_pay,
       md.c_sum                                 as amount,
       fm.c_cur_short                           as valuta,
       cast('КРЕДИТ' as varchar2(100))          as is_db_kt,
       cast(replace(coalesce(cr.c_code,regexp_substr(md.c_nazn,'PT[[:digit:]]*',1),regexp_substr(md.c_nazn,'РТ[[:digit:]]*',1)),
                    'РТ','PT') as varchar2(2000)) as comments,
       substr(pu.c_num,1,4)                       as gk_num,
       td.quarter
  from u1.T_RBO_Z#AC_FIN af
  join u1.V_RBO_Z#PL_USV             pu on pu.id = af.c_main_usv
  join u1.T_RBO_Z#MAIN_DOCUM_FRAUD   md on md.c_acc_kt = af.id
  join u1.V_RBO_Z#FT_MONEY           fm on fm.id = md.c_valuta
  left join u1.T_RBO_Z#KAS_ACASH_DOC ad on ad.c_quit_doc_ref = md.id
  left join u1.V_RBO_Z#KAS_CASH_REG  cr on cr.id = ad.c_device
  left join u1.V_TIME_HOLIDAYS        h on h.holiday = md.c_date_doc
  join u1.V_TIME_DAYS                td on td.yyyy_mm_dd = coalesce(h.first_work_day,trunc(md.c_date_doc))
 where substr(pu.c_num,1,4) = '1860'
   and upper(af.c_name) like '%ВАНД%'
   and af.c_acc_summary is not null
   and md.state_id = 'PROV';
comment on table U1.V_TERMINAL_FRAUD is 'Данные по мошенническим операциям по терминалам(вандализм)';
comment on column U1.V_TERMINAL_FRAUD.TYPE_REPORT is 'Тип отчета';
comment on column U1.V_TERMINAL_FRAUD.ACC_NUM is 'Номер счета ДЗ(1860)';
comment on column U1.V_TERMINAL_FRAUD.ACC_NAME is 'Наименование счета ДЗ(1860)';
comment on column U1.V_TERMINAL_FRAUD.MM_YYYY_REPORT_DATE is 'Отчетный месяц (mm-yyyy)';
comment on column U1.V_TERMINAL_FRAUD.DATE_PROV_X is 'Дата проведения операции с учетом переноса выходного дня на первый рабочий день';
comment on column U1.V_TERMINAL_FRAUD.DATE_PROV is 'Дата проведения операции';
comment on column U1.V_TERMINAL_FRAUD.NAZN_PAY is 'Назначение платежа';
comment on column U1.V_TERMINAL_FRAUD.AMOUNT is 'Сумма операции';
comment on column U1.V_TERMINAL_FRAUD.VALUTA is 'Валюта операции';
comment on column U1.V_TERMINAL_FRAUD.IS_DB_KT is 'Признак Дебета/Кредита';
comment on column U1.V_TERMINAL_FRAUD.COMMENTS is 'Комментарий: Номер терминала';
comment on column U1.V_TERMINAL_FRAUD.GK_NUM is 'Номер счета НПС';
comment on column U1.V_TERMINAL_FRAUD.QUARTER is 'Квартал';
grant select on U1.V_TERMINAL_FRAUD to LOADDB;
grant select on U1.V_TERMINAL_FRAUD to LOADER;


