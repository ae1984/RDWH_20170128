create or replace force view u1.v_dwh_ref_deal_deposit as
select dpst_id,
       dpst_gid,
       dpst$start_date,
       dpst$end_date,
       dpst$row_status,
       dpst$audit_id,
       dpst$hash,
       dpst_number,
       dpst_name,
       dpst_deal_type_cd,
       dpst_crt_gid,
       dpst_prod_gid,
       dpst_begin_date,
       dpst_plan_end_date,
       dpst_actual_end_date,
       dpst_length,
       dpst_deal_status_cd,
       dpst_deposit_close_stat_cd,
       dpst_contragent_clnt_gid,
       dpst_beneficiary_clnt_gid,
       dpst_crnc_gid,
       dpst_amount,
       dpst_min_amount,
       dpst_max_amount,
       dpst_min_initial_amount,
       dpst_min_addition_amount,
       dpst_addition_till_date,
       dpst_capitalization_flg,
       dpst_is_call_deposit_flg,
       dpst_deposit_acnt_gid,
       dpst_main_settlement_acnt_gid,
       dpst_pcnt_settlement_acnt_gid,
       dpst_tax_acnt_gid,
       dpst_main_expense_acnt_gid,
       dpst_pcnt_expense_acnt_gid,
       dpst_pre_acrued_pcnt_acnt_gid,
       dpst_percent_oblig_acnt_gid,
       dpst_rate_periodicity_cd,
       dpst_rate_percent_basis_cd,
       dpst_rate_float_type_cd,
       dpst_rate_revision_note,
       dpst_rate_fixed_amount,
       dpst_rate_tax_amount,
       dpst_rate_reval_period,
       dpst_previous_dpst_gid,
       dpst_prolongation_number,
       dpst_prolongation_max,
       dpst_description,
       dpst_representative_empl_gid,
       dpst_branch_dept_gid,
       dpst_additional_number,
       dpst_additional_name,
       dpst_close_rstr_gid,
       dpst_open_rstr_gid,
       dpst_max_addition_amount,
       dpst_min_amount_action_period,
       dpst_debt_for_synd_gid,
       dpst_heritor_clnt_gid,
       dpst_inspector_empl_gid,
       dpst$source,
       dpst_first_enter_empl_gid,
       dpst_second_enter_empl_gid,
       dpst_initiate_dept_gid,
       dpst_contract_dept_gid,
       dpst_contract_br_dept_gid,
       dpst_service_dept_gid,
       dpst_service_br_dept_gid,
       dpst_supervise_dept_gid,
       dpst_supervise_br_dept_gid,
       dpst_budgeting_dept_gid,
       dpst_paid_fee_acnt_gid,
       dpst_received_fee_acnt_gid,
       dpst_overdue_fee_acnt_gid,
       dpst_supervise_empl_gid,
       dpst_subordinated_flg,
       dpst$change_date,
       dpst$provider,
       dpst$source_pk,
       dpst_slch_gid,
       dpst_pal_gid,
       dpst_prolongation_begin_date,
       dpst_prolongation_amount,
       dpst_prolongation_length,
       dpst_tranzit_dpst_gid,
       dpst_return_acnt_gid,
       dpst_return_dpst_gid,
       dpst_prcnt_pay_acnt_gid,
       dpst_prcnt_pay_dpst_gid,
       dpst_create_date,
       dpst_close_reason_main,
       dpst_close_reason_add,
       dpst_close_reason_comm,
       dpst_bank_wishes
  from dwh_main.ref_deal_deposit@rdwh_exd;
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_ID is 'Депозитная сделка. Идентификатор истории';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_GID is 'Сделка. Идентификатор';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST$START_DATE is 'Служебное поле. Дата начала действия записи';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST$END_DATE is 'Служебное поле. Дата окончания действия записи';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST$ROW_STATUS is 'Служебное поле. Состояние записи (А-активная, D-неактивная)';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST$AUDIT_ID is 'Служебное поле. Метка изменения';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST$HASH is 'Служебное поле. Хэш записи в хранилище';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_NUMBER is 'Сделка. Номер';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_NAME is 'Наименование. Отсутствует в ЛМ';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_DEAL_TYPE_CD is 'Сделка. (CL) Тип сделки';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_CRT_GID is 'Сделка. Ссылка на договор';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_PROD_GID is 'Сделка. Ссылка на продукт';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_BEGIN_DATE is 'Сделка. Дата начала действия сделки';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_PLAN_END_DATE is 'Сделка. Дата окончания сделки (план)';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_ACTUAL_END_DATE is 'Сделка. Дата фактического окончания сделки';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_LENGTH is 'Депозитная сделка. Срок сделки';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_DEAL_STATUS_CD is 'Сделка. (CL) Статус сделки';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_DEPOSIT_CLOSE_STAT_CD is 'Депозитная сделка. (CL) Статус закрытия депозитной сделки';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_CONTRAGENT_CLNT_GID is 'Сделка. Ссылка на контрагента';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_BENEFICIARY_CLNT_GID is 'Депозитная сделка. Ссылка на запись о субъекте - выгодопр.';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_CRNC_GID is 'Сделка. Ссылка на валюту';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_AMOUNT is 'Cделка. Сумма сделки';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_MIN_AMOUNT is 'Депозитная сделка. Неснижаемый остаток';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_MAX_AMOUNT is 'Депозитная сделка. Максимальный остаток средств';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_MIN_INITIAL_AMOUNT is 'Депозитная сделка. Минимальная сумма первоначального взноса';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_MIN_ADDITION_AMOUNT is 'Депозитная сделка. Минимальная сумма дополнительного взноса';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_ADDITION_TILL_DATE is 'Депозитная сделка. Дата, до которой возможен доп.взнос';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_CAPITALIZATION_FLG is 'Депозитная сделка. Признак капитализации';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_IS_CALL_DEPOSIT_FLG is 'Депозитная сделка. Признак опционной оговорки';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_DEPOSIT_ACNT_GID is 'Депозитная сделка. Ссылка на лс уч.срочн.вклада';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_MAIN_SETTLEMENT_ACNT_GID is 'Депозитная сделка. Ссылка на лс расч.счет уч. %';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_PCNT_SETTLEMENT_ACNT_GID is 'Депозитная сделка .Ссылка на лс расч.счет уч. %';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_TAX_ACNT_GID is 'Депозитная сделка. Ссылка на лс учета налогов';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_MAIN_EXPENSE_ACNT_GID is 'Депозитная сделка. Ссылка на лс расходов буд.пер.';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_PCNT_EXPENSE_ACNT_GID is 'Депозитная сделка. Ссылка на лс расходов по %';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_PRE_ACRUED_PCNT_ACNT_GID is 'Депозитная сделка. Ссылка на лс нчисл, неоплач. %';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_PERCENT_OBLIG_ACNT_GID is 'Депозитная сделка. Ссылка на лс уч.обяз.по %';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_RATE_PERIODICITY_CD is 'Депозитная сделка. (CL) Периодичность [процентов]';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_RATE_PERCENT_BASIS_CD is 'Процентная ставка. (CL) Базис начисления процентов.';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_RATE_FLOAT_TYPE_CD is 'Процентная ставка. Плавающая процентная ставка. Ссылка на сущность "Вид плавающей процентной ставки"';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_RATE_REVISION_NOTE is 'Процентная ставка. Условие пересмотра.';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_RATE_FIXED_AMOUNT is 'Процентная ставка. фиксированная процентная ставка. Фиксированное значение, Процентная ставка. Плавающая процентная ставка. Маржа';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_RATE_TAX_AMOUNT is 'Процентная ставка. Плавающая процентная ставка. Множитель (Налог)';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_RATE_REVAL_PERIOD is 'Процентная ставка. Плавающая процентная ставка. Процентный период';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_PREVIOUS_DPST_GID is 'Ссылка на предыдущую депозитную сделку. Отсутствует в ЛМ';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_PROLONGATION_NUMBER is 'Депозитная сделка. Количество пролонгаций';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_PROLONGATION_MAX is 'Депозитная сделка. Возможное количество пролонгаций';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_DESCRIPTION is 'Сделка. Комментарий';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_REPRESENTATIVE_EMPL_GID is 'Сделка. Ссылка на доверенное лицо банка';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_BRANCH_DEPT_GID is 'Сделка. Ссылка на учитывающую в бюдж го/филиал';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_ADDITIONAL_NUMBER is 'Депозитная сделка. Номер соответствующего доп. соглашения';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_ADDITIONAL_NAME is 'Депозитная сделка. Наименование дополнительного соглашения';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_CLOSE_RSTR_GID is 'Сделка. Ссылка на реструктуризацию закрывшую сд';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_OPEN_RSTR_GID is 'Сделка. Ссылка на реструктуризацию открывшую сд';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_MAX_ADDITION_AMOUNT is 'Депозитная сделка. Максимальная сумма дополнительного взноса';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_MIN_AMOUNT_ACTION_PERIOD is 'Депозитная сделка. Срок действия неснижаемого остатка';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_DEBT_FOR_SYND_GID is 'Депозитная сделка. Ссылка на кредит без определения долевых';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_HERITOR_CLNT_GID is 'Депозитная сделка. Ссылка на запись о субъекте - наследника';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_INSPECTOR_EMPL_GID is 'Сделка. Ссылка на сотр.банка - инспектора';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST$SOURCE is 'Служебное поле. Код системы-источника';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_FIRST_ENTER_EMPL_GID is 'Сделка. Ссылка на сотр.банка,внесшего в ИС 1';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_SECOND_ENTER_EMPL_GID is 'Сделка. Ссылка на сотр.банка,внесшего в ИС 2';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_INITIATE_DEPT_GID is 'Сделка. Ссылка на инициирующее подразделение';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_CONTRACT_DEPT_GID is 'Сделка. Ссылка на заключающее подразделение';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_CONTRACT_BR_DEPT_GID is 'Сделка. Ссылка на заключающую го/филиал';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_SERVICE_DEPT_GID is 'Сделка. Ссылка на исполняющее подразделение';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_SERVICE_BR_DEPT_GID is 'Сделка. Ссылка на исполняющую го/филиал';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_SUPERVISE_DEPT_GID is 'Сделка. Ссылка на курирующее подразделение';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_SUPERVISE_BR_DEPT_GID is 'Сделка. Ссылка на курирующую го/филиал';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_BUDGETING_DEPT_GID is 'Сделка. Ссылка на учитывающее в бюджете подразд';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_PAID_FEE_ACNT_GID is 'Сделка. Ссылка на лс уплаченной комиссии';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_RECEIVED_FEE_ACNT_GID is 'Сделка. Ссылка на лс полученной комиссии';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_OVERDUE_FEE_ACNT_GID is 'Сделка. Ссылка на лс просроченной комиссии';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_SUPERVISE_EMPL_GID is 'Сделка. Ссылка на курирующего сотрудника';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_SUBORDINATED_FLG is 'Сделка. Признак субординированного займа';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST$CHANGE_DATE is 'Служебное поле. Дата изменения';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST$PROVIDER is 'Служебное поле. Код поставщика данных';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST$SOURCE_PK is 'Служебное поле. Первичный ключ источника (Для составного ключа разделитель ";")';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_SLCH_GID is 'Сделка. Ссылка на канал продаж';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_PAL_GID is 'Сделка. Ссылка на портфель однородных элементов';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_PROLONGATION_BEGIN_DATE is 'Депозитная сделка. Дата последней пролонгации';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_PROLONGATION_AMOUNT is 'Депозитная сделка. Сумма последней пролонгации';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_PROLONGATION_LENGTH is 'Депозитная сделка. Срок последней пролонгации';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_TRANZIT_DPST_GID is 'Депозитная сделка. Ссылка на сделку транзитного счета';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_RETURN_ACNT_GID is 'Депозитная сделка. Ссылка на счет для возвратов по депозиту';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_RETURN_DPST_GID is 'Депозитная сделка. Ссылка на сделку счета для возвратов по депозиту';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_PRCNT_PAY_ACNT_GID is 'Депозитная сделка. Ссылка на счет для зачисления процентов';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_PRCNT_PAY_DPST_GID is 'Депозитная сделка. Ссылка на сделку счета для зачисления процентов';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_CREATE_DATE is 'Депозитная сделка. Дата первоначального открытия';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_CLOSE_REASON_MAIN is 'Депозитная сделка. Основная причина закрытия';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_CLOSE_REASON_ADD is 'Депозитная сделка. Дополнительная причина закрытия';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_CLOSE_REASON_COMM is 'Депозитная сделка. Комментарии к причине закрытия';
comment on column U1.V_DWH_REF_DEAL_DEPOSIT.DPST_BANK_WISHES is 'Депозитная сделка. Пожелание Банку';
grant select on U1.V_DWH_REF_DEAL_DEPOSIT to LOADDB;


