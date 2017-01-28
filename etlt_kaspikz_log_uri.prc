create or replace procedure u1.ETLT_KASPIKZ_LOG_URI
 is
 vStrDate date := sysdate;
 s_mview_name     varchar2(30) := 'T_KASPIKZ_LOG_URI';
 n_max_id number;
 c    integer;
 nr   integer;
 v_id                    NUMBER;

v_uri                   VARCHAR2(4000);
v_hash                  VARCHAR2(4000);
v_length_col            NUMBER;

  begin
      select max(id)
      into n_max_id
      from T_KASPIKZ_LOG_URI;

      c := DBMS_HS_PASSTHROUGH.OPEN_CURSOR@db_kr2;
      DBMS_HS_PASSTHROUGH.PARSE@db_kr2(c,
         'select
                t.id,
                cast(t.URI as char(4000)),
                convert(int,t.Hash),
                t.Length
                from dbo.log_URI t
                 where t.id >'||n_max_id||'
                ');
      LOOP
        nr := DBMS_HS_PASSTHROUGH.FETCH_ROW@db_kr2(c);
        EXIT WHEN nr = 0;
        v_id                    := null;
        v_uri                   := null;
        v_hash                  := null;
        v_length_col            := null;
        DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  1, v_id);
        DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  2, v_uri);
        DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  3, v_hash);
        DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  4, v_length_col);
        insert into T_KASPIKZ_LOG_URI(ID, URI, HASH, LENGTH_COL)
        values (v_id,
                rtrim(v_uri),
                trim(to_char(abs(v_hash),'XXXXXXXXX')),
                v_length_col
               );
      END LOOP;
      DBMS_HS_PASSTHROUGH.CLOSE_CURSOR@db_kr2(c);
      commit;

end ETLT_KASPIKZ_LOG_URI;
/

