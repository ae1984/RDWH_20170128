CREATE OR REPLACE TRIGGER U1.data_all_insert
before insert on data_all
for each row
begin
    select data_all_id_seq.nextval into :new.id from dual;
end;
/

