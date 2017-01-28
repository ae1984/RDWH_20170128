create or replace force view u1.v_cred_dogs as
select b.rfo_client_id, b.start_date, b.date_fact_end, b.date_plan_end
from
  U1.m_rbo_contract_bas b where b.tariff_plan_name_code not in ('PC_ZP2_NEW_GK_TAIB', 'PC_ZP_NEW', 'PC_ZP2_NEW_GS', 'DEPOSIT_CARD', 'PC_ZP_OLD', 'PRIVILEGE', 'PC_BEST_ZP',
  'GOLD_CARD', 'PC_ZP_SOTR', 'PC_ZP2_NEW_GK', 'PC_ZP_TAIB');
comment on table U1.V_CRED_DOGS is 'Действующие и закрытые кредитные договора';
comment on column U1.V_CRED_DOGS.RFO_CLIENT_ID is 'ID Клиента';
comment on column U1.V_CRED_DOGS.START_DATE is 'Дата начала кредитного договора';
comment on column U1.V_CRED_DOGS.DATE_FACT_END is 'Фактическая дата закрытия кредитного договора';
comment on column U1.V_CRED_DOGS.DATE_PLAN_END is 'Плановая дата закрытия кредитного договора';
grant select on U1.V_CRED_DOGS to LOADDB;
grant select on U1.V_CRED_DOGS to LOADER;
grant select on U1.V_CRED_DOGS to LOAD_MO;


