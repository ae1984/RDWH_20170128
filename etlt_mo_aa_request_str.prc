﻿create or replace procedure u1.ETLT_MO_AA_REQUEST_STR
      is
       s_mview_name     varchar2(30) := 'MO_AA_REQUEST_STR';
       vStrDate         date := sysdate;
       v_max_aa_id         number;
      begin
        select /*+parallel(1)*/ max(t.id)
        into v_max_aa_id
        from MO_AA_REQUEST_STR t;

        insert /*+ APPEND */ into MO_AA_REQUEST_STR
        select * from AA_REQUEST_STR@MO1_PROD t where t.id > v_max_aa_id;
        commit;
 end ETLT_MO_AA_REQUEST_STR;
/

