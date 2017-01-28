create or replace force view u1.v_out_rfo_z#kas_online_buy as
select /*+ parallel(5)*/
         ob.id as online_buy_id,
         ob.c_process_id as process_id,
         ob.c_date_create as date_create,
         sd.c_code as status_code,
         sd.c_name as status_name,
         ob.c_total_amount as total_amount,
         s.c_code as shop_code,
         s.c_name as shop_name,
         ob.c_prod_info,
         (select listagg(c_name,';') within group (order by c_name)
            from V_RFO_Z#PROD_INFO
           where collection_id = ob.c_prod_info) as prod_info
    from V_RFO_Z#KAS_ONLINE_BUY ob
    join V_RFO_Z#STATUS_DOG sd on sd.id = ob.c_state_id
    left join V_RFO_Z#SHOPS s on s.id = ob.c_shop;
comment on table U1.V_OUT_RFO_Z#KAS_ONLINE_BUY is 'KAS. Онлайн покупка';
comment on column U1.V_OUT_RFO_Z#KAS_ONLINE_BUY.ONLINE_BUY_ID is 'Идентификатор онлайн покупки';
comment on column U1.V_OUT_RFO_Z#KAS_ONLINE_BUY.PROCESS_ID is 'Идентификатор сквозного процесса - ID заказа';
comment on column U1.V_OUT_RFO_Z#KAS_ONLINE_BUY.DATE_CREATE is 'Дата анкеты';
comment on column U1.V_OUT_RFO_Z#KAS_ONLINE_BUY.STATUS_CODE is 'Код состояния';
comment on column U1.V_OUT_RFO_Z#KAS_ONLINE_BUY.STATUS_NAME is 'Наименование состояния';
comment on column U1.V_OUT_RFO_Z#KAS_ONLINE_BUY.TOTAL_AMOUNT is 'Общая сумма выбранных товаров (корзины)';
comment on column U1.V_OUT_RFO_Z#KAS_ONLINE_BUY.SHOP_CODE is 'Код Города/Магазина/Подразделения получения товара';
comment on column U1.V_OUT_RFO_Z#KAS_ONLINE_BUY.SHOP_NAME is 'Наименование Города/Магазина/Подразделения получения товара';
comment on column U1.V_OUT_RFO_Z#KAS_ONLINE_BUY.PROD_INFO is 'Информация по товарам:Наименование';
grant select on U1.V_OUT_RFO_Z#KAS_ONLINE_BUY to IT6_USER;
grant select on U1.V_OUT_RFO_Z#KAS_ONLINE_BUY to LOADDB;
grant select on U1.V_OUT_RFO_Z#KAS_ONLINE_BUY to LOADER;


