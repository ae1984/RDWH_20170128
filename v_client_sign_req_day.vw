create or replace force view u1.v_client_sign_req_day as
select distinct fld.id as folder_id

  from GG_RFO.Z#KAS_ONLINE_BUY b
  join GG_RFO.Z#KAS_ONLINE_CLAIM oc on oc.c_buy_ref = b.id
  join GG_RFO.Z#CM_CHECKPOINT cp on cp.id = oc.c_folder_ref
  join GG_RFO.Z#FOLDERS fld on fld.id = cp.id
  join GG_RFO.Z#CM_HISTORY h     on h.collection_id = cp.c_history
  left join GG_RFO.Z#USER u      on u.id = h.c_user
  where b.c_date_create > trunc(sysdate)
        and cp.C_DATE_CREATE > trunc(sysdate)
        and upper(u.c_name) not in ('ПОЛЬЗОВАТЕЛЬ АВТОМАТИЧЕСКАЯ ОБРАБОТКА','ESB_USER');

