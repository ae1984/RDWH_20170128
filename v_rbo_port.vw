create or replace force view u1.v_rbo_port as
select
       rep_date,rbo_contract_id,rbo_client_id,
       principal,interest,overlimit,overlimit_interest,overdraft,overdraft_interest,
       principal_del,interest_del,overlimit_del,overlimit_interest_del,overdraft_del,overdraft_interest_del,
       w_principal_del,w_interest_del,w_overlimit_del,w_overlimit_interest_del,w_overdraft_del,w_overdraft_interest_del,
       pc_cred_limit,
       delinq_days,delinq_date,
       delinq_days_cli,delinq_date_cli,
       total_debt,delinq_amount,
       is_on_balance,is_card,
       total_debt_cli,del_amount_cli,
       total_debt_max,total_debt_cli_max,del_days_max,del_days_cli_max,del_amount_max,del_amount_cli_max
  from T_RBO_PORT
union all
select
       rep_date,rbo_contract_id,rbo_client_id,
       principal,interest,overlimit,overlimit_interest,overdraft,overdraft_interest,
       principal_del,interest_del,overlimit_del,overlimit_interest_del,overdraft_del,overdraft_interest_del,
       w_principal_del,w_interest_del,w_overlimit_del,w_overlimit_interest_del,w_overdraft_del,w_overdraft_interest_del,
       pc_cred_limit,
       delinq_days,delinq_date,
       delinq_days_cli,delinq_date_cli,
       total_debt,delinq_amount,
       is_on_balance,is_card,
       total_debt_cli,del_amount_cli,
       total_debt_max,total_debt_cli_max,del_days_max,del_days_cli_max,del_amount_max,del_amount_cli_max
  from T_RBO_PORT_2013
union all
select
       rep_date,rbo_contract_id,rbo_client_id,
       principal,interest,overlimit,overlimit_interest,overdraft,overdraft_interest,
       principal_del,interest_del,overlimit_del,overlimit_interest_del,overdraft_del,overdraft_interest_del,
       w_principal_del,w_interest_del,w_overlimit_del,w_overlimit_interest_del,w_overdraft_del,w_overdraft_interest_del,
       pc_cred_limit,
       delinq_days,delinq_date,
       delinq_days_cli,delinq_date_cli,
       total_debt,delinq_amount,
       is_on_balance,is_card,
       total_debt_cli,del_amount_cli,
       total_debt_max,total_debt_cli_max,del_days_max,del_days_cli_max,del_amount_max,del_amount_cli_max
  from T_RBO_PORT_2012
union all
select
       rep_date,rbo_contract_id,rbo_client_id,
       principal,interest,overlimit,overlimit_interest,overdraft,overdraft_interest,
       principal_del,interest_del,overlimit_del,overlimit_interest_del,overdraft_del,overdraft_interest_del,
       w_principal_del,w_interest_del,w_overlimit_del,w_overlimit_interest_del,w_overdraft_del,w_overdraft_interest_del,
       pc_cred_limit,
       delinq_days,delinq_date,
       delinq_days_cli,delinq_date_cli,
       total_debt,delinq_amount,
       is_on_balance,is_card,
       total_debt_cli,del_amount_cli,
       total_debt_max,total_debt_cli_max,del_days_max,del_days_cli_max,del_amount_max,del_amount_cli_max
  from T_RBO_PORT_2011
union all
select
       rep_date,rbo_contract_id,rbo_client_id,
       principal,interest,overlimit,overlimit_interest,overdraft,overdraft_interest,
       principal_del,interest_del,overlimit_del,overlimit_interest_del,overdraft_del,overdraft_interest_del,
       w_principal_del,w_interest_del,w_overlimit_del,w_overlimit_interest_del,w_overdraft_del,w_overdraft_interest_del,
       pc_cred_limit,
       delinq_days,delinq_date,
       delinq_days_cli,delinq_date_cli,
       total_debt,delinq_amount,
       is_on_balance,is_card,
       total_debt_cli,del_amount_cli,
       total_debt_max,total_debt_cli_max,del_days_max,del_days_cli_max,del_amount_max,del_amount_cli_max
  from T_RBO_PORT_2010
union all
select
       rep_date,rbo_contract_id,rbo_client_id,
       principal,interest,overlimit,overlimit_interest,overdraft,overdraft_interest,
       principal_del,interest_del,overlimit_del,overlimit_interest_del,overdraft_del,overdraft_interest_del,
       w_principal_del,w_interest_del,w_overlimit_del,w_overlimit_interest_del,w_overdraft_del,w_overdraft_interest_del,
       pc_cred_limit,
       delinq_days,delinq_date,
       delinq_days_cli,delinq_date_cli,
       total_debt,delinq_amount,
       is_on_balance,is_card,
       total_debt_cli,del_amount_cli,
       total_debt_max,total_debt_cli_max,del_days_max,del_days_cli_max,del_amount_max,del_amount_cli_max
  from T_RBO_PORT_2009;
