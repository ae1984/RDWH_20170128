create or replace force view u1.v_rej_score_lkn_bw_9 as
select xx."RFO_CONTRACT_ID",xx."FOLDER_ID",xx."CONTRACT_NUMBER",xx."CONTRACT_ID",xx."AGE_FULL_YEAR_GENDER_B",xx."AMOUNT_RISE_PERC_B",xx."CLI_AGE_BASING_ON_CON_MON_FL_B",xx."CLI_AGE_BASED_ON_FLD_MON_FL_B",xx."CONTRACT_AMOUNT_B",xx."CONTRACT_TERM_MONTHS_B",xx."PAID_SAL_COUNT_ALL_CON_B",xx."PKB_CLOSED_CONTRACTS_B",xx."PMT_RISE_PERC_B",xx."REAL_ESTATE_RELATION_B",xx."ST_CON_DEL_DAYS_MAX_BY_CLI_B",xx."ST_NUM_OF_CON_BY_CLI_PR_REP_B",xx."ST_PMT_MAX_BY_CLI_B",xx."WORK_EXPR_LAST_PLACE_MON_FL_B",
       xx.age_full_year_gender_b+
       xx.amount_rise_perc_b+
       xx.cli_age_basing_on_con_mon_fl_b+
       xx.cli_age_based_on_fld_mon_fl_b+
       xx.contract_amount_b+
       xx.contract_term_months_b+
       xx.paid_sal_count_all_con_b+
       xx.pkb_closed_contracts_b+
       xx.pmt_rise_perc_b+
       xx.real_estate_relation_b+
       xx.st_con_del_days_max_by_cli_b+
       xx.st_num_of_con_by_cli_pr_rep_b+
       xx.st_pmt_max_by_cli_b+
       xx.work_expr_last_place_mon_fl_b

       as score_bal
