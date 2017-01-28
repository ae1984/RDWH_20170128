create or replace force view u1.v_folder_mo_pmt as
select "RFOLDER_ID","DATE_CREATE","FOLDER_ID","SC_PMT_NOM_RATE","SC_PMT_RBO" from m_folder_mo_pmt_2014 t
union all
select "RFOLDER_ID","DATE_CREATE","FOLDER_ID","SC_PMT_NOM_RATE","SC_PMT_RBO" from m_folder_mo_pmt_2015 t
union all
select "RFOLDER_ID","DATE_CREATE","FOLDER_ID","SC_PMT_NOM_RATE","SC_PMT_RBO" from m_folder_mo_pmt_2016 t;
grant select on U1.V_FOLDER_MO_PMT to LOADDB;
grant select on U1.V_FOLDER_MO_PMT to LOADER;


