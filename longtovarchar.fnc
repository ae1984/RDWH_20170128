create or replace function u1.LongToVarchar(PoHeaderId in varchar2) return varchar2 is
  vievs varchar (4000);
  p_query varchar2(32000);
  name_v varchar (4000);
  viev integer;
  num integer;
  del integer;
begin
  select t.QUERY into p_query from SYS.USER_MVIEWS t where t.MVIEW_NAME = PoHeaderId;
     for name_v in (select t.MVIEW_NAME from SYS.USER_MVIEWS t) loop
       viev:=instr(upper(p_query),upper(name_v.mview_name||' '),1); 
       if viev = 0 then 
         viev:=instr(upper(p_query),upper(name_v.mview_name||','),1);
       end if;   
       if viev = 0 then 
         viev:=instr(upper(p_query),upper(name_v.mview_name||'"'),1); 
       end if;  
       if viev = 0 then 
         viev:=instr(upper(p_query),upper(name_v.mview_name||';'),1);   
       end if;         
       if viev >0 then
         vievs := vievs||name_v.mview_name||';'; 
       end if;  
     end loop; 
  return vievs;
end LongToVarchar;
/

