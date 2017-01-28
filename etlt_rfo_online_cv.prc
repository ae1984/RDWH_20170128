create or replace procedure u1.ETLT_RFO_ONLINE_CV is
    s_mview_name varchar2(30) := 'T_RFO_ONLINE_CV';
    vStrDate date := sysdate;

  begin

    insert /*+ APPEND */
      into T_RFO_ONLINE_CV
    select * from M_RFO_ONLINE_CV_PRE2 t;
    commit;


  end ETLT_RFO_ONLINE_CV;
/

