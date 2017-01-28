create or replace force view u1.v_tmp_jan_new_rgoods as
select rg1.product_name from V_TMP_JAN_RGOODS_1 rg1
            union select mr.title as product_name from V_MO_RISKY_GOODS mr;
grant select on U1.V_TMP_JAN_NEW_RGOODS to LOADDB;
grant select on U1.V_TMP_JAN_NEW_RGOODS to LOADER;


