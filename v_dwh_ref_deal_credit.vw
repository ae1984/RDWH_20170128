create or replace force view u1.v_dwh_ref_deal_credit as
select crdt_id,
       crdt_gid,
       crdt$start_date,
       crdt$end_date,
       crdt$row_status,
       crdt$audit_id,
       crdt$hash,
       crdt_number,
       crdt_name,
       crdt_deal_type_cd,
       crdt_crt_gid,
       crdt_prod_gid,
       crdt_begin_date,
       crdt_plan_end_date,
       crdt_actual_end_date,
       crdt_lend_decision_date,
       crdt_begin_problem_date,
       crdt_debt_fact_redmption_date,
       crdt_pcnt_fact_redmption_date,
       crdt_deal_status_cd,
       crdt_credit_close_stat_cd,
       crdt_contragent_clnt_gid,
       crdt_beneficiary_clnt_gid,
       crdt_crnc_gid,
       crdt_amount,
       crdt_calculated_reserve_pcnt,
       crdt_debt_limit_crnc_gid,
       crdt_debt_limit_amount,
       crdt_withdraw_limit_crnc_gid,
       crdt_withdraw_limit_amount,
       crdt_pal_gid,
       crdt_credit_target_cd,
       crdt_credit_target_desc,
       crdt_credit_quality_ch_desc,
       crdt_credit_lend_reason_cd,
       crdt_credit_lend_reason_desc,
       crdt_credit_srv_quality_cd,
       crdt_credit_backing_cd,
       crdt_industry_okved_cd,
       crdt_bki_status_cd,
       crdt_bki_pay_promptness_cd,
       crdt_bki_pay_promptness_note,
       crdt_bki_report_agreement_flg,
       crdt_is_problem_flg,
       crdt_is_syndicated_flg,
       crdt_is_revolving_flg,
       crdt_is_line_flg,
       crdt_3_10_flg,
       crdt_3_10_date,
       crdt_3_14_3_flg,
       crdt_3_14_3_date,
       crdt_credit_acnt_gid,
       crdt_overdue_acnt_gid,
       crdt_resrv_acnt_gid,
       crdt_resrv_overdue_acnt_gid,
       crdt_resrv_ofsh_acnt_gid,
       crdt_resrv_ofsh_odue_acnt_gid,
       crdt_percent_claim_b_acnt_gid,
       crdt_percent_claim_v_acnt_gid,
       crdt_percent_debt_b_acnt_gid,
       crdt_percent_debt_v_acnt_gid,
       crdt_writeoff_resrv_acnt_gid,
       crdt_writeoff_loss_acnt_gid,
       crdt_writeoff_prcnt_acnt_gid,
       crdt_debt_limit_acnt_gid,
       crdt_withdraw_limit_acnt_gid,
       crdt_m_rate_percent_basis_cd,
       crdt_m_rate_float_type_cd,
       crdt_m_rate_revision_note,
       crdt_m_rate_fixed_amount,
       crdt_m_rate_tax_amount,
       crdt_m_rate_reval_period,
       crdt_mo_rate_percent_basis_cd,
       crdt_mo_rate_float_type_cd,
       crdt_mo_rate_revision_note,
       crdt_mo_rate_fixed_amount,
       crdt_mo_rate_tax_amount,
       crdt_mo_rate_reval_period,
       crdt_po_rate_percent_basis_cd,
       crdt_po_rate_float_type_cd,
       crdt_po_rate_revision_note,
       crdt_po_rate_fixed_amount,
       crdt_po_rate_tax_amount,
       crdt_po_rate_reval_period,
       crdt_parent_crdt_gid,
       crdt_previous_crdt_gid,
       crdt_prolongation_number,
       crdt_prolongation_max,
       crdt_description,
       crdt_representative_empl_gid,
       crdt_inspector_empl_gid,
       crdt_service_dept_gid,
       crdt_supervise_dept_gid,
       crdt_budgeting_dept_gid,
       crdt_branch_dept_gid,
       crdt_close_rstr_gid,
       crdt_open_rstr_gid,
       crdt_percent_crnc_gid,
       crdt_synd_gid,
       crdt_oper_empl_gid,
       crdt_controller_empl_gid,
       crdt_subordinated_flg,
       crdt_advanced_repayment_flg,
       crdt_supervise_br_dept_gid,
       crdt_service_br_dept_gid,
       crdt_contract_br_dept_gid,
       crdt_contract_dept_gid,
       crdt_initiate_br_dept_gid,
       crdt_initiate_dept_gid,
       crdt_first_enter_empl_gid,
       crdt_second_enter_empl_gid,
       crdt_permited_overdraft_flg,
       crdt$source,
       crdt_frst_debt_payment_date,
       crdt_frst_intrst_payment_date,
       crdt_end_limit_date,
       crdt_transaction_risk_level,
       crdt_paid_fee_acnt_gid,
       crdt_received_fee_acnt_gid,
       crdt_overdue_fee_acnt_gid,
       crdt_supervise_empl_gid,
       crdt$change_date,
       crdt$provider,
       crdt$source_pk,
       crdt_slch_gid,
       crdt_old_overdue_scheme_flg,
       crdt_old_system_overdue_date,
       crdt_old_system_ovrd_fix_date,
       crdt_dcard_gid,
       crdt_current_dpst_gid,
       crdt_current_acnt_gid,
       crdt_default_date,
       crdt_work_offer_flg,
       crdt_first_enter_empl_name,
       crdt_second_enter_empl_name,
       crdt_actual_crsch_gid,
       crdt_date_trial,
       crdt_date_promised_payment,
       crdt_insur_num,
       crdt_old_system_migr_flg,
       crdt_disc_acnt_gid,
       crdt_internal_code,
       crdt_crt_refin_flg,
       crdt_dprt_gid,
       crdt_kas_back_date,
       crdt_iss_typ,
       crdt_set_date,
       crdt_manager_dept_gid
  from dwh_main.ref_deal_credit@rdwh_exd;
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_ID is 'Кредитная сделка. Идентификатор истории';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_GID is 'Сделка. Идентификатор';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT$START_DATE is 'Служебное поле. Дата начала действия записи';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT$END_DATE is 'Служебное поле. Дата окончания действия записи';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT$ROW_STATUS is 'Служебное поле. Состояние записи (А-активная, D-неактивная)';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT$AUDIT_ID is 'Служебное поле. Метка изменения';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT$HASH is 'Служебное поле. Хэш записи в хранилище';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_NUMBER is 'Сделка. Номер';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_NAME is 'Сделка. Наименование';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_DEAL_TYPE_CD is 'Сделка. (CL) Тип сделки';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_CRT_GID is 'Сделка. Ссылка на договор';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_PROD_GID is 'Сделка. Ссылка на продукт';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_BEGIN_DATE is 'Сделка. Дата начала действия сделки';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_PLAN_END_DATE is 'Сделка. Дата окончания сделки (план)';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_ACTUAL_END_DATE is 'Сделка. Дата фактического окончания сделки';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_LEND_DECISION_DATE is 'Кредитная сделка .Дата принятия основания для предоств';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_BEGIN_PROBLEM_DATE is 'Кредитная сделка. Дата отнесения к проблемной категории';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_DEBT_FACT_REDMPTION_DATE is 'Кредитная сделка.Факт. Дата полного погашения осн. долга';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_PCNT_FACT_REDMPTION_DATE is 'Кредитная сделка.Факт. Дата полного погашения процентов';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_DEAL_STATUS_CD is 'Сделка. (CL) Статус сделки';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_CREDIT_CLOSE_STAT_CD is 'Кредитная сделка. (CL) Статус закрытия кредитной сделки';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_CONTRAGENT_CLNT_GID is 'Сделка. Ссылка на контрагента';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_BENEFICIARY_CLNT_GID is 'Кредитная сделка. Ссылка на субъекта-выгодоприобретателя';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_CRNC_GID is 'Cделка. Ссылка на валюту';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_AMOUNT is 'Сделка. Сумма сделки';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_CALCULATED_RESERVE_PCNT is 'Кредитная сделка. Рачитанный коэффициент отчисления в резерв';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_DEBT_LIMIT_CRNC_GID is 'Кредитная сделка. Ссылка на валюту лимита задолженности';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_DEBT_LIMIT_AMOUNT is 'Кредитная линия. Лимит задолженности';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_WITHDRAW_LIMIT_CRNC_GID is 'Кредитная сделка .Ссылка на валюту лимита выдачи';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_WITHDRAW_LIMIT_AMOUNT is 'Кредитная линия. Лимит выдачи';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_PAL_GID is 'Сделка. Ссылка на портфель однородных элементов';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_CREDIT_TARGET_CD is 'Кредитная сделка. Ссылка на цель кредитования';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_CREDIT_TARGET_DESC is 'Кредитная сделка. Примечания к цели кредита';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_CREDIT_QUALITY_CH_DESC is 'Кредитная сделка. Причины изменения качества или портфеля';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_CREDIT_LEND_REASON_CD is 'Кредитная сделка. (CL) Основание для предоставления';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_CREDIT_LEND_REASON_DESC is 'Кредитная сделка. Описание основания для предоставления';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_CREDIT_SRV_QUALITY_CD is 'Кредитная сделка. (CL) Качество обслуживания';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_CREDIT_BACKING_CD is 'Кредитная сделка. (CL) Обеспеченность';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_INDUSTRY_OKVED_CD is 'Кредитная сделка. (CL) ОКВЭД';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_BKI_STATUS_CD is 'Кредитная сделка. (CL) Состояние по критериям БКИ';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_BKI_PAY_PROMPTNESS_CD is 'Сделка. Кредитная сделка. (CL) Своеврменность платежей по критериям БКИ';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_BKI_PAY_PROMPTNESS_NOTE is 'Кредитная сделка. Признак своеврем. по критерию бки';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_BKI_REPORT_AGREEMENT_FLG is 'Кредитная сделка .Признак согл. клиента перед.информ.в бки';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_IS_PROBLEM_FLG is 'Кредитная сделка. Признак проблемности';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_IS_SYNDICATED_FLG is 'Кредитная сделка. Признак синдицированного кредита';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_IS_REVOLVING_FLG is 'Признок возобновляемой кредитной линии. Отсутствует на ЛМ.';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_IS_LINE_FLG is 'Признак кредитной линии. Отсутствует в ЛМ';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_3_10_FLG is 'Кредитная сделка. Признак кл.ссуды согл. пр. 3.10 254-П';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_3_10_DATE is 'Кредитная сделка. Дата клас. дог. в соотв. с 3.10 254-П';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_3_14_3_FLG is 'Кредитная сделка. Признак кл. ссуды согл. пр. 3.14.3 245-П';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_3_14_3_DATE is 'Кредитная сделка. Дата клас. дог. в соотв. с 3.14.3 245-П';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_CREDIT_ACNT_GID is 'Кредитная сделка. Ссылка на лс основного долга';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_OVERDUE_ACNT_GID is 'Кредитная сделка. Ссылка на лс просроченного осн. долга';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_RESRV_ACNT_GID is 'Кредитная сделка. Ссылка на лс резерва по основному долгу';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_RESRV_OVERDUE_ACNT_GID is 'Кредитная сделка. Ссылка на лс резерва просроч.осн.долга';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_RESRV_OFSH_ACNT_GID is 'КРЕДИТНАЯ СДЕЛКА.ССЫЛКА НА ЛС РЕЗЕРВА ПО ОСН.Д.(ОФШОРЫ)';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_RESRV_OFSH_ODUE_ACNT_GID is 'КРЕДИТНАЯ СДЕЛКА.ССЫЛКА НА ЛС РЕЗ.ПРОСРОЧ.ОСН.Д.(ОФШОРЫ)';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_PERCENT_CLAIM_B_ACNT_GID is 'КРЕДИТНАЯ СДЕЛКА.ССЫЛКА НА ЛС ТРЕБОВАНИЙ ПО % (БАЛАНС)';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_PERCENT_CLAIM_V_ACNT_GID is 'КРЕДИТНАЯ СДЕЛКА.ССЫЛКА НА ЛС ТРЕБОВАНИЙ ПО % (ВНЕБАЛАНС)';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_PERCENT_DEBT_B_ACNT_GID is 'КРЕДИТНАЯ СДЕЛКА.ССЫЛКА НА ЛС ПРОСРОЧЕННЫХ % (БАЛАНС)';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_PERCENT_DEBT_V_ACNT_GID is 'КРЕДИТНАЯ СДЕЛКА.ССЫЛКА НА ЛС ПРОСРОЧЕННЫХ % (ВНЕБАЛАНС)';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_WRITEOFF_RESRV_ACNT_GID is 'КРЕДИТНАЯ СДЕЛКА.ССЫЛКА НА ЛС СПИС.ЗА СЧЕТ РЕЗЕРВА ЗАДОЛЖ';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_WRITEOFF_LOSS_ACNT_GID is 'КРЕДИТНАЯ СДЕЛКА.ССЫЛКА НА ЛС СПИС.НА УБЫТКИ ЗАДОЛЖ.';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_WRITEOFF_PRCNT_ACNT_GID is 'КРЕДИТНАЯ СДЕЛКА.ССЫЛКА НА ЛС НЕПОЛУЧ.% ПО СПИС. КРЕД.';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_DEBT_LIMIT_ACNT_GID is 'КРЕДИТНАЯ ЛИНИЯ.ССЫЛКА НА ЛС УЧЕТА ЛИМИТА ЗАДОЛЖ.';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_WITHDRAW_LIMIT_ACNT_GID is 'КРЕДИТНАЯ ЛИНИЯ.ССЫЛКА НА ЛС УЧЕТА ЛИМИТА ВЫДАЧИ';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_M_RATE_PERCENT_BASIS_CD is 'Процентная ставка по основному долгу. (CL) Базис начисления процентов.';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_M_RATE_FLOAT_TYPE_CD is 'Процентная ставка по основному долгу. Плавающая процентная ставка. Ссылка на сущность "Вид плавающей проце??тной ставки"';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_M_RATE_REVISION_NOTE is 'Процентная ставка по основному долгу. Условие пересмотра.';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_M_RATE_FIXED_AMOUNT is 'Процентная ставка по основному долгу. фиксированная процентная ставка. Фиксированное значение, Процентная ставка. Плавающая процентная ставка. Маржа';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_M_RATE_TAX_AMOUNT is 'Процентная ставка по основному долгу. Плавающая процентная ставка. Множитель (Налог)';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_M_RATE_REVAL_PERIOD is 'Процентная ставка по основному долгу. Плавающая процентная ставка. Процентный период';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_MO_RATE_PERCENT_BASIS_CD is 'Процентная ставка по просрочке основного долга. (CL) Базис начисления процентов.';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_MO_RATE_FLOAT_TYPE_CD is 'Процентная ставка по просрочке основного долга. Плавающая процентная ставка. Ссылка на сущность "Вид плавающей процентной ставки"';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_MO_RATE_REVISION_NOTE is 'Процентная ставка по просрочке основного долга. Условие пересмотра.';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_MO_RATE_FIXED_AMOUNT is 'Процентная ставка по просрочке основного долга. фиксированная процентная ставка. Фиксированное значение, Процентная ставка. Плавающая процентная ставка. Маржа';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_MO_RATE_TAX_AMOUNT is 'Процентная ставка по просрочке основного долга. Плавающая процентная ставка. Множитель (Налог)';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_MO_RATE_REVAL_PERIOD is 'Процентная ставка по просрочке основного долга. Плавающая процентная ставка. Процентный период';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_PO_RATE_PERCENT_BASIS_CD is 'Процентная ставка по просроченным процентам. (CL) Базис начисления процентов.';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_PO_RATE_FLOAT_TYPE_CD is 'Процентная ставка по просроченным процентам. Плавающая процентная ставка. Ссылка на сущность "Вид плавающей процентной ставки"';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_PO_RATE_REVISION_NOTE is 'Процентная ставка по просроченным процентам. Условие пересмотра.';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_PO_RATE_FIXED_AMOUNT is 'Процентная ставка по просроченным процентам. фиксированная процентная ставка. Фиксированное значение, Процентная ставка. Плавающая процентная ставка. Маржа';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_PO_RATE_TAX_AMOUNT is 'Процентная ставка по просроченным процентам. Плавающая процентная ставка. Множитель (Налог)';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_PO_RATE_REVAL_PERIOD is 'Процентная ставка по просроченным проц??нтам. Плавающая процентная ставка. Процентный период';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_PARENT_CRDT_GID is 'Использование транша. Ссылка на транш';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_PREVIOUS_CRDT_GID is 'Сделка. Кредитная сделка. Ссылка "Предшествующая сделка" на сущность Сделка. Кредитная сделка.';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_PROLONGATION_NUMBER is 'Сделка. Кредитная сделка. Номер пролонгации.';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_PROLONGATION_MAX is 'Кредитная сделка. Максимальное количество пролонгаций';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_DESCRIPTION is 'Сделка. Комментарий';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_REPRESENTATIVE_EMPL_GID is 'Сделка. Ссылка на доверенное лицо банка';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_INSPECTOR_EMPL_GID is 'Сделка. Ссылка на сотр.банка - инспектора';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_SERVICE_DEPT_GID is 'Сделка. Ссылка на исполняющее подразделение';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_SUPERVISE_DEPT_GID is 'Сделка. Ссылка на курирующее подразделение';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_BUDGETING_DEPT_GID is 'Сделка. Ссылка на учитывающее в бюджете подразд';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_BRANCH_DEPT_GID is 'Сделка. Ссылка на учитывающую в бюдж го/филиал';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_CLOSE_RSTR_GID is 'Сделка. Ссылка на реструктуризацию закрывшую сд';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_OPEN_RSTR_GID is 'Сделка. Ссылка на реструктуризацию открывшую сд';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_PERCENT_CRNC_GID is 'Кредитная сделка. Ссылка на валюту процентов';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_SYND_GID is 'Кредитная сделка. Ссылка на синдицированный кредит';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_OPER_EMPL_GID is 'Кредитная сделка. Ссылка на сотр.банка-операциониста';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_CONTROLLER_EMPL_GID is 'Кредитная сделка. Ссылка на сотр.банка-контролера';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_SUBORDINATED_FLG is 'Сделка. Признак субординированного займа';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_ADVANCED_REPAYMENT_FLG is 'Кредитная сделка. Признак возможности досрочного погашени';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_SUPERVISE_BR_DEPT_GID is 'Сделка. Ссылка на курирующую го/филиал';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_SERVICE_BR_DEPT_GID is 'Сделка. Ссылка на исполняющую го/филиал';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_CONTRACT_BR_DEPT_GID is 'Сделка. Ссылка на заключающую го/филиал';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_CONTRACT_DEPT_GID is 'Сделка. Ссылка на заключающее подразделение';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_INITIATE_BR_DEPT_GID is 'Сделка. Ссылка на инициирующую го/филиал';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_INITIATE_DEPT_GID is 'Сделка. Ссылка на инициирующее подразделение';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_FIRST_ENTER_EMPL_GID is 'Сделка. Ссылка на сотр.банка,внесшего в ИС 1';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_SECOND_ENTER_EMPL_GID is 'Сделка. Ссылка на сотр.банка,внесшего в ИС 2';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_PERMITED_OVERDRAFT_FLG is 'Овердрафт. Признак разрешенного / неразрешенного';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT$SOURCE is 'Служебное поле. Код системы-источника';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_FRST_DEBT_PAYMENT_DATE is 'Кредитная сделка. Дата первого платежа по осн. долгу';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_FRST_INTRST_PAYMENT_DATE is 'Кредитная сделка. Дата первого платежа по процентам';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_END_LIMIT_DATE is 'Кредитная сделка. Дата освоения лимита';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_TRANSACTION_RISK_LEVEL is 'Кредитная сделка. Уровень транзакционного риска';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_PAID_FEE_ACNT_GID is 'Сделка. Ссылка на лс уплаченной комиссии';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_RECEIVED_FEE_ACNT_GID is 'Сделка. Ссылка на лс полученной комиссии';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_OVERDUE_FEE_ACNT_GID is 'Сделка. Ссылка на лс просроченной комиссии';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_SUPERVISE_EMPL_GID is 'Сделка. Ссылка на курирующего сотрудника';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT$CHANGE_DATE is 'Служебное поле. Дата изменения';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT$PROVIDER is 'Служебное поле. Код поставщика данных';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT$SOURCE_PK is 'Служебное поле. Первичный ключ источника (Для составного ключа разделитель ";")';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_SLCH_GID is 'Сделка. Ссылка на канал продаж';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_OLD_OVERDUE_SCHEME_FLG is 'Кредитная сделка. Признак старой схемы выхода на просрочку';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_OLD_SYSTEM_OVERDUE_DATE is 'Кредитная сделка. Мигрированная дата выхода на просрочку';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_OLD_SYSTEM_OVRD_FIX_DATE is 'Кредитная сделка. Дата фиксации выхода на просрочку';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_DCARD_GID is 'Кредитная сделка. Ссылка на сделку обслуживания карточного счета';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_CURRENT_DPST_GID is 'Кредитная сделка. Ссылка на сделку текущего счета';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_CURRENT_ACNT_GID is 'Кредитная сделка. Ссылка на текущий лс';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_DEFAULT_DATE is 'Кредитная сделка. Дата установки дефолта';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_WORK_OFFER_FLG is 'Сделка. Признак действия спецпредложения';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_FIRST_ENTER_EMPL_NAME is 'Сделка. ФИО сотр.банка,внесшего в ИС 1';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_SECOND_ENTER_EMPL_NAME is 'Сделка. ФИО сотр.банка,внесшего в ИС 2';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_ACTUAL_CRSCH_GID is 'Кредитная сделка. Ссылка на актуальный график платежей';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_DATE_TRIAL is 'Кредитная сделка. Дата передачи дела в суд';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_DATE_PROMISED_PAYMENT is 'Кредитная сделка. Обещанная клиентом дата погашения';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_INSUR_NUM is 'КРЕДИТНАЯ СДЕЛКА.Номер полиса';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_OLD_SYSTEM_MIGR_FLG is 'Кредитная сделка. Признак миграции из старых систем';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_DISC_ACNT_GID is 'Кредитная сделка. Ссылка на счет «Дисконт по займам,предоставленным клиентам(Партнерам - 1434)».';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_INTERNAL_CODE is 'внутренний код для импорта';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_CRT_REFIN_FLG is 'Признак оптимизации карточного договора';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_DPRT_GID is 'Кредитная сделка. Ссылка на сделку с контрагентом';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_KAS_BACK_DATE is 'Кредитная сделка. Дата возврата из Хард';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_ISS_TYP is 'Кредитная сделка. ';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_SET_DATE is 'Кредитная сделка. Дата установки признака ';
comment on column U1.V_DWH_REF_DEAL_CREDIT.CRDT_MANAGER_DEPT_GID is 'Кредитная сделка. Ссылка на подразделение эксперта выдавшего';
grant select on U1.V_DWH_REF_DEAL_CREDIT to LOADDB;


