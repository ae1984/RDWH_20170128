create or replace function u1.get_birth_date_from_iin(in_iin varchar2) return date is
  result date;
begin
  select to_date(substr(in_iin,5,2)||'.'||substr(in_iin,3,2)||'.'||
          case when substr(in_iin,7,1) = '3' or substr(in_iin,7,1) = '4' then '19'
               when substr(in_iin,7,1) = '5' or substr(in_iin,7,1) = '6' then '20' end
        ||substr(in_iin,1,2),'dd.mm.yyyy') into result from dual;

  return result;

  exception when others then
            return null;
end get_birth_date_from_iin;
/

