create or replace force view u1.v_app_miner_online_old as
select t1.app_id,
       /*t1.rfo_client_id,
       t1.claim_id,
       t1.folder_date_create_mi,
       t1.product_type,*/

       t1.onl_app_30d_cnt_x as cnt_cl_claim,
       t1.onl_iss_30d_cnt_x as cnt_cl_issued,
       t1.onl_cnl_30d_cnt_x as cnt_cl_cancel,
       t1.onl_model_30d_cnt_x as cnt_cl_model,
       t1.onl_categ_30d_cnt_x as cnt_cl_categ,
       t1.onl_categ_cnl_30d_cnt_x as cnt_cl_categ_cancel,
       t1.onl_model_eq_30d_cnt_x as cnt_cl_eq_models,
       t1.onl_categ_eq_30d_cnt_x as cnt_cl_eq_categ,
       t1.onl_model_eq_iss_30d_cnt_x as cnt_cl_eq_model_app,
       t1.onl_categ_eq_iss_30d_cnt_x as cnt_cl_eq_categ_app,
       t1.onl_deliv_30d_cnt_x as cnt_cl_delivered,
       t1.onl_app_30d_sum_x as sum_cl,
       t1.onl_iss_30d_sum_x as sum_cl_app,
       t1.onl_shop_30d_cnt_x as cnt_cl_dif_shops,
       t1.onl_shop_cnl_30d_cnt_x as cnt_cl_dif_shops_cancel,
       t1.onl_mobile_30d_cnt_x as cnt_cl_mobile_phone,

       t1.onl_app_30d_cnt as cnt_cl_claim_t1,
       t1.onl_iss_30d_cnt as cnt_cl_issued_t1,
       t1.onl_cnl_30d_cnt as cnt_cl_cancel_t1,
       t1.onl_model_30d_cnt as cnt_cl_model_t1,
       t1.onl_categ_30d_cnt as cnt_cl_categ_t1,
       t1.onl_categ_cnl_30d_cnt as cnt_cl_categ_cancel_t1,
       t1.onl_model_eq_30d_cnt as cnt_cl_eq_models_t1,
       t1.onl_categ_eq_30d_cnt as cnt_cl_eq_categ_t1,
       t1.onl_model_eq_iss_30d_cnt as cnt_cl_eq_model_app_t1,
       t1.onl_categ_eq_iss_30d_cnt as cnt_cl_eq_categ_app_t1,
       t1.onl_deliv_30d_cnt as cnt_cl_delivered_t1,
       t1.onl_app_30d_sum as sum_cl_t1,
       t1.onl_iss_30d_sum as sum_cl_app_t1,
       t1.onl_shop_30d_cnt as cnt_cl_dif_shops_t1,
       t1.onl_shop_cnl_30d_cnt as cnt_cl_dif_shops_cancel_t1,
       t1.onl_mobile_30d_cnt as cnt_cl_mobile_phone_t1,
       --t1.cnt_cl_googleid,

       --t2.mobile_phone,
       t2.onl_ph_app_30d_cnt_x as cnt_ph,
       t2.onl_ph_cnl_30d_cnt_x as cnt_ph_cancel,
       t2.onl_ph_iss_30d_cnt_x as cnt_ph_app,
       t2.onl_ph_deliv_30d_cnt_x as cnt_ph_delivered,
       t2.onl_ph_app_30d_sum_x as sum_ph,
       t2.onl_ph_iss_30d_sum_x as sum_ph_app,
       t2.onl_ph_cl_30d_cnt_x as cnt_ph_client,

       t2.onl_ph_app_30d_cnt as cnt_ph_t1,
       t2.onl_ph_cnl_30d_cnt as cnt_ph_cancel_t1,
       t2.onl_ph_iss_30d_cnt as cnt_ph_app_t1,
       t2.onl_ph_deliv_30d_cnt as cnt_ph_delivered_t1,
       t2.onl_ph_app_30d_sum as sum_ph_t1,
       t2.onl_ph_iss_30d_sum as sum_ph_app_t1,
       t2.onl_ph_cl_30d_cnt_x as cnt_ph_client_t1,

       --
       t3.onl_cl_ga_eq_30d_cnt_x as cnt_ga_eq_client,
       t3.onl_cl_ga_eq_30d_cnt as cnt_ga_eq_client_t1,

       --
       fld1.app_tk_30d_cnt_x as cnt_cl_offline,
       fld1.app_tk_cnl_30d_cnt_x as cnt_cl_offline_cancel,
       fld1.app_tk_30d_cnt as cnt_cl_offline_t1,
       fld1.app_tk_cnl_30d_cnt as cnt_cl_offline_cancel_t1,

       --
       fld1.app_kn_30d_cnt_x as cnt_cl_kn,
       fld1.app_kn_cnl_30d_cnt_x as cnt_cl_kn_cancel,
       fld1.app_kn_30d_cnt as cnt_cl_kn_t1,
       fld1.app_kn_cnl_30d_cnt as cnt_cl_kn_cancel_t1

