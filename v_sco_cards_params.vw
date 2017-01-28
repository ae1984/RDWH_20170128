create or replace force view u1.v_sco_cards_params as
select c.card_id, c.card_name, p.id as param_id, p.param_name, p.param_type
from V_SCO_CARDS c
join V_SCO_CARD_PARAMS p on p.id_card = c.card_id and p.id_actual = 1 and p.using_in_scoring = 1
     and p.id not like '_RISK_%'
where c.is_sc_on = 'ON'
order by c.card_id, p.id;
grant select on U1.V_SCO_CARDS_PARAMS to LOADDB;
grant select on U1.V_SCO_CARDS_PARAMS to LOADER;


