create or replace force view u1.v_folder_mo_kn_rbp as
select x."RFOLDER_ID",x."DATE_CREATE",x."FOLDER_ID",x."IN_SCO_TERM_CRED",x."IN_SCO_SUMMA_CRED",x."IN_SCO_NUM_SCORING",x."SC_IS_DEPART_RBP",x."SC_IS_CATEG_A",x."SC_IS_CATEG_B",x."SC_IS_CLIENT_NEW_BY_CON",x."SC_KDN_REGUL",x."SC_RBP_CARD_KN_NEW_RES_PRE",x."SC_RBP_CARD_KN_OLD_RES_PRE",x."SC_RBP_IS_NEED_RECALC",x."SC_RBP_IS_REJECT_EXIST",x."SC_REJECT_KN",x."MO_SCO_REJECT_KN",x."SC_RBP_PMT_FIRST",x."SC_RBP_TERM_FIRST",x."SC_RBP_PMT_LAST",x."SC_RBP_TERM_LAST",x."RBP_CNT",
       y.rfo_term_cred,
      y.c_info_cred#summa_cred_com,
      y.c_info_cred#summa_cred,
      y.c_summa_full,
      y.is_credit_issued
from
(
    /*select *
    from M_FOLDER_MO_KN_ALT_1D t
    union*/
    select *
    from M_FOLDER_MO_KN_ALT t
) x
left join (/*select tt.folder_id,
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
           where tt.c_info_cred#type_cred#0 = 1

           union*/
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
           where tt.contract_date >= to_date('11122015', 'ddmmyyyy') and
                 tt.credit_type_of_contract = 'ДЕНЬГИ') y on y.folder_id = x.folder_id;
grant select on U1.V_FOLDER_MO_KN_RBP to LOADDB;


