create or replace force view u1.v_dhk_acc_special_offer_con as
select --+ parallel(5)
       t.contract_number,
       t.spof_end_date,
       t.restructing_type_code,
       t.spof_spec_offer_status_cd,
       t.restr_type
  from U1.M_DWH_ACC_SPECIAL_OFFER_CON t
;
grant select on U1.V_DHK_ACC_SPECIAL_OFFER_CON to LOADDB;
grant select on U1.V_DHK_ACC_SPECIAL_OFFER_CON to LOADER;


