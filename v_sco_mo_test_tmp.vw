create or replace force view u1.v_sco_mo_test_tmp as
select to_date(t.s_date||t.s_time,'yymmddhh24miss') as s_date,
       case when t.folderid < 90000000000 then t.folderid end as rfo_folder_id,
       t.iin, t.cardno,
       decode(t.yn,'YES',0,'NO',1) as yn_num,
       t.yn, t.idle, t.result, t.status
from SCO_MO_TEST_TMP t;
grant select on U1.V_SCO_MO_TEST_TMP to LOADDB;
grant select on U1.V_SCO_MO_TEST_TMP to LOADER;


