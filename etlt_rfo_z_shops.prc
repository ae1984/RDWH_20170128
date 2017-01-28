create or replace procedure u1.ETLT_RFO_Z_SHOPS
  is
   s_mview_name     varchar2(30) := 'T_RFO_Z#SHOPS';
   vStrDate         date := sysdate;
   d_date_start_ins date; --дата логирования инсерта

   d_src_commit_date_last date; --дата последней загруженной строки
   d_src_commit_date_load date; --дата, по которую делаем загрузку

  begin
    execute immediate ('truncate table T_RFO_Z#SHOPS');
    insert into T_RFO_Z#SHOPS
    select * from s01.z#SHOPS@RDWH_EXD ;
    commit;



   end ETLT_RFO_Z_SHOPS;
/

