create or replace procedure u1.ETLT_KASPIRED_RULES_OTH is
  s_mview_name     varchar2(30) := 'T_KASPIRED_RULES_OTH';
  vStrDate         date := sysdate;
  d_src_commit_date_last date; --дата последней загруженной строки

begin
    select max(INSERT_DATE) into d_src_commit_date_last from T_KASPIRED_RULES_OTH;

    insert into T_KASPIRED_RULES_OTH
    select
       t.*
    from UPD_USER.UAD_KASPI_RED_RULES_OTH t
    where t.insert_date > d_src_commit_date_last;
    commit;
end ETLT_KASPIRED_RULES_OTH;
--таблица для проверки остатков по T_RBO_PORT
/

