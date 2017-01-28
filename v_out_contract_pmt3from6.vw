create or replace force view u1.v_out_contract_pmt3from6 as
select /*+ parallel(5) */
       c.contract_number
  from U1.M_CONTRACT_CAL_DEL c
  join U1.V_DWH_PORTFOLIO_CURRENT dpc on c.contract_number = dpc.deal_number
  join U1.M_CLIENT_BARCODE t on t.client_id = c.client_id
 where substr (t.pmt_full_code_new,-6) like ('%1%1%1%')                     -- клиент платил по договорам хотябы 3 раза за посл 6 месяцев
       and c.yy_mm_start_last_date<= add_months(trunc(sysdate, 'month'),-4) -- отсечение свежих договоров по которым не прошло 3-х месяцев и не возможно посчитать были ли оплачены посл 3 платежа
       and dpc.actual_end_date>= add_months(trunc(sysdate,'month'),-3)--договор должен быть активным или  закрылся не ранее чем 3 месяца назад
       and not exists (select null from U1.M_FOLDER_CON_CANCEL f
                        where f.folder_id = c.folder_id_first and f.is_refin = 1)
;
grant select on U1.V_OUT_CONTRACT_PMT3FROM6 to DNP;
grant select on U1.V_OUT_CONTRACT_PMT3FROM6 to LOADDB;
grant select on U1.V_OUT_CONTRACT_PMT3FROM6 to LOADER;


