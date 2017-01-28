create or replace force view u1.v_oper_cancel as
select"NUMBER_EMP","FIO","POSITION","DEPART","OTDEL","CITY","DATE_FIRE","COUSE","DATE_REQ","REQ_TO_GO","DAY_REST","COMMENTS" from T_OPER_CANCEL_RDWH@rdboard;
grant select on U1.V_OPER_CANCEL to LOADDB;


