create or replace force view u1.v_dwh_acc_operation_deposit as
select dpop_gid,
       dpop$change_date,
       dpop$row_status,
       dpop$audit_id,
       dpop$hash,
       dpop$source,
       dpop$source_pk,
       dpop$provider,
       dpop_as_of_date,
       dpop_as_of_time,
       dpop_operation_type_cd,
       dpop_crnc_gid,
       dpop_amount,
       dpop_amount_eq,
       dpop_no_vat_amount,
       dpop_no_vat_amount_eq,
       dpop_is_fact_flg,
       dpop_oper_fee_cd,
       dpop_description,
       dpop_dept_gid,
       dpop_branch_dept_gid,
       dpop_depf_gid,
       dpop_deal_index_type_cd,
       dpop_rest_change_type_cd,
       dpop_dpst_gid,
       dpop_reg_date,
       dpop_create_empl_gid,
       dpop_dpsch_gid,
       dpop_doc_gid,
       dpop_is_reversed_flg,
       dpop_document_status_cd,
       dpop_number,
       dpop_first_empl_gid
  from dwh_main.acc_operation_deposit@rdwh_exd;
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP_GID is 'Операция по сделке. Идентификатор';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP$CHANGE_DATE is 'Служебное поле. Дата изменения';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP$ROW_STATUS is 'Служебное поле. Состояние записи (А-активная, D-неактивная)';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP$AUDIT_ID is 'Служебное поле. Метка изменения';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP$HASH is 'Служебное поле. Хэш записи в хранилище';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP$SOURCE is 'Служебное поле. Код системы-источника';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP$SOURCE_PK is 'Служебное поле. Первичный ключ источника (Для составного ключа разделитель ";")';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP$PROVIDER is 'Служебное поле. Код поставщика данных';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP_AS_OF_DATE is 'Операция по сделке. Дата операции';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP_AS_OF_TIME is 'Операция по сделке. Дата и время операции';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP_OPERATION_TYPE_CD is 'Операция по сделке. Тип операции';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP_CRNC_GID is 'Операция по сделке. Ссылка на валюту операции';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP_AMOUNT is 'Операция по сделке. Сумма операции';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP_AMOUNT_EQ is 'Операция по сделке. Сумма операции в валюте учета';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP_NO_VAT_AMOUNT is 'Операция по сделке. Сумма операции без ндс в валюте операции';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP_NO_VAT_AMOUNT_EQ is 'Операция по сделке. Сумма операции без ндс в валюте учета';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP_IS_FACT_FLG is 'Операция по сделке. Признак фактической';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP_OPER_FEE_CD is 'Операция. Депозитная операция. Код комиссии';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP_DESCRIPTION is 'Операция по сделке. Комментарии';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP_DEPT_GID is 'Операция по сделке. Ссылка на орг.единицу';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP_BRANCH_DEPT_GID is 'Операция по сделке. Ссылка на го/филиал, в котором заведена';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP_DEPF_GID is 'Депозитная операция с комиссиями. Ссылка на комиссию сделки';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP_DEAL_INDEX_TYPE_CD is 'Операция по сделке. Ссылка на тип аналитического показателя';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP_REST_CHANGE_TYPE_CD is 'Операция по сделке. Вид изм. оборота по остатку сделки';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP_DPST_GID is 'Операция по сделке. Ссылка на сделку/объект учета';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP_REG_DATE is 'Операция по сделке. Дата регистрации платежа';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP_CREATE_EMPL_GID is 'Операция по сделке. Ссылка на сотрудника банка';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP_DPSCH_GID is 'Операция по сделке. Ссылка на график';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP_DOC_GID is 'Операция по сделке. Ссылка на платежный документ';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP_IS_REVERSED_FLG is 'Операция по сделке. Признак отмены';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP_DOCUMENT_STATUS_CD is 'Операция по сделке. Состояние проводки';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP_NUMBER is 'Операция по сделке. Порядковый номер операции';
comment on column U1.V_DWH_ACC_OPERATION_DEPOSIT.DPOP_FIRST_EMPL_GID is 'Операция по сделке. Ссылка на сотрудника банка, который первый обслуживал клиента';
grant select on U1.V_DWH_ACC_OPERATION_DEPOSIT to LOADDB;


