create or replace force view u1.v_dwh_client_phys_current_iin as
select distinct t.clnt_inn from V_DWH_CLIENT_PHYS_CURRENT t;
grant select on U1.V_DWH_CLIENT_PHYS_CURRENT_IIN to LOADDB;
grant select on U1.V_DWH_CLIENT_PHYS_CURRENT_IIN to LOADER;


