create or replace procedure u1.loader_views_recreate is
begin
for x in (select t.table_name as obj_name from DBA_TABLES t where t.owner = 'U1'
          union all
          select w.view_name as obj_name from DBA_VIEWS w where w.owner = 'U1'
         ) loop
    begin
      execute immediate 'grant select on U1.' || x.obj_name || ' to LOADER';
      execute immediate 'create or replace view LOADER.' || x.obj_name || ' as ' ||
           'select /*+ parallel(5) */ t.* from U1.' || x.obj_name || ' t';

    null;
    exception when others then
/*      log_error (in_operation => 'loader_views_recreate',
                 in_error_code => sqlcode, in_error_message => sqlerrm,
                 in_object_type => 'object_name', in_object_id => x.obj_name);*/
      null;
    end;
end loop;
BEGIN
      execute immediate 'grant select on U1.M_CONTRACT_CAL_DEL to DNP'; 
      execute immediate 'grant select on U1.V_DWH_PORTFOLIO_CURRENT to DNP';
      execute immediate 'grant select on U1.V_POS to DNP';
      execute immediate 'grant select on U1.M_FOLDER_CON_CANCEL to DNP';
      execute immediate 'grant select on U1.v_contract_all_rfo_auto to DNP';
EXCEPTION when others then
  null;
END; 

end loader_views_recreate;
/

