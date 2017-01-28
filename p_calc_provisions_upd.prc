create or replace procedure u1.p_calc_provisions_upd(p_date in date,p_long_delinq in varchar2,p_prod in varchar2, p_new_value in number) --p_type -1 новый расчет, 2- пересчет с измененнными данными
is
begin
update t_dwh_provisions
set value_nb = p_new_value
where rep_date = p_date
and long_delinq = p_long_delinq
and prod = p_prod
and rep_lvl=1;
commit;
exception when others then
  dbms_output.put_line('error '||sqlerrm);
end;
/

