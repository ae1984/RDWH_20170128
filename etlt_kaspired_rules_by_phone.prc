﻿create or replace procedure u1.ETLT_KASPIRED_RULES_BY_PHONE is
  s_mview_name     varchar2(30) := 'T_KASPIRED_RULES_BY_PHONE';
  vStrDate         date := sysdate;
  d_src_commit_date_last date; --дата последней загруженной строки

begin
    select max(INSERT_DATE) into d_src_commit_date_last from T_KASPIRED_RULES_BY_PHONE;

    insert into T_KASPIRED_RULES_BY_PHONE
    select
       t.*
    from UPD_USER.UAD_KASPI_RED_RULES_BY_PHONE t
    where t.insert_date > d_src_commit_date_last;
    commit;

end ETLT_KASPIRED_RULES_BY_PHONE;
/

