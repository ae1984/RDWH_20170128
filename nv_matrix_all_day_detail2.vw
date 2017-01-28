create or replace force view u1.nv_matrix_all_day_detail2 as
select
   rr."YYYY",rr."QUARTER",rr."TEXT_YYYY_MM",rr."WEEK_TEXT",rr."TEXT_YYYY_MM_DD_WEEK_DAY",rr."CON_YYYY",rr."CON_QUARTER",rr."CON_TEXT_YYYY_MM",rr."CON_WEEK_TEXT",rr."CON_TEXT_YYYY_MM_DD_WEEK_DAY",rr."RFO_CON_OR_CLAIM_ID",rr."RFO_CON_CLAIM_TYPE",rr."FOLDER_CON_DATE",rr."FOLDER_CON_DATE_TIME",rr."FOLDER_ID",rr."CONTRACT_NUMBER",rr."CONTRACT_AMOUNT",rr."PROCESS_CODE",rr."PROCESS_NAME",rr."RFO_CLIENT_ID",rr."IIN",rr."RNN",rr."IS_CLIENT_NEW_BY_CON",rr."OVERDUE_DAYS_MAX",rr."COUNT_CLOSED_CREDIT",rr."COUNT_REFIN_CONTRACT",rr."COUNT_PAYMENT",rr."COUNT_PAYMENT_LAST12M",rr."PRODUCT",rr."PRODUCT_TYPE",rr."FOLDER_DATE_CREATE_MI",rr."CANCEL_PRESCORING",rr."CANCEL_MIDDLE_OFFICE",rr."CANCEL_CONTROLLER",rr."CANCEL_CLIENT",rr."CANCEL_MANAGER",rr."CANCEL_CPR_AA",rr."CANCEL_VERIFICATOR",rr."CANCEL_UNDEFINED",rr."IS_AA_APPROVED",rr."IS_AA_REJECT",rr."RFO_CON_OR_CLAIM_NOT_REJ",rr."IS_CREDIT_ISSUED_RFO",rr."IS_CREDIT_ISSUED_RBO",rr."RBO_CONTRACT_ID",rr."RBO_CLIENT_ID",rr."CONTRACT_AMOUNT_RBO",rr."IS_ON_BALANCE",rr."SALES",rr."DEL_DEBT_7D",rr."DEL_DEBT_30D",rr."DEL_DEBT_60D",rr."DEL_DEBT_90D",rr."DEL_DEBT_30D_EVER",rr."DEL_DEBT_60D_EVER",rr."DEL_DEBT_90D_EVER",rr."PMT_1_0D_DEL_DEBT",rr."PMT_1_0D_SALES",rr."PMT_1_7D_DEL_DEBT",rr."PMT_1_7D_SALES",rr."PMT_2_7D_DEL_DEBT",rr."PMT_2_7D_SALES",rr."PMT_3_7D_DEL_DEBT",rr."PMT_3_7D_SALES",rr."PMT_4_7D_DEL_DEBT",rr."PMT_4_7D_SALES",rr."PMT_5_7D_DEL_DEBT",rr."PMT_5_7D_SALES",rr."PMT_6_7D_DEL_DEBT",rr."PMT_6_7D_SALES",rr."PMT_1_30D_DEL_DEBT",rr."PMT_1_30D_SALES",rr."PMT_1_60D_DEL_DEBT",rr."PMT_1_60D_SALES",rr."COUNT_PAYMENT_MAX",rr."COUNT_PAYMENT_LAST12M_MAX"
   ,case
      when     rr.overdue_days_max <=15
           and rr.count_closed_credit >=2
           and rr.count_refin_contract =0
           and rr.count_payment_max >=12
           and rr.count_payment_last12m_max >=12
      then 1 else 0
    end as is_categ_a
   ,case
      when     rr.overdue_days_max <31
           and rr.count_closed_credit >=1
           and rr.count_refin_contract =0
           and rr.count_payment_max >=6
      then 1 else 0
    end as is_categ_b
   ,case
      when     rr.overdue_days_max <=15
           and rr.count_closed_credit >=2
           and rr.count_refin_contract =0
           and rr.count_payment_max >=12
           and rr.count_payment_last12m_max >=12
      then 'CAT A'
      when     rr.overdue_days_max <31
           and rr.count_closed_credit >=1
           and rr.count_refin_contract =0
           and rr.count_payment_max >=6
      then 'CAT B'
      when rr.is_client_new_by_con = 'NOT NEW CLIENT' then 'CAT C'
      when rr.is_client_new_by_con = 'NEW CLIENT' then 'CAT D'
    end as client_category

