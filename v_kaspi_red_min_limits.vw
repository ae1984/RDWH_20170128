create or replace force view u1.v_kaspi_red_min_limits as
select m.c_lim_sum_min
  from u1.V_RFO_Z#KAS_TP_CR_LIMIT m
  join u1.v_rfo_z#KAS_CARD_SCHEME sm on sm.c_tp_cred_limits = m.collection_id
  where  sm.c_code = 'KASPI_RED';
comment on table U1.V_KASPI_RED_MIN_LIMITS is 'Минимальные лимиты по карточной схеме KASPI RED';
grant select on U1.V_KASPI_RED_MIN_LIMITS to LOADDB;
grant select on U1.V_KASPI_RED_MIN_LIMITS to LOAD_MO;


