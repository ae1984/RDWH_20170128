create or replace procedure u1.ETL_TRUNC_TABLE(in_table_name varchar2) is
  v_invalid_table_name_ex exception;
begin
  begin
    if (in_table_name like 'S01_%') or (in_table_name in ('T_KASPISH_USER')) then
      execute immediate 'truncate table ' || in_table_name;
    else 
      raise v_invalid_table_name_ex;
    end if;
  exception 
    when v_invalid_table_name_ex then
         log_error(in_operation => 'ETL_TRUNC_TABLE invalid table name ' || in_table_name, in_error_code => sqlcode, in_error_message => sqlerrm);  
    when others then
         log_error(in_operation => 'ETL_TRUNC_TABLE ' || in_table_name, in_error_code => sqlcode, in_error_message => sqlerrm);  
  end;
end ETL_TRUNC_TABLE;
/
grant execute on U1.ETL_TRUNC_TABLE to ETL;


