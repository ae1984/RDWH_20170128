create or replace force view u1.v_contract_folder_test as
select /*+first_rows*/
       /*ora_hash(c.contract_number) as co_contract_number_num, */
       /*to_number(decode(substr(replace(c.contract_number,'-',''),1,1),'R',2,1)||
       lpad(substr(trim('R' from c.contract_number),1,instr(trim('R' from c.contract_number),'-')-1),10,0)||
       lpad(substr(trim('R' from c.contract_number),instr(trim('R' from c.contract_number),'-')+1,3),4,0)||
       decode(substr(trim('R' from c.contract_number),instr(trim('R' from c.contract_number),'-')+4,instr(trim('R' from c.contract_number),'-')+8),null,0,'e',1,2)||
       lpad((decode(substr(trim('R' from c.contract_number),instr(trim('R' from c.contract_number),'-')+9,instr(trim('R' from c.contract_number),'-')+11),null,0,
       substr(trim('R' from c.contract_number),instr(trim('R' from c.contract_number),'-')+9,instr(trim('R' from c.contract_number),'-')+11))),4,0)) as co_contract_number_num,*/
       c.contract_number as co_contract_number,
       c.contract_id as co_contract_id,
       c.start_total_fact_pmts_by_cli,-- as co_start_total_fact_pmts_by_cli,
       c.client_id as co_client_id,
       c.folder_id_first as co_folder_id_first,---
       c.start_date_first as co_start_date_first,--
       c.product_last as co_product_last,--
       c.product_refin_last as co_rpoduct_refin_last,--
       c.product_program_last as co_product_program_last,--
       c.start_date_last as co_start_date_last,
       c.contract_amount_last as co_contract_amount_last,
       c.max_debt_used as co_max_debt_used,--
       c.contract_amount_max as co_contract_amount_max,
       c.is_refin_restruct_last as co_is_refin_restruct_last,
       c.first_pmt_days_first as co_first_pmt_days_first,
       c.first_pmt_days_last as co_first_pmt_days_last,
       c.is_card as co_is_card,
       c.contract_amount_categ_last as co_contract_amount_categ_last,
       c.yy_mm_start_first as co_yy_mm_start_first,--
       c.yy_mm_start_last as co_yy_mm_start_last,--
       c.fact_pmts as co_fact_pmts,
       c.planned_pmts as co_planned_pmts,
       c.pmt as co_pmt,
       c.prev_con_num_by_start_date as co_prev_con_num_by_start_date,
       c.prev_con_num_by_yymm_last as co_prev_con_num_by_yymm_last,
       c.prev_con_st_date_by_start_date,-- as co_prev_con_st_date_by_start_date ,
       c.prev_con_st_date_by_yymm_last, --as co_prev_con_st_date_by_yymm_last ,
       c.yms as co_yms,
       f.folder_id as fr_folder_id,---в V_FOLDER_ALL_RFO больше записей чем в V_FOLDER_ALL
       f.is_form_exists as fr_is_form_exists,
       f.is_credit_process as fr_is_credit_process,
       f.folder_number as fr_folder_number,
       f.folder_date_create as fr_folder_date_create,
       f.rfo_client_id as fr_rfo_client_id,
       f.folder_state as fr_folder_state,
       f.process_name as fr_process_name,
       f.pos_code as fr_pos_code,-- 48 записей имеют неправильное значение '1'
       f.dnp_name as fr_dnp_name,
       f.underwriter as fr_underwriter,
       f.underwriter_senior as fr_underwriter_senior,
       --f.form_client_id as fr_form_client_id,-- такие же значения как и fc_form_client_id
       f.org_bin as fr_org_bin,--больше данных чем в V_ORG_GCVP
       --f1.folder_id as fa_folder_id,----в V_FOLDER_ALL_RFO больше заполненных folder_id
       f1.folder_create_date as fa_folder_create_date,
       --f1.client_id as fa_client_id,----правильнее брать co_client_id
       f1.client_iin as fa_client_iin,
       f1.folder_status as fa_folder_status,
       f1.pos_code as fa_pos_code,--
       f1.expert_name as fa_expert_name,
       f1.expert_num_tab as fa_expert_num_tab,
       f1.inc_sal as fa_inc_sal,
       f1.scoring_status as fa_scoring_status ,
       f1.scoring_test as fa_scoring_test,
       f1.inc_sal_spouse as fa_inc_sal_spouse,
       f1.prescoring_result as fa_prescoring_result,
       f1.sal_gcvp_to_sal_form_categ as fa_sal_gcvp_to_sal_form_categ,
       f1.total_prior_pmts as fa_total_prior_pmts,
       f1.max_prior_delinq_days as fa_max_prior_delinq_days,
       --cl.client_id as cl_client_id,----такие же значения как co_client_id
       cl.contract_number_first as cl_contract_number_first,
       cl.client_name as cl_client_name,
       cl.product_refin_first as cl_product_refin_first,
       cl.start_date_first as cl_start_date_first,--
       cl.product_last as cl_product_last,--
       cl.product_refin_last as cl_product_refin_last,--
       cl.product_program_last as cl_product_program_last,--
       cl.expert_name_last as cl_expert_name_last,
       cl.pos_code_last as cl_pos_code_last,
       cl.max_debt_used as cl_max_debt_used,--
       cl.delinq_days_max_last as cl_delinq_days_max_last,
       cl.number_of_contracts cl_number_of_contracts ,
       cl.yy_mm_start_first as cl_yy_mm_start_first,--
       cl.yy_mm_start_last as cl_yy_mm_start_last,--
       cl.total_pmts as cl_total_pmts,
       cl.number_of_folders_total as cl_number_of_folders_total,
       --p.folder_id as pr_folder_id,--- данных больше в V_FOLDER_ALL_RFO
       p.folder_client_id as pr_folder_client_id,
       p.pkb_report_date as pr_pkb_report_date,
       p.report_status as pr_report_status,
       p.rfo_report_date as pr_rfo_report_date,
       --po.pos_code as p_code_pos,---такие же значения fr_pos_code
       po.branch_code as p_branch_code,
       po.pos_name as p_pos_name,
       po.pos_city as p_pos_city,
       po.dnp_region as p_dnp_region,
       po.x_dnp_name as p_x_dnp_name,
       fc.form_client_id as fc_form_client_id,---
       fc.form_client_date as fc_form_client_date,
       fc.surname as fc_surname,
       fc.first_name as fc_first_name,
       fc.patronymic as fc_patronymic,
       fc.is_resident as fc_is_resident,
       fc.education as fc_education,
       fc.marital_status as fc_marital_status,
       fc.children as fc_children,
       fc.social_status_spouse as fc_social_status_spouse,
       fc.org_activity as fc_org_activity,
       fc.org_sector as fc_org_sector,
       fc.job_position_type as fc_job_position_type,
       fc.is_bank_account_exists as fc_is_bank_account_exists,
       fc.is_auto_exists as fc_is_auto_exists,
       fc.real_estate_relation as fc_real_estate_relation,
       fc.age_full_years as fc_age_full_years,
       fc.c_address_equal as fc_c_address_equal,
       --g.bin as og_bin,--в V_FOLDER_ALL_RFO данных больше
       g.org_name as og_org_name,
       g.pmt_date_min as og_pmt_date_min,
       g.pmt_date_max as og_pmt_date_max,
       g.gcvp_rep_date_min as og_gcvp_rep_date_min,
       g.gcvp_rep_date_max as og_gcvp_rep_date_max,
       g.clients_all as og_clients_all,
       g.clients_del_above_90d as og_clients_del_above_90d
from V_CONTRACT_CAL c
left join V_FOLDER_ALL_RFO f on f.folder_id = c.folder_id_first
left join V_FOLDER_ALL f1 on f1.folder_id = f.folder_id
left join V_CLIENT_CAL cl on cl.client_id = c.client_id
left join V_FORM_CLIENT_ALL_RFO fc on fc.form_client_id =  f.form_client_id
left join V_PKB_REPORT p on p.folder_id = f.folder_id
left join V_POS po on po.pos_code = f.pos_code
left join V_ORG_GCVP g on g.bin = f.org_bin
;
grant select on U1.V_CONTRACT_FOLDER_TEST to LOADDB;
grant select on U1.V_CONTRACT_FOLDER_TEST to LOADER;


