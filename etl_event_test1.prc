create or replace procedure u1.ETL_EVENT_TEST1 is
begin
  pkg_object_update_util.put_event('ETL_EVENT_TEST1');
end ETL_EVENT_TEST1;
/

