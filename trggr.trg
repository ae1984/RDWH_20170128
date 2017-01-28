CREATE OR REPLACE TRIGGER U1.trggr
BEFORE
INSERT OR DELETE OR UPDATE
ON tmp_CREDIT_CONTRACTS
for each row
BEGIN
  IF to_char(sysdate,'DY') = 'WED'
    THEN
      raise_application_error( -20501, 'qwerty');
  END IF;
END;
/

