create or replace force view u1.v_out_contract_auto as
select /*+ parallel(5)*/
---ДАННЫЕ ПО ДОГОВОРУ---
aa.contract_number as "НОМЕР ДОГОВОРА",
aa.cr_program_name as "ПРОГРАММА КРЕД",
aa.contract_date as "ДАТА ЗАЯВКИ",
aa.date_begin as "ДАТА НАЧАЛА ДОГ",
aa.date_end as "ДАТА ОКОНЧАНИЯ",
bb.deal_status as "СТАТУС ДОГОВОРА",
---ДАННЫЕ ПО КЛИЕНТУ---
bb.client_iin as "ИИН КЛИЕНТА",
bb.client_name as "ФИО КЛИЕНТА",
---ДАННЫЕ ПО АВТО---
aa.vin as "VIN КОД",
aa.brand as "МАРКА",
aa.model as "МОДЕЛЬ",
aa.prod_year as "ГОД ВЫПУСКА",
aa.tech_passport_date as "ДАТА ТЕХ ПАСП",
aa.color as "ЦВЕТ",
aa.engine_volume as "ОБЪЕМ ДВИГ",
aa.state_number as "ГОС НОМЕР",
aa.tech_pasport as "НОМЕР ТЕХ ПАСП",
cc.client_name as "ПРЕД ВЛАДЕЛЕЦ",
aa.date_agr as "ДАТА ЗАЛОГА",
---ДАННЫЕ ПО ПРОДАВЦУ---
aa.dealer_iin as "ИИН ПРОДАВЦА",
aa.dealer_fio as "ФИО ПРОДАВЦА",
aa.dealer_org as "ОРГ ПРОДАВЦА",
---ДАННЫЕ ПО МЕНЕДЖЕРУ И ОТДЕЛЕНИЮ---
bb.sign_empl_name as "ФИО МЕНЕДЖЕРА",
bb.dept_name as "ПОДРАЗДЕЛЕНИЕ",
bb.dept_number as "КОД ПОДР",
bb.unp_name as "ГОРОД"
from v_contract_all_rfo_auto aa
join v_dwh_portfolio_current bb on aa.contract_number = bb.deal_number
left join v_client_rfo_by_id cc on aa.prev_owner = cc.rfo_client_id
where aa.is_credit_issued = 1
and trunc(aa.date_begin) >= trunc(sysdate) - 1
;
comment on table U1.V_OUT_CONTRACT_AUTO is 'Информация по выданным кредитам по АВТО';
grant select on U1.V_OUT_CONTRACT_AUTO to LOADDB;
grant select on U1.V_OUT_CONTRACT_AUTO to LOADER;


