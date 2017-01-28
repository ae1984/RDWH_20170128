create or replace force view u1.v_tdwh_slandokz_adverts as
select /*+ noparallel */
        mn.id,
        mn.adv_name,
        mn.price,
        mn.region_name,
        mn.address,
        mn.phone,
        mn.seller_name,
        mn.view_cnt,
        mn.idate,
        mn.cat_name,
        mn.slando_adv_id,
        mn.advert_url,
        mn.phone1,
        mn.phone2,
        mn.phone3,
        mn.phone4,
        mn.phone5,
        mn.phone6,
        mn.phone7,
        mnp.phone1_clear,
        mnp.phone2_clear,
        mnp.phone3_clear,
        mnp.phone4_clear,
        mnp.phone5_clear,
        mnp.phone6_clear,
        mnp.phone7_clear,
        mn.parent_cat_id,
        mn.seller_url,
        mn.mobile_source,
        mn.seller_since,
        mn.publish_date,
        mn.advert_cat_id,
        mn.skype,
        mn.icq,
        mn.client_dwh_id,
        mn.is_deleted,
        mn.udate,
        mn.thread_id,
        mn.currency
  from U1.M_TDWH_SLANDOKZ_ADVERTS mn
  join U1.M_TDWH_SLANDOKZ_ADVERTS_PRE mnp on mn.id = mnp.id;
grant select on U1.V_TDWH_SLANDOKZ_ADVERTS to LOADDB;
grant select on U1.V_TDWH_SLANDOKZ_ADVERTS to LOADER;


