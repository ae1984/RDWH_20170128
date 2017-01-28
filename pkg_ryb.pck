create or replace package u1.PKG_RYB is

  procedure update_phone_mobil(RES OUT NUMBER);

end PKG_RYB;
/

create or replace package body u1.PKG_RYB is

procedure update_phone_mobil(RES OUT NUMBER)
  is
    error varchar2(1000);
    phone varchar2(100);
    phone2 varchar2(100);
    upd_phone varchar2(100);
    col number;
    i number;
    pos number;
begin 
  for cur in (select u.user_name,u.iin,u.update_phone from tmp_ryb_users u where u.update_phone like '7%') loop
    phone := cur.update_phone;
    if (length(phone))=11 then
    --upd_phone := replace(phone,'/','');  
    phone2 := substr(phone,2,10);
    upd_phone := '8'||phone;          
    update tmp_ryb_users us set us.update_phone = upd_phone where us.user_name = cur.user_name;   
    commit;
    end if; 
  end loop;  
  
EXCEPTION WHEN OTHERS
       then error:= SQLERRM; 
         error:= SQLERRM;
         DBMS_OUTPUT.PUT_LINE(SQLERRM);
       --THEN RAISE_APPLICATION_ERROR(-20000,SQLERRM); 
END;      
begin
  -- Initialization
  null;
end PKG_RYB;
/

