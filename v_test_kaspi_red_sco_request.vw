create or replace force view u1.v_test_kaspi_red_sco_request as
select t.iin, h.rfo_client_id, s."ID",s."PROCESS_REQUEST_ID",s."CLIENT_ID",s."FOLDER_ID",s."CODE_PROCESS",s."DATE_CREATE" /*min(s.date_create)*/
  from T_TEST_KASPI_RED_A t
  join V_CLIENT_RFO_BY_IIN h
    on h.iin = t.iin
  join MO_SCO_REQUEST s
    on s.client_id = h.rfo_client_id
   and s.date_create > trunc(sysdate - 365)
   and s.code_process = 'MO_SCO'
   and s.folder_id is not null;
grant select on U1.V_TEST_KASPI_RED_SCO_REQUEST to LOADDB;


