create or replace function u1.is_rdwh_object_ready(in_object_name in varchar2,
                                                in_schema_name in varchar2 := 'U1',
                                                in_check_date in date := trunc(sysdate)) return number
is
  v_result number := 0;

  v_sql               varchar2(1024);
  v_cnt               number;
  v_status            number;
begin
  begin
   select count(1) into v_status
   from u1.UPDATE_LOG t
   where t.object_name = in_object_name
         and t.end_refresh >= trunc(in_check_date)
         and trunc(t.end_refresh) = trunc(in_check_date)
         and t.status = 'OK';

/*   if v_status > 0 then
      v_sql := 'select count(*) from ' || in_schema_name || '.' || in_object_name;

      execute immediate v_sql
        into v_cnt;
    else
      v_cnt := 0;
    end if;*/

    v_result := case when v_status > 0 then 1 else 0 end;
  exception when others
    then log_error(in_operation => '',
                   in_error_code => sqlcode,
                   in_error_message => sqlerrm,
                   in_object_type => in_object_name);
  end;

  return(v_result);

end is_rdwh_object_ready;
/
grant execute on U1.IS_RDWH_OBJECT_READY to ESB_USER;
grant execute on U1.IS_RDWH_OBJECT_READY to ETL;
grant execute on U1.IS_RDWH_OBJECT_READY to LOAD_MO;
grant execute on U1.IS_RDWH_OBJECT_READY to RTS_RDWH;


