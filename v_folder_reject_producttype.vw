create or replace force view u1.v_folder_reject_producttype as
select  t.folder_date_create_mi
       ,t.folder_id
       ,t.rfo_contract_id
       ,t.rfo_client_id
       ,case when a.folder_id is null then 0 else 1 end as is_reject_KASPI_RED
       ,case when b.folder_id is null then 0 else 1 end as is_reject_CARDS
       ,case when c.folder_id is null then 0 else 1 end as is_reject_OPTIM
       ,case when d.folder_id is null then 0 else 1 end as is_reject_MONEY
       ,case when e.folder_id is null then 0 else 1 end as is_reject_AUTO
       ,case when f.folder_id is null then 0 else 1 end as is_reject_GOODS
from M_FOLDER_CON_CANCEL t
left join M_FOLDER_CON_CANCEL a  on a.rfo_contract_id=t.rfo_contract_id and a.product_type='KASPI RED'
left join M_FOLDER_CON_CANCEL b  on b.rfo_contract_id=t.rfo_contract_id and b.product_type='КАРТЫ'
left join M_FOLDER_CON_CANCEL c  on c.rfo_contract_id=t.rfo_contract_id and c.product_type='ОПТИМИЗАЦИЯ'
left join M_FOLDER_CON_CANCEL d  on d.rfo_contract_id=t.rfo_contract_id and d.product_type='ДЕНЬГИ'
left join M_FOLDER_CON_CANCEL e  on e.rfo_contract_id=t.rfo_contract_id and e.product_type='АВТО'
left join M_FOLDER_CON_CANCEL f  on f.rfo_contract_id=t.rfo_contract_id and f.product_type='ТОВАРЫ'
where t.is_credit_issued=0;
grant select on U1.V_FOLDER_REJECT_PRODUCTTYPE to LOADDB;


