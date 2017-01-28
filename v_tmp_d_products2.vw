create or replace force view u1.v_tmp_d_products2 as
select product_name, instr(product_name,'/',-1,1) x1 from v_tmp_d_products1
where product_name like '%/%' and begin_date>='01-01-2014';
grant select on U1.V_TMP_D_PRODUCTS2 to LOADDB;
grant select on U1.V_TMP_D_PRODUCTS2 to LOADER;


