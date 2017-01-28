create or replace force view u1.v_rfo_online_fld_ekt_phones as
select f."CONTRACT_NUMBER",f."POS_CODE",f."POS_NAME",f.manager_name,f."BEGIN_DATE",f."CONTRACT_TERM_MONTHS",f."PRODUCER",f."PRODUCT_NAME",f."GOODS_COST",f."BILL_SUM",f."CONTRACT_AMOUNT",f."CIENT_IIN",f."CLIENT_NAME",f."UNP_NAME",f."CONTACT",f."TIME_DATE",f.prod_type_list
  from (select *
          from m_rfo_online_fld_ekt_phon_uniq d
         order by d.contract_number) f
-- where rownum < 101
;
grant select on U1.V_RFO_ONLINE_FLD_EKT_PHONES to LOADDB;
grant select on U1.V_RFO_ONLINE_FLD_EKT_PHONES to LOADER;
grant select on U1.V_RFO_ONLINE_FLD_EKT_PHONES to NPS;


