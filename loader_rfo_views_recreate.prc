create or replace procedure u1.loader_rfo_views_recreate is
begin
for x in (select t.table_name as obj_name from DBA_TABLES t where t.owner = 'U1'
                 and t.TABLE_NAME like 'V_RFO_Z#%'
                 and t.TABLE_NAME not in (
                     'V_RFO_Z#KAS_GCVP_PAYMENT_RAW',
                     'V_RFO_Z#PROPERTIES_2012',
                     'V_RFO_Z#PROPERTIES_2013')
          union all
          select w.view_name as obj_name from DBA_VIEWS w where w.owner = 'U1'
                 and w.VIEW_NAME like 'V_RFO_Z#%'
         ) loop
    begin
      execute immediate 'grant select on U1.' || x.obj_name || ' to LOADER_RFO';
      execute immediate 'create or replace view LOADER_RFO.' || x.obj_name || ' as ' ||
           'select /*+ parallel(1) */ t.* from U1.' || x.obj_name || ' t';

    null;
    exception when others then
/*      log_error (in_operation => 'loader_views_recreate',
                 in_error_code => sqlcode, in_error_message => sqlerrm,
                 in_object_type => 'object_name', in_object_id => x.obj_name);*/
      null;
    end;
end loop;
end loader_rfo_views_recreate;
/

