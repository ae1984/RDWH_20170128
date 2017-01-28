create or replace force view u1.v_sco_cards as
select c.id as card_id,
       decode(c.id,2,'2 КН',6,'6 ЛК',8,'8 ЭКТ',9,'9 ЛКН',13,'13 ПК',
                   16,'16 ЗК',17,'17 КН15',18,'18 ЭКУ',22,'22 КНП',27,'27 ПКН',
                   28,'28 АК',38,'38 АЗЧ',43,'43 КК',102,'102 ЛК,КНП',103,'103 ПК'
       ) as card_prod,
       c.card_name,
       case when c.id > 100 then 'NIGHT' else 'DAY' end as is_day,
       r.blank_every,
       case when c.id in (2,13,18,22,43,103) then 'ON' end as is_sc_on,
       decode(c.id,2,'<=25%',13,'>=130',18,'<=20%',22,'<=25%',43,'>=97',103,'>=141') as yes_cond,
       case when f.formula = 'SET @RESULT=@AMOUNT' then 'NEW' else 'OLD' end as is_sc_new,
       decode(c.id,2,1,6,1,8,1,9,1,16,6,18,8,22,2,28,8,38,8,106,6,109,9,122,22,127,27) as ancestor,
       f.formula, r.return_conditions
from V_SCO_SCOCARDS c
join V_SCO_CARD_CONFIG f on f.id_card = c.id and f.id_actual = 1
join V_SCO_CARD_RETURN_CONDITIONS r on r.id_card = c.id and r.id_actual = 1
where c.id_actual = 1 and
      c.id in (2,6,8,9,13,16,17,18,22,27,28,38,43,102,103)
order by c.id;
grant select on U1.V_SCO_CARDS to LOADDB;
grant select on U1.V_SCO_CARDS to LOADER;


