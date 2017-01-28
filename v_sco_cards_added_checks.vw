create or replace force view u1.v_sco_cards_added_checks as
select c.card_id, c.card_name, c.is_sc_on,
       substr(ca.calculation,instr(ca.calculation,'.')+1, instr(ca.calculation,'(@')-instr(ca.calculation,'.')-1) as check_code,
       case when substr(ca.calculation,instr(ca.calculation,'.')+1, instr(ca.calculation,'(@')-instr(ca.calculation,'.')-1)
            not in ('RISK_MONITOR','RISK_CRIMINAL') then 'ON' end is_check_on,
       p.id as param_id, p.param_name, p.param_type, ca.calculation
from V_SCO_CARDS c
join V_SCO_CARD_PARAMS p on p.id_card = c.card_id and p.id_actual = 1 and p.using_in_scoring = 1
     and p.id like '_RISK_%'
join V_SCO_RULES ru on ru.id_param = p.id and ru.id_card = c.card_id and ru.id_actual = 1
join V_SCO_CALCULATIONS ca on ca.id = ru.id_calculation and ca.id_param = p.id and
     ru.type_calculation = 'CALCULATION' and ca.id_actual = 1
order by c.card_id, p.id;
grant select on U1.V_SCO_CARDS_ADDED_CHECKS to LOADDB;
grant select on U1.V_SCO_CARDS_ADDED_CHECKS to LOADER;


