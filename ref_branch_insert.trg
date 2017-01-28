CREATE OR REPLACE TRIGGER U1.ref_branch_insert
before insert on ref_branch
for each row
begin
    select ref_branch_id_seq.nextval into :new.id from dual;
end;
/

