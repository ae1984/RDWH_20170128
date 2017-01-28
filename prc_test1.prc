create or replace procedure u1.PRC_TEST1 is
    n number;
    e_user_exception exception;
begin
  -- n:=1/1;
  -- raise e_user_exception;
  dbms_lock.sleep(10);
end PRC_TEST1;
/

