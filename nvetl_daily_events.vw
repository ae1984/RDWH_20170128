create or replace force view u1.nvetl_daily_events as
select event, min(cast(e_timestamp as date)) as dt
from DAILY_UPDATE_EVENT
where e_date >=trunc(sysdate)
group by event;
grant select on U1.NVETL_DAILY_EVENTS to LOADDB;


