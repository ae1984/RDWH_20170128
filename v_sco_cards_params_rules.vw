create or replace force view u1.v_sco_cards_params_rules as
select c.card_id, c.card_name, p.id as param_id, p.param_name, p.param_type,
       ru.type_calculation, replace(replace(upper(ru.rules),'&',''),'QUOTE;','"') as rules,
       ca.calculation, ru.x_coefficient, ru.x_weight
from V_SCO_CARDS c
join V_SCO_CARD_PARAMS p on p.id_card = c.card_id and p.id_actual = 1 and p.using_in_scoring = 1
     and p.id not like '_RISK_%'
join V_SCO_RULES ru on ru.id_param = p.id and ru.id_card = c.card_id and ru.id_actual = 1
left join V_SCO_CALCULATIONS ca on ca.id = ru.id_calculation and ca.id_param = p.id and
     ru.type_calculation = 'CALCULATION' and ca.id_actual = 1
where c.is_sc_on = 'ON'
order by c.card_id, p.id, replace(replace(upper(ru.rules),'&',''),'QUOTE;','"');
grant select on U1.V_SCO_CARDS_PARAMS_RULES to LOADDB;
grant select on U1.V_SCO_CARDS_PARAMS_RULES to LOADER;


