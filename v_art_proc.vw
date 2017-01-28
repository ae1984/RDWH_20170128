create or replace force view u1.v_art_proc as
select "ID","START_DATE","AUTH_ERR","TRANS_ERR","ALL_ERR","ALL_0","AUTH_OK","TRANS_OK","ALL_OK" from T_ART_PROCESS t
where to_date(t.start_date,'yyyy/mm/dd hh24:mi:ss')>=trunc(sysdate);
grant select on U1.V_ART_PROC to LOADDB;
grant select on U1.V_ART_PROC to LOADER;


