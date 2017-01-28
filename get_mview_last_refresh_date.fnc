create or replace function u1.get_mview_last_refresh_date(in_mview_name varchar2, in_owner varchar2 := 'U1') return timestamp is
  Result timestamp;
begin
  begin
    select t.LAST_REFRESH_DATE into Result 
    from dba_mviews t
    where t.OWNER = in_owner
    and t.MVIEW_NAME = in_mview_name;
  exception when others then 
    Result := null;
  end;
  
  return(Result);
end get_mview_last_refresh_date;
/
grant execute on U1.GET_MVIEW_LAST_REFRESH_DATE to LOAD_MO;


