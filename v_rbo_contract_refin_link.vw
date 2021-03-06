﻿create or replace force view u1.v_rbo_contract_refin_link as
select
--RDWH2.0
       rbo_contract_id_to,
       contract_number_to,
       refin_contract_number,
       refin_rbo_contract_id,
       refin_type,
       refin_summa,
       refin_date,
       kas_pc_fo_id
from (
select
       rlt.rbo_contract_id_to,
       rlt.contract_number_to,
       rlt.refin_contract_number,
       ca.rbo_contract_id as refin_rbo_contract_id,
       rlt.refin_type,
       rlt.refin_summa,
       rlt.refin_date,
       pf.id as kas_pc_fo_id
from (
        select
            pc.id        as rbo_contract_id_to,                                                                        --id контракта из РБО(ГУ)
            pc.c_num_dog as contract_number_to,                                                                            --номер договора карты(ГУ)
            p.c_date_begin as refin_date,                                                                              --дата рефинансирования
            replace(replace(regexp_substr(p.c_str_value,'PRODUCT#.*?]',1),'PRODUCT#',''),']','') as refin_contract_number, --номер рефинансированного договора
            to_number(replace(replace(regexp_substr(p.c_str_value,'SUMM#.*?]',1),'SUMM#',''),']','')) as refin_summa,  --сумма рефинансирования
            replace(replace(regexp_substr(p.c_str_value,'CLASS#.*?]',1),'CLASS#',''),']','') as refin_type,            --тип рефинансированного договора (кредит,карта)
            pc.c_fo_arr                                                                                                --ссылка на проводки
        from u1.V_RBO_Z#PROPERTY p
        join u1.V_RBO_Z#PROPERTY_TYPE pt on p.c_property_type = pt.id
        join u1.V_RBO_Z#KAS_PC_DOG pc    on p.collection_id = pc.c_property_arr
        where pt.c_code = 'REFIN_PRODUCT' and p.c_date_begin > to_date('22-04-2013','dd-mm-yyyy')
     ) rlt
  --join u1.M_RBO_CONTRACT_BAS ca on ca.contract_number = rlt.refin_contract_number
  join (
      select
          pc.id as rbo_contract_id
          ,pc.c_num_dog as contract_number
      from V_RBO_Z#PR_CRED pc
      union all
      select
           kpd.id as rbo_contract_id
          ,kpd.c_num_dog as contract_number
      from V_RBO_Z#KAS_PC_DOG kpd
  ) ca on ca.contract_number = rlt.refin_contract_number
left join (
       select
           fo.id
           ,fo.collection_id
           ,fo.c_doc_date
           ,fo.c_summa as c_summa
           ,fo.c_is_storno
       from u1.V_RBO_Z#VID_OPER_DOG vd
       join u1.T_RBO_Z#KAS_PC_FO fo on vd.id = fo.c_vid_oper_ref
       where vd.c_code = 'PC_FROM_CARD_FOR_REFINANCING' and fo.c_doc_state = 'PROV') pf on pf.collection_id = rlt.c_fo_arr and pf.c_doc_date = rlt.refin_date
 union all
 select rbo_contract_id,
        deal_number_to,
        refin_deal_number,
        refin_rbo_contract_id,
        refin_type,
        refin_summa,
        refin_date,
        kas_pc_fo_id
 from u1.T_RDWH_CON_REFIN_LINK_22042013
) tt
;
grant select on U1.V_RBO_CONTRACT_REFIN_LINK to LOADDB;


