﻿create or replace force view u1.v_sco_mo_test_tmp_4_1 as
select to_date(t.s_date||t.s_time,'yymmddhh24miss') as s_date,
       case when t.folder_id < 90000000000 then t.folder_id end as rfo_folder_id,
       t.cardno, t.iin, t.idreq,
       t.answer,
       decode(t.yn,'YES',0,'NO',1) as yn_num,
       t.yn, t.idle, t.result, t.status
from SCO_MO_TEST_TMP_4_1 t;
grant select on U1.V_SCO_MO_TEST_TMP_4_1 to LOADDB;
grant select on U1.V_SCO_MO_TEST_TMP_4_1 to LOADER;


