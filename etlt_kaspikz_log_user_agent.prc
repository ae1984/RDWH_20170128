CREATE OR REPLACE PROCEDURE U1."ETLT_KASPIKZ_LOG_USER_AGENT"
 is
  vStrDate date := sysdate;
  s_mview_name     varchar2(30) := 'T_KASPIKZ_LOG_USER_AGENT';
  n_max_id number;
  c    integer;
  nr   integer;
  v_id                    NUMBER;
  v_uri                   VARCHAR2(4000);
  v_hash                  VARCHAR2(4000);
  v_length_col            NUMBER;


  v_user_agent            VARCHAR2(4000);
  v_device_model          VARCHAR2(200);
  v_os                    VARCHAR2(200);
  v_os_major_version      NUMBER;
  v_os_minor_version      NUMBER;
  v_browser               VARCHAR2(200);
  v_browser_major_version NUMBER;
  v_browser_minor_version NUMBER;

  begin
    select max(id)
    into n_max_id
    from T_KASPIKZ_LOG_USER_AGENT;

    c := DBMS_HS_PASSTHROUGH.OPEN_CURSOR@db_kr2;
    DBMS_HS_PASSTHROUGH.PARSE@db_kr2(c,
      'select
              t.id,
              cast(SUBSTRING(t.UserAgent, 1, 4000) as char(4000)),
              convert(int,t.Hash),
              t.Length,
              t.DeviceModel,
              t.OS,
              t.OSMajorVersion,
              t.OSMinorVersion,
              t.Browser,
              t.BrowserMajorVersion,
              t.BrowserMinorVersion
              from dbo.log_UserAgent t
               where t.id >'||n_max_id||'
             ');


    LOOP
      nr := DBMS_HS_PASSTHROUGH.FETCH_ROW@db_kr2(c);
      EXIT WHEN nr = 0;

      v_id                    := null;
      v_user_agent            := null;
      v_hash                  := null;
      v_length_col            := null;
      v_device_model          := null;
      v_os                    := null;
      v_os_major_version      := null;
      v_os_minor_version      := null;
      v_browser               := null;
      v_browser_major_version := null;
      v_browser_minor_version := null;

      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  1, v_id);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  2, v_user_agent);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  3, v_hash);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  4, v_length_col);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  5, v_device_model);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  6, v_os);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  7, v_os_major_version);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  8, v_os_minor_version);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c,  9, v_browser);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c, 10, v_browser_major_version);
      DBMS_HS_PASSTHROUGH.GET_VALUE@db_kr2(c, 11, v_browser_minor_version);

      insert into T_KASPIKZ_LOG_USER_AGENT(ID, USER_AGENT, HASH, LENGTH_COL, DEVICE_MODEL,
                                           OS, OS_MAJOR_VERSION, OS_MINOR_VERSION,
                                           BROWSER, BROWSER_MAJOR_VERSION, BROWSER_MINOR_VERSION)
      values (v_id,
              rtrim(v_user_agent),
              trim(to_char(abs(v_hash),'XXXXXXXXX')),
              v_length_col,
              v_device_model,
              v_os,
              v_os_major_version,
              v_os_minor_version,
              v_browser,
              v_browser_major_version,
              v_browser_minor_version);



    END LOOP;
    DBMS_HS_PASSTHROUGH.CLOSE_CURSOR@db_kr2(c);

    commit;

 end ETLT_KASPIKZ_LOG_USER_AGENT;
/

