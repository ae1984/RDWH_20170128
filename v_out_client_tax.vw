create or replace force view u1.v_out_client_tax as
select /*+ parallel 5 */
       cl."IIN",cl."RNN",cl."C_NAME",cl."REMOVE_TAX_REG_DATE",cl."IS_REMOVE_TAX_REG",cl."UPDATE_DATE",
       t.is_indiv_business,
       t.is_indiv_business_ever
from V_CLIENT_TAX cl
left join M_CLIENT_TAX_ADD_1 t on t.iin = cl.iin;
grant select on U1.V_OUT_CLIENT_TAX to IT6_USER;
grant select on U1.V_OUT_CLIENT_TAX to LOADDB;
grant select on U1.V_OUT_CLIENT_TAX to LOADER;


