create or replace procedure u1.ETLT_V_CONTRACT_CAL_BUF is
begin
  execute immediate ('truncate table V_CONTRACT_CAL_BUF');

insert /*+append parallel(30)*/ into V_CONTRACT_CAL_BUF
select /*+parallel(20)*/ distinct x.contract_number,
                to_number(decode(substr(replace(x.contract_number, '-', ''),
                                        1,
                                        1),
                                 'R',
                                 2,
                                 1) ||
                          lpad(substr(trim('R' from x.contract_number),
                                      1,
                                      instr(trim('R' from x.contract_number),
                                            '-') - 1),
                               10,
                               0) ||
                          lpad(substr(trim('R' from x.contract_number),
                                      instr(trim('R' from x.contract_number),
                                            '-') + 1,
                                      3),
                               4,
                               0) ||
                          decode(substr(trim('R' from x.contract_number),
                                        instr(trim('R' from
                                                   x.contract_number),
                                              '-') + 4,
                                        instr(trim('R' from
                                                   x.contract_number),
                                              '-') + 8),
                                 null,
                                 0,
                                 'e',
                                 1,
                                 2) || lpad((decode(substr(trim('R' from
                                                                x.contract_number),
                                                           instr(trim('R' from
                                                                      x.contract_number),
                                                                 '-') + 9,
                                                           instr(trim('R' from
                                                                      x.contract_number),
                                                                 '-') + 11),
                                                    null,
                                                    0,
                                                    substr(trim('R' from
                                                                x.contract_number),
                                                           instr(trim('R' from
                                                                      x.contract_number),
                                                                 '-') + 9,
                                                           instr(trim('R' from
                                                                      x.contract_number),
                                                                 '-') + 11))),
                                            4,
                                            0)) as contract_id,
                x.client_id,
                coalesce(rrc.product_last_old, x.product_last) as product, -- новый продукт, с учетом реф рестр от Жомарта
                x.product_first,
                x.product_refin_first,
                x.product_program_first,
                x.start_date_first,
                x.end_date_first,
                x.contract_amount_first,
                x.expert_name_first,
                x.pos_code_first,
                x.branch_name_first,
                x.product_last,
                x.product_refin_last,
                x.product_program_last,
                dw.prod_type as cr_prog_name_rbo_last, -- текущий продукт с судного потрфеля РБО
                coalesce(x.product_start_last, x.product_first) as product_start_last, -- первый продукт с yy_mm_start_last
                -- coalesce для обработки 843 договоров у которых start_date is null
                x.start_date_last,
                x.end_date_last,
                x.contract_amount_last,
                x.yy_mm_report_min,
                x.yy_mm_report_max,
                x.max_debt_used,
                x.delinq_days_max,
                x.delinq_days_last,
                x.contract_amount_max,
                x.is_refin_restruct_first,
                x.is_refin_restruct_last,
                x.is_refin_restruct_ever,
                x.first_pmt_days_first,
                x.first_pmt_days_last,
                x.first_pmt_days_refin_first,
                x.first_pmt_days_refin_last,
                x.total_debt_first,
                x.total_debt_last,
                x.is_card,
                x.contract_amount_categ_first,
                x.contract_amount_categ_last,
                x.delinq_type_last,
                x.client_rnn_first,
                x.client_rnn_last,
                x.client_iin_first,
                x.client_iin_last,
                x.yy_mm_start_first,
                x.yy_mm_start_first_num,
                x.start_year_first,
                x.contract_term_days_first,
                x.contract_term_months_first,
                x.yy_mm_start_last,
                x.yy_mm_start_last_num,
                x.start_year_last,
                x.contract_term_days_last,
                x.contract_term_months_last,
                x.fact_pmts,
                x.planned_pmts,
                x.pmt,
                x.start_con_amount_max_by_cli,
                x.start_con_del_days_max_by_cli,
                x.start_tot_debt_all_con_by_cli,
                x.start_num_of_con_by_cli_pr_rep,
                x.start_num_of_con_by_cli,
                x.start_total_fact_pmts_by_cli,
                x.start_total_plan_pmts_by_cli,
                x.start_total_undone_pmts_by_cli,
                x.start_pmt_max_by_cli,
                x.start_pmt_pr_rep_by_cli,
                x.provision_max,
                x.provision_last_rep,

                x.contract_amount_last_rep,
                x.total_debt_last_rep,
                x.delinq_days_last_rep,
                x.folder_id_first,
                x.start_num_of_fol_all,
                x.start_num_of_fol_1_month,
                x.prev_con_num_by_start_date,
                x.next_con_num_by_start_date,
                x.prev_con_num_by_yymm_last,
                x.next_con_num_by_yymm_last,
                x.prev_con_st_date_by_start_date,
                x.prev_con_st_date_by_yymm_last,
                x.prev_con_prod_first_by_std,
                x.prev_con_prod_first_by_yml,
                x.prev_con_tot_debt_first_by_std,
                x.prev_con_tot_debt_first_by_yml,
                x.yy_mm_start_debt,
                x.pkb_pmt_active_all_sum,
                x.pkb_pmt_active_good_sum,
                x.pkb_total_debt,
                x.first_pmt_delinq,
                x.four_pmts_delinq_max,
                af.prior_credit_fld_rejected_cnt,

                case
                  when x.rfo_client_id_x is null then
                   max(t.rfo_client_id) over(partition by t.contract_number)
                  else
                   x.rfo_client_id_x
                end as rfo_client_id,

                case
                  when x.is_refin_restruct_last = 0 then
                   x.yy_mm_start_last
                  else
                   to_char((case
                             when x.start_date_first >= (case
                                    when x.prev_con_st_date_by_yymm_last <=
                                         x.prev_con_st_date_by_start_date then
                                     x.prev_con_st_date_by_yymm_last
                                    when x.prev_con_st_date_by_yymm_last >
                                         x.prev_con_st_date_by_start_date then
                                     x.prev_con_st_date_by_start_date
                                  end) then
                              (case
                                when x.prev_con_st_date_by_yymm_last <=
                                     x.prev_con_st_date_by_start_date then
                                 x.prev_con_st_date_by_yymm_last
                                when x.prev_con_st_date_by_yymm_last >
                                     x.prev_con_st_date_by_start_date then
                                 x.prev_con_st_date_by_start_date
                              end)
                             else
                              x.start_date_first
                           end),
                           'yyyy - mm')
                end as yms,
                case
                  when x.is_refin_restruct_first = 1 or
                       x.is_refin_restruct_last = 1 or
                       x.is_refin_restruct_ever = 1 then
                   da.yms_res_first
                end as yms_res_first,
                case
                  when x.is_refin_restruct_first = 1 or
                       x.is_refin_restruct_last = 1 or
                       x.is_refin_restruct_ever = 1 then
                   da.yms_res_last
                end as yms_res_last,

                case
                  when x.max_debt_used > 0 then
                   case
                     when x.delinq_days_last_rep > 0 and
                          x.delinq_days_last_rep < 8 then
                      x.total_debt_last_rep * 0.45
                     when x.delinq_days_last_rep > 7 then
                      x.total_debt_last_rep
                     else
                      0
                   end / x.max_debt_used * 100
                  else
                   0
                end as delinq_rate,
                case
                  when dw.rate_value is not null then
                   dw.rate_value
                  else
                   r.rate_value_default
                end as nominal_rate,
                dw.pmt as pmt_nom_rate
  from V_CONTRACT_CAL_PRE x

  left join V_CONTRACT_ALL_RFO t
    on x.contract_number = t.contract_number
   and t.contract_number is not null
  left join (select contract_no,
                    min(yy_mm_report) as yms_res_first,
                    max(yy_mm_report) as yms_res_last
               from (select d.contract_no,
                            d.yy_mm_report,
                            p.is_refin_restruct,
                            lag(p.is_refin_restruct, 1, 0) over(partition by d.contract_no order by d.yy_mm_report) as is_refin_restruct_prev
                       from V_DATA_ALL d
                       join REF_PRODUCTS p
                         on p.product_program = d.product_programm)
              where is_refin_restruct_prev = 0
                and is_refin_restruct = 1
              group by contract_no) da
    on da.contract_no = x.contract_number
  left join V_DWH_PORTFOLIO_CURRENT dw
    on dw.deal_number = x.contract_number
  left join V_TMP_CON_PRIOR_APPROVED_FLD af
    on af.contract_number = x.contract_number
  left join (select t.prod_name,
                    max(t.rate_value) keep(dense_rank last order by t.x_total_debt) as rate_value_default
               from (select dw.prod_name,
                            dw.rate_value,
                            sum(dw.x_total_debt) as x_total_debt
                       from V_DWH_PORTFOLIO_CURRENT dw
                      where dw.rate_value is not null
                      group by dw.prod_name, dw.rate_value) t
              group by t.prod_name) r
    on r.prod_name = dw.prod_name
--left join M_REF_RESTR_CONS_ZHOMART_AGGR rrc on rrc.contract_number = x.contract_number
  left join M_REF_RESTR_CONS_AGR_X rrc
    on rrc.contract_number_new = x.contract_number;
 commit;
end ETLT_V_CONTRACT_CAL_BUF;
/

