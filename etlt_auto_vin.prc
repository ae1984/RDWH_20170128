create or replace procedure u1.ETLT_AUTO_VIN is
  s_mview_name     varchar2(30) := 'T_AUTO_VIN';
  vStrDate         date := sysdate;
  id_max number;

begin
    select max(autovin_id) into id_max from T_AUTO_VIN;
    insert into T_AUTO_VIN
    select /*+ driving_site*/ * from DWH_MAIN.REF_AUTO_VIN@RDWH_EXD
    where autovin_id > id_max;
    commit;

end ETLT_AUTO_VIN;
/