from (
    select
      t.rfo_contract_id,
      t.folder_id,
      t.contract_number,
      t.contract_id,

      case
            when age_full_year_gender < -38 then 16
            when age_full_year_gender >= -38 and age_full_year_gender < -33 then 8
            when age_full_year_gender >= -33 and age_full_year_gender < -27 then 6
            when age_full_year_gender >= -27 and age_full_year_gender < -21 then 0
            when age_full_year_gender >= -21 and age_full_year_gender < 23 then -6
            when age_full_year_gender >= 23 and age_full_year_gender < 27 then 3
            when age_full_year_gender >= 27 and age_full_year_gender < 31 then 8
            when age_full_year_gender >= 31 and age_full_year_gender < 42 then 13
            when age_full_year_gender >= 42 and age_full_year_gender < 54 then 19
            when age_full_year_gender >= 54 then 23
            else 0 end age_full_year_gender_b,

        case
            when amount_rise_perc < 101 then 8
            when amount_rise_perc >= 101 and amount_rise_perc < 126 then 9
            when amount_rise_perc >= 126 and amount_rise_perc < 200 then 10
            when amount_rise_perc >= 200 then 10
            else 8 end amount_rise_perc_b,

       case
            when cli_age_basing_on_con_mon_fl < 5 then -16
            when cli_age_basing_on_con_mon_fl >= 5 and cli_age_basing_on_con_mon_fl < 7 then -8
            when cli_age_basing_on_con_mon_fl >= 7 and cli_age_basing_on_con_mon_fl < 9 then -2
            when cli_age_basing_on_con_mon_fl >= 9 and cli_age_basing_on_con_mon_fl < 13 then 2
            when cli_age_basing_on_con_mon_fl >= 13 and cli_age_basing_on_con_mon_fl < 21 then 8
            when cli_age_basing_on_con_mon_fl >= 21 and cli_age_basing_on_con_mon_fl < 28 then 15
            when cli_age_basing_on_con_mon_fl >= 28 and cli_age_basing_on_con_mon_fl < 34 then 18
            when cli_age_basing_on_con_mon_fl >= 34 and cli_age_basing_on_con_mon_fl < 47 then 23
            when cli_age_basing_on_con_mon_fl >= 47 and cli_age_basing_on_con_mon_fl < 65 then 31
            when cli_age_basing_on_con_mon_fl >=  65 then 35
            else 23 end cli_age_basing_on_con_mon_fl_b,

        case
            when cli_age_based_on_fld_mon_fl < 4 then 12
            when cli_age_based_on_fld_mon_fl >= 4 and cli_age_based_on_fld_mon_fl < 7 then 11
            when cli_age_based_on_fld_mon_fl >= 7 and cli_age_based_on_fld_mon_fl < 10 then 10
            when cli_age_based_on_fld_mon_fl >= 10 and cli_age_based_on_fld_mon_fl < 21 then 9
            when cli_age_based_on_fld_mon_fl >= 21 and cli_age_based_on_fld_mon_fl < 31 then 8
            when cli_age_based_on_fld_mon_fl >= 31 and cli_age_based_on_fld_mon_fl < 58 then 7
            when cli_age_based_on_fld_mon_fl >=  58 then 6
            else 6 end cli_age_based_on_fld_mon_fl_b,

        case
            when contract_amount < 102500 then 11
            when contract_amount >= 102500 and contract_amount < 161250 then 10
            when contract_amount >= 161250 and contract_amount < 210000 then 8
            when contract_amount >=  210000 then 6
            else 11 end contract_amount_b,

        case
            when contract_term_months < 6 then 22
            when contract_term_months >= 6 and contract_term_months < 9 then 20
            when contract_term_months >= 9 and contract_term_months < 12 then 15
            when contract_term_months >= 12 and contract_term_months < 15 then 10
            when contract_term_months >= 15 and contract_term_months < 24 then 2
            when contract_term_months >=  24 then -5
            else 10 end contract_term_months_b,

        case
            when paid_sal_count_all_con < 2 then 17
            when paid_sal_count_all_con >= 2 and paid_sal_count_all_con < 3 then 13
            when paid_sal_count_all_con >= 3 and paid_sal_count_all_con < 4 then 9
            when paid_sal_count_all_con >= 4 and paid_sal_count_all_con < 6 then 6
            when paid_sal_count_all_con >= 6 and paid_sal_count_all_con < 7 then 1
            when paid_sal_count_all_con >= 7 and paid_sal_count_all_con < 10 then 0
            when paid_sal_count_all_con >=  10 then -6
            else 17 end paid_sal_count_all_con_b,

        case when pkb_closed_contracts < 1 then 8
             when pkb_closed_contracts >= 1 and pkb_closed_contracts< 2 then 8
             when pkb_closed_contracts >= 2 and pkb_closed_contracts< 6 then 9
             when pkb_closed_contracts >= 6 then 10
             else 8 end pkb_closed_contracts_b,

        case when pmt_rise_perc < 25 then 9
             when pmt_rise_perc >= 25 and pmt_rise_perc< 69 then 9
             when pmt_rise_perc >= 69 and pmt_rise_perc< 131 then 9
             when pmt_rise_perc >= 131 then 8
             else 9 end pmt_rise_perc_b,

        case when real_estate_relation in ('АРЕНДОВАННОЕ', 'ЖИЛИЩЕ РОДИТЕЛЕЙ') then 7
             when real_estate_relation in ('ВЕДОМСТВЕННОЕ', 'ДРУГОЕ', 'КУПЛЕННОЕ В КРЕДИТ') then 8
             when real_estate_relation in ('НЕПРИВАТИЗИРОВАННОЕ', 'СОБСТВЕННОЕ') then 10
             else 10 end real_estate_relation_b,

        case when start_con_del_days_max_by_cli < 2 then 19
             when start_con_del_days_max_by_cli >= 2 and start_con_del_days_max_by_cli< 8 then -3
             when start_con_del_days_max_by_cli >= 8 and start_con_del_days_max_by_cli< 17 then -14
             when start_con_del_days_max_by_cli >= 17 and start_con_del_days_max_by_cli< 30 then -20
             when start_con_del_days_max_by_cli >= 30 then -52
             else 19 end st_con_del_days_max_by_cli_b,

      case when start_num_of_con_by_cli_pr_rep < 1 then 11
           when start_num_of_con_by_cli_pr_rep >= 1 and start_num_of_con_by_cli_pr_rep< 2 then 8
           when start_num_of_con_by_cli_pr_rep >= 2 then 7
           else 11 end st_num_of_con_by_cli_pr_rep_b,

      case when start_pmt_max_by_cli < 4179 then 10
           when start_pmt_max_by_cli >= 4179 and start_pmt_max_by_cli< 11646 then 7
           when start_pmt_max_by_cli >= 11646 and start_pmt_max_by_cli< 31354 then 8
           when start_pmt_max_by_cli >= 31354 then 9
           else 10 end st_pmt_max_by_cli_b,

      case when work_expr_last_place_mon_floor < 16 then 2
           when work_expr_last_place_mon_floor >= 16 and work_expr_last_place_mon_floor< 24 then 4
           when work_expr_last_place_mon_floor >= 24 and work_expr_last_place_mon_floor< 46 then 7
           when work_expr_last_place_mon_floor >= 46 and work_expr_last_place_mon_floor< 52 then 9
           when work_expr_last_place_mon_floor >= 52 and work_expr_last_place_mon_floor< 88 then 11
           when work_expr_last_place_mon_floor >= 88 and work_expr_last_place_mon_floor< 124 then 15
           when work_expr_last_place_mon_floor >= 124 then 20
           else 20 end work_expr_last_place_mon_fl_b

    from (select tt.*,
                 case when tt.sex = 'М' then tt.age_full_years*-1 else tt.age_full_years end age_full_year_gender
          from m_folder_con_miner tt) t
) xx;
grant select on U1.V_REJ_SCORE_LKN_BW_9 to LOADDB;
grant select on U1.V_REJ_SCORE_LKN_BW_9 to LOADER;


