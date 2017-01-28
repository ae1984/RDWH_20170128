create or replace procedure u1.ETLT_KASPIRED_RULES_BY_IIN is
  s_mview_name     varchar2(30) := 'T_KASPIRED_RULES_BY_IIN';
  vStrDate         date := sysdate;
  d_src_commit_date_last date; --дата последней загруженной строки

begin
    select max(INSERT_DATE) into d_src_commit_date_last from T_KASPIRED_RULES_BY_IIN;

    insert into T_KASPIRED_RULES_BY_IIN
    select
       t.*
    from UPD_USER.UAD_KASPI_RED_RULES_BY_IIN t
    where t.insert_date > d_src_commit_date_last;
    commit;

end ETLT_KASPIRED_RULES_BY_IIN;
/

