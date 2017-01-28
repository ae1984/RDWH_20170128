create or replace procedure u1.ETLT_UPD_ECO_ONL is
begin
  insert into T_UPD_ECO_ONL
  select t.*,sysdate from UPD_USER.ECO_ONL t;
  commit;
end ETLT_UPD_ECO_ONL;
/

