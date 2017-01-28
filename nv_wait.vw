create or replace force view u1.nv_wait as
select "SDT","SID","SERIAL#","STATUS","OSUSER","MACHINE","MODULE","ACTION","SQL_ID","SQL_EXEC_START","STATE","SECONDS_IN_WAIT","WAIT_CLASS_ID","WAIT_CLASS#","WAIT_CLASS","EVENT","EVENT#","WAIT_TIME"
from NT_WAIT_HIST t
where t.sdt = (select max(sdt) from NT_WAIT_HIST) and t.status = 'ACTIVE'and t.osuser = 'oracle' and t.wait_class <> 'Idle'
      and t.seconds_in_wait>=900;
grant select on U1.NV_WAIT to LOADDB;


