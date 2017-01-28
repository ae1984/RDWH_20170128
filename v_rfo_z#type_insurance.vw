create or replace force view u1.v_rfo_z#type_insurance as
select "ID","C_CODE","C_NAME","C_TYPE_INS_ARR","C_KAS_PREF","SN","SU" from IBS.Z#TYPE_INSURANCE@RFO_SNAP;
grant select on U1.V_RFO_Z#TYPE_INSURANCE to LOADDB;
grant select on U1.V_RFO_Z#TYPE_INSURANCE to LOADER;


