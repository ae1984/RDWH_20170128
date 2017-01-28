create or replace force view u1.v_out_black_list_terror as
select t.rfo_black_list_id,
       t.iin as client_iin,
       t.rnn as client_rnn,
       t.surname || ' ' || t.first_name || ' ' || t.patronymic as client_name,
       t.surname,
       t.first_name,
       t.patronymic,
       to_date(t.birth_date_text,'dd-mm-yyyy') as birth_date,
       t.date_add,
       cast(null as date) as date_delete,
       t.pers_doc_type,
       t.pers_doc_num,
       t.pers_doc_issuer,
       t.pers_doc_issue_place,
       to_date(t.pers_doc_date_begin_text,'dd-mm-yyyy') as pers_doc_date_begin,
       to_date(t.pers_doc_date_end_text,'dd-mm-yyyy') as pers_doc_date_end,
       t.place_of_birth,
       t.add_reason as reason_note,
       'WORK' as status
  from V_RFO_BLACK_LIST    t
 where t.note in ('A7','А7')
 union all
 select dt.id as rfo_black_list_id,
       dt.c_inn as client_iin,
       dt.c_rnn as client_rnn,
       dt.c_last_name || ' ' || dt.c_last_name || ' ' || dt.c_sur_name as client_name,
       dt.c_last_name     as surname,
       dt.c_first_name    as first_name,
       dt.c_sur_name      as patronymic,
       dt.c_date_birth    as birth_date,
       dt.c_date_add      as date_add,
       dt.c_date_delete   as date_delete,
       upper(ct.c_name)   as pers_doc_type,
       dt.c_passport#num      as pers_doc_num,
       dt.c_passport#who      as pers_doc_issuer,
       dt.c_passport#place    as pers_doc_issue_place,
       dt.c_passport#date_doc as pers_doc_date_begin,
       dt.c_passport#date_end as pers_doc_date_end,
       dt.c_place_birth   as place_of_birth,
       dt.c_reason_delete as reason_note,
       'DELETE' as status
  from V_RFO_Z#KAS_BLACK_LIST_D dt
  left join V_RFO_Z#CERTIFIC_TYPE ct on ct.id = dt.c_passport#type
 where dt.c_note in ('A7','А7');
comment on table U1.V_OUT_BLACK_LIST_TERROR is 'Информация по внесенным в ЧС террористам';
comment on column U1.V_OUT_BLACK_LIST_TERROR.RFO_BLACK_LIST_ID is 'Идентификтор';
comment on column U1.V_OUT_BLACK_LIST_TERROR.CLIENT_IIN is 'ИИН';
comment on column U1.V_OUT_BLACK_LIST_TERROR.CLIENT_RNN is 'РНН';
comment on column U1.V_OUT_BLACK_LIST_TERROR.CLIENT_NAME is 'Полное ФИО';
comment on column U1.V_OUT_BLACK_LIST_TERROR.SURNAME is 'фамилия   ';
comment on column U1.V_OUT_BLACK_LIST_TERROR.FIRST_NAME is 'имя  ';
comment on column U1.V_OUT_BLACK_LIST_TERROR.PATRONYMIC is 'отчество  ';
comment on column U1.V_OUT_BLACK_LIST_TERROR.BIRTH_DATE is 'дата рождения  ';
comment on column U1.V_OUT_BLACK_LIST_TERROR.DATE_ADD is 'дата добавления в чс ';
comment on column U1.V_OUT_BLACK_LIST_TERROR.DATE_DELETE is 'дата удаления из чс ';
comment on column U1.V_OUT_BLACK_LIST_TERROR.PERS_DOC_TYPE is 'тип документа ';
comment on column U1.V_OUT_BLACK_LIST_TERROR.PERS_DOC_NUM is 'наименование документа ';
comment on column U1.V_OUT_BLACK_LIST_TERROR.PERS_DOC_ISSUER is 'кем выдан документ ';
comment on column U1.V_OUT_BLACK_LIST_TERROR.PERS_DOC_ISSUE_PLACE is 'место выдачи(город) ';
comment on column U1.V_OUT_BLACK_LIST_TERROR.PERS_DOC_DATE_BEGIN is 'дата начал действия документа ';
comment on column U1.V_OUT_BLACK_LIST_TERROR.PERS_DOC_DATE_END is 'дата окончания действия документа ';
comment on column U1.V_OUT_BLACK_LIST_TERROR.PLACE_OF_BIRTH is 'место рождения  ';
comment on column U1.V_OUT_BLACK_LIST_TERROR.REASON_NOTE is 'Причина занесения/удаления';
comment on column U1.V_OUT_BLACK_LIST_TERROR.STATUS is 'Статус: WORK-Действующая запись,DELETE-удаленная запись';
grant select on U1.V_OUT_BLACK_LIST_TERROR to LOADDB;


