create or replace force view u1.v_fpd_spd_nbrk as
select start_date,
   case when total_Debt_fpd0 > 0  then
     round(FPD0*100/total_Debt_fpd0,1)
   end as proc_fpd0,
   case when total_Debt_fpd7 > 0 and start_date <= trunc(sysdate) - 52 then
     round(FPD7*100/total_Debt_fpd7,1)
   end as proc_fpd7,
   case when total_Debt_spd > 0 and start_date <= trunc(sysdate) - 75 then
     round(SPD*100/total_Debt_spd,1)
   end as proc_spd
from (
      select
        cd.start_date,
        sum(cd.total_debt_x_pmt_1_0) as FPD0,
        sum(cd.max_debt_used_x_pmt_1_0) as total_Debt_fpd0,
        sum(cd.total_debt_x_pmt_1_7) as FPD7,
        sum(cd.max_debt_used_x_pmt_1_7) as total_Debt_fpd7,
        sum(cd.total_debt_x_pmt_1_30) as SPD,
        sum(cd.max_debt_used_x_pmt_1_30) as total_Debt_spd
       from u1.M_RBO_CONTRACT_DEL cd
      where start_date >= to_Date('01.01.2015','dd.mm.yyyy')
      group by cd.start_date)
where start_date <= trunc(sysdate)-45
order by start_date;
comment on table U1.V_FPD_SPD_NBRK is 'Данные по FPD, SPD для НБРК';
comment on column U1.V_FPD_SPD_NBRK.START_DATE is 'Отчетная дата';
comment on column U1.V_FPD_SPD_NBRK.PROC_FPD0 is 'Процент всей задолженности с учетом рефинанса при просрочке на дату 1-го платежа от общей задолженнности к Макс. задолженности с учетом рефинанса на дату 1-го платежа ';
comment on column U1.V_FPD_SPD_NBRK.PROC_FPD7 is 'Процент всей задолженности с учетом рефинанса при просрочки на дату 1-го платежа плюс 7 дней от общей задолженнности к Макс. задолженности с учетом рефинанса на дату 1-го платежа плюс 7 дней ';
comment on column U1.V_FPD_SPD_NBRK.PROC_SPD is 'Процент всей задолженности с учетом рефинанса при просрочки на дату 1-го платежа плюс 30 дней к Макс. задолженности с учетом рефинанса на дату 1-го платежа плюс 30 дней  ';
grant select on U1.V_FPD_SPD_NBRK to LOADDB;


