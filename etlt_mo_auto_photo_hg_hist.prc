create or replace procedure u1.ETLT_MO_AUTO_PHOTO_HG_HIST is
  s_mview_name     varchar2(30) := 'T_MO_AUTO_PHOTO_HG_HIST';
begin
    insert into T_MO_AUTO_PHOTO_HG_HIST
    select sysdate as sdt,t.* from M_MO_AUTO_PHOTO_HG t;
    commit;
end ETLT_MO_AUTO_PHOTO_HG_HIST;
/

