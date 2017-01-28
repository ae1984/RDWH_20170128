create or replace force view u1.v_form_client_phone_count_test as
select c1.contract_number, max(x.folder_id) as folder_id,
       max(x.is_rfo_must_be_rejected_hom) as is_rfo_must_be_rejected_hom,
       max(x.is_rfo_must_be_rejected_mob) as is_rfo_must_be_rejected_mob,
       max(x.is_rfo_must_be_rejected_con) as is_rfo_must_be_rejected_con
from (
select --кому счетчик в рфо не отказал
       pc.folder_id,
       max(pc.is_rfo_must_be_rejected_hom) as is_rfo_must_be_rejected_hom,
       max(pc.is_rfo_must_be_rejected_mob) as is_rfo_must_be_rejected_mob,
       max(pc.is_rfo_must_be_rejected_con) as is_rfo_must_be_rejected_con
from V_FORM_CLIENT_PHONE_COUNT_2 pc
join V_RFO_Z#CM_CHECKPOINT cp1 on cp1.id = pc.folder_id
where --to_char(cp1.c_date_create,'yyyy - mm') = '2012 - 11' and
      pc.is_rfo_must_be_rejected = 1 and
      pc.folder_id not in (
          select distinct cp.id
              from V_RFO_Z#KAS_CANCEL c
              join V_RFO_Z#KAS_CANCEL_TYPES ct on ct.id = c.c_type
              join V_RFO_Z#FOLDERS f on f.id = c.c_folders
              join V_RFO_Z#CM_CHECKPOINT cp on cp.id = f.id
              where ct.c_code in ('VERIFICATION_RATING','VERIFIC_RATING_SOFT') --and
                    --to_char(cp.c_date_create,'yyyy - mm') = '2012 - 11'
      )
group by pc.folder_id
) x
join V_CONTRACT_FOLDER_1st_LINK_RFO c1 on c1.folder_id_first = x.folder_id --and
--     c.contract_number is not null
group by c1.contract_number
;
grant select on U1.V_FORM_CLIENT_PHONE_COUNT_TEST to LOADDB;
grant select on U1.V_FORM_CLIENT_PHONE_COUNT_TEST to LOADER;


