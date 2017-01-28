create or replace function u1.GET_MD5(val varchar2) return varchar2 is
  v_result varchar2(200);

begin

  v_result :=  DBMS_OBFUSCATION_TOOLKIT.md5 (input => UTL_RAW.cast_to_raw(val));

  return v_result;
end GET_MD5;
/

