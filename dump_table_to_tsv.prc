create or replace procedure u1.dump_table_to_tsv(p_tname in varchar2,                    --Имя объекта
                                              p_dir   in varchar2 := 'EXPORT_DIR',    --директория для экспорта
                                              p_filename in varchar2,                  --имя файла cvs
                                              p_charset_to in varchar2 := 'AL32UTF8'
                                              )
  is
      l_output        utl_file.file_type;
      l_theCursor     integer default dbms_sql.open_cursor;
      l_columnValue   varchar2(32000);
      l_status        integer;
      l_query         varchar2(1000)
                      default 'select * from ' || p_tname;
      l_colCnt        number := 0;
      l_separator     varchar2(1);
      l_descTbl       dbms_sql.desc_tab;

      TAB1 varchar2(128) := chr(9);
  begin
      l_output := utl_file.fopen( p_dir, p_filename, 'w' , 32767);
      execute immediate 'alter session set nls_date_format=''dd/mm/yyyy hh24:mi:ss''';

      dbms_sql.parse(  l_theCursor,  l_query, dbms_sql.native );
      dbms_sql.describe_columns( l_theCursor, l_colCnt, l_descTbl );

      for i in 1 .. l_colCnt loop
          utl_file.put( l_output, l_separator || '"' || l_descTbl(i).col_name || '"');
          dbms_sql.define_column( l_theCursor, i, l_columnValue, 32000 );
          l_separator := TAB1;
      end loop;
      utl_file.new_line( l_output );

      l_status := dbms_sql.execute(l_theCursor);

      while ( dbms_sql.fetch_rows(l_theCursor) > 0 ) loop
          l_separator := '';
          for i in 1 .. l_colCnt loop
              dbms_sql.column_value( l_theCursor, i, l_columnValue );
              utl_file.put( l_output, l_separator || CONVERT(l_columnValue, p_charset_to, 'AL32UTF8') );
              l_separator := TAB1;
          end loop;
          utl_file.new_line( l_output );
      end loop;
      dbms_sql.close_cursor(l_theCursor);
      utl_file.fclose( l_output );

      --execute immediate 'alter session set nls_date_format=''dd-MON-yy'' ';
  exception
      when others then
          --execute immediate 'alter session set nls_date_format=''dd-MON-yy'' ';
          raise;
end;
/

