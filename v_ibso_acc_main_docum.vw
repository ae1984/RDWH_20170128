create or replace force view u1.v_ibso_acc_main_docum as
select xx.id,                      --идентификатор проводки
       xx.client_inn,
       xx.client_acc_num,
       xx.client_name,
       xx.benefic_inn, --ИИН Бенефициара
       xx.benefic_acc_num, --Счет бенефициара
       xx.benefic_name, --Наименование бенефициара
       xx.benefic_bic, --БИК банка бенефициара
       xx.is_db, --Дебет
       xx.is_ct, --Кредит
       xx.nazn_pay,      --Назначение платежа
       xx.date_prov,  --дата проведения платежа по балансу
       xx.amount,             --Сумма платежа в валюте
       xx.amount_nt,          -- Сумма платежа в национальной валюте(эквивалент по курсу)
       xx.currency,        --Валюта платежа
       xx.iin_nazn,
       mi.rbo_client_id,
       mi.rfo_client_id,
       mi.cnt_credit,
       mi.cnt_card,
       mi.cnt_work_credit,
       mi.cnt_work_card
  from (
select pd.id,                      --идентификатор проводки
       cl_kt.c_inn          as client_inn,
       ca_kt.c_main_v_id    as client_acc_num,
       cl_kt.c_name         as client_name,
       pd.c_kl_dt#2#inn     as benefic_inn, --ИИН Бенефициара
       pd.c_kl_dt#2#1       as benefic_acc_num, --Счет бенефициара
       pd.c_kl_dt#2#2       as benefic_name, --Наименование бенефициара
       coalesce(bnh.c_bic,bn.c_bic)             as benefic_bic, --БИК банка бенефициара
       0 as is_db, --Дебет
       1 as is_ct, --Кредит
       pd.c_nazn as nazn_pay,      --Назначение платежа
       pd.c_date_prov  as date_prov,  --дата проведения платежа по балансу
       pd.c_sum as amount,             --Сумма платежа в валюте
       pd.c_sum_nt as amount_nt,          -- Сумма платежа в национальной валюте(эквивалент по курсу)
       fm.c_cur_short as currency,        --Валюта платежа
       regexp_substr(regexp_substr(replace(pd.c_nazn,' ',':'),'ИИН[[:punct:]]*[[:digit:]]*',1,1),
                                    '[[:digit:]]*[[:digit:]]',1,1) as iin_nazn
  from V_IBSO_Z#AC_FIN  ca_kt
  join T_IBSO_Z#MAIN_DOCUM pd on pd.c_acc_kt = ca_kt.id
  join V_IBSO_Z#FT_MONEY   fm on fm.id = pd.c_valuta
  join V_IBSO_Z#CLIENT  cl_kt on cl_kt.id = ca_kt.c_client_v
  left join /*risk_mvera.*/z#cl_bank_n bn on bn.id = coalesce(pd.c_kl_dt#2#3,pd.c_kl_dt#1#1)
  left join /*risk_mvera.*/z#cl_bank_n bnh on bnh.id = bn.c_head_bank
union all
select pd.id,                      --идентификатор проводки
       cl_dt.c_inn          as client_inn,
       ca_dt.c_main_v_id    as client_acc_num,
       cl_dt.c_name         as client_name,
       pd.c_kl_kt#2#inn     as benefic_inn, --ИИН Бенефициара
       pd.c_kl_kt#2#1       as benefic_acc_num, --Счет бенефициара
       pd.c_kl_kt#2#2       as benefic_name, --Наименование бенефициара
       coalesce(bnh.c_bic,bn.c_bic)  as benefic_bic, --БИК банка бенефициара
       1 as is_db, --Дебет
       0 as is_ct, --Кредит
       pd.c_nazn as nazn_pay,      --Назначение платежа
       pd.c_date_prov  as date_prov,  --дата проведения платежа по балансу
       pd.c_sum as amount,             --Сумма платежа в валюте
       pd.c_sum_nt as amount_nt,          -- Сумма платежа в национальной валюте(эквивалент по курсу)
       fm.c_cur_short as currency,        --Валюта платежа
       regexp_substr(regexp_substr(replace(pd.c_nazn,' ',':'),'ИИН[[:punct:]]*[[:digit:]]*',1,1),
                                    '[[:digit:]]*[[:digit:]]',1,1) as iin_nazn
  from V_IBSO_Z#AC_FIN  ca_dt
  join T_IBSO_Z#MAIN_DOCUM pd on pd.c_acc_dt = ca_dt.id
  join V_IBSO_Z#FT_MONEY   fm on fm.id = pd.c_valuta
  join V_IBSO_Z#CLIENT  cl_dt on cl_dt.id = ca_dt.c_client_v
  left join /*risk_mvera.*/z#cl_bank_n bn on bn.id = coalesce(pd.c_kl_kt#2#3,pd.c_kl_kt#1#1)
  left join /*risk_mvera.*/z#cl_bank_n bnh on bnh.id = bn.c_head_bank
) xx
  left join M_RBO_CLIENT_INFO mi on mi.client_iin = coalesce(xx.iin_nazn,xx.benefic_inn)
