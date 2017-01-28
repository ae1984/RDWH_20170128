create or replace procedure u1.loader_view_create(in_object_name varchar2) is
begin
      execute immediate 'grant select on U1.' || in_object_name || ' to LOADER';
      execute immediate 'create or replace view LOADER.' || in_object_name || ' as ' ||
           'select /*+ parallel(5) */ t.* from U1.' || in_object_name || ' t';
    exception when others then
/*      log_error (in_operation => 'loader_views_recreate',
                 in_error_code => sqlcode, in_error_message => sqlerrm,
                 in_object_type => 'object_name', in_object_id => x.obj_name);*/
      null;
end loader_view_create;
/

