create or replace function u1.get_seconds(in_start timestamp, in_stop timestamp) return number is
  Result number;
begin
    if (to_char(in_start,'HH24:MI:SS') != '00:00:00' and to_char(in_stop,'HH24:MI:SS') = '00:00:00') then result := (23-extract(hour from in_start))*3600+
            (59-extract(minute from in_start))*60+
            (60-extract(second from in_start));
    else
            result := (extract(hour from in_stop)-extract(hour from in_start))*3600+
            (extract(minute from in_stop)-extract(minute from in_start))*60+
            extract(second from in_stop)-extract(second from in_start);
    end if;
  return(Result);
end get_seconds;
/