from U1.M_APP_MINER_ONLINE_PARAM t1
left join U1.M_APP_MINER_ONLINE_PHONE t2 on t2.app_id = t1.app_id
left join U1.M_APP_MINER_ONLINE_GA t3 on t3.app_id = t1.app_id
left join U1.M_APP_MINER_FOLDER_PRE1 fld1 on fld1.app_id = t1.app_id
--left  join U1.M_APP_MINER_FOLDER_PRE1 t5 on t5.app_id = t1.app_id
;
comment on table U1.V_APP_MINER_ONLINE_OLD is 'Miner: Параметры по заявкам продукта ОНЛАЙН со старыми названиями полей';
comment on column U1.V_APP_MINER_ONLINE_OLD.APP_ID is 'Идентификатор контракта, либо rfo_contract_id либо online_claim_id';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_CLAIM is 'Количество заказов этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_ISSUED is 'Количество выданных заказов этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_CANCEL is 'Количество отмененных заказов этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_MODEL is 'Количество товаров по всем заказам этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_CATEG is 'Количество типов товаров по всем заказам этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_CATEG_CANCEL is 'Количество типов товаров по отмененным заказам этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_EQ_MODELS is 'Количество заказов с таким же товаром этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_EQ_CATEG is 'Количество заказов с таким же типом товара этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_EQ_MODEL_APP is 'Количество выданных заказов с таким же товаром этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_EQ_CATEG_APP is 'Количество выданных заказов с таким же типом товара этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_DELIVERED is 'Количество доставок этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.SUM_CL is 'Общая сумма всех заказов этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.SUM_CL_APP is 'Общая сумма выданных заказов этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_DIF_SHOPS is 'Количество разных магазинов по всем заказам';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_DIF_SHOPS_CANCEL is 'Количество разных магазинов по отмененным заказам';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_MOBILE_PHONE is 'Количество телефонных номеров этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_CLAIM_T1 is 'Количество заказов этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_ISSUED_T1 is 'Количество выданных заказов этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_CANCEL_T1 is 'Количество отмененных заказов этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_MODEL_T1 is 'Количество товаров по всем заказам этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_CATEG_T1 is 'Количество типов товаров по всем заказам этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_CATEG_CANCEL_T1 is 'Количество типов товаров по отмененным заказам этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_EQ_MODELS_T1 is 'Количество заказов с таким же товаром этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_EQ_CATEG_T1 is 'Количество заказов с таким же типом товара этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_EQ_MODEL_APP_T1 is 'Количество выданных заказов с таким же товаром этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_EQ_CATEG_APP_T1 is 'Количество выданных заказов с таким же типом товара этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_DELIVERED_T1 is 'Количество доставок этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.SUM_CL_T1 is 'Общая сумма всех заказов этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.SUM_CL_APP_T1 is 'Общая сумма выданных заказов этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_DIF_SHOPS_T1 is 'Количество разных магазинов по всем заказам';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_DIF_SHOPS_CANCEL_T1 is 'Количество разных магазинов по отмененным заказам';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_MOBILE_PHONE_T1 is 'Количество телефонных номеров этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_PH is 'Количество заказов с этого номера телефона';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_PH_CANCEL is 'Количество отмененных заказов с этого номера телефона';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_PH_APP is 'Количество выданных заказов с этого номера телефона';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_PH_DELIVERED is 'Количество доставок заказов с этого номера телефона';
comment on column U1.V_APP_MINER_ONLINE_OLD.SUM_PH is 'Общая сумма всех заказов с этого телефона';
comment on column U1.V_APP_MINER_ONLINE_OLD.SUM_PH_APP is 'Общая сумма выданных заказов с этого телефона';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_PH_CLIENT is 'Количество других клиентов на этом телефоне клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_PH_T1 is 'Количество заказов с этого номера телефона';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_PH_CANCEL_T1 is 'Количество отмененных заказов с этого номера телефона';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_PH_APP_T1 is 'Количество выданных заказов с этого номера телефона';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_PH_DELIVERED_T1 is 'Количество доставок заказов с этого номера телефона';
comment on column U1.V_APP_MINER_ONLINE_OLD.SUM_PH_T1 is 'Общая сумма всех заказов с этого телефона';
comment on column U1.V_APP_MINER_ONLINE_OLD.SUM_PH_APP_T1 is 'Общая сумма выданных заказов с этого телефона';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_GA_EQ_CLIENT is 'Количество других клиентов с тем же гугл ид';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_GA_EQ_CLIENT_T1 is 'Количество других клиентов с тем же гугл ид';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_OFFLINE is 'Количество заявок на оффлайн этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_OFFLINE_CANCEL is 'Количество отказов на оффлане этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_OFFLINE_T1 is 'Количество заявок на оффлайн этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_OFFLINE_CANCEL_T1 is 'Количество отказов на оффлане этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_KN is 'Количество заявок на КН этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_KN_CANCEL is 'Количество отказов на КН этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_KN_T1 is 'Количество заявок на КН этого клиента';
comment on column U1.V_APP_MINER_ONLINE_OLD.CNT_CL_KN_CANCEL_T1 is 'Количество отказов на КН этого клиента';
grant select on U1.V_APP_MINER_ONLINE_OLD to LOADDB;


