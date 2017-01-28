create or replace procedure u1.ETLT_FOLDER_ALL_RFO is
begin
    delete from V_FOLDER_ALL_RFO t
    where t.folder_date_create>=trunc(sysdate)-180;
    
    insert into V_FOLDER_ALL_RFO
    select /*+ parallel(10)*/
           fld.id as folder_id,
           fld.c_n as folder_number,
           cp.c_date_create as folder_date_create,
           to_char(cp.c_date_create,'yyyy - mm') as folder_yy_mm_create,
           to_char(cp.c_date_create,'yyyy') as folder_year_create,
           fld.c_client as rfo_client_id,
           upper(cmp.c_name) as folder_state, -- дублирование с route_point_name
           bp.c_code as process_code,
           upper(bp.c_name) as process_name,
           cmw.c_code as route_code,
           upper(cmw.c_name) as route_name,
           upper(u1.c_name) as delivery_type,
           nvl(upper(u2.c_name),'РФО') as source_system,
           fcl.card_contract_id,
           fcl.card_contract_number,
           fcl.credit_contract_id,
           fcl.credit_contract_number,
           nvl(fcl.credit_contract_id, fcl.card_contract_id) as contract_id,
           sd.c_code as pos_code,
           upper(dnp.c_name) as dnp_name,
               case when bp.c_code in (
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
                  'OPEN_CRED_PRIV_OLD',
                  'ONLINE_CRED',
                  'KASPI_RED'
                 ) then 1 else 0 end as
           is_credit_process,
           case when (cmp.c_code in ('EXECUTE','CREDIT_EXEC','KAS_CHK_DOC_PACK','TO_RECLAMATION',
                       'ARCHIVE','ERR_ARCHIVE','KAS_SENT_PKD','KAS_WITHDRAWN1','KAS_WITHDRAWN2',
                       'KAS_PKD_CONTROL','KAS_PKD_REV','TR_CHANGED',
                       'TAKE_DEPART') or
                     cmp.c_priority >= 80)
                   and
                   bp.c_code in (
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
                      'OPEN_CRED_PRIV_OLD',
                      'ONLINE_CRED',
                      'KASPI_RED'
                    ) then 1 else 0 end as
           is_credit_issued,
           case when ar.c_cancel_point is null and (cmp.c_code in ('EXECUTE','CREDIT_EXEC','KAS_CHK_DOC_PACK','TO_RECLAMATION',
                       'ARCHIVE','ERR_ARCHIVE','KAS_SENT_PKD','KAS_WITHDRAWN1','KAS_WITHDRAWN2',
                       'KAS_PKD_CONTROL','KAS_PKD_REV','TR_CHANGED',
                       'TAKE_DEPART') or
                     cmp.c_priority >= 80)
                   and
                   bp.c_code in (
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
                      'OPEN_CRED_PRIV_OLD',
                      'ONLINE_CRED',
                      'KASPI_RED')
    /*
                   and cmp.c_code not like 'CANCEL%'
                   and cmp.c_status_group <> '#CANCELED#'*/
                    then 1 else 0 end as
           is_credit_issued_new,
               case when rfd.form_client_id is not null then 1 else 0 end as
           is_form_exists,
           uwr1.c_name as underwriter,
           uwr2.c_name as underwriter_senior,
           rfd.form_client_id,
           fld.c_docs as fld_c_docs,
           rfd3.autocalc_doc_id,
           forg.org_bin,
    --       nvl(fpcc.is_prev_credit_card_con_exists,0) as is_prev_credit_card_con_exists,
           cmp.c_code as route_point_code,
           upper(cmp.c_name) as route_point_name,
           uc.c_username as expert_login,
           uc.c_name as expert_name,
           upper(ca.c_value) as expert_position,
           case when uc.c_username = 'ESB_USER' then 0 else 1 end as is_daytime_decision_folder,
           fld.c_result_oper as manager_result,
           fld.c_result_oper_note as manager_result_note,
           time_sec.manager_input_time,
           case when is_individ_enterpreneur_clear.folder_id is null then 0 else 1 end as is_ind_enterpreneur_clear,--Чистый ИП
           case when is_individ_enterpreneur.folder_id is null then 0 else 1 end as is_ind_enterpreneur,  -- Грязный ИП
           uc.id as expert_id,
           case when alt.folder_id is not null then 1 else 0 end as is_alt
    from V_RFO_Z#FOLDERS fld
    join V_RFO_Z#CM_CHECKPOINT cp on cp.id = fld.id
    join V_RFO_Z#CM_WAY cmw on cmw.id = cp.c_way
    join V_RFO_Z#CM_POINT cmp on cmp.id = cp.c_point
    join V_RFO_Z#BUS_PROCESS bp on bp.id = fld.c_business
    --
    left join V_FOLDER_ALL_RFO_PRE1 ar on ar.c_folder_ref = fld.id
    --
    left join V_RFO_Z#USER uc on uc.id = cp.c_create_user
    left join V_RFO_Z#CASTA ca on ca.id = uc.c_casta
    left join V_FOLDER_ALL_RFO_PRE2 rfd on rfd.collection_id = fld.c_docs
    left join V_RFO_Z#KAS_UNIVERSAL_D u1 on u1.id = fld.c_kas_vid_delivery
    left join V_RFO_Z#KAS_UNIVERSAL_D u2 on u2.id = fld.c_kas_sys_ref
    left join V_FOLDER_CONTRACT_ALL_LINK_RFO fcl on fcl.folder_id = fld.id
    left join V_RFO_Z#STRUCT_DEPART sd on sd.id = cp.c_st_depart
    left join V_RFO_Z#KAS_UPRAVL_DNP dnp on dnp.id = sd.c_upravl_dnp_ref
    left join V_FOLDER_ALL_RFO_PRE3 rfd2  on rfd2.collection_id = fld.c_docs
    left join V_RFO_Z#USER uwr1 on uwr1.id = rfd2.c_underwriter
    left join V_RFO_Z#USER uwr2 on uwr2.id = rfd2.c_high_underwriter
    left join V_FOLDER_ALL_RFO_PRE4 rfd3  on rfd3.collection_id = fld.c_docs
    left join V_FOLDER_ALL_RFO_PRE5 forg on forg.folder_id = fld.id
    left join V_FOLDER_ALL_RFO_PRE6 time_sec on time_sec.id = fld.id
    left join V_FOLDER_ALL_RFO_PRE7 is_individ_enterpreneur_clear on  is_individ_enterpreneur_clear.folder_id=fld.id
    left join V_FOLDER_ALL_RFO_PRE8 is_individ_enterpreneur on is_individ_enterpreneur.folder_id=fld.id
    left join V_FOLDER_ALL_RFO_PRE9 alt on alt.folder_id = fld.id
    left join V_FOLDER_ALL_RFO fld1 on fld1.folder_id=fld.id         
    where cp.c_date_create>=trunc(sysdate)-180 /*(select max(folder_date_create) from V_FOLDER_ALL_RFO)*/ 
         and fld1.folder_id is null;
    commit;
end ETLT_FOLDER_ALL_RFO;
/