comment on table U1.V_RBO_PORT is 'Портфель расчета задолженности на каждый день по карточным/кредитным договорам';
comment on column U1.V_RBO_PORT.REP_DATE is 'Отчетная дата';
comment on column U1.V_RBO_PORT.RBO_CONTRACT_ID is 'ID контракта (FK на Z#KAS_PC_DOG.id(карточный),Z#PR_CRED(кредитный)';
comment on column U1.V_RBO_PORT.RBO_CLIENT_ID is 'ID клиента в РБО';
comment on column U1.V_RBO_PORT.PRINCIPAL is 'Основной долг';
comment on column U1.V_RBO_PORT.INTEREST is 'Проценты по ОД';
comment on column U1.V_RBO_PORT.OVERLIMIT is 'Оверлимит';
comment on column U1.V_RBO_PORT.OVERLIMIT_INTEREST is 'Проценты по оверлимиту';
comment on column U1.V_RBO_PORT.OVERDRAFT is 'Овердрафт';
comment on column U1.V_RBO_PORT.OVERDRAFT_INTEREST is 'Проценты по овердрафту';
comment on column U1.V_RBO_PORT.PRINCIPAL_DEL is 'Просроченный ОД';
comment on column U1.V_RBO_PORT.INTEREST_DEL is 'Просроченные проценты по ОД';
comment on column U1.V_RBO_PORT.OVERLIMIT_DEL is 'Просроченный оверлимит';
comment on column U1.V_RBO_PORT.OVERLIMIT_INTEREST_DEL is 'Просроченные проценты по оверлимиту';
comment on column U1.V_RBO_PORT.OVERDRAFT_DEL is 'Просроченный овердрафт';
comment on column U1.V_RBO_PORT.OVERDRAFT_INTEREST_DEL is 'Просроченные проценты по овердрафту';
comment on column U1.V_RBO_PORT.W_PRINCIPAL_DEL is 'Внебаланс. Просроченный ОД';
comment on column U1.V_RBO_PORT.W_INTEREST_DEL is 'Внебаланс. Просроченные проценты по ОД';
comment on column U1.V_RBO_PORT.W_OVERLIMIT_DEL is 'Внебаланс. Просроченный оверлимит';
comment on column U1.V_RBO_PORT.W_OVERLIMIT_INTEREST_DEL is 'Внебаланс. Проценты по просроченному оверлимиту';
comment on column U1.V_RBO_PORT.W_OVERDRAFT_DEL is 'Внебаланс. Просроченный овердрафт';
comment on column U1.V_RBO_PORT.W_OVERDRAFT_INTEREST_DEL is 'Внебаланс. просроченные проценты по овердрафту';
comment on column U1.V_RBO_PORT.PC_CRED_LIMIT is 'Свободный остаток по кредитному лимиту';
comment on column U1.V_RBO_PORT.DELINQ_DAYS is 'Количество дней на просрочке по договору';
comment on column U1.V_RBO_PORT.DELINQ_DATE is 'Дата выхода на просрочку по договору';
comment on column U1.V_RBO_PORT.DELINQ_DAYS_CLI is 'Количество дней на просрочке по клиенту';
comment on column U1.V_RBO_PORT.DELINQ_DATE_CLI is 'Дата выхода на просрочку по клиенту';
comment on column U1.V_RBO_PORT.TOTAL_DEBT is 'Вся задолженность по договору';
comment on column U1.V_RBO_PORT.DELINQ_AMOUNT is 'Сумма просроченной задолженности(не включает внебаланс)';
comment on column U1.V_RBO_PORT.IS_ON_BALANCE is 'Признак: 1-Вся задолженность на балансе, 0 - Вся задолженность на внебалансе, 2 - Задолженность не числится на балансе(7999), списывается за счет страховой компании(старая схема по кредитам)';
comment on column U1.V_RBO_PORT.IS_CARD is 'Признак: 0 - Кредитный договор, 1 - Карточный договор';
comment on column U1.V_RBO_PORT.TOTAL_DEBT_CLI is 'Сумма всей задолженности по клиенту на отчетную дату';
comment on column U1.V_RBO_PORT.DEL_AMOUNT_CLI is 'Сумма просроченной задолженности(не включает внебаланс) по клиенту на отчетную дату';
comment on column U1.V_RBO_PORT.TOTAL_DEBT_MAX is 'Максимальная задолженность по договору на отчетную дату';
comment on column U1.V_RBO_PORT.TOTAL_DEBT_CLI_MAX is 'Максимальная задолженность по клиенту на отчетную дату';
comment on column U1.V_RBO_PORT.DEL_DAYS_MAX is 'Максимальное количество дней на просрочке по договору на отчетную дату';
comment on column U1.V_RBO_PORT.DEL_DAYS_CLI_MAX is 'Максимальное количество дней на просрочке по клиенту на отчетную дату';
comment on column U1.V_RBO_PORT.DEL_AMOUNT_MAX is 'Максимальная сумма просроченной задолженности(не включает внебаланс)';
comment on column U1.V_RBO_PORT.DEL_AMOUNT_CLI_MAX is 'Максимальная сумма просроченной задолженности(не включает внебаланс) по клиенту на отчетную дату';
grant select on U1.V_RBO_PORT to LOADDB;
grant select on U1.V_RBO_PORT to LOADER;


