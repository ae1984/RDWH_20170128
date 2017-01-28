﻿create or replace procedure u1.ETLT_MO_SCO_REQUEST_CANCEL
      is
       s_mview_name     varchar2(30) := 'MO_SCO_REQUEST_CANCEL';
       vStrDate         date := sysdate;
       v_max_id         number;
      begin
        select max(t.id)
        into v_max_id
        from MO_SCO_REQUEST_CANCEL t;

        insert /*+ APPEND */ into MO_SCO_REQUEST_CANCEL
        select * from SCO_REQUEST_CANCEL@MO1_PROD t where t.id > v_max_id;
        commit;
end ETLT_MO_SCO_REQUEST_CANCEL;
/

