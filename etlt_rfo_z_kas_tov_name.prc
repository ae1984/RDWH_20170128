create or replace procedure u1.ETLT_RFO_Z_KAS_TOV_NAME
  is
   s_mview_name     varchar2(30) := 'T_RFO_Z#KAS_TOV_NAME';
   vStrDate         date := sysdate;
   d_date_start_ins date; --дата логирования инсерта

   d_src_commit_date_last date; --дата последней загруженной строки
   d_src_commit_date_load date; --дата, по которую делаем загрузку

  begin

    delete from T_RFO_Z#KAS_TOV_NAME;
    insert into T_RFO_Z#KAS_TOV_NAME
    select * from s01.z#KAS_TOV_NAME@RDWH_EXD   ;
    commit;

   end ETLT_RFO_Z_KAS_TOV_NAME;
/

