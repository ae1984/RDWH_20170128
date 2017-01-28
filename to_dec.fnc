create or replace function u1.to_dec
( p_str in varchar2,
 p_from_base in number default 16 ) return number
is
 l_num   number default 0;
 l_hex   varchar2(16) default '0123456789ABCDEF';
begin
 if ( p_str is null or p_from_base is null )
 then
  return null;
 end if;
 for i in 1 .. length(p_str) loop
  l_num := l_num * p_from_base + instr(l_hex,upper(substr(p_str,i,1)))-1;
 end loop;
 return l_num;
end to_dec;
/

