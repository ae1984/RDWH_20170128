create or replace force view u1.v_app_online_miner_v3_out as
select  /*c.id as claim_id,*/
        tt."APP_ID",tt."CLAIM_ID",tt."PROCESS_ID",tt."FOLDER_DATE_CREATE",tt."ONL_APP_30D_CNT_T1",
        tt."ONL_APP_ISS_30D_CNT_T1",tt."ONL_APP_CANCEL_CLI_30D_CNT_T1",tt."ONL_MODEL_30D_CNT_T1",tt."ONL_CATEG_30D_CNT_T1",
        tt."ONL_APP_SAME_MODEL_30D_CNT_T1",tt."ONL_APP_SAME_CATEG_30D_CNT_T1",tt."ONL_APP_ISS_SM_MDL_30D_CNT_T1",tt."ONL_APP_ISS_SM_CTG_30D_CNT_T1",
        tt."ONL_APP_DELIVERY_30D_CNT_T1",tt."ONL_APP_AMOUNT_30D_SUM_T1",tt."ONL_APP_ISS_AMOUNT_30D_SUM_T1",tt."ONL_SHOP_30D_CNT_T1",tt."ONL_SHOP_CANCEL_CLI_30D_CNT_T1",
        tt."ONL_MOBILE_30D_CNT_T1",tt."KN_APP_30D_CNT_T1",tt."KN_APP_CANCEL_30D_CNT_T1",tt."GOODS_OFFL_APP_30D_CNT_T1",tt."GOODS_OFFL_APP_CNL_30D_CNT_T1",
        tt."GCVP_SALARY",tt."GCVP_PMTS_CNT",tt."GCVP_ORG_CNT",tt."GCVP_LAST_PMT_DAYS_AGO",tt."GCVP_FIRST_PMT_DAYS_AGO",tt."GCVP_PMT_COUNT_30D",
        tt."GCVP_PMT_COUNT_60D",tt."GCVP_IS_ALL_PMTS_IN_30D",tt."GCVP_IS_ALL_PMTS_IN_60D",tt."PREV_CON_DEL_DAYS_MAX",tt."FACT_PMT_MON_BEFORE",
        tt."FACT_PMT_MON_BEFORE_12_MON",tt."AMOUNT_MAX_BEFORE",tt."PRIOR_OPTIM_COUNT",tt."PREV_CON_CLOSED_CNT",tt."PREV_CON_CNT",tt."PKB_CRED_HIST_AGE_MONS",
        tt."PKB_CON_ACTIVE_CNT",tt."PKB_CON_CLOSED_CNT",tt."PKB_CON_CLOSED_12M_CNT",tt."PKB_TOTAL_DEBT",tt."PKB_TOTAL_DEBT_CLOSED",tt."INC_SAL",tt."INC_ALL",
        tt."AGE",tt."REG_KASPIKZ_LENGTH_V3",tt."AVG_SUM_PAY_KSPKZ_30_D",tt."COUNT_MONTH_KASPIKZ_6_M",tt."COUNT_PAY_KSPKZ_30_D",tt."COUNT_SERV_KSPKZ_6_M",
        tt."KOMMUNALKA_KASPIKZ_6_M",tt."SESSION_KSP_LAST_6_MNTH_T1",tt."COUNT_DAY_APP_ONL",tt."MAX_COUNT_FAIL_ONL_DAY",tt."LAST_YEAR_MAX_DELAY_T1",
        tt."DAYS_LAST_GCVP",tt."DIFF_ZP_FORM_GCVP",tt."DIFF_ZP_FORM_ALL_GCVP",tt."AVG_SUM_PAY_CRED_3_M_T1",tt."COUNT_SALARY_6_M_T1",tt."KASPI_GOLD_ACTIVE_T1",
        tt."MAX_TOV_CATEG_CODE_T1",tt."MAX_COUNT_CATEGORY_DAY_T1",tt."MAX_COUNT_MODELS_DAY_T1",tt."EX_TERMINAL_SHARE_COUNT_T1",tt."FAIL_SHARE_30_D_COUNT",
        tt."SHARE_30_D_COUNT",tt."EX_TERMINAL_SHARE_T1",tt."FAIL_SHARE_30_D",tt."II",tt."MAX_SUM_ONLINE_EKT_3_M_V2",tt."COUNT_APPL_KN_30_D_V2",tt."COUNT_FAIL_KN_30_D_V2",
        tt."MAX_SUM_APPL_KN_30_D_V2",tt."COUNT_APPLICATIONS_30_D_V2",tt."BALANCE_ALL_DEP_BEG_M_V2",tt."BALANCE_ALL_DEP_BEG_V2",tt."DEPOSIT_LIFE_LENGTH_V2",
        tt."SUM_PRITOK_DEP_3_M_V2",tt."SHARE_USD_DEP_SUM_V2",tt."AVG_COUNT_APP_ONL_DAY_V2",tt."AVG_SUM_ONLINE_EKT_3_M_V2",tt."AVG_TERM_CRED_PLAN_V2",
        tt."COUNT_CATEGORY_3_M_V2",tt."COUNT_FAIL_30_D_V2",tt."COUNT_FAIL_ONLINE_30_D_V2",tt."COUNT_MOB_KSPKZ_V2",tt."COUNT_VISIT_GUEST_V2",tt."COUNT_VISIT_CLIENT_V2",
        tt."INSTALLMENT_INCOM_AVG_V2",tt."INSTALLMENT_INCOM_AVG_30D_V2",tt."LIFE_LENGTH_V2",tt."AVG_ZP_H_V2",tt."MAX_ZP_H_V2",tt."MIN_SUM_APPL_KN_30_D_V2",
        tt."MIN_SUM_ONLINE_EKT_3_M_V2",tt."SHARE_MONTH_KASPIKZ_6_M_V2",tt."SUM_PAY_KSPKZ_30_D_V2",tt."TOTAL_MAX_DELAY_V2",tt."COUNT_SHOPS_ON_CLIENT_V2",
        tt."MAX_COUNT_APP_ONL_DAY_V2",tt."TERMINAL_SHARE_COUNT_V2",tt."COUNT_KN_EVER",tt."SUM_PAY_CRED_3_M_V2",tt."TOTAL_MAX_DELAY_2YEARS_V2",
        tt."DIF_CHILDREN_VAL_30D_CNT_T1",tt."DIF_MAR_STAT_VAL_30D_CNT_T1",tt."DIF_INC_SAL_VAL_30D_CNT_T1",tt."DIF_INC_SAL_ADD_VAL_30D_CNT_T1",
        tt."DIF_INC_SAL_SPS_VAL30D_CNT_T1",tt."DIF_INC_PENSBEN_VAL30D_CNT_T1",tt."INC_SAL_TO_AVG_30D_RATIO_T1",tt."INC_ALL_TO_AVG_30D_RATIO_T1",
        tt."INC_SAL_TO_MIN_30D_RATIO_T1",tt."INC_ALL_TO_MIN_30D_RATIO_T1",tt."DIF_PHONE_MOB_VAL_30D_CNT_T1",tt."DIF_PHONE_HOME_VAL_30D_CNT_T1",
        tt."DIF_CITY_REG_VAL_30D_CNT_T1",tt."DIF_CITY_FACT_VAL_30D_CNT_T1",tt."DIF_CHILDREN_VAL_90D_CNT_T1",tt."DIF_MAR_STAT_VAL_90D_CNT_T1",
        tt."DIF_INC_SAL_VAL_90D_CNT_T1",tt."DIF_INC_SAL_ADD_VAL90DCNT_T1",tt."DIF_INC_SAL_SPS_VAL90D_CNT_T1",tt."DIF_INC_PENSBEN_VAL90D_CNT_T1",
        tt."INC_SAL_TO_AVG_90D_RATIO_T1",tt."INC_ALL_TO_AVG_90D_RATIO_T1",tt."INC_SAL_TO_MIN_90D_RATIO_T1",tt."INC_ALL_TO_MIN_90D_RATIO_T1",
        tt."DIF_PHONE_MOB_VAL_90D_CNT_T1",tt."DIF_PHONE_HOME_VAL_90D_CNT_T1",tt."DIF_CITY_REG_VAL_90D_CNT_T1",tt."DIF_CITY_FACT_VAL_90D_CNT_T1",
        tt."DIF_CHILDREN_VAL_30D_CNT_O_T1",tt."DIF_MARTL_VAL_30D_CNT_O_T1",tt."DIF_INC_SAL_VAL_30D_CNT_O_T1",tt."DIF_INCSAL_ADD_VAL30D_CNT_O_T1",
        tt."DIF_INCSAL_SPS_VAL30D_CNT_O_T1",tt."DIF_INC_PENSN_VAL30D_CNT_O_T1",tt."INC_SAL_TO_AVG_30D_RATIO_O_T1",tt."INC_ALL_TO_AVG_30D_RATIO_O_T1",
        tt."INC_SAL_TO_MIN_30D_RATIO_O_T1",tt."INC_ALL_TO_MIN_30D_RATIO_O_T1",tt."DIF_PHON_MOBL_VAL_30D_CNT_O_T1",tt."DIF_PHON_HOME_VAL_30D_CNT_O_T1",
        tt."DIF_CITY_REG_VAL_30D_CNT_O_T1",tt."DIF_CITY_FACT_VAL_30D_CNT_O_T1",tt."DIF_CHILDREN_VAL_90D_CNT_O_T1",tt."DIF_MARTL_ST_VAL_90D_CNT_O_T1",
        tt."DIF_INC_SAL_VAL_90D_CNT_O_T1",tt."DIF_INC_SALADD_VAL90D_CNT_O_T1",tt."DIF_INC_SALSPS_VAL90D_CNT_O_T1",tt."DIF_INC_PENSN_VAL90D_CNT_O_T1",
        tt."INC_SAL_TO_AVG_90D_RATIO_O_T1",tt."INC_ALL_TO_AVG_90D_RATIO_O_T1",tt."INC_SAL_TO_MIN_90D_RATIO_O_T1",tt."INC_ALL_TO_MIN_90D_RATIO_O_T1",
        tt."DIF_PHON_MOBL_VAL_90D_CNT_O_T1",tt."DIF_PHON_HOME_VAL_90D_CNT_O_T1",tt."DIF_CITY_REG_VAL_90D_CNT_O_T1",tt."DIF_CITY_FACT_VAL_90D_CNT_O_T1",
        tt."IS_FROM_DIFF_CITY_REG",tt."IS_FROM_DIFF_CITY_FACT",tt."IS_FROM_DIFF_CITY_BORN",tt."CLIENT_CATEG",tt."ACTIVE_TOTAL_DEBT",tt."ACTIVE_CON_CNT",
        tt."IS_ACTIVE_DEBT_EXISTS",tt."IS_ACTIVE_DEBT_50K_EXISTS",tt."IS_ACTIVE_DEBT_100K_EXISTS",tt."IS_ACTIVE_DEBT_500K_EXISTS",
        tt."INC_SAL_SPOUSE",tt."INC_PENSION_BENEFITS",tt."INC_SAL_ADD",tt."EXP_UTILITIES",tt."MARITAL_STATUS",tt."CHILDREN",tt."EDUCATION",
        tt."REAL_ESTATE_RELATION",tt."LAST_FORM_IS_CHILDREN_DIF_T1",tt."LAST_FORM_IS_MARIT_STAT_DIF_T1",tt."LAST_FORM_IS_PHONE_MOB_DIF_T1",
        tt."LAST_FORM_IS_PHONE_HOM_DIF_T1",tt."LAST_FORM_IS_MARRIED_VANISH_T1",tt."LAST_FORM_IS_CHILDR_VANISH_T1",tt."INC_ALL_TO_LAST_FORM_RATIO_T1",
        tt."PATRONYMIC_TYPE",tt."FORM_180D_IS_CHILDREN_DIF",tt."FORM_180D_IS_MARITAL_STAT_DIF",tt."FORM_180D_IS_PHONE_MOB_DIF",tt."FORM_180D_IS_PHONE_HOM_DIF",
        tt."FORM_180D_IS_MARRIED_VANISH",tt."FORM_180D_IS_CHILDREN_VANISH",tt."INC_ALL_TO_FORM_180D_RATIO",

        case when nvl(d.device_subcat_by_phone_30d,'UserDevice') = 'SuperAgent' then 1 else 0 end as target,

        case
               when kd1.c_name in ('Клиент без возможности запроса ПКБ/ГЦВП', 'Новый клиент')
                and c.c_check_result is not null
                and (x.cancel_type_name in ('ПКБ. ИМЕЕТСЯ ПРОСРОЧКА С УЧЕТОВ КУРСОВ ВАЛЮТ',
                                            'ПРЕСКОРИНГ ПКБ ОТЧЕТА',
                                            'ПКБ. ПРЕВЫШЕНО МАКСИМАЛЬНОЕ КОЛИЧЕСТВО КРЕДИТОВ')
                 or (c.c_exec_comment like '%У клиента присутствует договор на реструктуризации/рефинансировании%'
                 or c.c_exec_comment like '%К сожалению, согласно Вашей кредитной истории Вам отказано в выдаче займа. Вы допустили просрочку в нашем Банке, в связи с чем Банк не может выдать Вам кредит повторно%'
                 or c.c_exec_comment like '%Максимальная просрочка (> 1000 тенге)%')
                 or (xxx.par_name = 'ОНЛАЙН. БЕКИ, БЕЗ ЗП ГЦВП, НЕ А, НЕ Б, СУММА >= 150 000, БЕЗ КРЕД В КАСПИ'
                and mb.cancel_middle_office = 1)  ) then
                 'С запросом ПКБ/ГЦВП'
               when kd1.c_name in ('Клиент без возможности запроса ПКБ/ГЦВП', 'Новый клиент') then
                 'Без запроса ПКБ/ГЦВП'
               when kd1.c_name in ('Клиент с возможностью запроса ПКБ/ГЦВП') then
                 'С запросом ПКБ/ГЦВП'
             end as request_type