from (
    select
       r.*
       ,max(r.count_payment) over (partition by r.rfo_client_id) as count_payment_max
       ,max(r.count_payment_last12m) over (partition by r.rfo_client_id) as count_payment_last12m_max
    from(
        select /*- no_parallel*/ /*+ parallel(144)*/
           td.yyyy
          ,td.quarter
          ,td.text_yyyy_mm
          ,td.week_text
          ,td.text_yyyy_mm_dd_week_day
          ,tdc.yyyy as con_yyyy
          ,tdc.quarter as con_quarter
          ,tdc.text_yyyy_mm as con_text_yyyy_mm
          ,tdc.week_text as con_week_text
          ,tdc.text_yyyy_mm_dd_week_day as con_text_yyyy_mm_dd_week_day
          ,f.rfo_con_or_claim_id
          ,f.rfo_con_claim_type
          ,f.folder_con_date
          ,f.folder_con_date_time
          ,f.folder_id
          ,f.contract_number
          ,f.contract_amount
          ,f.process_code
          ,f.process_name
          ,f.rfo_client_id
          ,f.iin
          ,f.rnn
          ,case when (select count(1) from u1.T_RBO_PORT prt where prt.rbo_client_id = b.client_id and prt.rep_date<=f.folder_date_create_mi)>0 then 'NOT NEW CLIENT' else 'NEW CLIENT' end as IS_CLIENT_NEW_BY_CON
          ,(select max(prt.del_days_cli_max) from u1.T_RBO_PORT prt where prt.rbo_client_id = b.rbo_client_id and prt.rep_date<=f.folder_date_create_mi) as overdue_days_max
          ,(select count(distinct bs.folder_id_first) from u1.M_RBO_CONTRACT_BAS bs where bs.rbo_client_id = b.rbo_client_id and bs.date_fact_end<=f.folder_date_create_mi) as count_closed_credit
          ,(select count(cdel.is_refin_contract) from M_RBO_CONTRACT_DEL cdel where cdel.rbo_client_id = b.rbo_client_id and cdel.start_date<=f.folder_date_create_mi) as count_refin_contract
          ,(select count(1) from /*M_RBO_PLAN_OPER_CREDIT*/ T_CONTRACT_INCOME_PRE cpl where cpl.rbo_contract_id = b.rbo_contract_id and cpl.date_oper /*plan_date*/<=f.folder_date_create_mi) as count_payment
          ,(select count(1) from /*M_RBO_PLAN_OPER_CREDIT*/ T_CONTRACT_INCOME_PRE cpl where cpl.rbo_contract_id = b.rbo_contract_id and cpl.date_oper /*plan_date*/ between add_months(f.folder_date_create_mi,-12) and f.folder_date_create_mi) as count_payment_last12m
          ,f.product
          ,f.product_type
          --,f.cancel_type_point
          --,f.is_point_active
          --,f.is_credit_issued
          --,f.delivery_type
          --,f.bk_folder_id
          --,f.is_bk_aa_approved
          ,f.folder_date_create_mi
          --,f.folder_id_first
          ,f.cancel_prescoring
          ,f.cancel_middle_office
          ,f.cancel_controller
          ,f.cancel_client
          ,f.cancel_manager
          ,f.cancel_cpr_aa
          ,f.cancel_verificator
          ,f.cancel_undefined
          ,f.is_aa_approved
          ,f.is_aa_reject
          ,case when nvl(f.cancel_prescoring,0)
                    +nvl(f.cancel_middle_office,0)
                    +nvl(f.cancel_controller,0)
                    +nvl(f.cancel_client,0)
                    +nvl(f.cancel_manager,0)
                    +nvl(f.cancel_cpr_aa,0)
                    +nvl(f.cancel_verificator,0)
                    +nvl(f.cancel_undefined,0) = 0
                then f.rfo_con_or_claim_id
           end as rfo_con_or_claim_not_rej
          ,case when f.is_credit_issued = 0 then 'CREDIT NOT ISSUED' else 'CREDIT ISSUED' end as is_credit_issued_rfo
          ,case when b.rbo_contract_id is null then 'CREDIT NOT ISSUED' else 'CREDIT ISSUED' end as is_credit_issued_rbo
          ,b.rbo_contract_id
          ,b.rbo_client_id
          ,b.contract_amount as contract_amount_rbo
          ,d.is_on_balance
          ,d.max_debt_used_x as sales

          ,case when d.del_days_x > 7  then d.total_debt_x end     as del_debt_7d
          ,case when d.del_days_x > 30 then d.total_debt_x end     as del_debt_30d
          ,case when d.del_days_x > 60 then d.total_debt_x end     as del_debt_60d
          ,case when d.del_days_x > 90 then d.total_debt_x end     as del_debt_90d
          ,case when d.del_days_max_x > 30 then d.total_debt_x end as del_debt_30d_ever
          ,case when d.del_days_max_x > 60 then d.total_debt_x end as del_debt_60d_ever
          ,case when d.del_days_max_x > 90 then d.total_debt_x end as del_debt_90d_ever

          ,d.total_debt_x_pmt_1_0    as pmt_1_0d_del_debt
          ,d.max_debt_used_x_pmt_1_0 as pmt_1_0d_sales
          ,d.total_debt_x_pmt_1_7    as pmt_1_7d_del_debt
          ,d.max_debt_used_x_pmt_1_7 as pmt_1_7d_sales
          ,d.total_debt_x_pmt_2_7    as pmt_2_7d_del_debt
          ,d.max_debt_used_x_pmt_2_7 as pmt_2_7d_sales
          ,d.total_debt_x_pmt_3_7    as pmt_3_7d_del_debt
          ,d.max_debt_used_x_pmt_3_7 as pmt_3_7d_sales
          ,d.total_debt_x_pmt_4_7    as pmt_4_7d_del_debt
          ,d.max_debt_used_x_pmt_4_7 as pmt_4_7d_sales
          ,d.total_debt_x_pmt_5_7    as pmt_5_7d_del_debt
          ,d.max_debt_used_x_pmt_5_7 as pmt_5_7d_sales
          ,d.total_debt_x_pmt_6_7    as pmt_6_7d_del_debt
          ,d.max_debt_used_x_pmt_6_7 as pmt_6_7d_sales

          ,d.total_debt_x_pmt_1_30    as pmt_1_30d_del_debt
          ,d.max_debt_used_x_pmt_1_30 as pmt_1_30d_sales
          ,d.total_debt_x_pmt_1_60    as pmt_1_60d_del_debt
          ,d.max_debt_used_x_pmt_1_60 as pmt_1_60d_sales
        from u1.NV_RFO_APPLICATION_BASWRAP f
        join u1.V_TIME_DAYS td on td.yyyy_mm_dd = f.folder_con_date
        left join u1.M_RBO_CONTRACT_BAS b on b.folder_id_first = f.folder_id and b.contract_number = f.contract_number
        left join u1.V_TIME_DAYS tdc on tdc.yyyy_mm_dd = b.start_date
        left join u1.M_RBO_CONTRACT_DEL d on d.rbo_contract_id = b.rbo_contract_id
    ) r
) rr
;
grant select on U1.NV_MATRIX_ALL_DAY_DETAIL2 to LOADDB;


