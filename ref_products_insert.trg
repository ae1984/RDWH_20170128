CREATE OR REPLACE TRIGGER U1.ref_products_insert
before insert on ref_products
for each row
begin
    select ref_products_id_seq.nextval into :new.id from dual;
end;
/

