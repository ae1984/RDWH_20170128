create or replace function u1.func_test(p_string in varchar) return varchar2 is
  v_string varchar2(250);
begin
  select listagg(replace( replace(regexp_substr(p_string,'>.*?<', 1,rownum), '>', ''),'<','')) within group (order by rownum)  a
    into v_string
    from dual
 connect by rownum <= regexp_count(p_string,'>.*?<');
  return(v_string);
exception
  when others then
    return null;  
end func_test;
/

