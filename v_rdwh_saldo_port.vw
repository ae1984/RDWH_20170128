create or replace force view u1.v_rdwh_saldo_port as
select "C_REP_DATE","C_SUMMA_SALDO","C_PL_USV_NUM" from u1.t_rdwh_saldo_port@rdwh11;
grant select on U1.V_RDWH_SALDO_PORT to LOADDB;
grant select on U1.V_RDWH_SALDO_PORT to LOADER;


