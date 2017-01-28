CREATE OR REPLACE FUNCTION U1.copy_image_file
(from_file VARCHAR2, to_file VARCHAR2) RETURN NUMBER IS
LANGUAGE JAVA
NAME 'Copy.copyImage(java.lang.String,java.lang.String) return java.lang.int';
/
grant execute on U1.COPY_IMAGE_FILE to RISK_ARCHIL;
grant execute on U1.COPY_IMAGE_FILE to RISK_JAN;
grant execute on U1.COPY_IMAGE_FILE to RISK_MVERA;


