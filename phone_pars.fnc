create or replace function u1.phone_pars(phone varchar2) return varchar2 is
  v_result varchar2(100);
  str varchar2(100);
begin
  if length(phone) = 10 then
    select count(distinct substr(phone, level, 1)) into v_result from dual connect by level <= length(phone);
  elsif length(phone) = 11 then
    begin
      str := substr (phone,2,10);
      select count(distinct substr(str, level, 1)) into v_result from dual connect by level <= length(str);
    end;
  end if;
  return v_result;
end phone_pars;
/

