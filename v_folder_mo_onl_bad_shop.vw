create or replace force view u1.v_folder_mo_onl_bad_shop as
select x."RFOLDER_ID",x."DATE_CREATE",x."IIN",x."RFO_CLIENT_ID",x."RFO_FOLDER_ID",x."IN_SCO_POS_CODE",x."SC_IS_CATEG_A",x."SC_IS_CATEG_B",x."SCO_GCVP_PAYMENT_QTY",x."SC_GCVP_SAL_TO_SAL",x."SC_GENERAL_CONTRACT_AMOUNT",x."SC_IS_ACTIVITY_MATCHE",x."SC_EKT_NOT_A_BAD_GCVP_BAD_SHOP",x."MO_SCO_REJECT_8",x."MO_SCO_REJECT",
       y.rfo_contract_id,
       y.rfo_term_cred,
       y.c_info_cred#summa_cred_com,
       y.c_info_cred#summa_cred,
       y.c_summa_full,
       y.is_credit_issued
from
(
    select *
    from M_FOLDER_MO_ONL_BAD_SHOP_2 t
    union
    select *
    from M_FOLDER_MO_ONL_BAD_SHOP t
) x
left join (select tt.folder_id,
                  tt.folder_date_create,
                  tt.rfo_client_id,
                  tt.rfo_contract_id,
                  tt.credit_date_create,
                  tt.rfo_term_cred,
                  tt.c_info_cred#summa_cred_com,
                  tt.c_info_cred#summa_cred,
                  tt.c_summa_full,
                  tt.is_credit_issued
           from u1.M_STAGE_Z#CREDIT_DOG_2D tt
           where tt.c_info_cred#type_cred#0 in (2,3)

           union
           select tt.folder_id,
                  ff.folder_date_create,
                  tt.rfo_client_id,
                  tt.rfo_contract_id,
                  tt.contract_date contract_date_create,
                  c.c_info_cred#term_cred#quant rfo_term_cred,
                  c.c_info_cred#summa_cred_com,
                  c.c_info_cred#summa_cred,
                  c.c_summa_full,
                  tt.is_credit_issued
           from u1.v_contract_all_rfo tt
           join u1.v_folder_all_rfo ff on ff.folder_id = tt.folder_id
           join u1.v_rfo_z#credit_dog c on c.id = tt.rfo_contract_id
           where tt.contract_date >= trunc(sysdate) - 7 and
                 tt.credit_type_of_contract in ('ТОВАРЫ', 'УСЛУГИ')) y on y.folder_id = x.rfo_folder_id;
grant select on U1.V_FOLDER_MO_ONL_BAD_SHOP to LOADDB;
grant select on U1.V_FOLDER_MO_ONL_BAD_SHOP to LOADER;


