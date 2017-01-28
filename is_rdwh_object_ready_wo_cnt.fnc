create or replace function u1.is_rdwh_object_ready_wo_cnt(in_object_name in varchar2,
                                                       in_check_date  in date)
  return number is
  v_result number := 0;
  v_status number;
begin
  begin
    select count(1)
      into v_status
      from u1.UPDATE_LOG t
     where t.object_name = in_object_name
       and trunc(t.end_refresh) = coalesce(in_check_date,trunc(sysdate))
       and t.status = 'OK';
 
    v_result := case
                  when v_status > 0 then   1
                  else 0 end;
  exception
    when others then
      log_error(in_operation     => 'is_rdwh_object_ready_wo_cnt',
                in_error_code    => sqlcode,
                in_error_message => sqlerrm,
                in_object_type   => in_object_name);
  end;

  return(v_result);

end is_rdwh_object_ready_wo_cnt;
/
grant execute on U1.IS_RDWH_OBJECT_READY_WO_CNT to LOAD_MO;


