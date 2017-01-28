create or replace force view u1.v_client_all_iin as
select distinct c.clnt_inn as iin
from V_DWH_CLIENT_PHYS_CURRENT c
where c.clnt_inn is not null
union
select distinct r.iin
from V_CLIENT_RFO_BY_ID r
where r.iin is not null;
grant select on U1.V_CLIENT_ALL_IIN to LOADDB;
grant select on U1.V_CLIENT_ALL_IIN to LOADER;


