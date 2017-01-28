create or replace force view u1.v_dwh_acc_operation_credit as
select crop_gid,
       crop$change_date,
       crop$row_status,
       crop$audit_id,
       crop$hash,
       crop$source,
       crop$source_pk,
       crop$provider,
       crop_as_of_date,
       crop_as_of_time,
       crop_operation_type_cd,
       crop_crnc_gid,
       crop_amount,
       crop_amount_eq,
       crop_no_vat_amount,
       crop_no_vat_amount_eq,
       crop_is_fact_flg,
       crop_credit_oper_fee_cd,
       crop_description,
       crop_dept_gid,
       crop_branch_dept_gid,
       crop_crfl_gid,
       crop_advanced_repayment_flg,
       crop_deal_index_type_cd,
       crop_rest_change_type_cd,
       crop_crdt_gid,
       crop_reg_date,
       crop_create_empl_gid,
       crop_crcsh_gid,
       crop_doc_gid,
       crop_is_reversed_flg,
       crop_document_status_cd,
       crop_number,
       crop_reverse_crop_gid
  from dwh_main.acc_operation_credit@rdwh_exd;
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP_GID is 'Операция по сделке. Идентификатор';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP$CHANGE_DATE is 'Служебное поле. Дата изменения';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP$ROW_STATUS is 'Служебное поле. Состояние записи (А-активная, D-неактивная)';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP$AUDIT_ID is 'Служебное поле. Метка изменения';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP$HASH is 'Служебное поле. Хэш записи в хранилище';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP$SOURCE is 'Служебное поле. Код системы-источника';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP$SOURCE_PK is 'Служебное поле. Первичный ключ источника (Для составного ключа разделитель ";")';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP$PROVIDER is 'Служебное поле. Код поставщика данных';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP_AS_OF_DATE is 'Операция по сделке. Дата операции';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP_AS_OF_TIME is 'Операция по сделке. Дата и время операции';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP_OPERATION_TYPE_CD is 'Операция по сделке. Тип операции';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP_CRNC_GID is 'Операция по сделке. Ссылка на валюту операции';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP_AMOUNT is 'Операция по сделке. Сумма операции';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP_AMOUNT_EQ is 'Операция по сделке. Сумма операции в валюте учета';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP_NO_VAT_AMOUNT is 'Операция по сделке. Сумма операции без ндс в валюте операции';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP_NO_VAT_AMOUNT_EQ is 'Операция по сделке. Сумма операции без ндс в валюте учета';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP_IS_FACT_FLG is 'Операция по сделке. Признак фактической';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP_CREDIT_OPER_FEE_CD is 'Кредитная операция с комиссиями, Пенни. Код операции с комиссиями';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP_DESCRIPTION is 'Операция по сделке. Комментарии';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP_DEPT_GID is 'Операция по сделке. Ссылка на орг.единицу';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP_BRANCH_DEPT_GID is 'Операция по сделке. Ссылка на го/филиал, в котором заведена';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP_CRFL_GID is 'Кредитная операция с комиссиями, Пенни. Ссылка на комиссию сделки';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP_ADVANCED_REPAYMENT_FLG is 'Кредитная операция с основным долгом. Признак досрочного погашения';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP_DEAL_INDEX_TYPE_CD is 'Операция по сделке. Ссылка на тип аналитического показателя';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP_REST_CHANGE_TYPE_CD is 'Операция по сделке. Вид изм. оборота по остатку сделки';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP_CRDT_GID is 'Операция по сделке. Ссылка на сделку/объект учета';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP_REG_DATE is 'Операция по сделке. Дата регистрации платежа';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP_CREATE_EMPL_GID is 'Операция по сделке. Ссылка на сотрудника банка';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP_CRCSH_GID is 'Операция по сделке. Ссылка на график';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP_DOC_GID is 'Операция по сделке. Ссылка на платежный документ';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP_IS_REVERSED_FLG is 'Операция по сделке. Признак отмены';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP_DOCUMENT_STATUS_CD is 'Операция по сделке. Состояние проводки';
comment on column U1.V_DWH_ACC_OPERATION_CREDIT.CROP_NUMBER is 'Операция по сделке. Порядковый номер операции';
grant select on U1.V_DWH_ACC_OPERATION_CREDIT to LOADDB;


