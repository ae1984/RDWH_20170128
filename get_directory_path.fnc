CREATE OR REPLACE FUNCTION U1.GET_DIRECTORY_PATH
( virtual_directory IN VARCHAR2 )
RETURN VARCHAR2 IS

  -- Define return variable.
  directory_path VARCHAR2(256) := '';

  -- Define dynamic cursor.
  CURSOR get_directory (virtual_directory VARCHAR2) IS
    SELECT   directory_path
    FROM     sys.dba_directories
    WHERE    directory_name = virtual_directory;

  -- Define a local exception for name violation.
  directory_name EXCEPTION;
  PRAGMA EXCEPTION_INIT(directory_name,-22284);
BEGIN
  OPEN  get_directory (virtual_directory);
  FETCH get_directory
  INTO  directory_path;
  CLOSE get_directory;

  -- Return file name.
  RETURN directory_path;
EXCEPTION
  WHEN directory_name THEN
    RETURN NULL;
END get_directory_path;
/

