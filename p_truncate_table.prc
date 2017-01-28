CREATE OR REPLACE PROCEDURE U1.P_TRUNCATE_TABLE (P_TABLE_NAME IN VARCHAR2)
IS
   S_SCRIPT   VARCHAR2 (1000);
   BOOL_E     number(1);
BEGIN
   select case
            when upper(p_table_name) like '%EVENT%' then
              1
            else
              0
          end     as bool_event
     into BOOL_E
     from dual;

   if BOOL_E = 1 then
     SELECT 'truncate table ' || P_TABLE_NAME INTO S_SCRIPT FROM DUAL;
   end if;

   EXECUTE IMMEDIATE S_SCRIPT;
END P_TRUNCATE_TABLE;
/
grant execute on U1.P_TRUNCATE_TABLE to ETL;


