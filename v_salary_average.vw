create or replace force view u1.v_salary_average as
select "YM_DATE","YM_STR","SALARY","SALARY_DOUBLE","IS_STAT" from T_SALARY_AVERAGE t
where t.ym_date > to_date('01012014', 'ddmmyyyy');
grant select on U1.V_SALARY_AVERAGE to LOADDB;
grant select on U1.V_SALARY_AVERAGE to LOADER;
grant select on U1.V_SALARY_AVERAGE to LOAD_MO;


