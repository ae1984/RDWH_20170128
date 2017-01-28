create or replace force view u1.v_tmp_d_products5 as
select
cr_program_name,
contract_number,
pos_code,
POS_NAME,
start_month,
begin_date,
contract_term_days,
actual_end_date,
CONTRACT_TERM_Months,
PRODUCER,
product_name,
product_model,
quantity,
goods_cost,
BILL_SUM,
goods_price,
contract_amount,
product_type_name,
client_rnn,
client_iin,
client_name,
RFO_SHOP_ID,
SHOP_CODE,
shop_name,
city_name,
fil_name,
unp_name,
goods_id,
servise_id,
INITIAL_PAYMENT,
trim(product_name_modified2) as product_name_modified2
from v_tmp_d_products4 p1
where product_name_modified2 is not null;
grant select on U1.V_TMP_D_PRODUCTS5 to LOADDB;
grant select on U1.V_TMP_D_PRODUCTS5 to LOADER;


