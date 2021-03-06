﻿create or replace force view u1.m_rfo_online_fld_ekt_day_new as
select f.folder_id, f.rfo_contract_id,
       trunc(f.c_date_create,'mi') as folder_date_create_mi,
       f.c_client as rfo_client_id,
       upper(bp.c_name) as process_name,
       upper(f.cr_program_name) as cr_program_name,
    /*po.x_dnp_region*/drc.region as x_dnp_region, po.x_dnp_name, sd.c_code as dep_code,
       upper(sd.c_name) as dep_name,
       sh.shop_code,
       upper(sh.shop_name) as shop_name,
       u.c_name as manager_name,
       f.c_info_cred#summa_cred as contract_amount,
       rp.is_point_active,
       case when (cmp.c_code in ('EXECUTE','CREDIT_EXEC','KAS_CHK_DOC_PACK','TO_RECLAMATION',
                   'ARCHIVE','ERR_ARCHIVE','KAS_SENT_PKD','KAS_WITHDRAWN1','KAS_WITHDRAWN2',
                   'KAS_PKD_CONTROL','KAS_PKD_REV','TR_CHANGED',
                   'TAKE_DEPART') or
                 cmp.c_priority >= 80)
               and
               bp.c_code in ('ONLINE_CRED',
                  'OPEN_CRED_PRIV_PC',
    --              'KAS_SAFE_CREDIT',
                  'KAS_AUTO_CRED_PRIV_PC',
                  'KAS_CREDIT_CASH_PRIV_PC',
                  'SET_REVOLV',
                  'KAS_OPEN_CRED_PRIV_MIN',
                  'KAS_AUTO_CRED_PRIV',
                  'OPEN_PC',
                  'KAS_CREDIT_CASH_PRIV',
            --      'KAS_PC_PURSE',
                  'OPEN_CRED_PRIV',
                  'OPEN_TRANSH',
                  'OPEN_CRED_PRIV_CRL',
                  'OPEN_CRED_PRIV_OLD')
               and std.c_code not in ('CANCEL','PREPARE')
               then 1 else 0 end as
       is_credit_issued,
       rp.point_name as folder_state,
       upper(std.c_name) as contract_status
from u1.M_RFO_ONLINE_FLD_SHOPS_DAY f
join u1.V_RFO_Z#BUS_PROCESS bp on bp.id = f.c_business --and bp.c_code = 'OPEN_CRED_PRIV_PC' --Добавлено по решению ДВКП товары + онлайн
join u1.V_RFO_Z#STRUCT_DEPART sd on sd.id = f.c_st_depart
join u1.V_POS po on po.pos_code = sd.c_code
-----------
join t_nps_dict_region_city_new drc on po.x_dnp_name=drc.city ---Добавлено в связи с изменениями в распределении городов по регионам
-----------
join u1.V_RFO_Z#CM_POINT cmp on cmp.id = f.c_point
join u1.V_RFO_POINTS rp on rp.way_id = f.c_way and rp.point_code = cmp.c_code
join u1.V_RFO_Z#STATUS_DOG std on std.id = f.credit_dog_status_id and std.c_code != 'RFO_CLOSE'
left join u1.V_RFO_Z#USER u on u.id = f.c_create_user
left join u1.V_SHOP sh on sh.rfo_shop_id = f.c_shop
where upper(f.cr_program_name) in ('ЭКСПРЕСС-КРЕДИТОВАНИЕ-ТОВАР','ЭКСПРЕСС-КРЕДИТЫ (УСЛУГИ)')
;
grant select on U1.M_RFO_ONLINE_FLD_EKT_DAY_NEW to LOADDB;


