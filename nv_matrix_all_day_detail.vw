create or replace force view u1.nv_matrix_all_day_detail as
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
;
grant select on U1.NV_MATRIX_ALL_DAY_DETAIL to LOADDB;


