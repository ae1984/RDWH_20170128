CREATE OR REPLACE TRIGGER U1.T_ART_PROCESS_TR
  before insert on t_art_process
  for each row
declare
  -- local variables here
begin
  if (:NEW.ID is null) then
    :NEW.ID := T_ART_PROCESS_SEQ.NEXTVAL;
  end if;
end T_ART_PROCESS_TR;
/