;
comment on table U1.V_IBSO_ACC_MAIN_DOCUM is 'Представление по движениям по счетам из базы ИБСО(выбирать только по счету)';
comment on column U1.V_IBSO_ACC_MAIN_DOCUM.ID is 'Идентификатор проводки';
comment on column U1.V_IBSO_ACC_MAIN_DOCUM.CLIENT_INN is 'Счет';
comment on column U1.V_IBSO_ACC_MAIN_DOCUM.CLIENT_ACC_NUM is 'Наименование счета';
comment on column U1.V_IBSO_ACC_MAIN_DOCUM.CLIENT_NAME is 'Наименование клиента счета';
comment on column U1.V_IBSO_ACC_MAIN_DOCUM.BENEFIC_INN is 'ИИН Бенефициара';
comment on column U1.V_IBSO_ACC_MAIN_DOCUM.BENEFIC_ACC_NUM is 'Счет бенефициара';
comment on column U1.V_IBSO_ACC_MAIN_DOCUM.BENEFIC_NAME is 'Наименование бенефициара';
comment on column U1.V_IBSO_ACC_MAIN_DOCUM.BENEFIC_BIC is 'БИК банка бенефициара';
comment on column U1.V_IBSO_ACC_MAIN_DOCUM.IS_DB is 'Дебет';
comment on column U1.V_IBSO_ACC_MAIN_DOCUM.IS_CT is 'Кредит';
comment on column U1.V_IBSO_ACC_MAIN_DOCUM.NAZN_PAY is 'Назначение платежа';
comment on column U1.V_IBSO_ACC_MAIN_DOCUM.DATE_PROV is 'Дата проведения платежа по балансу';
comment on column U1.V_IBSO_ACC_MAIN_DOCUM.AMOUNT is 'Сумма платежа в валюте';
comment on column U1.V_IBSO_ACC_MAIN_DOCUM.AMOUNT_NT is 'Сумма платежа в национальной валюте(эквивалент по курсу на дату операции)';
comment on column U1.V_IBSO_ACC_MAIN_DOCUM.CURRENCY is 'Валюта платежа';
comment on column U1.V_IBSO_ACC_MAIN_DOCUM.IIN_NAZN is 'Парсинг: ИИН из назначения платежа';
comment on column U1.V_IBSO_ACC_MAIN_DOCUM.RBO_CLIENT_ID is 'Идентификатор клиента РБО';
comment on column U1.V_IBSO_ACC_MAIN_DOCUM.RFO_CLIENT_ID is 'Идентификатор клиента RFO';
comment on column U1.V_IBSO_ACC_MAIN_DOCUM.CNT_CREDIT is 'Количество всех кредитный договоров по клиенту на текущий день';
comment on column U1.V_IBSO_ACC_MAIN_DOCUM.CNT_CARD is 'Количество всех карточных договоров по клиенту на текущий день';
comment on column U1.V_IBSO_ACC_MAIN_DOCUM.CNT_WORK_CREDIT is 'Количество действующих кредитный договоров по клиенту на текущий день';
comment on column U1.V_IBSO_ACC_MAIN_DOCUM.CNT_WORK_CARD is 'Количество действующих карточных договоров по клиенту на текущий день';
grant select on U1.V_IBSO_ACC_MAIN_DOCUM to LOADDB;
grant select on U1.V_IBSO_ACC_MAIN_DOCUM to LOADER;


