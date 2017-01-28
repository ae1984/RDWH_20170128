CREATE OR REPLACE FUNCTION U1.get_canonical_local_bfilename
( locator           IN     BFILE
, operating_system  IN     VARCHAR2 := 'WINDOWS')
RETURN VARCHAR2 IS

  -- Declare default delimiter.
  delimiter         VARCHAR2(1) := '';

  -- Define statement variable.
  stmt              VARCHAR2(200);

  -- Define alias and file name.
  dir_alias         VARCHAR2(255);
  directory         VARCHAR2(255);
  file_name         VARCHAR2(255);

  -- Define a local exception for size violation.
  directory_num EXCEPTION;
  PRAGMA EXCEPTION_INIT(directory_num,-22285);
BEGIN
  -- Check for available locator.
  IF locator IS NOT NULL THEN
    DBMS_LOB.filegetname(locator,dir_alias,file_name);
  END IF;

  -- Check operating system and swap delimiter when necessary.
  IF operating_system <> 'WINDOWS' THEN
    delimiter := '/';
  END IF;

  -- Create a canonical file name.
  file_name := get_directory_path(dir_alias) || delimiter || file_name;

  -- Return file name.
  RETURN file_name;
EXCEPTION
  WHEN directory_num THEN
    RETURN NULL;
END get_canonical_local_bfilename;
/

