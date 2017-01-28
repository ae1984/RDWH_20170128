create or replace force view u1.v_client_rfo_approved_all as
select distinct c.rfo_client_id -- для чс в мониторинге
from V_CONTRACT_ALL_RFO c
join v_folder_all_rfo f on (f.credit_contract_id  = c.rfo_contract_id or
                            f.card_contract_id = c.rfo_contract_id) and
                            f.is_credit_process = 1 and
                            f.is_credit_issued = 1
join (select t.deal_number from V_DWH_PORTFOLIO_CURRENT t
       where (t.deal_status not in ('ОТКАЗ','ВВЕДЕН') or
              (t.deal_number is null and t.x_total_debt > 0)) and
             t.prod_name not in ('ПРИВИЛЕГИРОВАННЫЙ') -- кошелек не учитываем
          ) d  on d.deal_number = c.contract_number
;
grant select on U1.V_CLIENT_RFO_APPROVED_ALL to LOADDB;
grant select on U1.V_CLIENT_RFO_APPROVED_ALL to LOADER;


