create or replace force view u1.v_smart_cache_mviews_ready as
select t.MVIEW_NAME, t.LAST_REFRESH_DATE,
case when trunc(t.LAST_REFRESH_DATE) = trunc(sysdate) then 'OK' else 'ERROR' end update_status
from dba_mviews t
where t.MVIEW_NAME in ('V_CLIENT_RFO_BY_IIN', 'V_PKB_REPORT', 'V_GCVP_REPORT')
and t.OWNER = 'U1';
grant select on U1.V_SMART_CACHE_MVIEWS_READY to LOADDB;
grant select on U1.V_SMART_CACHE_MVIEWS_READY to LOADER;


