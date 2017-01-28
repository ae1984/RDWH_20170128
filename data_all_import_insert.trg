CREATE OR REPLACE TRIGGER U1.data_all_import_insert
before insert on data_all_import
for each row
begin
    select data_all_import_id_seq.nextval into :new.id from dual;
end;
/

