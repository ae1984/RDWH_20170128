create or replace force view u1.v_kspkz_onl_loginuser_phones as
select "USERID","USERNAME","REGDATE","IIN","DATEOFBIRTH","PHONENUMBER","IS_BANK_EMPLOYEE","STARTTIME","CLOSETIME","SERVICENAME_LIST",prod_type_list from M_NPS_KSPKZ_ONL_LOGUSER_PHONES t;
grant select on U1.V_KSPKZ_ONL_LOGINUSER_PHONES to LOADDB;
grant select on U1.V_KSPKZ_ONL_LOGINUSER_PHONES to LOADER;
grant select on U1.V_KSPKZ_ONL_LOGINUSER_PHONES to NPS;