from u1.m_matrix_base mb
join u1.v_rfo_z#kas_online_claim c on c.id = mb.claim_id
join u1.v_rfo_z#kas_online_buy b on b.id=c.c_buy_ref
join u1.m_kaspish_orders o on o.code = b.c_process_id
left join u1.m_online_device d on d.ga_client_id = o.p_gaclientid and d.yyyy_mm_dd = trunc(b.c_date_create)
left join U1.V_RFO_Z#KAS_UNIVERSAL_D kd1 on kd1.id = c.c_check_route
left join (select ff.folder_id,
                min(mm.is_rejecting) as is_rejecting,
                max(mm.par_code) keep (dense_rank last order by mm.reject_prior) as par_code,
                max(mm.par_name) keep (dense_rank last order by mm.reject_prior) as par_name
         from u1.M_FOLDER_CON_CANCEL ff
         join u1.m_folder_mo_cancel_last mm on mm.folder_id = ff.folder_id and
                                                      ff.process_name = 'ОНЛАЙН КРЕДИТ'
         join ( select m2.rfolder_id,
                       m2.folder_id,
                       coalesce(max(case when m2.is_rejecting = 0 then m2.reject_prior end), 0) as reject_prior_apr,
                       coalesce(max(case when m2.is_rejecting = 1 then m2.reject_prior end), 0) as reject_prior_can
                from u1.m_folder_mo_cancel_last m2
                group by m2.rfolder_id,
                         m2.folder_id
               ) m3 on m3.folder_id = mm.folder_id and
                       m3.reject_prior_apr <= mm.reject_prior
         where ff.process_name = 'ОНЛАЙН КРЕДИТ' and
               ff.is_credit_issued = 0 and
               ff.cancel_middle_office = 1 and
               ff.folder_date_create_mi >= to_date('01012016', 'ddmmyyyy')
               and
               mm.par_code not in ('MO_SCO_IS_CTRL_GR_81',
                                    'MO_SCO_REJECT',
                                    'MO_SCO_REJECT_81',
                                    'MO_SCO_REJECT_PRE_81'
                                    )
               group by ff.folder_id
         ) xxx on xxx.folder_id = c.c_folder_ref
left join (
          select
          distinct t2.folder_id,
          vc.cancel_type_name,
          row_number () over (partition by vc.folder_id order by cancel_date) as priority_cancel
          from u1.t_cancel vc
          join u1.m_folder_con_cancel t2 on t2.folder_id = vc.folder_id and
                                            t2.process_name = 'ОНЛАЙН КРЕДИТ' and
                                            t2.is_credit_issued = 0 and
                                            t2.cancel_prescoring = 1 and
                                            vc.cancel_level = 1 and
                                            trunc(t2.folder_date_create_mi)>= to_date('08-12-2014', 'dd-mm-yyyy')
          ) x on x.folder_id = c.c_folder_ref and priority_cancel = 1


left join u1.m_app_online_miner_learn_v3 tt on tt.claim_id = mb.claim_id
where mb.a_date >= to_date('01082016', 'ddmmyyyy');
grant select on U1.V_APP_ONLINE_MINER_V3_OUT to LOADDB;
grant select on U1.V_APP_ONLINE_MINER_V3_OUT to UPD_USER;


