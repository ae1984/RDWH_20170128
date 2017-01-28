create or replace force view u1.v_sco_cards_rfo as
select x."CARD_NUM",x."CARD_TIME",x."CRED_PROGRAM_NAME",x."CRED_PROGRAM_CODE",
       case when sp.process_count_30days > 0 then 1 end as is_used_30_days,
       sp.process_count_30days,
       sc.card_prod as mo_card_prod, sc.is_sc_on
from (
    select to_number(m.c_ext_code) as card_num, 'DAY' as card_time,
           upper(pp.c_name) as cred_program_name,
           pp.c_code as cred_program_code
    from V_RFO_Z#MAP_OBJ_IN_OUT m
    left join V_RFO_Z#PROD_PROPERTY pp on pp.id = m.c_id_object
    left join V_RFO_Z#PROPERTY_GRP pg on pg.id = pp.c_group_prop
    where m.c_class_object = 'PROD_PROPERTY'
    union
    select  to_number(tv.c_value) as card_num, 'NIGHT' as card_time,
            upper(pr.c_name) as cred_program_name,
            pr.c_code as cred_program_code
    from V_RFO_Z#TUNE t
    join V_RFO_Z#TUNE_VAL tv on tv.collection_id = t.c_values
    join V_RFO_Z#PROD_PROPERTY pr on pr.id = to_number(substr(tv.c_canon_vals, 1, 16))
    where t.c_code = 'NIGHT_SCOR_MAP'
) x
left join M_MO_STAT_SCO_CRED_PROGRAM_30D sp on sp.cr_program_code = x.cred_program_code and
                                               sp.card_num = x.card_num
left join V_SCO_CARDS sc on sc.card_id = x.card_num
order by 1, 3;
grant select on U1.V_SCO_CARDS_RFO to LOADDB;
grant select on U1.V_SCO_CARDS_RFO to LOADER;


