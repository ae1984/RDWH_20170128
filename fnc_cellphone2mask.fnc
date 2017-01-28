create or replace function u1.FNC_CELLPHONE2MASK(p_phone varchar2) return varchar2 is
  phone_number varchar2(100);
begin
   phone_number:=substr(p_phone,1,11);
   if substr(phone_number,2,3) in 
     (
        '701'
       ,'702'
       ,'705'
       ,'771'
       ,'775'
       ,'776'
       ,'777'
       ,'778'
       ,'700'
       ,'707'
       ,'708'
       ,'747'
     )
   then
     phone_number:=substr(p_phone,5,7); 
     if substr(phone_number,1,1) in ('0','1','2','3','4','5','6','7','8','9') then
       phone_number:=replace(phone_number,substr(phone_number,1,1),'A');
     end if;  
     if substr(phone_number,2,1) in ('0','1','2','3','4','5','6','7','8','9') then
       phone_number:=replace(phone_number,substr(phone_number,2,1),'B');
     end if;  
     if substr(phone_number,3,1) in ('0','1','2','3','4','5','6','7','8','9') then
       phone_number:=replace(phone_number,substr(phone_number,3,1),'C');
     end if;  
     if substr(phone_number,4,1) in ('0','1','2','3','4','5','6','7','8','9') then
       phone_number:=replace(phone_number,substr(phone_number,4,1),'D');
     end if;  
     if substr(phone_number,5,1) in ('0','1','2','3','4','5','6','7','8','9') then
       phone_number:=replace(phone_number,substr(phone_number,5,1),'X');
     end if;  
     if substr(phone_number,6,1) in ('0','1','2','3','4','5','6','7','8','9') then
       phone_number:=replace(phone_number,substr(phone_number,6,1),'Y');
     end if;  
     if substr(phone_number,7,1) in ('0','1','2','3','4','5','6','7','8','9') then
       phone_number:=replace(phone_number,substr(phone_number,7,1),'Z');
     end if;  
     return(phone_number);
   else   return('-------');
   end if;
end FNC_CELLPHONE2MASK;
/

