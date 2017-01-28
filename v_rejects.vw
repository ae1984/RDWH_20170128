create or replace force view u1.v_rejects as
select/*+ noparallel */ c.expert_name,
    c.folder_number,
    c.rfo_contract_id, -- уник идентификатор
    c.folder_id,
    c.rfo_client_id,
    trunc (c.folder_date_create_mi) "DATE",
    c.iin,
    c.x_dnp_region,
    c.x_dnp_name,
    c.pos_code,
    c.pos_name,
    c.process_name,
    c.cr_program_name,
    c.cancel_manager "ОТКАЗ МП",
    f.manager_result_note "КОММЕНТ МП",
    c.cancel_middle_office as "MIDDLE_OFFICE",
    c.cancel_prescoring as "ПРЕСКОРИНГ",
    c.cancel_cpr_aa "ЦПР и АА",
    c.is_aa_reject "АА",
    case when c.folder_state = 'ОТКАЗ МЕНЕДЖЕРА ПРОДАЖ' then 1 else 0 end as "ОтказМПпослеЦПР",
    c.cancel_client "ОТКАЗ КЛИЕНТА",
    c.is_credit_issued "КРЕДИТ ВЫДАН"
from U1.M_FOLDER_CON_CANCEL c
join U1.V_FOLDER_ALL_RFO f on f.folder_id = c.folder_id
where c.folder_date_create_mi >= to_date('01.05.2014','dd.mm.yyyy') and
      c.folder_date_create_mi < to_date('24.07.2014','dd.mm.yyyy')
--and c.pos_type = 'ОТДЕЛЕНИЕ'
;
grant select on U1.V_REJECTS to LOADDB;
grant select on U1.V_REJECTS to LOADER;


