CREATE OR REPLACE TRIGGER U1."T_ETL_CHECK_OBJ_INS"
before insert on T_ETL_CHECK_OBJ
for each row
begin
  select t_etl_check_obj_id_seq.nextval into :new.id from dual;
end;
/

