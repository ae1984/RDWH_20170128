create or replace force view u1.v_portfolio_old as
select /*+ first_rows */
       r1.id,
       r2.report_year,
       r1.yy_mm_report,
       r1.contract_number,
       r1.client_id,
       r2.folder_id_first,
       r2.total_debt,
       r1.delinq_days,
       r1.delinq_days_old,
       r1.report_month,
       r1.num_months,
       r1.is_card,
       r1.status,
       r1.yy_mm_start,
       r1.start_year,
       r1.delinq,
       r1.del_long,
       r1.del_long_old,
       r1.del_long_old_5,
       r1.contract_amount_categ,
       r1.planned_pmt_month,
       r1.delinq_mm,
       r1.delinq_type,
       r1.fact_pmts,
       r1.provision,
       r2.report_month_all_contracts,
       r2.report_month_all_contracts_n,
       r2.new_total_debt,
       r2.max_debt_used,
       r2.delinq_amount,
       p.x_dnp_name,
       p.pos_code,
       c.expert_name_first,
       p.pos_name,
       c.product_refin_last,
       c.first_pmt_days_first
from v_report_cal_1 r1
     join v_report_cal_2 r2 on r2.id = r1.id
     left join v_contract_cal c on r1.contract_number = c.contract_number
     left join v_folder_all_rfo f on r2.folder_id_first = f.folder_id
     left join v_pos p on p.pos_code = f.pos_code;
grant select on U1.V_PORTFOLIO_OLD to LOADDB;
grant select on U1.V_PORTFOLIO_OLD to LOADER;


