create or replace procedure u1.ETLT_MO_SCO_REQUEST_STR
      is
       s_mview_name     varchar2(30) := 'MO_SCO_REQUEST_STR';
       vStrDate         date := sysdate;
       v_max_id         number;
      begin
      select max(t.id)
      into v_max_id
      from MO_SCO_REQUEST_STR t;

        insert /*+ APPEND */ into MO_SCO_REQUEST_STR
        select * from SCO_REQUEST_STR@MO1_PROD t where t.id > v_max_id;
        commit;
 end ETLT_MO_SCO_REQUEST_STR;
/

